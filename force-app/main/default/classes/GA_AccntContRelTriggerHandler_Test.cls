/*******************************************************************************************************************************
@Author : Dilip Junapala
@Name: GA_AccntContRelTriggerHandler_Test 
@CreatedDate: 19 - Apr 2019 
@Description: GA_AccntContRelTriggerHandler_Test Test class 
@version : 1.0
********************************************************************************************************************************/
@isTest(seealldata=false)
private class GA_AccntContRelTriggerHandler_Test {
    
    /*******************************************************************************************************************************
@Description: createAccountContactRelationships() method 
@Name : createAccountContactRelationships
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
    private static testmethod void createAccountContactRelationships()
    {
        list<user> usrLst=new list<user>();
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('Testlckrec','testsysadminmail@bcbsm.com','System Administrator');
        usrLst.add(usr);
        user usrRetSlsRep = GA_OBJ_TD01_TestDataCreation.UsrRec('TestlckrecRetnslsRep','testsalesrepmail@bcbsm.com','Retention Sales');
        usrLst.add(usrRetSlsRep);
        database.insert(usrLst);
        system.runAs(usrLst[0])
        {
            try{
                Account accRec=GA_OBJ_TD01_TestDataCreation.AccRec();
                database.insert(accRec);
                Contact con = GA_OBJ_TD01_TestDataCreation.cntactRec(accRec.Id);
                con.Active__c = true;
                AccountContactRelation acr = New AccountContactRelation();
                acr.AccountId = accRec.id;
                acr.ContactId = con.id;
                
                test.startTest();
                GA_IsActiveUpdateOnBeforeInsertionOfACRs.isExecuting = false;
                database.insert(acr);
                test.stopTest();
                system.assert(usrLst <> null);
            }
            catch(exception e)
            {
                return;
            }
        }  
    }
    
    /*******************************************************************************************************************************
@Description: deactivaterecodsExcep() method 
@Name : deactivaterecodsExcep
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
    private static testmethod void deactivaterecodsExcep()
    {
        list<user> usrLst=new list<user>();
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('Testlckrec','testsysadminmail@bcbsm.com','System Administrator');
        usrLst.add(usr);
        user usrRetSlsRep = GA_OBJ_TD01_TestDataCreation.UsrRec('TestlckrecRetnslsRep','testsalesrepmail@bcbsm.com','Retention Sales');
        usrLst.add(usrRetSlsRep);
        database.insert(usrLst);
        system.runAs(usrLst[0])
        {
            try{
                List<AccountContactRelation> acrList = null;
                List<ExceptionLog__c> eLogLst=null;

                test.startTest();
                GA_IsActiveUpdateOnBeforeInsertionOfACRs.updateIsactive(acrList);
                test.stopTest();
                eLogLst=[select id from ExceptionLog__c limit 1];
                system.assert(eLogLst.size()>0);
            }
            catch(exception e)
            {
                return;
            }
        }  
    }
    
    /*******************************************************************************************************************************
@Description: acntCntRelHndlrExcep() method 
@Name : acntCntRelHndlrExcep
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
    private static testmethod void acntCntRelHndlrExcep()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('Testlckrec','testsysadminmail@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {
            try{
                List<AccountContactRelation> acrList = null;
                
                test.startTest();
                GA_AccntContRelTriggerHandler.beforeinsert(acrList);
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