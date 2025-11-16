import ballerina/http;
import ballerina/io;

public function mergeEmplDtls(http:Client dssClient, string epHost, 
                    int hdrSeq = 0, int dtlSer = 2, int hdrFlag = 1, string hsdUseridentifier = "hsdUseridentifier", 
                    string hsdLegalname = "hsdLegalname", string hsdName = "hsdName", string emailAddress1 = "emailAddress1",
                    string hsdAbn = "hsdAbn", string recMsg = "recMsg") returns json|error? {

    http:Request reqHdr = new;
    reqHdr.setHeader("Content-Type", "application/json");
    reqHdr.setHeader("Accept", "application/json");
    reqHdr.setHeader("Host", epHost);

    // tbl_user_empl_dtls
    json|error respJson = check dssClient->/postInsertEmplDtls.post({    
        "_postInsertEmplDtls": {
            "hdrSeq": hdrSeq,
            "dtlSer": dtlSer,
            "recSts": hdrFlag,
            "hsdUseridentifier": hsdUseridentifier,
            "hsdLegalname": hsdLegalname,
            "hsdName": hsdName,
            "emailAddress1": emailAddress1,
            "hsdAbn": hsdAbn,
            "recMsg": recMsg
        }          
    });

    if respJson is error {
        io:println("mergeEmplDtls :: Failed to merge DSS Employer Details", respJson);
        return;
    }   
     
    //io:println(`mergeEmplDtls :: respJson : ${respJson}`);
    return respJson;

}
