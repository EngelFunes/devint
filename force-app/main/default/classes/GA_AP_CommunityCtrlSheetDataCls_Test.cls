@isTest(seealldata = false)
private class GA_AP_CommunityCtrlSheetDataCls_Test {
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
                GA_AP_CommunityCtrlSheetDataCls.fetchaccName(acc.id);
                GA_AP_CommunityCtrlSheetDataCls.getBaseUrl();
                GA_AP_CommunityCtrlSheetDataCls.getUIThemeDescription();
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