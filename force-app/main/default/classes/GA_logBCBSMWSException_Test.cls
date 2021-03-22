/**
@Author : IDC offshore
@Name: GA_logBCBSMWSException_Test
@CreatedDate: 19 - June 2018 
@Description: GA_logBCBSMWSException Test class 
@version : 1.0  
*/
@isTest(seealldata = false)
private class GA_logBCBSMWSException_Test {
    /*******************************************************************************************************************************
@Description        :   logWSErrorTest() method 
@Name               :   logWSErrorTest
@Param              :   None
@Return             :   void
@throws Exception   :   N/A;
********************************************************************************************************************************/ 
    private static testMethod void logWSErrorTest(){
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestAgentAdmin','testsalesrepmail@bcbsm.com','Agent Administrator');
        database.insert(usr);
        system.runAs(usr){
            Test.startTest();
            GA_logBCBSMWSException.logWSError(null, null, null, null);
            GA_AP_CIDServiceCls.getcidVal(null); 
            Test.stopTest();
            system.assert(usr <> null);
        }
        
    }
    /*******************************************************************************************************************************
@Description        :   updatelogWSErrorTest() method 
@Name               :   updatelogWSErrorTest
@Param              :   None
@Return             :   void
@throws Exception   :   N/A;
********************************************************************************************************************************/ 
    private static testMethod void updatelogWSErrorTest(){
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestAgentAdmin','testsalesrepmail@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr){
            Test.startTest();
            
            
            Account acc1 = GA_OBJ_TD01_TestDataCreation.AccRec();
            database.insert(acc1);
            
            ExceptionLog__c expLog = new ExceptionLog__c();
            expLog.Object_ID__c =acc1.Id ;
            expLog.ExceptionDescription__c = 'errorDes';
            expLog.ExceptionCode__c = 'Internal Error';
            database.insert(expLog);
            
            GA_logBCBSMWSException.updatelogWSError(acc1.Id, 'status', 'errCode', 'errorDes', 'integrationService', 'invokingCmp', 'errResp');
            Test.stopTest();
            system.assert(usr <> null);
        }
        
    }
    
        /*******************************************************************************************************************************
@Description        :   updatelogWSErrorTest1() method 
@Name               :   updatelogWSErrorTest1
@Param              :   None
@Return             :   void
@throws Exception   :   N/A;
********************************************************************************************************************************/ 
    private static testMethod void updatelogWSErrorTest1(){
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestAgentAdmin','testsalesrepmail@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr){
            Test.startTest();
            
            
            Account acc1 = GA_OBJ_TD01_TestDataCreation.AccRec();
            database.insert(acc1);
 
            GA_logBCBSMWSException.updatelogWSError(acc1.Id, 'status', 'errCode', 'errorDes', 'integrationService', 'invokingCmp', 'errResp');
            Test.stopTest();
            system.assert(usr <> null);
        }
        
    }
}