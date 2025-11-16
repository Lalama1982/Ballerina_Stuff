import ballerina/io;

public function getAusVisaPayload(json reqPayload, json regDetails) returns (xml)|error {
    string loc = "ausvisa";
    io:println(loc, "-getAusVisaPayload: reqPayload >> " + reqPayload.toString());

    string accountId = check regDetails.accountId;
    string password = check regDetails.password;
    string verifyId = check reqPayload.verifyId;
    
    string ausVisaPassportNo = check reqPayload.ausVisaPassportNo;
    string ausVisaCountryIssue = check reqPayload.ausVisaCountryIssue;
    string ausVisaGivenName = check reqPayload.ausVisaGivenName;
    string ausVisaMiddleName = check reqPayload.ausVisaMiddleName;
    string ausVisaSurname = check reqPayload.ausVisaSurname;
    string ausVisaDoB = check reqPayload.ausVisaDoB;
    string ausVisaTandC = check reqPayload.ausVisaTandC;

    xml payloadXml = xml `<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:dyn="http://dynamicform.services.registrations.edentiti.com/">
                            <soapenv:Body>
                                <dyn:setFields>
                                <accountId>${accountId}</accountId>
                                <password>${password}</password>
                                <verificationId>${verifyId}</verificationId>
                                <greenIdWebVerificationToken></greenIdWebVerificationToken>
                                <sourceId>visadvs</sourceId>
                                <inputFields>
                                    <input>
                                        <name>greenid_visadvs_passport_number</name>
                                        <value>${ausVisaPassportNo}</value>
                                    </input>
                                    <input>
                                        <name>greenid_visadvs_country_of_issue</name>
                                        <value>${ausVisaCountryIssue}</value>
                                    </input>
                                    <input>
                                        <name>greenid_visadvs_givenname</name>
                                        <value>${ausVisaGivenName}</value>
                                    </input>                
                                    <input>
                                        <name>greenid_visadvs_middlename</name>
                                        <value>${ausVisaMiddleName}</value>
                                    </input>
                                    <input>
                                        <name>greenid_visadvs_surname</name>
                                        <value>${ausVisaSurname}</value>
                                    </input>
                                    <input>
                                        <name>greenid_visadvs_dob</name>
                                        <value>${ausVisaDoB}</value>
                                    </input>                                   
                                    <input>
                                        <name>greenid_visadvs_tandc</name>
                                        <value>${ausVisaTandC}</value>
                                    </input> 
                                </inputFields>
                                <extraData>
                                    <name></name>
                                    <value></value>
                                </extraData>
                                </dyn:setFields>
                            </soapenv:Body>
                          </soapenv:Envelope>`;

    return payloadXml;
}
