@isTest (SeeAllData=false)
public class DelegateAgentAndAgentSharingBatch_Test {
    private static testmethod void TestDelegateAgentAndAgentSharingBatch() {
        
        User u  = [SELECT ID,Name from User WHERE Id =: UserInfo.getUserId()];
        Account AORSRacc;
        Account AORSRacc1;
        Contact conta;
        Contact conta1;
        system.runAs(u){
            AORSRacc = GA_OBJ_TD01_TestDataCreation.AccRec();
            AORSRacc.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Customer').getRecordTypeId();
            database.insert(AORSRacc);
            
            AORSRacc1 = GA_OBJ_TD01_TestDataCreation.AccRec();
            AORSRacc1.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Customer').getRecordTypeId();
            database.insert(AORSRacc1);
            
            
            conta =  GA_OBJ_TD01_TestDataCreation.cntactRec(AORSRacc.id);
            conta.recordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact - Agent').getRecordTypeId();
            conta.vlocity_ins__Type__c  = 'Agent and Delegate';
            conta.Batch_Action_Flag__c ='Updated To Agent';
            conta.ARV_Is_Mass_Updating__c = true;
            database.insert(conta); 
            system.debug('--->test conlist'+conta);
            
            conta1 =  GA_OBJ_TD01_TestDataCreation.cntactRec(AORSRacc.id);
            conta1.recordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact - Agent').getRecordTypeId();
            conta1.vlocity_ins__Type__c  = 'Agent';
            conta1.Batch_Action_Flag__c ='Updated To Agent';
            conta1.ARV_Is_Mass_Updating__c = true;
            conta1.Delegate_Contact__c = true;
            database.insert(conta1); 
            system.debug('--->test conlist'+conta);
            
            Contact conta2 =  GA_OBJ_TD01_TestDataCreation.cntactRec(AORSRacc.id);
            conta2.recordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact - Agent').getRecordTypeId();
            conta2.vlocity_ins__Type__c  = 'Delegate';
            conta2.Batch_Action_Flag__c ='Updated To Agent';
            conta2.ARV_Is_Mass_Updating__c = true;
            database.insert(conta2); 
            system.debug('--->test conlist'+conta);
            
            contact conta3 =  GA_OBJ_TD01_TestDataCreation.cntactRec(AORSRacc.id);
            conta3.recordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact - Agent').getRecordTypeId();
            conta3.vlocity_ins__Type__c  = 'Agent and Delegate';
            conta3.Batch_Action_Flag__c ='Updated To Agent';
            conta3.ARV_Is_Mass_Updating__c = true;
            database.insert(conta3); 
            system.debug('--->test conlist'+conta3);
            
            contact conta4 =  GA_OBJ_TD01_TestDataCreation.cntactRec(AORSRacc.id);
            conta4.recordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact - Agent').getRecordTypeId();
            conta4.vlocity_ins__Type__c  = 'Agent and Delegate';
            conta4.Batch_Action_Flag__c ='Updated to DA';
            conta4.ARV_Is_Mass_Updating__c = true;
            database.insert(conta4); 
            system.debug('--->test conlist'+conta4);
            
           
            user usr1 = GA_OBJ_TD01_TestDataCreation.UsrRec('TestBCBSM','testsysadm@bcbsm.com','BCBSM Agent');
            usr1.ContactId = conta1.Id;
            usr1.IsActive = True;
            insert usr1;
            
            List<GA_Aor__C> GAAOCLIST = New List<GA_Aor__C>();
            GA_Aor__C agentacctRelation = GA_OBJ_TD01_TestDataCreation.createAOR(AORSRacc,conta);
            agentacctRelation.GA_Account_Id__c = AORSRacc.id;
            agentacctRelation.GA_Contact_Id__c = conta.id;
            agentacctRelation.isStatusDatesModified__c = True;
            database.insert(agentacctRelation); 
            GAAOCLIST.add(agentacctRelation);
            
            GA_Aor__C agentacctRelation1 = GA_OBJ_TD01_TestDataCreation.createAOR(AORSRacc1,conta1);
            agentacctRelation1.GA_Account_Id__c = AORSRacc1.id;
            agentacctRelation1.GA_Contact_Id__c = conta1.id;
            agentacctRelation1.isStatusDatesModified__c = True;
            database.insert(agentacctRelation1);
            GAAOCLIST.add(agentacctRelation1);
        }
        
        DelegateAgentAndAgentSharingBatch  Gaupdateaorsrb = new DelegateAgentAndAgentSharingBatch();
        Test.startTest();
        ID GA_UpdateAORSRBOBBatchid = Database.executeBatch(Gaupdateaorsrb);
        Test.stopTest();
        
    }
    
}