/*****************************************************************************************
Class Name   : ARV_AP73_LaunchEnrollmentFromQuote_Test 
Date Created : 17-Jan-2020
Created By   : IDC Onshore
Description  :This is the class to fetch the contract with status other than Cancelled and Underwriting - Rejected.
******************************************************************************************/
@isTest
/*****************************************************************************************
Method Name   : ARV_AP73_LaunchEnrollmentFromQuote_Test 
Date Created : 17-Jan-2020
Created By   : IDC Onshore
Description  :This is the method to fetch the contract with status other than Cancelled and Underwriting - Rejected.
******************************************************************************************/
public without sharing class ARV_AP73_LaunchEnrollmentFromQuote_Test {
    private static final string PROFILENAME='System Administrator';
 private static final string NAME='AP61LastName';
    Private static final String TEST_VAL='Test';
    Private static final String CID='23';
    private static final string USERNAME='bcbsm1@bcbsm.com';
    private static final string CONTRACTWHERECLAUSE=' where AccountId=:paramId5 and status!=:paramName1 and status!=:paramName2';
private static final String QUOTEWHERECLAUSE=' where id=:paramId1';
private static final String LIMIT1=' limit 1';
private static final String QUOTEQRY='select id,accountid from quote';
private static final String CONTRACTQRY='select id from contract';
private static final String CANCELLED='Cancelled';
private static final String URURJ='Underwriting - Rejected';
    
       
/************************************************* 
Method name : testDataSetup1
Params     : NA
Return Type : testmethod
Description :  testDataSetup1() method to create object records 
**************************************************/  
@testSetup static void testDataSetup1() { 
    Account acc = new Account(name=TEST_VAL);
   acc.CID__c=CID;
    database.insert(acc);
    pricebook2  pbook= ARV_AP05_TestDataCreation.priceBookRec();
    database.insert(pbook);
    Contract con = ARV_AP05_TestDataCreation.createContractRec(acc.Id);
    database.insert(con);
    Opportunity oprtny= ARV_AP05_TestDataCreation.opportunityRec(acc.Id,pbook.Id);
    database.insert(oprtny);
    Quote quote= ARV_AP05_TestDataCreation.quoteRec(oprtny.Id,pbook.Id);
     database.insert(quote);
    user usr = ARV_AP05_TestDataCreation.UsrRec(PROFILENAME);
  usr.LastName = NAME;
  usr.Username=USERNAME;
  database.insert(usr,true);
    
   

}
/*****************************************************************************************
Method Name   : getContractrecord
Date Created : 17-Jan-2020
Created By   : IDC Onshore
Description  :This is the method to fetch the contract with status other than Cancelled and Underwriting - Rejected.
******************************************************************************************/
    public static testmethod void getContractrecord()
    {  //list<quote> quoterec=ARV_AP07_QueryDataHelper.getsObjects(QUOTEQRY,QUOTEWHERECLAUSE,null,LIMIT1);
    //Quote quote=quoterec.get(0);
    ARV_AP07_QueryDataHelper.paramName1=CANCELLED;
         ARV_AP07_QueryDataHelper.paramName2=URURJ;
         //ARV_AP07_QueryDataHelper.paramId5=quote.AccountId;
        // list<contract> conlist=ARV_AP07_QueryDataHelper.getsObjects(CONTRACTQRY,CONTRACTWHERECLAUSE,null,LIMIT1);
        //Contract con=conlist.get(0);
       Quote quo1=[select id,Tech_QuoteStatus__c,AccountId from quote limit 1];
        Id accId= quo1.AccountId;
        //System.debug('accId::::'+accId);
        Contract con=[select id from contract where  AccountId=:accId and status!='cancelled' limit 1];
        //System.debug('retreived contract:::'+con);
        user usr1  = [SELECT Id from User where LastName =: NAME limit 1];
        system.runAs(usr1){  
            test.startTest(); 
        	ARV_AP73_LaunchEnrollmentFromQuote.getContracts(quo1.id);
            ARV_AP73_LaunchEnrollmentFromQuote.disabledGWC(quo1.id);
            ARV_AP73_LaunchEnrollmentFromQuote.altQSGQuoteCondition(quo1.id);
            test.stopTest();
            System.assertNotEquals(null,con.id);   
        }
    }
}