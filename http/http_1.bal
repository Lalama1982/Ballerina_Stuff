import ballerina/http;

service / on new http:Listener(9097) {

    // This function responds with the `string` value `Hello, World!` to HTTP GET requests.
    resource function get greeting(string name) returns string {
        return "Hello, World!";
    }
}   