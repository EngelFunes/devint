@isTest
public class GA_AgentSoldGroupTriggerHandler_Test 
{
	@isTest
    static void testValidateASG1()
    {
    	
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestUnderwriter','TestUnderwriter@bcbsm.com','System Administrator');
        database.insert(usr);
        
        // Run as test user context
        system.runAs(usr)
        {
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
            /*
            case cas=GA_OBJ_TD01_TestDataCreation.CaseRec();
            cas.recordtypeid=Schema.SObjectType.Case.getRecordTypeInfosByName().get('Support - Issues').getRecordTypeId();
            cas.AccountId = acc.id;
            cas.GA_IssuesCategory__c='Administration';
            database.insert(cas);
            */
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
            
            ASGrpRecd.GA_Benefit_Effective_Date__c  = system.Today()+2;
            update ASGrpRecd;
        
        }         
    }
}