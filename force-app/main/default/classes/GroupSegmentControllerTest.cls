/**
@Author : Raj Jena
@Name: GroupSegmentControllerTest 
@CreatedDate: 11 - Sep 2020 
@Description: GroupSegmentController Test class 
@version : 1.0  
*/
@isTest
public class GroupSegmentControllerTest {
    @testSetup
    public static void createTestData(){
        Account acc=GA_OBJ_TD01_TestDataCreation.AccRec();
        database.insert(acc);
        GA_Group_Segment__c gs = GA_OBJ_TD01_TestDataCreation.grpSegmntRec(acc);
        gs.Name='AMZ000009_AZ02';
        gs.GA_Account__c = acc.id;
        gs.status__c = 'Active';
        gs.GA_Facets_Group_ID__c = 'AMZ00000';
        database.insert(gs);
        GA_Group_Segment__c gs1 = GA_OBJ_TD01_TestDataCreation.grpSegmntRec(acc);
        gs1.Name='AMZ000009_AZ04';
        gs1.GA_Account__c = acc.id;
        gs1.status__c = 'Active';
        gs1.GA_Facets_Group_ID__c = 'AMZ00022';
        database.insert(gs1);
        GA_Group_Segment__c gs3 = GA_OBJ_TD01_TestDataCreation.grpSegmntRec(acc);
        gs3.Name='AMZ000009_AZ04';
        gs3.GA_Account__c = acc.id;
        gs3.status__c = 'Active';
        gs3.GA_MTV_Group__c = 'MTV00000';
        database.insert(gs3);
        User user = TestDataFactory.CreatePortalUser('BCBSM Agent', acc);
    }
    @isTest
    public static void testGetGroupListForSearch(){
        List<GA_Group_Segment__c> gs = [select Id,Name,GA_Account__c,GA_MTV_Group__c,GA_Facets_Group_ID__c from GA_Group_Segment__c];
        if(gs.size()>0)
        {
            Test.startTest();
            List<String> selectedIds = new List<String>();
            selectedIds.add(gs[1].Id);
            Id [] fixedSearchResults= new Id[1];
            fixedSearchResults[0] = gs[0].Id;
            Test.setFixedSearchResults(fixedSearchResults);
            List<LookupSearchResult> lsList  = GroupSegmentController.getGroupListForSearch('AMZ00000',null);
            System.assertEquals(1, lsList.size());
            GroupSegmentController.getGroupListForSearch('AMZ00000',selectedIds);
            GroupSegmentController.getGroupListForSearch('MTV00000',null);   
            Test.stopTest();
        }
    }
    @isTest
    public static void testgetGroupList(){
        List<GA_Group_Segment__c> gs = [select Id,Name,GA_Account__c,GA_MTV_Group__c,GA_Facets_Group_ID__c from GA_Group_Segment__c];
        if(gs.size()>0)
        {
            Test.startTest();
            List<GroupSegmentController.OptionWrapper> owList  = GroupSegmentController.getGroupList(gs[0].GA_Account__c);
            System.assertEquals(3, owList.size());
            Test.stopTest();
        }
    }
    @isTest
    public static void testgetAccountId(){
        List<GA_Group_Segment__c> gs = [select Id,Name,GA_Account__c,GA_MTV_Group__c,GA_Facets_Group_ID__c from GA_Group_Segment__c];
        if(gs.size()>0)
        {
            Test.startTest();
            GroupSegmentController.AccountDto adto = GroupSegmentController.getAccountId(gs[0].Id);
            System.assertEquals(adto.Id, gs[0].GA_Account__c);
            Test.stopTest();
        }
    }
    @isTest
    public static void testSearch(){
        Id idRecordId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Account_Customer').getRecordTypeId();
        List<Account> acc = [select Id,Name from Account];
        if(acc.size()>0)
        {
            Test.startTest();
            acc[0].RecordTypeId = idRecordId;
            update acc;
            List<String> selectedIds = new List<String>();
            Id [] fixedSearchResults= new Id[1];
            fixedSearchResults[0] = acc[0].Id;
            Test.setFixedSearchResults(fixedSearchResults);
            System.debug(acc[0].Name);
            List<LookupSearchResult> lsList  = GroupSegmentController.search(acc[0].Name,null);
            System.assertEquals(1, lsList.size());
            //GroupSegmentController.search('AMZ00000',selectedIds);
            //GroupSegmentController.search('MTV00000',null);   
            Test.stopTest();
        }
    }
}