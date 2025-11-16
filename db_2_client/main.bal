import db_2_client.dbOps;
import db_2_client.vendor;

import ballerina/http;
import ballerina/log;

configurable string clientTokenHost = ?;
configurable string clientTokenURL = ?;
configurable string clientTokenResource = ?;
configurable string clientUserName = ?;
configurable string clientUserPwd = ?;
configurable string clientHost = ?;
configurable string clientURL = ?;
configurable string clientClientId = ?;
configurable string clientClientSecret = ?;
configurable string clientViewName = ?;

configurable string urlDss = ?;
configurable string dssToken = ?;

decimal timeout = 3600;
http:HttpVersion httpVersion = http:HTTP_1_1;

http:BearerTokenConfig dssBearerConfig = {
    token: dssToken
};
http:Client|error dssClient = check new (urlDss, auth = dssBearerConfig, timeout = timeout, httpVersion = httpVersion);

public function main() returns error? {
    log:printInfo("db_2_client :: START");

    string rResp = "";

    dbOps:Root|error clientVals = check dbOps:getRecrContacts(check dssClient, examId = "", rResp = rResp);
    //log:printInfo(`main :: clientVals : ${check clientVals}`);
    if clientVals is error {
        log:printError("main :: Contact details fetch from DB Failed: ", clientVals);
        return error("main :: Contact details fetch from DB Failed", clientVals);
    }

    string? firstname_fr = clientVals.records.rec[0].firstname;
    log:printInfo(`main :: firstname_fr : ${firstname_fr}`);

    dbOps:RecItem[] recs = clientVals.records.rec;

    // Client Token fetch
    string clientAccessToken = check vendor:getClientToken(clientTokenURL, clientUserName, clientUserPwd, clientTokenHost,
            clientTokenResource, clientClientId, clientClientSecret);
    //fo(string `main :: clientAccessToken: ${clientAccessToken}`);

    // Setting Client Resource Client
    http:BearerTokenConfig clientResourceBearerConfig = {
        token: clientAccessToken
    };
    http:Client|error clientResourceClient = new (clientURL, auth = clientResourceBearerConfig, timeout = timeout, httpVersion = httpVersion);

    int i = 1;
    foreach dbOps:RecItem rec in recs {
        //log:printInfo(`main [${i}] - rec = ${rec.toJsonString()}`);
        rResp = "BTR-begin";

        string mathDateFormatted = rec?.math_date_formatted ?: "";
        string mathResultFormatted = rec?.math_result_formatted ?: "";

        string englDateFormatted = rec?.engl_date_formatted ?: "";
        string englResultFormatted = rec?.engl_result_formatted ?: "";

        string digiDateFormatted = rec?.digi_date_formatted ?: "";
        string digiResultFormatted = rec?.digi_result_formatted ?: "";

        string contactid = rec?.contactid ?: "";
        string examId = rec?.recexamid ?: "bksnid-n/a";

        log:printInfo(`main : begin ::: ${examId}`);

        if (mathDateFormatted == "" && englDateFormatted == "") { // currently no digital results (digiDateFormatted == "")
            log:printInfo(`main [${i}] - ${examId} :: No assessments to update (to Client)`);
            rResp = string `${rResp} | No assessments to update (to Client)`;
        } else {
            json|error clientUpdateResp = check vendor:updateClient(clientClient = check clientResourceClient, contactId = contactid,
                    mathDateFormatted = mathDateFormatted, mathResultFormatted = mathResultFormatted,
                    englDateFormatted = englDateFormatted, englResultFormatted = englResultFormatted,
                    digiDateFormatted = digiDateFormatted, digiResultFormatted = digiResultFormatted);

            if clientUpdateResp is error {
                log:printInfo(`main [${i}] - ${examId} :: ${clientUpdateResp.toString()}`);
                rResp = string `${rResp} | Failed to update Client-Contact :: ${clientUpdateResp.toString()}`;
                //return error(string `main [${i}] - ${examId} :: Failed to update Client Contacts :: ${clientUpdateResp.toString()}`); 
            } else {
                //log:printInfo(`main [${i}] - ${examId} :: clientUpdateResp : ${clientUpdateResp}`);
                int returnedBksbId = check clientUpdateResp.resp.recexamid;
                rResp = string `${rResp} | Client-Contact updated - Returned BksbId : ${returnedBksbId}`;
            }
        }

        rResp = string `${rResp} | BTR-end`;

        json|error saveResponse = check dbOps:updateResults(check dssClient, resultType = 7, hitBksbid = examId, 
                             dateLatest = "", resultLatest = "", dateHighest = "", resultHighest = "",
                             dateFormatted = "", resultFormatted = "",
                             rResp = rResp);

        if saveResponse is error {
            log:printInfo(`main [${i}] - ${examId} :: Failed to update Client-Contact response to DB : ${saveResponse.toString()}`);
            rResp = string `${rResp} | ${saveResponse.toString()}`;                
            return error(string `main [${i}] - ${examId} :: Failed to update Client-Contact response to DB : ${saveResponse.toString()}`); 
        } 

        log:printInfo(`main : end ::: ${examId}`);

        i += 1;

    }

    log:printInfo("db_2_client :: END");
}
