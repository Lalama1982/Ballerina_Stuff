import ballerina/http;
import ballerina/io;

public function mergeTraineeDtls(http:Client dssClient, string epHost,
                                int hdrSeq = -1, int dtlSer = -2, int hdrFlag = 1, string hsdUseridentifier = "hsdUseridentifier,", 
                                string firstName = "firstName", string lastName = "lastName", string hsdGender = "hsdGender", string hsdDob = "hsdDob", 
                                string hsdUsi = "hsdUsi", string hsdHasadisability = "hsdHasadisability", string hsdCitizenshipstatus = "hsdCitizenshipstatus", 
                                string recMsg = "recMsg") returns json|error? {
    http:Request reqHdr = new;
    reqHdr.setHeader("Content-Type", "application/json");
    reqHdr.setHeader("Accept", "application/json");
    reqHdr.setHeader("Host", epHost);

    json|error respJson = check dssClient->/postInsertTraineeDtls.post({ //xx
        "_postInsertTraineeDtls": {
            "hdrSeq": hdrSeq,
            "dtlSer": dtlSer,
            "recSts": hdrFlag,
            "hsdUseridentifier": hsdUseridentifier,
            "firstName": firstName,
            "lastName": lastName,
            "hsdGender": hsdGender,
            "hsdDob": hsdDob,
            "hsdUsi": hsdUsi,
            "hsdHasadisability": hsdHasadisability,
            "hsdCitizenshipstatus": hsdCitizenshipstatus,
            "recMsg": recMsg
        }
    });

    if respJson is error {
        io:println("mergeTraineeDtls :: Failed to merge DSS Trainee Details", respJson);
        return;
    }
    
    //io:println(`mergeTraineeDtls :: respJson : ${respJson}`);
    return respJson;
}
