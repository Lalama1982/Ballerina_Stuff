import ballerina/http;
import ballerina/io;

public function mergeEmplPrimaryCntc(http:Client dssClient, string epHost, int hdrSeq = 0, int dtlSer = 2, int hdrFlag = 1, string telePhone1 = "telePhone1", 
                     string mobilePhone = "mobilePhone", string firstName = "firstName", string lastName = "lastName",
                     string recMsg = "recMsg") returns json|error? {

    http:Request reqHdr = new;
    reqHdr.setHeader("Content-Type", "application/json");
    reqHdr.setHeader("Accept", "application/json");
    reqHdr.setHeader("Host", epHost);

    // tbl_user_empl_primary_cntc
    json|error respJson = check dssClient->/postInsertEmplPrimaryCntc.post({    
        "_postInsertEmplPrimaryCntc": {
            "hdrSeq": hdrSeq,
            "dtlSer": dtlSer,
            "recSts": hdrFlag,
            "telePhone1": telePhone1,
            "mobilePhone": mobilePhone,
            "firstName": firstName,
            "lastName": lastName,
            "recMsg": recMsg
        }          
    });

    if respJson is error {
        io:println("mergeEmplPrimaryCntc :: Failed to merge DSS Employer Primary Contact", respJson);
        return;
    }    
    
    //io:println(`mergeEmplPrimaryCntc :: respJson : ${respJson}`);
    return respJson;

}
