import ballerina/http;
import ballerina/io;

public function mergeDetails(http:Client dssClient, string epHost, 
                             int hdrSeq = 0, int dtlSer = 2, int dtlFlag = 1, string recMsg = "recMsg") returns error? {

    http:Request reqHdr = new;
    reqHdr.setHeader("Content-Type", "application/json");
    reqHdr.setHeader("Accept", "application/json");
    reqHdr.setHeader("Host", epHost);

    // tbl_user_dtl
    json|error respJson = check dssClient->/postInsertDtl.post({    
        "_postInsertDtl": {
            "hdrSeq": hdrSeq,
            "dtlSer": dtlSer,
            "recSts": dtlFlag,
            "recMsg": recMsg
        }          
    });

    if respJson is error {
        io:println("mergeDetails :: Failed to merge DSS Details", respJson);
        return;
    }    

    //io:println(`mergeDetails :: respJson : ${respJson}`);

}
