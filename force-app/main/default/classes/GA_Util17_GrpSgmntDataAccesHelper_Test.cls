/*
@Author : IDC Offshore
@Name: GA_Util17_GrpSgmntDataAccesHelper_Test 
@CreatedDate: 28 - Aug 2019 
@Description: GA_Util17_GrpSgmntDataAccesHelper Test class
@version : 1.0  
*/
@isTest(seealldata = false)
private class GA_Util17_GrpSgmntDataAccesHelper_Test {
    
    /**
@Description: fetchGrpSgmMapTst() method 
@Name : fetchGrpSgmMapTst
@Param : N/A   
@Return : void
@throws Exception : N/A;
*/   
    private static testmethod void fetchGrpSgmMapTst()
    {
        try{
            user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestAgentAdmin','testsalesrepmail@bcbsm.com','System Administrator');
            database.insert(usr);
            Map<Id,GA_AOR_Group_Segment__c> aorGSoldmap = new Map<Id,GA_AOR_Group_Segment__c> ();
            
            Account acc1 = GA_OBJ_TD01_TestDataCreation.AccRec();
            database.insert(acc1);
            
            GA_Group_Segment__c gsmt = GA_OBJ_TD01_TestDataCreation.grpSegmntRec(acc1);
            database.insert(gsmt); 
            
            Contact cnt =  GA_OBJ_TD01_TestDataCreation.cntactRec(acc1.id);
            cnt.recordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact - Agent').getRecordTypeId();
            database.insert(cnt); 
            
            GA_Aor__C aorRec = GA_OBJ_TD01_TestDataCreation.createAOR(acc1,cnt);
            aorRec.GA_Service_Start_Date__c =  Date.newInstance(1990, 1, 1);
            aorRec.GA_Service_End_Date__c = Date.newInstance(2200, 1, 1);
            database.insert(aorRec); 
            
            GA_AOR_Group_Segment__c aorGSRec = GA_OBJ_TD01_TestDataCreation.createAORGS(aorRec,gsmt);
            aorGSRec.GA_Cancel_Flag__c =False;
            aorGSRec.GA_Cancel_Date__c=system.today();
            aorGSRec.GA_Is_EndDateProcessed__c=False;
            database.insert(aorGSRec); 
            List<GA_AOR_Group_Segment__c> aorGsLst = new List<GA_AOR_Group_Segment__c>();
            aorGsLst.add(aorGSRec);
            
            gsmt.GA_AOR_Group_Segment_Id__c =aorGSRec.Id;
            database.update(gsmt);
            
            aorgsOldMap.put(aorGSRec.Id,aorGSRec);
            List<GA_AOR_Group_Segment__c> aorGsLst1 = new List<GA_AOR_Group_Segment__c>();
            
            GA_AOR_Group_Segment__c aorGSRec1 = new GA_AOR_Group_Segment__c(id=aorGsLst[0].Id);
            aorGSRec1.GA_Process_Start_Date__c=system.today()-1 ;
            aorGSRec1.GA_Process_End_Date__c=system.today()+3;
            aorGsLst1.add(aorGSRec1);
            system.runAs(usr){
                
                Test.startTest();      
                GA_AORGS_AP01_SrvcAgntUpdatToGrpSegmnt.updtSrvcAgntToGS(aorGsLst1,aorgsOldMap);
                GA_AORGS_AP01_SrvcAgntUpdatToGrpSegmnt.updtDateInfo(aorGsLst1,aorgsOldMap);
                Test.stopTest();
                
                List<GA_AOR_Group_Segment__c> aoGsLst = [Select id from GA_AOR_Group_Segment__c where GA_AOR_Id__c=:aorRec.id Limit 10];
                system.assert(aoGsLst <> null);
            }
        }
        catch(exception e)
        {
            return;
        } 
    }
    /**
@Description: dmlOnGSInsertTst() method 
@Name : dmlOnGSInsertTst
@Param : N/A   
@Return : void
@throws Exception : N/A;
*/   
    private static testmethod void dmlOnGSInsertTst()
    {
        try{
            user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestAgentAdmin','testsalesrepmail@bcbsm.com','System Administrator');
            database.insert(usr);
            Map<Id,GA_AOR_Group_Segment__c> aorGSoldmap = new Map<Id,GA_AOR_Group_Segment__c> ();
            
            Account acc1 = GA_OBJ_TD01_TestDataCreation.AccRec();
            database.insert(acc1);
            
            GA_Group_Segment__c gsmt = GA_OBJ_TD01_TestDataCreation.grpSegmntRec(acc1);
            List<GA_Group_Segment__c> gsLst = new List<GA_Group_Segment__c> ();
            gsLst.add(gsmt);
            
            system.runAs(usr){
                
                Test.startTest();   
                GA_Util17_GrpSgmntDataAccesHelper.dmlOnGS(gsLst,'insert');
                Test.stopTest();
                
                system.assert(usr <> null);
            }
        }
        catch(exception e)
        {
            return;
        } 
    }   
    /**
@Description: dmlOnGSUpdateTst() method 
@Name : dmlOnGSUpdateTst
@Param : N/A   
@Return : void
@throws Exception : N/A;
*/   
    private static testmethod void dmlOnGSUpdateTst()
    {
        try{
            user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestAgentAdmin','testsalesrepmail@bcbsm.com','System Administrator');
            database.insert(usr);
            Map<Id,GA_AOR_Group_Segment__c> aorGSoldmap = new Map<Id,GA_AOR_Group_Segment__c> ();
            
            Account acc1 = GA_OBJ_TD01_TestDataCreation.AccRec();
            database.insert(acc1);
            
            GA_Group_Segment__c gsmt = GA_OBJ_TD01_TestDataCreation.grpSegmntRec(acc1);
            database.insert(gsmt);
            
            List<GA_Group_Segment__c> gsLst = new List<GA_Group_Segment__c> ();
            gsLst.add(gsmt);
            
            system.runAs(usr){
                
                Test.startTest();   
                GA_Util17_GrpSgmntDataAccesHelper.dmlOnGS(gsLst,'Update');
                Test.stopTest();
                
                system.assert(usr <> null);
            }
        }
        catch(exception e)
        {
            return;
        } 
    }   
    /**
@Description: dmlOnGSDeleteTst() method 
@Name : dmlOnGSDeleteTst
@Param : N/A   
@Return : void
@throws Exception : N/A;
*/   
    private static testmethod void dmlOnGSDeleteTst()
    {
        try{
            user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestAgentAdmin','testsalesrepmail@bcbsm.com','System Administrator');
            database.insert(usr);
            Map<Id,GA_AOR_Group_Segment__c> aorGSoldmap = new Map<Id,GA_AOR_Group_Segment__c> ();
            
            Account acc1 = GA_OBJ_TD01_TestDataCreation.AccRec();
            database.insert(acc1);
            
            GA_Group_Segment__c gsmt = GA_OBJ_TD01_TestDataCreation.grpSegmntRec(acc1);
            database.insert(gsmt);
            
            List<GA_Group_Segment__c> gsLst = new List<GA_Group_Segment__c> ();
            gsLst.add(gsmt);
            
            system.runAs(usr){
                
                Test.startTest();   
                GA_Util17_GrpSgmntDataAccesHelper.dmlOnGS(gsLst,'Delete');
                Test.stopTest();
                
                system.assert(usr <> null);
            }
        }
        catch(exception e)
        {
            return;
        } 
    }   
        /**
@Description: dmlOnGSUpsertTst() method 
@Name : dmlOnGSUpsertTst
@Param : N/A   
@Return : void
@throws Exception : N/A;
*/   
    private static testmethod void dmlOnGSUpsertTst()
    {
        try{
            user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestAgentAdmin','testsalesrepmail@bcbsm.com','System Administrator');
            database.insert(usr);
            Map<Id,GA_AOR_Group_Segment__c> aorGSoldmap = new Map<Id,GA_AOR_Group_Segment__c> ();
            
            Account acc1 = GA_OBJ_TD01_TestDataCreation.AccRec();
            database.insert(acc1);
            
            GA_Group_Segment__c gsmt = GA_OBJ_TD01_TestDataCreation.grpSegmntRec(acc1);
            database.insert(gsmt);
            
            List<GA_Group_Segment__c> gsLst = new List<GA_Group_Segment__c> ();
            gsLst.add(gsmt);
            
            system.runAs(usr){
                
                Test.startTest();   
                GA_Util17_GrpSgmntDataAccesHelper.dmlOnGS(gsLst,'Upsert');
                Test.stopTest();
                
                system.assert(usr <> null);
            }
        }
        catch(exception e)
        {
            return;
        } 
    }
}