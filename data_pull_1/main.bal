import ballerina/http;
import ballerina/io;

import data_pull_1.db_ops;

configurable string url = ?;
configurable string host = ?;
configurable string tokenPwd = ?;
configurable string tokenUid = ?;
configurable string tokenToid = ?;
configurable string urlDss = ?;
configurable string tokenDss = ?;
configurable string hostDss = ?;
configurable string dssToken = ?;
configurable string execEnv = ?;

decimal timeout = 15;
http:HttpVersion httpVersion = http:HTTP_1_1;

http:BearerTokenConfig dssBearerConfig = {
    token: dssToken
};
http:Client|error dssClient = check new (urlDss, auth = dssBearerConfig, timeout = timeout, httpVersion = httpVersion);

public function main() returns error? {

    if dssClient is error {
        io:println("Failed to initialize DSS DB HTTP client", dssClient);
        return;
    }
    io:println(string `main :: Initialized client for DSS DB with URL: ${urlDss}, timeout: ${timeout}, HTTP version: ${httpVersion}`);

    json datesJson = check getDates(execEnv);
    string fromDateAU = check datesJson.fromDateAU;
    string toDateAU = check datesJson.toDateAU;
    string fromDateUTC = check datesJson.fromDateUTC;
    string toDateUTC = check datesJson.toDateUTC;

    string hdrMsg = "#Begin[Choreo]#";
    json hdrResp = check db_ops:mergerHeader(check dssClient, epHost = hostDss,
            hdrSeq = 0, hdrFlag = 1, fromDateAU = fromDateAU, toDateAU = toDateAU,
            fromDateUTC = fromDateUTC, toDateUTC = toDateUTC, hdrMsg = hdrMsg);

    int hdrSeq;
    do {
        hdrSeq = check int:fromString(check hdrResp.response.io_seq);
    } on fail error e {
        io:println("Process sequence not fetched or errored", e);
        hdrResp = check db_ops:mergerHeader(check dssClient, epHost = hostDss,
                hdrSeq = 0, hdrFlag = 0, fromDateAU = fromDateAU, toDateAU = toDateAU,
                fromDateUTC = fromDateUTC, toDateUTC = toDateUTC,
                hdrMsg = string `${hdrMsg} | Process sequence not fetched: ${e.toString()} | #End[Choreo]#`);
        return;
    }

    io:println(`main :: hdrSeq = ${hdrSeq}`);

    http:Client|error tokenClient = new (url, {timeout, httpVersion});

    if tokenClient is error {
        io:println("Failed to initialize an HTTP client for token", tokenClient);
        hdrResp = check db_ops:mergerHeader(check dssClient, epHost = hostDss,
                hdrSeq = hdrSeq, hdrFlag = 0, fromDateAU = fromDateAU, toDateAU = toDateAU,
                fromDateUTC = fromDateUTC, toDateUTC = toDateUTC,
                hdrMsg = string `${hdrMsg} | Failed to initialize an HTTP client for token: ${tokenClient.toString()} | #End[Choreo]#`);
        return;
    }
    io:println(string `main :: Initialized client for token with URL: ${url}, timeout: ${timeout}, HTTP version: ${httpVersion}`);

    // TOKEN Retrieval
    string tokenBody = string `grant_type=password&username=${tokenUid}&password=${tokenPwd}&toid=${tokenToid}&AuthMethod=FormsAuthenticationresource`;
    //io:println(`tokenBody : ${tokenBody}`);

    http:Request reqToken = new;
    reqToken.setHeader("Content-Type", "application/x-www-form-urlencoded; charset=UTF-8");
    reqToken.setHeader("Host", host);
    reqToken.setPayload(tokenBody);

    http:Response|error resToken = new;
    resToken = check tokenClient->/token.post(reqToken);
    if resToken is error {
        io:println("Token Fetch Failed: ", resToken);
        hdrResp = check db_ops:mergerHeader(check dssClient, epHost = hostDss,
                hdrSeq = hdrSeq, hdrFlag = 0, fromDateAU = fromDateAU, toDateAU = toDateAU,
                fromDateUTC = fromDateUTC, toDateUTC = toDateUTC,
                hdrMsg = string `${hdrMsg} | Token Fetch Failed: ${resToken.toString()} | #End[Choreo]#`);
        return;
    }
    int tokenHttpStatus = resToken.statusCode;
    io:println("main :: tokenHttpStatus >> ", tokenHttpStatus);

    json tokenResp = check resToken.getJsonPayload();
    //io:println(`tokenResp : ${tokenResp}`);

    string token = check tokenResp.access_token;
    io:println(`main :: token received: ${token}`);

    // CONTRACT Retrieval
    // TESTING for null contracts(JSON)
    // string startDate = "2024-08-17%2014:00:00Z"; // fromDateUTC;
    // string endDate = "2024-08-18%2013:59:59Z"; //toDateUTC;
    // TESTING for null contracts(JSON)
    string startDate = fromDateUTC;
    string endDate = toDateUTC;

    string contractPath = string `/${tokenToid}?startdate=${startDate}&enddate=${endDate}`;
    io:println(`main :: contractPath : ${contractPath}`);

    // Create a BearerTokenConfig
    http:BearerTokenConfig bearerConfig = {
        token: token
    };

    string contractUrl = string `${url}/api/trainingcontracts`;
    io:println(`main :: contractUrl : ${contractUrl}`);
    http:Client|error userContractsClient = check new (contractUrl, auth = bearerConfig);

    if userContractsClient is error {
        io:println("Failed to initialize an HTTP client for contracts", userContractsClient);
        hdrResp = check db_ops:mergerHeader(check dssClient, epHost = hostDss,
                hdrSeq = hdrSeq, hdrFlag = 0, fromDateAU = fromDateAU, toDateAU = toDateAU,
                fromDateUTC = fromDateUTC, toDateUTC = toDateUTC,
                hdrMsg = string `${hdrMsg} | Failed to initialize an HTTP client for contracts: ${userContractsClient.toString()} | #End[Choreo]#`);
        return;
    }
    io:println(string `main :: Initialized client for contracts with URL: ${url}, timeout: ${timeout}, HTTP version: ${httpVersion}`);

    //http:Response|error resContracts = new;
    json[]|error contracts = check userContractsClient->get(contractPath);       

    //resContracts = check userContractsClient->get(contractPath);
    if contracts is error {
        io:println("main :: Contract Fetch Failed: ", contracts);
        hdrResp = check db_ops:mergerHeader(check dssClient, epHost = hostDss,
                hdrSeq = hdrSeq, hdrFlag = 0, fromDateAU = fromDateAU, toDateAU = toDateAU,
                fromDateUTC = fromDateUTC, toDateUTC = toDateUTC,
                hdrMsg = string `${hdrMsg} | contract Fetch Failed: ${contracts.toString()} | #End[Choreo]#`);
        return;
    } 

    if contracts.length() == 0 {
        io:println("main :: No Contracts to fetch");
        hdrResp = check db_ops:mergerHeader(check dssClient, epHost = hostDss,
                hdrSeq = hdrSeq, hdrFlag = 1, fromDateAU = fromDateAU, toDateAU = toDateAU,
                fromDateUTC = fromDateUTC, toDateUTC = toDateUTC,
                hdrMsg = string `${hdrMsg} | No Contracts to fetch | #End[Choreo]#`);
        return;
    } 

    json? firstRecJ = contracts[0];
    io:println("main :: firstRecJ : ", firstRecJ);

    // json? firstRecJ;
    // do {
    //     firstRecJ = contracts[0];
    //     io:println("main :: firstRecJ : ", firstRecJ);
    // }  on fail error e {
    //         io:println(string `No Contracts to process : ${e.toString()}`);
    //         hdrResp = check db_ops:mergerHeader(check dssClient, epHost = hostDss,
    //                 hdrSeq = hdrSeq, hdrFlag = 1, fromDateAU = fromDateAU, toDateAU = toDateAU,
    //                 fromDateUTC = fromDateUTC, toDateUTC = toDateUTC,
    //                 hdrMsg = string `No Contracts to process | #End[Choreo]#`);
    //         return;
    // }
    
    string hsd_useridentifier = check firstRecJ.Trainee.TraineeDetails.hsd_useridentifier;
    io:println(`main :: hsd_useridentifier - 1st : ${hsd_useridentifier}`);

    json|error processJson = contractsProcessing(check dssClient, hdrSeq, contracts);

    if processJson is error {
        io:println("Contracts processing failed : ", processJson);
        hdrResp = check db_ops:mergerHeader(check dssClient, epHost = hostDss,
                hdrSeq = hdrSeq, hdrFlag = 0, fromDateAU = fromDateAU, toDateAU = toDateAU,
                fromDateUTC = fromDateUTC, toDateUTC = toDateUTC,
                hdrMsg = string `${hdrMsg} | Contracts processing failed | #End[Choreo]#`);
        return;
    }

    hdrMsg = hdrMsg + " | Processed | #End[Choreo]#";
    hdrResp = check db_ops:mergerHeader(check dssClient, epHost = hostDss,
            hdrSeq = hdrSeq, hdrFlag = 1, fromDateAU = fromDateAU, toDateAU = toDateAU,
            fromDateUTC = fromDateUTC, toDateUTC = toDateUTC, hdrMsg = hdrMsg);

    io:println(`main :: hdrMsg : ${hdrMsg}`);

}
