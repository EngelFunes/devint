@isTest(seealldata = false)
public class GA_Account_TriggerHandler_Test {
    private static testmethod void agntIdentityBatchSlsRep()
    {
        list<user> usrLst=new list<user>();
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestJeoRl','testsalesrepmail@bcbsm.com','Retention Sales');
        usrLst.add(usr);
        user usrRetSlsRep = GA_OBJ_TD01_TestDataCreation.UsrRec('TestJeoRlRetnslsRep','testsalesrepmail@bcbsm.com','Retention Sales');
        usrLst.add(usrRetSlsRep);
        user usrRetSlsRep2 = GA_OBJ_TD01_TestDataCreation.UsrRec('TestJeoRlRetnsls2Rep','testsalesrep2mail@bcbsm.com','Retention Sales');
        usrLst.add(usrRetSlsRep2);
        database.insert(usrLst);
        
         Account acctest = GA_OBJ_TD01_TestDataCreation.AccRec();
        insert acctest;
        
        Id devRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact - Agent').getRecordTypeId();
        Contact contest = GA_OBJ_TD01_TestDataCreation.cntactRec(acctest.Id);
        contest.Active__c = true;
        contest.RecordTypeId = devRecordTypeId;
        insert contest;
        List<GA_AOR__c> GAAorList = New List<GA_AOR__c>();
        GA_AOR__c Gatest = new GA_AOR__c();
        Gatest.Name = 'Test Agent';
        Gatest.GA_Account_Id__c = acctest.Id;
        Gatest.GA_Contact_Id__c = contest.Id;
        Gatest.GA_Service_End_Date__c = system.today() + 10;
        GAAorList.add(Gatest);
        insert GAAorList;
        
        List<Account> acc = [Select Id, Account_Status__c from Account where Name = 'Test Acc'];
        if(acc != null && acc.size() > 0){
            acc[0].Account_Status__c = 'Inactive';
            update acc[0];
            GA_Account_TriggerHandler.handleAORsOnAccount(acc);
        }
        
    }
    
}