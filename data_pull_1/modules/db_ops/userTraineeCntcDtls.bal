import ballerina/http;
import ballerina/io;

public function mergeTraineeCntcDtls(http:Client dssClient, string epHost,
                                    int hdrSeq = 0, int dtlSer = 2, int hdrFlag = 1, string telePhone2 = "telePhone2,", 
                                    string mobilePhone = "mobilePhone", string emailAddress1 = "emailAddress1", 
                                    string recMsg = "recMsg") returns json|error? {

    http:Request reqHdr = new;
    reqHdr.setHeader("Content-Type", "application/json");
    reqHdr.setHeader("Accept", "application/json");
    reqHdr.setHeader("Host", epHost);

    // tbl_user_traineecntc_dtls
    json|error respJson = check dssClient->/postInsertTraineeCntcDtls.post({    
        "_postInsertTraineeCntcDtls": {
            "hdrSeq": hdrSeq,
            "dtlSer": dtlSer,
            "recSts": hdrFlag,
            "telePhone2": telePhone2,
            "mobilePhone": mobilePhone,
            "emailAddress1": emailAddress1,
            "recMsg": recMsg
        }          
    });

    if respJson is error {
        io:println("mergeTraineeCntcDtls :: Failed to merge DSS CNTC Trainee Details", respJson);
        return;
    }    
    
    //io:println(`mergeTraineeCntcDtls :: respJson : ${respJson}`);
    return respJson;
}
