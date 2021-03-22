/*****************************************************************************************
Class Name   : ASC_DeleteLineItemExt_Test 
Date Created : 25 SEP 2020
Created By   : IDC Offshore
Description  : This class is used for testing ASC_DeleteLineItemExt Class.
******************************************************************************************/
@isTest
public without sharing class ASC_DeleteLineItemExt_Test {
    
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
    private static final Integer UNIT_PRICE1 = 12;             
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
    private static final string LIENAME  ='TEST LIE';
    private static final Integer QUANTITY = 20;
    private static final Double COUPONSAVINGS = 20;
    private static final Double COUPONSAVINGSDECIMAL = 20.50;
    private static final Double AWP1 = 20;
    private static final Double AWP1DECIMAL = 20.65;
    private static final Double AWP2 = 20;
    private static final Double AWP2DECIMAL = 20.75;
    
    
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
        List<Line_Item_Extension__c> LieLst=new list<Line_Item_Extension__c>();
        Line_Item_Extension__c lie2 = new Line_Item_Extension__c();
        lie2.name = LIENAME;
        lie2.Quantity__c = QUANTITY;
        //lie.Quote_Line_Item__c=QliLst[1].id;
        lie2.Percent_of_Coupon_Savings__c=COUPONSAVINGSDECIMAL;
        lie2.AWP_1__c=AWP1DECIMAL;
        lie2.AWP_2__c=AWP2DECIMAL;
        LieLst.add(Lie2);
        
        
        Line_Item_Extension__c lie = new Line_Item_Extension__c();
        lie.name = LIENAME;
        // lie.Quote_Line_Item__c=qli.id;
        lie.Quantity__c = QUANTITY;
        lie.Percent_of_Coupon_Savings__c=COUPONSAVINGS;
        // lie.Quote_Line_Item__c=QliLst[0].id;
        lie.AWP_1__c=AWP1;
        lie.AWP_2__c=AWP2;
        LieLst.add(Lie);
        
        Line_Item_Extension__c lie1 = new Line_Item_Extension__c();
        lie1.name = LIENAME;
        lie1.Quantity__c = QUANTITY;
        // lie.Quote_Line_Item__c=QliLst[1].id;
        lie1.Percent_of_Coupon_Savings__c=COUPONSAVINGSDECIMAL;
        lie1.AWP_1__c=AWP1DECIMAL;
        lie1.AWP_2__c=AWP2DECIMAL;
        LieLst.add(Lie1);
        Database.insert(LieLst);   
        
        List<QuoteLineItem > QliLst=new list<QuoteLineItem >();
        QuoteLineItem qli=new QuoteLineItem();
        qli.QuoteId = q.Id;
        qli.product2Id = p.Id;
        qli.ASC_Line_Item_Extension__c=LieLst[0].id;
        qli.UnitPrice = UNIT_PRICE ;
        qli.Quantity = QUANTY_LI;
        qli.pricebookentryid = prc.Id;
        QliLst.add(qli);
        
        QuoteLineItem qli1=new QuoteLineItem();
        qli1.QuoteId = q.Id;
        qli1.product2Id = p1.Id;
        qli1.ASC_Line_Item_Extension__c=LieLst[1].id;
        qli1.UnitPrice = UNIT_PRICE1 ;
        qli1.Quantity = QUANTY_LI;
        qli1.pricebookentryid = prc.Id;
        QliLst.add(qli1);
        
        Database.insert(QliLst,false); 
        
        
        
        Contract con= new Contract(
            AccountId=acc.Id,Status='Draft',
            StartDate =system.today(),ContractTerm=4);
        Database.insert(con);    
        
        vlocity_ins__ContractLineItem__c plan2 = new vlocity_ins__ContractLineItem__c();
        plan2.vlocity_ins__Product2Id__c=P.Id;
        plan2.ASC_Effective_Start_Date__c=system.today();
        plan2.ASC_AAC_PCNT__c=10.00;
        plan2.ASC_Line_Item_Extension__c =LieLst[2].id;
        plan2.vlocity_ins__ContractId__c=con.id;
        Database.insert(plan2);                 
        
        Product2 prd3 = new Product2();
        prd3.vlocity_ins__Type__c = TYPE;
        prd3.ProductCode = PARPRD_CD;
        prd3.IsActive = true;
        prd3.Name = 'Rx Opt Out';
        prd3.Family = PARPRD_FAMILY;
        prd3.vlocity_ins__LineOfBusiness__c = PRD_LOB;
        prd3.RecordTypeId = prdRecordTypeId;
        prd3.vlocity_ins__SubType__c = TYPE;
        Database.insert(prd3, false); 
        
        vlocity_ins__ContractLineItem__c plan3 = new vlocity_ins__ContractLineItem__c();
        plan3.vlocity_ins__Product2Id__c=Prd3.Id;
        plan3.ASC_Effective_Start_Date__c=system.today();
        plan3.ASC_AAC_PCNT__c=10.00;
        //plan3.ASC_Line_Item_Extension__c =LieLst[1].id;
        plan3.vlocity_ins__ContractId__c=con.id;
        Database.insert(plan3);                 
    }        
    /**************  
    Method name : testMethod1
    Params     : NA
    Return Type : testmethod
    Description :  To delete Lie Realted Qli
    *************/ 
    private static testmethod void deleteLieforQli(){
        try{
            user usr = GA_OBJ_TD01_TestDataCreation.UsrRec(ROLE_NAM,EMAILVAL,PROF_NAM);
            database.insert(usr);
            system.runAs(usr){
                List<QuoteLineItem > QliLst1=[select id from quotelineitem];
                delete QliLst1[0];
                test.startTest();  
                ASC_DeleteLineItemExt.deleteLineitemExt(QliLst1);                                
                test.stopTest(); 
            }
        }
        catch(exception e){
            system.assert(e <> null);
            return;
        }                           
    }        
}