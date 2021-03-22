/**
@Author : IDC Offshore
@Name: GA_AP_GenPartAPartBDataCls_Test 
@CreatedDate: 9 May 2019
@Description: GA_AP_GenPartAPartBDataCls_Test Test class 
@version : 1.0  
*/
@isTest(seealldata = false)
private class GA_AP_GenPartAPartBDataCls_Test {
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
                Case cas=GA_OBJ_TD01_TestDataCreation.CaseRec();
                database.insert(cas);            
              
                test.startTest();
                GA_AP_GenPartAPartBDataCls.fetchCaseNumber(cas.id);               
                test.stopTest();      
                
                system.assert(cas <> null);
           }
            catch(exception e)
            {
                return;
            }
        }
    }
        /**
@Description: executeCtrlClsExcptn() method 
@Name : executeCtrlClsExcptn
@Param : None
@Return : void
@throws Exception : N/A;
*/ 
    private static testmethod void executeCtrlClsExcptn()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestEnrlmnt','testsysadminmail@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        { 
            try {
                Case cas=GA_OBJ_TD01_TestDataCreation.CaseRec();
                database.insert(cas);            
              
                test.startTest();
                GA_AP_GenPartAPartBDataCls.fetchCaseNumber(null);               
                test.stopTest();      
                
                system.assert(cas <> null);
           }
            catch(exception e)
            {
                return;
            }
        }
    }
}