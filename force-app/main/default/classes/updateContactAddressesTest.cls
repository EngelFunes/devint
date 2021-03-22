@isTest(SeeAllData=FALSE)
public class updateContactAddressesTest {
    
    @testSetup
    static void setup(){
        List<Account> allAccountList = new List<Account>();
        List<Contact> allContactList = new List<Contact>();
        List<GA_Group_Segment__c> allGroupSegment = new List<GA_Group_Segment__c>();
        Id customerRecTypeid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Prospect').getRecordTypeId();
        Id conAgentRecTypeid = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact - Agent').getRecordTypeId();
        for(Integer i = 1; i <= 2; i++){
            Account acc = new Account(Name='Test Account'+i, CID__c = '1234'+i, RecordTypeId = customerRecTypeid, ShippingCity='Detroit',ShippingCountry='United States',ShippingCountryCode='US',ShippingState='Michigan',ShippingStreet='123 Jefferson',ShippingPostalcode='48074' );
            allAccountList.add(acc);
        }
        insert allAccountList;
        
        for(Integer i = 1; i <= 28; i++){
            if(i>=1 && i<=2){
                Contact con = new Contact(FirstName = 'CEO', LastName = 'Test', Email = 'ceo@test.com.invalid', GA_Smart_ID__c = '234545234'+i, Active__c = TRUE, AccountId = allAccountList[0].id, GA_Contact_Role__c = 'Administrative');
                allContactList.add(con);
            }
            if(i>=3 && i<=4){
                Contact con = new Contact(FirstName = 'Decision_Maker', LastName = 'Test', Email = 'decisionmaker@test.com.invalid', GA_Smart_ID__c = '23534523'+i, Active__c = TRUE, AccountId = allAccountList[0].id);
                allContactList.add(con);
            }
            if(i>=5 && i<=6){
                Contact con = new Contact(FirstName = 'Consultant', LastName = 'Test', Email = 'consultant@test.com.invalid', GA_Smart_ID__c = '76864235'+i, Active__c = TRUE, AccountId = allAccountList[0].id, RecordTypeId = conAgentRecTypeid);
                allContactList.add(con);
            }
            if(i>=7 && i<=8){
                Contact con = new Contact(FirstName = 'Mutual_Voter', LastName = 'Test', Email = 'mutualvoter@test.com.invalid', GA_Smart_ID__c = '34657654'+i, Active__c = TRUE, AccountId = allAccountList[0].id);
                allContactList.add(con);
            }
            if(i>=9 && i<=10){
                Contact con = new Contact(FirstName = 'Principal_Admin', LastName = 'Test', Email = 'principaladmin@test.com.invalid', GA_Smart_ID__c = '876563'+i, Active__c = TRUE, AccountId = allAccountList[0].id);
                allContactList.add(con);
            }
            if(i>=11 && i<=12){
                Contact con = new Contact(FirstName = 'onSegment', LastName = 'Test', Email = 'onsegment@test.com.invalid', GA_Smart_ID__c = '46453734'+i, Active__c = TRUE, AccountId = allAccountList[0].id);
                allContactList.add(con);
            }
            if(i>=13 && i<=14){
                Contact con = new Contact(FirstName = 'Forsegment', LastName = 'Test', Email = 'forsegment@test.com.invalid', GA_Smart_ID__c = '58568703'+i, Active__c = TRUE, AccountId = allAccountList[0].id);
                allContactList.add(con);
            }
            if(i>=15 && i<=16){
                Contact con = new Contact(FirstName = 'CEO2', LastName = 'Test', Email = 'ceo2@test.com.invalid', GA_Smart_ID__c = '173854866'+i, Active__c = TRUE, AccountId = allAccountList[1].id, GA_Contact_Role__c = 'Administrative');
                allContactList.add(con);
            }
            if(i>=17 && i<=18){
                Contact con = new Contact(FirstName = 'Decision_Maker2', LastName = 'Test', Email = 'decisionmaker2@test.com.invalid', GA_Smart_ID__c = '23657389'+i, Active__c = TRUE, AccountId = allAccountList[1].id);
                allContactList.add(con);
            }
            if(i>=19 && i<=20){
                Contact con = new Contact(FirstName = 'Consultant2', LastName = 'Test', Email = 'consultant2@test.com.invalid', GA_Smart_ID__c = '233845444'+i, Active__c = TRUE, AccountId = allAccountList[1].id, RecordTypeId = conAgentRecTypeid);
                allContactList.add(con);
            }
            if(i>=21 && i<=22){
                Contact con = new Contact(FirstName = 'Mutual_Voter2', LastName = 'Test', Email = 'mutualvoter2@test.com.invalid', GA_Smart_ID__c = '346455554'+i, Active__c = TRUE, AccountId = allAccountList[1].id);
                allContactList.add(con);
            }
            if(i>=23 && i<=24){
                Contact con = new Contact(FirstName = 'Principal_Admin2', LastName = 'Test', Email = 'principaladmin2@test.com.invalid', GA_Smart_ID__c = '92223675'+i, Active__c = TRUE, AccountId = allAccountList[1].id);
                allContactList.add(con);
            }
            if(i==25){
                Contact con = new Contact(FirstName = 'onSegment2', LastName = 'Test', Email = 'onsegment2@test.com.invalid', GA_Smart_ID__c = '33375678'+i, Active__c = TRUE, AccountId = allAccountList[1].id);
                allContactList.add(con);
            }
            if(i==26){
                Contact con = new Contact(FirstName = 'onSegment2', LastName = 'Test', Email = 'onsegment2@test.com.invalid', GA_Smart_ID__c = '33375678'+i, Active__c = TRUE, AccountId = allAccountList[1].id, GA_Contact_Role__c = 'Administrative');
                allContactList.add(con);
            }
            if(i==27){
                Contact con = new Contact(FirstName = 'Forsegment2', LastName = 'Test', Email = 'forsegment2@test.com.invalid', GA_Smart_ID__c = '447788533'+i, Active__c = FALSE, AccountId = allAccountList[1].id, GA_Contact_Role__c = 'Administrative');
                allContactList.add(con);
            }
            if(i==28){
                Contact con = new Contact(FirstName = 'Forsegment2', LastName = 'Test', Email = 'forsegment2@test.com.invalid', GA_Smart_ID__c = '', Active__c = TRUE, AccountId = allAccountList[1].id, GA_Contact_Role__c = 'Administrative');
                allContactList.add(con);
            }
        }
        
        
        insert allContactList;
        
        for(Integer i = 1; i <= 2; i++){
            if(i==1){
                GA_Group_Segment__c segment = new GA_Group_Segment__c(Name='Test Group'+i, GA_Account__c = allAccountList[0].Id, Status__c = 'Canceled');
                allGroupSegment.add(segment);
            }
            if(i==2){
                GA_Group_Segment__c segment = new GA_Group_Segment__c(Name='Sample Group'+i, GA_Account__c = allAccountList[1].Id, Status__c = 'Canceled');
                allGroupSegment.add(segment);
            }
        }
        insert allGroupSegment;
        Account acc1 = new Account(Id = allAccountList[0].Id);
        Account acc2 = new Account(Id = allAccountList[1].Id);
        GA_Group_Segment__c seg1 = new GA_Group_Segment__c(Id = allGroupSegment[0].Id);
        GA_Group_Segment__c seg2 = new GA_Group_Segment__c(Id = allGroupSegment[1].Id);
        
        for(Contact con: allContactList){
            if(con.AccountId == acc1.id){
                if(con.FirstName == 'CEO'){
                    acc1.GA_CEO__c = con.id;
                    seg1.GA_Administrative_Contact_Id__c = con.id;
                }
                if(con.FirstName == 'Decision_Maker'){
                    acc1.GA_Decision_Maker__c = con.id;
                    seg1.GA_Billing_Contact_Id__c = con.id;
                }
                if(con.FirstName == 'Consultant'){
                    acc1.GA_Consultant__c = con.id;
                    seg1.GA_Commissioning_Agent__c = con.id;
                }
                if(con.FirstName == 'Mutual_Voter'){
                    acc1.GA_Mutual_Voter__c = con.id;
                    seg1.GA_Consultant_Id__c = con.id;
                }
                if(con.FirstName == 'Principal_Admin'){
                    acc1.GA_Principal_Admin__c = con.id;
                    seg1.GA_Level_1_Appeals_Contact__c = con.id;
                }
                if(con.FirstName == 'onSegment'){
                    acc1.GA_Principal_Admin__c = con.id;
                    seg1.GA_Level_2_Appeals_Contact__c = con.id;
                }
                if(con.FirstName == 'Forsegment'){
                    acc1.GA_Principal_Admin__c = con.id;
                    seg1.GA_Servicing_Agent__c = con.id;
                }
            } else if(con.AccountId == acc2.id){
                if(con.FirstName == 'CEO2'){
                    acc2.GA_CEO__c = con.id;
                    seg2.GA_Administrative_Contact_Id__c = con.id;
                }
                if(con.FirstName == 'Decision_Maker2'){
                    acc2.GA_Decision_Maker__c = con.id;
                    seg2.GA_Billing_Contact_Id__c = con.id;
                }
                if(con.FirstName == 'Consultant2'){
                    acc2.GA_Consultant__c = con.id;
                    seg2.GA_Commissioning_Agent__c = con.id;
                }
                if(con.FirstName == 'Mutual_Voter2'){
                    acc2.GA_Mutual_Voter__c = con.id;
                    seg2.GA_Consultant_Id__c = con.id;
                }
                if(con.FirstName == 'Principal_Admin2'){
                    acc2.GA_Principal_Admin__c = con.id;
                    seg2.GA_Level_1_Appeals_Contact__c = con.id;
                }
                if(con.FirstName == 'onSegment2'){
                    acc2.GA_Principal_Admin__c = con.id;
                    seg2.GA_Level_2_Appeals_Contact__c = con.id;
                }
                if(con.FirstName == 'Forsegment2'){
                    acc2.GA_Principal_Admin__c = con.id;
                    seg2.GA_Servicing_Agent__c = con.id;
                }
            }
        }
        update acc1;
        update acc2;
        update seg1;
        update seg2;
    }
    
    
    @isTest
    static void runBatch(){
        
        Test.startTest();
        Id batchJob = Database.executeBatch(new UpdateContactAddresses(), 200);
        Test.stopTest();
        
        List<Contact> activeContacts = [SELECT Id, Name, Active__c FROM Contact WHERE Active__c = TRUE];
        System.assertEquals(14, activeContacts.size());
        
        List<Contact> inactiveContacts = [SELECT Id, Name, Active__c FROM Contact WHERE Active__c = FALSE];
        System.assertEquals(14, inactiveContacts.size());
        
        List<Account> validateAccount = [SELECT Id, GA_CEO__r.Active__c, GA_Decision_Maker__r.Active__c, GA_Consultant__r.Active__c, GA_Mutual_Voter__r.Active__c, GA_Principal_Admin__r.Active__c FROM Account];
        System.assertEquals(TRUE, validateAccount[0].GA_CEO__r.Active__c);
        System.assertEquals(TRUE, validateAccount[0].GA_Decision_Maker__r.Active__c);
        System.assertEquals(TRUE, validateAccount[0].GA_Consultant__r.Active__c);
        System.assertEquals(TRUE, validateAccount[0].GA_Mutual_Voter__r.Active__c);
        System.assertEquals(TRUE, validateAccount[0].GA_Principal_Admin__r.Active__c);
        System.assertEquals(TRUE, validateAccount[1].GA_CEO__r.Active__c);
        System.assertEquals(TRUE, validateAccount[1].GA_Decision_Maker__r.Active__c);
        System.assertEquals(TRUE, validateAccount[1].GA_Consultant__r.Active__c);
        System.assertEquals(TRUE, validateAccount[1].GA_Mutual_Voter__r.Active__c);
        System.assertEquals(TRUE, validateAccount[1].GA_Principal_Admin__r.Active__c);
        
        List<GA_Group_Segment__c> validateGroupSegment = [SELECT Id, GA_Administrative_Contact_Id__r.Active__c, GA_Billing_Contact_Id__r.Active__c, GA_Commissioning_Agent__r.Active__c, GA_Consultant_Id__r.Active__c, GA_Level_1_Appeals_Contact__r.Active__c, GA_Level_2_Appeals_Contact__r.Active__c, GA_Servicing_Agent__r.Active__c FROM GA_Group_Segment__c];
        System.assertEquals(TRUE, validateGroupSegment[0].GA_Administrative_Contact_Id__r.Active__c);
        System.assertEquals(TRUE, validateGroupSegment[0].GA_Billing_Contact_Id__r.Active__c);
        System.assertEquals(TRUE, validateGroupSegment[0].GA_Consultant_Id__r.Active__c);
        System.assertEquals(TRUE, validateGroupSegment[0].GA_Level_1_Appeals_Contact__r.Active__c);
        System.assertEquals(TRUE, validateGroupSegment[0].GA_Level_2_Appeals_Contact__r.Active__c);
        System.assertEquals(TRUE, validateGroupSegment[1].GA_Administrative_Contact_Id__r.Active__c);
        System.assertEquals(TRUE, validateGroupSegment[1].GA_Billing_Contact_Id__r.Active__c);
        System.assertEquals(TRUE, validateGroupSegment[1].GA_Consultant_Id__r.Active__c);
        System.assertEquals(TRUE, validateGroupSegment[1].GA_Level_1_Appeals_Contact__r.Active__c);
        System.assertEquals(TRUE, validateGroupSegment[1].GA_Level_2_Appeals_Contact__r.Active__c);
        
    }
}