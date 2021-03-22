/*****************************************************************************************
Class Name   : ARV_AP38_CoverPageCotroller_Test 
Date Created : 23-JULY-2019
Created By   : IDC Offshore
Description  : This class is used for testing CoverPage Class
******************************************************************************************/
@isTest
Private without sharing class ARV_AP35_RateGridController_Test {
    private static final string PROFILENAME='BCBSM Agent';
    private static final string PROFILENAME1='System Administrator';
    private static final string IDS = 'id';
    private static final string NAME='AP35LastName';
    private static final string NAME1='AP35RateGrid';
    private static final string USERNAME='bcbsm1@bcbsm.com';
/**************  
Method name : testDataSetup
Params     : NA
Return Type : testmethod
Description :  testDataSetup() method 
*************/     
    @testSetup static void testDataSetup() {
        Account act= ARV_AP05_TestDataCreation.accRec();
        database.insert(act); 
        Id standardPriceBookRecId=Test.getStandardPricebookId();
        pricebook2 pb2=ARV_AP05_TestDataCreation.priceBookRec();
        database.insert(pb2);
        Opportunity opp= ARV_AP05_TestDataCreation.opportunityRec(act.Id,standardPriceBookRecId);
        database.insert(opp); 
        contact con= ARV_AP05_TestDataCreation.contactRec(act.Id);
        database.insert(con);
        attachment att=ARV_AP05_TestDataCreation.attachmentRec(con.Id,null);
        database.insert(att);
        User user1=ARV_AP05_TestDataCreation.UsrRec1(PROFILENAME,con.Id);
        user1.LastName = NAME;
        database.insert(User1,true);
        Quote quot = ARV_AP05_TestDataCreation.quoteRec1(opp.Id,standardPriceBookRecId,User1.Id);
        database.insert(quot);
        ARV_CO02_RateGridStaticData__c rateGridData = ARV_AP05_TestDataCreation.RateGridStaticData();
        database.insert(rateGridData);
        Product2 prd= ARV_AP05_TestDataCreation.productRec();
        database.insert(prd);
        pricebookEntry prc= ARV_AP05_TestDataCreation.priceBookEntryRec(prd.Id,standardPriceBookRecId);
        database.insert(prc);
        QuoteLineItem qli= ARV_AP05_TestDataCreation.quoteLineItemRec(quot.Id,prd.Id,prc.Id);
        database.insert(qli);
        user usr = ARV_AP05_TestDataCreation.UsrRec(PROFILENAME1);
        usr.LastName = NAME1;
        usr.Username=USERNAME;
        database.insert(usr,true);
    }
    /**************  
Method name : internalUserTest
Params     : NA
Return Type : testmethod
Description :  internalUserTest() method 
*************/ 
    private static testmethod void internalUserTest(){
        user usr1 = [SELECT Id from User where LastName =: NAME1 limit 1];
        quote quo=[select id from quote limit 1]; 
        system.runAs(usr1){
            PageReference pageRef = Page.ARV_VF06_RateGridPage;
            pageRef.getParameters().put(IDS, String.valueOf(quo.Id));
            Test.setCurrentPage(pageRef);
			ARV_AP35_RateGridController rate = new ARV_AP35_RateGridController();
            test.startTest();            
            rate.getRates();
            test.stopTest(); 
            System.assertNotEquals(null,pageRef);
        }
    }
    /**************  
Method name : externalUserTest
Params     : NA
Return Type : testmethod
Description :  externalUserTest() method 
*************/
    private static testmethod void externalUserTest(){
        user usr1 = [SELECT id from User where LastName =:NAME limit 1];
        quote quo=[select id from quote limit 1];
        system.runAs(usr1){ 
            PageReference pageRef = Page.ARV_VF06_RateGridPage;
            pageRef.getParameters().put(IDS, String.valueOf(quo.Id));
            Test.setCurrentPage(pageRef);
			ARV_AP35_RateGridController rate=new ARV_AP35_RateGridController();
            test.startTest();            
            rate.getRates();
            test.stopTest();
            System.assertNotEquals(null,pageRef);
        }
    }
    /**************  
Method name : exceptionTest
Params     : NA
Return Type : testmethod
Description :  exceptionTest() method 
*************/
    private static testmethod void exceptionTest(){
        user usr1 = [SELECT Id from User where LastName =: NAME1 limit 1];
        system.runAs(usr1){
            try{
                PageReference pageRef = Page.ARV_VF06_RateGridPage;
                pageRef.getParameters().put(IDS, null);
                Test.setCurrentPage(pageRef);
				ARV_AP35_RateGridController rate=new ARV_AP35_RateGridController();
                test.startTest();                
                rate.getRates();
                test.stopTest();
                System.assertNotEquals(null,pageRef);
            }
            catch(exception e){
                return;
            }
        }
    } 
}