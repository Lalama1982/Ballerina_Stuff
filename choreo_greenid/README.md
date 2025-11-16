bal new -t service choreo_greenid

# choreo-greenid
GreenId middleware

# Executing for Localhost
Within the same folder of the "bal" file, run "bal run"

# modules
bal add xml_templates

# backup
    string streetNumber = check reqPayload.streetNumber;
    string streetName = check reqPayload.streetName;
    string streetType = check reqPayload.streetType;
    string suburb = check reqPayload.suburb;
    string postcode = check reqPayload.postcode;
    string state = check reqPayload.state;
    string country = check reqPayload.country;
<currentResidentialAddress>
    <streetNumber>${streetNumber}</streetNumber>                
    <streetName>${streetName}</streetName>
    <streetType>${streetType}</streetType>                
    <suburb>${suburb}</suburb>                
    <postcode>${postcode}</postcode>
    <state>${state}</state>                
    <country>${country}</country>
</currentResidentialAddress>
