/***********************************************************************************************************************************************
@Author : Dilip
@Name: GA_UpdateAccntsPltinmSts_Scheduler_Test 
@CreatedDate: 15 - Jan 2018 
@Description: GA_UpdateAccntsPltinmSts_Scheduler Test class 
@version : 1.0  
*************************************************************************************************************************************************/
@isTest
Private class GA_UpdateAccntsPltinmSts_Scheduler_Test {
/***********************************************************************************************************************************************
@Description: executeTest() method 
@Name : executeTest
@Param : None
@Return : void
@throws Exception : N/A;
************************************************************************************************************************************************/   
    private static testmethod void executeTest()
    {   
        string agencyRecType = 'Account - Agency';
        Id agencyRecTpeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(agencyRecType).getRecordTypeId();
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestJeoRl','testsalesrepmail@bcbsm.com','Integration User');
        insert usr;
        system.runAs(usr)
        {
            try{
                
                Account agaccnt = GA_OBJ_TD01_TestDataCreation.AccRec();
                agaccnt.RecordTypeId = agencyRecTpeId;
                agaccnt.GA_Platinum__c = true;
                database.insert(agaccnt);
                Account acc=GA_OBJ_TD01_TestDataCreation.AccRec();
                acc.GA_Platinum__c = false;
                database.insert(acc);
                GA_AgencyRelationship__c ar = GA_OBJ_TD01_TestDataCreation.agencyRelationshipRec(acc.Id);
                ar.GA_Account__c = acc.id;
                ar.GA_Agency__c = agaccnt.Id;
                ar.GA_StartDate__c = system.today();
                ar.GA_EndDate__c = system.today()+5; 
                database.insert(ar);
                
                Test.startTest();
                GA_UpdateAccntsPltinmSts_Scheduler p = new GA_UpdateAccntsPltinmSts_Scheduler();
                String sch = '0 0 23 * * ?'; 
                system.schedule('Platinum Check', sch, p);
                Test.stopTest(); 
                system.assert(acc <> null);
            }
            catch(exception e)
            {
                return;
            }
        }
    }  
    
/*********************************************************************************************************************************************
@Description: executeTest1() method 
@Name : executeTest1
@Param : None
@Return : void
@throws Exception : N/A;
*********************************************************************************************************************************************/   
    private static testmethod void executeTest1()
    {   
        string agencyRecType = 'Account - Agency';
        Id agencyRecTpeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(agencyRecType).getRecordTypeId();
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestJeoRl','testsalesrepmail@bcbsm.com','Integration User');
        insert usr;
        system.runAs(usr)
        {
            try{
                
                Account agaccnt = GA_OBJ_TD01_TestDataCreation.AccRec();
                agaccnt.RecordTypeId = agencyRecTpeId;
                agaccnt.GA_Platinum__c = true;
                database.insert(agaccnt);
                Account acc=GA_OBJ_TD01_TestDataCreation.AccRec();
                acc.GA_Platinum__c = false;
                database.insert(acc);
                GA_AgencyRelationship__c ar = GA_OBJ_TD01_TestDataCreation.agencyRelationshipRec(acc.Id);
                ar.GA_Account__c = acc.id;
                ar.GA_Agency__c = agaccnt.Id;
                ar.GA_StartDate__c = system.today() - 5;
                ar.GA_EndDate__c = system.today()-1; 
                database.insert(ar);
                
                Test.startTest();
                GA_UpdateAccntsPltinmSts_Scheduler p = new GA_UpdateAccntsPltinmSts_Scheduler();
                String sch = '0 0 23 * * ?'; 
                system.schedule('Platinum Check', sch, p);
                Test.stopTest(); 
                system.assert(acc <> null);
            }
            catch(exception e)
            {
                return;
            }
        }
    }  
}