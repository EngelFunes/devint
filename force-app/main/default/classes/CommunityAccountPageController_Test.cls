/**
@Author : IDC Offshore
@Name: CommunityAccountPageController_Test
@CreatedDate: 12-August-2020
@Description: CommunityAccountPageController_Test 
@version : 1.0 
*/
@isTest
public class CommunityAccountPageController_Test {
    Private static final String TEST_VAL='Test';
    Private static final String ACTIVE='Active';
    private static final string PROFILENAME='System Administrator';
    private static final string NAME='AP61LastName';
    private static final string USERNAME='bcbsm1@bcbsm.com';
    private static final string PROFILENAME1='BCBSM FSA';
    private static final string SEARCHTERM='TEST';
    /*********************************************************************************************************
@Description: testDataSetup1() method 
@Name : testDataSetup1
@Param : N/A
@Return : void
@throws Exception : N/A;
***********************************************************************************************************/
    
    @testSetup static void testDataSetup1() { 
        Account acc = new Account(name=TEST_VAL);
        acc.Status__c= ACTIVE;
        acc.ARV_Renewal_Account_Type__c='SG';
        acc.CID__c = '601013';
        
        database.insert(acc);
        user usr = ARV_AP05_TestDataCreation.UsrRec(PROFILENAME);
        usr.LastName = NAME;
        usr.Username=USERNAME;
        database.insert(usr,true);
    }
    
    private static testMethod void testisCustomer()
    {
        user usr1  = [SELECT Id from User where LastName =: NAME limit 1];
        system.runAs(usr1){
            Account acc=ARV_AP05_TestDataCreation.accRec();
            acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Customer').getRecordTypeId();
            acc.ARV_Renewal_Account_Type__c='SG';
            acc.Renewal_Month__c='January';
            acc.CreatedDate=system.today();
            database.insert(acc);
             Account acc1=ARV_AP05_TestDataCreation.accRec();
            acc1.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Unqualified Prospect (Agent)').getRecordTypeId();
            acc1.ARV_Renewal_Account_Type__c='SG';
            acc1.Renewal_Month__c='January';
            acc1.CreatedDate=system.today();
            database.insert(acc1);
            pricebook2 prb=ARV_AP05_TestDataCreation.priceBookRec();
            database.insert(prb);
            
            Opportunity opt= ARV_AP05_TestDataCreation.opportunityRec(acc.Id, prb.id);
            opt.name='Test';
            database.insert(opt);
            Quote qot=ARV_AP05_TestDataCreation.quoteRec(opt.id, prb.Id);
            qot.RecordTypeId=Schema.SObjectType.Quote.getRecordTypeInfosByName().get('Quote').getRecordTypeId();
            database.insert(qot);
            contract con =ARV_AP05_TestDataCreation.createContractRec(acc.Id);
            con.RecordTypeId=Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Renewal').getRecordTypeId();
            con.ARV_Renewal_Status__c='Released';
            con.Status='In Progress';
            database.insert(con);
            con.Status='Future';
            database.update(con);
            contract con1 =ARV_AP05_TestDataCreation.createContractRec(acc1.Id);
            con1.RecordTypeId=Schema.SObjectType.Contract.getRecordTypeInfosByName().get('Enrollment').getRecordTypeId();
            con1.Status='In Progress';
            database.insert(con1);
            con1.Status='Activated';
            database.update(con1);
            GA_Group_Segment__c gs =ARV_AP05_TestDataCreation.groupSegmentRec(acc.Id,con.Id);
            database.insert(gs);
            GA_Group_Segment__c gs1 =ARV_AP05_TestDataCreation.groupSegmentRec(acc.Id,con.Id);
            gs1.GA_Suite__c='SUITE A';
            database.insert(gs1);
            CommunityAccountPageController.isCustomer(acc.Id);
            CommunityAccountPageController.getAccountrecord(acc.Id);
            CommunityAccountPageController.disabledMaintenanceChange(acc.Id);
            CommunityAccountPageController.isPilotAgentListView();
            CommunityAccountPageController.AltQuoteCondition(acc.id);
            CommunityAccountPageController.AltQSGQuoteCondition(qot.id);
            CommunityAccountPageController.getAgentAccounts(SEARCHTERM);
            CommunityAccountPageController.getAgentCommunityUserAccountdetails(acc.id);
            CommunityAccountPageController.getAgentCommunityUserAccountdetails(acc1.id);
        }
    }
    
    
}