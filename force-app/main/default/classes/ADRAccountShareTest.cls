@isTest
public class ADRAccountShareTest {
    @isTest
    public static void testMe(){ 
        List<Account> allAcc = new List<Account>();
        Id recTypeIdagency = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Account_Agency').getRecordTypeId();
        Id conAgent = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Contact_Agent').getRecordTypeId();
        Id recTypeIdofcontact = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get(System.label.Contact_Delegate_Agent_Record_Type).getRecordTypeId();
        Id cusrecordType = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Account_Customer').getRecordTypeId();
        Account accountAOR = new Account(Name = 'Portal 1', type = 'Account_Prospect',AccountNumber = 'Test001',RecordTypeId = cusrecordType, cid__c = '00000');
        allAcc.add(accountAOR);   
        Account acc1 = new Account(Name = 'Portal 1', type = 'Account_Prospect',AccountNumber = 'Test001',RecordTypeId = recTypeIdagency,cid__c = '00000');
        allAcc.add(acc1); 
        insert allAcc;
        Contact contact2 = new Contact(
            LastName='Test contact1',
            FirstName = 'Test',
            RecordTypeId = conAgent,
            Email='testcontact1@email.com',
            vlocity_ins__Type__c = 'Delegate Agent',
           //  vlocity_ins__Type__c = 'Agent',
            AccountId = acc1.Id);
        insert contact2;
        Contact contact1 = new Contact(
            LastName='Test contact1',
            FirstName = 'Test',
            RecordTypeId = conAgent,
            Email='testcontact1@email.com',
            vlocity_ins__Type__c = 'Delegate Agent',
           //  vlocity_ins__Type__c = 'Agent',
            AccountId = acc1.Id);
        insert contact1;
        string profId = [SELECT Id FROM Profile WHERE Name = :System.label.User_Profile_Name_Agent Limit 1].Id;
        User user1 = new User(
            ProfileId = profId,
            LastName = 'Last Name',
            Email = 'email@eamil.com',
            Username = System.currentTimeMillis() + 'email@eamil.com',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ContactId = contact1.Id
        );
        insert user1;
        User user2 = new User(
            ProfileId = profId,
            LastName = 'Last Name',
            Email = 'email@eamil.com',
            Username = System.currentTimeMillis() + 'email@eamil2.com',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ContactId = contact2.Id
        );
        insert user2;
        GA_Aor__C aorRec = New GA_Aor__C();
        aorRec.Name = 'TestAor';
        aorRec.GA_Account_Id__c = accountAOR.id;
        aorRec.GA_Contact_Id__c =contact1.Id ;
        insert aorRec;
        GA_Aor__C aorRec1 = New GA_Aor__C();
        aorRec1.Name = 'TestAor2';
        aorRec1.GA_Account_Id__c = accountAOR.id;
        aorRec1.GA_Contact_Id__c =contact1.Id ;
        aorRec1.GA_Service_End_Date__c = date.today()-10;
        insert aorRec1;
        Test.startTest();
        ADRAccountShare adr = new ADRAccountShare();
        Id jobId = Database.executeBatch(adr);
        Test.stopTest();
        Account[] accUpdatedList = [SELECT Id,Name FROM Account];
        System.assert(accUpdatedList[0].Name.Contains('Portal'));
        Contact[] conUpdatedList = [SELECT Id,lastName FROM Contact];
        System.assert(conUpdatedList[0].lastName.Contains('Test'));
    }
}