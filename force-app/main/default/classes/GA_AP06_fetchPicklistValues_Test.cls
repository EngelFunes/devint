/*******************************************************************************************************************************
@Author : IDC offshore
@Name: GA_AP06_fetchPicklistValues_Test
@CreatedDate: 25 - Feb 2019 
@Description: GA_AP06_fetchPicklistValues_Test class is for GA_AP06_fetchPicklistValues class.
@version : 1.0  
********************************************************************************************************************************/
@isTest 
private class GA_AP06_fetchPicklistValues_Test {
 /*******************************************************************************************************************************
@Description: ftchPiklstval() method 
@Name : ftchPiklstval
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
    private static testMethod void ftchPiklstval() {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestSysAdm','testsysadm@bcbsm.com','System Administrator');
        insert usr;
        system.runAs(usr)
        {
            try{
                Account acc=GA_OBJ_TD01_TestDataCreation.AccRec();
                database.insert(acc); 
                 
                GA_Account_Benefit_Review__c benRvw=GA_OBJ_TD01_TestDataCreation.accBenfitRvw(acc);
                database.insert(benRvw);
                
                test.startTest();
				GA_AP_Create_ABR_Record.fetchpickValues(); //GA_AP_Create_ABR_Record used GA_AP06_fetchPicklistValues class as reference
                test.stopTest();
            }
            catch(exception e)
            {
                return;
            }
        }
    }
  /*******************************************************************************************************************************
@Description: ftchPiklstval() method 
@Name : ftchPiklstval
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
    private static testMethod void ftchPiklstvalCatch() {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestSysAdm','testsysadm@bcbsm.com','System Administrator');
        insert usr;
        system.runAs(usr)
        {
            try{
                Account acc=GA_OBJ_TD01_TestDataCreation.AccRec();
                database.insert(acc); 
                
                test.startTest();
                GA_AP06_fetchPicklistValues.getselectOptions(null,null);
                test.stopTest();
            }
            catch(exception e)
            {
                return;
            }
        }
    }
      
    
}