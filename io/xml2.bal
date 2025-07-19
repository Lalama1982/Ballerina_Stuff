import ballerina/io;

public function main() returns error? {
    string name = "Lalama";
    string suburb = "Clyde North";
    int age = 43;

    xml xmlEx = xml `<name>${name}</name>
                        <details>
                          <suburb id="3978">${suburb}</suburb>
                          <language>English</language>
                        </details>
                        <age>${age}</age>`;

    //xml xmlExElements = xmlEx.elements();
    //io:println(xmlExElements);

    io:println("---------- Method #1: Start ------------");

    xml nameXML = xmlEx.elements("name");
    io:println("nameXML >> ", nameXML);
    //io:println(nameXML.data());

    xml detailsXML = xmlEx.elements("details");
    io:println("detailsXML >> ", detailsXML);
    //io:println("detailsXML #2 >> ", detailsXML.elementChildren("suburb"));

    xml suburbXML = detailsXML.elementChildren("suburb");
    io:println("suburbXML >> ", suburbXML);
    string suburbName = suburbXML.data();
    io:println("suburbName >> ", suburbName);
    string suburbId = check suburbXML.id;
    io:println("suburbId >> ", suburbId);
    
    io:println("---------- Method #1: End ------------");

    io:println("---------- Method #2: Start ------------");
    
    io:println("---------- Method #2: End ------------");
}