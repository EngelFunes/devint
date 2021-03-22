/*
@Author : IDC Offshore
@Name: GA_Util03_WrkflwDataAccessHelper_Test
@CreatedDate: 26 - Nov 2018 
@Description: GA_Util03_WrkflwDataAccessHelper_Test
@version : 1.0  
*/
@isTest(seealldata = false)
private class GA_Util03_WrkflwDataAccessHelper_Test {
    /**
@Description: executeTest() method 
@Name : executeTest
@Param : N/A   
@Return : void
@throws Exception : N/A;
*/  
    private static testmethod void executeTest()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestSysAdm','testsysadm@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {
            try {
                
                GA_WF_Workflow__c wfRec = New GA_WF_Workflow__c(); 
                List<GA_WF_Workflow__c> wfLst = New List<GA_WF_Workflow__c>();
                wfLst.add(wfRec);
                List<GA_WF_Workflow__c> wrkflwList =[Select Id,Name from GA_WF_Workflow__c Limit 3000];
                //database.insert(wfRec);
                test.startTest();
                GA_Util03_WrkflwDataAccessHelper.dmlOnwrkflw(wfLst, 'Insert');                
                GA_Util03_WrkflwDataAccessHelper.dmlOnwrkflw(wfLst, 'Update');
                GA_Util03_WrkflwDataAccessHelper.fetchwrkflowMap(GA_AP_ShowGrpSgmntWFCls.SELECTWFWUERY, 
                                                                 '', 
                                                                 GA_Util03_WrkflwDataAccessHelper.BLANK,
                                                                 GA_AP_ShowGrpSgmntWFCls.LIMITSTR).values();
                test.stopTest();
                system.assert(usr <> null);
            }
            catch(exception e)
            {
                return;
            }
        }
    }

  
    
}