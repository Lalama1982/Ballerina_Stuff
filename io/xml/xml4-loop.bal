import ballerina/io;

public function main() returns error? {
    xml xmlEx = xml `<recs>
                            <rec>
                                <name>Lalama</name>
                                <details>
                                    <suburb id="3978">Clyde North</suburb>
                                    <language>English</language>
                                </details>
                                <age>43</age>
                            </rec> 
                            <rec>
                                <name>Nadeera</name>
                                <details>
                                    <suburb id="3977">Cranbourne North</suburb>
                                    <language>French</language>
                                </details>
                                <age>42</age>
                            </rec>                                                        
                        </recs>`;

    xml recXml = xmlEx/<rec>;
    int i = 1;
    // `foreach` iterates over each item.
    foreach var item in recXml {
        //io:println(item);
        //io:println(i," :: item >> ", item);
        string name = (item/<name>).data();
        string age = (item/<age>).data();
        string suburb = (item/**/<suburb>).data();
        string suburbId = check (item/**/<suburb>).id; 
        string language = (item/**/<language>).data();

        io:println(`${i} :: Name >> ${name} / age >> ${age}  / suburb >> ${suburb}(${suburbId}) / language >> ${language}`);

        i = i+1;
    }

}
