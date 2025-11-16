public type RecItem record {|
    string? line_seq?;
    string? hit_hitvendorid?;
    string firstname?;
    string? lastname?;    
    string? birthdate?;
    string? emailaddress?;    
    string? etag?;    
    string? contactid?;
    string? engl_result_latest?;  
    string? engl_date_latest?;        
    string? engl_result_highest?;
    string? engl_date_highest?; 
    string? engl_result_formatted?;
    string? engl_date_formatted?;     
    string? math_result_latest?;         
    string? math_date_latest?;
    string? math_result_highest?;    
    string? math_date_highest?;
    string? math_result_formatted?;    
    string? math_date_formatted?;
    string? digi_result_latest?;     
    string? digi_date_latest?;   
    string? digi_result_highest?;    
    string? digi_date_highest?; 
    string? digi_result_formatted?;    
    string? digi_date_formatted?;               
    json...;
|};

public type Records record {|
    RecItem[] rec;
    json...;
|};

public type Root record {|
    Records records;
    json...;
|};