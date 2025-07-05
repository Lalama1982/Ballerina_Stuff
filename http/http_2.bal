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

service / on new http:Listener(9090) {

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