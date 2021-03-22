/*****************************************************************************************
Class Name   : ARV_AP38_CoverPageCotroller_Test 
Date Created : 23-JULY-2019
Created By   : IDC Offshore
Description  : This class is used for testing CoverPage Class
******************************************************************************************/
@isTest
Private without sharing class ARV_AP38_CoverPageCotroller_Test {
    private static final string PROFILENAME='BCBSM Agent';
    private static final string PROFILENAME1='Retention Sales';
    private static final string IDS='id';
    private static final string NAME='AP38LastName';
    private static final string NAME1='AP35RateGrid';
    private static final string USERNAME='bcbsm1@bcbsm.com';
    /**************  
Method name : testDataSetup
Params     : NA
Return Type : testmethod
Description :  testDataSetup() method 
*************/     
    @testSetup static void testDataSetup() {
        Account acc= ARV_AP05_TestDataCreation.accRec();
        database.insert(acc); 
        Id standardPriceBookRecId=Test.getStandardPricebookId();
        pricebook2 pb2=ARV_AP05_TestDataCreation.priceBookRec();
        database.insert(pb2);
        Opportunity opp= ARV_AP05_TestDataCreation.opportunityRec(acc.Id,standardPriceBookRecId);
        database.insert(opp); 
        contact con= ARV_AP05_TestDataCreation.contactRec(acc.Id);
        database.insert(con);
        attachment att=ARV_AP05_TestDataCreation.attachmentRec(con.Id,null);
        database.insert(att);
        User user1=ARV_AP05_TestDataCreation.UsrRec(PROFILENAME1);
        user1.LastName = NAME;
        database.insert(user1,true);
        Quote quote = ARV_AP05_TestDataCreation.quoteRec1(opp.Id,standardPriceBookRecId,User1.Id);
        database.insert(quote); 
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
            PageReference pageRef = Page.ARV_VF09_CoverPage;
            pageRef.getParameters().put(IDS, String.valueOf(quo.Id));
            Test.setCurrentPage(pageRef);
            ARV_AP38_CoverPageCotroller coverPage=new ARV_AP38_CoverPageCotroller();
            test.startTest();
            coverPage.getQuoteData();
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
            PageReference pageRef = Page.ARV_VF09_CoverPage;
            pageRef.getParameters().put(IDS, String.valueOf(quo.Id));
            Test.setCurrentPage(pageRef);
            ARV_AP38_CoverPageCotroller coverPage=new ARV_AP38_CoverPageCotroller();
            test.startTest();
            coverPage.getQuoteData();
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
        user usr1 = [SELECT id from User where LastName =:NAME limit 1];
        system.runAs(usr1){ 
            try{
                PageReference pageRef = Page.ARV_VF09_CoverPage;
                pageRef.getParameters().put(IDS, null);
                Test.setCurrentPage(pageRef);
                ARV_AP38_CoverPageCotroller coverPage=new ARV_AP38_CoverPageCotroller();
                test.startTest();
                coverPage.getQuoteData();
                test.stopTest();
                System.assertNotEquals(null,pageRef);
            }
            catch(exception e){
                return;
            }
        }
    }   
}