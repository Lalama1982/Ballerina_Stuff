import ballerina/http;
import ballerina/io;

public function mergeEmplPostalAddr(http:Client dssClient, string epHost, int hdrSeq = 0, int dtlSer = 2, int hdrFlag = 1, string address2Line1 = "address2Line1", 
                     string address2Line2 = "address2Line2", string address2City = "address2City", string address2Postalcode = "address2Postalcode",
                     string address2State = "address2State", string address2Country = "address2Country", string recMsg = "recMsg") returns json|error? {

    http:Request reqHdr = new;
    reqHdr.setHeader("Content-Type", "application/json");
    reqHdr.setHeader("Accept", "application/json");
    reqHdr.setHeader("Host", epHost);

    // tbl_user_empl_postal_addr
    json|error respJson = check dssClient->/postInsertEmplPostalAddr.post({    
        "_postInsertEmplPostalAddr": {
            "hdrSeq": hdrSeq,
            "dtlSer": dtlSer,
            "recSts": hdrFlag,
            "address2Line1": address2Line1,
            "address2Line2": address2Line2,
            "address2City": address2City,
            "address2Postalcode": address2Postalcode,
            "address2State": address2State,
            "address2Country": address2Country,
            "recMsg": recMsg
        }          
    });

    if respJson is error {
        io:println("mergeEmplPostalAddr :: Failed to merge DSS Employer Postal Address", respJson);
        return;
    }  
      
    //io:println(`mergeEmplPostalAddr :: respJson : ${respJson}`);
    return respJson;

}
