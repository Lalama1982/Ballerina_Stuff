import ballerina/io;
import ballerina/time;
//import ballerina/lang.regexp;

public function main() returns time:Error? {
    string tt = "2025-08-13%2000:00:00Z"; //"2025-08-13T00:00:00Z";

    string:RegExp r = re `%20`;
    string ttt = r.replace(tt, "T");

    io:println(`ttt >> ${ttt}`);

    time:Civil t1 = check time:civilFromString(ttt+"[Australia/Melbourne]");
    io:println("t1 >> ", time:civilToString(t1));
    string tS = check time:civilToString(check time:civilFromString(ttt+"[Australia/Melbourne]"));
    io:println("tS >> ", tS);
    io:println("+++++++++++++++++++++++++++++++++++++++++++++++++");
    time:Utc currentUTC = time:utcNow();
    //io:println(`currentUTC = ${currentUTC}`);
    //io:println(`Number of seconds from the epoch: ${currentUTC[0]}s`);
    //io:println(`Nanoseconds fraction: ${currentUTC[1]}s`);

    time:Civil currentUTC_civil = time:utcToCivil(currentUTC);
    io:println(`currentUTC in Civil: ${currentUTC_civil.toString()}`);

    string currentUTCString = time:utcToString(currentUTC);
    io:println(`UTC string representation: ${currentUTCString}`);

    currentUTCString = currentUTCString+"[Australia/Melbourne]";
    time:Civil melbTime = check time:civilFromString(currentUTCString);
    io:println("melbTime (Converted): " + melbTime.toString());

    // int yearMelb = melbTime.year;
    // int monthMelb = melbTime.month;
    // int dayMelb = melbTime.day;
    // int hourMelb = melbTime.hour;
    // int minuteMelb = melbTime.minute;
    // time:Seconds? secondMelb = melbTime.second;

    // io:println(`yearMelb = ${yearMelb}`);
    // io:println(`monthMelb = ${monthMelb}`);
    // io:println(`dayMelb = ${dayMelb}`);
    // io:println(`hourMelb = ${hourMelb}`);
    // io:println(`minuteMelb = ${minuteMelb}`);
    // io:println(`secondMelb = ${secondMelb}`);

    time:Utc currMelbTimeUTC = check time:utcFromCivil(melbTime);
    io:println(`currMelbTimeUTC string representation: ${time:utcToString(currMelbTimeUTC)}`);
    time:Utc prevMelbTimeUTC = time:utcAddSeconds(currMelbTimeUTC, -86400);
    //io:println(`prevMelbTimeUTC: ${prevMelbTimeUTC}`);
    io:println(`prevMelbTimeUTC string representation: ${time:utcToString(prevMelbTimeUTC)}`);

    time:Civil prevMelbTimeUTC_civil = time:utcToCivil(prevMelbTimeUTC);
    io:println(`prevMelbTimeUTC in Civil: ${prevMelbTimeUTC_civil.toString()}`);

    int yearUTC = prevMelbTimeUTC_civil.year;
    int monthUTC = prevMelbTimeUTC_civil.month;
    int dayUTC = prevMelbTimeUTC_civil.day;

    // UTC format: 2022-01-03%2001:26:51Z
    string fromDateUTC = string `${yearUTC}-${monthUTC}-${dayUTC}%2000:00:00Z`;
    string toDateUTC = string `${yearUTC}-${monthUTC}-${dayUTC}%2023:59:59Z`;
    string fromDateAU = "";
    string toDateAU = "";

    io:println(`fromDateAU : ${fromDateAU}`);
    io:println(`toDateAU : ${toDateAU}`);
    io:println(`fromDateUTC : ${fromDateUTC}`);
    io:println(`toDateUTC : ${toDateUTC}`);

    io:println("===================================================");

    string[] splittedValues1 = re `-`.split(time:utcToString(prevMelbTimeUTC));
    io:println(splittedValues1);

    string yearUTC_re = splittedValues1[0];
    string monthUTC_re = splittedValues1[1];
    string[] splittedValues2 = re `T`.split(splittedValues1[2]);
    string dayUTC_re = splittedValues2[0];

    io:println(`yearUTC_re = ${yearUTC_re}`);
    io:println(`monthUTC_re = ${monthUTC_re}`);
    io:println(`dayUTC_re = ${dayUTC_re}`);

    // "re" >> UTC format: 2022-01-03%2001:26:51Z
    fromDateUTC = string `${yearUTC_re}-${monthUTC_re}-${dayUTC_re}%2000:00:00Z`;
    toDateUTC = string `${yearUTC_re}-${monthUTC_re}-${dayUTC_re}%2023:59:59Z`;

    // time:Civil fAU = check time:civilFromString(string `${r.replace(fromDateUTC, "T")}[Australia/Melbourne]`);
    // time:Civil tAU = check time:civilFromString(string `${r.replace(toDateUTC, "T")}[Australia/Melbourne]`);

    fromDateAU = check time:civilToString(check time:civilFromString(string `${r.replace(fromDateUTC, "T")}[Australia/Melbourne]`));
    toDateAU = check time:civilToString(check time:civilFromString(string `${r.replace(toDateUTC, "T")}[Australia/Melbourne]`));

    // io:println("fromDateUTC (Converted): " + fAU);
    // io:println("toDateUTC (Converted): " + tAU);
    // fromDateAU = fAU.toString();
    // toDateAU = tAU.toString();

    io:println(`fromDateAU : ${fromDateAU}`);
    io:println(`toDateAU : ${toDateAU}`);
    io:println(`fromDateUTC : ${fromDateUTC}`);
    io:println(`toDateUTC : ${toDateUTC}`);    
}