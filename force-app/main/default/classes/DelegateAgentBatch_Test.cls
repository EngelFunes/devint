@isTest (SeeAllData=false)
public class DelegateAgentBatch_Test {
    private static testmethod void TestDelegateAgentBatch() {
        User u  = [SELECT ID,Name from User WHERE Id =: UserInfo.getUserId()];
         Account AORSRacc;
        Account AORSRacc1; 
        Contact conta1;
        Contact conta2;
        Contact conta3;
        system.runAs(u){
            AORSRacc = GA_OBJ_TD01_TestDataCreation.AccRec();
            AORSRacc.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Customer').getRecordTypeId();
            database.insert(AORSRacc);
            
            AORSRacc1 = GA_OBJ_TD01_TestDataCreation.AccRec();
            AORSRacc1.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Customer').getRecordTypeId();
            database.insert(AORSRacc1);
           
              contact conta =  GA_OBJ_TD01_TestDataCreation.cntactRec(AORSRacc.id);
            conta.recordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact - Agent').getRecordTypeId();
            database.insert(conta); 
            
          conta1 =  GA_OBJ_TD01_TestDataCreation.cntactRec(AORSRacc.id);
            conta1.recordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact - Agent').getRecordTypeId();
            conta1.vlocity_ins__Type__c  = 'Agent';
            conta1.Batch_Action_Flag__c ='Updated To Agent';
            conta1.ARV_Is_Mass_Updating__c = true;
            database.insert(conta1); 
            
            conta2 =  GA_OBJ_TD01_TestDataCreation.cntactRec(AORSRacc1.id);
            conta2.recordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact - Agent').getRecordTypeId();
            conta2.vlocity_ins__Type__c  = 'Delegate';
            conta2.Batch_Action_Flag__c ='Updated To Agent';
            conta2.ARV_Is_Mass_Updating__c = true;
            database.insert(conta2); 
            system.debug('--->test conlist'+conta2);
            
            conta3 =  GA_OBJ_TD01_TestDataCreation.cntactRec(AORSRacc.id);
            conta3.recordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact - Agent').getRecordTypeId();
            conta3.vlocity_ins__Type__c  = 'Agent and Delegate';
            conta3.Batch_Action_Flag__c ='Updated To Agent';
            conta3.ARV_Is_Mass_Updating__c = true;
            database.insert(conta3); 
            system.debug('--->test conlist'+conta3);
            
            
            List<GA_Aor__C> GAAOCLIST = New List<GA_Aor__C>();
            GA_Aor__C agentacctRelation = GA_OBJ_TD01_TestDataCreation.createAOR(AORSRacc,conta1);
            agentacctRelation.GA_Service_Start_Date__c =  Date.newInstance(2020, 2, 1);
            agentacctRelation.GA_Account_Id__c = AORSRacc.id;
            agentacctRelation.GA_Contact_Id__c = conta1.id;
            agentacctRelation.isStatusDatesModified__c = True;
            database.insert(agentacctRelation); 
            GAAOCLIST.add(agentacctRelation);
            
              list<user> usrLst=new list<user>();
            user hisusr = GA_OBJ_TD01_TestDataCreation.UsrRec('BCBSMTest Partner User','testsalesrepmail@bcbsm.com','BCBSM Both');
            hisusr.ContactId = conta1.id;
            hisusr.IsActive = True;
            usrLst.add(hisusr);
            user usr1 = GA_OBJ_TD01_TestDataCreation.UsrRec('TestBCBSM','testsysadm@bcbsm.com','BCBSM Agent');
            usr1.ContactId = conta2.Id;
            usr1.IsActive = True;
            usrLst.add(usr1);
             user usr2 = GA_OBJ_TD01_TestDataCreation.UsrRec('TestBCBSM','testsysadm@bcbsm.com','BCBSM Agent');
             usr2.ContactId = conta3.Id;
            usr2.IsActive = True;
            usrLst.add(usr2);
            
            insert usrLst;
     
        }
        
            AORSRacc = GA_OBJ_TD01_TestDataCreation.AccRec();
            AORSRacc.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Customer').getRecordTypeId();
            database.insert(AORSRacc);
           
              contact conta =  GA_OBJ_TD01_TestDataCreation.cntactRec(AORSRacc.id);
            conta.recordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact - Agent').getRecordTypeId();
            database.insert(conta);
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestBCBSM','testsysadm@bcbsm.com','BCBSM Agent');
        usr.ContactId = conta.Id;
        database.insert(usr);
        system.runAs(usr){
            
            DelegateAgentBatch  Gaupdateaorsrb = new DelegateAgentBatch();
            Test.startTest();
            ID GA_UpdateAORSRBOBBatchid = Database.executeBatch(Gaupdateaorsrb);
            Test.stopTest();
        }
    }
    
    private static testmethod void TestDelegateAgentBatch2() {
        User u  = [SELECT ID,Name from User WHERE Id =: UserInfo.getUserId()];
         Account AORSRacc;
        Account AORSRacc1;
        Contact conta1;
        Contact conta2;
        Contact conta3;
        system.runAs(u){
            AORSRacc = GA_OBJ_TD01_TestDataCreation.AccRec();
            AORSRacc.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Customer').getRecordTypeId();
            database.insert(AORSRacc);
            
            AORSRacc1 = GA_OBJ_TD01_TestDataCreation.AccRec();
            AORSRacc1.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Customer').getRecordTypeId();
            database.insert(AORSRacc1);
            
              conta1 =  GA_OBJ_TD01_TestDataCreation.cntactRec(AORSRacc.id);
            conta1.recordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact - Agent').getRecordTypeId();
            conta1.vlocity_ins__Type__c  = 'Agent';
            conta1.Batch_Action_Flag__c ='Updated To Agent';
            conta1.ARV_Is_Mass_Updating__c = true;
            database.insert(conta1); 
            system.debug('--->test conlist'+conta1);
            
            conta2 =  GA_OBJ_TD01_TestDataCreation.cntactRec(AORSRacc.id);
            conta2.recordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact - Agent').getRecordTypeId();
            conta2.vlocity_ins__Type__c  = 'Delegate';
            conta2.Batch_Action_Flag__c ='Updated To Agent';
            conta2.ARV_Is_Mass_Updating__c = true;
            database.insert(conta2); 
            system.debug('--->test conlist'+conta2);
            
            conta3 =  GA_OBJ_TD01_TestDataCreation.cntactRec(AORSRacc.id);
            conta3.recordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact - Agent').getRecordTypeId();
            conta3.vlocity_ins__Type__c  = 'Agent and Delegate';
            conta3.Batch_Action_Flag__c ='Updated To Agent';
            conta3.ARV_Is_Mass_Updating__c = true;
            database.insert(conta3); 
            system.debug('--->test conlist'+conta3);
            
            
            List<GA_Aor__C> GAAOCLIST = New List<GA_Aor__C>();
            GA_Aor__C agentacctRelation = GA_OBJ_TD01_TestDataCreation.createAOR(AORSRacc,conta1);
            agentacctRelation.GA_Service_Start_Date__c =  Date.newInstance(2020, 2, 1);
            agentacctRelation.GA_Account_Id__c = AORSRacc.id;
            agentacctRelation.GA_Contact_Id__c = conta1.id;
            agentacctRelation.isStatusDatesModified__c = True;
            database.insert(agentacctRelation); 
            GAAOCLIST.add(agentacctRelation);
        }
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestBCBSM','testsysadm@bcbsm.com','BCBSM Agent');
        usr.ContactId = conta1.Id;
        database.insert(usr);
        system.runAs(usr){
            
            DelegateAgentBatch  Gaupdateaorsrb = new DelegateAgentBatch();
            Test.startTest();
            ID GA_UpdateAORSRBOBBatchid = Database.executeBatch(Gaupdateaorsrb);
            Test.stopTest();
        }
    }
   /**   private static testmethod void TestGA_DelegateContactBOBBatc2() {
        
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestSysAdm','testsysadm@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr){
            
            Test.startTest();
            String CRON_EXP = '0 0 0 3 9 ? 2099';
            String jobId = System.schedule('DelegateAgentBatch',  CRON_EXP, new DelegateAgentBatch());            
            CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
            System.assertEquals(CRON_EXP, ct.CronExpression);
            System.assertEquals(0, ct.TimesTriggered);
            Test.stopTest();
        } 
    }    **/  
}