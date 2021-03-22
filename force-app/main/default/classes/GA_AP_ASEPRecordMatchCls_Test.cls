/*
@Author : IDC Offshore
@Name: GA_AP_ASEPRecordMatchCls_Test 
@CreatedDate: 16 - Nov 2018 
@Description: GA_AP_ASEPRecordMatchCls Test class
@version : 1.0
*/
@isTest
private class GA_AP_ASEPRecordMatchCls_Test {
    
    /**
@Description: AprvASEPRcrdMatch() method 
@Name : AprvASEPRcrdMatch
@Param : N/A   
@Return : void
@throws Exception : N/A;
*/     
    private static testmethod void AprvASEPRcrdMatch()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestUnderwriter','TestUnderwriter@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {
            try {
                GA_WFT_workflow__c wfTemp = GA_OBJ_TD01_TestDataCreation.wrkFlwTmplt();
                wfTemp.Name='BCBSM Agent Sold Enrollment - New Business';
                wfTemp.GA_Carrier__c='BCBSM';
                database.insert(wfTemp);
                
                GA_WFT_Inventory_Step__c wfInvStp = GA_OBJ_TD01_TestDataCreation.wfInventoryStp();
                database.insert(wfInvStp);
                
                GA_WFT_Inventory_Step__c wfInvStp1 = GA_OBJ_TD01_TestDataCreation.wfInventoryStp();
                database.insert(wfInvStp1);
                
                GA_WFT_Step__c wftStp = GA_OBJ_TD01_TestDataCreation.wrkTmpStp(wfTemp,wfInvStp);
                database.insert(wftStp);
                
                GA_WFT_Allowed_Next_Step__c wftNxtStp = GA_OBJ_TD01_TestDataCreation.wfAlwdNxtStp(wftStp);
                database.insert(wftNxtStp);
                
                Account acc=GA_OBJ_TD01_TestDataCreation.AccRec();
                acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Prospect').getRecordTypeId();
                acc.Federal_Tax_ID__c ='23245';
                database.insert(acc);    
                
                Account assctnAcc = GA_OBJ_TD01_TestDataCreation.AccRec();
                assctnAcc.Name = 'Test Assctn Acc';
                assctnAcc.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Association').getRecordTypeId();
                database.insert(assctnAcc);
                
                Account agncyAcc = GA_OBJ_TD01_TestDataCreation.AccRec();
                agncyAcc.Name = 'Test Assctn Acc';
                agncyAcc.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Agency').getRecordTypeId();
                database.insert(agncyAcc);
                
                case cas=GA_OBJ_TD01_TestDataCreation.CaseRec();
                cas.recordtypeid=Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('GA_Support_Issues').getRecordTypeId();
                //cas.recordtypeid=Schema.SObjectType.Case.getRecordTypeInfosByName().get('Support - Issues').getRecordTypeId();
                cas.AccountId = acc.id;
                cas.GA_IssuesCategory__c='Administration';
                database.insert(cas);
                
                Contact  cntc=GA_OBJ_TD01_TestDataCreation.cntactRec(acc.id);
                cntc.FirstName='First';
                cntc.MiddleName='Middle';
                cntc.LastName='Last';
                cntc.Email='testcntc@gmail.com';
                cntc.Phone='1234567890';
                cntc.MobilePhone='1234567890';
                cntc.Active__c=False;              
                database.insert(Cntc);
                
                Contact  cntcAgnt=GA_OBJ_TD01_TestDataCreation.cntactRec(acc.id);
                cntcAgnt.recordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact - Agent').getRecordTypeId();
                cntcAgnt.FirstName='First';
                cntcAgnt.MiddleName='Middle';
                cntcAgnt.LastName='Last';
                cntcAgnt.Email='testcntc@gmail.com';
                cntcAgnt.Phone='4234567890';
                cntcAgnt.MobilePhone='3244567890';
                cntcAgnt.Active__c=False;       
                database.insert(cntcAgnt);
                
                List<Contact> Cntclst= new List<Contact>();
                Cntclst.add(Cntc);
                Cntclst.add(cntcAgnt);
                
                acc.GA_Decision_Maker__c=cntc.Id;
                database.update(acc);
                
                GA_Agent_Sold_Contact__c ASCntRecd=GA_OBJ_TD01_TestDataCreation.agntSoldContact(); 
                ASCntRecd.GA_First_Name__c='First';
                ASCntRecd.GA_Last_Name__c='Last';
                ASCntRecd.GA_Email__c='testcntc@gmail.com';
                ASCntRecd.GA_Phone__c='1234567890';
                database.insert(ASCntRecd);    
                
                List<GA_Agent_Sold_Contact__c> ASCntlst= new List<GA_Agent_Sold_Contact__c>();
                ASCntlst.add(ASCntRecd);
                
                List<id> ASCntlstid= new List<id>();
                ASCntlstid.add(ASCntRecd.id);
                
                GA_Agent_Sold_Enrollment__c ASEnrlRecd=GA_OBJ_TD01_TestDataCreation.agentSoldEnrollemnt(ASCntRecd);
                ASEnrlRecd.Name='Test ASEnrlRecd';
                ASEnrlRecd.GA_ASEP_Processed__c = True;
                ASEnrlRecd.GA_Account_Id__c = acc.id;
                ASEnrlRecd.GA_Federal_Tax_ID__c ='23245';
                ASEnrlRecd.GA_Account_Name__c = acc.Name;
                ASEnrlRecd.GA_Principal_Admin__c = ASCntRecd.Id;
                ASEnrlRecd.GA_Decision_Maker__c = ASCntRecd.Id;
                ASEnrlRecd.GA_Carrier__c = 'BCBSM';
                ASEnrlRecd.GA_ASEP_Status__c = 'Approved';                                     
                ASEnrlRecd.GA_CEO__c = ASCntRecd.Id;
                ASEnrlRecd.GA_Mutual_Voter__c = ASCntRecd.Id;   
                ASEnrlRecd.GA_CID__c = '132';
                database.insert(ASEnrlRecd);
                
                List<GA_Agent_Sold_Enrollment__c> ASEnrllst= new List<GA_Agent_Sold_Enrollment__c>();
                ASEnrllst.add(ASEnrlRecd);
                
                string ASEnrllststring= ASEnrlRecd.id;
                
                id ASEnrlID = ASEnrlRecd.id;
                
                GA_Agent_Sold_Group__c ASGrpRecd = new GA_Agent_Sold_Group__c();
                ASGrpRecd.Name = 'Test ASG2';
                ASGrpRecd.GA_Group_Number__c = '1234';
                ASGrpRecd.GA_Managing_Agent_Sale_Enroll_Id__c = ASEnrlRecd.Id;
                ASGrpRecd.GA_Benefit_Effective_Date__c = system.Today();
                ASGrpRecd.GA_Billing_Contact_Id__c = ASCntRecd.Id;
                ASGrpRecd.GA_Administrative_Contact_Id__c = ASCntRecd.Id;
                ASGrpRecd.GA_Agent_Id__c = cntcAgnt.Id;
                ASGrpRecd.GA_Managing_Agency_Code__c = '12';
                ASGrpRecd.GA_Billing_City__c = 'Delton';
                ASGrpRecd.GA_Physical_City__c = 'Delton';
                ASGrpRecd.GA_Mailing_City__c = 'Delton';
                ASGrpRecd.GA_Association_Id__c = assctnAcc.id;
                database.insert(ASGrpRecd);  
                
                List<GA_Agent_Sold_Group__c> ASGrplst= new List<GA_Agent_Sold_Group__c>();
                ASGrplst.add(ASGrpRecd);
                
                List<id> ASGrplstid= new List<id>();
                ASGrplstid.add(ASGrpRecd.id);
                
                string ASGrplststring= ASGrpRecd.id;
                
                string ASEPRecsts = ASEnrlRecd.GA_ASEP_Status__c;
                
                GA_Trigger_Functionality_By_Pass__c trgrBypass=new GA_Trigger_Functionality_By_Pass__c();
                trgrBypass.SetupOwnerId=usr.ProfileId;
                trgrBypass.GA_ASEP_Approve__c=true;
                database.insert(trgrBypass);
                
                test.startTest();
                GA_AP_ASEPRecordMatchCls.fetchASEPReadonlyInfo(ASEnrlRecd.Id);
                GA_AP_ASEPRecordMatchCls.fetchAccInfo(ASEnrlRecd.Id);
                GA_AP_ASEPRecordMatchCls.fetchCntInfo(ASEnrlRecd.id, acc.id, 'Account - Prospect');
                GA_AP_ASEPRecordMatchCls.fetchExtngCnt(ASCntRecd.Id+'~'+cntc.ID, '[{"agntSldCnt":{"Id":\"'+ASCntRecd.Id+'\","Name":"Prasant Satpathy","GA_First_Name__c":"Prasant","GA_Last_Name__c":"Satpathy","GA_Email__c":"pks4@gmail.com"},"CntRle":"Billing Contact","ObjInfo":"Group Segment: 1234"}]');
                GA_AP_ASEPRecordMatchCls.updateASContacts(ASCntRecd.Id+'~'+cntc.ID, acc, ASEnrlRecd, ASGrplst, '[{"agntSldCnt":{"Id":\"'+ASCntRecd.Id+'\","Name":"Prasant Satpathy","GA_First_Name__c":"Prasant","GA_Last_Name__c":"Satpathy","GA_Email__c":"pks4@gmail.com"},"CntRle":"Billing Contact","ObjInfo":"Group Segment: 1234"}]');
                GA_AP_ASEPRecordMatchCls.newAccountASEPPrcss(ASEnrlRecd, acc, ASGrplst);
                test.stopTest();    
            }
            catch(exception e)
            {
                return;
            }
        }
    }
    /**
@Description: New2AprvASEPRcrdMatch() method 
@Name : New2AprvASEPRcrdMatch
@Param : N/A   
@Return : void
@throws Exception : N/A;
*/     
    private static testmethod void New2AprvASEPRcrdMatch()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestUnderwriter','TestUnderwriter@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {
            try {
                GA_WFT_workflow__c wfTemp = GA_OBJ_TD01_TestDataCreation.wrkFlwTmplt();
                database.insert(wfTemp);
                
                GA_WFT_Inventory_Step__c wfInvStp = GA_OBJ_TD01_TestDataCreation.wfInventoryStp();
                database.insert(wfInvStp);
                
                GA_WFT_Inventory_Step__c wfInvStp1 = GA_OBJ_TD01_TestDataCreation.wfInventoryStp();
                database.insert(wfInvStp1);
                
                GA_WFT_Step__c wftStp = GA_OBJ_TD01_TestDataCreation.wrkTmpStp(wfTemp,wfInvStp);
                database.insert(wftStp);
                
                GA_WFT_Allowed_Next_Step__c wftNxtStp = GA_OBJ_TD01_TestDataCreation.wfAlwdNxtStp(wftStp);
                database.insert(wftNxtStp);
                
                Account acc=GA_OBJ_TD01_TestDataCreation.AccRec();
                acc.Federal_Tax_ID__c ='23245';
                database.insert(acc);    
                
                Account agncyAcc = GA_OBJ_TD01_TestDataCreation.AccRec();
                agncyAcc.Name = 'Test Assctn Acc';
                agncyAcc.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Agency').getRecordTypeId();
                database.insert(agncyAcc);
                
                case cas=GA_OBJ_TD01_TestDataCreation.CaseRec();
                cas.recordtypeid=Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('GA_Support_Issues').getRecordTypeId();
                //cas.recordtypeid=Schema.SObjectType.Case.getRecordTypeInfosByName().get('Support - Issues').getRecordTypeId();
                cas.AccountId = acc.id;
                cas.GA_IssuesCategory__c='Administration';
                database.insert(cas);
                
                Contact cntc=GA_OBJ_TD01_TestDataCreation.cntactRec(acc.id);
                cntc.FirstName='First';
                cntc.MiddleName='Middle';
                cntc.LastName='Last';
                cntc.Email='testcntc@gmail.com';
                cntc.Phone='1234567890';
                cntc.MobilePhone='1234567890';
                cntc.Active__c=False; 
                database.insert(Cntc);
                
                List<Contact> Cntclst= new List<Contact>();
                Cntclst.add(Cntc);
                
                acc.GA_Decision_Maker__c=cntc.Id;
                database.update(acc);
                
                GA_Agent_Sold_Contact__c ASCntRecd=GA_OBJ_TD01_TestDataCreation.agntSoldContact(); 
                ASCntRecd.GA_First_Name__c='First';
                ASCntRecd.GA_Last_Name__c='Last';
                ASCntRecd.GA_Email__c='testcntc@gmail.com';
                ASCntRecd.GA_Phone__c='1234567890';
                database.insert(ASCntRecd);    
                
                List<GA_Agent_Sold_Contact__c> ASCntlst= new List<GA_Agent_Sold_Contact__c>();
                ASCntlst.add(ASCntRecd);
                
                List<id> ASCntlstid= new List<id>();
                ASCntlstid.add(ASCntRecd.id);
                
                GA_Agent_Sold_Enrollment__c ASEnrlRecd=GA_OBJ_TD01_TestDataCreation.agentSoldEnrollemnt(ASCntRecd);
                ASEnrlRecd.Name='Test ASEnrlRecd';
                ASEnrlRecd.GA_ASEP_Processed__c = True;
                ASEnrlRecd.GA_Account_Id__c = acc.id;
                ASEnrlRecd.GA_Federal_Tax_ID__c ='23245';
                ASEnrlRecd.GA_Account_Name__c = acc.Name;
                ASEnrlRecd.GA_Principal_Admin__c = ASCntRecd.Id;
                ASEnrlRecd.GA_Decision_Maker__c = ASCntRecd.Id;
                ASEnrlRecd.GA_Carrier__c = 'BCBSM';
                ASEnrlRecd.GA_ASEP_Status__c = 'New';                                     
                ASEnrlRecd.GA_CEO__c = ASCntRecd.Id;
                ASEnrlRecd.GA_Mutual_Voter__c = ASCntRecd.Id;   
                ASEnrlRecd.GA_CID__c = '132';
                database.insert(ASEnrlRecd);
                
                ASEnrlRecd.GA_ASEP_Status__c = 'Approved';
                database.update(ASEnrlRecd);
                
                List<GA_Agent_Sold_Enrollment__c> ASEnrllst= new List<GA_Agent_Sold_Enrollment__c>();
                ASEnrllst.add(ASEnrlRecd);
                
                string ASEnrllststring= ASEnrlRecd.id;
                
                id ASEnrlID = ASEnrlRecd.id;
                
                GA_Agent_Sold_Group__c ASGrpRecd = new GA_Agent_Sold_Group__c();
                ASGrpRecd.Name = 'Test ASG2';
                ASGrpRecd.GA_Group_Number__c = '1234';
                ASGrpRecd.GA_Managing_Agent_Sale_Enroll_Id__c = ASEnrlRecd.Id;
                ASGrpRecd.GA_Benefit_Effective_Date__c = system.Today();
                ASGrpRecd.GA_Billing_Contact_Id__c = ASCntRecd.Id;
                ASGrpRecd.GA_Administrative_Contact_Id__c = ASCntRecd.Id;
                ASGrpRecd.GA_Billing_City__c = 'Delton';
                ASGrpRecd.GA_Physical_City__c = 'Delton';
                ASGrpRecd.GA_Mailing_City__c = 'Delton';
                ASGrpRecd.GA_Suite__c = 'SUITE A';
                ASGrpRecd.GA_Suite_Start_Date__c = system.now();
                ASGrpRecd.GA_Managing_Agency_Id__c = agncyAcc.id;
                database.insert(ASGrpRecd);  
                
                List<GA_Agent_Sold_Group__c> ASGrplst= new List<GA_Agent_Sold_Group__c>();
                ASGrplst.add(ASGrpRecd);
                
                List<id> ASGrplstid= new List<id>();
                ASGrplstid.add(ASGrpRecd.id);
                
                string ASGrplststring= ASGrpRecd.id;
                
                string ASEPRecsts = ASEnrlRecd.GA_ASEP_Status__c;
                
                test.startTest();
                GA_AP_ASEPRecordMatchCls.fetchASEPReadonlyInfo(ASEnrlRecd.Id);
                GA_AP_ASEPRecordMatchCls.fetchAccInfo(ASEnrlRecd.Id);
                GA_AP_ASEPRecordMatchCls.fetchCntInfo(ASEnrlRecd.id, acc.id, 'Account - Prospect');
                GA_AP_ASEPRecordMatchCls.fetchExtngCnt(ASCntRecd.Id+'~'+cntc.ID, '[{"agntSldCnt":{"Id":\"'+ASCntRecd.Id+'\","Name":"Prasant Satpathy","GA_First_Name__c":"Prasant","GA_Last_Name__c":"Satpathy","GA_Email__c":"pks4@gmail.com"},"CntRle":"Billing Contact","ObjInfo":"Group Segment: 1234"}]');
                GA_AP_ASEPRecordMatchCls.updateASContacts(ASCntRecd.Id+'~'+cntc.ID, acc, ASEnrlRecd, ASGrplst, '[{"agntSldCnt":{"Id":\"'+ASCntRecd.Id+'\","Name":"Prasant Satpathy","GA_First_Name__c":"Prasant","GA_Last_Name__c":"Satpathy","GA_Email__c":"pks4@gmail.com"},"CntRle":"Billing Contact","ObjInfo":"Group Segment: 1234"}]');
                GA_AP_ASEPRecordMatchCls.newAccountASEPPrcss(ASEnrlRecd, acc, ASGrplst);
                test.stopTest();    
            }
            catch(exception e)
            {
                return;
            }
        }
    }
    
    /**
@Description: NoAccAprvASEPRcrdMatch() method 
@Name : NoAccAprvASEPRcrdMatch
@Param : N/A   
@Return : void
@throws Exception : N/A;
*/     
    private static testmethod void NoAccAprvASEPRcrdMatch()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestUnderwriter','TestUnderwriter@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {
            try {
                GA_WFT_workflow__c wfTemp = GA_OBJ_TD01_TestDataCreation.wrkFlwTmplt();
                wfTemp.Name='BCBSM Agent Sold Enrollment - New Business';
                wfTemp.GA_Carrier__c='BCBSM';
                database.insert(wfTemp);
                GA_WFT_Inventory_Step__c wfInvStp = GA_OBJ_TD01_TestDataCreation.wfInventoryStp();
                database.insert(wfInvStp);
                
                GA_WFT_Inventory_Step__c wfInvStp1 = GA_OBJ_TD01_TestDataCreation.wfInventoryStp();
                database.insert(wfInvStp1);
                
                GA_WFT_Step__c wftStp = GA_OBJ_TD01_TestDataCreation.wrkTmpStp(wfTemp,wfInvStp);
                database.insert(wftStp);
                
                GA_WFT_Allowed_Next_Step__c wftNxtStp = GA_OBJ_TD01_TestDataCreation.wfAlwdNxtStp(wftStp);
                database.insert(wftNxtStp);
                
                Account acc=GA_OBJ_TD01_TestDataCreation.AccRec();
                acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Prospect').getRecordTypeId();
                acc.Federal_Tax_ID__c ='23245';
                database.insert(acc);    
                
                case cas=GA_OBJ_TD01_TestDataCreation.CaseRec();
                cas.recordtypeid=Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('GA_Support_Issues').getRecordTypeId();
                //cas.recordtypeid=Schema.SObjectType.Case.getRecordTypeInfosByName().get('Support - Issues').getRecordTypeId();
                cas.AccountId = acc.id;
                cas.GA_IssuesCategory__c='Administration';
                database.insert(cas);
                
                Contact  cntc=GA_OBJ_TD01_TestDataCreation.cntactRec(acc.id);
                cntc.FirstName='First';
                cntc.MiddleName='Middle';
                cntc.LastName='Last';
                cntc.Email='testcntc@gmail.com';
                cntc.Phone='1234567890';
                cntc.MobilePhone='1234567890';
                cntc.Active__c=False;              
                database.insert(Cntc);
                
                List<Contact> Cntclst= new List<Contact>();
                Cntclst.add(Cntc);
                
                acc.GA_Decision_Maker__c=cntc.Id;
                database.update(acc);
                
                GA_Agent_Sold_Contact__c ASCntRecd=GA_OBJ_TD01_TestDataCreation.agntSoldContact(); 
                ASCntRecd.GA_First_Name__c='First';
                ASCntRecd.GA_Last_Name__c='Last';
                ASCntRecd.GA_Email__c='testcntc@gmail.com';
                ASCntRecd.GA_Phone__c='1234567890';
                ASCntRecd.GA_Matched_Contact__c=Cntc.Id;
                database.insert(ASCntRecd);    
                
                List<GA_Agent_Sold_Contact__c> ASCntlst= new List<GA_Agent_Sold_Contact__c>();
                ASCntlst.add(ASCntRecd);
                
                List<id> ASCntlstid= new List<id>();
                ASCntlstid.add(ASCntRecd.id);
                
                GA_Agent_Sold_Enrollment__c ASEnrlRecd=GA_OBJ_TD01_TestDataCreation.agentSoldEnrollemnt(ASCntRecd);
                ASEnrlRecd.Name='Test ASEnrlRecd';
                ASEnrlRecd.GA_ASEP_Processed__c = True;
                ASEnrlRecd.GA_Account_Id__c = acc.id;
                ASEnrlRecd.GA_Federal_Tax_ID__c ='23245';
                ASEnrlRecd.GA_Account_Name__c = acc.Name;
                ASEnrlRecd.GA_Principal_Admin__c = ASCntRecd.Id;
                ASEnrlRecd.GA_Decision_Maker__c = ASCntRecd.Id;
                ASEnrlRecd.GA_Carrier__c = 'BCBSM';
                ASEnrlRecd.GA_ASEP_Status__c = 'Approved';                                     
                ASEnrlRecd.GA_CEO__c = ASCntRecd.Id;
                ASEnrlRecd.GA_Mutual_Voter__c = ASCntRecd.Id;   
                ASEnrlRecd.GA_CID__c = '132';
                database.insert(ASEnrlRecd);
                
                List<GA_Agent_Sold_Enrollment__c> ASEnrllst= new List<GA_Agent_Sold_Enrollment__c>();
                ASEnrllst.add(ASEnrlRecd);
                
                string ASEnrllststring= ASEnrlRecd.id;
                
                id ASEnrlID = ASEnrlRecd.id;
                
                GA_Agent_Sold_Group__c ASGrpRecd = new GA_Agent_Sold_Group__c();
                ASGrpRecd.Name = 'Test ASG2';
                ASGrpRecd.GA_Group_Number__c = '1234';
                ASGrpRecd.GA_Managing_Agent_Sale_Enroll_Id__c = ASEnrlRecd.Id;
                ASGrpRecd.GA_Benefit_Effective_Date__c = system.Today();
                ASGrpRecd.GA_Billing_Contact_Id__c = ASCntRecd.Id;
                ASGrpRecd.GA_Administrative_Contact_Id__c = ASCntRecd.Id;
                ASGrpRecd.GA_Billing_City__c = 'Delton';
                ASGrpRecd.GA_Physical_City__c = 'Delton';
                ASGrpRecd.GA_Mailing_City__c = 'Delton';
                
                database.insert(ASGrpRecd);  
                
                List<GA_Agent_Sold_Group__c> ASGrplst= new List<GA_Agent_Sold_Group__c>();
                ASGrplst.add(ASGrpRecd);
                
                List<id> ASGrplstid= new List<id>();
                ASGrplstid.add(ASGrpRecd.id);
                
                string ASGrplststring= ASGrpRecd.id;
                
                string ASEPRecsts = ASEnrlRecd.GA_ASEP_Status__c;
                
                test.startTest();
                GA_AP_ASEPRecordMatchCls.fetchASEPReadonlyInfo(ASEnrlRecd.Id);
                GA_AP_ASEPRecordMatchCls.fetchAccInfo(ASEnrlRecd.Id);
                GA_AP_ASEPRecordMatchCls.fetchCntInfo(ASEnrlRecd.id, acc.id, 'Account - Prospect');
                GA_AP_ASEPRecordMatchCls.fetchExtngCnt(ASCntRecd.Id+'~'+cntc.ID, '[{"agntSldCnt":{"Id":\"'+ASCntRecd.Id+'\","Name":"Prasant Satpathy","GA_First_Name__c":"Prasant","GA_Last_Name__c":"Satpathy","GA_Email__c":"pks4@gmail.com"},"CntRle":"Billing Contact","ObjInfo":"Group Segment: 1234"}]');
                GA_AP_ASEPRecordMatchCls.updateASContacts(ASCntRecd.Id+'~'+cntc.ID, acc, ASEnrlRecd, ASGrplst, '[{"agntSldCnt":{"Id":\"'+ASCntRecd.Id+'\","Name":"Prasant Satpathy","GA_First_Name__c":"Prasant","GA_Last_Name__c":"Satpathy","GA_Email__c":"pks4@gmail.com"},"CntRle":"Billing Contact","ObjInfo":"Group Segment: 1234"}]');
                GA_AP_ASEPRecordMatchCls.newAccountASEPPrcss(ASEnrlRecd, null, ASGrplst);
                test.stopTest();
            }
            catch(exception e)
            {
                return;
            }
        }
    }       
}