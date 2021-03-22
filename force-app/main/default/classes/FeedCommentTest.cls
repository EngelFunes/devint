@isTest
public class FeedCommentTest {
    public static testMethod void testfeedComment_1() {
        User u = [SELECT Id, name FROM user WHERE Id = :UserInfo.getUserId()];
        User userinput;
        system.runAs(u) {
            userinput = Testdatafactory.userRecord(System.label.User_Profile_Name_Support, 'testagent7@test.com.bcbsm');
            userrole usr=[select id,name from userrole where name='Support Representative'];
            userinput.UserRoleId=usr.id;
            update userinput;
        }
        Id recTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Agent Support Request').getRecordTypeId();
        Id accrecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Customer').getRecordTypeId();
        List<FeedComment> flist = new List<FeedComment>();
        Account acc = new Account();
        acc.recordtypeId = accrecTypeId ;
        acc.Name = 'TestAcc';
        acc.Account_Status__c = 'Active';
        acc.Phone = '1234323454';
        //acc.Employees = 5;
        acc.GA_Total_Eligible__c = 5;
        acc.ARV_Total_Eligible__c = 5;
        acc.Renewal_Month__c = 'January';
        acc.CID__c='231';
        INSERT acc;
        
        system.debug('===>acc' + acc);
        Contact con = new Contact();
        con.LastName = 'Test Contact';
        con.FirstName = 'Test';
        con.Email = 'testcontact@email.com';
        con.AccountId = acc.Id;
        insert con;
        Profile profId = [SELECT Id,name FROM Profile WHERE Name = 'BCBSM FSA' Limit 1];
        User portalUs = new User();
        portalUs.ProfileId = profId.Id;
        portalUs.LastName = 'Last Name';
        portalUs.Email = 'email@eamil.com';
        portalUs.Username = System.currentTimeMillis() + 'email1@eamil.com';
        portalUs.Alias = 'alias';
        portalUs.TimeZoneSidKey = 'America/Los_Angeles';
        portalUs.EmailEncodingKey = 'UTF-8';
        portalUs.LanguageLocaleKey = 'en_US';
        portalUs.LocaleSidKey = 'en_US';
        portalUs.ContactId = con.Id;
        Insert portalUs;
        Case c = new Case();
        c.recordtypeId = recTypeId;
        c.AccountId = acc.Id;
        c.Status = 'Submitted';
        c.GA_WorkOrderCategory__c = 'Support Request';
        c.Subject = 'Test Subject';
        c.Description = 'This is Case Desciption';
        c.ContactId = con.Id;
        c.GA_AgentName__c=con.Id;
        c.GA_ASR__c=userinput.id;
        //c.FSA_Delegated_Agent__c = portalUs.Id;
        c.Field_reoccurrence_email_check__c=false;
        c.FSA_Delegated_Agent__c=userinput.id;
        c.Managing_Agent__c=userinput.id;
        INSERT c;
        
        //CaseShare cs = new CaseShare();
        //cs.CaseId = c.Id;
        //cs.UserOrGroupId = userinput.id;
        //cs.CaseAccessLevel = 'Edit';
        //insert cs;
        //CaseShare cs1 = new CaseShare();
        //cs1.CaseId = c.Id;
        //cs1.UserOrGroupId = portalUs.id;
        //cs1.CaseAccessLevel = 'Edit';
        //insert cs1;
        FeedItem f;
        system.runAs(userinput) {
            f = new FeedItem();
            f.ParentId = c.Id;
            f.Body = 'This is feed body';
            f.Type = 'TextPost';
            Insert f;
            system.debug('===>feedItem' + f);
            
            FeedComment fcomment = new FeedComment();
            fcomment.feedItemId = f.Id;
            fcomment.commentBody = 'test Cpmment body';
            //fcomment.ParentId = f.parentId;
            flist.add(fcomment);
            Insert flist;
        }
        List<FeedComment> fcQ = [Select Id,CommentBody, FeedItemId,ParentId from FeedComment where ParentId = :c.Id LIMIT 1];
        system.debug('fcQ==>'+fcQ);
        test.startTest();
        system.runAs(portalUs) {
            FeedCommentTriggerHandler.postcommentBeforeInsertAndUpdate(fcQ);
            FeedCommentTriggerHandler.setRequestNumberAccountDetails(fcQ);
            FeedCommentTriggerHandler.noResponseEmailChecktoAgent(fcQ);
        }
        system.runAs(userinput) {
            FeedCommentTriggerHandler.setRequestNumberAccountDetails(fcQ);
            FeedCommentTriggerHandler.noResponseEmailChecktoAgent(fcQ);
        }
        FeedCommentTriggerHandler.feedCommentBeforeIU(fcQ);  
        FeedCommentTriggerHandler.setRequestNumberAccountDetails(fcQ);
        FeedCommentTriggerHandler.noResponseEmailChecktoAgent(fcQ);
        test.stopTest();
    }
}