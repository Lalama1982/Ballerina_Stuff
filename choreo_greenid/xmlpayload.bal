import ballerina/io;
import choreo_greenid.xml_templates;

public function getXmlPayload(string templateFlag, json reqPayload, json regDetails = null) returns (xml)|error {
    string fileName = "xmlpayload";

    io:println(fileName, "-getXmlPayload: templateFlag >> " + templateFlag);
    io:println(fileName, "-getXmlPayload: reqPayload >> " + reqPayload.toString());
    io:println(fileName, "-getXmlPayload: regDetails >> " + regDetails.toString());

    match templateFlag {
        "reg-ver" => {
            return xml_templates:getRegVerifPayload(reqPayload, regDetails);
        }
        "aus-medc" => {
            return xml_templates:getAusMedicarePayload(reqPayload, regDetails);
        }
        "aus-birth" => {
            return xml_templates:getAusBirthCertPayload(reqPayload, regDetails);
        }
        "aus-citz" => {
            return xml_templates:getAusCitzCertPayload(reqPayload, regDetails);
        }
        "aus-immi" => {
            return xml_templates:getAusImmiCardPayload(reqPayload, regDetails);
        }
        "aus-passport" => {
            return xml_templates:getAusPassportPayload(reqPayload, regDetails);
        }        
        "aus-visa" => {
            return xml_templates:getAusVisaPayload(reqPayload, regDetails);
        }
        "nz-birth" => {
            return xml_templates:getNzBirthCertPayload(reqPayload, regDetails);
        }
        "nz-citz" => {
            return xml_templates:getNzCitzCertPayload(reqPayload, regDetails);
        }
        "nz-passport" => {
            return xml_templates:getNzPassportPayload(reqPayload, regDetails);
        }    
        "aus-centrelink" => {
            return xml_templates:getAusCentrelinkPayload(reqPayload, regDetails);
        }     
        // Use `_` to match type `any`.
        _ => {
            return xml `Invalid DVS Template Code`;
        }
    }
}
