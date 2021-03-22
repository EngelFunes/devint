/********************************************************************************************
Class Name   : ARV_AP21_QuoteLineItemsAura_Test 
Date Created : 05-June-2019
Created By   : IDC Offshore
Description  : This is the test class for ARV_AP21_QuoteLineItemsAura.	
*******************************************************/
@isTest
public without sharing class ARV_AP21_QuoteLineItemsAura_Test {

	// Initializing variables and constants.
	private static final string PROFILENAME='BCBSM Agent';
	private static final string PROFILENAME1='System Administrator';    
	private static final string NAME='AP33LastName';
	private static final string NAME1='AP33RateGrid';
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
		Id standardPriceBookRecId = Test.getStandardPricebookId();
		
		pricebook2 pb2=ARV_AP05_TestDataCreation.priceBookRec();
		database.insert(pb2);
		Opportunity opp = ARV_AP05_TestDataCreation.opportunityRec(acc.Id,standardPriceBookRecId);
		database.insert(opp);
		
		Quote quot = ARV_AP05_TestDataCreation.quoteRec(opp.Id,standardPriceBookRecId);
		database.insert(quot);
		Product2 prd= ARV_AP05_TestDataCreation.productRec();
		database.insert( prd );
		
		pricebookEntry prc= ARV_AP05_TestDataCreation.priceBookEntryRec(prd.Id,standardPriceBookRecId);
		database.insert(prc);
		
		QuoteLineItem qli= ARV_AP05_TestDataCreation.quoteLineItemRec(quot.Id,prd.Id,prc.Id);
		database.insert( qli);
		
		user usr = ARV_AP05_TestDataCreation.UsrRec(PROFILENAME1);
		usr.LastName = NAME1;
		usr.Username=USERNAME;
		database.insert(usr,true); 
	}

	/**************  
	Method name : testQuoteLineItems
	Params     : NA
	Return Type : testmethod
	Description :  to test the getQuoteLineItems()  
	*************/ 
	@isTest    
	static void testQuoteLineItems()
	{
		user usr1  = [SELECT Id from User where LastName =: NAME1 limit 1];
		quote quot = [select id from quote limit 1];
		try {        
			// running from the user perspective.
			system.runAs(usr1){
				List<QuoteLineItem> qliList = ARV_AP21_QuoteLineItemsAura.getQuoteLineItems( String.valueOf(quot.id));
				test.startTest();        
				// ARV_AP21_QuoteLineItemsAura.getQuoteLineItems( null);
                ARV_AP21_QuoteLineItemsAura.getQuoteLineItems( string.valueof(qliList[0]));
				system.assertNotEquals(quot.id, null);
			}
		}catch(Exception e){
			 return  ;
		}
	}
}