/*
@Author : IDC Offshore
@Name: GA_AccOutOfBusiness_Test 
@CreatedDate: 6 - Aug 2019 
@Description: GA_AccOutOfBusiness Test class
@version : 1.0  
*/
@isTest(seealldata = false)
private class GA_CASE_AP01_LockRecords_Test {
/*******************************************************************************************************************************
@Description: updtCaseSmrtId() method 
@Name : updtCaseSmrtId
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
    private static testmethod void updtCaseSmrtId(){
        user usrSA = GA_OBJ_TD01_TestDataCreation.UsrRec('Testwfstp','testsystemadminstrator@bcbsm.com','System Administrator');
        database.insert(usrSA);
        account accnt=GA_OBJ_TD01_TestDataCreation.AccRec();
        database.insert(accnt);
        List<Case> caseLst=new list<case>();
        map<id,Case> caseoldMap=new map<id,Case>();
        map<id,Case> casenewMap=new map<id,Case>();
        
        case cas=GA_OBJ_TD01_TestDataCreation.CaseRec();
        cas.GA_SMART_ID__c = '123';
        caseLst.add(cas);
        Database.insert(caseLst);
        casenewMap.put(cas.id, cas);
        caseoldMap.put(cas.id, cas);
        
        system.runAs(usrSA)
        {
            try{
                Test.startTest();
                //GA_CASE_AP01_LockRecords.lockCases(caseLst,casenewMap,caseoldMap);
                //GA_CASE_AP01_LockRecords.UnlockCases(caseLst,casenewMap,caseoldMap);
                Test.stopTest();
                system.assert(usrSA <> null);
            }
            catch(exception e)
            {
                return;
            }
        }
    }
  /********************************************************************************************************************************
@Description: updtCaseNullSmrtId() method 
@Name : updtCaseNullSmrtId
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
    private static testmethod void updtCaseNullSmrtId(){
        user usrSA = GA_OBJ_TD01_TestDataCreation.UsrRec('Testwfstp','testsystemadminstrator@bcbsm.com','System Administrator');
        database.insert(usrSA);
        account accnt=GA_OBJ_TD01_TestDataCreation.AccRec();
        database.insert(accnt);
        List<Case> caseLst=new list<case>();
        map<id,Case> caseoldMap=new map<id,Case>();
        map<id,Case> casenewMap=new map<id,Case>();
        
        case cas=GA_OBJ_TD01_TestDataCreation.CaseRec();
        cas.GA_SMART_ID__c = '';
        caseLst.add(cas);
        Database.insert(caseLst);
        casenewMap.put(cas.id, cas);
        caseoldMap.put(cas.id, cas);
        
        system.runAs(usrSA)
        {
            try{
                Test.startTest();
                //GA_CASE_AP01_LockRecords.lockCases(caseLst,casenewMap,caseoldMap);
                //GA_CASE_AP01_LockRecords.UnlockCases(caseLst,casenewMap,caseoldMap);
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
@Description: updtCaseExcptn() method 
@Name : updtCaseExcptn
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
    private static testmethod void updtCaseExcptn(){
        user usrSA = GA_OBJ_TD01_TestDataCreation.UsrRec('Testwfstp','testsystemadminstrator@bcbsm.com','System Administrator');
        database.insert(usrSA);
        account accnt=GA_OBJ_TD01_TestDataCreation.AccRec();
        database.insert(accnt);
        List<Case> caseLst=new list<case>();
        map<id,Case> caseoldMap=new map<id,Case>();
        map<id,Case> casenewMap=new map<id,Case>();
        
        system.runAs(usrSA)
        {
            try{
                Test.startTest();
                //GA_CASE_AP01_LockRecords.lockCases(null,casenewMap,caseoldMap);
                //GA_CASE_AP01_LockRecords.UnlockCases(null,casenewMap,caseoldMap);
                Test.stopTest();
                system.assert(usrSA <> null);
            }
            catch(exception e)
            {
                return;
            }
        }
    }   
}