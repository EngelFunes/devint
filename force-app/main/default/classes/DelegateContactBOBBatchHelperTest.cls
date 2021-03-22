@isTest
public class DelegateContactBOBBatchHelperTest {
 private static testmethod void TestDelegateContactBOBBatchHelper() {
        UserRole userrole = [Select Id, DeveloperName From UserRole Where DeveloperName = 'System_Administrator' Limit 1];
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('System Administrator','testsysadm@bcbsm.com','System Administrator');
        usr.UserRoleId  = userrole.id;
        database.insert(usr);
        system.runAs(usr){
            List<Contact> contactlist = New List<Contact>();
            
            Account AORSRacc = GA_OBJ_TD01_TestDataCreation.AccRec();
            AORSRacc.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Customer').getRecordTypeId();
            database.insert(AORSRacc);
            
            Account AORSRacc1 = GA_OBJ_TD01_TestDataCreation.AccRec();
            AORSRacc1.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Customer').getRecordTypeId();
            database.insert(AORSRacc1);
            
            Contact conta =  GA_OBJ_TD01_TestDataCreation.cntactRec(AORSRacc.id);
            conta.recordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact - Agent').getRecordTypeId();
            conta.Active__c = True;
            database.insert(conta); 
            contactlist.add(conta);

            
            Contact conta2 =  GA_OBJ_TD01_TestDataCreation.cntactRec(AORSRacc.id);
            conta2.recordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact - Agent').getRecordTypeId();
            conta2.Active__c = false;
            database.insert(conta2);
              contactlist.add(conta2);

            List<GA_Aor__C> GAAOCLIST = New List<GA_Aor__C>();
            GA_Aor__C agentacctRelation = GA_OBJ_TD01_TestDataCreation.createAOR(AORSRacc,conta);
            agentacctRelation.GA_Service_Start_Date__c =  Date.newInstance(2020, 1, 1);
            agentacctRelation.GA_Service_End_Date__c = Date.newInstance(2021, 2, 1);
            agentacctRelation.GA_Account_Id__c = AORSRacc.id;
            agentacctRelation.GA_Contact_Id__c = conta.id;
            database.insert(agentacctRelation); 
            
            GA_Aor__C agentacctRelation1 = GA_OBJ_TD01_TestDataCreation.createAOR(AORSRacc1,conta2);
            agentacctRelation1.GA_Service_Start_Date__c =  Date.newInstance(2020, 2, 1);
            agentacctRelation1.GA_Service_End_Date__c = Date.newInstance(2022, 2, 1);
            agentacctRelation1.GA_Account_Id__c = AORSRacc1.id;
            agentacctRelation1.GA_Contact_Id__c = conta2.id;
            database.insert(agentacctRelation1); 
            
            GAAOCLIST.add(agentacctRelation);
            GAAOCLIST.add(agentacctRelation1);
            
             List<case> caseLst = New List<case>();
            case cas=GA_OBJ_TD01_TestDataCreation.CaseRec();
            cas.AccountId = AORSRacc.id;
            caseLst.add(cas);
            case cas1 =GA_OBJ_TD01_TestDataCreation.CaseRec();
            cas1.AccountId = AORSRacc1.id;
            caseLst.add(cas1);
            Database.insert(caseLst);
            
              list<user> usrLst=new list<user>();
            user hisusr = GA_OBJ_TD01_TestDataCreation.UsrRec('BCBSMTest Partner User','testsalesrepmail@bcbsm.com','BCBSM Both');
            hisusr.ContactId = conta2.id;
            hisusr.IsActive = True;
            usrLst.add(hisusr);
            
            insert usrLst;

           // List<CaseShare> caseShareobj = [Select Caseid,UserOrGroupId from CaseShare];
            
            Test.startTest();
            DelegateContactBOBBatchHelper.delegateContactAccountCaseBOB(contactlist);
            Test.stopTest();
        }
    }   
    
}