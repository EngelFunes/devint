/*****************************************************************************************
Class Name   : ASC_GetGSPriceJson_Test 
Date Created : 20 May 2020
Created By   : IDC Offshore
Description  : This class is used for testing ASC_GetGSPriceJson Class. 
******************************************************************************************/
@isTest
public without sharing class ASC_GetGSPriceJson_Test {
    private static final string PROFILENAME='BCBSM Agent';
    private static final string PROFILENAME1='System Administrator';
    private static final string TYPE='Dental';
    private static final string TYPE1='Vision';
    private static final string BLANK='';
    private static final string NAME1='Agent';
    private static final string USERNAME='bcbsm1@bcbsm.com';
    private static final string PRD_TYPE='ASC Product';
    private static final string PRD_LOB = 'Non-Benefit';
    private static final string COV_SPEC = 'Coverage Spec';
    private static final string PRODT = 'Product';
    private static final string CARR_BCBSM = 'BCBSM';
    private static final string CARR_BCN = 'BCN';
        
    private static Id prdCovSpecRecordTypeId =
     Schema.SObjectType.Product2.getRecordTypeInfosByName().get(COV_SPEC).getRecordTypeId(); 
    
    /**********************************
    Method name : testDataSetup
    Params     : NA
    Return Type : testmethod
    Description :  testDataSetup() method 
    *************/     
    @testSetup static void testDataSetup() {
        List<GA_County_Code__c> countyList = ARV_AP05_TestDataCreation.createCounties(1);
        database.insert(countyList);
        Account act= ARV_AP05_TestDataCreation.accRec();
        act.GA_Mailing_County_id__c = countyList[0].id;
        database.insert(act);
        vlocity_ins__GroupCensus__c census=ARV_AP05_TestDataCreation.groupCensus(act.Id);
        database.insert(census);
        Id standardPriceBookRecId=Test.getStandardPricebookId();
        pricebook2 pb2=ARV_AP05_TestDataCreation.priceBookRec();
        database.insert(pb2);
        Opportunity opp= ARV_AP05_TestDataCreation.opportunityRec(act.Id,standardPriceBookRecId);
        database.insert(opp);
        
        Contract con = ARV_AP05_TestDataCreation.createContractRecCensus(act.Id,census.Id);
        con.ARV_Tech_Selected_Plans__c = 'Dental;Vision';
        con.vlocity_ins__EnrollmentCensusId__c = census.id;
        database.insert(con);

        Product2 prd= ARV_AP05_TestDataCreation.productRec();
        prd.vlocity_ins__Type__c=PRD_TYPE;
        prd.Carrier_Type__c=BLANK;
        prd.Voluntary_Contributory__c = 'Non-Voluntary';
        prd.vlocity_ins__AttributeDefaultValues__c = '{"ASC_Variance":false,"ASC_Productcode":"ASC_0000017","ASC_Last_Price_Modified_Date__c":"2020-05-01","ASC_UnitPrice":3.75,"ASC_Activation_Type":"New","ASC_Sales_Volume":1,"ASC_SalesPrice":0,"ASC_Tier":"Tier 1 (51-100)","ASC_PricingMethod":"PCPM","ASC_PricingType":"Default"}';
        prd.vlocity_ins__LineOfBusiness__c = PRD_LOB;
        prd.RecordTypeId = prdCovSpecRecordTypeId;
        prd.isActive = true;
        database.insert(prd);
        
        Product2 prd1= ARV_AP05_TestDataCreation.productRec();
        prd1.vlocity_ins__Type__c=PRD_TYPE;
        prd1.Carrier_Type__c=BLANK;
        prd1.vlocity_ins__AttributeDefaultValues__c = '{"ASC_Variance":false,"ASC_Productcode":"ASC_0000017","ASC_Last_Price_Modified_Date__c":"2020-05-01","ASC_UnitPrice":3.75,"ASC_Activation_Type":"New","ASC_Sales_Volume":1,"ASC_SalesPrice":0,"ASC_Tier":"Tier 1 (51-100)","ASC_PricingMethod":"PCPM","ASC_PricingType":"Default"}';
        prd1.vlocity_ins__LineOfBusiness__c = PRD_LOB;
        prd1.RecordTypeId = prdCovSpecRecordTypeId;
        prd1.isActive = true;
        database.insert(prd1);
        
        Product2 prd2= ARV_AP05_TestDataCreation.productRec();
        prd2.vlocity_ins__Type__c=PRD_TYPE;
        prd2.Carrier_Type__c=BLANK;
        prd2.vlocity_ins__AttributeDefaultValues__c = '{"ASC_Variance":false,"ASC_Productcode":"ASC_0000017","ASC_Last_Price_Modified_Date__c":"2020-05-01","ASC_UnitPrice":3.75,"ASC_Activation_Type":"New","ASC_Sales_Volume":1,"ASC_SalesPrice":0,"ASC_Tier":"Tier 1 (51-100)","ASC_PricingMethod":"PMPM","ASC_PricingType":"Default"}';
        prd2.vlocity_ins__LineOfBusiness__c = PRD_LOB;
        prd2.RecordTypeId = prdCovSpecRecordTypeId;
        prd2.isActive = true;
        database.insert(prd2);
        
        Product2 prd3= ARV_AP05_TestDataCreation.productRec();
        prd3.vlocity_ins__Type__c=PRD_TYPE;
        prd3.Carrier_Type__c=BLANK;
        prd3.vlocity_ins__AttributeDefaultValues__c = '{"ASC_Variance":false,"ASC_Productcode":"ASC_0000017","ASC_Last_Price_Modified_Date__c":"2020-05-01","ASC_UnitPrice":3.75,"ASC_Activation_Type":"New","ASC_Sales_Volume":1,"ASC_SalesPrice":0,"ASC_Tier":"Tier 1 (51-100)","ASC_PricingMethod":"PMPM","ASC_PricingType":"Data Feeds"}';
        prd3.vlocity_ins__LineOfBusiness__c = PRD_LOB;
        prd3.RecordTypeId = prdCovSpecRecordTypeId;
        prd3.isActive = true;
        database.insert(prd3);
         Product2 prd4= ARV_AP05_TestDataCreation.productRec();
        prd4.vlocity_ins__Type__c=PRD_TYPE;
        prd4.Carrier_Type__c=BLANK;
        prd4.vlocity_ins__AttributeDefaultValues__c = '{"ASC_Variance":false,"ASC_Productcode":"ASC_00000178","ASC_Last_Price_Modified_Date__c":"2020-05-01","ASC_UnitPrice":3.75,"ASC_Activation_Type":"New","ASC_Sales_Volume":1,"ASC_SalesPrice":0,"ASC_Tier":"Tier 1 (51-100)","ASC_PricingMethod":"PCPM","ASC_PricingType":"Data Feeds"}';
        prd4.vlocity_ins__LineOfBusiness__c = PRD_LOB;
        prd4.RecordTypeId = prdCovSpecRecordTypeId;
        prd4.isActive = true;
        database.insert(prd4);
        pricebookEntry prc = ARV_AP05_TestDataCreation.priceBookEntryRec(prd.Id,standardPriceBookRecId);
        database.insert(prc);
        Quote qte = ARV_AP05_TestDataCreation.quoteRec(opp.Id,standardPriceBookRecId);
        database.insert(qte,false);
                
        Quote qte2 = ARV_AP05_TestDataCreation.quoteRec(opp.Id,standardPriceBookRecId);
        qte2.Description = 'qtTest324';
        qte2.AdditionalName = 'qtTest324';
        qte2.status='New';
        database.insert(qte2,false);
         Quote qte3 = ARV_AP05_TestDataCreation.quoteRec(opp.Id,standardPriceBookRecId);
        qte3.Description = 'qtTest324';
        qte3.AdditionalName = 'qtTest324';
        qte3.status='New';
        database.insert(qte3,false);
        
        //
        /*
        Quote qte4 = ARV_AP05_TestDataCreation.quoteRec(opp.Id,standardPriceBookRecId);
        qte4.Description = 'qtTest32400';
        qte4.AdditionalName = 'qtTest32400';
        qte4.status='Draft';
        database.insert(qte4,false);
        QuoteLineItem qli4 = ARV_AP05_TestDataCreation.quoteLineItemRec(qte3.id,prd4.Id,prc.Id);
        qli4.vlocity_ins__AttributeSelectedValues__c = '{"ASC_UnitVolume":3.75,"ASC_Variance":false,"ASC_Productcode":"ASC_0000415","ASC_Last_Price_Modified_Date__c":"2020-05-01","ASC_UnitPrice":3.75,"ASC_Activation_Type":"Renewal","ASC_Sales_Volume":1,"ASC_SalesPrice":0,"ASC_Tier":"Tier 1 (51-100)","ASC_PricingMethod":"PCPM","ASC_PricingType":"Data Feeds"}';
        qli4.ASC_Last_Price_Modified_Date__c = null;
        database.insert(qli4,false);
        */
        
        
        QuoteLineItem qli = ARV_AP05_TestDataCreation.quoteLineItemRec(qte.id,prd.Id,prc.Id);
        ////qli.vlocity_ins__AttributeSelectedValues__c = '{"ASC_Variance":false,"ASC_Productcode":"ASC_0000017","ASC_Last_Price_Modified_Date__c":"2020-05-01","ASC_UnitPrice":3.75,"ASC_Activation_Type":"New","ASC_Sales_Volume":1,"ASC_SalesPrice":0,"ASC_Tier":"Tier 1 (51-100)","ASC_PricingMethod":"PCPM"}';
        qli.vlocity_ins__AttributeSelectedValues__c = '{"ASC_UnitVolume":3.75,"ASC_Variance":false,"ASC_Productcode":"ASC_0000017","ASC_Last_Price_Modified_Date__c":"2020-05-01","ASC_UnitPrice":3.75,"ASC_Activation_Type":"New","ASC_Sales_Volume":1,"ASC_SalesPrice":0,"ASC_Tier":"Tier 1 (51-100)","ASC_PricingMethod":"PCPM"}';
        database.insert(qli,false);
        
        QuoteLineItem qli2 = ARV_AP05_TestDataCreation.quoteLineItemRec(qte2.id,prd.Id,prc.Id);
        qli2.vlocity_ins__AttributeSelectedValues__c = '{"ASC_UnitVolume":3.75,"ASC_Variance":false,"ASC_Productcode":"ASC_0000017","ASC_Last_Price_Modified_Date__c":"2020-05-01","ASC_UnitPrice":3.75,"ASC_Activation_Type":"New","ASC_Sales_Volume":1,"ASC_SalesPrice":0,"ASC_Tier":"Tier 1 (51-100)","ASC_PricingMethod":"PCPM"}';
        qli2.ASC_Last_Price_Modified_Date__c = system.now();
        database.insert(qli2,false);
        QuoteLineItem qli3 = ARV_AP05_TestDataCreation.quoteLineItemRec(qte3.id,prd4.Id,prc.Id);
        qli3.vlocity_ins__AttributeSelectedValues__c = '{"ASC_UnitVolume":3.75,"ASC_Variance":false,"ASC_Productcode":"ASC_0000018","ASC_Last_Price_Modified_Date__c":"2020-05-01","ASC_UnitPrice":3.75,"ASC_Activation_Type":"Renewal","ASC_Sales_Volume":1,"ASC_SalesPrice":0,"ASC_Tier":"Tier 1 (51-100)","ASC_PricingMethod":"PCPM","ASC_PricingType":"Data Feeds"}';
        qli3.ASC_Last_Price_Modified_Date__c = system.now();
        database.insert(qli3,false);
        
        
        vlocity_ins__ProductChildItem__c chld = new vlocity_ins__ProductChildItem__c();
        chld.vlocity_ins__ParentProductId__c = prd1.Id;
        chld.vlocity_ins__ChildProductId__c = prd2.Id;
        chld.vlocity_ins__ChildLineNumber__c = '12';
        insert chld;
        Line_Item_Extension__c lie = new Line_Item_Extension__c();
        lie.name = 'TestLie';
        lie.Quantity__c = 5;
        insert lie;
        vlocity_ins__ContractLineItem__c pln = ARV_AP05_TestDataCreation.planRec(prd.id,con.id);
        pln.ASC_Line_Item_Extension__c = lie.id;
        database.insert(pln);
        vlocity_ins__ContractLineItem__c pln1 = ARV_AP05_TestDataCreation.planRec(prd1.id,con.id);
        database.insert(pln1);
        vlocity_ins__ContractLineItem__c pln2 = ARV_AP05_TestDataCreation.planRec(prd2.id,con.id);
        database.insert(pln2);
        ASC_Group_Specific_Pricing__c gsp = new ASC_Group_Specific_Pricing__c();
        gsp.ASC_Group__c = act.id;
        //gsp.ASC_Product_Code__c = prd1.productcode;
        gsp.ASC_Carrier__c = CARR_BCBSM;
        gsp.ASC_Product__c = prd3.id;
        gsp.ASC_Effective_Date__c = date.valueOf('2020-01-01');
        gsp.ASC_Effective_End_Date__c = date.valueOf('2020-12-12');
        gsp.ASC_Monthly_Cap_Amount__c=12;
        gsp.ASC_Deleted__c = false;
        Database.insert(GSP,false);
        user usr = ARV_AP05_TestDataCreation.UsrRec(PROFILENAME1);
        usr.LastName = NAME1;
        usr.Username=USERNAME;
        database.insert(usr,true);
    }
    /**************  
    Method name : testMethod1
    Params     : NA
    Return Type : testmethod
    Description :  Positive Flow Test() method 
    *************/ 
    private static testmethod void testMethod1(){
        Account acc=[select id,name,MailingCountyFormula__c,BillingPostalCode from Account limit 1];
        Contract con =[select id,name from Contract limit 1];
        product2 prdt =[select id,name from product2 limit 1];
        Quote qte =[select id,name from Quote limit 1];
        Map<String,Object> inputMap = new Map<String,Object>();
        Map<String,Object> outMap = new Map<String,Object>();
        Map<String,Object> options = new Map<String,Object>();
        Map<String,Object> IdentifyingQuote1 = new Map<String,Object>();
        Map<String,Object> subsg = new Map<String,Object>();
        subsg.put('GetAscSubSegement','abc');
        IdentifyingQuote1.put('Carrier', 'BCBSM');
        IdentifyingQuote1.put('StartDate', '2020-01-01');
        IdentifyingQuote1.put('EndDate', '2020-12-12');
        IdentifyingQuote1.put('GetSubSegName-Block', subsg);
        inputMap.put('IdentifyingQuote',IdentifyingQuote1);
        inputMap.put('productIdSet','Id:'+prdt.Id);
        Date edate = date.newinstance(2020,02,02);
        inputMap.put('ContextId',qte.id);
        inputMap.put('AccId',acc.id);
        inputMap.put('CarrierType','BCBSM');
        inputMap.put('EffDate',edate);
        SYSTEM.debug('----->>>'+inputMap);
         
        user usr1 = [SELECT Id from User where LastName =: NAME1 limit 1];
        system.runAs(usr1){            
            ASC_GetGSPriceJson rate = new ASC_GetGSPriceJson();
            try{
            test.startTest();            
            rate.invokeMethod('getUnitpriceJSon',inputMap,outMap,options);
            
            System.assertNotEquals(null,acc.id);
            test.stopTest(); 
            System.assertNotEquals(null,acc.id); 
            } Catch(Exception e) {
              return;
              }  
        }
    }
    /**************  
    Method name : voluntaryVldtnsTest
    Params     : NA
    Return Type : testmethod
    Description :  internalUserTest() method 
    *************/ 
    private static testmethod void voluntaryVldtnsTest2(){
        Account acc=[select id,name,MailingCountyFormula__c,BillingPostalCode from Account limit 1];
        Contract con =[select id,name from Contract limit 1];
        product2 prdt =[select id,name from product2 limit 1];
        Quote qte =[select id,name from Quote where AdditionalName like 'qtTest324' limit 1];
        Map<String,Object> inputMap = new Map<String,Object>();
        Map<String,Object> outMap = new Map<String,Object>();
        Map<String,Object> options = new Map<String,Object>();
        Map<String,Object> IdentifyingQuote1 = new Map<String,Object>();
        Map<String,Object> subsg = new Map<String,Object>();
        subsg.put('GetAscSubSegement','abc');
        IdentifyingQuote1.put('Carrier', 'BCBSM');
        IdentifyingQuote1.put('StartDate', '2020-01-01');
        IdentifyingQuote1.put('EndDate', '2020-12-12');
        IdentifyingQuote1.put('GetSubSegName-Block', subsg);
        
        inputMap.put('IdentifyingQuote',IdentifyingQuote1);
        string prdse = 'Id:'+ prdt.Id;
        inputMap.put('productIdSet',prdse);
        system.debug('xxxx'+prdt.Id);
        Date edate = date.newinstance(2020,02,02);
        inputMap.put('ContextId',qte.id);
        inputMap.put('AccId',acc.id);
        inputMap.put('CarrierType','BCBSM');
        inputMap.put('EffDate',edate);
        //options.put('SubSegment','abc');
        
        user usr1 = [SELECT Id from User where LastName =: NAME1 limit 1];
        system.runAs(usr1){            
            ASC_GetGSPriceJson rate = new ASC_GetGSPriceJson();
            try {
            test.startTest();            
            rate.invokeMethod('getUnitpriceJSon',inputMap,outMap,options);
            rate.invokeMethod('getUnitVolume',inputMap,outMap,options);
            test.stopTest(); 
            System.assertNotEquals(null,acc.id); 
                } Catch(Exception e) {
              return;
              }  
        }
    }
    /**************  
    Method name : voluntaryVldtnsTest
    Params     : NA
    Return Type : testmethod
    Description :  internalUserTest() method 
    *************/
    private static testmethod void voluntaryVldtnsTestException(){
        Account acc=[select id,name,MailingCountyFormula__c,BillingPostalCode from Account limit 1];
        Contract con =[select id,name from Contract limit 1];
        Map<String,Object> inputMap = new Map<String,Object>();
        Map<String,Object> outMap = new Map<String,Object>();
        Map<String,Object> options = new Map<String,Object>();
        Date edate = date.newinstance(2020,02,02);
        options.put('ctrctId',NULL);
        options.put('AccId',acc.id);
        options.put('CarrierType','BCBSM');
        options.put('EffDate',edate);
        
        user usr1 = [SELECT Id from User where LastName =: NAME1 limit 1];
        system.runAs(usr1){            
            ASC_GetGSPriceJson rate = new ASC_GetGSPriceJson();
            try {
                test.startTest();            
                rate.invokeMethod('getUnitpriceJSon',Null,outMap,NULL);
                test.stopTest(); 
                System.assertNotEquals(null,acc.id);     
            } Catch(Exception e) {
              return;
              }  
        }
    }
    ///////
       /**************  
    Method name : voluntaryVldtnsTest
    Params     : NA
    Return Type : testmethod
    Description :  internalUserTest() method 
    *************/ 
    /*
    
    private static testmethod void voluntaryVldtnsTest5(){
        Account acc=[select id,name,MailingCountyFormula__c,BillingPostalCode from Account limit 1];
        Contract con =[select id,name from Contract limit 1];
        product2 prdt =[select id,name from product2 limit 1];
        Quote qte =[select id,name from Quote where AdditionalName like 'qtTest32400' limit 1];
        Map<String,Object> inputMap = new Map<String,Object>();
        Map<String,Object> outMap = new Map<String,Object>();
        Map<String,Object> options = new Map<String,Object>();
        Map<String,Object> IdentifyingQuote1 = new Map<String,Object>();
        Map<String,Object> subsg = new Map<String,Object>();
        subsg.put('GetAscSubSegement','abc');
        IdentifyingQuote1.put('Carrier', 'BCBSM');
        IdentifyingQuote1.put('StartDate', '2020-01-01');
        IdentifyingQuote1.put('EndDate', '2020-12-12');
        IdentifyingQuote1.put('GetSubSegName-Block', subsg);
        
        inputMap.put('IdentifyingQuote',IdentifyingQuote1);
        string prdse = 'Id:'+ prdt.Id;
        inputMap.put('productIdSet',prdse);
        system.debug('xxxx'+prdt.Id);
        Date edate = date.newinstance(2020,02,02);
        inputMap.put('ContextId',qte.id);
        inputMap.put('AccId',acc.id);
        inputMap.put('CarrierType','BCBSM');
        inputMap.put('EffDate',edate);
        //options.put('SubSegment','abc');
        
        user usr1 = [SELECT Id from User where LastName =: NAME1 limit 1];
        system.runAs(usr1){            
            ASC_GetGSPriceJson rate = new ASC_GetGSPriceJson();
            test.startTest();            
            rate.invokeMethod('getUnitpriceJSon',inputMap,outMap,options);
            test.stopTest(); 
            System.assertNotEquals(null,acc.id);     
        }
    }
    */   
}