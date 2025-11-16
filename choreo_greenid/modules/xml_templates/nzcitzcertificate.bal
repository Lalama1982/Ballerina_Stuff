import ballerina/io;

public function getNzCitzCertPayload(json reqPayload, json regDetails) returns (xml)|error {
    string loc = "nzbirthcertificate";
    io:println(loc, "-getNzCitzCertPayload: reqPayload >> " + reqPayload.toString());

    string accountId = check regDetails.accountId;
    string password = check regDetails.password;
    string verifyId = check reqPayload.verifyId;
    
    string nzCitzGivenName = check reqPayload.nzCitzGivenName;
    string nzCitzMiddleName = check reqPayload.nzCitzMiddleName;
    string nzCitzSurname = check reqPayload.nzCitzSurname;
    string nzCitzDob = check reqPayload.nzCitzDob;
    string nzCitzIssueDate = check reqPayload.nzCitzIssueDate;
    string nzCitzCertNo = check reqPayload.nzCitzCertNo;
    string nzCitzTandC = check reqPayload.nzCitzTandC;

    xml payloadXml = xml `<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:dyn="http://dynamicform.services.registrations.edentiti.com/">
                            <soapenv:Body>
                                <dyn:setFields>
                                <accountId>${accountId}</accountId>
                                <password>${password}</password>
                                <verificationId>${verifyId}</verificationId>
                                <greenIdWebVerificationToken></greenIdWebVerificationToken>
                                <sourceId>nzcitizenship</sourceId>
                                <inputFields>
                                    <input>
                                        <name>greenid_nzcitizenship_givenname</name>
                                        <value>${nzCitzGivenName}</value>
                                    </input>
                                    <input>
                                        <name>greenid_nzcitizenship_middlename</name>
                                        <value>${nzCitzMiddleName}</value>
                                    </input>
                                    <input>
                                        <name>greenid_nzcitizenship_surname</name>
                                        <value>${nzCitzSurname}</value>
                                    </input>                
                                    <input>
                                        <name>greenid_nzcitizenship_dob</name>
                                        <value>${nzCitzDob}</value>
                                    </input>
                                    <input>
                                        <name>greenid_nzcitizenship_issuedate</name>
                                        <value>${nzCitzIssueDate}</value>
                                    </input>
                                    <input>
                                        <name>greenid_nzcitizenship_certno</name>
                                        <value>${nzCitzCertNo}</value>
                                    </input>
                                    <input>
                                        <name>greenid_nzcitizenship_tandc</name>
                                        <value>${nzCitzTandC}</value>
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
