import ballerina/io;

public function getAusImmiCardPayload(json reqPayload, json regDetails) returns (xml)|error {
    string loc = "ausimmicard";
    io:println(loc, "-getAusImmiCardPayload: reqPayload >> " + reqPayload.toString());

    string accountId = check regDetails.accountId;
    string password = check regDetails.password;
    string verifyId = check reqPayload.verifyId;
    
    string ausImmiCardNo = check reqPayload.ausImmiCardNo;
    string ausImmiGivenName = check reqPayload.ausImmiGivenName;
    string ausImmiSurname = check reqPayload.ausImmiSurname;
    string ausImmiMiddleName = check reqPayload.ausImmiMiddleName;
    string ausImmiDob = check reqPayload.ausImmiDob;
    string ausImmiTandC = check reqPayload.ausImmiTandC;

    xml payloadXml = xml `<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:dyn="http://dynamicform.services.registrations.edentiti.com/">
                            <soapenv:Body>
                                <dyn:setFields>
                                <accountId>${accountId}</accountId>
                                <password>${password}</password>
                                <verificationId>${verifyId}</verificationId>
                                <greenIdWebVerificationToken></greenIdWebVerificationToken>
                                <sourceId>immicarddvs</sourceId>
                                <inputFields>
                                    <input>
                                        <name>greenid_immicarddvs_card_number</name>
                                        <value>${ausImmiCardNo}</value>
                                    </input>
                                    <input>
                                        <name>greenid_immicarddvs_givenname</name>
                                        <value>${ausImmiGivenName}</value>
                                    </input>
                                    <input>
                                        <name>greenid_citizenshipcertificatedvs_surname</name>
                                        <value>${ausImmiSurname}</value>
                                    </input>                
                                    <input>
                                        <name>greenid_immicarddvs_middlename</name>
                                        <value>${ausImmiMiddleName}</value>
                                    </input>
                                    <input>
                                        <name>greenid_immicarddvs_surname</name>
                                        <value>${ausImmiSurname}</value>
                                    </input>
                                    <input>
                                        <name>greenid_immicarddvs_dob</name>
                                        <value>${ausImmiDob}</value>
                                    </input>
                                    <input>
                                        <name>greenid_immicarddvs_tandc</name>
                                        <value>${ausImmiTandC}</value>
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
