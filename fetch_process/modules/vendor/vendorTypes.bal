public type InitialAssessmentResultsItem record {|
    int SessionId;
    string CourseSubject;
    string CourseName;
    string ResultDate;
    string AssessmentName;
    int AssessmentID;
    string Result;
    json...;
|};

public type Pagination record {|
    int CurrentPage;
    int TotalRecords;
    int RecordsPerPage;
    json...;
|};

public type ResultsRecord record {|
    InitialAssessmentResultsItem[] InitialAssessmentResults?;
    Pagination Pagination;
    json...;
|};

public type Assesment record {|
    string courseSubject?;
    string result;
    string resultDate;
    int highestOrder;
    string resultFormatted?;
    string resultDateFormatted?;
|};

public type ResultMap record {|
    string result;
    string resultFormatted;
    int resultOrder;
|};

// public type ResultMapSet record {|
//     ResultMap[] mapRec;
// |};

public ResultMap[] resultMap = [
    {result: "Maths ACSF Pre Level 1", resultFormatted: "L000", resultOrder: 1},
    {result: "Maths ACSF L1", resultFormatted: "L010", resultOrder: 2},
    {result: "Maths ACSF L2", resultFormatted: "L020", resultOrder: 3},
    {result: "Maths ACSF EXIT LEVEL 2 (Working at Level 3)", resultFormatted: "L023", resultOrder: 4},
    {result: "Maths ACSF EXIT LEVEL 3 (Working at Level 4)", resultFormatted: "L034", resultOrder: 5},
    {result: "Maths ACSF L5", resultFormatted: "L050", resultOrder: 6},
    {result: "English ACSF Pre Level 1", resultFormatted: "L000", resultOrder: 1},
    {result: "English ACSF L1", resultFormatted: "L010", resultOrder: 2},
    {result: "English ACSF L2", resultFormatted: "L020", resultOrder: 3},
    {result: "English ACSF EXIT LEVEL 2 (Working at Level 3)", resultFormatted: "L023", resultOrder: 4},
    {result: "English ACSF EXIT LEVEL 3 (Working at Level 4)", resultFormatted: "L034", resultOrder: 5},
    {result: "English ACSF L5", resultFormatted: "L050", resultOrder: 6}
];