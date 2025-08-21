import ballerina/io;

type User record {
    string name;
    int age;
    string email?;
};

public function main() returns error? {
    json j1 = {name: "Alice", age: 30, email: "alice@example.com"};
    User u1 = check j1.cloneWithType(User);
    io:println(u1.email); // Prints "alice@example.com"

    json j2 = {name: "Bob", age: 25}; // 'email' field is missing
    User u2 = check j2.cloneWithType(User);
    io:println(u2.email); // Prints "()" (nil value for optional field)
}