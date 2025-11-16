import ballerina/http;
import ballerina/io;

public function mergeAnpDtls(http:Client dssClient, string epHost,
                             int hdrSeq = 0, int dtlSer = 2, int hdrFlag = 1, string hsdUseridentifier = "hsdUseridentifier", 
                             string hsdLegalname = "hsdLegalname", string recMsg = "recMsg") returns json|error? {

    http:Request reqHdr = new;
    reqHdr.setHeader("Content-Type", "application/json");
    reqHdr.setHeader("Accept", "application/json");
    reqHdr.setHeader("Host", epHost);

    // tbl_user_anp_dtls
    json|error respJson = check dssClient->/postInsertTrainingAnpDtls.post({    
        "_postInsertTrainingAnpDtls": {
            "hdrSeq": hdrSeq,
            "dtlSer": dtlSer,
            "recSts": hdrFlag,
            "hsdUseridentifier": hsdUseridentifier,
            "hsdLegalname": hsdLegalname,
            "recMsg": recMsg
        }          
    });

    if respJson is error {
        io:println("mergeAnpDtls :: Failed to merge DSS Training ANP Details", respJson);
        return;
    }    
    
    //io:println(`mergeAnpDtls :: respJson : ${respJson}`);
    return respJson;

}
