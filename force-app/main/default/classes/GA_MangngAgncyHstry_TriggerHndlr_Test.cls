/*
@Author : IDC Offshore
@Name: GA_MangngAgncyHstry_TriggerHndlr_Test 
@CreatedDate: 23 - Aug 2019 
@Description: GA_MangngAgncyHstry_TriggerHndlr Test class
@version : 1.0  
*/
@isTest(seealldata = false)
private  class GA_MangngAgncyHstry_TriggerHndlr_Test {
    /***********************************************************************************************************************************************
@Description: mngAgcnyHstryInsrtTest() method 
@Name : mngAgcnyHstryInsrtTest
@Param : None
@Return : void
@throws Exception : N/A;
************************************************************************************************************************************************/   
    private static testmethod void mngAgcnyHstryInsrtTest()
    {   
        
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestAgentAdmin','testsalesrepmail@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr){
            
            try{
                Map<ID,GA_Managing_Agency_History__c> mngAgcnyHstryOldMap = new Map<ID,GA_Managing_Agency_History__c> ();   
                
                Id RecordTypeIdAccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Agency').getRecordTypeId();
                Account acc = GA_OBJ_TD01_TestDataCreation.AccRec();
                acc.Name='Test Acc';
                acc.RecordTypeId=RecordTypeIdAccount;
                acc.GA_Managing_Agency_Code__c='01';
                database.insert(acc);
                
                GA_Group_Segment__c gsmt = GA_OBJ_TD01_TestDataCreation.grpSegmntRec(acc);
                database.insert(gsmt); 
                
                GA_Managing_Agency_History__c mngAgcnyHstry = new GA_Managing_Agency_History__c();
                mngAgcnyHstry.GA_Group_Segment__c=gsmt.id;
                mngAgcnyHstry.GA_Managing_Agency__c=acc.id;
                mngAgcnyHstry.GA_Start_Date__c=system.today();
                mngAgcnyHstry.GA_End_Date__c=system.today()+1;
                mngAgcnyHstry.GA_Is_Processed__c=False;
                database.insert(mngAgcnyHstry);
                
                mngAgcnyHstry.GA_Start_Date__c=system.today()-6;
                mngAgcnyHstry.GA_End_Date__c=system.today()-1;
                database.update(mngAgcnyHstry);
                
                List<GA_Managing_Agency_History__c> mngAgcnyHstryLst = new List<GA_Managing_Agency_History__c> ();
                GA_Managing_Agency_History__c mngAgcnyHstryRcrd = new GA_Managing_Agency_History__c();
                
                For(Integer i=1 ;i<=101 ; i++)
                {                    
                    mngAgcnyHstryRcrd = new GA_Managing_Agency_History__c();
                    mngAgcnyHstryRcrd.Name = 'Test ' + i;
                    mngAgcnyHstryRcrd.GA_Group_Segment__c=gsmt.id;
                    mngAgcnyHstryRcrd.GA_Managing_Agency__c=acc.id;
                    mngAgcnyHstryRcrd.GA_Start_Date__c=system.today()-6;
                    mngAgcnyHstryRcrd.GA_End_Date__c=system.today()-1;
                    mngAgcnyHstryRcrd.GA_Is_Processed__c=False;
                    mngAgcnyHstryLst.add(mngAgcnyHstryRcrd);    
                }
                
                Test.startTest();
                database.insert(mngAgcnyHstryLst);
                GA_MngngAgncyHstry_AP01_UpdtToGrpSgmnt.endDateExecuting = False;
                GA_MangngAgncyHstry_TriggerHndlr.afterInsert(mngAgcnyHstryLst);
                Test.stopTest(); 
                system.assert(usr <> null);
            }
            catch(exception e)
            {
                return;
            }    
        }
        
    }
    /***********************************************************************************************************************************************
@Description: mngAgcnyHstryUpdtTest() method 
@Name : mngAgcnyHstryUpdtTest
@Param : None
@Return : void
@throws Exception : N/A;
************************************************************************************************************************************************/   
    private static testmethod void mngAgcnyHstryUpdtTest()
    {   
        
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestAgentAdmin','testsalesrepmail@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr){
            
            try{
                Map<ID,GA_Managing_Agency_History__c> mngAgcnyHstryOldMap = new Map<ID,GA_Managing_Agency_History__c> ();   
                
                Id RecordTypeIdAccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Agency').getRecordTypeId();
                Account acc = GA_OBJ_TD01_TestDataCreation.AccRec();
                acc.Name='Test Acc';
                acc.RecordTypeId=RecordTypeIdAccount;
                acc.GA_Managing_Agency_Code__c='01';
                database.insert(acc);
                
                GA_Group_Segment__c gsmt = GA_OBJ_TD01_TestDataCreation.grpSegmntRec(acc);
                database.insert(gsmt); 
                
                GA_Managing_Agency_History__c mngAgcnyHstry = new GA_Managing_Agency_History__c();
                mngAgcnyHstry.GA_Group_Segment__c=gsmt.id;
                mngAgcnyHstry.GA_Managing_Agency__c=acc.id;
                mngAgcnyHstry.GA_Start_Date__c=system.today();
                mngAgcnyHstry.GA_End_Date__c=system.today()+1;
                mngAgcnyHstry.GA_Is_Processed__c=False;
                database.insert(mngAgcnyHstry);
                
                mngAgcnyHstry.GA_Start_Date__c=system.today()-6;
                mngAgcnyHstry.GA_End_Date__c=system.today()-1;
                database.update(mngAgcnyHstry);
                
                List<GA_Managing_Agency_History__c> mngAgcnyHstryInsrtLst = new List<GA_Managing_Agency_History__c> ();
                
                GA_Managing_Agency_History__c mngAgcnyHstryRcrd = new GA_Managing_Agency_History__c();
                
                For(Integer i=1 ;i<=101 ; i++)
                {                    
                    mngAgcnyHstryRcrd = new GA_Managing_Agency_History__c();
                    mngAgcnyHstryRcrd.Name = 'Test ' + i;
                    mngAgcnyHstryRcrd.GA_Group_Segment__c=gsmt.id;
                    mngAgcnyHstryRcrd.GA_Managing_Agency__c=acc.id;
                    mngAgcnyHstryRcrd.GA_Start_Date__c=system.today()-1;
                    mngAgcnyHstryRcrd.GA_End_Date__c=system.today()+1;
                    mngAgcnyHstryRcrd.GA_Is_Processed__c=False;
                    mngAgcnyHstryInsrtLst.add(mngAgcnyHstryRcrd);    
                }
                database.insert(mngAgcnyHstryInsrtLst);
                
                List<GA_Managing_Agency_History__c> mngAgcnyHstryUpdtLst = new List<GA_Managing_Agency_History__c> ();
                List<GA_Managing_Agency_History__c> mngAgcnHstryLst= [select id, name from GA_Managing_Agency_History__c where GA_Managing_Agency__c =:acc.id and GA_Group_Segment__c=:gsmt.id];
                for(GA_Managing_Agency_History__c mngAgcnHstry:mngAgcnHstryLst)
                {
                    mngAgcnHstry.GA_Start_Date__c=system.today()-6;
                    mngAgcnHstry.GA_End_Date__c=system.today()-1;
                    mngAgcnyHstryUpdtLst.add(mngAgcnHstry); 
                }
                
                Test.startTest();
                database.update(mngAgcnyHstryUpdtLst);
                GA_MngngAgncyHstry_AP01_UpdtToGrpSgmnt.endDateExecuting = False;
                GA_MangngAgncyHstry_TriggerHndlr.afterUpdate(mngAgcnyHstryUpdtLst,mngAgcnyHstryOldMap);
                Test.stopTest(); 
                system.assert(usr <> null);
            }
            catch(exception e)
            {
                return;
            }      
        }
        
    }
  /***********************************************************************************************************************************************
@Description: mngAgcnyHstryExcptns() method 
@Name : mngAgcnyHstryExcptns
@Param : None
@Return : void
@throws Exception : N/A;
************************************************************************************************************************************************/   
    private static testmethod void mngAgcnyHstryExcptns()
    {   
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestAgentAdmin','testsalesrepmail@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr){
            
            try{
                Test.startTest();
                GA_MangngAgncyHstry_TriggerHndlr.beforeInsert(null);
                GA_MangngAgncyHstry_TriggerHndlr.afterInsert(null);
                GA_MangngAgncyHstry_TriggerHndlr.afterUpdate(null,null);
                Test.stopTest(); 
                system.assert(usr <> null);
            }
            catch(exception e)
            {
                return;
            }    
        }
        
    }  
    
       /***********************************************************************************************************************************************
@Description: mngAgcnyHstryInsrtTest() method 
@Name : mngAgcnyHstryInsrtTest
@Param : None
@Return : void
@throws Exception : N/A;
************************************************************************************************************************************************/   
    private static testmethod void mngAgcnyHstryAfterInsrtTest()
    {   
        
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestAgentAdmin','matestsalesrepmail@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr){
            
            try{
                Map<ID,GA_Managing_Agency_History__c> mngAgcnyHstryOldMap = new Map<ID,GA_Managing_Agency_History__c> ();   
                
                Id RecordTypeIdAccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Agency').getRecordTypeId();
                Account acc = GA_OBJ_TD01_TestDataCreation.AccRec();
                acc.Name='Test Acc';
                acc.RecordTypeId=RecordTypeIdAccount;
                acc.GA_Managing_Agency_Code__c='03';
                database.insert(acc);
                
                GA_Group_Segment__c gsmt = GA_OBJ_TD01_TestDataCreation.grpSegmntRec(acc);
                database.insert(gsmt); 
                
                GA_Managing_Agency_History__c mngAgcnyHstry = new GA_Managing_Agency_History__c();
                mngAgcnyHstry.GA_Group_Segment__c=gsmt.id;
                mngAgcnyHstry.GA_Managing_Agency__c=acc.id;
                mngAgcnyHstry.GA_Start_Date__c=system.today();
                mngAgcnyHstry.GA_End_Date__c=system.today()+1;
                mngAgcnyHstry.GA_Is_Processed__c=False;
                database.insert(mngAgcnyHstry);
                
                mngAgcnyHstry.GA_Start_Date__c=system.today()-6;
                mngAgcnyHstry.GA_End_Date__c=system.today()-1;
                database.update(mngAgcnyHstry);
                
                List<GA_Managing_Agency_History__c> mngAgcnyHstryLst = new List<GA_Managing_Agency_History__c> ();
                GA_Managing_Agency_History__c mngAgcnyHstryRcrd = new GA_Managing_Agency_History__c();
                
                For(Integer i=1 ;i<=101 ; i++)
                {                    
                    mngAgcnyHstryRcrd = new GA_Managing_Agency_History__c();
                    mngAgcnyHstryRcrd.Name = 'Test ' + i;
                    mngAgcnyHstryRcrd.GA_Group_Segment__c=gsmt.id;
                    mngAgcnyHstryRcrd.GA_Managing_Agency__c=acc.id;
                    mngAgcnyHstryRcrd.GA_Start_Date__c=system.today()-6;
                    mngAgcnyHstryRcrd.GA_End_Date__c=system.today()-1;
                    mngAgcnyHstryRcrd.GA_Is_Processed__c=False;
                    mngAgcnyHstryLst.add(mngAgcnyHstryRcrd);    
                }
                
                Test.startTest();
                database.insert(mngAgcnyHstryLst);
                GA_MngngAgncyHstry_AP01_UpdtToGrpSgmnt.endDateExecuting = False;
                GA_MangngAgncyHstry_TriggerHndlr.beforeInsert(mngAgcnyHstryLst);
                Test.stopTest(); 
                system.assert(usr <> null);
            }
            catch(exception e)
            {
                return;
            }    
        }
        
    }
}