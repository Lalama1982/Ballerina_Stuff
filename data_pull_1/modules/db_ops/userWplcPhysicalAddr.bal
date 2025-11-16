import ballerina/http;
import ballerina/io;

public function mergeWplcPhysicalAddr(http:Client dssClient, string epHost, int hdrSeq = 0, int dtlSer = 2, int hdrFlag = 1, string address1Line1 = "address1Line1", 
                     string address1Line2 = "address1Line2", string address1City = "address1City", string address1Postalcode = "address1Postalcode",
                     string address1State = "address1State", string address1Country = "address1Country", string recMsg = "recMsg") returns json|error? {

    http:Request reqHdr = new;
    reqHdr.setHeader("Content-Type", "application/json");
    reqHdr.setHeader("Accept", "application/json");
    reqHdr.setHeader("Host", epHost);

    // tbl_user_wplc_physical_addr
    json|error respJson = check dssClient->/postInsertWplcPhysicalAddr.post({    
        "_postInsertWplcPhysicalAddr": {
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
        io:println("mergeWplcPhysicalAddr :: Failed to merge DSS WPLC Physical Address", respJson);
        return;
    }    
    
    //io:println(`mergeWplcPhysicalAddr :: respJson : ${respJson}`);
    return respJson;

}
