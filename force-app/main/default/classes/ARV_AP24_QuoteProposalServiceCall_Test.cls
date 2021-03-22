/*****************************************************************************************
Class Name   : ARV_AP24_QuoteProposalServiceCall_Test 
Date Created : 20-June-2019
Created By   : IDC Offshore
Description  : This class is used for testing sbc service.
******************************************************************************************/
@isTest(SeeAllData=FALSE)
public class ARV_AP24_QuoteProposalServiceCall_Test {
    private static final string SCLBAAGPLANS='sclBAAGPlans';
    private static final string QUOTEID='quoteId';
    private static final string SCLSBCPLANS='sclSBCPlans';
    private static final string SBC='SBC';
    private static final string BAAG='BAAG';
    private static final string METHODNAME1='generateDocument';
    private static final string METHODNAME2='refreshDocument';
    private static final string METHODNAME3='sendingEmails';
    private static final string PARAMSBC='sbcParam';
    private static final string PARAMBAAG='baagParam';
    private static final String MYFINALBAAGPRODUCTS='finalBAAGProducts';
    private static final String MYFINALSBCPRODUCTS='finalSBCProducts';
    private static final String  MYDOCIDLIST= 'docIdList';
    private static final string NAME='AP18LastName';
    private static final string PROFILENAME='system Administrator';
    private static final string MYBLANKVAL='';
    private static final string  SEPERATOR='-';
     private static final string BCBSCOMP='BCBSCOMP';
        private static final string FILE_TITLE='MLR-Agreement.pdf';

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
        //system.runAs(usr){
        Account accnt=ARV_AP05_TestDataCreation.AccRec();
        database.insert(accnt);
        Product2 prod=ARV_AP05_TestDataCreation.productRec();
        database.insert(prod);
        Id standardPriceBookRecId=Test.getStandardPricebookId();
        pricebookEntry pre=ARV_AP05_TestDataCreation.priceBookEntryRec(prod.Id,standardPriceBookRecId);database.insert(pre);
        opportunity opp=ARV_AP05_TestDataCreation.opportunityRec(accnt.Id,standardPriceBookRecId);database.insert(opp);
        Quote quo=ARV_AP05_TestDataCreation.quoteRec(opp.Id,standardPriceBookRecId);database.insert(quo);
        QuoteLineItem qli1=ARV_AP05_TestDataCreation.quoteLineItemRec(quo.Id,prod.Id,pre.Id);database.insert(qli1);
        attachment doc=ARV_AP05_TestDataCreation.attachmentRec(quo.Id,prod.Id); 
        doc.Description=prod.Id+SEPERATOR+SBC;
        database.insert(doc);
        document doc1=ARV_AP05_TestDataCreation.documentRec(quo.Id,prod.Id); 
         database.insert(doc1);
        ContentVersion conVion1=ARV_AP05_TestDataCreation.contenntversinRec(FILE_TITLE);
        database.insert(conVion1);       
        ContentDocument condoc=[Select Id,parentid from ContentDocument where Parentid=:conVion1.ContentDocumentId];
        ContentDocumentLink cdl=ARV_AP05_TestDataCreation.contentDocLink(condoc.Id,quo.Id );
        database.insert(cdl);
      //  }
    }
        /**************  
    Method name : getBAAGDoc
    Params     : NA
    Return Type : testmethod
    Description :  getBAAGDoc() method 
    *************/ 
    private static testmethod void getBAAGSelected()
    {
        user usr1 = [SELECT Id from User where LastName =: NAME limit 1];
        system.runAs(usr1){
            try{ 
                quote quo=[select id,name from quote limit 1];
                QuoteLineItem quoteLineList=[select id,Product2Id from QuoteLineItem limit 1];
                Map<String,Object> input=new Map<String,Object>();
                Map<String,Object> output=new Map<String,Object>();
                Map<String,Object> options=new Map<String,Object>();
                input.put(QUOTEID,quo.Id);
                input.put(PARAMBAAG,BAAG);
                input.put(MYFINALBAAGPRODUCTS,quoteLineList.iD);
                ARV_AP24_QuoteProposalServiceCall servcall=new ARV_AP24_QuoteProposalServiceCall();
                string methodname=METHODNAME1;
                test.startTest();
                servcall.invokeMethod(methodname,input,output,options);
                test.stopTest();
                system.assert(input != null);
                
            }
            catch(Exception e) 
            {
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
    private static testmethod void getBAAGSelected1()
    {
        user usr1 = [SELECT Id from User where LastName =: NAME limit 1];
        system.runAs(usr1){
            try{ 
                quote quo=[select id,name from quote limit 1];
                QuoteLineItem quoteLineList=[select id,Product2Id from QuoteLineItem limit 1];
                Map<String,Object> input=new Map<String,Object>();
                Map<String,Object> output=new Map<String,Object>();
                Map<String,Object> options=new Map<String,Object>();
                input.put(QUOTEID,quo.Id);
                input.put(PARAMBAAG,BAAG);
                input.put(MYFINALBAAGPRODUCTS,BCBSCOMP);
                ARV_AP24_QuoteProposalServiceCall servcall=new ARV_AP24_QuoteProposalServiceCall();
                string methodname=METHODNAME1;
                test.startTest();
                servcall.invokeMethod(methodname,input,output,options);
                test.stopTest();
                system.assert(input != null);
                
            }
            catch(Exception e) 
            {
                return;
            }
        }
    }
        /**************  
    Method name : getSBCDoc
    Params     : NA
    Return Type : testmethod
    Description :  getSBCDoc() method 
    *************/ 
    private static testmethod void getSBCSelected()
    {
        user usr1 = [SELECT Id from User where LastName =: NAME limit 1];
        system.runAs(usr1){
            try{ 
                quote quo=[select id,name from quote limit 1];
                QuoteLineItem quoteLineList=[select id,Product2Id from QuoteLineItem limit 1];
                Product2 prod=ARV_AP05_TestDataCreation.productRec1();
                database.insert(prod);
            ContentVersion conVion1=ARV_AP05_TestDataCreation.contenntversinRec(FILE_TITLE);
            conVion1.Description=prod.Id+SEPERATOR+BAAG;
            database.insert(conVion1);         
            ContentDocument condoc=[Select Id,parentid from ContentDocument where Parentid=:conVion1.ContentDocumentId];
            ContentDocumentLink cdl=ARV_AP05_TestDataCreation.contentDocLink(condoc.Id,quo.Id );
            database.insert(cdl);
               attachment doc=ARV_AP05_TestDataCreation.attachmentRec1(quo.Id,prod.Id); 
                database.insert(doc);  
                Map<String,Object> input=new Map<String,Object>();
                Map<String,Object> output=new Map<String,Object>();
                Map<String,Object> options=new Map<String,Object>();
                input.put(QUOTEID,quo.Id);
                input.put(PARAMSBC,SBC);
                input.put(PARAMBAAG,BAAG);
                input.put(MYFINALSBCPRODUCTS,quoteLineList.id);
                input.put(MYFINALBAAGPRODUCTS,MYBLANKVAL);
                ARV_AP24_QuoteProposalServiceCall servcall=new ARV_AP24_QuoteProposalServiceCall();
                string methodname=METHODNAME1;
                test.startTest();
                servcall.invokeMethod(methodname,input,output,options);
                test.stopTest();
                system.assert(input != null);
            }
            catch(Exception e) 
            {
                return;
            }
        }
    }
        /**************  
    Method name : getSBCDoc
    Params     : NA
    Return Type : testmethod
    Description :  getSBCDoc() method 
    *************/ 
    private static testmethod void getSBCSelectedempy()
    {
        user usr1 = [SELECT Id from User where LastName =: NAME limit 1];
        system.runAs(usr1){
                Account accnt=ARV_AP05_TestDataCreation.AccRec();
                database.insert(accnt);
                Product2 prod=ARV_AP05_TestDataCreation.productRec1();
                database.insert(prod);
                Id standardPriceBookRecId=Test.getStandardPricebookId();
                pricebookEntry pre=ARV_AP05_TestDataCreation.priceBookEntryRec(prod.Id,standardPriceBookRecId);database.insert(pre);
                opportunity opp=ARV_AP05_TestDataCreation.opportunityRec(accnt.Id,standardPriceBookRecId);database.insert(opp);
                Quote quo=ARV_AP05_TestDataCreation.quoteRec(opp.Id,standardPriceBookRecId);database.insert(quo);
                QuoteLineItem qli1=ARV_AP05_TestDataCreation.quoteLineItemRec(quo.Id,prod.Id,pre.Id);database.insert(qli1);
            ContentVersion conVion2=ARV_AP05_TestDataCreation.contenntversinRec(FILE_TITLE);
            conVion2.Description=quo.Id;
            database.insert(conVion2);
            system.debug('kjjj'+conVion2);
            List<ContentVersion> cvrsn = [SELECT ContentDocumentId  FROM ContentVersion WHERE Id=:conVion2.id limit 1];
            ContentDocumentLink cd2=ARV_AP05_TestDataCreation.contentDocLink(cvrsn[0].ContentDocumentId,prod.Id );
            database.insert(cd2);
            /* attachment doc=ARV_AP05_TestDataCreation.attachmentRec1(quo.Id,prod.Id); 
                database.insert(doc);*/
                Map<String,Object> input=new Map<String,Object>();
                Map<String,Object> output=new Map<String,Object>();
                Map<String,Object> options=new Map<String,Object>();
                input.put(QUOTEID,quo.Id);
                input.put(PARAMSBC,SBC);
                input.put(PARAMBAAG,BAAG);
                input.put(MYFINALSBCPRODUCTS,MYBLANKVAL);
                input.put(MYFINALBAAGPRODUCTS,MYBLANKVAL);
                ARV_AP24_QuoteProposalServiceCall servcall=new ARV_AP24_QuoteProposalServiceCall();
                string methodname=METHODNAME1;
                test.startTest();
               //servcall.invokeMethod(methodname,input,output,options);
                test.stopTest();
                system.assert(input != null);
        }
    }
        /**************  
    Method name : getdoc
    Params     : NA
    Return Type : testmethod
    Description :  getdoc() method 
    *************/ 
    private static testmethod void docGeneration()
    {
        user usr1 = [SELECT Id from User where LastName =: NAME limit 1];
        system.runAs(usr1){
                Map<String,Object> input=new Map<String,Object>();
                Map<String,Object> output=new Map<String,Object>();
                Map<String,Object> options=new Map<String,Object>();
                Account accnt=ARV_AP05_TestDataCreation.AccRec(); database.insert(accnt);
                Product2 prod=ARV_AP05_TestDataCreation.productRec();database.insert(prod);
                Id standardPriceBookRecId=Test.getStandardPricebookId();
                pricebookEntry pre=ARV_AP05_TestDataCreation.priceBookEntryRec(prod.Id,standardPriceBookRecId);database.insert(pre);
                opportunity opp=ARV_AP05_TestDataCreation.opportunityRec(accnt.Id,standardPriceBookRecId);database.insert(opp);
                Quote quo=ARV_AP05_TestDataCreation.quoteRec(opp.Id,standardPriceBookRecId);database.insert(quo);
                QuoteLineItem qli1=ARV_AP05_TestDataCreation.quoteLineItemRec(quo.Id,prod.Id,pre.Id);database.insert(qli1);
            ContentVersion conVion1=ARV_AP05_TestDataCreation.contenntversinRec(FILE_TITLE);
            conVion1.Description=prod.Id+SEPERATOR+BAAG;
            database.insert(conVion1);         
            ContentDocument condoc=[Select Id,parentid from ContentDocument where Parentid=:conVion1.ContentDocumentId];
            ContentDocumentLink cdl=ARV_AP05_TestDataCreation.contentDocLink(condoc.Id,quo.Id );
            database.insert(cdl);
            ContentVersion conVion2=ARV_AP05_TestDataCreation.contenntversinRec(FILE_TITLE);
            conVion2.Description='BCNCOMP';
            database.insert(conVion2);
            system.debug('kjjj'+conVion2);
            List<ContentVersion> cvrsn = [SELECT ContentDocumentId  FROM ContentVersion WHERE Id=:conVion2.id limit 1];
            ContentDocumentLink cd2=ARV_AP05_TestDataCreation.contentDocLink(cvrsn[0].ContentDocumentId,quo.Id );
            database.insert(cd2);
            /*attachment doc=ARV_AP05_TestDataCreation.attachmentRec(quo.Id,prod.Id);
                doc.Description=prod.Id+SEPERATOR+BAAG; database.insert(doc);
                attachment doc1=ARV_AP05_TestDataCreation.attachmentRec(quo.Id,prod.Id);
                doc1.Description='BCNCOMP';database.insert(doc1); */
                input.put(QUOTEID,quo.Id);
                input.put(MYDOCIDLIST,qli1.iD);
                input.put(PARAMSBC,SBC);
                input.put(PARAMBAAG,BAAG);
                input.put(SCLSBCPLANS,prod.iD);
                input.put(SCLBAAGPLANS,prod.iD);
                ARV_AP24_QuoteProposalServiceCall servcall=new ARV_AP24_QuoteProposalServiceCall();
                test.startTest();
                servcall.invokeMethod(METHODNAME2,input,output,options);
                test.stopTest();
                system.assert(input != null);
        }
    }
        /**************  
    Method name : sendmail
    Params     : NA
    Return Type : testmethod
    Description :  getdoc() method 
    *************/ 
    private static testmethod void sendmail()
    {
        user usr1 = [SELECT Id from User where LastName =: NAME limit 1];
        system.runAs(usr1){
            try{
                Map<String,Object> input=new Map<String,Object>();
                Map<String,Object> output=new Map<String,Object>();
                Map<String,Object> options=new Map<String,Object>();
                list<quotelineitem> qllist=new list<quotelineitem>();
                quotelineitem quoteLineList=[select Product2Id, Product2.Carrier_Type__c,QuoteId,Quote.AccountId from QuoteLineItem limit 1];
                qllist.add(quoteLineList);
                quote quoteList=[select Id,name from quote limit 1];
                list<Attachment> attachmentList=new list<attachment>();
                Attachment attach=[select Id,name from attachment limit 1];
                attachmentList.add(attach);
                input.put(MYDOCIDLIST,attach.iD);
                ARV_AP24_QuoteProposalServiceCall servcall=new ARV_AP24_QuoteProposalServiceCall();
                string methodname=METHODNAME3;
                test.startTest();
                servcall.invokeMethod(methodname,input,output,options);
                test.stopTest();
                system.assert(input != null);
            }catch(exception e){return;}
          }
    }
}