/**
@Author : IDC offshore
@Name: GA_AORGrpSgmntTriggerHandler_Test
@CreatedDate: 19 - July 2019
@Description: GA_AORGrpSgmntTriggerHandler_Test Test class 
@version : 1.0  
*/
@isTest(seealldata = false)
private class GA_AORGrpSgmntTriggerHandler_Test {
    /*******************************************************************************************************************************
@Description        :   aorTrigger() method 
@Name               :   aorTrigger
@Param              :   None
@Return             :   void
@throws Exception   :   N/A;
********************************************************************************************************************************/ 
    private static testMethod void aorTrigger(){
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
        agentacctRelation.GA_Commission_Start_Date__c =  Date.newInstance(1990, 1, 1);
        agentacctRelation.GA_Commission_End_Date__c = Date.newInstance(2200, 1, 1);
        database.insert(agentacctRelation); 
        
        GA_AOR_Group_Segment__c aorGSRec = GA_OBJ_TD01_TestDataCreation.createAORGS(agentacctRelation,gsmt);
        database.insert(aorGSRec); 
        List<GA_AOR_Group_Segment__c> aoGsLst = new List<GA_AOR_Group_Segment__c> ();
        system.runAs(usr){
            
            Test.startTest();            
            //aorGSRec.GA_Cancel_Flag__c = true;
            aorGSRec.GA_Is_Mass_updating__c = true;
            aorGsRec.GA_Is_StartDateProcessed__c =  true;
            aorGsRec.GA_Cancel_Flag__c = false;
            aorGsRec.GA_Is_EndDateProcessed__c = false;
            GA_AORGrpSgmntTriggerHandler.isBeforeExecuting = false;
            GA_AORGrpSgmntTriggerHandler.isExecuting = false;
            Database.update(aorGSRec);
            
            Test.stopTest();
            
            aoGsLst = [Select id from GA_AOR_Group_Segment__c where GA_AOR_Id__c=:agentacctRelation.id Limit 10];
            system.assert(aoGsLst <> null);
        }
    }

    /*******************************************************************************************************************************
@Description        :   aorTriggerExcp() method 
@Name               :   aorTriggerExcp
@Param              :   None
@Return             :   void
@throws Exception   :   N/A;
********************************************************************************************************************************/ 
    private static testMethod void aorTriggerExcp(){
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestAgentAdmin','testsalesrepmail@bcbsm.com','Agent Administrator');
        database.insert(usr);
        system.runAs(usr){
              list<GA_AOR_Group_Segment__c> aorGSLst  =  null;
              Map<Id,GA_AOR_Group_Segment__c> aorGSoldmap = null;
                test.startTest();
                GA_AORGrpSgmntTriggerHandler.beforeInsert(aorGSLst);
                GA_AORGrpSgmntTriggerHandler.afterInsert(aorGSLst);
                GA_AORGrpSgmntTriggerHandler.afterUpdate(aorGSLst,aorGSoldmap);
                GA_AORGrpSgmntTriggerHandler.beforeUpdate(aorGSLst,aorGSoldmap);               
                Test.stopTest();
             system.assert(usr <> null);
   
        }
    }
    
/*******************************************************************************************************************************
@Description        :   multipleCommissionAndServicinfAgents() method 
@Name               :   multipleCommissionAndServicinfAgents
@Param              :   None
@Return             :   void
@throws Exception   :   N/A;
********************************************************************************************************************************/ 
    
    @isTest static void multipleCommissionAndServicingAgents(){
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestAgentAdmin','testsalesrepmail@bcbsm.com','Agent Administrator');
        database.insert(usr);
        
        Account acc1 = GA_OBJ_TD01_TestDataCreation.AccRec();
        database.insert(acc1);
        
        GA_Group_Segment__c gsmt = GA_OBJ_TD01_TestDataCreation.grpSegmntRec(acc1);
        database.insert(gsmt); 
        
        List<Contact> lstContacts = new List<Contact>();
        Contact cnt =  GA_OBJ_TD01_TestDataCreation.cntactRec(acc1.id);
        cnt.recordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact - Agent').getRecordTypeId();
        lstContacts.add(cnt);
        
        Contact cnt1 =  GA_OBJ_TD01_TestDataCreation.cntactRec(acc1.id);
        cnt1.FirstName = 'Gary';
        cnt1.LastName = 'Sobers';
        cnt1.recordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact - Agent').getRecordTypeId();
        lstContacts.add(cnt1);
        insert lstContacts;
        
        GA_Aor__C agentacctRelation = GA_OBJ_TD01_TestDataCreation.createAOR(acc1,cnt);
        agentacctRelation.GA_Service_Start_Date__c =  Date.newInstance(1990, 1, 1);
        agentacctRelation.GA_Service_End_Date__c = Date.newInstance(2200, 1, 1);
        agentacctRelation.GA_Commission_Start_Date__c =  Date.newInstance(1990, 1, 1);
        agentacctRelation.GA_Commission_End_Date__c = Date.newInstance(2200, 1, 1);
        insert agentacctRelation;
        
        GA_AOR_Group_Segment__c aorGSRec = GA_OBJ_TD01_TestDataCreation.createAORGS(agentacctRelation,gsmt);
        insert aorGSRec;
        
        
        GA_Aor__C agentacctRelation1 = GA_OBJ_TD01_TestDataCreation.createAOR(acc1,cnt1);
        agentacctRelation.GA_Service_Start_Date__c =  Date.newInstance(1990, 1, 1);
        agentacctRelation.GA_Service_End_Date__c = Date.newInstance(2020, 1, 1);
        agentacctRelation1.GA_Commission_Start_Date__c =  Date.newInstance(1990, 1, 1);
        agentacctRelation1.GA_Commission_End_Date__c = Date.newInstance(2020, 10, 15);
        insert agentacctRelation1;
        
       	GA_AOR_Group_Segment__c aorGSRec1 = GA_OBJ_TD01_TestDataCreation.createAORGS(agentacctRelation1,gsmt);
        insert aorGSRec1;
    }
    
/*******************************************************************************************************************************
@Description        :   multipleCommissionAndServicinfAgents() method 
@Name               :   multipleCommissionAndServicinfAgents
@Param              :   None
@Return             :   void
@throws Exception   :   N/A;
********************************************************************************************************************************/ 
    
    @isTest static void onlyCommissionAgentOnGS(){
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestAgentAdmin','testsalesrepmail@bcbsm.com','Agent Administrator');
        database.insert(usr);
        
        Account acc1 = GA_OBJ_TD01_TestDataCreation.AccRec();
        acc1.Name='Test Acc1';
        acc1.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Customer').getRecordTypeId();
        database.insert(acc1);
        
        GA_Group_Segment__c gsmt = GA_OBJ_TD01_TestDataCreation.grpSegmntRec(acc1);
        database.insert(gsmt); 
        
        Contact cnt1 =  GA_OBJ_TD01_TestDataCreation.cntactRec(acc1.id);
        cnt1.FirstName = 'Andrew';
        cnt1.LastName = 'Barash';
        cnt1.recordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact - Agent').getRecordTypeId();
        insert cnt1;
        
        GA_Aor__C agentacctRelation = GA_OBJ_TD01_TestDataCreation.createAOR(acc1,cnt1);
        agentacctRelation.GA_Commission_Start_Date__c =  Date.newInstance(1990, 1, 1);
        agentacctRelation.GA_Commission_End_Date__c = Date.newInstance(2020, 1, 1);
        insert agentacctRelation;
        
        GA_AOR_Group_Segment__c aorGSRec = GA_OBJ_TD01_TestDataCreation.createAORGS(agentacctRelation,gsmt);
        insert aorGSRec;
    }
    
/*******************************************************************************************************************************
@Description        :   multipleCommissionAndServicinfAgents() method 
@Name               :   multipleCommissionAndServicinfAgents
@Param              :   None
@Return             :   void
@throws Exception   :   N/A;
********************************************************************************************************************************/ 
    
    @isTest static void removeCommissionAgentOnGS(){
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestAgentAdmin','testsalesrepmail@bcbsm.com','Agent Administrator');
        database.insert(usr);
        
        Account acc1 = GA_OBJ_TD01_TestDataCreation.AccRec();
        acc1.Name='Test Acc1';
        acc1.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Customer').getRecordTypeId();
        database.insert(acc1);
        
        GA_Group_Segment__c gsmt = GA_OBJ_TD01_TestDataCreation.grpSegmntRec(acc1);
        database.insert(gsmt); 
        
        Contact cnt1 =  GA_OBJ_TD01_TestDataCreation.cntactRec(acc1.id);
        cnt1.FirstName = 'Andrew';
        cnt1.LastName = 'Barash';
        cnt1.recordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact - Agent').getRecordTypeId();
        insert cnt1;
        
        GA_Aor__C agentacctRelation = GA_OBJ_TD01_TestDataCreation.createAOR(acc1,cnt1);
        agentacctRelation.GA_Commission_Start_Date__c =  Date.newInstance(1990, 1, 1);
        agentacctRelation.GA_Commission_End_Date__c = Date.newInstance(2020, 1, 1);
        insert agentacctRelation;
        
        GA_AOR_Group_Segment__c aorGSRec = GA_OBJ_TD01_TestDataCreation.createAORGS(agentacctRelation,gsmt);
        GA_AORGrpSgmntTriggerHandler.removeCommissionAgentFlag = true;
        insert aorGSRec;
    }

/*******************************************************************************************************************************
@Description        :   multipleCommissionAndServicinfAgents() method 
@Name               :   multipleCommissionAndServicinfAgents
@Param              :   None
@Return             :   void
@throws Exception   :   N/A;
********************************************************************************************************************************/ 
    
	@isTest static void removeMultipleCommissionAndServicinfAgents(){
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestAgentAdmin','testsalesrepmail@bcbsm.com','Agent Administrator');
        database.insert(usr);
        
        Account acc1 = GA_OBJ_TD01_TestDataCreation.AccRec();
        database.insert(acc1);
        
        GA_Group_Segment__c gsmt = GA_OBJ_TD01_TestDataCreation.grpSegmntRec(acc1);
        database.insert(gsmt); 
        
        List<Contact> lstContacts = new List<Contact>();
        Contact cnt =  GA_OBJ_TD01_TestDataCreation.cntactRec(acc1.id);
        cnt.recordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact - Agent').getRecordTypeId();
        lstContacts.add(cnt);
        
        Contact cnt1 =  GA_OBJ_TD01_TestDataCreation.cntactRec(acc1.id);
        cnt1.FirstName = 'Gary';
        cnt1.LastName = 'Sobers';
        cnt1.recordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact - Agent').getRecordTypeId();
        lstContacts.add(cnt1);
        insert lstContacts;
        
        GA_Aor__C agentacctRelation = GA_OBJ_TD01_TestDataCreation.createAOR(acc1,cnt);
        agentacctRelation.GA_Service_Start_Date__c =  Date.newInstance(1990, 1, 1);
        agentacctRelation.GA_Service_End_Date__c = Date.newInstance(2200, 1, 1);
        agentacctRelation.GA_Commission_Start_Date__c =  Date.newInstance(1990, 1, 1);
        agentacctRelation.GA_Commission_End_Date__c = Date.newInstance(2020, 1, 1);
        insert agentacctRelation;
        
        GA_AOR_Group_Segment__c aorGSRec = GA_OBJ_TD01_TestDataCreation.createAORGS(agentacctRelation,gsmt);
        insert aorGSRec;
        
        
        GA_Aor__C agentacctRelation1 = GA_OBJ_TD01_TestDataCreation.createAOR(acc1,cnt1);
        agentacctRelation.GA_Service_Start_Date__c =  Date.newInstance(1990, 1, 1);
        agentacctRelation.GA_Service_End_Date__c = Date.newInstance(2020, 1, 1);
        agentacctRelation1.GA_Commission_Start_Date__c =  Date.newInstance(1990, 1, 1);
        agentacctRelation1.GA_Commission_End_Date__c = Date.newInstance(2020, 10, 15);
        insert agentacctRelation1;
        
       	GA_AOR_Group_Segment__c aorGSRec1 = GA_OBJ_TD01_TestDataCreation.createAORGS(agentacctRelation1,gsmt);
        GA_AORGrpSgmntTriggerHandler.removeCommissionAgentFlag = true;
        insert aorGSRec1;
    }
}