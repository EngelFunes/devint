/*
@Author : Eswararao Rajana
@Name: ServicingAgentSREmailTest 
@CreatedDate: 	19-AUG-2020 
@Description: ServicingAgentSREmail Test class
@version : 1.0  
*/
@isTest
public class ServicingAgentSREmailTest {
     private static testmethod void TestServicingAgentSREmail() {
       
         user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('System Administrator','testsysadm@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr){
          
            Account AORSRacc = GA_OBJ_TD01_TestDataCreation.AccRec();
            AORSRacc.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Customer').getRecordTypeId();
            database.insert(AORSRacc);
            Contact conta =  GA_OBJ_TD01_TestDataCreation.cntactRec(AORSRacc.id);
            conta.recordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact - Delegate').getRecordTypeId();
            conta.Active__c = True;
            conta.Email =  'reswar89@gmail.com';
            database.insert(conta); 

            Account AORSRacc1 = GA_OBJ_TD01_TestDataCreation.AccRec();
            AORSRacc1.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Customer').getRecordTypeId();
            AORSRacc1.Servicing_Agent__c = conta.id;
            database.insert(AORSRacc1);
            
             Account AORSRacc2 = GA_OBJ_TD01_TestDataCreation.AccRec();
            AORSRacc2.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Customer').getRecordTypeId();
            AORSRacc2.Servicing_Agent__c = conta.id;
            database.insert(AORSRacc2);
            
             Account AORSRacc3 = GA_OBJ_TD01_TestDataCreation.AccRec();
            AORSRacc3.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Customer').getRecordTypeId();
            AORSRacc3.Servicing_Agent__c = conta.id;
            database.insert(AORSRacc3);
            
            List<id> caseLst = New List<id>();
            case cas=GA_OBJ_TD01_TestDataCreation.CaseRec();
            cas.AccountId = AORSRacc2.id;
            cas.Status ='Submitted';
            cas.FSA_Delegated_Agent__c = usr.id;
            Database.insert(cas);
            caseLst.add(cas.id);
            case cas1 =GA_OBJ_TD01_TestDataCreation.CaseRec();
            cas1.AccountId = AORSRacc1.id;
            cas1.FSA_Delegated_Agent__c = usr.id;
            cas1.Status ='In Progress';
            Database.insert(cas1);
            caseLst.add(cas1.id);
            case cas2 =GA_OBJ_TD01_TestDataCreation.CaseRec();
            cas2.AccountId = AORSRacc3.id;
            cas2.FSA_Delegated_Agent__c = usr.id;
            cas2.Status ='Closed';
            Database.insert(cas2);
            caseLst.add(cas2.id);
           
            Test.startTest();
            ServicingAgentSREmail.sendEmailtoASRSalesrepFuture(caseLst);
            Test.stopTest();
        }
    }   

}