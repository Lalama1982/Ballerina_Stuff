import ballerina/io;

public function getAusCentrelinkPayload(json reqPayload, json regDetails) returns (xml)|error {
    string loc = "auscentrelink";
    io:println(loc, "-getAusCentrelinkPayload: reqPayload >> " + reqPayload.toString());

    string accountId = check regDetails.accountId;
    string password = check regDetails.password;
    string verifyId = check reqPayload.verifyId;
    
    string ausCLCardType = check reqPayload.ausCLCardType;
    string ausCLNumber = check reqPayload.ausCLNumber;
    string ausCLNameOnCards = check reqPayload.ausCLNameOnCards;
    string ausCLDob = check reqPayload.ausCLDob;
    string ausCLExpiry = check reqPayload.ausCLExpiry;
    string ausCLTandC = check reqPayload.ausCLTandC;

    xml payloadXml = xml `<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:dyn="http://dynamicform.services.registrations.edentiti.com/">
                            <soapenv:Body>
                                <dyn:setFields>
                                <accountId>${accountId}</accountId>
                                <password>${password}</password>
                                <verificationId>${verifyId}</verificationId>
                                <greenIdWebVerificationToken></greenIdWebVerificationToken>
                                <sourceId>centrelinkdvs</sourceId>
                                <inputFields>
                                    <input>
                                        <name>greenid_centrelinkdvs_cardType</name>
                                        <value>${ausCLCardType}</value>
                                    </input>
                                    <input>
                                        <name>greenid_centrelinkdvs_number</name>
                                        <value>${ausCLNumber}</value>
                                    </input>
                                    <input>
                                        <name>greenid_centrelinkdvs_nameOnCard</name>
                                        <value>${ausCLNameOnCards}</value>
                                    </input>                
                                    <input>
                                        <name>greenid_centrelinkdvs_dob</name>
                                        <value>${ausCLDob}</value>
                                    </input>
                                    <input>
                                        <name>greenid_centrelinkdvs_expiry</name>
                                        <value>${ausCLExpiry}</value>
                                    </input>       
                                    <input>
                                        <name>greenid_centrelinkdvs_tandc</name>
                                        <value>${ausCLTandC}</value>
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
