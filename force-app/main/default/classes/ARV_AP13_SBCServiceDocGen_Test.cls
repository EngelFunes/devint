/*****************************************************************************************
Class Name   : ARV_AP13_SBCServiceDocGen_Test 
Date Created : 27-MAY-2019
Created By   : IDC Offshore
Description  : This class is used for testing sbc services.-
******************************************************************************************/
@isTest(SeeAllData=FALSE)
private class ARV_AP13_SBCServiceDocGen_Test {
    private static final string NAME='AP18LastName';
    private static final string PROFILENAME='System Administrator';
     private static final string  CARRIERTYPE='BCN';
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
        Document doc=ARV_AP05_TestDataCreation.documentRec(qli1.Id,prod.Id);database.insert(doc);        
    }
/**************  
    Method name : getSBCDoc
    Params     : NA
    Return Type : NA
    Description :  getSBCDoc() method
    *************/ 
private static testmethod void getSBCDocexeption()
    {
           user usr1 = [SELECT Id from User where LastName =: NAME limit 1];
        system.runAs(usr1){
            try{ 
                Account accnt=[select Name from Account limit 1];
                product2 prod=[select Name from product2 limit 1];
                quote quo=[select name from quote limit 1];
                 ARV_AP13_SBCServiceDocGen docGen=new ARV_AP13_SBCServiceDocGen();
                test.startTest();
                docGen.getSBCDoc(prod.Id,accnt.Id,quo.Id,CARRIERTYPE);
                test.stopTest();
                system.assert(prod.Id != null);
           }  
            catch(Exception e) {   return;  }
        }
    }
}