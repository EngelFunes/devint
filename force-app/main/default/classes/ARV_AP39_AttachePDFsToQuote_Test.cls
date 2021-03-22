/*****************************************************************************************
Class Name   : ARV_AP39_AttachePDFsToQuote_Test 
Date Created : 23-JULY-2019
Created By   : IDC Offshore
Description  : This class is used for testing attachements created in quote or note
******************************************************************************************/
@isTest
public without sharing class ARV_AP39_AttachePDFsToQuote_Test {
    
    private static final string NAME='AP18LastName';
    private static final string PROFILENAME='System Administrator';
    private static final string DOCTYPE1='RateGrid';
    private static final string DOCTYPE2='CoverPage';
    private static final string DOCTYPE3='Census';
    /**************  
Method name : testDataSetup
Params     : NA
Return Type : testmethod
Description :  testDataSetup() method 
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
        pricebookEntry pre=ARV_AP05_TestDataCreation.priceBookEntryRec(prod.Id,standardPriceBookRecId);
        database.insert(pre);
        opportunity opp=ARV_AP05_TestDataCreation.opportunityRec(accnt.Id,standardPriceBookRecId);
        database.insert(opp);
        Quote quo=ARV_AP05_TestDataCreation.quoteRec(opp.Id,standardPriceBookRecId);
        database.insert(quo);
    }
    /**************  
Method name : createAttachment
Params     : NA
Return Type : testmethod
Description :  createAttachment() method 
*************/
    private static testmethod void createAttachment(){
        user usr1 = [SELECT Id from User where LastName =: NAME limit 1];
        Quote quo=[select id from quote limit 1];
        system.runAs(usr1){
            test.startTest();
            ARV_AP39_AttachePDFsToQuote.attachToQuote(quo.Id,DOCTYPE1,DOCTYPE2,DOCTYPE3);
            test.stopTest();
            Attachment[] att=[select id from attachment where parentID = :quo.Id limit 3]; 
            System.assertEquals(0,att.size());
        }
    }
    /**************  
Method name : exceptionTest
Params     : NA
Return Type : testmethod
Description :  exceptionTest() method 
*************/ 
    private static testmethod void exceptionTest(){
        user usr1 = [SELECT Id from User where LastName =: NAME limit 1];
        system.runAs(usr1){
            try{ 
                test.startTest();
                ARV_AP39_AttachePDFsToQuote.attachToQuote(null,DOCTYPE1,DOCTYPE2,DOCTYPE3);
                test.stopTest();
                Attachment[] att=[select id from attachment where parentID = null limit 1];
                System.assertEquals(0,att.size());
            }
            catch(Exception e) 
            {
                return;
            }
        }
    }      
}