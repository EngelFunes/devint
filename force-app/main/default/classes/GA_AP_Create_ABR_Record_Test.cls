/*
@Author : Dilip Junapala
@Name: GA_AP_Create_ABR_Record_Test 
@CreatedDate: 4 - Oct 2018 
@Description: GA_AP_Create_ABR_Record Test class
@version : 1.0  
*/
@isTest
private class GA_AP_Create_ABR_Record_Test {
    /**
@Description: ABRrelatLst() method 
@Name : ABRrelatLst
@Param : N/A   
@Return : void
@throws Exception : N/A;
*/    
    private static testmethod void ABRrelatLst()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestABR','testABRSpecialist@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {
            try {
                Account acc=GA_OBJ_TD01_TestDataCreation.AccRec();
                database.insert(acc);
                GA_Account_Benefit_Review__c benRvw=GA_OBJ_TD01_TestDataCreation.accBenfitRvw(acc);
                database.insert(benRvw);
                test.startTest();
                GA_AP_Create_ABR_Record.fetchpickValues();
                test.stopTest();
            }
            catch(exception e)
            {
                return;
            }
        }
    }
    
}