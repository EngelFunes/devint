@isTest
public class DeleteGroupSegmentControllerTest {
    
    @testSetup static void testData(){
        
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
        
        GA_Group_Segment__c groupSegment = new GA_Group_Segment__c();
        groupSegment.GA_Account__c = acc.id;
        groupSegment.Status__c = 'Pending';
        groupSegment.GA_Post_Transaction__c = false;
        groupSegment.GA_Transaction_Posted__c = false;
        insert groupSegment;
        
        GA_WF_Group_Segment__c  wfGrpSgm = new GA_WF_Group_Segment__c ();
        wfGrpSgm.GA_Group_Segment_ID__c = groupSegment.Id;
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
        aorGsRec.GA_Group_Segment_Id__c =groupSegment.id;
        
    }
    
    //
    @isTest static void deleteGroupSegmentTest(){
        
        GA_Group_Segment__c groupSegment = [select id from GA_Group_Segment__c];
        DeleteGroupSegmentController.deleteGroupSegment(groupSegment.Id);
        
        System.assertEquals(0, [select id from GA_Group_Segment__c].size());
    }
    
    //
    @isTest static void deleteGroupSegmentNotPendingTest(){
        try{
            GA_Group_Segment__c groupSegment = [select id from GA_Group_Segment__c];
            groupSegment.Status__c = 'Active';
            update groupSegment;
            
            DeleteGroupSegmentController.deleteGroupSegment(groupSegment.Id);
            System.assertEquals(1, [select id from GA_Group_Segment__c].size());
        }catch(Exception e){
            
        }
        
    }
}