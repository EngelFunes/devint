/**
@Author : Prasant S
@Name: GA_ACCNTFCTSHT01_RecList_Test 
@CreatedDate: 31 - Jul 2017 
@Description: GA_ACCNTFCTSHT01_RecList Test class 
@version : 1.0  
*/ 
@isTest(seealldata=false)
private class GA_ACCNTFCTSHT01_RecList_Test {
    /**
@Description: acntfshtrelatLst() method 
@Name : acntfshtrelatLst
@Param : None
@Return : void
@throws Exception : N/A;
*/ 
    private static testmethod void acntfshtrelatLst()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestAcnFctsht','testsalesrepmail@bcbsm.com','Support');
        database.insert(usr);
        system.runAs(usr)
        {
            try {
                Account acc=GA_OBJ_TD01_TestDataCreation.AccRec();
                database.insert(acc);
                Contact con = GA_OBJ_TD01_TestDataCreation.cntactRec(acc.Id);
                database.insert(con);
                GA_Account_Fact_Sheet__c actFctsht=GA_OBJ_TD01_TestDataCreation.accFactSheetRec(acc,con);
                database.insert(actFctsht);
                Map<String,Object> actFcstsht=null;
                Account accRec= null;
                test.startTest();
                actFcstsht=GA_ACCNTFCTSHT01_RecList.actfctshtLst(acc.id);
                accRec=GA_ACCNTFCTSHT01_RecList.actRec(acc.id);
                test.stopTest();
                system.assert(accRec <> null);
                system.assert(actFcstsht <> null);
            }
            catch(exception e)
            {
                return;
            }
        }
    }
    
    /**
@Description: acntfshtrelatLstException() method 
@Name : acntfshtrelatLstException
@Param : None
@Return : void
@throws Exception : N/A;
*/
    private static testmethod void acntfshtrelatLstException()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestAcnFctsht','testsalesrepmail@bcbsm.com','Support');
        database.insert(usr);
        system.runAs(usr)
        {
            
            try {
                Map<String,Object> actFcstsht=null;
                test.startTest();
                actFcstsht=GA_ACCNTFCTSHT01_RecList.actfctshtLst('');
                test.stopTest();
            } 
            catch (exception e) {
                system.assert(e <> null);
                return;
            }
        }
    }
    
    /**
@Description: acntRecException() method 
@Name : acntRecException
@Param : None
@Return : void
@throws Exception : N/A;
*/
    private static testmethod void acntRecException()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestAcnFctsht','testsalesrepmail@bcbsm.com','Support');
        database.insert(usr);
        system.runAs(usr)
        {
            
            try {
                Account accRec= null;
                test.startTest();
                accRec=GA_ACCNTFCTSHT01_RecList.actRec('');
                test.stopTest();
            } 
            catch (exception e) {
                system.assert(e <> null);
                return;
            }
        }
    }
}