import ballerina/io;

public function getAusPassportPayload(json reqPayload, json regDetails) returns (xml)|error {
    string loc = "auspassport";
    io:println(loc, "-getAusPassportPayload: reqPayload >> " + reqPayload.toString());

    string accountId = check regDetails.accountId;
    string password = check regDetails.password;
    string verifyId = check reqPayload.verifyId;
    
    string ausPassportNo = check reqPayload.ausPassportNo;
    string ausPassportGivenName = check reqPayload.ausPassportGivenName;
    string ausPassportMiddleName = check reqPayload.ausPassportMiddleName;
    string ausPassportSurname = check reqPayload.ausPassportSurname;
    string ausPassportDoB = check reqPayload.ausPassportDoB;
    string ausPassportTandC = check reqPayload.ausPassportTandC;

    xml payloadXml = xml `<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:dyn="http://dynamicform.services.registrations.edentiti.com/">
                            <soapenv:Body>
                                <dyn:setFields>
                                <accountId>${accountId}</accountId>
                                <password>${password}</password>
                                <verificationId>${verifyId}</verificationId>
                                <greenIdWebVerificationToken></greenIdWebVerificationToken>
                                <sourceId>passportdvs</sourceId>
                                <inputFields>
                                    <input>
                                        <name>greenid_passportdvs_number</name>
                                        <value>${ausPassportNo}</value>
                                    </input>
                                    <input>
                                        <name>greenid_passportdvs_givenname</name>
                                        <value>${ausPassportGivenName}</value>
                                    </input>
                                    <input>
                                        <name>greenid_passportdvs_middlename</name>
                                        <value>${ausPassportMiddleName}</value>
                                    </input>                
                                    <input>
                                        <name>greenid_passportdvs_surname</name>
                                        <value>${ausPassportSurname}</value>
                                    </input>
                                    <input>
                                        <name>greenid_passportdvs_dob</name>
                                        <value>${ausPassportDoB}</value>
                                    </input>
                                    <input>
                                        <name>greenid_passportdvs_tandc</name>
                                        <value>${ausPassportTandC}</value>
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
