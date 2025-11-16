import ballerina/http;
import ballerina/io;

public function mergeEmplPhysicalAddr(http:Client dssClient, string epHost, 
                    int hdrSeq = 0, int dtlSer = 2, int hdrFlag = 1, string address1Line1 = "address1Line1", 
                    string address1Line2 = "address1Line2", string address1City = "address1City", string address1Postalcode = "address1Postalcode",
                    string address1State = "address1State", string address1Country = "address1Country", string recMsg = "recMsg") returns json|error? {

    http:Request reqHdr = new;
    reqHdr.setHeader("Content-Type", "application/json");
    reqHdr.setHeader("Accept", "application/json");
    reqHdr.setHeader("Host", epHost);

    // tbl_user_empl_physical_addr
    json|error respJson = check dssClient->/postInsertEmplPhysicalAddr.post({    
        "_postInsertEmplPhysicalAddr": {
            "hdrSeq": hdrSeq,
            "dtlSer": dtlSer,
            "recSts": hdrFlag,
            "address1Line1": address1Line1,
            "address1Line2": address1Line2,
            "address1City": address1City,
            "address1Postalcode": address1Postalcode,
            "address1State": address1State,
            "address1Country": address1Country,
            "recMsg": recMsg
        }          
    });

    if respJson is error {
        io:println("mergeEmplPhysicalAddr :: Failed to merge DSS Employer Physical Address", respJson);
        return;
    }   
     
    //io:println(`mergeEmplPhysicalAddr :: respJson : ${respJson}`);
    return respJson;

}
