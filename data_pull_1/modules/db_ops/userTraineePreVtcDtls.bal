import ballerina/http;
import ballerina/io;

public function mergeTraineePreVtcDtls(http:Client dssClient, string epHost,
                                    int hdrSeq = 0, int dtlSer = 2, int hdrFlag = 1, 
                                    string hsdPrevioustrainingcontract = "hsdPrevioustrainingcontract", 
                                    string recMsg = "recMsg") returns json|error? {

    http:Request reqHdr = new;
    reqHdr.setHeader("Content-Type", "application/json");
    reqHdr.setHeader("Accept", "application/json");
    reqHdr.setHeader("Host", epHost);

    // tbl_user_traineeprevtc_dtls
    json|error respJson = check dssClient->/postInsertTraineePrevtcDtls.post({    
        "_postInsertTraineePrevtcDtls": {
            "hdrSeq": hdrSeq,
            "dtlSer": dtlSer,
            "recSts": hdrFlag,
            "hsdPrevioustrainingcontract": hsdPrevioustrainingcontract,
            "recMsg": recMsg
        }          
    });

    if respJson is error {
        io:println("mergeTraineePreVtcDtls :: Failed to merge DSS Trainee Pre-VTC Details", respJson);
        return;
    }    
    
    //io:println(`mergeTraineePreVtcDtls :: respJson : ${respJson}`);
    return respJson;

}
