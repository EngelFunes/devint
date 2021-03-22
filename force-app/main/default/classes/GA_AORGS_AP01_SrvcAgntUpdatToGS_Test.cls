/*
@Author : Sri Lakshmi Addula
@Name: GA_AORGS_RestrictDuplicateAORGS_Test 
@CreatedDate: 5 - Aug 2019 
@Description: GA_AORGS_RestrictDuplicateAORGS Test class
@version : 1.0  
*/
@isTest(seealldata = false)
private class GA_AORGS_AP01_SrvcAgntUpdatToGS_Test {
    /**
@Description: aorGSRecrdCnclFlg() method 
@Name : aorGSRecrdCnclFlg
@Param : N/A   
@Return : void
@throws Exception : N/A;
*/   
    private static testmethod void aorGSRecrdCnclFlg()
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
        aorGSRec.GA_Process_Start_Date__c=system.today()-1 ;
        aorGSRec.GA_Process_End_Date__c=system.today() +1;
        aorGSRec.GA_Cancel_Flag__c =True;
        database.insert(aorGSRec); 
        List<GA_AOR_Group_Segment__c> aorGsLst = new List<GA_AOR_Group_Segment__c>();
        aorGsLst.add(aorGSRec);
        
        aorgsOldMap.put(aorGSRec.Id,aorGSRec);
        List<GA_AOR_Group_Segment__c> aorGsLst1 = new List<GA_AOR_Group_Segment__c>();
        
        GA_AOR_Group_Segment__c aorGSRec1 = new GA_AOR_Group_Segment__c(id=aorGsLst[0].Id);
        aorGSRec1.GA_Cancel_Flag__c =False;
        
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
@Description: aorGSRecrdFuturePrcsEndDt() method 
@Name : aorGSRecrdFuturePrcsEndDt
@Param : N/A   
@Return : void
@throws Exception : N/A;
*/   
    private static testmethod void aorGSRecrdFuturePrcsEndDt()
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
        aorGsRec.GA_Is_StartDateProcessed__c =  true;
            
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
@Description: aorGSRecrdTodayPrcsEndDt() method 
@Name : aorGSRecrdTodayPrcsEndDt
@Param : N/A   
@Return : void
@throws Exception : N/A;
*/   
    private static testmethod void aorGSRecrdTodayPrcsEndDt()
    {
        try{
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestAgentAdmin','testsalesrepmail@bcbsm.com','System Administrator');
        database.insert(usr);
        Map<Id,GA_AOR_Group_Segment__c> aorGSoldmap = new Map<Id,GA_AOR_Group_Segment__c> ();
        Map<String,GA_AOR_Group_Segment__c> gsIdaorGsMap = new Map<String,GA_AOR_Group_Segment__c>();
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
        database.insert(aorGSRec); 
        List<GA_AOR_Group_Segment__c> aorGsLst = new List<GA_AOR_Group_Segment__c>();
        aorGsLst.add(aorGSRec);
        
        aorgsOldMap.put(aorGSRec.Id,aorGSRec);
        List<GA_AOR_Group_Segment__c> aorGsLst1 = new List<GA_AOR_Group_Segment__c>();
        
        GA_AOR_Group_Segment__c aorGSRec1 = new GA_AOR_Group_Segment__c(id=aorGsLst[0].Id);
        aorGSRec1.GA_Process_Start_Date__c=system.today()-4 ;
        aorGSRec1.GA_Process_End_Date__c=system.today();
        
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
    /*******************************************************************************************************************************
@Description        :   updateAoRRecs() method 
@Name               :   updateAoRRecs
@Param              :   None
@Return             :   void
@throws Exception   :   N/A;
********************************************************************************************************************************/ 
    private static testMethod void updateAoRRecs(){
        try{
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestAgentAdmin','testsalesrepmail@bcbsm.com','Agent Administrator');
        database.insert(usr);
        
        Account acc1 = GA_OBJ_TD01_TestDataCreation.AccRec();
        database.insert(acc1);
        
        GA_Group_Segment__c gsmt = GA_OBJ_TD01_TestDataCreation.grpSegmntRec(acc1);
        database.insert(gsmt); 
        
        Contact cnt =  GA_OBJ_TD01_TestDataCreation.cntactRec(acc1.id);
        cnt.recordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact - Agent').getRecordTypeId();
        database.insert(cnt); 
        
        GA_Aor__C aorRecd = GA_OBJ_TD01_TestDataCreation.createAOR(acc1,cnt);
        aorRecd.GA_Service_Start_Date__c =  Date.newInstance(1990, 1, 1);
        aorRecd.GA_Service_End_Date__c = Date.newInstance(2200, 1, 1);
        database.insert(aorRecd); 
        
        GA_AOR_Group_Segment__c aorGSRec = GA_OBJ_TD01_TestDataCreation.createAORGS(aorRecd,gsmt);
        database.insert(aorGSRec); 
        
        GA_Aor__C aorRecd1 = new GA_Aor__C(id =aorRecd.id);
        system.runAs(usr){
            
            Test.startTest();            
            aorRecd1.GA_Service_End_Date__c = System.today() -  1;
            aorRecd1.GA_Commission_Start_Date__c= System.today();
            Database.update(aorRecd1);
            
            Test.stopTest();
            
            List<GA_AOR_Group_Segment__c> aoGsLst = [Select id from GA_AOR_Group_Segment__c where GA_AOR_Id__c=:aorRecd.id Limit 10];
            system.assert(aoGsLst <> null);
        }
      }
            catch(exception e)
            {
                return;
            }
    }
}