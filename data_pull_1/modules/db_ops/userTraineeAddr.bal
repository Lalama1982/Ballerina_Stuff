import ballerina/http;
import ballerina/io;

public function mergeTraineeAddr(http:Client dssClient, string epHost, 
                    int hdrSeq = 0, int dtlSer = 2, int hdrFlag = 1, string address2Line1 = "address2Line1", 
                    string address2Line2 = "address2Line2", string address2City = "address2City", string address2Postalcode = "address2Postalcode",
                    string hsdAddress2state = "hsdAddress2state", string hsdAddress2country = "hsdAddress2country", string recMsg = "recMsg") returns json|error? {

    http:Request reqHdr = new;
    reqHdr.setHeader("Content-Type", "application/json");
    reqHdr.setHeader("Accept", "application/json");
    reqHdr.setHeader("Host", epHost);

    // tbl_user_trainee_addr
    json|error respJson = check dssClient->/postInsertTraineeAddr.post({    
        "_postInsertTraineeAddr": {
            "hdrSeq": hdrSeq,
            "dtlSer": dtlSer,
            "recSts": hdrFlag,
            "address2Line1": address2Line1,
            "address2Line2": address2Line2,
            "address2City": address2City,
            "address2Postalcode": address2Postalcode,
            "hsdAddress2state": hsdAddress2state,
            "hsdAddress2country": hsdAddress2country,
            "recMsg": recMsg
        }          
    });

    if respJson is error {
        io:println("mergeTraineeAddr :: Failed to merge DSS Trainee Addresses", respJson);
        return;
    }    
    
    //io:println(`mergeTraineeAddr :: respJson : ${respJson}`);
    return respJson;

}
