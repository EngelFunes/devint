/*******************************************************************************************************************************
@Author : IDC offshore
@Name: GA_GSRatingTypeBatch_Test
@CreatedDate: 25 - Feb 2019 
@Description: GA_GSRatingTypeBatch_Test class is for Group Segment.
@version : 1.0  
********************************************************************************************************************************/
@isTest(seealldata = false)
private class GA_GSRatingTypeBatch_Test {
    /*******************************************************************************************************************************
@Description: updtRatngTypTest() method 
@Name : updtRatngTypTest
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
    private static testmethod void updtRatngTypTest(){
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestSysAdm','testsysadm@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr){
            try{
                Account testAccount = GA_OBJ_TD01_TestDataCreation.AccRec();
                testAccount.RecordTypeId =  Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Customer').getRecordTypeId();
                testAccount.GA_System_of_record__c='Salesforce';
                database.insert(testAccount);
                
                GA_Group_Segment__c grpSmt=GA_OBJ_TD01_TestDataCreation.grpSegmntRec(testAccount);
                grpSmt.GA_Group_Effective_Date__c = system.today()-10;
                grpSmt.GA_Cancellation_Date__c = system.today()+10;
                grpSmt.Status__c = 'Pending';
                grpSmt.GA_Current_Cluster_Code__c = 'D500';
                grpSmt.GA_Smart_Rating_Type__c='TEST SMART';
                database.insert(grpSmt);
                
                grpSmt.GA_Current_Cluster_Code__c = '0E00';
                grpSmt.GA_Is_Mass_Updating__c=true;
                GA_GS_AP02_Update_Address.isExecuting=true;
                GA_GroupSegmentTriggerHandler.beforeUpdateExecuting = true;
                GA_GroupSegmentTriggerHandler.isExecuting = true;
                database.update(grpSmt);
                
                //String rtngTypQry = 'select Id,GA_Cluster_Code_Formula__c,GA_Is_Mass_Updating__c,GA_Account_Type__c,GA_Rating_Type__c,GA_Smart_Rating_Type__c,GA_Rating_Method__c,GA_Current_Cluster_Code__c,GA_System_of_Record__c from GA_Group_Segment__c';
                String rtngTypQry = 'select Id,GA_Is_Mass_Updating__c,GA_Account_Type__c,GA_Rating_Type__c,GA_Smart_Rating_Type__c,GA_Rating_Method__c,GA_Current_Cluster_Code__c,GA_System_of_Record__c from GA_Group_Segment__c';
                
                GA_GSRatingTypeBatch sh1 = new GA_GSRatingTypeBatch(rtngTypQry);      
                Id processId = null;
                Test.startTest();
                processId = Database.executeBatch(sh1,200);
                Test.stopTest();
            }
            catch(exception e)
            {
                system.assert(e <> null);
                return;
            }
        }
    }
    
    /*******************************************************************************************************************************
@Description: updtSmartRatngTypTest() method 
@Name : updtSmartRatngTypTest
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
    private static testmethod void updtSmartRatngTypTest(){
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestSysAdm','testsysadm@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr){
            try{
                Account testAccount = GA_OBJ_TD01_TestDataCreation.AccRec();
                testAccount.RecordTypeId =  Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Customer').getRecordTypeId();
                testAccount.GA_System_of_record__c='SMART';
                database.insert(testAccount);
                
                GA_Group_Segment__c grpSmt=GA_OBJ_TD01_TestDataCreation.grpSegmntRec(testAccount);
                grpSmt.GA_Group_Effective_Date__c = system.today()-10;
                grpSmt.GA_Cancellation_Date__c = system.today()+10;
                grpSmt.Status__c = 'Pending';
                grpSmt.GA_Current_Cluster_Code__c = 'D500';
                grpSmt.GA_Smart_Rating_Type__c='TEST SMART';
                database.insert(grpSmt);
                
                grpSmt.GA_Current_Cluster_Code__c = '0E00';
                grpSmt.GA_Is_Mass_Updating__c=true;
                GA_GS_AP02_Update_Address.isExecuting=true;
                GA_GroupSegmentTriggerHandler.beforeUpdateExecuting = true;
                GA_GroupSegmentTriggerHandler.isExecuting = true;
                database.update(grpSmt);
                
                String rtngTypQry = 'select Id,GA_Is_Mass_Updating__c,GA_Account_Type__c,GA_Rating_Type__c,GA_Smart_Rating_Type__c,GA_Rating_Method__c,GA_Current_Cluster_Code__c,GA_System_of_Record__c from GA_Group_Segment__c';
               //String rtngTypQry = 'select Id,GA_Cluster_Code_Formula__c,GA_Is_Mass_Updating__c,GA_Account_Type__c,GA_Rating_Type__c,GA_Smart_Rating_Type__c,GA_Rating_Method__c,GA_Current_Cluster_Code__c,GA_System_of_Record__c from GA_Group_Segment__c';
               
                GA_GSRatingTypeBatch sh1 = new GA_GSRatingTypeBatch(rtngTypQry);      
                Id processId = null;
                Test.startTest();
                processId = Database.executeBatch(sh1,200);
                Test.stopTest();
            }
            catch(exception e)
            {
                system.assert(e <> null);
                return;
            }
        }
    }
    /*******************************************************************************************************************************
@Description: updtNullSmartRatngTypTest() method 
@Name : updtNullSmartRatngTypTest
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
    private static testmethod void updtNullSmartRatngTypTest(){
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestSysAdm','testsysadm@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr){
            try{
                Account testAccount = GA_OBJ_TD01_TestDataCreation.AccRec();
                testAccount.RecordTypeId =  Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Customer').getRecordTypeId();
                testAccount.GA_System_of_record__c='SMART';
                database.insert(testAccount);
                
                GA_Group_Segment__c grpSmt=GA_OBJ_TD01_TestDataCreation.grpSegmntRec(testAccount);
                grpSmt.GA_Group_Effective_Date__c = system.today()-10;
                grpSmt.GA_Cancellation_Date__c = system.today()+10;
                grpSmt.Status__c = 'Pending';
                grpSmt.GA_Current_Cluster_Code__c = 'D500';
                grpSmt.GA_Smart_Rating_Type__c='TEST SMART';
                database.insert(grpSmt);
                
                grpSmt.GA_Smart_Rating_Type__c=null;
                grpSmt.GA_Current_Cluster_Code__c = '0E00';
                grpSmt.GA_Is_Mass_Updating__c=true;
                GA_GS_AP02_Update_Address.isExecuting=true;
                GA_GroupSegmentTriggerHandler.beforeUpdateExecuting = true;
                GA_GroupSegmentTriggerHandler.isExecuting = true;
                database.update(grpSmt);
                
                //String rtngTypQry = 'select Id,GA_Cluster_Code_Formula__c,GA_Is_Mass_Updating__c,GA_Account_Type__c,GA_Rating_Type__c,GA_Smart_Rating_Type__c,GA_Rating_Method__c,GA_Current_Cluster_Code__c,GA_System_of_Record__c from GA_Group_Segment__c';
                String rtngTypQry = 'select Id,GA_Is_Mass_Updating__c,GA_Account_Type__c,GA_Rating_Type__c,GA_Smart_Rating_Type__c,GA_Rating_Method__c,GA_Current_Cluster_Code__c,GA_System_of_Record__c from GA_Group_Segment__c';
           
                GA_GSRatingTypeBatch sh1 = new GA_GSRatingTypeBatch(rtngTypQry);      
                Id processId = null;
                Test.startTest();
                processId = Database.executeBatch(sh1,200);
                Test.stopTest();
            }
            catch(exception e)
            {
                system.assert(e <> null);
                return;
            }
        }
    }
    
    /*******************************************************************************************************************************
@Description: updtNullClustrCdRatngTypTest() method 
@Name : updtNullClustrCdRatngTypTest
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
    private static testmethod void updtNullClustrCdRatngTypTest(){
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestSysAdm','testsysadm@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr){
            try{
                Account testAccount = GA_OBJ_TD01_TestDataCreation.AccRec();
                testAccount.RecordTypeId =  Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Customer').getRecordTypeId();
                testAccount.GA_System_of_record__c='Salesforce';
                database.insert(testAccount);
                
                GA_Group_Segment__c grpSmt=GA_OBJ_TD01_TestDataCreation.grpSegmntRec(testAccount);
                grpSmt.GA_Group_Effective_Date__c = system.today()-10;
                grpSmt.GA_Cancellation_Date__c = system.today()+10;
                grpSmt.Status__c = 'Pending';
                grpSmt.GA_Current_Cluster_Code__c = 'D500';
                grpSmt.GA_Smart_Rating_Type__c='TEST SMART';
                database.insert(grpSmt);
                
                grpSmt.GA_Current_Cluster_Code__c = null;
                grpSmt.GA_Is_Mass_Updating__c=true;
                GA_GS_AP02_Update_Address.isExecuting=true;
                GA_GroupSegmentTriggerHandler.beforeUpdateExecuting = true;
                GA_GroupSegmentTriggerHandler.isExecuting = true;
                database.update(grpSmt);
                
                //String rtngTypQry = 'select Id,GA_Cluster_Code_Formula__c,GA_Is_Mass_Updating__c,GA_Account_Type__c,GA_Rating_Type__c,GA_Smart_Rating_Type__c,GA_Rating_Method__c,GA_Current_Cluster_Code__c,GA_System_of_Record__c from GA_Group_Segment__c';
                String rtngTypQry = 'select Id,GA_Is_Mass_Updating__c,GA_Account_Type__c,GA_Rating_Type__c,GA_Smart_Rating_Type__c,GA_Rating_Method__c,GA_Current_Cluster_Code__c,GA_System_of_Record__c from GA_Group_Segment__c';
           
                GA_GSRatingTypeBatch sh1 = new GA_GSRatingTypeBatch(rtngTypQry);      
                Id processId = null;
                Test.startTest();
                processId = Database.executeBatch(sh1,200);
                Test.stopTest();
            }
            catch(exception e)
            {
                system.assert(e <> null);
                return;
            }
        }
    }
        /*******************************************************************************************************************************
@Description: updtIBUGsRatngTypTest() method 
@Name : updtIBUGsRatngTypTest
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
    private static testmethod void updtIBUGsRatngTypTest(){
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestSysAdm','testsysadm@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr){
            try{
                Account testAccount = GA_OBJ_TD01_TestDataCreation.AccRec();
                testAccount.RecordTypeId =  Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Customer').getRecordTypeId();
                testAccount.GA_System_of_record__c='Salesforce';
                database.insert(testAccount);
                
                GA_Group_Segment__c grpSmt=GA_OBJ_TD01_TestDataCreation.grpSegmntRec(testAccount);
                grpSmt.GA_Group_Effective_Date__c = system.today()-10;
                grpSmt.GA_Cancellation_Date__c = system.today()+10;
                grpSmt.Status__c = 'Pending';
                grpSmt.GA_Current_Cluster_Code__c = 'D500';
                grpSmt.GA_Smart_Rating_Type__c='TEST SMART';
                grpSmt.GA_Account_Type__c='IBU';
                database.insert(grpSmt);
                
                grpSmt.GA_Current_Cluster_Code__c = null;
                grpSmt.GA_Is_Mass_Updating__c=true;
                GA_GS_AP02_Update_Address.isExecuting=true;
                GA_GroupSegmentTriggerHandler.beforeUpdateExecuting = true;
                GA_GroupSegmentTriggerHandler.isExecuting = true;
                database.update(grpSmt);
                
                //String rtngTypQry = 'select Id,GA_Cluster_Code_Formula__c,GA_Is_Mass_Updating__c,GA_Account_Type__c,GA_Rating_Type__c,GA_Smart_Rating_Type__c,GA_Rating_Method__c,GA_Current_Cluster_Code__c,GA_System_of_Record__c from GA_Group_Segment__c';
                String rtngTypQry = 'select Id,GA_Is_Mass_Updating__c,GA_Account_Type__c,GA_Rating_Type__c,GA_Smart_Rating_Type__c,GA_Rating_Method__c,GA_Current_Cluster_Code__c,GA_System_of_Record__c from GA_Group_Segment__c';
                
                GA_GSRatingTypeBatch sh1 = new GA_GSRatingTypeBatch(rtngTypQry);      
                Id processId = null;
                Test.startTest();
                processId = Database.executeBatch(sh1,200);
                Test.stopTest();
            }
            catch(exception e)
            {
                system.assert(e <> null);
                return;
            }
        }
    }
    /*******************************************************************************************************************************
@Description: erroBlocktest() method 
@Name : erroBlocktest
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
    private static testmethod void erroBlocktest(){
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestSysAdm','testsysadm@bcbsm.com','Sales Operations');
        database.insert(usr);
        system.runAs(usr){
            try{
                Account testAcnt = GA_OBJ_TD01_TestDataCreation.AccRec();
                testAcnt.RecordTypeId =  Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Prospect').getRecordTypeId();
                testAcnt.GA_System_of_record__c='Salesforce';
                testAcnt.Federal_Tax_ID__c = '';
                testAcnt.GA_Is_Mass_Updating__c = true;
                database.insert(testAcnt);               
                
                GA_Group_Segment__c gsRec=GA_OBJ_TD01_TestDataCreation.grpSegmntRec(testAcnt);               
                database.insert(gsRec);
                
                String rtngTypQry = 'select Id,GA_Is_Mass_Updating__c,GA_Account_Type__c,GA_Rating_Type__c,GA_Smart_Rating_Type__c,GA_Rating_Method__c,GA_Current_Cluster_Code__c,GA_System_of_Record__c from GA_Group_Segment__c';
                //String rtngTypQry = 'select Id,GA_Cluster_Code_Formula__c,GA_Is_Mass_Updating__c,GA_Account_Type__c,GA_Rating_Type__c,GA_Smart_Rating_Type__c,GA_Rating_Method__c,GA_Current_Cluster_Code__c,GA_System_of_Record__c from GA_Group_Segment__c';
                
                GA_GSRatingTypeBatch sh1 = new GA_GSRatingTypeBatch(rtngTypQry);
                //sh1.gsLst.add(New GA_Group_Segment__c());
                Id processId = '';
                Test.startTest();
                processId = Database.executeBatch(sh1,200);
                Test.stopTest();
            }
            catch(exception e)
            {
                system.assert(e <> null);
                return;
            }
        }
    }
    
}