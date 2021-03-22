/*
@Author : IDC Offshore
@Name: GA_AccOutOfBusiness_Test 
@CreatedDate: 6 - Aug 2019 
@Description: GA_AccOutOfBusiness Test class
@version : 1.0  
*/
@isTest(seealldata = false)
private class GA_AccOutOfBusiness_Test {
  /*******************************************************************************************************************************
@Description: updtAccOutOfBusinessTst() method 
@Name : updtAccOutOfBusinessTst
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
    private static testmethod void updtAccOutOfBusinessTst(){
        user usrSA = GA_OBJ_TD01_TestDataCreation.UsrRec('Testwfstp','testsystemadminstrator@bcbsm.com','System Administrator');
        database.insert(usrSA);
        
               account accnt=GA_OBJ_TD01_TestDataCreation.AccRec();
                database.insert(accnt);
        
        system.runAs(usrSA)
        {
            try{
                Test.startTest();
                GA_AccOutOfBusiness.fetchOOBButtonAccess();
                GA_AccOutOfBusiness.updateAccountStatus(accnt.id);
                Test.stopTest();
                system.assert(usrSA <> null);
            }
            catch(exception e)
            {
                return;
            }
        }
    }
    
      /*******************************************************************************************************************************
@Description: updtAccOutOfBusinessExcpt() method 
@Name : updtAccOutOfBusinessExcpt
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
    private static testmethod void updtAccOutOfBusinessExcpt(){
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('Testwfstp','testsystemadminstrator@bcbsm.com','GA Team Leader');
        database.insert(usr);
        
               account accnt=GA_OBJ_TD01_TestDataCreation.AccRec();
                database.insert(accnt);
        
        system.runAs(usr)
        {
            try{
                Test.startTest();
                GA_AccOutOfBusiness.fetchOOBButtonAccess();
                GA_AccOutOfBusiness.updateAccountStatus(null);
                Test.stopTest();
                system.assert(usr <> null);
            }
            catch(exception e)
            {
                return;
            }
        }
    }
}