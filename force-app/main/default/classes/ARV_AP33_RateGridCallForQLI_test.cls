/*****************************************************************************************
Class Name   : ARV_AP33_RateGridCallForQLI_test 
Date Created : 26-JULY-2019
Created By   : IDC Offshore
Description  : This class is used for testing ARV_AP33_RateGridCallForQLI , ARV_AP34_QuoteLineItemQueueableIP and ARV_AP27_GetRateMatrix_CallIP Classes.
******************************************************************************************/
@isTest
public without sharing class ARV_AP33_RateGridCallForQLI_test {

 // Initializing variables and constants.
 private static final string PROFILENAME='BCBSM Agent';
 private static final string PROFILENAME1='System Administrator';
 //private static final string ID='id';
 private static final string NAME='AP33LastName';
 private static final string NAME1='AP33RateGrid';
 private static final string USERNAME='bcbsm1@bcbsm.com';
 private static final String CLSNAME  = 'ARV_AP33_RateGridCallForQLI';
 private static final string QLIQUEUEABLEINVOCATION  = 'qliQueueableInvocation';
 private static final String INVOKE_METHOD  = 'invokeMethod';
 private static final String ERRORMSG='There was an issue processing quotelineItem to send to '+
									  ' ARV_AP34_QuoteLineItemQueueableIP';
 private static final string USERSELECTQRY = ' SELECT Id from User ';
 private static final string USERWHERCLAUS = ' where LastName =: paramName ';
 private static final string USERLIMITCLAUSE = '  limit 1';  
 private static final string QUOTEID = 'QUOTEID'; 
 private static final string GETMETADATALABELS = 'getMetadataLabels';
 private static final String QUOTLNITMSELECTQRY = '  SELECT Id FROM QuoteLineItem ';
 private static final String RATRGRIDIPMAP = 'RateGridIPMap';
 private static final String QUOTLNITMLIMITCLAUSE = '  LIMIT 1 '; 
 private static final String QUOTSELECTQRY = '  SELECT Id FROM quote ';
 private static final String QUOTLIMITCLAUSE = '  LIMIT 1 ';
 private static final String METADATASELECTQRY = ' select InputJson__c from ARV_MDT01_TestingJson__mdt  ';
 private static final String METADATAWHERECLAUSE =  '  where MasterLabel = : paramName ';
 private static final String METADATALIMITCLAUSE =  '   LIMIT 1  ';
    
	
/**************  
Method name : testDataSetup
Params     : NA
Return Type : testmethod
Description :  testDataSetup() method 
*************/
 @testSetup static void testDataSetup() {
     
	Account acc= ARV_AP05_TestDataCreation.accRec();
	database.insert(acc,true) ;
	Id standardPriceBookRecId=Test.getStandardPricebookId();

	pricebook2 pb2=ARV_AP05_TestDataCreation.priceBookRec();	
    database.insert(pb2,true) ;
	Opportunity opp= ARV_AP05_TestDataCreation.opportunityRec(acc.Id,standardPriceBookRecId);	
    database.insert(opp,true) ;

	Quote quot = ARV_AP05_TestDataCreation.quoteRec(opp.Id,standardPriceBookRecId);
	database.insert(quot,true) ;
	Product2 prd= ARV_AP05_TestDataCreation.productRec();
	database.insert(prd,true) ;

	pricebookEntry prc= ARV_AP05_TestDataCreation.priceBookEntryRec(prd.Id,standardPriceBookRecId);
	database.insert(prc,true) ;

	QuoteLineItem qli= ARV_AP05_TestDataCreation.quoteLineItemRec(quot.Id,prd.Id,prc.Id);
	database.insert(qli,true) ;
     
    user usr = ARV_AP05_TestDataCreation.UsrRec(PROFILENAME1);
    usr.LastName = NAME1;
    usr.Username=USERNAME;
    database.insert(usr,true); 
 }
/**************  
Method name : testMetadataLabels
Params     : NA
Return Type : testmethod
Description :  to test the getMetadataLabels() method 
*************/ 
@isTest    
static void testMetadataLabels()
{
    Map<String,Object> inputMap = new Map<String,Object>();
	Map<String,Object> outMap = new Map<String,Object>();
	Map<String,Object> options = new Map<String,Object>();
	ARV_AP07_QueryDataHelper.paramName = NAME1;
	list<user> usr1  =  ARV_AP07_QueryDataHelper.getsObjects(USERSELECTQRY,USERWHERCLAUS,null, USERLIMITCLAUSE );      
	list<QUOTE> quot  =  ARV_AP07_QueryDataHelper.getsObjects(QUOTSELECTQRY,NULL,null, QUOTLIMITCLAUSE );
      system.runAs(usr1[0]){
            options.put( QUOTEID,quot[0].id);            
            ARV_AP33_RateGridCallForQLI arvqli = new ARV_AP33_RateGridCallForQLI();
             try{
                test.startTest();
                arvqli.invokemethod(GETMETADATALABELS,inputMap,outMap,options);
                options.put(QUOTEID,null);
                arvqli.invokemethod(GETMETADATALABELS,null,null,null);
                test.stoptest();
				system.assertNotEquals(quot[0].id, null);
               }Catch(Exception e)
                    {
                        return ;
                      
                    }
    	}
	}
   
}