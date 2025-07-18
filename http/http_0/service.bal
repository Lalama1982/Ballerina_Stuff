import ballerina/http;
import ballerina/io;
import ballerina/mime;

type Album readonly & record {|
    string id;
    string title;
    string artist;
|};

table<Album> key(id) albums = table [
    {id: "1", title: "Blue Train", artist: "John Coltrane"},
    {id: "2", title: "Jeru", artist: "Gerry Mulligan"},
    {id: "3", title: "Sarah Vaughan and Clifford Brown", artist: "Sarah Vaughan"}
];

// Represents the subtype of http:Conflict status code record.
type AlbumConflict record {|
    *http:Conflict;
    record {
        string message;
    } body;
|};

# A service representing a network-accessible API
# bound to port `9090`.
service /http0 on new http:Listener(9090) {

    # resource for simple Hello-worl
    # + return - hello message
    resource function get hello() returns string {
        return "Hello, World!";
    }

    # A resource for generating greetings
    # + name - name as a string or nil
    # + return - string name with hello message or error
    resource function get greeting(string? name) returns string|error {
        // Send a response back to the caller.
        if name is () {
            return error("name should not be empty!");
        }
        return string `Hello, ${name}`;
    }

    resource function get albums() returns Album[] {
        return albums.toArray();
    }

    resource function get albumsByPath/[string id]() returns Album|http:NotFound {
        Album? album = albums[id];
        if album is () {
            return http:NOT_FOUND;
        }
        return album;
    }

    resource function get albumsByQuery(string artist) returns Album[] {
        return from Album album in albums
            where album.artist == artist
            select album;
    }

    // The `accept` argument with `@http:Header` annotation takes the value of the `Accept` request header.
    resource function get albumsWithHeader(@http:Header string accept) returns Album[]|http:NotAcceptable {
        if !string:equalsIgnoreCaseAscii(accept, mime:APPLICATION_JSON) {
            return http:NOT_ACCEPTABLE;
        }
        return albums.toArray();
    }

    resource function post albums(Album album) returns Album|error {
        io:println("albumsAdd: " + album.artist);
        albums.add(album);
        return album;

    }

    resource function post albumsReqBody(http:Request request) returns http:Response|error {
        json payload = check request.getJsonPayload();
        io:println("albums-ReqBody-Add: All >> " + payload.toString());

        string artist = check payload.artist;
        io:println("albums-ReqBody-Add: artist >> " + artist);

        // Casting request body to "album" type
        //Album album = check payload.cloneWithType();

        string addErr = "";
        string albumAdd = "";
        Album|error album = check payload.cloneWithType();

        if album is error {
            addErr = "Casting payload to albums >> failed";
        } else {
            addErr = "Casting payload to albums >> success";

            if albums.hasKey(album.title) {
                //return http:CONFLICT;
                albumAdd = "album already exists";
            } else {
                albums.add(album);
                albumAdd = "album added to albums";
            }
        }
        io:println(addErr);

        json respJson = {"From": "albumsReqBody", "request": payload, "album_add": albumAdd, "casting_outcome": addErr};

        // Create a response and populate the headers/payload.
        http:Response response = new;
        io:println("1");
        response.setPayload(respJson);
        io:println("2");
        response.setHeader("x-albumsReqBody", "Set at albumsReqBody");
        io:println("3");
        return response;
    }

    // The resource returns the `409 Conflict` status code as the error response status code using 
    // the `StatusCodeResponse` constants. This constant does not have a body or headers.
    resource function post albumsDuplChk(Album album) returns Album|AlbumConflict { //Album|http:Conflict {
        io:println("albums: " + album.artist);
        if albums.hasKey(album.title) {
            //return http:CONFLICT;
            return {body: {message: "album already exists"}};
        }
        albums.add(album);
        return album;
    }
}
