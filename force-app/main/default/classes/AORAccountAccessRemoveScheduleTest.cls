@istest
public class AORAccountAccessRemoveScheduleTest {
    @istest
    public static void  testschedule() {
        Account acctest = GA_OBJ_TD01_TestDataCreation.AccRec();
        insert acctest;
        Id devRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact - Agent').getRecordTypeId();
        Contact contest = GA_OBJ_TD01_TestDataCreation.cntactRec(acctest.Id);
        contest.Active__c = true;
        contest.RecordTypeId = devRecordTypeId;
        insert contest;
        List<GA_AOR__c> GAAorList = New List<GA_AOR__c>();
        GA_AOR__c Gatest = new GA_AOR__c();
        Gatest.Name = 'Test Agent';
        Gatest.GA_Account_Id__c = acctest.Id;
        Gatest.GA_Contact_Id__c = contest.Id;
        Gatest.GA_Service_End_Date__c = system.today() + 10;
        GAAorList.add(Gatest);
        insert GAAorList;
        Test.StartTest();
        AORAccountAccessRemoveSchedule sh1 = new AORAccountAccessRemoveSchedule();      
        String sch = '0 0 0 ? * * *';
        String jobId = system.schedule('Test check', sch, sh1);
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
        System.assertEquals(0, ct.TimesTriggered);
        Test.stopTest();
    }
}