/**
@Author : Prasanth S
@Name: GA_AP01_UserInfocls_Test 
@CreatedDate: 31 - Jul 2017 
@Description: GA_AP01_UserInfocls Test class 
@version : 1.0  
*/
@isTest
private class GA_AP01_UserInfocls_Test {
    /**
@Description: UserInfoMethod() method 
@Name : UserInfoMethod
@Param : None
@Return : void
@throws Exception : N/A;
*/   
    private static testmethod void UserInfoMethod()
    {
        user usr1 = GA_OBJ_TD01_TestDataCreation.UsrRec('TestJeoRl','testsalesrepmail@bcbsm.com','Support');
        insert usr1;
        system.runAs(usr1)
        {
            test.startTest();
            user usr=GA_AP01_UserInfocls.getUser(); 
            test.stopTest();
            system.assertEquals(userinfo.getName(), usr.Name);
            system.assertEquals(userinfo.getUserId(), usr.id);
        }
    }
    
    /**
@Description: UserInfoMethodExcp() method 
@Name : UserInfoMethodExcp
@Param : None
@Return : void
@throws Exception : N/A;
*/   
    private static testmethod void UserInfoMethodExcp()
    {
        user usr1 = GA_OBJ_TD01_TestDataCreation.UsrRec('TestJeoRl','testsalesrepmail@bcbsm.com','Support');
        insert usr1;
        system.runAs(usr1)
        {
            test.startTest();
            GA_AP01_UserInfocls.CurrentUserId='';
            user usr=GA_AP01_UserInfocls.getUser(); 
            test.stopTest();
            List<ExceptionLog__c> eLogLst=[select id from ExceptionLog__c limit 1];
           // system.assert(eLogLst.size()>0);
        }
    }
    
}