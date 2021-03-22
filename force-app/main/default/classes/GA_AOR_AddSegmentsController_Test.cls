/**
@Author : IDC offshore
@Name: GA_AOR_AddSegmentsController_Test
@CreatedDate: 19 - June 2018 
@Description: GA_AOR_AddSegmentsController Test class 
@version : 1.0  
*/
@isTest(seealldata = false)
private class GA_AOR_AddSegmentsController_Test {
    /*******************************************************************************************************************************
@Description        :   addGroupSegmentToAOR() method 
@Name               :   addGroupSegmentToAOR
@Param              :   None
@Return             :   void
@throws Exception   :   N/A;
********************************************************************************************************************************/ 
    private static testMethod void addGroupSegmentToAOR(){
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
        database.insert(agentacctRelation); 
        
        //system.runAs(usr){
            
            GA_Trigger_Functionality_By_Pass__c trgrBypass=new GA_Trigger_Functionality_By_Pass__c();
         //   trgrBypass.SetupOwnerId=usr.ProfileId;
            trgrBypass.GA_AORAddGS__c=true;
            trgrBypass.GA_AORUpdateGS__c = true;
            database.insert(trgrBypass);
            
            String grpSegRecords = '[{"gsId":"grpId","GsName":"BAY COUNTY LIBRARY SYSTEM","isSelected":true,"Name":"204","ratingTyp":"No Cluster Code","removeAORflag":false,"Status":"Pending","typeVal":"NASCO"}]';
            grpSegRecords = grpSegRecords.replace('grpId', String.valueOf(gsmt.Id)); 
            
            
            
            Test.startTest();
            GA_AOR_AddSegmentsController.fetchAccsgrSgmntLst(acc1.id, agentacctRelation.id);
            GA_AOR_AddSegmentsController.createAORGSrecords(grpSegRecords, agentacctRelation.id);
            GA_AOR_AddSegmentsController.checkAORaccess(agentacctRelation.id);
            GA_AOR_AddSegmentsController.saveCommissioninfo(agentacctRelation.id, true, Date.newInstance(2200, 1, 1), 'Hi');
            Test.stopTest();
            
            List<GA_AOR_Group_Segment__c> aoGsLst = [Select id from GA_AOR_Group_Segment__c where GA_AOR_Id__c=:agentacctRelation.id ];
            system.assert(aoGsLst <> null);
       // }
    }
    
}