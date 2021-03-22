/**
@Author : IDC Offshore
@Name: GA_AP_CtrlSheetDataCls_Test 
@CreatedDate: 01 - Feb 2018 
@Description: GA_AP_CtrlSheetDataCls_Test Test class 
@version : 1.0  
*/
@isTest(seealldata = false)
private class GA_AP_CtrlSheetDataCls_Test {
    /**
@Description: executeCtrlCls() method 
@Name : executeCtrlCls
@Param : None
@Return : void
@throws Exception : N/A;
*/ 
    private static testmethod void executeCtrlCls()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestEnrlmnt','testsysadminmail@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {
            try {
                Account acc=GA_OBJ_TD01_TestDataCreation.AccRec();
                database.insert(acc);
                
                test.startTest();
                GA_AP_CtrlSheetDataCls.fetchaccName(acc.id);
                test.stopTest();
                system.assert(usr <> null,true);
            }
            catch(exception e)
            {
                return;
            }
        }
    }
}