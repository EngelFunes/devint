@isTest 
public class UpdateAorSegmentControllerTest {
    
    @isTest static void testSetup(){
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
        
        GA_AOR_Group_Segment__c aorGsRec2 = new GA_AOR_Group_Segment__c ();
        aorGsRec2.Name = 'Test';
        aorGsRec2.GA_AOR_Id__c = agentacctRelation.id;
        aorGsRec2.GA_Group_Segment_Id__c = gsmt.id;
        GA_AORGrpSgmntTriggerHandler.isBeforeExecuting = false;
        database.insert(aorGsRec2); 
        
        UpdateAorSegmentController.updateAorSegment(new List<GA_Group_Segment__c>{gsmt});
        System.assertEquals(2, [select id from GA_AOR__c].size());
    }
}