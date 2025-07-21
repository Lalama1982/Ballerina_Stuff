import ballerina/http;
import ballerina/io;
//import ballerina/mime;

public function main() returns error? {
    // Creates a new client with the GreenID APIM Implmentation.
    string url = "https://24c9c232-84f9-4788-ae7a-597a7e4f2b87-nonprod.nonprod.hgln.choreoapis.dev/apisproxies/greenid-proxy/v1/Registrations-Registrations";
    decimal timeout = 15;
    http:HttpVersion httpVersion = http:HTTP_1_1;
    http:Client|error greenIdApimClient = new (url, {timeout, httpVersion});

    if greenIdApimClient is error {
        io:println("Failed to initialize an HTTP client", greenIdApimClient);
        return;
    }
    io:println(string `Initialized client with URL: ${url}, timeout: ${timeout}, HTTP version: ${httpVersion}`);
    io:println("------------------------------------------------------------");

    xml payloadXml = xml `<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:dyn="http://dynamicform.services.registrations.edentiti.com/">
                            <soapenv:Body>
                                <dyn:registerVerification>
                                    <accountId>holmesglen</accountId>
                                    <password>X7549vsSJLK4M2Zn</password>
                                    <verificationId></verificationId>
                                    <ruleId>default</ruleId>
                                    <generateGreenIdWebVerificationToken>true</generateGreenIdWebVerificationToken>
                                    <name>
                                        <givenName>JANE</givenName>
                                        <honorific></honorific>
                                        <middleNames></middleNames>
                                        <surname>SMITH</surname>
                                    </name>
                                    <email>greenid@GBGPLC.com</email>
                                    <dob>
                                        <day>10</day>
                                        <month>10</month>
                                        <year>2005</year>
                                    </dob>
                                    <currentResidentialAddress>
                                        <streetNumber>675-685</streetNumber>                
                                        <streetName>Warrigal Rd</streetName>
                                        <streetType>St</streetType>                
                                        <suburb>Chadstone</suburb>                
                                        <postcode>3148</postcode>
                                        <state>VIC</state>                
                                        <country>AU</country>
                                    </currentResidentialAddress>
                                    <homePhone></homePhone>
                                    <workPhone></workPhone>
                                    <mobilePhone></mobilePhone>
                                    <deviceIDData></deviceIDData>
                                    <ipAddress></ipAddress>
                                    <deviceId></deviceId>
                                    <extraData>
                                        <name>dnb-credit-header-consent-given</name>
                                        <value>true</value>
                                    </extraData>
                                </dyn:registerVerification>
                            </soapenv:Body>
                        </soapenv:Envelope>`;

    http:Request req = new;
    req.setXmlPayload(payloadXml);
    req.setHeader("Content-Type", "text/xml");

    string apimAuthToken = "Bearer eyJ4NXQiOiIyM3BHLUFiR1RrVGFqd0JSX2FwZTlRVS13MDAiLCJraWQiOiJaV0poT0RWak5XUmpNR0l6WldObVpUQXdOR0UzTnpabE5EQmtOMlprWWpZM1ltTmxaRE15WlRSaVptTmxZVGRtTmpZMk1qTXhNV0k0T0RjMU1EZGtaQV9SUzI1NiIsInR5cCI6ImF0K2p3dCIsImFsZyI6IlJTMjU2In0.eyJzdWIiOiJ4c291WmgyNEU1Z2d1NzhhYUk1dFNXNGhwNllhIiwiYXV0IjoiQVBQTElDQVRJT04iLCJpc3MiOiJodHRwczpcL1wvYXBpLmFzZ2FyZGVvLmlvXC90XC9ob2xtZXNnbGVuXC9vYXV0aDJcL3Rva2VuIiwiY2xpZW50X2lkIjoieHNvdVpoMjRFNWdndTc4YWFJNXRTVzRocDZZYSIsImF1ZCI6WyJ4c291WmgyNEU1Z2d1NzhhYUk1dFNXNGhwNllhIiwiY2hvcmVvOmRlcGxveW1lbnQ6c2FuZGJveCJdLCJuYmYiOjE3NTMwNjcwNzgsImF6cCI6Inhzb3VaaDI0RTVnZ3U3OGFhSTV0U1c0aHA2WWEiLCJvcmdfaWQiOiIyNGM5YzIzMi04NGY5LTQ3ODgtYWU3YS01OTdhN2U0ZjJiODciLCJleHAiOjE3ODQ2MDMwNzgsIm9yZ19uYW1lIjoiaG9sbWVzZ2xlbiIsImlhdCI6MTc1MzA2NzA3OCwianRpIjoiNDM5MmIxZWUtODE0Ni00NmVkLWE2M2YtMDJiMmQxOTMzNGZkIiwib3JnX2hhbmRsZSI6ImhvbG1lc2dsZW4ifQ.VLHwo9lshVROevGqzOyeSmS2hV95kx4UCy1AA5eJHTyZFYA8TnwEkX_Zej2SZsDOQxOMAUIk9CUz1OKVCiWRAnK5RujABMW2tuTb3ui2gp7MoJftK7anqaQLJFQEfuIooA--X1xU6atza4mHurmQd0QlPKikgcsNBvYgsexFCLXSidGmmZsrhMOSTn05dnUNiABQ_nPqYnh19396h0Kvr3ZeZbkAy2FHfx1wwsJ4EpzsFi2Wjr_fCN_Rsa1Wupu57Rm_JCOdlOLqewJxz2fuq6yQZa4Xk7-442ZBcjHhfm8dsMlETOqx7_vLVuq-ZbL-VT7Y17gsqDlUtQ-6PNcl-w";
    req.setHeader("Authorization", apimAuthToken);

    xml xmlPayload = check greenIdApimClient->/DynamicFormsServiceV5.post(req);

    io:println("------------------------------------------------------------");    
    //io:println("xmlPayload >> ", xmlPayload);
    string verificationId = (xmlPayload/**/<verificationId>).data();
    io:println("verificationId >> ", verificationId);

    string overallVerificationStatus = (xmlPayload/**/<overallVerificationStatus>).data();            
    io:println("overallVerificationStatus >> ", overallVerificationStatus);    

    io:println("------------------------------------------------------------"); 
    json respJson = {"verificationId": verificationId, "overallVerificationStatus": overallVerificationStatus};
    io:println("respJson >> ",respJson);
}
