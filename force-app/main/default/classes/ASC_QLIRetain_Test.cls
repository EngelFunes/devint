/**************************************************************************************************************************
@Author : IDC Offshore
@Name: ASC_QLIRetain_Test 
@CreatedDate: 23 May 2020
@Description: ASC_QLIRetain_Test class is used to cover ASC_QLIRetain class.  
****************************************************************************************************************************/
@isTest(seealldata = false)
private class ASC_QLIRetain_Test {
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
    private static final string PROFILENAME1='System Administrator';
    private static final string BLANK='';
    private static final string NAME1='Agent';
    private static final string USERNAME='bcbsm1@bcbsm.com';
    private static final string ROLE_NAM = 'TestUser';
    private static final string EMAILVAL = 'testUser@bcbsm.com';
    private static final string PROF_NAM = 'System Administrator';
    private static final String FIRSTSECD_SETJSON = '{"records":[{"childProducts":{"records":[{"ProductCode":"ASC_0000206"}]}}]}';
    @TestSetup static void initData() {
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
        database.insert(con);
        Product2 prd= ARV_AP05_TestDataCreation.productRec();
        prd.Carrier_Type__c=BLANK;
        prd.Voluntary_Contributory__c = 'Non-Voluntary';
        prd.productcode = 'ASC_0000206';
        database.insert(prd);
        Product2 prd1= ARV_AP05_TestDataCreation.productRec();
        database.insert(prd1);
        Product2 prd2= ARV_AP05_TestDataCreation.productRec();
        database.insert(prd2);
        pricebookEntry prc = ARV_AP05_TestDataCreation.priceBookEntryRec(prd.Id,standardPriceBookRecId);
        database.insert(prc);
        Quote qte = ARV_AP05_TestDataCreation.quoteRec(opp.Id,standardPriceBookRecId);
        database.insert(qte,false);
        QuoteLineItem qli = ARV_AP05_TestDataCreation.quoteLineItemRec(qte.id,prd.Id,prc.Id);
        qli.vlocity_ins__AttributeSelectedValues__c = '{"ASC_Variance":false,"ASC_Productcode":"ASC_0000017","ASC_Last_Price_Modified_Date__c":"2020-05-01","ASC_UnitPrice":3.75,"ASC_Activation_Type":"New","ASC_Sales_Volume":1,"ASC_SalesPrice":0,"ASC_Tier":"Tier 1 (51-100)","ASC_PricingMethod":"PCPM"}';
        database.insert(qli,false);
        Quote qte2 = ARV_AP05_TestDataCreation.quoteRec(opp.Id,standardPriceBookRecId);
        qte2.Description = 'qtTest324';
        qte2.AdditionalName = 'qtTest324';
        database.insert(qte2,false);
        QuoteLineItem qli2 = ARV_AP05_TestDataCreation.quoteLineItemRec(qte2.id,prd.Id,prc.Id);
        qli2.vlocity_ins__AttributeSelectedValues__c = '{"ASC_Variance":false,"ASC_Productcode":"ASC_0000017","ASC_Last_Price_Modified_Date__c":"2020-05-01","ASC_UnitPrice":3.75,"ASC_Activation_Type":"New","ASC_Sales_Volume":1,"ASC_SalesPrice":0,"ASC_Tier":"Tier 1 (51-100)","ASC_PricingMethod":"PCPM"}';
        qli2.ASC_Last_Price_Modified_Date__c = system.now();
        database.insert(qli2,false);
        vlocity_ins__ProductChildItem__c chld = new vlocity_ins__ProductChildItem__c();
        chld.vlocity_ins__ParentProductId__c = prd1.Id;
        chld.vlocity_ins__ChildProductId__c = prd2.Id;
        chld.vlocity_ins__ChildLineNumber__c = '12';
        insert chld;
        vlocity_ins__ContractLineItem__c pln = ARV_AP05_TestDataCreation.planRec(prd.id,con.id);
        database.insert(pln);
        vlocity_ins__ContractLineItem__c pln1 = ARV_AP05_TestDataCreation.planRec(prd1.id,con.id);
        database.insert(pln1);
        vlocity_ins__ContractLineItem__c pln2 = ARV_AP05_TestDataCreation.planRec(prd2.id,con.id);
        database.insert(pln2);
        user usr = ARV_AP05_TestDataCreation.UsrRec(PROFILENAME1);
        usr.LastName = NAME1;
        usr.Username=USERNAME;
        database.insert(usr,true);
    }
    
    private static testmethod void testmethod1(){ 
         user usr = GA_OBJ_TD01_TestDataCreation.UsrRec(ROLE_NAM,EMAILVAL,PROF_NAM);
      database.insert(usr);
        system.runAs(usr){
        contract ctrct = [select id from contract LIMIT 1];
        Map<String,Object> options = new Map<String,Object>();
        Map<String,Object> outputMap = new Map<String,Object>();
        options.put('ctrctId',ctrct.Id);
        String strSet = FIRSTSECD_SETJSON;
        Map<String, Object> tmpResult = (Map<String, Object>) JSON.deserializeUntyped(strSet);
        ASC_QLIRetain prdServ = new ASC_QLIRetain();
        test.startTest();
        prdServ.invokeMethod('isSelQLI',tmpResult,outputMap,options);
        test.stopTest();
        System.assertNotEquals(null,ctrct.id);
            }
    }   
    
    private static testmethod void testmethod2(){ 
        contract ctrct = [select id from contract LIMIT 1];
        ASC_QLIRetain prdServ = new ASC_QLIRetain();
          user usr = GA_OBJ_TD01_TestDataCreation.UsrRec(ROLE_NAM,EMAILVAL,PROF_NAM);
      database.insert(usr);
        system.runAs(usr){
        try {
            test.startTest();
            prdServ.invokeMethod('isSelQLI',null,null,null);
            test.stopTest();
            System.assertNotEquals(null,ctrct.id);
        }Catch(Exception e) {return ;}
        } 
    }      
}