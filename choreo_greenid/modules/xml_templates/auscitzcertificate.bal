import ballerina/io;

public function getAusCitzCertPayload(json reqPayload, json regDetails) returns (xml)|error {
    string loc = "auscitzcertificate";
    io:println(loc, "-getAusCitzCertPayload: reqPayload >> " + reqPayload.toString());

    string accountId = check regDetails.accountId;
    string password = check regDetails.password;
    string verifyId = check reqPayload.verifyId;
    
    string ausCitzGivenName = check reqPayload.ausCitzGivenName;
    string ausCitzMiddleName = check reqPayload.ausCitzMiddleName;
    string ausCitzSurname = check reqPayload.ausCitzSurname;
    string ausCitzStockNum = check reqPayload.ausCitzStockNum;
    string ausCitzAcquisitionDate = check reqPayload.ausCitzAcquisitionDate;
    string ausCitzDob = check reqPayload.ausCitzDob;
    string ausCitzTandC = check reqPayload.ausCitzTandC;

    xml payloadXml = xml `<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:dyn="http://dynamicform.services.registrations.edentiti.com/">
                            <soapenv:Body>
                                <dyn:setFields>
                                <accountId>${accountId}</accountId>
                                <password>${password}</password>
                                <verificationId>${verifyId}</verificationId>
                                <greenIdWebVerificationToken></greenIdWebVerificationToken>
                                <sourceId>citizenshipcertificatedvs</sourceId>
                                <inputFields>
                                    <input>
                                    <name>greenid_citizenshipcertificatedvs_givenname</name>
                                    <value>${ausCitzGivenName}</value>
                                    </input>
                                    <input>
                                    <name>greenid_citizenshipcertificatedvs_middlename</name>
                                    <value>${ausCitzMiddleName}</value>
                                    </input>
                                    <input>
                                    <name>greenid_citizenshipcertificatedvs_surname</name>
                                    <value>${ausCitzSurname}</value>
                                    </input>                
                                    <input>
                                    <name>greenid_citizenshipcertificatedvs_stock_number</name>
                                    <value>${ausCitzStockNum}</value>
                                    </input>
                                    <input>
                                    <name>greenid_citizenshipcertificatedvs_acquisition_date</name>
                                    <value>${ausCitzAcquisitionDate}</value>
                                    </input>
                                    <input>
                                    <name>greenid_citizenshipcertificatedvs_dob</name>
                                    <value>${ausCitzDob}</value>
                                    </input>
                                    <input>
                                    <name>greenid_citizenshipcertificatedvs_tandc</name>
                                    <value>${ausCitzTandC}</value>
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
