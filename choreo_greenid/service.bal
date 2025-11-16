import ballerina/http;
import ballerina/io;
import ballerina/log;

configurable string unitName = ?;
configurable string url = ?;
configurable decimal timeout = ?;
configurable string apimAuthToken = ?;

public configurable string accountId = ?;
public configurable string password = ?;
public configurable string ruleId = ?;
public configurable string concessionRuleId = ?;

const http:HttpVersion httpVersion = http:HTTP_1_1;
const ERROR_HTTP_STATUS = 499;

@http:ServiceConfig {
    cors: {
        allowOrigins: ["*"],
        allowMethods: ["GET", "POST", "PUT"],
        allowCredentials: true,
        maxAge: 3600 // In seconds
    }
}

//A service representing a network-accessible API bound to port `9090`.
service /HGlenGreenIdService on new http:Listener(9090) {

    resource function get info() returns http:Response|error {
        json respJson = {"Source": "Holmesglen-Integration", "Project": "GreenID Service"};

        // Send a response back to the caller.
        http:Response response = new;

        response.setPayload(respJson);
        return response;
    }

    resource function post verifyRegDVS/[string templateFlag](http:Request request) returns http:Response|error? {
        log:printInfo("<>");
        json payLoad = check request.getJsonPayload();
        log:printInfo(`${unitName}-verifyRegDVS(${templateFlag}): START`);

        log:printInfo(`${unitName}-verifyRegDVS: templateFlag >> ${templateFlag}`);
        log:printInfo(`${unitName}-verifyRegDVS: payLoad >> ${payLoad.toString()}`);
        string studId = check payLoad.studId;
        log:printInfo(`${unitName}-verifyRegDVS: studId >> ${studId}`);
        
        // Registration verification :: START 
        string templateRuleId = ruleId;
        if (templateFlag == "aus-centrelink"){
            templateRuleId = concessionRuleId;    
        }
        log:printInfo(`${unitName}-verifyRegDVS: templateRuleId >> ${templateRuleId}`);   

        json params = {"unitName": unitName, "url": url, "timeout": timeout, "accountId": accountId, "password": password, "ruleId": templateRuleId};
        // json params = {"unitName": unitName, "url": url, "timeout": timeout, "accountId": accountId, "password": password, 
        //                "ruleId": (templateFlag = "aus-centrelink") ? concessionRuleId : ruleId};
        log:printInfo(`${unitName}-verifyRegDVS: params >> ${params.toString()}`);                       

        json verifyRespJson = check getVerificationId(request, params);

        string verfId = check verifyRespJson.verificationId;
        log:printInfo(`${unitName}-verifyRegDVS: verfId >> ${verfId}`);

        //string regStatus = check verifyRespJson.statusCode;
        int|error regStatus = int:fromString(check verifyRespJson.statusCode);
        log:printInfo(`${unitName}unitName-verifyRegDVS: regStatus >> ${check regStatus}`);

        http:Response response = new;
        response.setHeader("Access-Control-Allow-Origin", "*");
        
        if regStatus == ERROR_HTTP_STATUS {
           response.setPayload(verifyRespJson);
           return response;
        }
        json js = {"verifyId": verfId};
        payLoad = check payLoad.mergeJson(js);

        if js is null {
            log:printError(`${unitName}-verifyRegDVS: No verification ID`);            
            response.setPayload(verifyRespJson);
            return response;
        }

        log:printInfo(`${unitName}-regVerifyT2: payLoad (updated with verification ID) >> ${payLoad.toString()}`);
        log:printInfo("+++++++++++++++++++++++");
        // Registration verification :: END

        http:Client|error greenIdApimClient = new (url, {timeout, httpVersion});

        if greenIdApimClient is error {
            log:printError(`${unitName}-verifyRegDVS: Failed to initialize an HTTP client >> ${greenIdApimClient.toString()}`);
            json msgJson = {"Source": unitName, "Student": studId, "Template": templateFlag, "Msg": "Failed to initialize an HTTP client >> " + greenIdApimClient.toString()};
            response.setPayload(msgJson);
            return response;
        }
        log:printInfo(string `${unitName}-verifyRegDVS: Initialized client with URL: ${url}, timeout: ${timeout}, HTTP version: ${httpVersion}`);

        json regDetails = {"accountId": accountId, "password": password};   

        xml payloadXml = check getXmlPayload(templateFlag, payLoad, regDetails);
        log:printInfo(`${unitName}-verifyRegDVS(${templateFlag}): payloadXml >> ${payloadXml.toString()}`);

        http:Request reqGreenId = new;
        xml xmlPayload = xml ``;
        json respJson;

        do {
            reqGreenId.setXmlPayload(payloadXml);
            reqGreenId.setHeader("Content-Type", "text/xml");
            reqGreenId.setHeader("Authorization", apimAuthToken);
            xmlPayload = check greenIdApimClient->/DynamicFormsServiceV5.post(reqGreenId);

            string verificationId = (xmlPayload/**/<verificationId>).data();
            log:printInfo(`${unitName}-verifyRegDVS: verificationId >> ${verificationId}`);

            string overallVerificationStatus = (xmlPayload/**/<overallVerificationStatus>).data();
            log:printInfo(`${unitName}-verifyRegDVS: overallVerificationStatus >> ${overallVerificationStatus}`);

            respJson = {"Source": unitName, "Student": studId, "Template": templateFlag, "verificationId": verificationId, "overallVerificationStatus": overallVerificationStatus};

        } on fail error e {
            respJson = check formatError(studId, templateFlag, e);

            response.statusCode = ERROR_HTTP_STATUS;
            log:printError(`${unitName}-verifyRegDVS(${templateFlag}): ERRORED - ${respJson.toJsonString()}`);
        }

        response.setPayload(respJson);
        log:printInfo(`${unitName}-verifyRegDVS: respJson >> ${respJson.toString()}`);
        log:printInfo(`${unitName}-verifyRegDVS(${templateFlag}): END`);
        return response;
    }

    resource function post regVerify(http:Request request) returns http:Response|error? {
        io:println("<>");
        io:println(unitName, "-regVerify: START");
        string templateFlag = "reg-ver";
        io:println(unitName, "-regVerify: templateFlag >> " + templateFlag);

        json payLoad = check request.getJsonPayload();
        io:println(unitName, "-regVerify: payLoad >> " + payLoad.toString());
        string studId = check payLoad.studId;
        io:println(unitName, "-regVerify: studId >> " + studId);

        http:Response response = new;
        http:Client|error greenIdApimClient = new (url, {timeout, httpVersion});

        if greenIdApimClient is error {
            io:println(unitName, "-regVerify: Failed to initialize an HTTP client >> ", greenIdApimClient);
            json msgJson = {"Source": unitName, "Student": studId, "Template": templateFlag, "Msg": "Failed to initialize an HTTP client >> " + greenIdApimClient.toString()};
            response.setPayload(msgJson);
            return response;
        }
        io:println(string `${unitName}-regVerify: Initialized client with URL: ${url}, timeout: ${timeout}, HTTP version: ${httpVersion}`);

        json regDetails = {"accountId": accountId, "password": password, "ruleId": ruleId};   

        xml payloadXml = check getXmlPayload(templateFlag, payLoad, regDetails);

        http:Request reqGreenId = new;
        xml xmlPayload = xml ``;
        json respJson;

        do {
            reqGreenId.setXmlPayload(payloadXml);
            reqGreenId.setHeader("Content-Type", "text/xml");
            reqGreenId.setHeader("Authorization", apimAuthToken);

            xmlPayload = check greenIdApimClient->/DynamicFormsServiceV5.post(reqGreenId);
            io:println(unitName, "-regVerify: xmlPayload >> ", xmlPayload);

            string verificationId = (xmlPayload/**/<verificationId>).data();
            io:println(unitName, "-regVerify: verificationId >> ", verificationId);

            string overallVerificationStatus = (xmlPayload/**/<overallVerificationStatus>).data();
            io:println(unitName, "-regVerify: overallVerificationStatus >> ", overallVerificationStatus);

            respJson = {"Source": unitName, "Student": studId, "Template": templateFlag, "verificationId": verificationId, "overallVerificationStatus": overallVerificationStatus};
            io:println(unitName, "-regVerify: respJson >> ", respJson);

        } on fail error e {
            respJson = check formatError(studId, templateFlag, e);
            response.statusCode = ERROR_HTTP_STATUS;
            io:println(`${unitName}-regVerify: ERRORED - ${respJson.toJsonString()}`);
        }

        io:println(unitName, "-regVerify: END");

        response.setPayload(respJson);
        return response;
    }

    resource function post verifyDVS/[string templateFlag](http:Request request) returns http:Response|error? {
        io:println("<>");
        json payLoad = check request.getJsonPayload();
        io:println(`${unitName}-verifyDVS(${templateFlag}): START`);

        io:println(unitName, "-verifyDVS: templateFlag >> " + templateFlag);
        io:println(unitName, "-verifyDVS: payLoad >> " + payLoad.toString());
        string studId = check payLoad.studId;
        io:println(unitName, "-verifyDVS: studId >> " + studId);

        http:Response response = new;
        http:Client|error greenIdApimClient = new (url, {timeout, httpVersion});

        if greenIdApimClient is error {
            io:println(unitName, "-verifyDVS: Failed to initialize an HTTP client >> ", greenIdApimClient);
            json msgJson = {"Source": unitName, "Student": studId, "Template": templateFlag, "Msg": "Failed to initialize an HTTP client >> " + greenIdApimClient.toString()};
            response.setPayload(msgJson);
            return response;
        }
        io:println(string `${unitName}-verifyDVS: Initialized client with URL: ${url}, timeout: ${timeout}, HTTP version: ${httpVersion}`);

        json regDetails = {"accountId": accountId, "password": password};   

        xml payloadXml = check getXmlPayload(templateFlag, payLoad, regDetails);
        io:println(`${unitName}-verifyDVS(${templateFlag}): payloadXml >> ${payloadXml}`);

        http:Request reqGreenId = new;
        xml xmlPayload = xml ``;
        json respJson;

        do {
            reqGreenId.setXmlPayload(payloadXml);
            reqGreenId.setHeader("Content-Type", "text/xml");
            reqGreenId.setHeader("Authorization", apimAuthToken);
            xmlPayload = check greenIdApimClient->/DynamicFormsServiceV5.post(reqGreenId);

            string verificationId = (xmlPayload/**/<verificationId>).data();
            io:println(unitName, "-verifyDVS: verificationId >> ", verificationId);

            string overallVerificationStatus = (xmlPayload/**/<overallVerificationStatus>).data();
            io:println(unitName, "-verifyDVS: overallVerificationStatus >> ", overallVerificationStatus);

            respJson = {"Source": unitName, "Student": studId, "Template": templateFlag, "verificationId": verificationId, "overallVerificationStatus": overallVerificationStatus};

        } on fail error e {
            respJson = check formatError(studId, templateFlag, e);

            response.statusCode = ERROR_HTTP_STATUS;
            io:println(`${unitName}-verifyDVS(${templateFlag}): ERRORED - ${respJson.toJsonString()}`);
        }

        response.setPayload(respJson);
        io:println(unitName, "-verifyDVS: respJson >> ", respJson);
        io:println(`${unitName}-verifyDVS(${templateFlag}): END`);
        return response;
    }

    resource function 'default [string... paths](http:Request req) returns http:Response {
        http:Response response = new;
        json respJson = {"Source": unitName, "method": req.method, "path": paths.toString(), "message": "resource not found"};

        response.setPayload(respJson);
        response.statusCode = ERROR_HTTP_STATUS;
        return response;
    }    
}
