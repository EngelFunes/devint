/***************************************************************************************************************************
@Author : Rahul
@Name: CommissionAgentonGS_Test
@CreatedDate:  09/18/2020 
@Description: CommissionAgentonGS_Test is a test class for CommissionAgentonGS_Schedular class
@version : 1.0  
***************************************************************************************************************************/

@isTest
public class CommissionAgentonGS_Test {
    @isTest static void executeTest()
    {
       user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestAgentAdmin','testsalesrepmail@bcbsm.com','Agent Administrator');
        database.insert(usr);
        
        Account acc1 = GA_OBJ_TD01_TestDataCreation.AccRec();
        acc1.Name='Test Acc1';
        acc1.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Customer').getRecordTypeId();
        database.insert(acc1);
        
        GA_Group_Segment__c gsmt = GA_OBJ_TD01_TestDataCreation.grpSegmntRec(acc1);
        database.insert(gsmt); 
        
        Contact cnt1 =  GA_OBJ_TD01_TestDataCreation.cntactRec(acc1.id);
        cnt1.FirstName = 'Andrew';
        cnt1.LastName = 'Barash';
        cnt1.recordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact - Agent').getRecordTypeId();
        insert cnt1;
        
        GA_Aor__C agentacctRelation = GA_OBJ_TD01_TestDataCreation.createAOR(acc1,cnt1);
        agentacctRelation.GA_Commission_Start_Date__c =  Date.newInstance(1990, 1, 1);
        agentacctRelation.GA_Commission_End_Date__c = System.today() - 1;
        insert agentacctRelation;
        
        GA_AOR_Group_Segment__c aorGSRec = GA_OBJ_TD01_TestDataCreation.createAORGS(agentacctRelation,gsmt);
        GA_AORGrpSgmntTriggerHandler.removeCommissionAgentFlag = true;
        insert aorGSRec;
        
		Test.startTest();
        SchedulableContext sc = null;
        CommissionAgentonGS_Scheduler schedule = new CommissionAgentonGS_Scheduler();
        schedule.execute(sc);
        Test.stopTest();
    }
}