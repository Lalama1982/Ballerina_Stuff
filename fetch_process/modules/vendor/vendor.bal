import ballerina/http;
import ballerina/io;
import ballerina/log;
import ballerina/lang.array;

# Returns the string `Hello` with the input string name.
#
# + name - name as a string or nil
# + return - "Hello, " with the input string name
public function hello(string? name) returns string {
    if name !is () {
        return string `Hello from dbOps, ${name}`;
    }
    return "Hello, World!";
}

# Description : returns user ID for the BKSB ID
#
# + vendorClient - HTTP Client for Client EP  
# + vendorHost - "Host" header for Client EP
# + vendorId - BKSB ID
# + rResp - message from main
# + return - user ID
public function getBksbUserId(http:Client vendorClient, string vendorHost,
        string vendorId = "", string rResp = "rResp") returns json|error? {

    json|error respJson = check vendorClient->get(string `/users/user/getUserId?username=${vendorId}`,
        headers = {
            "Accept": "application/json",
            "Host": vendorHost
        }
    );

    if respJson is error {
        io:println("getBksbUserId :: Failed to fetch Client user id", respJson);
        return;
    }

    //io:println(`getBksbUserId :: respJson : ${respJson}`);
    return respJson;
}

# Description : returns Client results
#
# + vendorClient - HTTP Client for Client EP  
# + vendorHost - "Host" header for Client EP
# + vendorUserId - user ID of the BKSB ID  
# + rResp - message from main
# + return - result set
public function getBksbResults(http:Client vendorClient, string vendorHost,
        string vendorUserId = "", string rResp = "rResp") returns ResultsRecord|error {

    ResultsRecord|error respResults = check vendorClient->get(string `/results/initialAssessment/${vendorUserId}/all?page=1&recordsPerPage=20`,
        headers = {
            "Accept": "application/json",
            "Host": vendorHost
        }
    );

    if respResults is error {
        log:printInfo("getBksbResults :: Failed to fetch Client Results", respResults);
        return error(string `getBksbResults :: Failed to fetch Client Results :: ${respResults.toString()}`);
    }

    //log:printInfo(`getBksbResults :: respResults : ${respResults}`);
    return respResults;
}

# Description : Processing the result set for each BKSB ID
# - to return highest & latest result & date out from array of results
# + vendorUserId - user ID of the BKSB ID
# + initAssesments - results set for BKSB ID
# + return - return highest & latest result & date
public function processResults(string vendorUserId, InitialAssessmentResultsItem[] initAssesments) returns map<json> {
    //log:printInfo(`processResults :: initAssesments : ${initAssesments}`);

    string resp = "";
    int i = 1;

    Assesment[] assesmentMaths = [];
    int m = 0;
    Assesment[] assesmentEnglish = [];
    int e = 0;
    Assesment[] assesmentDigital = [];
    int d = 0;

    foreach InitialAssessmentResultsItem item in initAssesments {
        //log:printInfo(`processResults :: ${i} = ${item.toJsonString()}`);

        string? courseSubject = item.CourseSubject;
        string? resultDate = item.ResultDate;
        string? result = item.Result;
        //int sessionId = item.SessionId;
        //string? courseName = item.CourseName;           
        //string? assessmentName = item.AssessmentName;
        //int? assessmentID = item.AssessmentID;

        //log:printInfo(`processResults :: ${i} - ${vendorUserId} >> ${courseSubject} || ${result} on ${resultDate}`);

        if (courseSubject == "OZ_MATHS") {
            string? resultFormatted;    
            int? resultOrder;

            ResultMap[] foundResultMap = from var p in resultMap
                                where p.result == result
                                select p;

            if foundResultMap == [] {
                log:printError(`processResults :: [${i}] - ${vendorUserId} :: Mapping for Maths Result not exists or errored`);
                resultFormatted = string `Mapping for Maths Result not exists or errored`;
                resultOrder = 0;
            } else {                    
                resultFormatted = foundResultMap[0].resultFormatted;
                resultOrder = foundResultMap[0].resultOrder;
            }

            // log:printInfo(`processResults [M-A]:: result: ${result}`);
            // log:printInfo(`processResults [B]:: resultFormatted: ${resultFormatted}`);                
            // log:printInfo(`processResults [C]:: resultOrder: ${resultOrder}`);

            Assesment recM = {courseSubject: courseSubject,
                            result: result ?: "",
                            resultDate: resultDate ?: "",
                            highestOrder: resultOrder ?: 0,
                            resultFormatted: resultFormatted ?: ""};

            assesmentMaths[m] = recM;
            m += 1;
        }

        if (courseSubject == "OZ_ENG") {
            ResultMap[] foundResultMap = from var p in resultMap
                                where p.result == result
                                select p;

            string? resultFormatted = foundResultMap[0].resultFormatted;
            int? resultOrder = foundResultMap[0].resultOrder;

            // log:printInfo(`processResults [E-A]:: result: ${result}`);

            Assesment recE = {courseSubject: courseSubject,
                            result: result ?: "",
                            resultDate: resultDate ?: "",
                            highestOrder: resultOrder ?: 0,
                            resultFormatted: resultFormatted ?: ""};

            assesmentEnglish[e] = recE;         
            e += 1;
        }

        if (courseSubject == "OZ_DIGI") {      
            ResultMap[] foundResultMap = from var p in resultMap
                                where p.result == result
                                select p;

            string? resultFormatted = foundResultMap[0].resultFormatted;
            int? resultOrder = foundResultMap[0].resultOrder;

            // log:printInfo(`processResults [D-A]:: result: ${result}`);

            Assesment recD = {courseSubject: courseSubject,
                            result: result ?: "",
                            resultDate: resultDate ?: "",
                            highestOrder: resultOrder ?: 0,
                            resultFormatted: resultFormatted ?: ""};

            assesmentDigital[d] = recD;
            d += 1;
        }

        i = i + 1;
    }

    if assesmentMaths == [] {    
        log:printInfo(`processResults :: ${vendorUserId} >> No MATHS Results`);
        resp = "processResults :: No MATHS Results";
        //return error(string `processResults :: No MATHS Results`); 
    } else {
        log:printInfo(`processResults :: ${vendorUserId} >> MATHS Results populated`);
        resp = "processResults :: MATHS Results populated";
        //return error(string `processResults :: MATHS Results populated`);

        // foreach Assesment am in assesmentMaths {
        //     log:printInfo(`XXXXXXXXXXXX - ${vendorUserId} >> M-courseSubject = ${am.courseSubject}`);
        //     log:printInfo(`XXXXXXXXXXXX - ${vendorUserId} >> M-result = ${am.result}`);
        //     log:printInfo(`XXXXXXXXXXXX - ${vendorUserId} >> M-resultDate = ${am.resultDate}`);
        //     log:printInfo(`XXXXXXXXXXXX - ${vendorUserId} >> M-highestOrder = ${am.highestOrder}`);
        //     log:printInfo(`XXXXXXXXXXXX - ${vendorUserId} >> M-resultFormatted = ${am.resultFormatted}`);
        //     log:printInfo(`XXXXXXXXXXXX - ${vendorUserId} >> M-resultDateFormatted = ${am.resultDateFormatted}`);
        // }

    }

    if assesmentEnglish == [] {
        log:printInfo(`processResults :: ${vendorUserId} >> No ENGLISH Results`);
        resp = "processResults :: No ENGLISH Results";
        //return error(string `processResults :: No ENGLISH Results`); 
    } else {
        log:printInfo(`processResults :: ${vendorUserId} >> ENGLISH Results populated`);
        resp = "processResults :: ENGLISH Results populated";
        //return error(string `processResults :: ENGLISH Results populated`);  
             
    }

    if assesmentDigital == [] {
        log:printInfo(`processResults :: ${vendorUserId} >> No DIGITAL Results`);
        resp = "processResults :: No DIGITAL Results";
        //return error(string `processResults :: No DIGITAL Results`); 
    } else {
        log:printInfo(`processResults :: ${vendorUserId} >> DIGITAL Results populated`);
        resp = "processResults :: DIGITAL Results populated";
        //return error(string `processResults :: DIGITAL Results populated`);  
             
    }

    // log:printInfo(`%%%%%%%%%%%%%%%%%%%%%%%%%%%`);
    // foreach ResultMap rec in resultMap {
    //     log:printInfo(`result = ${rec.result}`);
    //     log:printInfo(`resultFormatted = ${rec.resultFormatted}`);
    //     log:printInfo(`resultOrder = ${rec.resultOrder}`);
    // }  
    // log:printInfo(`%%%%%%%%%%%%%%%%%%%%%%%%%%%`);

    // Client returns a sorted data set with latest being the first, hence the use of [0]
    string mathDateLatest = "";
    string mathResultLatest = "";
    string mathResultLatestFormatted = "";
    string mathDateHighest = "";
    string mathResultHighest = "";
    string mathResultHighestFormatted = "";
    if assesmentMaths != [] {
        mathDateLatest = assesmentMaths[0].resultDate+"Z"; //string `mathDateLatest`;
        mathResultLatest = assesmentMaths[0].result;
        mathResultLatestFormatted = assesmentMaths[0].resultFormatted ?: "";

        // foreach Assesment am in assesmentMaths {
        //     log:printInfo(`BEFORE SORTING - ${vendorUserId} >> M-courseSubject = ${am.courseSubject}`);
        //     log:printInfo(`BEFORE SORTING - ${vendorUserId} >> M-result = ${am.result}`);
        //     log:printInfo(`BEFORE SORTING - ${vendorUserId} >> M-resultDate = ${am.resultDate}`);
        //     log:printInfo(`BEFORE SORTING - ${vendorUserId} >> M-highestOrder = ${am.highestOrder}`);
        //     log:printInfo(`BEFORE SORTING - ${vendorUserId} >> M-resultFormatted = ${am.resultFormatted}`);
        //     log:printInfo(`BEFORE SORTING - ${vendorUserId} >> M-resultDateFormatted = ${am.resultDateFormatted}`);
        // }        

        Assesment[] assesmentMathsSorted = assesmentMaths.sort(array:DESCENDING, (item) => item.highestOrder);
        mathDateHighest = assesmentMathsSorted[0].resultDate+"Z";
        mathResultHighest = assesmentMathsSorted[0].result;
        mathResultHighestFormatted = assesmentMathsSorted[0].resultFormatted ?: "";

        // foreach Assesment am in assesmentMathsSorted {
        //     log:printInfo(`AFTER SORTING - ${vendorUserId} >> M-courseSubject = ${am.courseSubject}`);
        //     log:printInfo(`AFTER SORTING - ${vendorUserId} >> M-result = ${am.result}`);
        //     log:printInfo(`AFTER SORTING - ${vendorUserId} >> M-resultDate = ${am.resultDate}`);
        //     log:printInfo(`AFTER SORTING - ${vendorUserId} >> M-highestOrder = ${am.highestOrder}`);
        //     log:printInfo(`AFTER SORTING - ${vendorUserId} >> M-resultFormatted = ${am.resultFormatted}`);
        //     log:printInfo(`AFTER SORTING - ${vendorUserId} >> M-resultDateFormatted = ${am.resultDateFormatted}`);
        // }   

    }

    string englDateLatest = "";
    string englResultLatest = "";
    string englResultLatestFormatted = "";
    string englDateHighest = "";
    string englResultHighest = "";
    string englResultHighestFormatted = "";
    if assesmentEnglish != [] {
        englDateLatest = assesmentEnglish[0].resultDate+"Z";
        englResultLatest = assesmentEnglish[0].result;
        englResultLatestFormatted = assesmentEnglish[0].resultFormatted ?: "";

        Assesment[] assesmentEnglishSorted = assesmentEnglish.sort(array:DESCENDING, (item) => item.highestOrder);
        englDateHighest = assesmentEnglishSorted[0].resultDate+"Z";
        englResultHighest = assesmentEnglishSorted[0].result;
        englResultHighestFormatted = assesmentEnglishSorted[0].resultFormatted ?: "";        
    }

    string digiDateLatest = "";
    string digiResultLatest = "";
    string digiResultLatestFormatted = "";
    string digiDateHighest = "";
    string digiResultHighest = "";
    string digiResultHighestFormatted = "";
    if assesmentDigital != [] {
        digiDateLatest = assesmentDigital[0].resultDate+"Z";
        digiResultLatest = assesmentDigital[0].result;
        digiResultLatestFormatted = assesmentDigital[0].resultFormatted ?: "";

        Assesment[] assesmentDigitalSorted = assesmentDigital.sort(array:DESCENDING, (item) => item.highestOrder);
        digiDateHighest = assesmentDigitalSorted[0].resultDate+"Z";
        digiResultHighest = assesmentDigitalSorted[0].result;
        digiResultHighestFormatted = assesmentDigitalSorted[0].resultFormatted ?: "";
    }

    // log:printInfo(`processResults :: mathDateLatest : ${mathDateLatest}`);
    // log:printInfo(`processResults :: mathResultLatest : ${mathResultLatest}`);
    // log:printInfo(`processResults :: mathResultLatestFormatted : ${mathResultLatestFormatted}`);
    // log:printInfo(`processResults :: mathDateHighest : ${mathDateHighest}`);
    // log:printInfo(`processResults :: mathResultHighest : ${mathResultHighest}`);
    // log:printInfo(`processResults :: mathResultHighestFormatted : ${mathResultHighestFormatted}`);

    // log:printInfo(`processResults :: englDateLatest : ${englDateLatest}`);
    // log:printInfo(`processResults :: englResultLatest : ${englResultLatest}`);
    // log:printInfo(`processResults :: englResultLatestFormatted : ${englResultLatestFormatted}`);
    // log:printInfo(`processResults :: englDateHighest : ${englDateHighest}`);
    // log:printInfo(`processResults :: englResultHighest : ${englResultHighest}`);
    // log:printInfo(`processResults :: englResultHighestFormatted : ${englResultHighestFormatted}`);

    // log:printInfo(`processResults :: digiDateLatest : ${digiDateLatest}`);
    // log:printInfo(`processResults :: digiResultLatest : ${digiResultLatest}`);
    // log:printInfo(`processResults :: digiResultLatestFormatted : ${digiResultLatestFormatted}`);
    // log:printInfo(`processResults :: digiDateHighest : ${digiDateHighest}`);
    // log:printInfo(`processResults :: digiResultHighest : ${digiResultHighest}`);
    // log:printInfo(`processResults :: digiResultHighestFormatted : ${digiResultHighestFormatted}`);

    return {
        "mathDateLatest": mathDateLatest,
        "mathResultLatest": mathResultLatest,
        "mathResultLatestFormatted": mathResultLatestFormatted,
        "mathDateHighest": mathDateHighest,
        "mathResultHighest": mathResultHighest,
        "mathResultHighestFormatted": mathResultHighestFormatted,
        "englDateLatest": englDateLatest,
        "englResultLatest": englResultLatest,
        "englResultLatestFormatted": englResultLatestFormatted,
        "englDateHighest": englDateHighest,
        "englResultHighest": englResultHighest,
        "englResultHighestFormatted": englResultHighestFormatted,
        "digiDateLatest": digiDateLatest,
        "digiResultLatest": digiResultLatest,
        "digiResultLatestFormatted": digiResultLatestFormatted,
        "digiDateHighest": digiDateHighest,
        "digiResultHighest": digiResultHighest,
        "digiResultHighestFormatted": digiResultHighestFormatted,
        "resp": resp
    };
}
