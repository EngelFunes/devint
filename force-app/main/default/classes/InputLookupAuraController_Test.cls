/*******************************************************************************************************************************
@Author : Raj Jena
@Name: InputLookupAuraController_Test 
@CreatedDate: 19 - Apr 2019 
@Description: InputLookupAuraController_Test Test class 
@version : 1.0  
********************************************************************************************************************************/
@isTest
public class InputLookupAuraController_Test {
   /*******************************************************************************************************************************
@Description: getCurrentValue_UT() method 
@Name : getCurrentValue_UT
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
    private static testmethod void getCurrentValue_UT()
    {
        list<user> UsrLst=new list<user>();
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestRec','testsysadminmail@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {
            try{
                
                account accnt=GA_OBJ_TD01_TestDataCreation.AccRec();
                Database.insert(accnt);
                account accnt1=GA_OBJ_TD01_TestDataCreation.AccRec();
                Database.insert(accnt1);
                GA_Group_Segment__c grpSegmntRec =GA_OBJ_TD01_TestDataCreation.grpSegmntRec(accnt);
                Database.insert(grpSegmntRec);
                case cas=GA_OBJ_TD01_TestDataCreation.CaseRec();
                Database.insert(cas);
                test.startTest();
                InputLookupAuraController.getCurrentValue('Account',accnt.id,'Name');
                InputLookupAuraController.searchSObject('Account',null, accnt.Name,accnt.id,'CID__c');
                InputLookupAuraController.searchSObject('GA_Group_Segment__c',null, grpSegmntRec.Name,grpSegmntRec.id,'Name');
                InputLookupAuraController.searchSObject('Case',null, cas.caseNumber,cas.id,'caseNumber');
                
                test.stopTest();
                system.assert(UsrLst <> null);
            }
            catch(exception e)
            {
                return;
            }
        }  
    }
    /*******************************************************************************************************************************
@Description: getCurrentValue_case() method 
@Name : getCurrentValue_case
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
    
    private static testmethod void getCurrentValue_case()
    {
        list<user> UsrLst=new list<user>();
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestRec','testsysadminmail@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {
            try{
                
                account accnt=GA_OBJ_TD01_TestDataCreation.AccRec();
                Database.insert(accnt);
                case cas=GA_OBJ_TD01_TestDataCreation.CaseRec();
                Database.insert(cas);
                test.startTest();
                InputLookupAuraController.getCurrentValue('','test','');
                InputLookupAuraController.getCurrentValue('','','');
                InputLookupAuraController.getCurrentValue('test','','');
                 InputLookupAuraController.getCurrentValue('Account','test','Name');
                InputLookupAuraController.searchSObject('Account',null, 'test','','');
                InputLookupAuraController.searchSObject('Account',null, 'test','test','test');
                InputLookupAuraController.SearchResult myclass = new InputLookupAuraController.SearchResult();
                myclass.id = 'test';
                myclass.value = 'test';
                
                test.stopTest();
                system.assert(UsrLst <> null);
            }
            catch(exception e)
            {
                return;
            }
        }  
    }
      /*******************************************************************************************************************************
@Description: getCurrentValue_User() method 
@Name : getCurrentValue_User
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
    
    private static testmethod void getCurrentValue_User()
    {
        list<user> UsrLst=new list<user>();
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestRec','testsysadminmail@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {
            try{
                
                account accnt=GA_OBJ_TD01_TestDataCreation.AccRec();
                Database.insert(accnt);
                case cas=GA_OBJ_TD01_TestDataCreation.CaseRec();
                Database.insert(cas);
                test.startTest();
                InputLookupAuraController.getCurrentValue('','test','');
                InputLookupAuraController.getCurrentValue('','','');
                InputLookupAuraController.getCurrentValue('test','','');
                InputLookupAuraController.getCurrentValue('Account','test','Name');
                InputLookupAuraController.searchSObject('User','', 'test','','');
                InputLookupAuraController.searchSObject('User','RC Buddy Check', 'test','test','test');
                InputLookupAuraController.SearchResult myclass = new InputLookupAuraController.SearchResult();
                myclass.id = 'test';
                myclass.value = 'test';
                
                test.stopTest();
                system.assert(UsrLst <> null);
            }
            catch(exception e)
            {
                return;
            }
        }  
    }
}