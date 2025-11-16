import ballerina/http;
import ballerina/io;

//import choreo_greenid.xml_templates;

//string unitName = "HGlenGreenIdService";
const http:HttpVersion httpVersion = http:HTTP_1_1;
const ERROR_HTTP_STATUS = 499;

public function getVerificationId(http:Request request, json params) returns json|error {
    io:println(unitName, "-getVerificationId: START");

    string unitName = check params.unitName;
    string url = check params.url;
    string accountId = check params.accountId;
    string password = check params.password;
    string ruleId = check params.ruleId;

    //string tT = check params.timeout; //decimal:fromString("0.2453")
    decimal timeout = 15.0; //check decimal:fromString(tT);

    string templateFlag = "reg-ver";
    io:println(unitName, "-getVerificationId: templateFlag >> " + templateFlag);

    json payLoad = check request.getJsonPayload();
    io:println(unitName, "-getVerificationId: payLoad >> " + payLoad.toString());
    string studId = check payLoad.studId;
    io:println(unitName, "-getVerificationId: studId >> " + studId);

    //http:Response response = new;
    http:Client|error greenIdApimClient = new (url, {timeout, httpVersion});

    if greenIdApimClient is error {
        io:println(unitName, "-getVerificationId: Failed to initialize an HTTP client >> ", greenIdApimClient);
        json msgJson = {"Source": unitName, "Student": studId, "Template": templateFlag, "Msg": "Failed to initialize an HTTP client >> " + greenIdApimClient.toString(), "statusCode": ERROR_HTTP_STATUS};
        //response.setPayload(msgJson);

        return msgJson;
    }
    io:println(string `${unitName}-getVerificationId: Initialized client with URL: ${url}, timeout: ${timeout}, HTTP version: ${httpVersion}`);

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
        io:println(unitName, "-getVerificationId: xmlPayload >> ", xmlPayload);

        string verificationId = (xmlPayload/**/<verificationId>).data();
        io:println(unitName, "-getVerificationId: verificationId >> ", verificationId);

        string overallVerificationStatus = (xmlPayload/**/<overallVerificationStatus>).data();
        io:println(unitName, "-getVerificationId: overallVerificationStatus >> ", overallVerificationStatus);

        respJson = {"Source": unitName, "Student": studId, "Template": templateFlag, "verificationId": verificationId, "overallVerificationStatus": overallVerificationStatus, "statusCode": "200"};
        io:println(unitName, "-getVerificationId: respJson >> ", respJson);

    } on fail error e {
        respJson = check formatError(studId, templateFlag, e);
        //response.statusCode = ERROR_HTTP_STATUS;
        io:println(`${unitName}-getVerificationId: ERRORED - ${respJson.toJsonString()}`);
    }

    io:println(unitName, "-getVerificationId: END");

    //response.setPayload(respJson);
    return respJson;
}
