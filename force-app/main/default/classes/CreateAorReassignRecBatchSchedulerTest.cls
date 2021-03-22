@isTest
public class CreateAorReassignRecBatchSchedulerTest {
    
    @isTest private static  void aorTrigger(){
        
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestAgentAdmin','testsalesrepmail@bcbsm.com','Agent Administrator');
        database.insert(usr);
        
        Account acc1 = GA_OBJ_TD01_TestDataCreation.AccRec();
        database.insert(acc1);
        
        GA_Group_Segment__c gsmt = GA_OBJ_TD01_TestDataCreation.grpSegmntRec(acc1);
        database.insert(gsmt); 
        
        Contact cnt =  GA_OBJ_TD01_TestDataCreation.cntactRec(acc1.id);
        cnt.recordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact - Agent').getRecordTypeId();
        database.insert(cnt); 
        
        GA_Aor__C agentacctRelation = GA_OBJ_TD01_TestDataCreation.createAOR(acc1,cnt);
        agentacctRelation.GA_Service_Start_Date__c =  Date.newInstance(1990, 1, 1);
        agentacctRelation.GA_Service_End_Date__c = Date.newInstance(2200, 1, 1);
        database.insert(agentacctRelation); 
        
        GA_AOR_Group_Segment__c aorGSRec = GA_OBJ_TD01_TestDataCreation.createAORGS(agentacctRelation,gsmt);
        database.insert(aorGSRec); 
        
        GA_Aor__C aorRec = GA_OBJ_TD01_TestDataCreation.createAOR(acc1,cnt);
        aorRec.GA_Service_Start_Date__c =  Date.newInstance(1990, 1, 1);
        aorRec.GA_Service_End_Date__c =system.today();
        aorRec.GA_Commission_Start_Date__c =  Date.newInstance(1990, 1, 1);
        aorRec.GA_Commission_End_Date__c =system.today();
        aorRec.GA_Process_Date__c=system.today();
        aorRec.GA_Customer_Letter_Type__c ='AOR Normal (Group)';
        database.insert(aorRec); 
        
        AOR_Reassign__c aorAssign = new AOR_Reassign__c();
        aorAssign.AccountId__c = acc1.Id;
        aorAssign.To_Contact__c = cnt.Id;
        aorAssign.Service_Start_Date__c = System.today();
        aorAssign.AOR__c = aorRec.Id;
        aorAssign.Processed__c = false;
        aorAssign.AOR_Group_Segment__c = aorGSRec.Id;
        insert aorAssign;
        
        CreateAorReassignRecBatchScheduler.scheduleMe();
        Database.executeBatch(new CreateAorReassignRecBatch (), 200);     
        
        
    }
}