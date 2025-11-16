import ballerina/http;
import ballerina/io;

public function mergerHeader(http:Client hdrClient, string epHost,
        int hdrSeq = 0, int hdrFlag = 1, string fromDateAU = "i_from_date_au", string toDateAU = "i_to_date_au",
        string fromDateUTC = "i_from_date_utc", string toDateUTC = "i_to_date_utc", string hdrMsg = "io_rec_msg") returns json|error? {

    http:Request reqHdr = new;
    reqHdr.setHeader("Content-Type", "application/json");
    reqHdr.setHeader("Accept", "application/json");
    reqHdr.setHeader("Host", epHost);

    json|error respJson = check hdrClient->/postInsertHdr.post({
        "_postInsertHdr": {
            "hdrSeq": hdrSeq,
            "recSts": hdrFlag,
            "fromDateAU": fromDateAU,
            "toDateAU": toDateAU,
            "fromDateUTC": fromDateUTC,
            "toDateUTC": toDateUTC,
            "recMsg": hdrMsg 
        }        
    });

    if respJson is error {
        io:println("mergerHeader :: Failed to merge DSS Header", respJson);
        return;
    } 

    //io:println(`mergerHeader :: respJson : ${respJson}`);
    return respJson;

}
