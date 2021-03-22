/*****************************************************************************************
Class Name   : RemoveQuotedRatesServiceTest 
Date Created : 30-JULY-2019
Created By   : Onshore
Description  : This class is used for testing 'RemoveQuotedRatesService'.
******************************************************************************************/
@isTest
public without sharing class ARV_AP17_RemoveQuotedRatesService_Test {
    
    // Initializing variables and constants.
    private static final string PROFILENAME='System Administrator';
    private static final string QUOTEID='quoteId';
    private static final string QLIDS='QLIds';
    private static final string NAME='Test';
    private static final string NAME1='Name1';
    private static final string METHOD='testDeleteService';
    private static final string VALUE='["';
    private static final string VALUE1='"]';
    
    /**************  
    Method name : testDataSetup
    Params      : NA
    Return Type : testmethod
    Description : testDataSetup() method 
	*************/
    @testSetup static void testDataSetup() {     
        user usr = ARV_AP05_TestDataCreation.UsrRec(PROFILENAME);
        usr.LastName = NAME1;
        usr.FirstName = NAME;
        database.insert(usr,true);  
        Account acc = ARV_AP05_TestDataCreation.accRec();
        database.insert(acc,true) ;
        Id standardPriceBookRecId=Test.getStandardPricebookId(); 
        pricebook2 pb1 = ARV_AP05_TestDataCreation.priceBookRec();	
        database.insert(pb1,true) ;
        Opportunity opp = ARV_AP05_TestDataCreation.opportunityRec(acc.Id,standardPriceBookRecId);	
        database.insert(opp,true) ;  
        Quote quote = ARV_AP05_TestDataCreation.quoteRec(opp.Id,standardPriceBookRecId);
        database.insert(quote,true) ;
        Product2 prd = ARV_AP05_TestDataCreation.productRec();
        database.insert(prd,true) ;
        pricebookEntry prc = ARV_AP05_TestDataCreation.priceBookEntryRec(prd.Id,standardPriceBookRecId);
        database.insert(prc,true) ;
        QuoteLineItem qli = ARV_AP05_TestDataCreation.quoteLineItemRec(quote.Id,prd.Id,prc.Id);
        database.insert(qli,true) ;
        opp.OwnerId = usr.id;
        database.update(opp,true);
        vlocity_ins__QuoteLineItemRateBreakout__c qlirb = ARV_AP05_TestDataCreation.quoteBreakoutRec1(quote.Id,prd.Id);
        database.insert(qlirb, true); 
    }  
    /**************  
    Method name : testDeleteService
    Params     : NA
    Return Type : testmethod
    Description :  to test the invokeMethod() method in class: 'RemoveQuotedRatesService'.
	*************/     
    static testMethod void testDeleteService() {
        Map<String,Object> inputMap = new Map<String,Object>();
        Map<String,Object> outMap = new Map<String,Object>();
        Map<String,Object> options = new Map<String,Object>();  
        User usr1  = [SELECT Id from User where LastName =: NAME1 limit 1];
        Quote quot = [SELECT Id from Quote limit 1];
        list<QuoteLineItem> quli = [SELECT Id from QuoteLineItem limit 1];   
        system.runAs(usr1){
            inputMap.put(QUOTEID,quot.id);	
            String selectMedAccount = VALUE+quli[0].id+VALUE1;
            List<object> data = (List<Object>)(JSON.deserializeUntyped(selectMedAccount)); 
            inputMap.put(QLIDS, data);   
            ARV_AP17_RemoveQuotedRatesService rqrs = new ARV_AP17_RemoveQuotedRatesService();  
                   Boolean req=true;
            test.startTest();    
            rqrs.invokeMethod(METHOD, inputMap, outMap, options);      
            test.stopTest();
            System.assertEquals(true,req);   
        }
    } 
    /**************  
    Method name : exceptionTest
    Params     : NA
    Return Type : testmethod
    Description :  exceptionTest() method 
	*************/
    private static testmethod void exceptionTest(){
        User usr1  = [SELECT Id from User where LastName =: NAME1 limit 1];
        system.runAs(usr1){
            try{
                 Boolean req=false;
                 ARV_AP17_RemoveQuotedRatesService arv = new ARV_AP17_RemoveQuotedRatesService();
                 test.startTest();    
           		arv.invokeMethod(null, null, null, null); 
                test.stopTest();
                System.assertNotEquals(false,req);      
            }Catch(Exception e) {
                return;                                         
            }
        }
    }
}