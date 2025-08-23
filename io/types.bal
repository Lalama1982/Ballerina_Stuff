import ballerina/log;

public type TestType record {|
    string courseSubject;
    string result;
    string resultDate;
    int highestOrder = 0;
|};

public function main() returns error? {
    TestType rec0 =  { courseSubject: "courseSubject-1", result: "result-1", resultDate: "resultDate-1" };

    TestType[] recArr = [rec0]; 
    log:printInfo(`courseSubject = ${recArr[0].courseSubject}`);
    log:printInfo(`result = ${recArr[0].result}`);
    log:printInfo(`resultDate = ${recArr[0].resultDate}`);

   TestType[] recM = [
        {courseSubject: "CS-1", result: "R-1", resultDate: "RD-1"},
        {courseSubject: "CS-2", result: "R-2", resultDate: "RD-2"}
    ];

    foreach TestType rec in recM {
        log:printInfo(`courseSubject = ${rec.courseSubject}`);
        log:printInfo(`result = ${rec.result}`);
        log:printInfo(`resultDate = ${rec.resultDate}`);
    }   

    log:printInfo(`*************************************`);

    //json j0 =  { courseSubject: "courseSubject-1", result: "result-1", resultDate: "resultDate-1" };
    json[] jArr = [ 
                    { courseSubject: "CS-1", result: "R-1", resultDate: "RD-1" },
                    { courseSubject: "CS-2", result: "R-2", resultDate: "RD-2" },
                    { courseSubject: "CS-3", result: "R-3", resultDate: "RD-3" }
                  ];
        
    int i = 0;
    TestType[] recA = [];  
    foreach json j in jArr {
       log:printInfo(j.toJsonString());
       //string courseSubject = check j.courseSubject;
       TestType rec =  { courseSubject: check j.courseSubject, 
                         result: check j.result, 
                         resultDate: check j.resultDate };
        recA[i] = rec;                          
    }    
    
}