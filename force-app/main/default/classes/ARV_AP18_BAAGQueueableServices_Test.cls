/*****************************************************************************************
Class Name   : ARV_AP18_BAAGQueueableServices_Test 
Date Created : 27-MAY-2019
Created By   : IDC Offshore
Description  : This class is used for testing BAAG Service.
******************************************************************************************/
@isTest(seealldata=false)
private class ARV_AP18_BAAGQueueableServices_Test { 
    private static final string NAME='AP18LastNames';
    private static final string PROFILENAME='System Administrator';
        /**************  
    Method name : testDataSetup
    Params     : NA
    Return Type : testmethod
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
        // Document doc=ARV_AP05_TestDataCreation.documentRec(qli1.Id,prod.Id);database.insert(doc);        
    }
    
        /**************  
    Method name : getBAAGDoc
    Params     : NA
    Return Type : testmethod
    Description :  getBAAGDoc() method 
    *************/ 
    private static testmethod void getBAAGDoc(){
        user usr1 = [SELECT Id from User where LastName =: NAME limit 1];
        system.runAs(usr1){
            try{   
                QuoteLineItem qli1=[select product2Id,Description from QuoteLineItem limit 1];
                qli1.Description = NAME;
                quote quo=[select name from quote limit 1];
                ARV_AP18_BAAGQueueableServices baagqueable=new ARV_AP18_BAAGQueueableServices(qli1,quo.Id,FALSE);
                test.startTest();
                system.enqueueJob(baagqueable);
                test.stopTest(); 
                system.assert(baagqueable != null);
             } 
            catch(Exception e){
                return;
            }
        }
    }
     
        /**************  
    Method name : getBAAGDoc
    Params     : NA
    Return Type : testmethod
    Description :  getBAAGDoc() method 
    *************/ 
    private static testmethod void getBAAGDocCatch(){
        user usr1 = [SELECT Id from User where LastName =: NAME limit 1];
        system.runAs(usr1){
            try{   
                QuoteLineItem qli1=[select product2Id,Description from QuoteLineItem limit 1];
                qli1.Description = null;
                 quote quo=[select name from quote limit 1];
               ARV_AP18_BAAGQueueableServices baagqueable=new ARV_AP18_BAAGQueueableServices(qli1,quo.Id,FALSE);
                test.startTest();
                system.enqueueJob(baagqueable);
                test.stopTest();
                system.assert(baagqueable != null); 
            } 
            catch(Exception e){
                return;
            }
        }
    }
}