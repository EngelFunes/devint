@isTest
public class GA_DeleteGroupSegmentBatchPending_Test {
    
    @TestSetup static void setup()
    {
        
        string profId = [SELECT Id FROM Profile WHERE Name = 'System Administrator' Limit 1].Id;
        User usr = new User(
            ProfileId = profId,
            LastName = 'last',
            Email = 'demo@gmail.com',
            Username = 'demo@gmail.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'
        );
        insert usr;

        Account acc = new Account();
        acc.name = 'Test Account';
        acc.CID__c='123456'; 
        insert acc;
        
        Id agentRecordType = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Contact_Agent').getRecordTypeId();
        Contact cont = new Contact();
        cont.FirstName = 'First';
        cont.LastName = 'last';
        cont.AccountId = acc.Id;
        cont.Phone='1234567089';
        cont.recordtypeId = agentRecordType;
        insert cont;
        
        Case cas = new Case();
        cas.Subject = '112245';
        cas.GA_ASR_Notes__c = 'Asr notes';
        insert cas;
        
        GA_WFT_workflow__c  wfTmplt = new GA_WFT_workflow__c ();
        wfTmplt.Name = 'Test Workflow Template';
        wfTmplt.GA_Carrier__c = 'BCBSM';
        wfTmplt.GA_Method__c = 'Automated';
        wfTmplt.GA_Process_Type__c = 'GWC';
        wfTmplt.GA_Process_Subtype__c ='Benefit Change'; 
        insert wfTmplt;
        
        GA_WF_Workflow__c wrkFlw=new GA_WF_Workflow__c();
        wrkFlw.Name = 'Test Workflow';
        wrkFlw.GA_Account__c = acc.Id;
        wrkFlw.GA_Support__c = cas.Id;
        wrkFlw.GA_Workflow_Template__c = wfTmplt.Id;
        wrkFlw.OwnerId = usr.Id;
        wrkFlw.GA_Status__c = 'Open';
        wrkFlw.GA_Workflow_Owner__c = 'Test WF Owner';
        wrkFlw.GA_WorkflowOwner__c = usr.Id;
        wrkFlw.GA_Notes__c='Test Notes';
        wrkFlw.GA_Date_Opened__c = system.today();
        wrkFlw.GA_Date_Closed__c = system.today();
        wrkFlw.GA_Renewal_Date__c = system.today();
        insert wrkFlw;
        
        GA_WF_Step__c wfStep = new GA_WF_Step__c();
        wfStep.Name = 'Test Workflow Step';
        wfStep.GA_WF_Workflow_ID__c = wrkFlw.Id;
        wfStep.GA_Status__c = 'Open';
        wfStep.GA_Start__c = datetime.newInstance(2018, 5, 15, 12, 30, 0);
        wfStep.GA_End_Time__c = datetime.newInstance(2018, 7, 15, 12, 30, 0);
        wfStep.GA_Notes__c = 'Test Notes';
        insert wfStep;
        
        Datetime yesterday = Datetime.now().addDays(-365);
        GA_Group_Segment__c gsmt = GA_OBJ_TD01_TestDataCreation.grpSegmntRec(acc);
        gsmt.Status__C= 'Pending';
        gsmt.CreatedDate =  yesterday;
        Database.insert(gsmt);
        
        
        GA_Group_Segment__History objectHistory = new GA_Group_Segment__History (ParentId = gsmt.Id, Field = 'Status__c');
        insert objectHistory;
        
        GA_WF_Group_Segment__c  wfGrpSgm = new GA_WF_Group_Segment__c ();
        wfGrpSgm.GA_Group_Segment_ID__c = gsmt.Id;
        wfGrpSgm.GA_WF_Step_ID__c = wfStep.Id;
        
        wfGrpSgm.GA_Status__c = 'Open';
        insert wfGrpSgm;
        
        
        
        GA_Aor__C aorRec = New GA_Aor__C();
        aorRec.Name = 'TestAor';
        aorRec.GA_Account_Id__c = acc.id;
        aorRec.GA_Contact_Id__c =cont.id;
        insert aorRec;
        
        GA_AOR_Group_Segment__c aorGsRec = New GA_AOR_Group_Segment__c();
        aorGsRec.Name='TestAorGs';
        aorGsRec.GA_AOR_Id__c = aorRec.id;
        aorGsRec.GA_Group_Segment_Id__c =gsmt.id;
        
   
        
    }
  
    static testMethod void TestGA_DeleteGroupSegmentBatchPending()
    {
        Test.startTest();
        GA_DeleteGroupSegmentBatchPending x = new GA_DeleteGroupSegmentBatchPending();
        database.executeBatch(x);
        Test.stopTest();
        
    }
    public static String CRON_EXP = '0 0 0 15 3 ? 2022';
    @isTest static  void TestGA_DeleteGroupSegmentPending_Scheduler() 
    {
        Test.startTest();
        String jobId = System.schedule('GA_DeleteGroupSegmentPending_Scheduler',CRON_EXP,new GA_DeleteGroupSegmentPending_Scheduler());
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime
                          FROM CronTrigger WHERE id = :jobId];
        System.assertEquals(CRON_EXP, 
                            ct.CronExpression);
        System.assertEquals(0, ct.TimesTriggered);
        System.assertEquals('2022-03-15 00:00:00', 
                            String.valueOf(ct.NextFireTime));
        Test.stopTest();
        
        
    }
    

}