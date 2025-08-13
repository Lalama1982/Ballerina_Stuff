import ballerina/http;
import ballerina/io;

string url = "https://wwwstg.eduweb.vic.gov.au/EpsilonRTOInterface";
string host = "wwwstg.eduweb.vic.gov.au";
//http:Client endpoint = check new (url);
decimal timeout = 15;
http:HttpVersion httpVersion = http:HTTP_1_1;
string tokenPwd = "Epsilon678*";
string tokenUid = "ECHTES";
string tokenToid = "0416";

//public string urlDss = "https://24c9c232-84f9-4788-ae7a-597a7e4f2b87-nonprod.nonprod.hgln.choreoapis.dev/epsilonintegration/epsilonintegrationdss/v1.0/services/DS_Epsilon_Intg_DSS";

public function main() returns error? {

    http:Client|error epsilonTokenClient = new (url, {timeout, httpVersion});

    if epsilonTokenClient is error {
        io:println("Failed to initialize an HTTP client for token", epsilonTokenClient);
        return;
    }
    io:println(string `Initialized client for token with URL: ${url}, timeout: ${timeout}, HTTP version: ${httpVersion}`);
    io:println("------------------------------------------------------------");

    // TOKEN Retrieval
    //string tokenBody = string `grant_type=password&username=ECHTES&password=Epsilon678*&toid=0416&AuthMethod=FormsAuthenticationresource`;
    string tokenBody = string `grant_type=password&username=${tokenUid}&password=${tokenPwd}&toid=${tokenToid}&AuthMethod=FormsAuthenticationresource`;
    io:println(`tokenBody : ${tokenBody}`);

    http:Request reqToken = new;
    reqToken.setHeader("Content-Type", "application/x-www-form-urlencoded; charset=UTF-8");
    reqToken.setHeader("Host", host);
    reqToken.setPayload(tokenBody);

    http:Response resToken = new;
    //json tokenResp = check epsilonTokenClient->/token.post(reqToken);
    resToken = check epsilonTokenClient->/token.post(reqToken);
    io:println("statusCode >> ", resToken.statusCode);

    json tokenResp = check resToken.getJsonPayload();
    io:println(`tokenResp : ${tokenResp}`);

    string token = check tokenResp.access_token;
    io:println(`token : ${token}`);

    io:println("========================================");

    // CONTRACT Retrieval
    string startDate = "2025-02-23%2000:00:00Z";
    string endDate = "2025-02-27%2023:59:59Z";
    string contractPath = string `/${tokenToid}?startdate=${startDate}&enddate=${endDate}`;
    io:println(`contractPath : ${contractPath}`);

    //http:Request reqContracts = new;
    //string accessToken = string `Bearer ${token}`;
    //io:println(`accessToken : ${accessToken}`);
    //reqContracts.setHeader("Authorization", accessToken);
    //json contracts = check epsilonClient->/api/trainingcontracts/[tokenToid](startdate=startDate, enddate=endDate);
    //http:Response contractResp = check epsilonClient->get("/api/trainingcontracts/0416?startdate=2025-02-23%2000%3A00%3A00Z&enddate=2025-02-27%2023%3A59%3A59Z)",reqContracts);

    // Create a BearerTokenConfig
    http:BearerTokenConfig bearerConfig = {
        token: token
    };

    string contractUrl = string `${url}/api/trainingcontracts`;
    io:println(`contractUrl : ${contractUrl}`);
    http:Client|error epsilonContractsClient = check new (contractUrl, auth = bearerConfig);

    if epsilonContractsClient is error {
        io:println("Failed to initialize an HTTP client for contracts", epsilonContractsClient);
        return;
    }
    io:println(string `Initialized client for contracts with URL: ${url}, timeout: ${timeout}, HTTP version: ${httpVersion}`);

    json[] contracts = check epsilonContractsClient->get(contractPath);
    //io:println(`contracts : ${contracts}`);

    //io:println("+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++");

    json firstRecJ = contracts[0];
    //io:println("firstRecJ : ", firstRecJ);

    string hsd_epsilonidentifier = check firstRecJ.Trainee.TraineeDetails.hsd_epsilonidentifier;
    io:println(`hsd_epsilonidentifier - 1st : ${hsd_epsilonidentifier}`);
}