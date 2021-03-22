@isTest
Private class GA_DelegateContactBOBBatchTest {
    
    private static testmethod void TestGA_DelegateContactBOBBatch() {
        
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestSysAdm','testsysadm@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr){
                       List<Contact> contactlist = New List<Contact>();
                       List<CaseShare> caseSharestobeshared = new List<CaseShare>();
            
             Account AORSRacc = GA_OBJ_TD01_TestDataCreation.AccRec();
            AORSRacc.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Customer').getRecordTypeId();
            database.insert(AORSRacc);
            
            Account AORSRacc1 = GA_OBJ_TD01_TestDataCreation.AccRec();
            AORSRacc1.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Customer').getRecordTypeId();
            database.insert(AORSRacc1);
            
            Contact conta =  GA_OBJ_TD01_TestDataCreation.cntactRec(AORSRacc.id);
            conta.recordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact - Delegate').getRecordTypeId();
            conta.Active__c = True;
            conta.Delegate_Contact__c = True;
            conta.vlocity_ins__Type__c = 'Delegate Agent';
            contactlist.add(conta);
            
            Contact conta1 =  GA_OBJ_TD01_TestDataCreation.cntactRec(AORSRacc.id);
            conta1.recordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact - Delegate').getRecordTypeId();
            conta1.Active__c = True;
            conta1.Delegate_Contact__c = false;
            conta1.vlocity_ins__Type__c = 'Delegate Agent';
            contactlist.add(conta1);
            database.insert(contactlist);

        
             GA_DelegateContactBOBBatch  Gaupdateaorsrb = new GA_DelegateContactBOBBatch();
          
            Test.startTest();
            DelegateContactBOBBatchHelper.delegateContactAccountCaseBOB(contactlist);
            ID GA_UpdateAORSRBOBBatchid = Database.executeBatch(Gaupdateaorsrb);
            Test.stopTest();
        }
    }   
    
        private static testmethod void TestGA_DelegateContactBOBBatch2() {
        
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestSysAdm','testsysadm@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr){
            
            Test.startTest();
            String CRON_EXP = '0 0 0 3 9 ? 2099';
            String jobId = System.schedule('GA_DelegateContactBOBBatch',  CRON_EXP, new GA_DelegateContactBOBBatch());            
            CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
            System.assertEquals(CRON_EXP, ct.CronExpression);
            System.assertEquals(0, ct.TimesTriggered);
            Test.stopTest();
        }
    }   
}