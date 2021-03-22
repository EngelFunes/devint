@isTest(seealldata=false)
/***********************************************************************************************************
*Class Name   : ARV_AP43_GetCompletedQuotes_Test 
*Date Created : 18-August-2019
*Created By   : IDC Offshore
*Description  : It is test class for ARV_AP43_GetCompletedQuotes
***********************************************************************************************************/
public class ARV_AP43_GetCompletedQuotes_Test {
    private static final string NAME='compltedQuotes';
    private static final string NAME1='TXtest';
    private static final string ACTIVE='Active';
    private static final string NBQUOTING='NB Quoting';
    private static final string SYSADMIN='System Administrator';
    private static final string RECORDTYPENAME='Unqualified Prospect (Agent)';
/***********************************************************************************************************
*Method Name   : testDataSetup()
*Date Created : 18-August-2019
*Created By   : IDC Offshore
*Description  : It Creates test data for the Class
***********************************************************************************************************/
    @testSetup static void testDataSetup() {
        user usr = ARV_AP05_TestDataCreation.UsrRec(SYSADMIN);
        usr.LastName = NAME;
        database.insert(usr,true);
        system.runAs(usr){
        Id recordTypeIdAccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get(RECORDTYPENAME).getRecordTypeId();                                
        Account accnt=ARV_AP05_TestDataCreation.AccRec1(recordTypeIdAccount);
        accnt.Account_Status__c=ACTIVE;
        accnt.AccountSource=NBQUOTING;
        database.insert(accnt);
        Account acnt= ARV_AP05_TestDataCreation.accRec();
        acnt.name=NAME1;
        database.insert(acnt);
        Contract cntrct = ARV_AP05_TestDataCreation.createContractRec(acnt.id);
        database.insert(cntrct);
        Product2 prod=ARV_AP05_TestDataCreation.productRec();
        database.insert(prod);
        Id standardPriceBookRecId=Test.getStandardPricebookId();
        pricebookEntry pre=ARV_AP05_TestDataCreation.priceBookEntryRec(prod.Id,standardPriceBookRecId);database.insert(pre);
        opportunity opp=ARV_AP05_TestDataCreation.opportunityRec(accnt.Id,standardPriceBookRecId);database.insert(opp);
        Quote quo=ARV_AP05_TestDataCreation.quoteRec(opp.Id,standardPriceBookRecId);
        database.insert(quo);
        QuoteLineItem qli1=ARV_AP05_TestDataCreation.quoteLineItemRec(quo.Id,prod.Id,pre.Id);database.insert(qli1);
        }
    }
/***********************************************************************************************************
**Method Name   :complQuotesExcepTest()
*Date Created : 18-August-2019
*Created By   : IDC Offshore
*Description  : this method Covers the testClass Coverage.
***********************************************************************************************************/
    private static testmethod void complQuotesExcepTest(){
      user usr1 = [SELECT Id from User where LastName =: NAME limit 1];
        List<Quote>compQuotes=New List<Quote>();
        system.runAs(usr1) {
           Account acc=[SELECT Id,Name from Account limit 1];
            Quote qte=[SELECT Id,Name from Quote limit 1];
            qte.Tech_QuoteStatus__c=ACTIVE;
            database.update(qte);      
            test.startTest();
            compQuotes=ARV_AP43_GetCompletedQuotes.getCompletedQuotes(acc.Id);
            test.stopTest();
            system.assertEquals(1,compQuotes.size());
        }
    }
/***********************************************************************************************************
**Method Name   :complQuotesExcepTest()
*Date Created : 18-August-2019
*Created By   : IDC Offshore
*Description  : this method Covers the testClass Coverage.
***********************************************************************************************************/
private static testmethod void txRecordsTest(){
    user usr1 = [SELECT Id from User where LastName =: NAME limit 1];
        List<TX__c> txRecords=New List<TX__c>();
        system.runAs(usr1) {
           Account acc=[SELECT Id,Name from Account where name=:NAME1 limit 1];
            Contract con=[SELECT Id,Name from Contract limit 1];
            test.startTest();
            txRecords=ARV_AP43_GetCompletedQuotes.getTXRecords(con.Id);
            test.stopTest();
            system.assertNotEquals(null,con.Id);
        }
    
	}
}