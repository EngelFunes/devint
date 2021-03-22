/**************************************************************************************************************************
@Author : Harsha
@Name: ASC_QLI_LineItemExtensionsAttrUpdateTest 
@CreatedDate: 29 May 2020
@Description: ASC_QLI_LineItemExtensionsAttrUpdateTest class is used to cover ASC_QLI_LineItemExtensionsAttrUpdate class
@version : 1.0  
****************************************************************************************************************************/
@isTest
public without sharing class ASC_QLI_LineItemExtensionsAttrUpdateTest { 

    private static final string PRODNAME  ='TEST Product';
    private static final string NAME='TEST'; 
    private static final string PHONE='9876543211';    
    private static final string ASC_QTRECTYPE = 'ASC Quote';
    private static final string TYPE  ='ASC Product';
    private static final string QUOTEID = 'quoteId';
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
    private static final string COV_SPEC = 'Coverage Spec';
    private static final string PRODT = 'Product';
    private static final string CARR_BCBSM = 'BCBSM';
    private static final string CARR_BCN = 'BCN';
    private static final string NEWBUSINESS = 'New Business';
        
    private static Id prdCovSpecRecordTypeId =
     Schema.SObjectType.Product2.getRecordTypeInfosByName().get(COV_SPEC).getRecordTypeId(); 
    private static Id prdRecordTypeId=
     Schema.SObjectType.Product2.getRecordTypeInfosByName().get(PRODT).getRecordTypeId();    
    private static Id qTRecordTypeId = 
    Schema.SObjectType.Quote.getRecordTypeInfosByName().get(ASC_QTRECTYPE).getRecordTypeId();   
    private static final string UPDTQLIEXTN  ='updtQLILineItemExtension';
    private static final string ATTSEL_VAL 
    ='{"ASC_CRED_CLMS_Facility":0,"ASC_Variance":"false","ASC_Coverage_Elected__c":false,"ASC_Productcode":"ASC_0000370","ASC_CRED_CLMS":0,"ASC_PricingType":"Underwritten","ASC_AAC_PCNT":"0","ASC_PercentOfClaim":"0","ASC_UnitVolume":"1","ASC_EffectiveEndDate":"2020-05-29","ASC_EffectiveStartDate":"2020-05-01","ASC_Platform":"MOS","ASC_Activation_Type":"New","ASC_Sales_AAC_PCNT":"0","ASC_Sales_PcntOfClaims":"0","ASC_Sales_Volume":"1","ASC_SalesFee_Not_GT":0,"ASC_Sales_Fee_Not_LT":0,"ASC_PricingMethod":"PCPM","ASC_Mixed_Billed_Type":"Flat"}';
    private static final string ATTSEL_VAL1 
    ='{"ASC_Last_Price_Modified":"2020-05-01T00:00:00","ASC_Coverage_Elected__c":"false","ASC_CRED_CLMS_Facility":0,"ASC_Variance":"false","ASC_Productcode":"ASC_0000370","ASC_CRED_CLMS":0,"ASC_PricingType":"Underwritten","ASC_AAC_PCNT":"0","ASC_PercentOfClaim":"0","ASC_UnitVolume":"1","ASC_EffectiveEndDate":"2020-05-29","ASC_EffectiveStartDate":"2020-05-01","ASC_Platform":"MOS","ASC_Activation_Type":"New","ASC_Sales_AAC_PCNT":"0","ASC_Sales_PcntOfClaims":"0","ASC_Sales_Volume":"1","ASC_SalesFee_Not_GT":0,"ASC_Sales_Fee_Not_LT":0,"ASC_PricingMethod":"PCPM"}';

    private static final string ROLE_NAM = 'TestUser';
    private static final string EMAILVAL = 'testUser@bcbsm.com';
    private static final string PROF_NAM = 'System Administrator';

    /*******************************************************************************************************************************
    @Description: initData() method - preparing the test data
    @Name : initData
    @Param : None
    @Return : void
    @throws Exception : N/A;
    ********************************************************************************************************************************/
    @TestSetup static void initData() {

            Account acc=new Account();
            acc.Name=NAME;
            acc.Phone=PHONE;
            acc.CID__c=ACCCID;
            acc.Federal_Tax_ID__c=ACCCID;
            acc.Requested_Effective_Date__c=system.today();
            acc.GA_CoverageCancellationDate__c=system.today();        
            acc.BillingPostalCode = BILL_PCODE;
            acc.RecordTypeId =
             Schema.SObjectType.Account.getRecordTypeInfosByName().get(ACC_RECORDTYPE).getRecordTypeId();
            Database.insert(acc,false);
            
            Product2 prod= new product2(
            Name = PRD_NAME,
            productcode = PRD_CODE,
            Family = PRD_FAMILY,
            vlocity_ins__LineOfBusiness__c = PRD_LOB,
            vlocity_ins__SubType__c = TYPE,
            vlocity_ins__Type__c = TYPE,
            vlocity_ins__EffectiveDate__c = system.today()
            );
            Database.insert(prod,false);
                        
            opportunity opp=new opportunity();
            opp.Name = NAME;
            opp.AccountId = acc.id;
            opp.stageName = OPP_STAG;
            opp.CloseDate = system.today()+120;
            opp.RecordTypeId = 
            Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(ASC_OPPRECTYPE).getRecordTypeId();
            Database.insert(opp,false);
                        
            Id pricebookId = Test.getStandardPricebookId();            
            Quote quot = new Quote();
            quot.Name = QTNAME;
            quot.opportunityId = Opp.Id;
            quot.pricebook2Id = pricebookId;
            quot.RecordTypeId = qTRecordTypeId;
            quot.ASC_Carrier__c = CARR_BCBSM;
            quot.ASC_Invoice_Exceptions__c = NEWBUSINESS;
            Database.insert(quot,false);

            Quote quot1 = new Quote();
            quot1.Name = QTNAME;
            quot1.opportunityId = Opp.Id;
            quot1.pricebook2Id = pricebookId;
            quot1.RecordTypeId = qTRecordTypeId;
            quot1.ASC_Carrier__c = CARR_BCN;
            Database.insert(quot1,false);

            pricebookEntry prc=new pricebookEntry ();
            prc.product2Id = prod.Id;
            prc.Pricebook2Id = pricebookId;
            prc.UnitPrice = UNIT_PRICE;
            prc.isActive = true;
            Database.insert(prc,false);

            QuoteLineItem qli=new QuoteLineItem();
            qli.QuoteId = quot.Id;
            qli.product2Id = prod.Id;
            qli.UnitPrice = UNIT_PRICE ;
            qli.Quantity = QUANTY_LI;
            qli.pricebookentryid = prc.Id;
            qli.vlocity_ins__AttributeSelectedValues__c = ATTSEL_VAL;
            Database.insert(qli,false);     
                               
            QuoteLineItem qli1 = new QuoteLineItem();
            qli1.QuoteId = quot1.Id;
            qli1.product2Id = prod.Id;
            qli1.UnitPrice = UNIT_PRICE ;
            qli1.Quantity = QUANTY_LI;
            qli1.pricebookentryid = prc.Id;
            qli1.vlocity_ins__AttributeSelectedValues__c = ATTSEL_VAL1;
            Database.insert(qli1,false);
    }
    /*******************************************************************************************************************************
    @Description: This test method is used to create/update LI and QLI records.
    @Name : lineItemExtensionsAttrUpdate
    @Param : None
    @Return : void
    @throws Exception : N/A;
    ********************************************************************************************************************************/
     public static testmethod void lineItemExtensionsAttrUpdate(){
     try{
         user usr = GA_OBJ_TD01_TestDataCreation.UsrRec(ROLE_NAM,EMAILVAL,PROF_NAM);
         database.insert(usr);
         system.runAs(usr){
            Map<String,Object> outMap = new Map<String,Object>();
            Map<String,Object> options = new Map<String,Object>();
            Quote quot = [Select Id from Quote where RecordTypeId =:qTRecordTypeId 
                          AND ASC_Carrier__c =:CARR_BCBSM Limit 1];            
            string sid = quot.Id;
            Map<String,Object> input = new Map<String,Object>();
            input.put(QUOTEID,sid);
            ASC_QLI_LineItemExtensionsAttrUpdate ascl =new ASC_QLI_LineItemExtensionsAttrUpdate();
            ascl.invokeMethod(UPDTQLIEXTN,input,options,outMap);    
            system.assert(quot <> null);
         }
        }
        catch(exception e)
        {
            system.assert(e <> null);
            return;
        }      
    }
    /*******************************************************************************************************************************
    @Description: This test method is used to create/update LI and QLI records - Coverage for Date/Time Type
    @Name : lineItemExtensionsAttrUpdatemethod2
    @Param : None
    @Return : void
    @throws Exception : N/A;
    ********************************************************************************************************************************/
    public static testmethod void lineItemExtensionsAttrUpdatemethod2(){
     try{
         user usr = GA_OBJ_TD01_TestDataCreation.UsrRec(ROLE_NAM,EMAILVAL,PROF_NAM);
         database.insert(usr);
         system.runAs(usr){
            Map<String,Object> outMap = new Map<String,Object>();
            Map<String,Object> options = new Map<String,Object>();
            Quote quot1 = [Select Id from Quote where RecordTypeId =:qTRecordTypeId
                           AND ASC_Carrier__c =: CARR_BCN Limit 1];            
            string sid = quot1.Id;
            Map<String,Object> input = new Map<String,Object>();
            input.put(QUOTEID,sid);
            ASC_QLI_LineItemExtensionsAttrUpdate ascl =new ASC_QLI_LineItemExtensionsAttrUpdate();
            ascl.invokeMethod(UPDTQLIEXTN,input,options,outMap);    
            system.assert(quot1 <> null);
         }
        }
        catch(exception e)
        {
            system.assert(e <> null);
            return;
        }      
    }
}