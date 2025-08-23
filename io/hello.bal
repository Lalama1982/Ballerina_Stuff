import ballerina/io;
import ballerina/lang.'int;    //lang.int as ints; // Alias for clarity

public function main() returns error? {
    io:println("Hello LMY!");

    string v1 = "62789908";
    string v2 = "A user with username '30003041' not found.";

    int|error result = int:fromString(v1);

    if result !is int {
        io:println("v1 >> Not An Int : ", result);
        return;
    } 
    io:println("v1 >> An Int : ", result);

    result = int:fromString(v2);

    if result !is int {
        io:println("v2 >> Not An Int : ", result);
        return;
    } 
    io:println("v2 >> An Int : ", result);

    // string fromDateAU = "2024-08-13T00:00:00Z";
    // string:RegExp r = re `Z`;
    // string ttt = r.replace(fromDateAU, "+10:00");
    // io:println(`ttt: ${ttt}`);

    // json s = {"z": "Z"};
    // io:println(s);
    // json m = {"x": "X", "y": "Y"};
    // io:println(m);    

    // json d = check m.mergeJson(s);
    // io:println(d);
}