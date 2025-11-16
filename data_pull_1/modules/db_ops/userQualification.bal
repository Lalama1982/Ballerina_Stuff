import ballerina/http;
import ballerina/io;

public function mergeQualification(http:Client dssClient, string epHost,
                    int hdrSeq = 0, int dtlSer = 2, int hdrFlag = 1, string hsdCode = "hsdCode", 
                    string hsdDeltacode = "hsdDeltacode", string hsdQualificationname = "hsdQualificationname", string hsdVersion = "hsdVersion",
                    string recMsg = "recMsg") returns json|error? {

    http:Request reqHdr = new;
    reqHdr.setHeader("Content-Type", "application/json");
    reqHdr.setHeader("Accept", "application/json");
    reqHdr.setHeader("Host", epHost);

    // tbl_user_qualification
    json|error respJson = check dssClient->/postInsertTrainingQualification.post({    
        "_postInsertTrainingQualification": {
            "hdrSeq": hdrSeq,
            "dtlSer": dtlSer,
            "recSts": hdrFlag,
            "hsdCode": hsdCode,
            "hsdDeltacode": hsdDeltacode,
            "hsdQualificationname": hsdQualificationname,
            "hsdVersion": hsdVersion,
            "recMsg": recMsg
        }          
    });

    if respJson is error {
        io:println("mergeQualification :: Failed to merge DSS Training Qualification", respJson);
        return;
    }    
    
    //io:println(`mergeQualification :: respJson : ${respJson}`);
    return respJson;

}
