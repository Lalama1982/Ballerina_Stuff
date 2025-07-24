import ballerina/io;

public function main() returns error?{
    string xmlStr = "<env:Envelope xmlns:env='http://schemas.xmlsoap.org/soap/envelope/'><env:Header></env:Header><env:Body><env:Fault xmlns:env='http://schemas.xmlsoap.org/soap/envelope/'><faultcode>env:Server</faultcode><faultstring>Invalid input field - givenname</faultstring><detail><ns2:faultDetails xmlns:ns2='http://dynamicform.services.registrations.edentiti.com/'><code>FieldValidationFault</code><details>Value of [] for givenname is invalid</details></ns2:faultDetails></detail></env:Fault></env:Body></env:Envelope>";
    //xml xmlA = xml `${xmlStr}`;

    //string myXMLStream = "<root><foo/></root>";
    io:StringReader reader = new io:StringReader(xmlStr);
    xml xmlA = check reader.readXml() ?: xml ``;

    io:println("xmlA >> ", xmlA);

    string faultstring = (xmlA/**/<faultstring>).data();
    io:println("faultstring >> ", faultstring);    
}