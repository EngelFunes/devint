/*****************************************************************************************
Class Name   : ARV_AP09_BAAGServiceDocGen_Test 
Date Created : 03-MAY-2019
Created By   : IDC Offshore
Description  : This class is used for testing BAAG Services.....
******************************************************************************************/
@isTest(seealldata=false)
private class ARV_AP09_BAAGServiceDocGen_Test {
        private static final string NAME='AP18LastName';
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
        Document doc=ARV_AP05_TestDataCreation.documentRec(qli1.Id,prod.Id);database.insert(doc);        
    }
      /**************  
    Method name : getBAAGDoc
    Params     : NA
    Return Type : testmethod
    Description :  getBAAGDoc() method 
    *************/ 
    private static testmethod void getBAAGDoc()
    {
      user usr1 = [SELECT Id from User where LastName =: NAME limit 1];
        system.runAs(usr1){
            try{ 
              ARV_AP09_BAAGServiceDocGen baag=new ARV_AP09_BAAGServiceDocGen();
              Product2 prod=[Select Name from product2 limit 1];
                 quote quo=[select name from quote limit 1];
              String createBenefDocResp= '--MIMEBoundaryurn_uuid_BF8ECB5A24513C815B1518414105872'
                    +'Content-Type: application/json' +'Content-Transfer-Encoding: binary'
                    +'Content-ID: <0.urn:uuid:BF8ECB5A24513C815B1518414105873@apache.org>'
                    +'{ "CreateBenefitDocResponse":{ "RespHeaderArea":{ "VersionInfo":{ "ServiceVersion":"1.0", "SchemaVersion":"1.0.1" },'
                    +' "CreationDateTime":"2019-05-06T07:23:19.624-04:00", "MessageID":"BNFTMGMTJSON1.0-ddd5b172-c96f-4ed4-8844-857909940ddb", '
                   +'"Status":"SUCCESSFUL", "SystemMessage":[ { "Code":"S0000", "Description":"Successful completion.",'
                   +' "Source":"CreateBenefitDocument" } ] }, '
                   +'"PayloadArea":{ "Attribute":[ { "Name":"DocID", "Value":"000007289234" }, { "Name":"DocType", "Value":"PDF" } ] } } }  '
                    +'--MIMEBoundaryurn_uuid_BF8ECB5A24513C815B1518414105872'
                    +'Content-Type: */*' +'Content-Transfer-Encoding: binary'
                    +'Content-ID: <attachment=urn:uuid:BF8ECB5A24513C815B1518414105870>'  +'%PDF-1.5'  +'%ÈÈÈÈÈÈÈ'
                    +'%%EOF' +'--MIMEBoundaryurn_uuid_7110B31FA3DF8794C61518605185718--';
                 
                Test.setMock(HttpCalloutMock.class, new ARV_AP06_CalloutMockResp(createBenefDocResp));
                   test.startTest();
                baag.getBAAGDoc(prod.Id,quo.Id,FALSE);
                test.stopTest();
                system.assert(CreateBenefDocResp != null);
             }
            catch(Exception e) 
            {
                return;
            }
            
        }
    }
     /**************  
    Method name : getBAAGDocMethodException
    Params     : NA
    Return Type : testmethod
    Description :  getBAAGDocMethodException() method 
    *************/ 
    private static testmethod void getBAAGDocMethodException()
    {
         user usr1 = [SELECT Id from User where LastName =: NAME limit 1];
        system.runAs(usr1){
            try
             {
               ARV_AP09_BAAGServiceDocGen baag=new ARV_AP09_BAAGServiceDocGen();
             
              String createBenefDocResp= '--MIMEBoundaryurn_uuid_BF8ECB5A24513C815B1518414105872'
                    +'Content-Type: application/json' +'Content-Transfer-Encoding: binary'
                    +'Content-ID: <0.urn:uuid:BF8ECB5A24513C815B1518414105873@apache.org>'
                    +'{ "CreateBenefitDocResponse":{ "RespHeaderArea":{ "VersionInfo":{ "ServiceVersion":"1.0", "SchemaVersion":"1.0.1" },'
                  +' "CreationDateTime":"2019-05-06T07:23:19.624-04:00", "MessageID":"BNFTMGMTJSON1.0-ddd5b172-c96f-4ed4-8844-857909940ddb", '
                   +'"Status":"SUCCESSFUL", "SystemMessage":[ { "Code":"S0000", "Description":"Successful completion.", '
                  +'"Source":"CreateBenefitDocument" } ] }, '
                  +'"PayloadArea":{ "Attribute":[ { "Name":"DocID", "Value":"000007289234" }, { "Name":"DocType", "Value":"PDF" } ] } } }  '
                    +'--MIMEBoundaryurn_uuid_BF8ECB5A24513C815B1518414105872'
                    +'Content-Type: */*' +'Content-Transfer-Encoding: binary'
                    +'Content-ID: <attachment=urn:uuid:BF8ECB5A24513C815B1518414105870>'  +'%PDF-1.5'  +'%ÈÈÈÈÈÈÈ'
                    +'%%EOF' +'--MIMEBoundaryurn_uuid_7110B31FA3DF8794C61518605185718--';
                  Test.setMock(HttpCalloutMock.class, new ARV_AP06_CalloutMockResp(createBenefDocResp));
                   test.startTest();
                baag.getBAAGDoc(Null,NULL,TRUE);
                test.stopTest();
                system.assert(CreateBenefDocResp != null);
             }
            catch(Exception e) 
            {
                return;
            }
            
        }
    }
    
}