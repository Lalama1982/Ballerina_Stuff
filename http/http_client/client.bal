import ballerina/http;
import ballerina/io;
import ballerina/mime;

type Album readonly & record {
    string title;
    string artist;
};

public function main() returns error? {
    // Creates a new client with the Basic REST service URL.
    string url = "localhost:9090";
    decimal timeout = 15;
    http:HttpVersion httpVersion = http:HTTP_1_1;
    //http:Client|error albumClient = check new ("localhost:9090");
    http:Client|error albumClient = new (url, {timeout, httpVersion});

    if albumClient is error {
        io:println("Failed to initialize an HTTP client", albumClient);
        return;
    }
    io:println( string `Initialized client with URL: ${url}, timeout: ${timeout}, HTTP version: ${httpVersion}`);

    // Binding the payload to a `record` array type.
    // The contextually expected type is inferred from the LHS variable type.
    Album[] albums = check albumClient->/http0/albums;
    io:println("First artist name: " + albums[0].artist);

    Album album = check albumClient->/http0/albums.post({
        // Here, an album which exceeds the constraints are sent to a server
        // which returns the same record again to the client.
        id: "6",
        title: "Blue Train",
        artist: "John Coltrane"
    },
    // Headers can be specified as a `map<string|string[]>`
    {
        Accept: mime:APPLICATION_JSON
    }    
    );
    io:println("Received album: " + album.toJsonString());

    json respJson = check albumClient->/http0/albumsReqBody.post({
        // Here, an album which exceeds the constraints are sent to a server
        // which returns the same record again to the client.
        id: "9",
        title: "Blue Train",
        artist: "John Coltrane"
    },
    // Headers can be specified as a `map<string|string[]>`
    {
        Accept: mime:APPLICATION_JSON
    }    
    );
    io:println("Received respJson: " + respJson.toJsonString());


}
