import ballerina/io;

public function getAusBirthCertPayload(json reqPayload, json regDetails) returns (xml)|error {
    string loc = "ausbirthcertificate";
    io:println(loc, "-getAusBirthCertPayload: reqPayload >> " + reqPayload.toString());

    string accountId = check regDetails.accountId;
    string password = check regDetails.password;
    string verifyId = check reqPayload.verifyId;
    
    string ausBCRegNo = check reqPayload.ausBCRegNo;
    string ausBCRegState = check reqPayload.ausBCRegState;
    string ausBCGivenName = check reqPayload.ausBCGivenName;
    string ausBCSurname = check reqPayload.ausBCSurname;
    string ausBCDob = check reqPayload.ausBCDob;
    string ausBCTandC = check reqPayload.ausBCTandC;
    string ausBCRegYear = check reqPayload.ausBCRegYear;
    string ausBCRegDate = check reqPayload.ausBCRegDate;
    string ausBCCertNo = check reqPayload.ausBCCertNo;
    string ausBCPrintDate = check reqPayload.ausBCPrintDate;
    string ausBCMidName = check reqPayload.ausBCMidName;

    xml payloadXml = xml `<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:dyn="http://dynamicform.services.registrations.edentiti.com/">
                            <soapenv:Body>
                                <dyn:setFields>
                                <accountId>${accountId}</accountId>
                                <password>${password}</password>
                                <verificationId>${verifyId}</verificationId>
                                <greenIdWebVerificationToken></greenIdWebVerificationToken>
                                <sourceId>birthcertificatedvs</sourceId>
                                <inputFields>
                                    <input>
                                        <name>greenid_birthcertificatedvs_registration_number</name>
                                        <value>${ausBCRegNo}</value>
                                    </input>
                                    <input>
                                        <name>greenid_birthcertificatedvs_registration_state</name>
                                        <value>${ausBCRegState}</value>
                                    </input>
                                    <input>
                                        <name>greenid_birthcertificatedvs_givenname</name>
                                        <value>${ausBCGivenName}</value>
                                    </input>                
                                    <input>
                                        <name>greenid_birthcertificatedvs_surname</name>
                                        <value>${ausBCSurname}</value>
                                    </input>
                                    <input>
                                        <name>greenid_birthcertificatedvs_dob</name>
                                        <value>${ausBCDob}</value>
                                    </input>
                                    <input>
                                        <name>greenid_birthcertificatedvs_tandc</name>
                                        <value>${ausBCTandC}</value>
                                    </input>
                                    <input>
                                        <name>greenid_birthcertificatedvs_registration_year</name>
                                        <value>${ausBCRegYear}</value>
                                    </input>                                     
                                    <input>
                                        <name>greenid_birthcertificatedvs_registration_date</name>
                                        <value>${ausBCRegDate}</value>
                                    </input>  
                                    <input>
                                        <name>greenid_birthcertificatedvs_certificate_number</name>
                                        <value>${ausBCCertNo}</value>
                                    </input>  
                                    <input>
                                        <name>greenid_birthcertificatedvs_certificate_printed_date</name>
                                        <value>${ausBCPrintDate}</value>
                                    </input>  
                                    <input>
                                        <name>greenid_birthcertificatedvs_middlename</name>
                                        <value>${ausBCMidName}</value>
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
