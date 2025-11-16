import ballerina/io;

public function getAusMedicarePayload(json reqPayload, json regDetails) returns (xml)|error {
    string loc = "ausmedicare";
    io:println(loc, "-getAusMedicarePayload: reqPayload >> " + reqPayload.toString());

    string accountId = check regDetails.accountId;
    string password = check regDetails.password;

    string verifyId = check reqPayload.verifyId;
    string medicareCardColor = check reqPayload.medicareCardColor;
    string medicareNo = check reqPayload.medicareNo;
    string medicareRefNo = check reqPayload.medicareRefNo;
    string medicareNameOnCard = check reqPayload.medicareNameOnCard;
    string medicareDob = check reqPayload.medicareDob;
    string medicareExpiry = check reqPayload.medicareExpiry;
    string medicareTaC = check reqPayload.medicareTaC;

    xml payloadXml = xml `<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:dyn="http://dynamicform.services.registrations.edentiti.com/">
                            <soapenv:Body>
                                <dyn:setFields>
                                <accountId>${accountId}</accountId>
                                <password>${password}</password>
                                <verificationId>${verifyId}</verificationId>
                                <greenIdWebVerificationToken></greenIdWebVerificationToken>
                                <sourceId>medicaredvs</sourceId>
                                <inputFields>
                                    <input>
                                        <name>greenid_medicaredvs_cardColour</name>
                                        <value>${medicareCardColor}</value>
                                    </input>
                                    <input>
                                        <name>greenid_medicaredvs_number</name>
                                        <value>${medicareNo}</value>
                                    </input>
                                    <input>
                                        <name>greenid_medicaredvs_individualReferenceNumber</name>
                                        <value>${medicareRefNo}</value>
                                    </input>                
                                    <input>
                                        <name>greenid_medicaredvs_nameOnCard</name>
                                        <value>${medicareNameOnCard}</value>
                                    </input>
                                    <input>
                                        <name>greenid_medicaredvs_dob</name>
                                        <value>${medicareDob}</value>
                                    </input>
                                    <input>
                                        <name>greenid_medicaredvs_expiry</name>
                                        <value>${medicareExpiry}</value>
                                    </input>
                                    <input>
                                        <name>greenid_medicaredvs_tandc</name>
                                        <value>${medicareTaC}</value>
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
