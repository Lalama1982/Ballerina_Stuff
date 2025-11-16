import ballerina/io;

public function formatError(string studId, string templateFlag, error err) returns json|error {
    json errDetail = check err.detail().toString().fromJsonString();

    // io:println("formaterror-formatError: detail(): ", errDetail);
    string errSts = (check errDetail.statusCode).toString();
    io:println("formaterror-formatError: errSts >> " + errSts);
    
    string errBody = check errDetail.body;
    // io:println("formaterror-formatError: errBody: ", errBody);
    
    io:StringReader reader = new io:StringReader(errBody);
    xml errBodyXml = check reader.readXml() ?: xml ``;

    // io:println("formaterror-formatError: errBodyXml >> ", errBodyXml);
    
    string errorCode = (errBodyXml/**/<code>).data();
    string faultstring = (errBodyXml/**/<faultstring>).data();
    string details = (errBodyXml/**/<details>).data();
    io:println("formaterror-formatError: errorCode = ", errorCode, " / faultstring = ", faultstring, " / details = ", details);
    
    json respJson = {"Source": unitName, "Student": studId, "Template": templateFlag, "errorCode": errorCode, "faultstring": faultstring, "details": details, "statusCode": ERROR_HTTP_STATUS};
    
    return respJson;
}
