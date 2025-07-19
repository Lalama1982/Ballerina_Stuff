import ballerina/io;

public function main() returns error? {
    string name = "Lalama";
    string suburb = "Clyde North";
    int age = 43;
    //int sCode = 3978;

    xml xmlValue = xml `<name>${name}</name>
                        <details>
                          <suburb id="3978">${suburb}</suburb>
                          <language>English</language>
                        </details>
                        <age>${age}</age>`;

    // `xmlValue.<name>` - retrieves every element in `xmlValue` named `items`.
    xml nameXml = xmlValue.<name>;
    io:println("nameXml >> ", nameXml);
    string nameData = nameXml.data();
    io:println("nameData >> ", nameData);

    xml ageXml = xmlValue/<age>;
    io:println("ageXml >> ", ageXml);

    // `xmlValue/<suburb>` - for every element `e` in `xmlValue`, retrieves every element named `age` 
    // in the children of `e`.
    // NOT "age", "name" or "details"
    xml suburbXml = xmlValue/<suburb>;
    io:println("suburbXml >> ", suburbXml);
    string suburbData = suburbXml.data();
    io:println("suburbData >> ", suburbData);
    string suburbId = check suburbXml.id;
    io:println("suburbId >> "+suburbId);

    // `xmlValue/<name|age>` - for every element `e` in `xmlValue`, retrieves every element named 
    // `name` or `age` in the children of `e`.
    // NOT "age", "name" or "details"    
    xml suburbLanguageXml = xmlValue/<suburb|language>;
    io:println("suburbLanguageXml >> ", suburbLanguageXml);
    string suburbLanguageData = suburbLanguageXml.data();
    io:println("suburbLanguageData >> ", suburbLanguageData);

    // `xmlValue/*` - for every element `e` in `xmlValue`, retrieves the children of `e`.
    xml childrenXml = xmlValue/*;
    io:println("childrenXml >> ", childrenXml);

    // `xmlValue/<*>` - for every element `e` in `xmlValue`, retrieves every element in the children of `e`.
    // children of "details"
    xml children2Xml = xmlValue/<*>;
    io:println("children2Xml >> ",children2Xml);    

    // `xmlValue/**/<language>` - for every element `e` in `xmlValue`, retrieves every element named `language` in
    // the descendants of `e`.
    xml languageXml = xmlValue/**/<language>;
    io:println("languageXml >> ", languageXml);
    string languageData = languageXml.data();
    io:println("languageData >> ", languageData);

    // `xmlValue/<details>[0]` - for every element `e` in `xmlValue`, retrieves the first element named `details` in
    // the children of `e`.
    xml detailsXml = xmlValue.<details>;
    io:println("detailsXml >> ", detailsXml);    
    xml detailsLanguageXml = detailsXml/<language>;
    io:println("detailsLanguageXml >> ", detailsLanguageXml);
    string detailsLanguageData = detailsLanguageXml.data();
    io:print("detailsLanguageData >> ", detailsLanguageData);

}
