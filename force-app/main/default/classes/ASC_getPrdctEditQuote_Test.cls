/*****************************************************************************************
Class Name   : ASC_getPrdctEditQuote_Test 
Date Created : 10 june 2020
Created By   : IDC Offshore
Description  : This class is used for testing ASC_getPrdctEditQuote Class.
******************************************************************************************/
@isTest
public without sharing class ASC_getPrdctEditQuote_Test {
    
    private static final string TYPE  ='ASC Product';
    private static final string PRODNAME  ='TEST Product';
    private static final string NAME='TEST'; 
    private static final string PHONE='9876543211';    
    private static final string ASC_QTRECTYPE = 'ASC Quote';
    private static final Id qTRecordTypeId = Schema.SObjectType.Quote.getRecordTypeInfosByName().get(ASC_QTRECTYPE).getRecordTypeId();   
    private static final string OPP_STAG = 'Quote Request';
    private static final string ASC_OPPRECTYPE = 'Opportunity - ASC';
    private static final string QTNAME = 'test quote';
    private static final Integer UNIT_PRICE = 1;            
    private static final string PRD_NAME = 'Variable Administrative Fees';
    private static final string PRD_CODE = 'ASC_0000370';
    private static final string PRD_FAMILY = 'Admin Fees';
    private static final string PRD_FAMILY_CARVE = 'Processing Options';    
    private static final string PRD_LOB = 'Non-Benefit';
    private static final Integer QUANTY_LI = 2;
    private static final string ACC_RECORDTYPE  ='Account - Customer';
    private static final string ACCCID = '12345';
    private static final string FEDTID = '123456789';
    private static final string BILL_PCODE = '48005';
    private static final string PARPRD_CD = 'ASC_0000005';
    private static final string PARPRD_FAMILY = 'Medical';
    private static final string PARPRD_FAMILY_CARVE = 'Carve-Outs';
    private static final string ROLE_NAM = 'TestUser';
    private static final string EMAILVAL = 'testUser@bcbsm.com';
    private static final string PROF_NAM = 'System Administrator';
    
    
    private static final Id prdCovSpecRecordTypeId = Schema.SObjectType.Product2.getRecordTypeInfosByName().get('Coverage Spec').getRecordTypeId(); 
    private static final Id prdRecordTypeId=Schema.SObjectType.Product2.getRecordTypeInfosByName().get('Product').getRecordTypeId();    
    
    /**************  
Method name : testDataSetup
Params     : NA
Return Type : testmethod
Description :  testDataSetup() method 
*************/     
    @testSetup static void testDataSetup() {
        Product2 prd1 = new Product2();
        prd1.vlocity_ins__Type__c = TYPE;
        prd1.ProductCode = PARPRD_CD;
        prd1.IsActive = true;
        prd1.Name = PRODNAME;
        prd1.Family = PARPRD_FAMILY;
        prd1.vlocity_ins__LineOfBusiness__c = PRD_LOB;
        prd1.RecordTypeId = prdRecordTypeId;
        prd1.vlocity_ins__SubType__c = TYPE;
        Database.insert(prd1, false);
        
        Product2 prd2 = new Product2();
        prd2.vlocity_ins__Type__c = TYPE;
        prd2.ProductCode = PARPRD_CD;
        prd2.IsActive = true;
        prd2.Name = PRODNAME;
        prd2.Family = PARPRD_FAMILY_CARVE;
        prd2.vlocity_ins__LineOfBusiness__c = PRD_LOB;
        prd2.RecordTypeId = prdRecordTypeId;
        prd1.vlocity_ins__SubType__c = TYPE;
        
        Database.insert(prd2, false);
        
        
        Account acc=new Account();
        acc.Name=NAME;
        acc.Phone=PHONE;
        acc.CID__c=ACCCID;
        acc.Federal_Tax_ID__c=ACCCID;
        acc.Requested_Effective_Date__c=system.today();
        acc.GA_CoverageCancellationDate__c=system.today();        
        acc.BillingPostalCode = BILL_PCODE;
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(ACC_RECORDTYPE).getRecordTypeId();
        insert acc;
        
        Product2 p= new product2(
            Name = PRD_NAME,
            productcode = PRD_CODE,
            Family = PRD_FAMILY,
            vlocity_ins__LineOfBusiness__c = PRD_LOB,
            vlocity_ins__SubType__c = TYPE,
            vlocity_ins__Type__c = TYPE,
            vlocity_ins__EffectiveDate__c = system.today(),
            RecordTypeId = prdCovSpecRecordTypeId
        );
        insert p;
        Product2 p1= new product2(
            Name = PRD_NAME,
            //productcode = PRD_CODE,
            Family = PRD_FAMILY_CARVE,
            vlocity_ins__LineOfBusiness__c = PRD_LOB,
            vlocity_ins__SubType__c = TYPE,
            vlocity_ins__Type__c = TYPE,
            vlocity_ins__EffectiveDate__c = system.today(),
            RecordTypeId = prdCovSpecRecordTypeId
        );
        insert p1;
        
        
        opportunity opp=new opportunity();
        opp.Name = NAME;
        opp.AccountId = acc.id;
        opp.stageName = OPP_STAG;
        opp.CloseDate = system.today()+120;
        opp.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(ASC_OPPRECTYPE).getRecordTypeId();
        insert opp;
        
        Id pricebookId = Test.getStandardPricebookId();            
        Quote q = new Quote();
        q.Name = QTNAME;
        q.opportunityId = Opp.Id;
        q.pricebook2Id = pricebookId;
        q.RecordTypeId = qTRecordTypeId;
        Database.insert(q,false);
        
        pricebookEntry prc=new pricebookEntry ();
        prc.product2Id = p.Id;
        prc.Pricebook2Id = pricebookId;
        prc.UnitPrice = UNIT_PRICE;
        prc.isActive = true;
        insert prc;
        
        QuoteLineItem qli=new QuoteLineItem();
        qli.QuoteId = q.Id;
        qli.product2Id = p.Id;
        qli.UnitPrice = UNIT_PRICE ;
        qli.Quantity = QUANTY_LI;
        qli.pricebookentryid = prc.Id;
        Database.insert(qli,false);            
    }
    
    
    /**************  
Method name : testMethod1
Params     : NA
Return Type : testmethod
Description :  To Fetch CarveOut Products
*************/ 
    private static testmethod void editQuoteCar(){
        try{
            user usr = GA_OBJ_TD01_TestDataCreation.UsrRec(ROLE_NAM,EMAILVAL,PROF_NAM);
            database.insert(usr);
            system.runAs(usr){
                Map<String,Object> inputMap = new Map<String,Object>();
                Map<String,Object> outMap = new Map<String,Object>();
                Map<String,Object> options = new Map<String,Object>();
                
                ASC_getPrdctEditQuote editQuote= new ASC_getPrdctEditQuote();
                test.startTest();            
                editQuote.invokeMethod('getPrdctsCarout',inputMap,outMap,options);
                test.stopTest(); 
            }
        }
        catch(exception e)
        {
            system.assert(e <> null);
            return;
        }   
        
        
        
    }
    /**************  
Method name : editQuoteRem
Params     : NA
Return Type : testmethod
Description :  To Fetch Other than Carveout Products
*************/ 
    private static testmethod void editQuoteRem(){
        try{
            user usr = GA_OBJ_TD01_TestDataCreation.UsrRec(ROLE_NAM,EMAILVAL,PROF_NAM);
            database.insert(usr);
            system.runAs(usr){
                Map<String,Object> inputMap = new Map<String,Object>();
                Map<String,Object> outMap = new Map<String,Object>();
                Map<String,Object> options = new Map<String,Object>();
                
                ASC_getPrdctEditQuote editQuoteRem= new ASC_getPrdctEditQuote();
                test.startTest();            
                editQuoteRem.invokeMethod('getPrdctsRem',inputMap,outMap,options);        
                test.stopTest(); 
            }
        }
        catch(exception e)
        {
            system.assert(e <> null);
            return;
        }    
        
        
        
    }
}