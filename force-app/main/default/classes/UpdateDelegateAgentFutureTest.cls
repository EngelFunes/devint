@isTest
public class UpdateDelegateAgentFutureTest {
     private static testmethod void TestUpdateDelegateAgentFutureTest() {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec(System.label.User_Profile_Name_MAUser,'testsysadm@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr){
            Account AORSRacc = GA_OBJ_TD01_TestDataCreation.AccRec();
            AORSRacc.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Customer').getRecordTypeId();
            database.insert(AORSRacc);
            
            Account AORSRacc1 = GA_OBJ_TD01_TestDataCreation.AccRec();
            AORSRacc1.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Customer').getRecordTypeId();
            database.insert(AORSRacc1);
            
            Contact conta =  GA_OBJ_TD01_TestDataCreation.cntactRec(AORSRacc.id);
            conta.recordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact - Delegate').getRecordTypeId();
            conta.Active__c = True;
            database.insert(conta); 
            
            Contact conta1 =  GA_OBJ_TD01_TestDataCreation.cntactRec(AORSRacc.id);
            conta1.recordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact - Delegate').getRecordTypeId();
            conta1.Active__c = True;
            conta1.Delegate_Contact__c = True;
            conta1.vlocity_ins__Type__c = 'Delegate Agent';
            database.insert(conta1);
            
            Contact conta2 =  GA_OBJ_TD01_TestDataCreation.cntactRec(AORSRacc.id);
            conta2.recordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact - Agent').getRecordTypeId();
            conta2.Active__c = True;
            database.insert(conta2);
            
            Contact conta3 =  GA_OBJ_TD01_TestDataCreation.cntactRec(AORSRacc.id);
            conta3.recordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact - Agent').getRecordTypeId();
            conta3.Active__c = True;
            database.insert(conta3); 
            

            set<id> caseLst = New set<id>();
            case cas=GA_OBJ_TD01_TestDataCreation.CaseRec();
            cas.AccountId = AORSRacc.id;
            cas.FSA_Delegated_Agent__c = usr.id;
            Database.insert(cas);
            caseLst.add(cas.id);
            case cas1 =GA_OBJ_TD01_TestDataCreation.CaseRec();
            cas1.AccountId = AORSRacc1.id;
            cas1.FSA_Delegated_Agent__c = usr.id;
            Database.insert(cas1);
            caseLst.add(cas1.id);          
            Test.startTest();
            UpdateDelegateAgentFuture.updateDelegateAgentOnCase(caseLst,usr.id,'testsysadm@bcbsm.com','Delegate Agent');
            Test.stopTest();
        }
    }   

}