import ballerina/http;
import ballerina/log;

# Returns the string `Hello` with the input string name.
#
# + name - name as a string or nil
# + return - "Hello, " with the input string name
public function hello(string? name) returns string {
    if name !is () {
        return string `Hello from dbOps, ${name}`;
    }
    return "Hello, World!";
}

# Description : Get Clients' Contacts from DB
#
# + dssClient - HTTP Client for DSS EP   
# + vendorId - BKSB ID
# + rResp - message from main
# + return - return contacts as a JSON array
public function getClientContacts(http:Client dssClient,
        string? vendorId = "", string rResp = "rResp") returns Root|error {
    
    log:printInfo(`getClientContacts - t(2) :: before-dbOps:getClientContacts`);        
    Root|error respJson = check dssClient->get(string `/getClientContacts?vendorId=${vendorId ?: ""}`,
        headers = {
            "Accept": "application/json"
        }
    );
    log:printInfo(`getClientContacts - t(3) :: after-dbOps:getClientContacts`); 

    if respJson is error {
        log:printInfo("getClientContacts :: Failed to fetch Client Contact Details", respJson);
        return error("getClientContacts :: Failed to fetch Client Contact Details", respJson);
    }

    //log:printInfo(`getClientContacts :: respJson : ${respJson}`);
    return respJson;
}

# Description : Update assessments results to table "hit_reports.br2r_bal_recr_contacts"
#
# + dssClient - HTTP Client for DSS EP  
# + resultType - 1 : maths, 2 : english, 3 : digital techs  
# + hitBksbid - BKSB ID  
# + dateLatest - date of latest result  
# + resultLatest - resulf of latest
# + dateHighest - date of highest result  
# + resultHighest - result of highest  
# + dateFormatted - date formatted for Client update
# + resultFormatted - result formatted for Client update 
# + rResp - message from main
# + return - status of the update process
public function updateResults(http:Client dssClient, int resultType, string hitBksbid = "hitBksbid", 
        string dateLatest = "dateLatest", string resultLatest = "resultLatest", 
        string dateHighest = "dateHighest", string resultHighest = "resultHighest",
        string dateFormatted = "dateFormatted", string resultFormatted = "resultFormatted",
        string rResp = "rResp") returns json|error {

    http:Request req = new;
    //req.setHeader("Content-Type", "application/json");
    req.setHeader("Accept", "application/json");

    json reqPayload = {
        "_updateResults": {
            "resultType": resultType,
            "vendorId": hitBksbid,
            "dateLatest": dateLatest,
            "resultLatest": resultLatest,
            "dateHighest": dateHighest,
            "resultHighest": resultHighest,
            "dateFormatted": dateFormatted,
            "resultFormatted": resultFormatted,            
            "rResp": rResp
        }
    };

    req.setJsonPayload(reqPayload, "application/json");

    json|error respJson = check dssClient->post("/updateResults", req);

    if respJson is error {
        log:printInfo(string `updateResults :: ${hitBksbid} >> Failed to update Results :: ${respJson.toString()}`);
        return error(string `updateResults :: Failed to update Results :: ${respJson.toString()}`); 
    }

    //log:printInfo(`updateResults :: ${hitBksbid} >> respJson : ${respJson}`);
    return respJson;
}
