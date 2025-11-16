type TokenResponse record {|
    string access_token;
    string token_type;
    int expires_in;
    string 'resource;
    string refresh_token;
    int refresh_token_expires_in;
    string id_token;
    json...;
|};


public type ContactsResponseValueItem record {|
    string \@odata\.etag;
    string lastname?;
    int recexamid?;
    string firstname?;
    string emailaddress1?;
    string birthdate?;
    string contactid;
    json...;
|};
