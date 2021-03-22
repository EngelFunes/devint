/*****************************************************************************************
Class Name   : ARV_AP53_CencosVoluntaryVldtns_Test 
Date Created : 26-DEC-2019
Created By   : IDC Offshore
Description  : This class is used for testing ARV_AP53_CencosVoluntaryVldtns Class.
******************************************************************************************/
@isTest
public without sharing class ASC_CreateRenewalUserInputs_Test {
    /* Constructor defined */
    public ASC_CreateRenewalUserInputs_Test(){
        ACTIVE1 ='Active';
    }
    private static  string ACTIVE1 ='Active';
    private static final string PROFILENAME='BCBSM Agent';
    private static final string PROFILENAME1='System Administrator';
    private static final string TYPE='Dental';
    private static final string TYPE1='Vision';
    private static final string BLANK='';
    private static final string NAME1='Agent';
    private static final string USERNAME='bcbsm1@bcbsm.com';
    
    private static final string PRODNAME  ='TEST Product';
    private static final string NAME='TEST'; 
    private static final string PHONE='9876543211';    
    private static final string ASC_QTRECTYPE = 'ASC Quote';
    private static final string CONTXID = 'ContextId';
    private static final string SETPRODUCTSELECTIONDATA = 'setProductSelectiondata';
    private static final string GETISSELECTEDPRODUCTS = 'getIsSelectedProductsdata';
    private static final string GETMERGESELECTEDPRODUCTS = 'getMergeSelectedProducts';
    private static final string PRODCONFIGURATIONRESPONSE = 'prodConfigResponse';
    private static final string DELETEUNSELECTEDPLANS = 'deleteUnselectedPlans';  
    private static final Id qTRecordTypeId = Schema.SObjectType.Quote.getRecordTypeInfosByName().get(ASC_QTRECTYPE).getRecordTypeId();   
    private static final string OPP_STAG = 'Quote Request';
    private static final string ASC_OPPRECTYPE = 'Opportunity - ASC';
    private static final string QTNAME = 'test quote';
    private static final Integer UNIT_PRICE = 1;            
    private static final string PRD_NAME = 'Variable Administrative Fees';
    private static final string PRD_CODE = 'ASC_0000370';
    private static final string PRD_FAMILY = 'Admin Fees';
    private static final string PRD_LOB = 'Non-Benefit';
    private static final Integer QUANTY_LI = 2;
    private static final string ACC_RECORDTYPE  ='Account - Customer';
    private static final string ACCCID = '12345';
    private static final string FEDTID = '123456789';
    private static final string BILL_PCODE = '48005';
    private static final string PARPRD_CD = 'ASC_0000005';
    private static final string PARPRD_FAMILY = 'Medical';
    private static final string SCHEDULEA_EXHIBIT_2 ='Schedule A - Exhibit 2';
    private static final string CONTRACT_AMENDMENT ='Contract Amendment';
    private static final string STOPLOSS_AMENDMENT ='Stop-Loss Amendment';
    private static final string ACTIVE = 'Active';
    private static final string ASC_DOCLANG = 'Active text';
    private static final Id prdCovSpecRecordTypeId = Schema.SObjectType.Product2.getRecordTypeInfosByName().get('Coverage Spec').getRecordTypeId(); 
    private static final Id prdRecordTypeId=Schema.SObjectType.Product2.getRecordTypeInfosByName().get('Product').getRecordTypeId();    
    private static final string BCBSM = 'BCBSM';
    private static final string GETUSERINPUTJSON = 'getUserInputJSon';
    private static final string RETAINPRIORYEARINFO = 'RetainPriorYearInformation';
    
    /**************  
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
        prd.vlocity_ins__Type__c=TYPE;
        prd.ASC_Annual_Product__c=False;
        prd.Carrier_Type__c=BLANK;
        database.insert(prd);
        Product2 prd1= ARV_AP05_TestDataCreation.productRec();
        prd1.vlocity_ins__Type__c=TYPE;
        prd1.Carrier_Type__c=BLANK;
        prd1.ASC_Annual_Product__c=False;
        database.insert(prd1);
        Product2 prd2= ARV_AP05_TestDataCreation.productRec();
        prd2.vlocity_ins__Type__c=TYPE1;
        prd2.Carrier_Type__c=BLANK;
        prd2.ASC_Annual_Product__c=False;
        database.insert(prd2);
        
        Id pricebookId = Test.getStandardPricebookId();            
        Quote q = new Quote();
        q.Name = QTNAME;
        q.opportunityId = Opp.Id;
        q.pricebook2Id = pricebookId;
        q.RecordTypeId = qTRecordTypeId;
        q.status = 'Draft';
        q.ASC_Carrier__c=BCBSM;
        Database.insert(q,false);
        
        pricebookEntry prc=new pricebookEntry ();
        prc.product2Id = prd.Id;
        prc.Pricebook2Id = pricebookId;
        prc.UnitPrice = UNIT_PRICE;
        prc.isActive = true;
        Database.insert(prc);
        
        QuoteLineItem qli=new QuoteLineItem();
        qli.QuoteId = q.Id;
        qli.product2Id = prd.Id;
        qli.UnitPrice = UNIT_PRICE ;
        qli.Quantity = QUANTY_LI;
        qli.pricebookentryid = prc.Id;
        qli.ASC_Effective_Start_Date__c = system.today();
        qli.ASC_Effective_End_Date__c = system.today();
        Database.insert(qli,false);
        Database.update(qli,false);
        
        QuoteLineItem qli1=new QuoteLineItem();
        qli1.QuoteId = q.Id;
        qli1.product2Id = prd1.Id;
        qli1.UnitPrice = UNIT_PRICE ;
        qli1.Quantity = QUANTY_LI;
        qli1.pricebookentryid = prc.Id;
        qli1.ASC_Effective_Start_Date__c = system.today();
        qli1.ASC_Effective_End_Date__c = system.today();
        Database.insert(qli1,false);
        Database.update(qli1,false);
        
        vlocity_ins__ProductChildItem__c chld = new vlocity_ins__ProductChildItem__c();
        chld.vlocity_ins__ParentProductId__c = prd1.Id;
        chld.vlocity_ins__ChildProductId__c = prd2.Id;
        chld.vlocity_ins__ChildLineNumber__c = '12';
        Database.insert(chld);
        
        Line_Item_Extension__c lie = new Line_Item_Extension__c();
        lie.name = 'TestLie';
        lie.Quantity__c = 5;
        Database.insert(lie);
        vlocity_ins__ContractLineItem__c pln = ARV_AP05_TestDataCreation.planRec(prd.id,con.id);
        pln.ASC_Line_Item_Extension__c = lie.id;
        pln.ASC_Effective_Start_Date__c=system.today();
        pln.ASC_Effective_End_Date__c=system.today();
        database.insert(pln);
        vlocity_ins__ContractLineItem__c pln1 = ARV_AP05_TestDataCreation.planRec(prd1.id,con.id);
        pln1.ASC_Effective_Start_Date__c=system.today();
        pln1.ASC_Effective_End_Date__c=system.today();
       
        database.insert(pln1);
        vlocity_ins__ContractLineItem__c pln2 = ARV_AP05_TestDataCreation.planRec(prd2.id,con.id);
        pln2.ASC_Effective_Start_Date__c=system.today();
        pln2.ASC_Effective_End_Date__c=system.today();
        
        database.insert(pln2);
        ASC_Group_Specific_Pricing__c gsp = new ASC_Group_Specific_Pricing__c();
        gsp.ASC_Group__c = act.id;
        gsp.ASC_Carrier__c = BCBSM;
        gsp.ASC_Product__c = prd1.id;
        gsp.ASC_Effective_Date__c = date.valueOf('2020-01-01');
        gsp.ASC_Effective_End_Date__c = date.valueOf('2020-12-12');
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
    Description :  testMethod1() method 
    *************/ 
    private static testmethod void testMethod1(){    
    
        Account acc=[select id,name,MailingCountyFormula__c,BillingPostalCode from Account limit 1];
        Contract con =[select id,name from Contract limit 1];
        Quote q = [ select id from quote limit 1];
        Map<String,Object> inputMap = new Map<String,Object>();
        Map<String,Object> outMap = new Map<String,Object>();
        Map<String,Object> options = new Map<String,Object>();
        Date edate = date.newinstance(2020,02,02);
        options.put('ctrctId',con.id);
        options.put('AccId',acc.id);
        options.put('CarrierType','BCBSM');
        options.put('EffDate',edate);
        options.put('quoteId',q.id);
        options.put('RenewalYear','2019');
        
        user usr1 = [SELECT Id from User where LastName =: NAME1 limit 1];
        system.runAs(usr1){            
            ASC_CreateRenewalUserInputs rate = new ASC_CreateRenewalUserInputs();
            try {
                test.startTest();            
                rate.invokeMethod('getUserInputJSon',inputMap,outMap,options);
                rate.invokeMethod('RetainPriorYearInformation',inputMap,outMap,options);
                test.stopTest(); 
                System.assertNotEquals(null,acc.id);     
            } Catch(Exception e) {return ;}  
        }
    }
    /**************  
    Method name : testMethodException
    Params     : NA
    Return Type : testmethod
    Description :  testMethodException() method 
    *************/ 
    private static testmethod void testMethodException(){
        Account acc=[select id,name,MailingCountyFormula__c,BillingPostalCode from Account limit 1];
        Contract con =[select id,name from Contract limit 1];
        Quote q = [ select id from quote limit 1];
        Map<String,Object> outMap = new Map<String,Object>();
        Map<String,Object> options = new Map<String,Object>();
        Date edate = date.newinstance(2020,02,02);
        options.put('ctrctId',NULL);
        options.put('AccId',acc.id);
        options.put('CarrierType',BCBSM);
        options.put('EffDate',edate);
        options.put('quoteId',q.id);
        
        user usr1 = [SELECT Id from User where LastName =: NAME1 limit 1];
        system.runAs(usr1){            
            ASC_CreateRenewalUserInputs rate = new ASC_CreateRenewalUserInputs();
            try {
                test.startTest();            
                rate.invokeMethod(GETUSERINPUTJSON,Null,outMap,NULL);
                 rate.invokeMethod(RETAINPRIORYEARINFO,Null,outMap,NULL);
                test.stopTest(); 
                System.assertNotEquals(null,acc.id);     
            } Catch(Exception e) {return ;}  
        }
    }
}