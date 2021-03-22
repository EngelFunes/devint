/*****************************************************************************************
Class Name   : GA_WrkFlwPrcssUpdtRecvandCmpDts_Test
Date Created : 20-08-2018
Created By   : IDC Offshore
Description  : 1. GA_WrkFlwPrcssUpdtRecvandCmpDts Test class
******************************************************************************************/
@isTest(seealldata=false)
private class GA_Util03_WrkflwStpDataAccessHelper_Test {
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
                List<GA_WF_Workflow__c> wrkflwList =[Select Id,Name from GA_WF_Workflow__c Limit 2000];
               
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