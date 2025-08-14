import ballerina/io;

public function main() returns error? {
    string filePath = "json.txt";
    string fileContent = check io:fileReadString(filePath);
    //io:println("File content: " + fileContent);

    json|error contracts = check fileContent.fromJsonString();

    // Check for errors during conversion
    if (contracts is error) {
        io:println("Error in parsing JSON: ", contracts);
    } else {
        io:println("Successfully converted string to JSON: ");
        // You can now access elements of the JSON
        //string chk = contracts[0].Trainee.TraineeDetails.hsd_epsilonidentifier;
        io:println("Name: ", contracts.Trainee);
    }    
}