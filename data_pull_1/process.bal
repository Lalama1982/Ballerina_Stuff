import ballerina/io;
import ballerina/http;

import data_pull_1.db_ops;

public function contractsProcessing(http:Client dssClient, int hdrSeq, json[] contracts) returns json|error {
    string msg = "";
    int dtlSer = 0;

    int i = 1;
    foreach json member in contracts {  
        dtlSer = 0;
        msg = "";
        string msgThread = "#Begin[Choreo]#";

        // tbl_user_trainee_dtls
        string? traineeDtls_hsdUseridentifier = check member.Trainee.TraineeDetails.hsd_useridentifier;
        //io:println(`contractsProcessing :: ${i} ::: tbl_user_trainee_dtls : traineeDtls_hsdUseridentifier : ${traineeDtls_hsdUseridentifier}`);
        string? traineeDtls_firstName = check member.Trainee.TraineeDetails.firstname;
        string? traineeDtls_lastName = check member.Trainee.TraineeDetails.lastname;
        string? traineeDtls_hsdGender = check member.Trainee.TraineeDetails.hsd_gender;
        string? traineeDtls_hsdDob = check member.Trainee.TraineeDetails.hsd_dateofbirth;
        string? traineeDtls_hsdUsi = check member.Trainee.TraineeDetails.hsd_usi;
        string? traineeDtls_hsdHasadisability = (check member.Trainee.TraineeDetails.hsd_hasadisability).toString();
        string? traineeDtls_hsdCitizenshipstatus = check member.Trainee.TraineeDetails.hsd_citizenshipstatus;

        do {
            json dtlResp = check db_ops:mergeTraineeDtls(dssClient = dssClient, epHost = hostDss, hdrSeq = hdrSeq, dtlSer = dtlSer, hdrFlag = 1, hsdUseridentifier = traineeDtls_hsdUseridentifier ?: "null",
                                                  firstName = traineeDtls_firstName ?: "null", lastName = traineeDtls_lastName ?: "null", hsdGender = traineeDtls_hsdGender ?: "null", 
                                                  hsdDob = traineeDtls_hsdDob ?: "null", hsdUsi = traineeDtls_hsdUsi ?: "null", hsdHasadisability = traineeDtls_hsdHasadisability ?: "null", 
                                                  hsdCitizenshipstatus = traineeDtls_hsdCitizenshipstatus ?: "null", 
                                                  recMsg = "");

            dtlSer = check int:fromString(check dtlResp.response.io_ser);
            io:println(`contractsProcessing :: mergeTraineeDtls - dtlSer = ${dtlSer}`);

            msgThread = msgThread + " | " + <string>check dtlResp.response.io_rec_msg;  

        } on fail error e {
            msg = string `mergeTraineeDtls failed : ${e.toString()}`;
            io:println(`contractsProcessing :: ${msg}`);

            check db_ops:mergeDetails(dssClient = dssClient, epHost = hostDss, hdrSeq = hdrSeq, dtlSer = dtlSer, dtlFlag = 0, recMsg = msg);

            json resp = {"status": 0, "msg": msg};
            return resp;
        }
        
        // tbl_user_traineecntc_dtls
        string? traineeCntcDtls_telePhone2 = check member.Trainee.TraineeContactDetails.telephone2;
        //io:println(`contractsProcessing :: ${i} ::: tbl_user_traineecntc_dtls : traineeCntcDtls_telePhone2 : ${traineeCntcDtls_telePhone2}`);
        string? traineeCntcDtls_mobilePhone = check member.Trainee.TraineeContactDetails.mobilephone;
        string? traineecntcDtlsemailAddress1 = check member.Trainee.TraineeContactDetails.emailaddress1;

        do {
            json dtlResp = check db_ops:mergeTraineeCntcDtls(dssClient = dssClient, epHost = hostDss, hdrSeq = hdrSeq, dtlSer = dtlSer, hdrFlag = 1, telePhone2 = traineeCntcDtls_telePhone2 ?: "null",
                                                      mobilePhone = traineeCntcDtls_mobilePhone ?: "null", emailAddress1 = traineecntcDtlsemailAddress1 ?: "null", recMsg = "");

            msgThread = msgThread + " | " + <string>check dtlResp.response.io_rec_msg;    

        } on fail error e {
            msg = string `mergeTraineeCntcDtls failed : ${e.toString()}`;
            io:println(`contractsProcessing :: ${msg}`);
            
            check db_ops:mergeDetails(dssClient = dssClient, epHost = hostDss, hdrSeq = hdrSeq, dtlSer = dtlSer, dtlFlag = 0, recMsg = msg);

            json resp = {"status": 0, "msg": msg};
            return resp;
        }

        // tbl_user_traineeprevtc_dtls
        string? traineePrevtcDtls_hsdPrevioustrainingcontract = check member.Trainee.TraineePreviousTCDetails.hsd_previoustrainingcontract;
        //io:println(`contractsProcessing :: ${i} ::: tbl_user_traineeprevtc_dtls : traineePrevtcDtls_hsdPrevioustrainingcontract : ${traineePrevtcDtls_hsdPrevioustrainingcontract}`);

        do {
            json dtlResp = check db_ops:mergeTraineePreVtcDtls(dssClient = dssClient, epHost = hostDss, hdrSeq = hdrSeq, dtlSer = dtlSer, hdrFlag = 1, 
                                                        hsdPrevioustrainingcontract = traineePrevtcDtls_hsdPrevioustrainingcontract ?: "null", 
                                                        recMsg = "");

            msgThread = msgThread + " | " + <string>check dtlResp.response.io_rec_msg;

        } on fail error e {
            msg = string `mergeTraineePreVtcDtls failed : ${e.toString()}`;
            io:println(`contractsProcessing :: ${msg}`);

            check db_ops:mergeDetails(dssClient = dssClient, epHost = hostDss, hdrSeq = hdrSeq, dtlSer = dtlSer, dtlFlag = 0, recMsg = msg);
            
            json resp = {"status": 0, "msg": msg};
            return resp;
        }

        // tbl_user_trainee_addr
        string? traineeAddr_address2Line1 = check member.Trainee.TraineeAddress.address2_line1;
        //io:println(`contractsProcessing :: ${i} ::: tbl_user_trainee_addr : traineeAddr_address2Line1 : ${traineeAddr_address2Line1}`);
        string? traineeAddr_address2Line2 = check member.Trainee.TraineeAddress.address2_line2;
        string? traineeAddr_address2City = check member.Trainee.TraineeAddress.address2_city;
        string? traineeAddr_address2Postalcode = check member.Trainee.TraineeAddress.address2_postalcode;
        string? traineeAddr_hsdAddress2state = check member.Trainee.TraineeAddress.hsd_address2state;
        string? traineeAddr_hsdAddress2country = check member.Trainee.TraineeAddress.hsd_address2country;

        do {
            json dtlResp = check db_ops:mergeTraineeAddr(dssClient, epHost = hostDss, hdrSeq = hdrSeq, dtlSer = dtlSer, hdrFlag = 1, address2Line1 = traineeAddr_address2Line1 ?: "null",
                                                  address2Line2 = traineeAddr_address2Line2 ?: "null", address2City = traineeAddr_address2City ?: "null", 
                                                  address2Postalcode = traineeAddr_address2Postalcode ?: "null", hsdAddress2state = traineeAddr_hsdAddress2state ?: "null", 
                                                  hsdAddress2country = traineeAddr_hsdAddress2country ?: "null", recMsg = "");

            msgThread = msgThread + " | " + <string>check dtlResp.response.io_rec_msg;
                                                              
        } on fail error e {
            msg = string `mergeTraineeAddr failed : ${e.toString()}`;
            io:println(`contractsProcessing :: ${msg}`);

            check db_ops:mergeDetails(dssClient = dssClient, epHost = hostDss, hdrSeq = hdrSeq, dtlSer = dtlSer, dtlFlag = 0, recMsg = msg);

            json resp = {"status": 0, "msg": msg};
            return resp;
        }

        // tbl_user_empl_dtls
        string? emplDtls_hsdUseridentifier = check member.Employer.EmployerDetails.hsd_useridentifier;
        //io:println(`contractsProcessing :: ${i} ::: tbl_user_empl_dtls : emplDtls_hsdUseridentifier : ${emplDtls_hsdUseridentifier}`);
        string? hsdLegalname = check member.Employer.EmployerDetails.hsd_legalname;
        string? hsdName = check member.Employer.EmployerDetails.hsd_name;
        string? emplDtlsemailAddress1 = check member.Employer.EmployerDetails.emailaddress1;
        string? hsdAbn = check member.Employer.EmployerDetails.hsd_abn;

        do {
            json dtlResp = check db_ops:mergeEmplDtls(dssClient, epHost = hostDss, hdrSeq = hdrSeq, dtlSer = dtlSer, hdrFlag = 1, hsdUseridentifier = emplDtls_hsdUseridentifier ?: "null", 
                                               hsdLegalname = hsdLegalname ?: "null", hsdName = hsdName ?: "null", emailAddress1 = emplDtlsemailAddress1 ?: "null",
                                               hsdAbn = hsdAbn ?: "null", recMsg = "");

            msgThread = msgThread + " | " + <string>check dtlResp.response.io_rec_msg;

        } on fail error e {
            msg = string `mergeEmplDtls failed : ${e.toString()}`;
            io:println(`contractsProcessing :: ${msg}`);

            check db_ops:mergeDetails(dssClient = dssClient, epHost = hostDss, hdrSeq = hdrSeq, dtlSer = dtlSer, dtlFlag = 0, recMsg = msg);

            json resp = {"status": 0, "msg": msg};
            return resp;
        }
        
        // tbl_user_empl_postal_addr
        string? emplPostalAddr_address2Line1 = check member.Employer.EmployerPostalAddress.Address2_line1;
        //io:println(`contractsProcessing :: ${i} ::: tbl_user_empl_postal_addr : emplPostalAddr_address2Line1 : ${emplPostalAddr_address2Line1}`);
        string? emplPostalAddr_address2Line2 = check member.Employer.EmployerPostalAddress.Address2_line2;
        string? emplPostalAddr_address2City = check member.Employer.EmployerPostalAddress.Address2_city;
        string? emplPostalAddr_address2Postalcode = check member.Employer.EmployerPostalAddress.Address2_postalcode;
        string? emplPostalAddr_address2State = check member.Employer.EmployerPostalAddress.Address2_state;
        string? emplPostalAddr_address2Country = check member.Employer.EmployerPostalAddress.Address2_country;

        do {
            json dtlResp = check db_ops:mergeEmplPostalAddr(dssClient, epHost = hostDss, hdrSeq = hdrSeq, dtlSer = dtlSer, hdrFlag = 1, address2Line1 = emplPostalAddr_address2Line1 ?: "null", 
                                                     address2Line2 = emplPostalAddr_address2Line2 ?: "null", address2City = emplPostalAddr_address2City ?: "null", 
                                                     address2Postalcode = emplPostalAddr_address2Postalcode ?: "null", address2State = emplPostalAddr_address2State ?: "null", 
                                                     address2Country = emplPostalAddr_address2Country ?: "null", recMsg = "");

            msgThread = msgThread + " | " + <string>check dtlResp.response.io_rec_msg;
                                                                 
        } on fail error e {
            msg = string `mergeEmplPostalAddr failed : ${e.toString()}`;
            io:println(`contractsProcessing :: ${msg}`);

            check db_ops:mergeDetails(dssClient = dssClient, epHost = hostDss, hdrSeq = hdrSeq, dtlSer = dtlSer, dtlFlag = 0, recMsg = msg);

            json resp = {"status": 0, "msg": msg};
            return resp;
        }
        
        // tbl_user_empl_physical_addr
        string? emplPhysicalAddr_address1Line1 = check member.Employer.EmployerPhysicalAddress.address1_line1;
        //io:println(`contractsProcessing :: ${i} ::: tbl_user_empl_physical_addr : emplPhysicalAddr_address1Line1 : ${emplPhysicalAddr_address1Line1}`);
        string? emplPhysicalAddr_address1Line2 = check member.Employer.EmployerPhysicalAddress.address1_line2;
        string? emplPhysicalAddr_address1City = check member.Employer.EmployerPhysicalAddress.address1_city;
        string? emplPhysicalAddr_address1Postalcode = check member.Employer.EmployerPhysicalAddress.address1_postalcode;
        string? emplPhysicalAddr_address1State = check member.Employer.EmployerPhysicalAddress.address1_state;
        string? emplPhysicalAddr_address1Country = check member.Employer.EmployerPhysicalAddress.address1_country;

        do {
            json dtlResp = check db_ops:mergeEmplPhysicalAddr(dssClient, epHost = hostDss, hdrSeq = hdrSeq, dtlSer = dtlSer, hdrFlag = 1, address1Line1 = emplPhysicalAddr_address1Line1 ?: "null", 
                                                       address1Line2 = emplPhysicalAddr_address1Line2 ?: "null", address1City = emplPhysicalAddr_address1City ?: "null", 
                                                       address1Postalcode = emplPhysicalAddr_address1Postalcode ?: "null", address1State = emplPhysicalAddr_address1State ?: "null", 
                                                       address1Country = emplPhysicalAddr_address1Country ?: "null", recMsg = "");

            msgThread = msgThread + " | " + <string>check dtlResp.response.io_rec_msg;

        } on fail error e {
            msg = string `mergeEmplPhysicalAddr failed : ${e.toString()}`;
            io:println(`contractsProcessing :: ${msg}`);

            check db_ops:mergeDetails(dssClient = dssClient, epHost = hostDss, hdrSeq = hdrSeq, dtlSer = dtlSer, dtlFlag = 0, recMsg = msg);

            json resp = {"status": 0, "msg": msg};
            return resp;
        }
        
        // tbl_user_empl_primary_cntc
        string? emplPrimaryCntc_telePhone1 = check member.Employer.EmployerPrimaryContact.telephone1;
        //io:println(`contractsProcessing :: ${i} ::: tbl_user_empl_primary_cntc : emplPrimaryCntc_telePhone1 : ${emplPrimaryCntc_telePhone1}`);
        string? emplPrimaryCntc_mobilePhone = check member.Employer.EmployerPrimaryContact.mobilephone;
        string? emplPrimaryCntc_firstName = check member.Employer.EmployerPrimaryContact.firstname;
        string? emplPrimaryCntc_lastName = check member.Employer.EmployerPrimaryContact.lastname;

        do {
            json dtlResp = check db_ops:mergeEmplPrimaryCntc(dssClient, epHost = hostDss, hdrSeq = hdrSeq, dtlSer = dtlSer, hdrFlag = 1, telePhone1 = emplPrimaryCntc_telePhone1 ?: "null", 
                                                      mobilePhone = emplPrimaryCntc_mobilePhone ?: "null", firstName = emplPrimaryCntc_firstName ?: "null", 
                                                      lastName = emplPrimaryCntc_lastName ?: "null", recMsg = "");

            msgThread = msgThread + " | " + <string>check dtlResp.response.io_rec_msg;

        } on fail error e {
            msg = string `mergeEmplPrimaryCntc failed : ${e.toString()}`;
            io:println(`contractsProcessing :: ${msg}`);

            check db_ops:mergeDetails(dssClient = dssClient, epHost = hostDss, hdrSeq = hdrSeq, dtlSer = dtlSer, dtlFlag = 0, recMsg = msg);

            json resp = {"status": 0, "msg": msg};
            return resp;
        }

        // tbl_user_wplc_physical_addr
        string? wplcPhysicalAddr_address1Line1 = check member.Employer.WorkplacePhysicalAddress.address1_line1;
        //io:println(`contractsProcessing :: ${i} ::: tbl_user_wplc_physical_addr : wplcPhysicalAddr_address1Line1 : ${wplcPhysicalAddr_address1Line1}`);
        string? wplcPhysicalAddr_address1Line2 = check member.Employer.WorkplacePhysicalAddress.address1_line2;
        string? wplcPhysicalAddr_address1City = check member.Employer.WorkplacePhysicalAddress.address1_city;
        string? wplcPhysicalAddr_address1Postalcode = check member.Employer.WorkplacePhysicalAddress.address1_postalcode;
        string? wplcPhysicalAddr_address1State = check member.Employer.WorkplacePhysicalAddress.address1_state;
        string? wplcPhysicalAddr_address1Country = check member.Employer.WorkplacePhysicalAddress.address1_country;

        do {
            json dtlResp = check db_ops:mergeWplcPhysicalAddr(dssClient, epHost = hostDss, hdrSeq = hdrSeq, dtlSer = dtlSer, hdrFlag = 1, address1Line1 = wplcPhysicalAddr_address1Line1 ?: "null", 
                                                       address1Line2 = wplcPhysicalAddr_address1Line2 ?: "null", address1City = wplcPhysicalAddr_address1City ?: "null", 
                                                       address1Postalcode = wplcPhysicalAddr_address1Postalcode ?: "null", address1State = wplcPhysicalAddr_address1State ?: "null", 
                                                       address1Country = wplcPhysicalAddr_address1Country ?: "null", recMsg = "");

            msgThread = msgThread + " | " + <string>check dtlResp.response.io_rec_msg;
            
        } on fail error e {
            msg = string `mergeWplcPhysicalAddr failed : ${e.toString()}`;
            io:println(`contractsProcessing :: ${msg}`);

            check db_ops:mergeDetails(dssClient = dssClient, epHost = hostDss, hdrSeq = hdrSeq, dtlSer = dtlSer, dtlFlag = 0, recMsg = msg);

            json resp = {"status": 0, "msg": msg};
            return resp;
        }

        // tbl_user_training_cntrc_dtls
        string? trainingCntrcDtls_hsdTrainingcontractstatus = check member.TrainingContract.TrainingContractDetails.hsd_trainingcontractstatus;
        //io:println(`${i} ::: tbl_user_training_cntrc_dtls : trainingCntrcDtls_hsdTrainingcontractstatus : ${trainingCntrcDtls_hsdTrainingcontractstatus}`);
        string? trainingCntrcDtls_hsdUseridentifier = check member.TrainingContract.TrainingContractDetails.hsd_useridentifier;
        string? trainingCntrcDtls_hsdCommencementdate = check member.TrainingContract.TrainingContractDetails.hsd_commencementdate;
        string? trainingCntrcDtls_hsdNominalcompletiondate = check member.TrainingContract.TrainingContractDetails.hsd_nominalcompletiondate;
        string? trainingCntrcDtls_hsdProbationperiod = check member.TrainingContract.TrainingContractDetails.hsd_probationperiod;
        string? trainingCntrcDtls_hsdDeterminationcode = check member.TrainingContract.TrainingContractDetails.hsd_determinationcode;
        string? trainingCntrcDtls_hsdDeterminationname = check member.TrainingContract.TrainingContractDetails.hsd_determinationname;
        string? trainingCntrcDtls_hsdStatuschanged = check member.TrainingContract.TrainingContractDetails.hsd_statuschanged;
        string? trainingCntrcDtls_hsdTrainingorganisationid = check member.TrainingContract.TrainingContractDetails.hsd_trainingorganisationid;
        string? trainingCntrcDtls_hsdTerminationdate = check member.TrainingContract.TrainingContractDetails.hsd_terminationdate;
        string? trainingCntrcDtls_hsdSchoolname = check member.TrainingContract.TrainingContractDetails.hsd_SchoolName;
        string? trainingCntrcDtls_hsdSchemetype = check member.TrainingContract.TrainingContractDetails.hsd_schemetype;

        do {
            json dtlResp = check db_ops:mergeTrainingCntrcDtls(dssClient, epHost = hostDss, hdrSeq = hdrSeq, dtlSer = dtlSer, hdrFlag = 1, hsdTrainingcontractstatus = trainingCntrcDtls_hsdTrainingcontractstatus ?: "null", 
                                                        hsdUseridentifier = trainingCntrcDtls_hsdUseridentifier ?: "null", hsdCommencementdate = trainingCntrcDtls_hsdCommencementdate ?: "null", 
                                                        hsdNominalcompletiondate = trainingCntrcDtls_hsdNominalcompletiondate ?: "null", hsdProbationperiod = trainingCntrcDtls_hsdProbationperiod ?: "null", 
                                                        hsdDeterminationcode = trainingCntrcDtls_hsdDeterminationcode ?: "null", hsdDeterminationname = trainingCntrcDtls_hsdDeterminationname ?: "null", 
                                                        hsdStatuschanged = trainingCntrcDtls_hsdStatuschanged ?: "null", hsdTrainingorganisationid = trainingCntrcDtls_hsdTrainingorganisationid ?: "null", 
                                                        hsdTerminationdate = trainingCntrcDtls_hsdTerminationdate ?: "null", hsdSchoolname = trainingCntrcDtls_hsdSchoolname ?: "null", 
                                                        hsdSchemetype = trainingCntrcDtls_hsdSchemetype ?: "null", recMsg = "");

            msgThread = msgThread + " | " + <string>check dtlResp.response.io_rec_msg;
                                                                    
        } on fail error e {
            msg = string `mergeTrainingCntrcDtls failed : ${e.toString()}`;
            io:println(`contractsProcessing :: ${msg}`);

            check db_ops:mergeDetails(dssClient = dssClient, epHost = hostDss, hdrSeq = hdrSeq, dtlSer = dtlSer, dtlFlag = 0, recMsg = msg);

            json resp = {"status": 0, "msg": msg};
            return resp;
        }

        // tbl_user_qualification
        string? hsdCode = check member.TrainingContract.Qualification.hsd_code;
        //io:println(`contractsProcessing :: ${i} ::: tbl_user_qualification : hsdCode : ${hsdCode}`);
        string? hsdDeltacode = check member.TrainingContract.Qualification.hsd_deltacode;
        string? hsdQualificationname = check member.TrainingContract.Qualification.hsd_qualificationname;
        string? hsdVersion = check member.TrainingContract.Qualification.hsd_version;

        do {
            json dtlResp = check db_ops:mergeQualification(dssClient, epHost = hostDss, hdrSeq = hdrSeq, dtlSer = dtlSer, hdrFlag = 1, hsdCode = hsdCode ?: "null", 
                                                    hsdDeltacode = hsdDeltacode ?: "null", hsdQualificationname = hsdQualificationname ?: "null", 
                                                    hsdVersion = hsdVersion ?: "null", recMsg = "");

            msgThread = msgThread + " | " + <string>check dtlResp.response.io_rec_msg;
                                                                
        } on fail error e {
            msg = string `mergeQualification failed : ${e.toString()}`;
            io:println(`contractsProcessing :: ${msg}`);

            check db_ops:mergeDetails(dssClient = dssClient, epHost = hostDss, hdrSeq = hdrSeq, dtlSer = dtlSer, dtlFlag = 0, recMsg = msg);

            json resp = {"status": 0, "msg": msg};
            return resp;
        }
        
        // tbl_user_anp_dtls
        string? anpDtls_hsdUseridentifier = check member.TrainingContract.ANPDetails.hsd_useridentifier;
        //io:println(`contractsProcessing :: ${i} ::: tbl_user_anp_dtls : anpDtls_hsdUseridentifier : ${anpDtls_hsdUseridentifier}`);
        string? anpDtls_hsdLegalname = check member.TrainingContract.ANPDetails.hsd_legalname;

        do {
            json dtlResp = check db_ops:mergeAnpDtls(dssClient, epHost = hostDss, hdrSeq = hdrSeq, dtlSer = dtlSer, hdrFlag = 1, 
                                              hsdUseridentifier = anpDtls_hsdUseridentifier ?: "null", 
                                              hsdLegalname = anpDtls_hsdLegalname ?: "null", recMsg = "");

            msgThread = msgThread + " | " + <string>check dtlResp.response.io_rec_msg;
                                                          
        } on fail error e {
            msg = string `mergeAnpDtls failed : ${e.toString()}`;
            io:println(`contractsProcessing :: ${msg}`);

            check db_ops:mergeDetails(dssClient = dssClient, epHost = hostDss, hdrSeq = hdrSeq, dtlSer = dtlSer, dtlFlag = 0, recMsg = msg);
            
            json resp = {"status": 0, "msg": msg};
            return resp;
        }

        // tbl_user_dtl
        do {
            check db_ops:mergeDetails(dssClient = dssClient, epHost = hostDss, hdrSeq = hdrSeq, dtlSer = dtlSer, dtlFlag = 1, recMsg = msgThread+" | #End[Choreo]#");
        } on fail error e {
            msg = string `mergeDetails failed : ${e.toString()}`;
            io:println(`contractsProcessing :: ${msg}`);
            json resp = {"status": 0, "msg": msg};
            return resp;
        }

        i += 1;                
    }

    json resp = {"status": 1, "msg": msg};
    return resp;
}
