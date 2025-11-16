import ballerina/io;

public function getNzPassportPayload(json reqPayload, json regDetails) returns (xml)|error {
    string loc = "nzpassport";
    io:println(loc, "-getNzPassportPayload: reqPayload >> " + reqPayload.toString());

    string accountId = check regDetails.accountId;
    string password = check regDetails.password;
    string verifyId = check reqPayload.verifyId;
    
    string nzPassportNo = check reqPayload.nzPassportNo;
    string nzPassportExpiry = check reqPayload.nzPassportExpiry;
    string nzPassportGivenName = check reqPayload.nzPassportGivenName;
    string nzPassportMiddleName = check reqPayload.nzPassportMiddleName;
    string nzPassportSurname = check reqPayload.nzPassportSurname;
    string nzPassportDob = check reqPayload.nzPassportDob;
    string nzPassportTandC = check reqPayload.nzPassportTandC;

    xml payloadXml = xml `<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:dyn="http://dynamicform.services.registrations.edentiti.com/">
                            <soapenv:Body>
                                <dyn:setFields>
                                <accountId>${accountId}</accountId>
                                <password>${password}</password>
                                <verificationId>${verifyId}</verificationId>
                                <greenIdWebVerificationToken></greenIdWebVerificationToken>
                                <sourceId>nzpassport</sourceId>
                                <inputFields>
                                    <input>
                                        <name>greenid_nzpassport_number</name>
                                        <value>${nzPassportNo}</value>
                                    </input>
                                    <input>
                                        <name>greenid_nzpassport_expiry</name>
                                        <value>${nzPassportExpiry}</value>
                                    </input>
                                    <input>
                                        <name>greenid_nzpassport_givenname</name>
                                        <value>${nzPassportGivenName}</value>
                                    </input>                
                                    <input>
                                        <name>greenid_nzpassport_middlename</name>
                                        <value>${nzPassportMiddleName}</value>
                                    </input>
                                    <input>
                                        <name>greenid_nzpassport_surname</name>
                                        <value>${nzPassportSurname}</value>
                                    </input>
                                    <input>
                                        <name>greenid_nzpassport_dob</name>
                                        <value>${nzPassportDob}</value>
                                    </input>         
                                    <input>
                                        <name>greenid_nzpassport_tandc</name>
                                        <value>${nzPassportTandC}</value>
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
