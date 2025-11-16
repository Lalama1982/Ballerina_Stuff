import ballerina/time;
import ballerina/io;
public function getDates(string execEnv) returns json|error{

    // get currrent date in UTC
    time:Utc currentUTC = time:utcNow();

    //based on exec. env. set previous date
    time:Utc previousUTC = time:utcAddSeconds(currentUTC, -86400);

    if execEnv == "uat" {
        previousUTC = time:utcAddSeconds(previousUTC, -31536000);
    }    
    string previousUTCString = time:utcToString(previousUTC);

    // previous date to melb time
    previousUTCString = previousUTCString + "[Australia/Melbourne]";
    io:println(`getDates :: previousUTCString-3: ${previousUTCString}`);
    time:Civil prevMelbTime = check time:civilFromString(previousUTCString); //json

    string prevMelbTime_str = check time:civilToString(prevMelbTime);     

    // construct melb from & to dates
    string[] splittedValues1 = re `-`.split(prevMelbTime_str);
    string melbYearPrev = splittedValues1[0];
    string melbMonthPrev = splittedValues1[1];

    splittedValues1 = re `T`.split(splittedValues1[2]);
    string melbDayPrev = splittedValues1[0];

    //2025-08-13T00:00:00Z
    string fromDateAU = string `${melbYearPrev}-${melbMonthPrev}-${melbDayPrev}T00:00:00Z`;
    string toDateAU = string `${melbYearPrev}-${melbMonthPrev}-${melbDayPrev}T23:59:59Z`;
    io:println(`getDates :: fromDateAU (str) = ${fromDateAU}`);
    io:println(`getDates :: toDateAU (str) = ${toDateAU}`);

    // get utc from & to dates
    // format change : 2024-08-13T00:00:00Z >> 2024-08-13T00:00:00+10:00
    string:RegExp r = re `Z`;
    string fAU = r.replace(fromDateAU, "+10:00");
    string tAU = r.replace(toDateAU, "+10:00");

    r = re `T`;
    time:Utc|time:Error uu = time:utcFromString(string `${fAU}`);
    string fromDateUTC = r.replace((time:utcToString(check uu)),"%20");
    io:println(`getDates :: fromDateUTC (str) = ${fromDateUTC}`);

    uu = time:utcFromString(string `${tAU}`);
    string toDateUTC = r.replace(time:utcToString(check uu),"%20");
    io:println(`getDates :: toDateUTC (str) = ${toDateUTC}`);

    json datesJson = {"fromDateAU": fromDateAU, "toDateAU": toDateAU, "fromDateUTC": fromDateUTC, "toDateUTC": toDateUTC};
    return datesJson;    
}