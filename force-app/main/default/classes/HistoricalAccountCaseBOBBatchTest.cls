@isTest
Private class HistoricalAccountCaseBOBBatchTest {
    
    private static testmethod void TestHistoricalAccountCaseBOBBatch() {
        UserRole userrole = [Select Id, DeveloperName From UserRole Where DeveloperName = 'System_Administrator' Limit 1];
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('System Administrator','testsysadm@bcbsm.com','System Administrator');
        usr.UserRoleId  = userrole.id;
        database.insert(usr);
        system.runAs(usr){
            List<Account> Acclist = New List<Account>();
            Account AORSRacc = GA_OBJ_TD01_TestDataCreation.AccRec();
            AORSRacc.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Customer').getRecordTypeId();
            database.insert(AORSRacc);
            Acclist.add(AORSRacc);
            
            Account AORSRacc1 = GA_OBJ_TD01_TestDataCreation.AccRec();
            AORSRacc1.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Customer').getRecordTypeId();
            database.insert(AORSRacc1);
            
            Contact conta =  GA_OBJ_TD01_TestDataCreation.cntactRec(AORSRacc.id);
            conta.recordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact - Delegate').getRecordTypeId();
            conta.Active__c = True;
            conta.vlocity_ins__Type__c = 'Agent and Delegate';
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
            
            List<GA_Aor__C> GAAOCLIST = New List<GA_Aor__C>();
            GA_Aor__C agentacctRelation = GA_OBJ_TD01_TestDataCreation.createAOR(AORSRacc,conta);
            agentacctRelation.GA_Service_Start_Date__c =  Date.newInstance(2020, 1, 1);
            agentacctRelation.GA_Service_End_Date__c = Date.newInstance(2021, 2, 1);
            agentacctRelation.GA_Account_Id__c = AORSRacc.id;
            agentacctRelation.GA_Contact_Id__c = conta2.id;
            database.insert(agentacctRelation); 
            
            GA_Aor__C agentacctRelation1 = GA_OBJ_TD01_TestDataCreation.createAOR(AORSRacc1,conta1);
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
            hisusr.ContactId = conta.id;
            hisusr.IsActive = True;
            usrLst.add(hisusr);
            
            insert usrLst;
            
            case ca =GA_OBJ_TD01_TestDataCreation.CaseRec();
            database.insert(ca);
            List<CaseShare> caseShareobj = [Select Caseid,UserOrGroupId from CaseShare];
            CaseShareSeq02Batch cshare = new CaseShareSeq02Batch(caseShareobj);
            HistoricalAccountCaseBOBBatch   Gaupdateaorsrb = new HistoricalAccountCaseBOBBatch();
            
            Test.startTest();
            ID GA_UpdateAORSRBOBBatchid = Database.executeBatch(Gaupdateaorsrb);
            ID CaseShareSeq02Batchid = Database.executeBatch(cshare);
            HistoricalAccountCaseBOBBatch.shareHistoricalData(Acclist);
            Test.stopTest();
        }
    }   
    
    private static testmethod void TestGA_DelegateContactBOBBatch2() {
        
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestSysAdm','testsysadm@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr){
            
            Test.startTest();
            String CRON_EXP = '0 0 0 3 9 ? 2099';
            String jobId = System.schedule('HistoricalAccountCaseBOBBatch',  CRON_EXP, new HistoricalAccountCaseBOBBatch());            
            CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
            System.assertEquals(CRON_EXP, ct.CronExpression);
            System.assertEquals(0, ct.TimesTriggered);
            Test.stopTest();
        } 
    }    
}