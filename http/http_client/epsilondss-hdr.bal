import ballerina/http;
import ballerina/io;

string urlDss = "https://24c9c232-84f9-4788-ae7a-597a7e4f2b87-nonprod.nonprod.hgln.choreoapis.dev/epsilonintegration/epsilonintegrationdss/v1.0/services/DS_Epsilon_Intg_DSS";
string dssToken = "eyJ4NXQiOiIyM3BHLUFiR1RrVGFqd0JSX2FwZTlRVS13MDAiLCJraWQiOiJaV0poT0RWak5XUmpNR0l6WldObVpUQXdOR0UzTnpabE5EQmtOMlprWWpZM1ltTmxaRE15WlRSaVptTmxZVGRtTmpZMk1qTXhNV0k0T0RjMU1EZGtaQV9SUzI1NiIsInR5cCI6ImF0K2p3dCIsImFsZyI6IlJTMjU2In0.eyJzdWIiOiIzODlaS3JSZ0p4ZnZjN2JLbzlOdEg3WjR4bFVhIiwiYXV0IjoiQVBQTElDQVRJT04iLCJpc3MiOiJodHRwczpcL1wvYXBpLmFzZ2FyZGVvLmlvXC90XC9ob2xtZXNnbGVuXC9vYXV0aDJcL3Rva2VuIiwiY2xpZW50X2lkIjoiMzg5WktyUmdKeGZ2YzdiS285TnRIN1o0eGxVYSIsImF1ZCI6WyIzODlaS3JSZ0p4ZnZjN2JLbzlOdEg3WjR4bFVhIiwiY2hvcmVvOmRlcGxveW1lbnQ6c2FuZGJveCJdLCJuYmYiOjE3NDg4NTY5MDQsImF6cCI6IjM4OVpLclJnSnhmdmM3YktvOU50SDdaNHhsVWEiLCJvcmdfaWQiOiIyNGM5YzIzMi04NGY5LTQ3ODgtYWU3YS01OTdhN2U0ZjJiODciLCJleHAiOjE3ODAzOTI5MDQsIm9yZ19uYW1lIjoiaG9sbWVzZ2xlbiIsImlhdCI6MTc0ODg1NjkwNCwianRpIjoiYjllZjg4N2EtYWE3NC00YWUzLWEwZDQtZjVhNjEzZjEzMDkwIiwib3JnX2hhbmRsZSI6ImhvbG1lc2dsZW4ifQ.eLBdeJn9C_Zl_9y0qSrZ23Ob91W3QWOnzmA2iy7oNBwsFXUKIr4RkpQpn_z-KknBGX5eQHGSnrTe_KEQk4oujHh0cxcncnUjS3z2ABlAAIFk_ESR63xUcXFSWTF6Jos5gtGPB-wdp_Wh6-aexLPazZ7S_omC-Cy5E0noK_nBq5c7dQSa0nRUCtwY-Cljy8CNlUjcTrgkQwvGLiplfV8XFYtPa7c8nAvHoC7d-ACuuhWErgKCdlHt1gif-au5qLbAKEAw94I1ezDZUfrBRGaoC3h1b6tt3P7Sy6cNYo8lUoB-EVbTGqsx5WWH6QjCLVT7LiOOP_8oSQFz8HDQX70qMA";
string host = "24c9c232-84f9-4788-ae7a-597a7e4f2b87-nonprod.nonprod.hgln.choreoapis.dev";

decimal timeout = 15;
http:HttpVersion httpVersion = http:HTTP_1_1;

public function main(int hdrSeq = 0, int hdrFlag = 1, string fromDateAU = "i_from_date_au", string toDateAU = "i_to_date_au",
        string fromDateUTC = "i_from_date_utc", string toDateUTC = "i_to_date_utc", string hdrMsg = "io_rec_msg") returns error? {

    http:BearerTokenConfig bearerConfig = {
        token: dssToken
    };
    //http:Client|error hdrClient = new (urlDss, {timeout, httpVersion});
    http:Client|error hdrClient = check new (urlDss, auth = bearerConfig, timeout = timeout, httpVersion = httpVersion);

    if hdrClient is error {
        io:println("Failed to initialize DSS Header HTTP client", hdrClient);
        return;
    }
    io:println(string `Initialized DSS Header HTTP client with URL: ${urlDss}, timeout: ${timeout}, HTTP version: ${httpVersion}`);

    http:Request reqHdr = new;
    reqHdr.setHeader("Content-Type", "application/json");
    reqHdr.setHeader("Accept", "application/json");
    //reqHdr.setHeader("Authorization", "Bearer " + dssToken);
    reqHdr.setHeader("Host", host);

    // string hdrBody = string `
    // "_postInsertHdr": {
    //     "hdrSeq": ${hdrSeq},
    //     "recSts": ${hdrFlag},
    //     "fromDateAU": ${fromDateAU},
    //     "toDateAU": ${toDateAU},
    //     "fromDateUTC": ${fromDateUTC},
    //     "toDateUTC": ${toDateUTC},
    //     "recMsg": ${hdrMsg} 
    // }`;
    // //reqHdr.setJsonPayload(hdrBody);

    //json respJson = check hdrClient->/postInsertHdr.post(reqHdr);
    json respJson = check hdrClient->/postInsertHdr.post({
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
    io:println(`respJson : ${respJson}`);

    //return respJson;

}
