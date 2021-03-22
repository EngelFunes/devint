/**************************************************************************************************************************
@Author : Dinesh
@Name: ASC_IP_GetProductService_Test 
@CreatedDate: 23 Apr 2020
@Description: ASC_IP_GetProductService_Test class is used to cover ASC_IP_GetProductService class
@version : 1.0  
****************************************************************************************************************************/
@isTest(seealldata = false)
private class ASC_IP_GetProductService_Test {
    private static final string QUOTEID = 'quoteId';
    private static final string TYPE  ='ASC Product';
    private static final string PRODNAME  ='TEST Product';
    private static final string NAME='TEST'; 
    private static final string PHONE='9876543211';    
    private static final string ASC_QTRECTYPE = 'ASC Quote';
    private static final string CONTXID = 'ContextId';
    private static final String SETPRODUCTSELECTIONDATA = 'setProductSelectiondata';
    private static final String GETISSELECTEDPRODUCTS = 'getIsSelectedProductsdata';
    private static final String GETMERGESELECTEDPRODUCTS = 'getMergeSelectedProducts';
    private static final String PRODCONFIGURATIONRESPONSE = 'prodConfigResponse';
    private static final String DELETEUNSELECTEDPLANS = 'deleteUnselectedPlans';  
    private static final Id QTRECTYPID = 
    Schema.SObjectType.Quote.getRecordTypeInfosByName().get(ASC_QTRECTYPE).getRecordTypeId();   
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
    private static final Id PRDCOVSPECRECTYPEID = 
    Schema.SObjectType.Product2.getRecordTypeInfosByName().get('Coverage Spec').getRecordTypeId(); 
    private static final Id PRDRECTYPID = 
    Schema.SObjectType.Product2.getRecordTypeInfosByName().get('Product').getRecordTypeId();    
                                              
    private static final String CONFIGPRD_JSON = '{"ConfigureProduct1":{"ConfigureSelectedProduct1" : [{"childProducts" : {"records" :[{"ProductCode":"ASC_0000206"}]}}]},"ConfigureProduct2":{"ConfigureSelectedProduct2" : [{"childProducts" : {"records" :[{"ProductCode":"ASC_0000207"}]}}]},"ConfigureProduct3":{"ConfigureSelectedProduct3" : [{"childProducts" : {"records" :[{"ProductCode":"ASC_0000208"}]}}]},"ConfigureProduct4":{"ConfigureSelectedProduct4" : [{"childProducts" : {"records" :[{"ProductCode":"ASC_0000209"}]}}]},"ConfigureProduct5":{"ConfigureSelectedProduct5" : [{"childProducts" : {"records" :[{"ProductCode":"ASC_0000210"}]}}]},"ConfigureProduct6":{"ConfigureSelectedProduct6" : [{"childProducts" : {"records" :[{"ProductCode":"ASC_0000211"}]}}]},"ConfigureProduct7":{"ConfigureSelectedProduct7" : [{"childProducts" : {"records" :[{"ProductCode":"ASC_0000212"}]}}]},"ConfigureProduct8":{"ConfigureSelectedProduct8" : [{"childProducts" : {"records" :[{"ProductCode":"ASC_0000213"}]}}]},"ConfigureProduct9":{"ConfigureSelectedProduct9" : [{"childProducts" : {"records" :[{"ProductCode":"ASC_0000214"}]}}]},"ConfigureProduct10":{"ConfigureSelectedProduct10" : [{"childProducts" : {"records" :[{"ProductCode":"ASC_0000215"}]}}]},"ConfigureProduct11":{"ConfigureSelectedProduct11" : [{"childProducts" : {"records" :[{"ProductCode":"ASC_0000216"}]}}]},"ConfigureProduct12":{"ConfigureSelectedProduct12" : [{"childProducts" : {"records" :[{"ProductCode":"ASC_0000217"}]}}]},"ConfigureProduct13":{"ConfigureSelectedProduct13" : [{"childProducts" : {"records" :[{"ProductCode":"ASC_0000218"}]}}]},"ConfigureProduct14":{"ConfigureSelectedProduct14" : [{"childProducts" : {"records" :[{"ProductCode":"ASC_0000219"}]}}]},"ConfigureProduct15":{"ConfigureSelectedProduct15" : [{"childProducts" : {"records" :[{"ProductCode":"ASC_0000220"}]}}]},"ConfigureProduct16":{"ConfigureSelectedProduct16" : [{"childProducts" : {"records" :[{"ProductCode":"ASC_0000221"}]}}]},"ConfigureProduct17":{"ConfigureSelectedProduct17" : [{"childProducts" : {"records" :[{"ProductCode":"ASC_0000222"}]}}]},"ConfigureProduct18":{"ConfigureSelectedProduct18" : [{"childProducts" : {"records" :[{"ProductCode":"ASC_0000223"}]}}]},"ConfigureProduct19":{"ConfigureSelectedProduct19" : [{"childProducts" : {"records" :[{"ProductCode":"ASC_0000224"}]}}]},"ConfigureProduct20":{"ConfigureSelectedProduct20" : [{"childProducts" : {"records" :[{"ProductCode":"ASC_0000225"}]}}]},"ConfigureProduct21":{"ConfigureSelectedProduct21" : [{"childProducts" : {"records" :[{"ProductCode":"ASC_0000226"}]}}]},"ConfigureProduct22":{"ConfigureSelectedProduct22" : [{"childProducts" : {"records" :[{"ProductCode":"ASC_0000227"}]}}]},"ConfigureProduct23":{"ConfigureSelectedProduct23" : [{"childProducts" : {"records" :[{"ProductCode":"ASC_0000228"}]}}]},"ConfigureProduct24":{"ConfigureSelectedProduct24" : [{"childProducts" : {"records" :[{"ProductCode":"ASC_0000229"}]}}]},"ConfigureProduct25":{"ConfigureSelectedProduct25" : [{"childProducts" : {"records" :[{"ProductCode":"ASC_0000230"}]}}]},"ConfigureProduct26":{"ConfigureSelectedProduct26" : [{"childProducts" : {"records" :[{"ProductCode":"ASC_0000231"}]}}]},"ConfigureProduct27":{"ConfigureSelectedProduct27" : [{"childProducts" : {"records" :[{"ProductCode":"ASC_0000232"}]}}]},"ConfigureProduct28":{"ConfigureSelectedProduct28" : [{"childProducts" : {"records" :[{"ProductCode":"ASC_0000233"}]}}]},"ConfigureProduct29":{"ConfigureSelectedProduct29" : [{"childProducts" : {"records" :[{"ProductCode":"ASC_0000234"}]}}]},"ConfigureProduct30":{"ConfigureSelectedProduct30" : [{"childProducts" : {"records" :[{"ProductCode":"ASC_0000235"}]}}]},"records12":[{"isSelected": true,"Id": "01tg0000009w2yXAAQ","Name": "3rd Party Vendor Services","ProductCode": "ASC_0001206","$$hashKey": "object:998"},{"isSelected": true,"Id": "01tg0000009v1mDAAQ","Name": "Administrative Fees","ProductCode": "ASC_0000011","$$hashKey": "object:1009"}]}';   
    private static final String FIRSTSECD_SETJSON = '{"firstSet": [{"isSelected": true,"Id": "01tg0000009w2yXAAQ","Name": "3rd Party Vendor Services","ProductCode": "ASC_0000206","$$hashKey": "object:998"}],"secondSet": [{"Id": "01tg0000009v1mDAAQ","Name": "Administrative Fees","ProductCode": "ASC_0000011","$$hashKey": "object:1009"}]}';
    private static final String RECORDS12 = '{"records12":[{"isSelected": true,"Id": "01tg0000009w2yXAAQ","Name": "3rd Party Vendor Services","ProductCode": "ASC_0000206","$$hashKey": "object:998"},{"isSelected": true,"Id": "01tg0000009v1mDAAQ","Name": "Administrative Fees","ProductCode": "ASC_0000011","$$hashKey": "object:1009"}]}';
    private static final string ROLE_NAM = 'TestUser';
    private static final string EMAILVAL = 'testUser@bcbsm.com';
    private static final string PROF_NAM = 'System Administrator';
    private static final string DEL_CONFIGPRD_JSON = '{"unSelectedPlans": ["01tg0000009w0001"],"deSelectedChildPlans": ["01tg0000009w0001"]}';                                                         

    /*******************************************************************************************************************************
    @Description: initData() method - preparing the test data
    @Name : initData
    @Param : None
    @Return : void
    @throws Exception : N/A;
    ********************************************************************************************************************************/
     @TestSetup static void initData() {
            
            Product2 prd1 = new Product2();
            prd1.vlocity_ins__Type__c = TYPE;
            prd1.ProductCode = PARPRD_CD;
            prd1.IsActive = true;
            prd1.Name = PRODNAME;
            prd1.Family = PARPRD_FAMILY;
            prd1.vlocity_ins__LineOfBusiness__c = PRD_LOB;
            prd1.RecordTypeId = PRDRECTYPID;
            prd1.vlocity_ins__SubType__c = TYPE;
            Database.insert(prd1, false);
                                                    
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
            vlocity_ins__EffectiveDate__c = system.today(),
            RecordTypeId = PRDCOVSPECRECTYPEID
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
            quot.RecordTypeId = QTRECTYPID;
            Database.insert(quot,false);

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
            Database.insert(qli,false);   
            
         QuoteLineItem qli1=new QuoteLineItem();
            qli1.QuoteId = quot.Id;
            qli1.product2Id = prd1.Id;
            qli1.UnitPrice = UNIT_PRICE ;
            qli1.Quantity = QUANTY_LI;
            qli1.pricebookentryid = prc.Id;
            Database.insert(qli1,false);                 
    }
    /*******************************************************************************************************************************
    @Description: This test method is used to cover the config prod selection data.
    @Name : testmethod1
    @Param : None
    @Return : void
    @throws Exception : N/A;
    ********************************************************************************************************************************/
    private static testmethod void testmethod1(){ 
      user usr = GA_OBJ_TD01_TestDataCreation.UsrRec(ROLE_NAM,EMAILVAL,PROF_NAM);
      database.insert(usr);
      system.runAs(usr){
       try{
        String strSet = FIRSTSECD_SETJSON;
        Map<String, Object> resultInptIsSel = (Map<String, Object>) JSON.deserializeUntyped(strSet); 
           
        String confProducts = CONFIGPRD_JSON;
        Map<String, Object> tmpResult = (Map<String, Object>) JSON.deserializeUntyped(confProducts);
        Map<String, Object> Iputmap1 =new Map<String, Object>();
           Iputmap1.put('records12',RECORDS12);
           system.debug('==>'+Iputmap1);
        ASC_IP_GetProductService prdServ = new ASC_IP_GetProductService();
        prdServ.invokeMethod(SETPRODUCTSELECTIONDATA,null,null,null);
        prdServ.invokeMethod(GETISSELECTEDPRODUCTS,resultInptIsSel,null,null);
        prdServ.invokeMethod(GETMERGESELECTEDPRODUCTS,tmpResult,null,null);
       // prdServ.invokeMethod(GETMERGESELECTEDPRODUCTS,Iputmap1,null,null);
        prdServ.invokeMethod(PRODCONFIGURATIONRESPONSE,tmpResult,null,null);        
       }
       catch(exception e)
       {
            system.assert(e <> null);
            return;
       }
      }
    }   
    /*******************************************************************************************************************************
    @Description: This test method is used to cover the preselected quoteline item records- getMergeSelectedProducts.
    @Name : testmethod2
    @Param : None
    @Return : void
    @throws Exception : N/A;
    ********************************************************************************************************************************/
    private static testmethod void testmethod2(){ 
      user usr = GA_OBJ_TD01_TestDataCreation.UsrRec(ROLE_NAM,EMAILVAL,PROF_NAM);
      database.insert(usr);
      system.runAs(usr){
       try{                       

        Map<String, Object> tmpResult = new Map<String,Object>();
        Quote quot = [Select Id from Quote where RecordTypeId =:QTRECTYPID Limit 1];            
        tmpResult.put(CONTXID,quot.Id);
            Map<String,Object> output = new Map<String,Object>();
            Map<String,Object> input = new Map<String,Object>(); 
           Map<String, Object> Iputmap1 =new Map<String, Object>();
           Iputmap1.put('records12',RECORDS12);
        ASC_IP_GetProductService prdServ = new ASC_IP_GetProductService();
        prdServ.invokeMethod(SETPRODUCTSELECTIONDATA,null,null,null);
        prdServ.invokeMethod(GETMERGESELECTEDPRODUCTS,tmpResult,null,null);
           // prdServ.invokeMethod(GETMERGESELECTEDPRODUCTS,Iputmap1,null,null);
                                                                    
        String delQLIProducts = DEL_CONFIGPRD_JSON;
        Map<String, Object> inpResult = (Map<String, Object>) JSON.deserializeUntyped(delQLIProducts);
        prdServ.invokeMethod(DELETEUNSELECTEDPLANS,inpResult,null,null);                   
        system.assert(quot <> null);
       }
       catch(exception e)
       {
            system.assert(e <> null);
            return;
       }
      }
    } 
    
    /*******************************************************************************************************************************
    @Description: This test method is used to cover the preselected quoteline item records- getMergeSelectedProducts.
    @Name : testmethod2
    @Param : None
    @Return : void
    @throws Exception : N/A;
    ********************************************************************************************************************************/
    private static testmethod void testmethod3(){ 
      user usr = GA_OBJ_TD01_TestDataCreation.UsrRec(ROLE_NAM,EMAILVAL,PROF_NAM);
      database.insert(usr);
    

        Map<String, Object> tmpResult = new Map<String,Object>();
             Account acc=[select id,name,MailingCountyFormula__c,BillingPostalCode from Account limit 1];
        //Contract con =[select id,name from Contract limit 1];
        product2 prdt =[select id,name from product2 limit 1];
        List<Quote> qte =[select id,name from Quote limit 1];
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
        inputMap.put('ContextId',qte[0].id);
        inputMap.put('AccId',acc.id);
        inputMap.put('CarrierType','BCBSM');
        inputMap.put('EffDate',edate);
           system.debug('---'+inputMap);
           //inputMap = (Map<String, Object>) JSON.deserializeUntyped(delQLIProducts);
        ASC_IP_GetProductService prdServ = new ASC_IP_GetProductService();
        prdServ.invokeMethod('updateDatesForQLI',inputMap,outMap,options);
      
       }
         
}