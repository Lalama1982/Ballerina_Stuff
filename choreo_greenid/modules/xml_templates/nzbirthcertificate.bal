import ballerina/io;

public function getNzBirthCertPayload(json reqPayload, json regDetails) returns (xml)|error {
    string loc = "nzbirthcertificate";
    io:println(loc, "-getNzBirthCertPayload: reqPayload >> " + reqPayload.toString());

    string accountId = check regDetails.accountId;
    string password = check regDetails.password;
    string verifyId = check reqPayload.verifyId;
    
    string nzBCGivenName = check reqPayload.nzBCGivenName;
    string nzBCMiddleName = check reqPayload.nzBCMiddleName;
    string nzBCSurname = check reqPayload.nzBCSurname;
    string nzBCDob = check reqPayload.nzBCDob;
    string nzBCIssueDate = check reqPayload.nzBCIssueDate;
    string nzBCRegNo = check reqPayload.nzBCRegNo;
    string nzBCTandC = check reqPayload.nzBCTandC;

    xml payloadXml = xml `<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:dyn="http://dynamicform.services.registrations.edentiti.com/">
                            <soapenv:Body>
                                <dyn:setFields>
                                <accountId>${accountId}</accountId>
                                <password>${password}</password>
                                <verificationId>${verifyId}</verificationId>
                                <greenIdWebVerificationToken></greenIdWebVerificationToken>
                                <sourceId>nzbirthcertificate</sourceId>
                                <inputFields>
                                    <input>
                                    <name>greenid_nzbirthcertificate_givenname</name>
                                    <value>${nzBCGivenName}</value>
                                    </input>
                                    <input>
                                    <name>greenid_nzbirthcertificate_middlename</name>
                                    <value>${nzBCMiddleName}</value>
                                    </input>
                                    <input>
                                    <name>greenid_nzbirthcertificate_surname</name>
                                    <value>${nzBCSurname}</value>
                                    </input>                
                                    <input>
                                    <name>greenid_nzbirthcertificate_dob</name>
                                    <value>${nzBCDob}</value>
                                    </input>
                                    <input>
                                    <name>greenid_nzbirthcertificate_issuedate</name>
                                    <value>${nzBCIssueDate}</value>
                                    </input>
                                    <input>
                                    <name>greenid_nzbirthcertificate_regno</name>
                                    <value>${nzBCRegNo}</value>
                                    </input>                                   
                                    <input>
                                    <name>greenid_nzbirthcertificate_tandc</name>
                                    <value>${nzBCTandC}</value>
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
