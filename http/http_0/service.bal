import ballerina/http;

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

# A service representing a network-accessible API
# bound to port `9090`.
service / on new http:Listener(9090) {

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

    resource function get albums/[string id]() returns Album|http:NotFound {
        Album? album = albums[id];
        if album is () {
            return http:NOT_FOUND;
        }
        return album;
    }

    resource function post albums(Album album) returns Album {
        albums.add(album);
        return album;
    }        
}
