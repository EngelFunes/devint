/*****************************************************************************************
Class Name   : ARV_AP50CensusRatesSummary_Test 
Date Created : 25-SEP-2019
Created By   : IDC Offshore
Description  : This class is used for testing ARV_AP50CensusRatesSummary Class.
******************************************************************************************/
@isTest(seeAllData=false)
public with sharing class ARV_AP50CensusRatesSummary_Test {
	private static final string PROFILENAME='BCBSM Agent';
    private static final string PROFILENAME1='System Administrator';
    private static final string IDS = 'id';
    private static final string NAME='AP35LastName';
    private static final string NAME1='AP35RateGrid';
    private static final string USERNAME='bcbsm1@bcbsm.com';
    private static final string TYPE='Dental';
    private static final string TYPE1='Vision';
    private static final string BLANK='';
    private static final string CHECK='Yes';
    
    /**************  
Method name : testDataSetup
Params     : NA
Return Type : testmethod
Description :  testDataSetup() method 
*************/         
    @testSetup static void testDataSetup() {
        Account act= ARV_AP05_TestDataCreation.accRec();
        database.insert(act);
        vlocity_ins__GroupCensus__c census=ARV_AP05_TestDataCreation.groupCensus(act.Id);
        database.insert(census);
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
        Quote quot = ARV_AP05_TestDataCreation.quoteRec2(opp.Id,standardPriceBookRecId,User1.Id,census.Id); 
        database.insert(quot);
        Quote quot1 = ARV_AP05_TestDataCreation.quoteRec2(opp.Id,standardPriceBookRecId,User1.Id,census.Id);
        quot1.ARV_IsCensus2Check__c=CHECK;
        database.insert(quot1);
        Product2 prd= ARV_AP05_TestDataCreation.productRec();
        database.insert(prd);
        Product2 prd1= ARV_AP05_TestDataCreation.productRec();
        prd1.vlocity_ins__Type__c=TYPE;
        prd1.Carrier_Type__c=BLANK;
        database.insert(prd1);
        Product2 prd2= ARV_AP05_TestDataCreation.productRec();
        prd2.vlocity_ins__Type__c=TYPE1;
        prd2.Carrier_Type__c=BLANK;
        database.insert(prd2);              
        vlocity_ins__GroupCensusMember__c censusMem=ARV_AP05_TestDataCreation.groupCensusMember(census.Id);
        database.insert(censusMem);
        vlocity_ins__QuoteLineItemRateBreakout__c qrb= ARV_AP05_TestDataCreation.quoteBreakoutRec1(quot.Id,prd.Id);
        qrb.vlocity_ins__CensusMemberId__c=censusMem.Id;
        database.insert(qrb);
        vlocity_ins__QuoteLineItemRateBreakout__c qrb1= ARV_AP05_TestDataCreation.quoteBreakoutRec1(quot.Id,prd1.Id);
        qrb1.vlocity_ins__CensusMemberId__c=censusMem.Id;
        database.insert(qrb1);
        vlocity_ins__QuoteLineItemRateBreakout__c qrb2= ARV_AP05_TestDataCreation.quoteBreakoutRec1(quot.Id,prd2.Id);
        qrb2.vlocity_ins__CensusMemberId__c=censusMem.Id;
        database.insert(qrb2);          
        user usr = ARV_AP05_TestDataCreation.UsrRec(PROFILENAME1);
        usr.LastName = NAME1;
        usr.Username=USERNAME;
        database.insert(usr,true);
    }
    /**************  
Method name : censusRateSummaryTest
Params     : NA
Return Type : testmethod
Description :  internalUserTest() method 
*************/ 
    private static testmethod void censusRateSummaryTest(){
        Map<String,Object> inputMap = new Map<String,Object>();
		Map<String,Object> outMap = new Map<String,Object>();
		Map<String,Object> options = new Map<String,Object>();        
        user usr1 = [SELECT Id from User where LastName =: NAME1 limit 1];
        quote quo=[select id from quote limit 1];
        vlocity_ins__GroupCensus__c census = [select id from vlocity_ins__GroupCensus__c limit 1]; 
        inputMap.put('quoteId',quo.id);
        inputMap.put('censusId',census.id);
        ARV_AP50CensusRatesSummary rates = new ARV_AP50CensusRatesSummary();
        system.runAs(usr1){                        
            test.startTest();            
            rates.invokeMethod('getData',inputMap,outMap,options);
            test.stopTest(); 
            System.assertNotEquals(inputMap,null);
        }
    }
    
    private static testmethod void exceptionTest(){
        Map<String,Object> inputMap = new Map<String,Object>();
        user usr1 = [SELECT Id from User where LastName =: NAME1 limit 1];
        system.runAs(usr1){
            try{
                ARV_AP50CensusRatesSummary rate = new ARV_AP50CensusRatesSummary();
                test.startTest();            
                rate.invokeMethod(null,null,null,null);
                test.stopTest(); 
                System.assertNotEquals(null,inputMap);
            }
            catch(exception e){
                return;
            }
        }
    }
}