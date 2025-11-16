import fetch_process.vendor;
import fetch_process.dbOps;

import ballerina/http;
//import ballerina/io;
import ballerina/lang.value;
import ballerina/log;

configurable string urlDss = ?;
configurable string dssToken = ?;
configurable string vendorEp = ?;
configurable string vendorUid = ?;
configurable string vendorPwd = ?;
configurable string vendorHost = ?;

decimal timeout = 3600;
http:HttpVersion httpVersion = http:HTTP_1_1;

http:BearerTokenConfig dssBearerConfig = {
    token: dssToken
};
http:Client|error dssClient = check new (urlDss, auth = dssBearerConfig, timeout = timeout, httpVersion = httpVersion);

http:Client|error vendorClient = check new (url = vendorEp,
    auth = {
        username: vendorUid,
        password: vendorPwd
    },
    timeout = timeout,
    httpVersion = httpVersion
);

public function main() returns error? {
    log:printInfo("fetch_process :: START");

    string rResp = "";
    log:printInfo(`main - t(1) :: before-dbOps:getClientContacts`);
    dbOps:Root|error recrVals = check dbOps:getClientContacts(check dssClient, vendorId = "", rResp = rResp);
    log:printInfo(`main - t(4) :: after-dbOps:getClientContacts`);
    //log:printInfo(`main :: recrVals : ${check recrVals}`);
    if recrVals is error {
        log:printError("main :: Contact details fetch from DB Failed: ", recrVals);
        return error("Failed to initialize Client View details fetch", recrVals);
    }

    string? firstname_fr = recrVals.records.rec[0].firstname;
    log:printInfo(`main :: firstname_fr : ${firstname_fr}`);
    log:printInfo(`main - t(5) :: after-dbOps:getClientContacts`);
    dbOps:RecItem[] recs = recrVals.records.rec;
    log:printInfo(`main - t(6) :: after-dbOps:getClientContacts`);
    int i = 1;
    foreach dbOps:RecItem rec in recs {
        //log:printInfo(`${i} = ${rec.toJsonString()}`);
        rResp = "BFP-begin";
        string respVal = "";

        string mathDateLatest = "";
        string mathResultLatest = "";
        string mathDateHighest = "";
        string mathResultHighest = "";
        string mathDateFormatted = "";
        string mathResultFormatted = "";

        string englDateLatest = "";
        string englResultLatest = "";
        string englDateHighest = "";
        string englResultHighest = "";
        string englDateFormatted = "";
        string englResultFormatted = "";

        string digiDateLatest = "";
        string digiResultLatest = "";
        string digiDateHighest = "";
        string digiResultHighest = "";
        string digiDateFormatted = "";
        string digiResultFormatted = "";

        string? vendorId = rec?.hit_hitvendorid;
        string vendorUserId = "";

        int errored = 1;

        json|error resultUserId = {};

        do {
            resultUserId = check vendor:getBksbUserId(check vendorClient, vendorHost = vendorHost, vendorId = vendorId ?: "", rResp = rResp);
        } on fail error e {
            errored = 0;
            resultUserId = "Client User ID Not Found";

            log:printError(`xE message: ${e.message()}`);
            log:printError(`xE check: ${check e.cause()}`);
            map<value:Cloneable> & readonly eDtl = e.detail();
            log:printError(`xE detail: ${eDtl.toString()}`);
            //log:printError("xE body: ",<error?>eDtl["body"]);
        }            
       
        if errored == 0 { //resultUserId is error {
            log:printError(`main [${i}] - ${vendorId} - Failed to fetch BKSB User ID :: ${(check resultUserId).toString()}`);
            rResp = string `${rResp} | Failed to fetch BKSB User ID :: ${(check resultUserId).toString()}`;
            //return error(string `main [${i}] :: Failed to fetch BKSB User ID :: ${resultUserId.toString()}`);
        } else {
            vendorUserId = (check resultUserId).toJsonString();

            log:printInfo(`main : begin ::: ${vendorId}`);
            //log:printInfo(`main [${i}]:: vendorUserId = ${vendorUserId}`);   
            rResp = rResp + string ` | main :: User ID = ${vendorUserId}`;

            int|error userIdCheck = int:fromString(vendorUserId);

            if userIdCheck !is int {
                log:printError(`main [${i}] - ${vendorUserId} :: Invalid BKSB Id or No User ID exists = ${userIdCheck.toString()}`);
                rResp = rResp + "| main :: Invalid BKSB Id or No User ID exists";
                //return error(string `main [${i}]:: Invalid BKSB Id or No User ID exists = ${userIdCheck.toString()}`); 
            } else {
                log:printInfo(`main [${i}] - ${vendorUserId} :: Valid BKSB User ID`);

                vendor:ResultsRecord|error vendorResults = check vendor:getBksbResults(check vendorClient, vendorHost = vendorHost,
                        vendorUserId = vendorUserId, rResp = respVal);
                
                if vendorResults is error {
                    log:printError(`main [${i}] - ${vendorUserId} :: ${vendorResults.toString()}`);
                    rResp = string `${rResp} | :: Failed to fetch Client Results :: ${vendorResults.toString()}`;
                    //return error(string `main [${i}] - ${vendorUserId} :: Failed to fetch Client Results :: ${vendorResults.toString()}`);
                } else {
                    //log:printInfo(`main [${i}] - ${vendorUserId} :: vendorResults : ${vendorResults}`);  

                    if (vendorResults.InitialAssessmentResults == []) {
                        log:printWarn(`main [${i}] - ${vendorUserId} :: No Assessments`);
                        rResp = string `${rResp} | No Assessments`;
                        //return error(string `main [${i}] - ${vendorUserId} :: No Assessments`); 
                        // i += 1;
                        // continue;
                    } else {
                        json|error assessments = vendor:processResults(vendorUserId, vendorResults.InitialAssessmentResults ?: []);
                        if assessments is error {
                            log:printError(`main [${i}] - ${vendorUserId} :: ${assessments.toString()}`);
                            rResp = string `${rResp} | ${assessments.toString()}`;
                            return error(string `main [${i}] - ${vendorUserId} :: Failed to process Client Results :: ${assessments.toString()}`);
                        }

                        mathDateLatest = check assessments.mathDateLatest; //string `mathsDateLatest-${i}`;
                        mathResultLatest = check assessments.mathResultLatest; //string `mathsResultLatest-${i}`;
                        mathDateHighest = check assessments.mathDateHighest; //string `mathsDateHighest-${i}`;
                        mathResultHighest = check assessments.mathResultHighest; //string `mathsResultHighest-${i}`;

                        mathDateFormatted = mathDateHighest;
                        mathResultFormatted = check assessments.mathResultHighestFormatted;

                        if mathResultHighest == "" {
                            log:printWarn(`main [${i}]:: No Maths Results`);
                            rResp = string `${rResp} | main [${i}] - ${vendorUserId} :: No Maths Results`;
                        } else {
                            //log:printInfo(`main [${i}]:: Maths Results are set`);
                            rResp = string `${rResp} | main [${i}] - ${vendorUserId} :: Maths Results are set`;
                        }

                        englDateLatest = check assessments.englDateLatest;
                        englResultLatest = check assessments.englResultLatest;
                        englDateHighest = check assessments.englDateHighest;
                        englResultHighest = check assessments.englResultHighest;

                        englDateFormatted = englDateHighest;
                        englResultFormatted = check assessments.englResultHighestFormatted;

                        if englResultHighest == "" {
                            log:printWarn(`main [${i}]:: No English Results`);
                            rResp = string `${rResp} | main [${i}] - ${vendorUserId} :: No English Results`;
                        } else {
                            //log:printInfo(`main [${i}]:: English Results are set`);
                            rResp = string `${rResp} | main [${i}] - ${vendorUserId} :: English Results are set`;
                        }

                        digiDateLatest = check assessments.digiDateLatest;
                        digiResultLatest = check assessments.digiResultLatest;
                        digiDateHighest = check assessments.digiDateHighest;
                        digiResultHighest = check assessments.digiResultHighest;

                        digiDateFormatted = digiDateHighest;
                        digiResultFormatted = check assessments.digiResultHighestFormatted;

                        if digiResultHighest == "" {
                            log:printWarn(`main [${i}]:: No Digital Results`);
                            rResp = string `${rResp} | main [${i}] - ${vendorUserId} :: No Digital Results`;
                        } else {
                            //log:printInfo(`main [${i}]:: Digital Results are set`);
                            rResp = string `${rResp} | main [${i}] - ${vendorUserId} :: Digital Results are set`;
                        }
                    }
                }
            }

            json|error saveResponse = check dbOps:updateResults(check dssClient, resultType = 1, hitBksbid = vendorId ?: "",
                    dateLatest = mathDateLatest, resultLatest = mathResultLatest,
                    dateHighest = mathDateHighest, resultHighest = mathResultHighest,
                    dateFormatted = mathDateFormatted, resultFormatted = mathResultFormatted,
                    rResp = string `${rResp} | BFP-end`);

            if saveResponse is error {
                log:printError(`main [${i}]:: ${saveResponse.toString()}`);
                rResp = string `${rResp} | Failed to update Client Maths Results :: ${saveResponse.toString()}`;
                //return error(string `main [${i}] - ${vendorUserId} :: Failed to update Client Maths Results :: ${saveResponse.toString()}`);
            }
            //log:printInfo(`main [${i}] - ${vendorUserId} :: MATHS | saveResponse = ${saveResponse.toJsonString()}`);  

            saveResponse = check dbOps:updateResults(check dssClient, resultType = 2, hitBksbid = vendorId ?: "",
                    dateLatest = englDateLatest, resultLatest = englResultLatest,
                    dateHighest = englDateHighest, resultHighest = englResultHighest,
                    dateFormatted = englDateFormatted, resultFormatted = englResultFormatted,
                    rResp = string `${rResp} | BFP-end`);

            if saveResponse is error {
                log:printError(`main [${i}]:: ENGLISH : ${saveResponse.toString()}`);
                rResp = string `${rResp} | Failed to update Client English Results :: ${saveResponse.toString()}`;
                //return error(string `main [${i}] - ${vendorUserId} :: Failed to update Client English Results :: ${saveResponse.toString()}`);
            }
            //log:printInfo(`main [${i}] - ${vendorUserId} :: ENGLISH | saveResponse = ${saveResponse.toJsonString()}`); 

            saveResponse = check dbOps:updateResults(check dssClient, resultType = 3, hitBksbid = vendorId ?: "",
                    dateLatest = digiDateLatest, resultLatest = digiResultLatest,
                    dateHighest = digiDateHighest, resultHighest = digiResultHighest,
                    dateFormatted = digiDateFormatted, resultFormatted = digiResultFormatted,
                    rResp = string `${rResp} | BFP-end`);

            if saveResponse is error {
                log:printError(`main [${i}]:: DIGITAL : ${saveResponse.toString()}`);
                rResp = string `${rResp} | Failed to update Client Digital Results :: ${saveResponse.toString()}`;
                //return error(string `main [${i}] - ${vendorUserId} :: Failed to update Client Digital Results :: ${saveResponse.toString()}`);
            }
            //log:printInfo(`main [${i}] - ${vendorUserId} :: DIGITAL | saveResponse = ${saveResponse.toJsonString()}`);
        }

        json|error saveResponse_final = check dbOps:updateResults(check dssClient, resultType = 6, hitBksbid = vendorId ?: "",
                dateLatest = "", resultLatest = "",
                dateHighest = "", resultHighest = "",
                dateFormatted = "", resultFormatted = "",
                rResp = string `${rResp} | BFP-end`);

        if saveResponse_final is error {
            log:printError(`main [${i}]:: REC-MSG-UPD : ${saveResponse_final.toString()}`);
            rResp = string `${rResp} | ${saveResponse_final.toString()}`;
            //return error(string `main [${i}] - ${vendorUserId} :: Failed to update REC-MSG-UPD :: ${saveResponse_final.toString()}`);
        }

        log:printInfo(`main : end ::: ${vendorId}`);
        i = i + 1;
    }

    log:printInfo("fetch_process :: END");
}
