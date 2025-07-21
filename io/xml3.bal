import ballerina/io;

public function main()  returns error? {
    xml xmlValue = xml `<recs>
                            <rec>
                                <name>Lalama</name>
                                <details>
                                    <suburb id="3978">Clyde North</suburb>
                                    <language>English</language>
                                </details>
                                <age>43</age>
                            </rec>                            
                        </recs>`;    

    xml recsXml = xmlValue.<recs>;
    io:println("recsXml >> ", recsXml);
    //string nameData = recsXml.data();
    //io:println("recsXml >> ", nameData);

    xml recXml = recsXml/<rec>;
    io:println("recXml >> ", recXml);

    xml nameXml = recXml/<name>;
    io:println("nameXml >> ", nameXml);
    string nameData = nameXml.data();
    io:println("nameData >> ", nameData);

    xml suburbXml = recXml/**/<suburb>;
    io:println("suburbXml >> ", suburbXml);
    string suburbData = suburbXml.data();
    io:println("suburbData >> ", suburbData);
    string suburbId = check suburbXml.id;
    io:println("suburbID >> ", suburbId);

}