@isTest
public class GA_UpdateAORSRShareBOBBatchTest {
    private static testmethod void TestGA_UpdateAORSRShareBOBBatch() {
        
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestSysAdm','testsysadm@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr){
            
            Account AORSRacc = GA_OBJ_TD01_TestDataCreation.AccRec();
            AORSRacc.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Customer').getRecordTypeId();
            database.insert(AORSRacc);
            
            Account AORSRacc1 = GA_OBJ_TD01_TestDataCreation.AccRec();
            AORSRacc1.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Customer').getRecordTypeId();
            database.insert(AORSRacc1);
            
            Contact conta =  GA_OBJ_TD01_TestDataCreation.cntactRec(AORSRacc.id);
            conta.recordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact - Agent').getRecordTypeId();
            database.insert(conta); 
            
            Contact conta1 =  GA_OBJ_TD01_TestDataCreation.cntactRec(AORSRacc.id);
            conta1.recordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact - Agent').getRecordTypeId();
            database.insert(conta1);
            
            List<GA_Aor__C> GAAOCLIST = New List<GA_Aor__C>();
            GA_Aor__C agentacctRelation = GA_OBJ_TD01_TestDataCreation.createAOR(AORSRacc,conta);
                agentacctRelation.GA_Account_Id__c = AORSRacc.id;
                agentacctRelation.GA_Contact_Id__c = conta.id;
                agentacctRelation.isStatusDatesModified__c = True;
            database.insert(agentacctRelation); 
            
            GA_Aor__C agentacctRelation1 = GA_OBJ_TD01_TestDataCreation.createAOR(AORSRacc,conta);
                agentacctRelation1.GA_Account_Id__c = AORSRacc1.id;
                agentacctRelation1.GA_Contact_Id__c = conta1.id;
            agentacctRelation1.isStatusDatesModified__c = True;
            database.insert(agentacctRelation1); 
            
            GAAOCLIST.add(agentacctRelation);
            GAAOCLIST.add(agentacctRelation1);
 
            GA_UpdateAORSRShareBOBBatch  Gaupdateaorsrb = new GA_UpdateAORSRShareBOBBatch();
          
            Test.startTest();
            GA_updateAORBoB.supportRequestShareBatchUpdateBoB(GAAOCLIST);
            ID GA_UpdateAORSRBOBBatchid = Database.executeBatch(Gaupdateaorsrb);
            Test.stopTest();
        }
    }
    
     private static testmethod void TestUpdateAORSRBOBbatchschedule() {
        
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestSysAdm','testsysadm@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr){
            
            Test.startTest();
            String CRON_EXP = '0 0 0 3 9 ? 2099';
            String jobId = System.schedule('UpdateAORSRBOBbatchschedule',  CRON_EXP, new GA_UpdateAORSRShareBOBBatch());            
            CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
            System.assertEquals(CRON_EXP, ct.CronExpression);
            System.assertEquals(0, ct.TimesTriggered);
            Test.stopTest();
        } 
    }    

}