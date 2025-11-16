import ballerina/http;
import ballerina/log;

# Returns the string `Hello` with the input string name.
#
# + name - name as a string or nil
# + return - "Hello, " with the input string name
public function hello(string? name) returns string {
    if name !is () {
        return string `Hello, ${name}`;
    }
    return "Hello, World!";
}

# Description.
#
# + clientTokenURL - HTTP Client for Client Token EP  
# + clientUserName - Client User Name  
# + clientUserPwd - Client Password  
# + clientTokenHost - Host for Token EP  
# + clientTokenResource - resource for Token EP  
# + clientClientId - Client Client ID 
# + clientClientSecret - Client Client Secret
# + return - returns (Bearer) Access Token
public function getClientToken(string clientTokenURL, string clientUserName, string clientUserPwd,
        string clientTokenHost, string clientTokenResource,
        string clientClientId, string clientClientSecret) returns string|error {

    decimal timeout = 3600;
    http:HttpVersion httpVersion = http:HTTP_1_1;
    http:Client|error clientTokenClient = new (clientTokenURL, {timeout, httpVersion});

    if clientTokenClient is error {
        log:printError("getClientToken :: Failed to initialize Client Token: ", clientTokenClient);
        return error("Failed to initialize Client Token", clientTokenClient);

    } else {

        log:printInfo(string `getClientToken :: Initialized client for Client Token with URL: ${clientTokenURL}, timeout: ${timeout}, HTTP version: ${httpVersion}`);

        http:Request tokenReq = new;

        string tokenBody = string `AuthMethod=FormsAuthenticationresource&grant_type=password&username=${clientUserName}&password=${clientUserPwd}&resource=${clientTokenResource}&client_id=${clientClientId}&client_secret=${clientClientSecret}`;
        log:printInfo(`getClientToken :: tokenBody = ${tokenBody}`);

        tokenReq.setPayload(tokenBody);
        tokenReq.setHeader("Host", clientTokenHost);
        tokenReq.setHeader("Content-Type", "text/plain");

        TokenResponse|error tokenResp = clientTokenClient->/adfs/oauth2/token.post(tokenReq);

        if tokenResp is error {
            log:printError("getClientToken :: Token Fetch Failed: ", tokenResp);
            return error("Failed to fetch Client token", tokenResp);
        } else {
            return tokenResp.access_token;
        }
    }

}

# Description.
#
# + clientClient - HTTP Client for Client Resource EP  
# + contactId - contact Id of "Contacts" entity record  
# + mathDateFormatted - Formatted Date for Maths Assessment
# + mathResultFormatted - Formatted Result for Maths Assessment  
# + englDateFormatted - Formatted Date for English Assessment  
# + englResultFormatted - Formatted Result for English Assessment  
# + digiDateFormatted - Formatted Date for Digital Assessment  
# + digiResultFormatted - Formatted Result for Digital Assessment
# + return - returns update status & client response
public function updateClient(http:Client clientClient, string contactId = "contactId",
                              string mathDateFormatted = "mathDateFormatted", string mathResultFormatted = "mathResultFormatted",
                              string englDateFormatted = "englDateFormatted", string englResultFormatted = "englResultFormatted",
                              string digiDateFormatted = "digiDateFormatted", string digiResultFormatted = "digiResultFormatted"
                             ) returns json|error {
                                
    //string clientQueryPath = string `/contacts(${contactId})?$select=recexamid%2C%20hit_exam_english_result%2C%20hit_exam_english_date%2C%20hit_exam_maths_result%2C%20hit_exam_maths_date`;        
    string clientQueryPath = string `/contacts(${contactId})?$select=recexamid,hit_exam_english_result,hit_exam_english_date,hit_exam_maths_result,hit_exam_maths_date`;        

    http:Request req = new;

    req.setHeader("Accept", "application/json");
    req.setHeader("OData-Version", "4.0");
    req.setHeader("OData-MaxVersion", "4.0");
    req.setHeader("If-Match", "*");
    req.setHeader("Prefer", "return=representation");
    req.setHeader("Content-Type", "application/json");

    json reqPayload = "";
    if (mathDateFormatted != "" && englDateFormatted == "") {
        reqPayload = {
            "hit_exam_maths_result": mathResultFormatted,
            "hit_exam_maths_date": mathDateFormatted //"2023-04-27T16:21:00Z"
        };        
    } else if (mathDateFormatted == "" && englDateFormatted != "") {
        reqPayload = {
            "hit_exam_english_result": englResultFormatted,
            "hit_exam_english_date": englDateFormatted //"2023-04-27T15:34:00Z"
        };        
    } else { // both the english & maths results are not null
        reqPayload = {
            "hit_exam_english_result": englResultFormatted,
            "hit_exam_english_date": englDateFormatted, //"2023-04-27T15:34:00Z",
            "hit_exam_maths_result": mathResultFormatted,
            "hit_exam_maths_date": mathDateFormatted //"2023-04-27T16:21:00Z"
        };        
    }

    req.setJsonPayload(reqPayload, "application/json");

    ContactsResponseValueItem|error updateResp = check clientClient->patch(string `/${clientQueryPath}`, req);  
    if updateResp is error {
        log:printError("client.updateClient :: Client Contact update Failed: ", updateResp);
        return error("client.updateClient :: Client Contact update Failed: ", updateResp);        
    }       
    // string updateRespStr = updateResp.toString();
    // log:printInfo("client.updateClient :: updateResp = ", updateRespStr);

    json resp = {status: "Client Updated", resp: updateResp};
    return resp;
}