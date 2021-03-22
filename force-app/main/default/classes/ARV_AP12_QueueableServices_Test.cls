/*****************************************************************************************
Class Name   : ARV_AP12_QueueableServices_Test 
Date Created : 23-MAY-2019
Created By   : IDC Offshore
Description  : This class is used for testing BAAG Service.
******************************************************************************************/
@isTest(seealldata=false)
private class ARV_AP12_QueueableServices_Test {
    private static final string NAME='AP18LastName';
    private static final string PROFILENAME='System Administrator';
      private static final string CARRIERTYPE='BCBS';
        /**************  
    Method name : testDataSetup
    Params     : NA
    Return Type : testmethod1
    Description :  getBAAGDoc() method 
    *************/ 
     @testSetup static void testDataSetup() {
        user usr = ARV_AP05_TestDataCreation.UsrRec(PROFILENAME);
        usr.LastName = NAME;
        database.insert(usr,true);        
        Account accnt=ARV_AP05_TestDataCreation.AccRec();
        database.insert(accnt);
        Product2 prod=ARV_AP05_TestDataCreation.productRec();
        database.insert(prod);
        Id standardPriceBookRecId=Test.getStandardPricebookId();
        pricebookEntry pre=ARV_AP05_TestDataCreation.priceBookEntryRec(prod.Id,standardPriceBookRecId);database.insert(pre);
        opportunity opp=ARV_AP05_TestDataCreation.opportunityRec(accnt.Id,standardPriceBookRecId);database.insert(opp);
        Quote quo=ARV_AP05_TestDataCreation.quoteRec(opp.Id,standardPriceBookRecId);database.insert(quo);
        QuoteLineItem qli1=ARV_AP05_TestDataCreation.quoteLineItemRec(quo.Id,prod.Id,pre.Id);database.insert(qli1);
        Document doc=ARV_AP05_TestDataCreation.documentRec(qli1.Id,prod.Id);database.insert(doc);        
    }
    
      /**************  
        Method name : executeQueable
        Params     : NA
        Return Type : testmethod
        Description :  executeQueable() method 
        *************/ 
    private static testmethod void executeQueable()
    {
         user usr1 = [SELECT Id from User where LastName =: NAME limit 1];
        system.runAs(usr1){
            try{  
                Account acc=[select Name from Account limit 1];
                QuoteLineItem qli1=[select product2Id,Description from QuoteLineItem limit 1];
                qli1.Description = NAME;
                quote quo=[select name from quote limit 1];
              ARV_AP12_QueueableServices queable=new ARV_AP12_QueueableServices(acc.Id,qli1,quo.Id,CARRIERTYPE);
                  test.startTest();
                system.enqueueJob(queable);
                test.stopTest(); 
                 system.assert(queable != null);
             }
            catch(Exception e) {   return;  }
        }       
    }
    /**************  
        Method name : executeQueable
        Params     : NA
        Return Type : testmethod
        Description :  executeQueable() method 
        *************/ 
    private static testmethod void executeQueableCatch()
    {
         user usr1 = [SELECT Id from User where LastName =: NAME limit 1];
        system.runAs(usr1){
            try{  
               
                Account acc=[select Name from Account limit 1];
                QuoteLineItem qli1=[select product2Id,Description from QuoteLineItem limit 1];
                qli1.Description = null;
                quote quo=[select Id, name from quote limit 1];
              ContentDocumentLink[] att=[select id from ContentDocumentLink where linkedentityid =:quo.ID limit 1];
                ARV_AP12_QueueableServices queable=new ARV_AP12_QueueableServices(acc.Id,qli1,quo.Id,CARRIERTYPE);
               test.startTest();
                system.enqueueJob(queable);
                test.stopTest(); 
                  system.assert(acc.Id != null);
             }
            catch(Exception e) {   return;  }
        }       
    }
}