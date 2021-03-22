/**
@Author : Roshan Kotla
@Name: TestDataFactory 
@CreatedDate: 01 - Apr 2020 
@Description: Test Data Factory.
@version : 1.0  
*/
@isTest(SeeAllData=false)
public class TestDataFactory {
    static Integer idCounter = 1;
    Public static Case supportRequestRecord(String status){
        Account customerAccount = accountRecord(System.label.Account_Record_Type_Customer);
        Case supportRequestRecordStatusNew = new Case(Status = status, Subject = 'Test Subject', AccountId = customerAccount.id,
                                                      Description = 'Test Description', GA_ASR_Notes__c = 'Test Notes' );
        insert supportRequestRecordStatusNew;
        return supportRequestRecordStatusNew;
    }
    
    public static User userRecord(String profile, String userName){
        Profile profileId = [SELECT Id 
                             FROM Profile 
                             WHERE name =: profile];
        Integer randomNumber = Integer.valueof((Math.random() * 10));
        User userRecord;
        userRecord = new User(LastName = 'TestUser', Email = 'testUser6@test.com.bcbsm', username = userName+String.valueOf(randomNumber), profileid = profileId.id,
                              Alias = 'TestUser', TimeZoneSidKey = 'America/New_York', LocaleSidKey = 'en_US', EmailEncodingKey = 'ISO-8859-1', 
                              LanguageLocaleKey = 'en_US', GA_ByPass_VR__c=true );
        insert userRecord;
        return userRecord;
    }
    
    public static Account accountRecord(String recordType){
        RecordType accountRecordType = [SELECT Id 
                                        FROM RecordType 
                                        WHERE DeveloperName =: recordType];
        Account accountRecord = new Account(Name = 'Test Account', AccountNumber = 'Test001',
                                            RecordTypeId = accountRecordType.Id, cid__c = '00000');
        insert accountRecord;
        return accountRecord;
    }
    
    public static Account accountRecordWithFakeId(String recordType){
        RecordType accountRecordType = [SELECT Id 
                                        FROM RecordType 
                                        WHERE DeveloperName =: recordType];
        Id AccountId = getFakeId(Account.SObjectType);
        Account accountRecord = new Account(Id = AccountId, Name = 'Test Account', AccountNumber = 'Test001',
                                            RecordTypeId = accountRecordType.Id, cid__c = '00000');
        return accountRecord;
    }
    
    public static contact agentContactRecord(String recordType){
        user userAdmin = TestDataFactory.userRecord('TechnoSoftSystemAdmin','testAdmin10@test.com');
        Account agencyAccount = accountRecord(System.label.Account_Record_Type_Agency);
        agencyAccount.OwnerId = UserInfo.getUserId();
        RecordType contactRecordType = [SELECT Id 
                                        FROM RecordType 
                                        WHERE DeveloperName =: recordType];
        Contact agent = new Contact(FirstName = 'Agent', LastName = 'Test', AccountId = agencyAccount.id,
                                    Email = 'testcontact@test.com.bcbsm',Delegate_Contact__c = true, RecordTypeId = contactRecordType.Id);
        System.runAs(userAdmin){
            insert agent;
        }
        return agent;
    }
    
    public static User CreatePortalUser(string profileName, Account account)
    {
        try{
            Contact contact = new Contact(
                LastName='Test Contact',
                FirstName = 'Test',
                Email='testcontact@email.com',
                AccountId = account.Id);
            insert contact;
            
            
            string profId = [SELECT Id FROM Profile WHERE Name = :profileName Limit 1].Id;
            User user = new User(
                ProfileId = profId,
                LastName = 'Last Name',
                Email = 'email@eamil.com',
                Username = System.currentTimeMillis() + 'email@eamil.com',
                Alias = 'alias',
                TimeZoneSidKey = 'America/Los_Angeles',
                EmailEncodingKey = 'UTF-8',
                LanguageLocaleKey = 'en_US',
                LocaleSidKey = 'en_US',
                ContactId = contact.Id
            );
            
            return user;
        }
        catch(Exception e){
            return null;
        }
    }
    
    public static Case supportRequestRecord(){
        User agentAdminUser = TestDataFactory.agentUserRecord(System.label.User_Profile_Name_Agent, 'testagentadmin2@test.com.bcbsm');
        //User agentUser = TestDataFactory.agentUserRecord(System.label.User_Profile_Name_Agent, 'testagent3@test.com.bcbsm');
        Contact agentContact = agentContactRecord(System.label.Contact_Record_Type_Agency);
        User asrUser = TestDataFactory.userRecord(System.label.User_Profile_Name_Support, 'testASR1@test.com.bcbsm'); 
        Account customerAccount = accountRecord(System.label.Account_Record_Type_Customer);
        Case supportRequestRecord = new Case(Status = 'In Progress', Subject = 'Test Subject', AccountId = customerAccount.id, GA_ASR__c = asrUser.Id,
                                             GA_AgentName__c = agentContact.Id, FSA_Delegated_Agent__c = agentAdminUser.Id,Description = 'Test Description', GA_ASR_Notes__c = 'Test Notes');
        insert supportRequestRecord;
        return supportRequestRecord;
    } 
    public static Case createSupportRequestRecord(){
        User agentAdminUser = TestDataFactory.agentUserRecord(System.label.User_Profile_Name_Agent, 'testagentadmin2@test.com.bcbsm');
        //User agentUser = TestDataFactory.agentUserRecord(System.label.User_Profile_Name_Agent, 'testagent3@test.com.bcbsm');
        Contact agentContact = agentContactRecord(System.label.Contact_Record_Type_Agency);
        User asrUser = TestDataFactory.userRecord(System.label.User_Profile_Name_Support, 'testASR1@test.com.bcbsm'); 
        Account customerAccount = accountRecord(System.label.Account_Record_Type_Customer);
        Case supportRequestRecord = new Case(Status = 'In Progress', Subject = 'Test Subject', AccountId = customerAccount.id,
                                             GA_AgentName__c = agentContact.Id, FSA_Delegated_Agent__c = agentAdminUser.Id,Description = 'Test Description', GA_ASR_Notes__c = 'Test Notes');
        insert supportRequestRecord;
        return supportRequestRecord;
    }
    
    public static Case supportRequestRecordforASR(){
        User agentAdminUser = TestDataFactory.agentUserRecord(System.label.User_Profile_Name_Agent, 'testagentadmin2@test.com.bcbsm');
        //User agentUser = TestDataFactory.agentUserRecord(System.label.User_Profile_Name_Agent, 'testagent3@test.com.bcbsm');
        Contact agentContact = agentContactRecord(System.label.Contact_Record_Type_Agency);
        //add new custom lable here
        User asrUser = TestDataFactory.userRecord(System.label.User_Profile_Name_Support, 'testASR1@test.com.bcbsm'); 
        Account customerAccount = accountRecord(System.label.Account_Record_Type_Customer);
        Case supportRequestRecord = new Case(Status = 'In Progress', Subject = 'Test Subject', AccountId = customerAccount.id, GA_ASR__c = asrUser.Id,
                                             GA_AgentName__c = agentContact.Id, FSA_Delegated_Agent__c = agentAdminUser.Id,Description = 'Test Description', GA_ASR_Notes__c = 'Test Notes');
        insert supportRequestRecord;
        return supportRequestRecord;
    }
    
    public static Case supportRequestRecordByAgent(){
        User agentAdminUser = TestDataFactory.agentUserRecord(System.label.User_Profile_Name_Agent, 'testagentadmin2@test.com.bcbsm');
        Contact agentContact = agentContactRecord(System.label.Contact_Record_Type_Agency);
        Account customerAccount = accountRecordWithFakeId(System.label.Account_Record_Type_Customer);
        Id caseId = getFakeId(Case.SObjectType);
        Case supportRequestRecord = new Case(Id = caseId, Status = 'New', Subject = 'Test Subject', AccountId = customerAccount.id,
                                            Description = 'Test Description', GA_ASR_Notes__c = 'Test Notes');
        
        return supportRequestRecord;
    }
    
    public static FeedItem feedItemPostForSupportRequest(){
        Case supportRequestRecord = supportRequestRecord();
        FeedItem feedItemPostForSupportRequest;
        User aSRUserRecord = TestDataFactory.userRecord(System.label.User_Profile_Name_Support, 'testAdmin5@test.com.bcbsm');
        system.runAs(aSRUserRecord){
            feedItemPostForSupportRequest = new FeedItem( ParentId = supportRequestRecord.Id, Type = 'TextPost',  
                                                        Body = '<p>test</p>', IsRichText=true, Visibility='InternalUsers');
        }
        System.runAs(aSRUserRecord){
            insert feedItemPostForSupportRequest;
        }
        return feedItemPostForSupportRequest;
    }
    
    public static FeedItem feedItemPostForSupportRequestASR(){
        Case supportRequestRecord = supportRequestRecordforASR();
        FeedItem feedItemPostForSupportRequest;
        User aSRUserRecord = TestDataFactory.userRecord(System.label.User_Profile_Name_Support, 'testAdmin5@test.com.bcbsm');
        system.runAs(aSRUserRecord){
            feedItemPostForSupportRequest = new FeedItem( ParentId = supportRequestRecord.Id, Type = 'TextPost',  
                                                        Body = '<p>test</p>', IsRichText=true, Visibility='InternalUsers');
        }
        System.runAs(aSRUserRecord){
            insert feedItemPostForSupportRequest;
        }
        return feedItemPostForSupportRequest;
    }
    
    public static testMethod ContentDocument contentDocument() {
        ContentVersion contentVersion = new ContentVersion( Title = 'test', PathOnClient = 'test.jpg',
                                                             VersionData = Blob.valueOf('Test Content'), IsMajorVersion = true);
        insert contentVersion;
        
        ContentVersion contentVersionForContentDocumentId = [SELECT Id, Title, ContentDocumentId FROM ContentVersion WHERE Id = :contentVersion.Id LIMIT 1];
        ContentDocument contentDocument = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument WHERE Id =: contentVersionForContentDocumentId.ContentDocumentId];
        return contentDocument;
    }
    
    public static User agentUserRecord(String profile, String userName){
        Profile profileId = [SELECT Id 
                             FROM Profile 
                             WHERE name =: profile];
        Contact agentContact = agentContactRecord(System.label.Contact_Record_Type_Agency);
        UserRole userRole = [SELECT Id 
                             FROM UserRole 
                             WHERE DeveloperName = 'Account_Services_Manager'];
        String hashString = '1000' + String.valueOf(Datetime.now().formatGMT('yyyy-MM-dd HH:mm:ss.SSS'));
        Blob hash = Crypto.generateDigest('MD5', Blob.valueOf(hashString));
        String hexDigest = EncodingUtil.convertToHex(hash);
        
        Integer randomNumber = Integer.valueof((Math.random() * 10));User userRecord;
        userRecord = new User(LastName = 'TestUser', Email = 'test@test.com', username = userName+String.valueOf(randomNumber), profileid = profileId.id, CommunityNickName = hexDigest,
                              Alias = 'TestUser', TimeZoneSidKey = 'America/New_York', LocaleSidKey = 'en_US', EmailEncodingKey = 'ISO-8859-1', contactId = agentContact.id, 
                              LanguageLocaleKey = 'en_US');
       
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        
        System.runAs (thisUser) {    
            insert userRecord;
        }
        return userRecord;
    }

    public static String getFakeId(Schema.SObjectType sot){
        String result = String.valueOf(idCounter);
        idCounter ++;
        return sot.getDescribe().getKeyPrefix() + '0'.repeat(12-result.length()) + result;
    }
}