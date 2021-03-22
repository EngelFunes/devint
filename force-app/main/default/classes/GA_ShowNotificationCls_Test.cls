/**
@Author : Dilip
@Name: GA_ShowNotificationCls_Test
@CreatedDate: 8 - June 2018 
@Description: GA_ShowNotificationCls_Test class is for GA_ShowNotificationCls class.
@version : 1.0  
*/
@isTest
private class GA_ShowNotificationCls_Test {
    /**
@Description: shwNotifi() method 
@Name : shwNotifi
@Param : N/A  
@Return : void
@throws Exception : N/A;
*/      
    private static testmethod void shwNotifi(){
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestJeoRl','testsalesrepmail@bcbsm.com','System Administrator');
        insert usr;
        system.runAs(usr){
            GA_ShowNotificationCls.getSessionId();
        }
    }
}