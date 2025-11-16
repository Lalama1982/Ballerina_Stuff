import ballerina/http;
import ballerina/io;

public function mergeTrainingCntrcDtls(http:Client dssClient, string epHost, 
                    int hdrSeq = 0, int dtlSer = 2, int hdrFlag = 1, string hsdTrainingcontractstatus = "hsdTrainingcontractstatus", 
                    string hsdUseridentifier = "hsdUseridentifier", string hsdCommencementdate = "hsdCommencementdate", string hsdNominalcompletiondate = "hsdNominalcompletiondate",
                    string hsdProbationperiod = "hsdProbationperiod", string hsdDeterminationcode = "hsdDeterminationcode", string hsdDeterminationname = "hsdDeterminationname", 
                    string hsdStatuschanged = "hsdStatuschanged",  string hsdTrainingorganisationid = "hsdTrainingorganisationid", string hsdTerminationdate = "hsdTerminationdate",  
                    string hsdSchoolname = "hsdSchoolname", string hsdSchemetype = "hsdSchemetype", string recMsg = "recMsg") returns json|error? {

    http:Request reqHdr = new;
    reqHdr.setHeader("Content-Type", "application/json");
    reqHdr.setHeader("Accept", "application/json");
    reqHdr.setHeader("Host", epHost);

    // tbl_user_training_cntrc_dtls
    json|error respJson = check dssClient->/postInsertTrainingCntrcDtls.post({    
        "_postInsertTrainingCntrcDtls": {
            "hdrSeq": hdrSeq,
            "dtlSer": dtlSer,
            "recSts": hdrFlag,
            "hsdTrainingcontractstatus": hsdTrainingcontractstatus,
            "hsdUseridentifier": hsdUseridentifier,
            "hsdCommencementdate": hsdCommencementdate,
            "hsdNominalcompletiondate": hsdNominalcompletiondate,
            "hsdProbationperiod": hsdProbationperiod,
            "hsdDeterminationcode": hsdDeterminationcode,
            "hsdDeterminationname": hsdDeterminationname,
            "hsdStatuschanged": hsdStatuschanged,
            "hsdTrainingorganisationid": hsdTrainingorganisationid,
            "hsdTerminationdate": hsdTerminationdate,
            "hsdSchoolname": hsdSchoolname,
            "hsdSchemetype": hsdSchemetype,
            "recMsg": recMsg
        }          
    });

    if respJson is error {
        io:println("mergeTrainingCntrcDtls :: Failed to merge DSS Training Contract Details", respJson);
        return;
    }    
    
    //io:println(`mergeTrainingCntrcDtls :: respJson : ${respJson}`);
    return respJson;

}
