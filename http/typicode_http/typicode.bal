// Define the end point to the call the `TypiCode`.
import ballerina/http;
import ballerina/io;
import ballerina/mime;

string url = "https://jsonplaceholder.typicode.com";
decimal timeout = 15;
http:HttpVersion httpVersion = http:HTTP_1_1;

service /typiCodeProxy on new http:Listener(9095) {
    resource function get getFirstPost() returns http:Response|error {
        //json payload = check request.getJsonPayload();
        //io:println("getFirstPost: payload >> " + payload.toString());

        http:Response response = new;
        http:Client|error typiCodeClient = new (url, {timeout, httpVersion});

        if typiCodeClient is error {
            //io:println("getFirstPost: Failed to initialize an HTTP client", typiCodeClient);
            string err = string `Failed to initialize an HTTP client ${typiCodeClient.toString()}`;
            io:println("getFirstPost:", err);
            json respJson = {"From": "getFirstPost", "Error": err};

            response.setPayload(respJson);
        } else {
            io:println(string `getFirstPost: Initialized client with URL: ${url}, timeout: ${timeout}, HTTP version: ${httpVersion}`);

            json[] posts = check typiCodeClient->/posts;
            string firstTitle = check posts[0].title;
            io:println("firstTitle = " + firstTitle);

            json respJson = {"From": "getFirstPost", "firstTitle": firstTitle};

            response.setPayload(respJson);

        }

        return response;
    }

    resource function get getPostById(int? postID) returns http:Response|error {
        io:println("getPostById: postID >> ", postID);

        http:Response response = new;
        http:Client|error typiCodeClient = new (url, {timeout, httpVersion});

        if typiCodeClient is error {
            string err = string `Failed to initialize an HTTP client ${typiCodeClient.toString()}`;
            io:println("getPostById:", err);
            json respJson = {"From": "getPostById", "Error": err};

            response.setPayload(respJson);
        } else {
            io:println(string `getPostById: Initialized client with URL: ${url}, timeout: ${timeout}, HTTP version: ${httpVersion}`);

            json post = check typiCodeClient->/posts/[postID ?: 0];
            string title = check post.title;
            io:println("getPostById: firstTitle = " + title);

            json respJson = {"From": "getPostById", "Post Received": post};

            response.setPayload(respJson);

        }

        return response;
    }

    resource function post createPost(http:Request request) returns http:Response|error {
        json payLoad = check request.getJsonPayload();
        io:println("createPost: payLoad >> " + payLoad.toString());

        http:Response response = new;
        http:Client|error typiCodeClient = new (url, {timeout, httpVersion});

        if typiCodeClient is error {
            string err = string `Failed to initialize an HTTP client ${typiCodeClient.toString()}`;
            io:println("createPost:", err);
            json respJson = {"From": "createPost", "Error": err};

            response.setPayload(respJson);
        } else {
            io:println(string `createPost: Initialized client with URL: ${url}, timeout: ${timeout}, HTTP version: ${httpVersion}`);

            json typiResp = check typiCodeClient->/posts.post([payLoad],
                // Headers can be specified as a `map<string|string[]>`
                {
                    Accept: mime:APPLICATION_JSON
                }
            );

            io:println(string `createPost: respJson: ${typiResp.toString()}`);
            json respJson = {"From": "getPostById", "Typi Response": typiResp};

            response.setPayload(respJson);            
        }

        return response;
    }
}
