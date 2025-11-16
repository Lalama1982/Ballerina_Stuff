import ballerina/io;

public function getRegVerifPayload(json reqPayload, json regDetails) returns (xml)|error {
    string loc = "regVeriftemplate";
    io:println(loc, "-getRegVerifPayload: reqPayload >> " + reqPayload.toString());

    string accountId = check regDetails.accountId;
    string password = check regDetails.password;
    string ruleId = check regDetails.ruleId;

    string firstName = check reqPayload.firstName;
    string lastName = check reqPayload.lastName;
    string email = check reqPayload.email;
    string dobDay = check reqPayload.dobDay;
    string dobMonth = check reqPayload.dobMonth;
    string dobYear = check reqPayload.dobYear;

    xml payloadXml = xml `<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:dyn="http://dynamicform.services.registrations.edentiti.com/">
                            <soapenv:Body>
                                <dyn:registerVerification>
                                    <accountId>${accountId}</accountId>
                                    <password>${password}</password>
                                    <verificationId></verificationId>
                                    <ruleId>${ruleId}</ruleId>
                                    <generateGreenIdWebVerificationToken>true</generateGreenIdWebVerificationToken>
                                    <name>
                                        <givenName>${firstName}</givenName>
                                        <honorific></honorific>
                                        <middleNames></middleNames>
                                        <surname>${lastName}</surname>
                                    </name>
                                    <email>${email}</email>
                                    <dob>
                                        <day>${dobDay}</day>
                                        <month>${dobMonth}</month>
                                        <year>${dobYear}</year>
                                    </dob>
                                    <currentResidentialAddress/>
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

    return payloadXml;
}
