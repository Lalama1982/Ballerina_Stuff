import ballerina/io;
import ballerina/time;

public function main() returns error? {
    string execEnv = "uat";
    // get currrent date in UTC
    time:Utc currentUTC = time:utcNow();
    string currentUTCString = time:utcToString(currentUTC);
    io:println(`currentUTCString: ${currentUTCString}`);

    //based on exec. env. set previous date
    time:Utc previousUTC = time:utcAddSeconds(currentUTC, -86400);     
    io:println(`previousUTCString-1: ${time:utcToString(previousUTC)}`);

    if execEnv == "uat" {
        previousUTC = time:utcAddSeconds(previousUTC, -31536000);
    }    
    string previousUTCString = time:utcToString(previousUTC);
    io:println(`previousUTCString-2: ${previousUTCString}`);

    // previous date to melb time
    previousUTCString = previousUTCString + "[Australia/Melbourne]";
    io:println(`previousUTCString-3: ${previousUTCString}`);
    time:Civil prevMelbTime = check time:civilFromString(previousUTCString); //json
    io:println("prevMelbTime toString(): " + prevMelbTime.toString());    

    string prevMelbTime_str = check time:civilToString(prevMelbTime);     
    io:println("prevMelbTime_str: " + prevMelbTime_str);

    // construct melb from & to dates
    string[] splittedValues1 = re `-`.split(prevMelbTime_str);
    string melbYearPrev = splittedValues1[0];
    string melbMonthPrev = splittedValues1[1];

    splittedValues1 = re `T`.split(splittedValues1[2]);
    string melbDayPrev = splittedValues1[0];

    io:println(`melbYearPrev = ${melbYearPrev}`);
    io:println(`melbMonthPrev = ${melbMonthPrev}`);
    io:println(`melbDayPrev = ${melbDayPrev}`);

    //2025-08-13T00:00:00Z
    string fromDateAU = string `${melbYearPrev}-${melbMonthPrev}-${melbDayPrev}T00:00:00Z`;
    string toDateAU = string `${melbYearPrev}-${melbMonthPrev}-${melbDayPrev}T23:59:59Z`;
    io:println(`fromDateAU (str) = ${fromDateAU}`);
    io:println(`toDateAU (str) = ${toDateAU}`);

    // get utc from & to dates
    //time:Civil xc = check time:civilFromString(string `${fromDateAU}[Australia/Melbourne]`); //json
    //io:println("xc toString(): " + xc.toString()); 

    //2024-08-13T00:00:00Z >> 2024-08-13T00:00:00+10:00
    string:RegExp r = re `Z`;
    string fAU = r.replace(fromDateAU, "+10:00");
    io:println(`fAU: ${fAU}`);
    string tAU = r.replace(toDateAU, "+10:00");
    io:println(`fAU: ${tAU}`);

    r = re `T`;
    //time:Utc|time:Error uu = time:utcFromString("2024-08-13T00:00:00+10:00");
    time:Utc|time:Error uu = time:utcFromString(string `${fAU}`);
    string fromDateUTC = r.replace((time:utcToString(check uu)),"%20");
    io:println(`fromDateUTC: ${fromDateUTC}`);

    uu = time:utcFromString(string `${tAU}`);
    string toDateUTC = r.replace(time:utcToString(check uu),"%20");
    io:println(`toDateUTC: ${toDateUTC}`);
}