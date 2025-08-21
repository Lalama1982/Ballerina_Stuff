import ballerina/io;

type ValueItem record {|
    string \@odata\.etag;
    string savedqueryid;
    json...;
|};

type SavedQueryResponse record {|
    string \@odata\.context;
    string field2?;
    ValueItem[] value;
    string z;
    json...;
|};

public function main() returns error? {
    json m = {
              "@odata.context": "savedqueries", 
              "field2": "fd2", 
              "value":[
                    {
                        "@odata.etag": "data_etag",
                        "savedqueryid": "91d27960"
                    }
              ],
              "z": "z-A"
             }; 

    SavedQueryResponse mc = check m.cloneWithType(SavedQueryResponse);

    io:println(`mc.z = ${mc.z}`);
    io:println(`mc.\@odata\.context = ${mc.\@odata\.context}`);
    string? field2 = mc.field2;
    io:println(`mc.field2 = ${field2}`);   

    string etag_0 = mc.value[0].\@odata\.etag;
    io:println(`etag_0 = ${etag_0}`);

    string savedqueryid_0 = mc.value[0].savedqueryid;
    io:println(`savedqueryid_0 = ${savedqueryid_0}`);    
  
    io:println("+++++++++++++++++++++++++++++++++++++++++");

    json n = {
              "@odata.context": "savedqueries", 
              "value":[
                    {
                        "@odata.etag": "data_etag_b",
                        "savedqueryid": "91d27960_b"
                    }
              ],
              "z": "z-B"
             }; 

    SavedQueryResponse nc = check n.cloneWithType(SavedQueryResponse);    
    io:println(`nc.z = ${nc.z}`);
    io:println(`nc.\@odata\.context = ${nc.\@odata\.context}`);
    field2 = nc.field2;
    io:println(`nc.field2 = ${field2}`);   

    etag_0 = nc.value[0].\@odata\.etag;
    io:println(`etag_0 = ${etag_0}`);

    savedqueryid_0 = nc.value[0].savedqueryid;
    io:println(`savedqueryid_0 = ${savedqueryid_0}`);    
}