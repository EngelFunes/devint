/**
@Author : IDC offshore
@Name: ASC_QuoteTriggerHandlerTest
@CreatedDate: 10 - June 2020 
@Description: ASC_QuoteTriggerHandlerTest class 
@version : 1.0  
*/
@isTest(seealldata = false)
private class ASC_QuoteTriggerHandlerTest {
    
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
    private static final String SCHEDULEA_EXHIBIT_2 ='Schedule A - Exhibit 2';
    private static final String CONTRACT_AMENDMENT ='Contract Amendment';
    private static final String STOPLOSS_AMENDMENT ='Stop-Loss Amendment';
    private static final String ACTIVE = 'Active';
    private static final String ASC_DOCLANG = 'Active text';
    private static final Id prdCovSpecRecordTypeId = Schema.SObjectType.Product2.getRecordTypeInfosByName().get('Coverage Spec').getRecordTypeId(); 
    private static final Id prdRecordTypeId=Schema.SObjectType.Product2.getRecordTypeInfosByName().get('Product').getRecordTypeId();    
    /*******************************************************************************************************************************
@Description        :   createProductRecords() method 
@Name               :   createProductRecords
@Param              :   None
@Return             :   void
@throws Exception   :   N/A;
********************************************************************************************************************************/ 
    @TestSetup public static  void createQuoteRecords(){
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestAgentAdmin','testsalesrepmail@bcbsm.com','System Administrator');
        database.insert(usr);
        
        Bank_Info__c bankInfo = new Bank_Info__c();
        bankInfo.American_Bank_Association__c ='Test';
        bankInfo.Wire_Number__c='Test';
        bankInfo.Name ='Test';
        insert bankInfo;
        
        Account acc=new Account();
        acc.Name=NAME;
        acc.Phone=PHONE;
        acc.ASC_BCBSM_Bank__c=bankInfo.id;
        acc.ASC_BCN_Bank__c=bankInfo.Id;                
        acc.CID__c=ACCCID;
        acc.Federal_Tax_ID__c=ACCCID;
        acc.Requested_Effective_Date__c=system.today();
        acc.GA_CoverageCancellationDate__c=system.today();        
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
        
        Product2 prod1= new product2(
            Name = 'Data Feeds 1',
            productcode = 'ASC_0000081',
            Family = 'Data Feeds',
            vlocity_ins__LineOfBusiness__c = PRD_LOB,
            vlocity_ins__SubType__c = TYPE,
            vlocity_ins__Type__c = TYPE,
            vlocity_ins__EffectiveDate__c = system.today(),
            RecordTypeId = prdCovSpecRecordTypeId
        );
        insert prod1;
        
        
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
        q.status = 'Draft';
        q.ASC_Carrier__c='BCBSM';
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
        
        QuoteLineItem qli1=new QuoteLineItem();
        qli1.QuoteId = q.Id;
        qli1.product2Id = prod1.Id;
        qli1.UnitPrice = UNIT_PRICE ;
        qli1.Quantity = QUANTY_LI;
        qli1.pricebookentryid = prc.Id;
        Database.insert(qli1,false);
        
        ASC_Document_Language__c docLang = new ASC_Document_Language__c();
        docLang.ASC_Document_Type__c=SCHEDULEA_EXHIBIT_2;
        docLang.ASC_Document_Language_State__c=ACTIVE;
        docLang.ASC_Quote__c=q.id;
        docLang.ASC_Document_Language_Text__c=ASC_DOCLANG;
        docLang.Update_Quote_Specific_Language__c =true;
        Database.insert(docLang,false);
     
        
        ASC_Document_Language__c docLang2 = new ASC_Document_Language__c();
        docLang2.ASC_Document_Type__c=CONTRACT_AMENDMENT;
        docLang2.ASC_Document_Language_State__c=ACTIVE;
        docLang2.ASC_Quote__c=q.id;
        docLang2.ASC_Document_Language_Text__c=ASC_DOCLANG;
        docLang2.Update_Quote_Specific_Language__c =true;
        Database.insert(docLang2,false);
  
        ASC_Document_Language__c docLang4 = new ASC_Document_Language__c();
        docLang4.ASC_Document_Type__c=STOPLOSS_AMENDMENT;
        docLang4.ASC_Document_Language_State__c=ACTIVE;
        docLang4.ASC_Quote__c=q.id;
        docLang4.ASC_Document_Language_Text__c=ASC_DOCLANG;
        docLang4.Update_Quote_Specific_Language__c =true;
        Database.insert(docLang4,false);
      
        
        Test.startTest();            
        
        ASC_QuoteTriggerHandler.beforeUpdate(null,null);       
        Test.stopTest();  
    }
    
    /*******************************************************************************************************************************
@Description        :   createProductRecords() method 
@Name               :   createProductRecords
@Param              :   None
@Return             :   void
@throws Exception   :   N/A;
********************************************************************************************************************************/ 
    private static testMethod void createQuoteRecordsBCN(){
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestAgentAdmin','testsalesrepmail@bcbsm.com','System Administrator');
        database.insert(usr);
        
        Bank_Info__c bankInfo = new Bank_Info__c();
        bankInfo.American_Bank_Association__c ='Test';
        bankInfo.Wire_Number__c='Test';
        bankInfo.Name ='Test';
        insert bankInfo;
        
        Account acc=new Account();
        acc.Name=NAME;
        acc.Phone=PHONE;
        acc.ASC_BCBSM_Bank__c=bankInfo.id;
        acc.ASC_BCN_Bank__c=bankInfo.Id;                
        acc.CID__c=ACCCID;
        acc.Federal_Tax_ID__c=ACCCID;
        acc.Requested_Effective_Date__c=system.today();
        acc.GA_CoverageCancellationDate__c=system.today();        
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
        q.status = 'Draft';
        q.ASC_Carrier__c='BCN';
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
        
        Test.startTest();            
        q.Status ='Accepted';
        update q;
        ASC_QuoteTriggerHandler.beforeUpdate(null,null);
        Test.stopTest();       
        
    }
    private static testMethod void createQuote(){
        List<Quote> quoteList =[select id,status from Quote];
        Opportunity opp = [select id from opportunity limit 1];
        //q1.Status ='Accepted';
        //update q1;
        Id pricebookId = Test.getStandardPricebookId();            
        Quote q = new Quote();
        q.Name = QTNAME;
        q.opportunityId = Opp.Id;
        q.pricebook2Id = pricebookId;
        q.RecordTypeId = qTRecordTypeId;
        q.status = 'Draft';
        q.ASC_Carrier__c='BCBSM';
        //Database.insert(q,false);
        ASC_QuoteTriggerHandler.afterinsert(quoteList);
        ASC_QuoteTriggerHelper.updateQuoteName(quoteList);
    }
    
     private static testMethod void updateQuote(){
        List<Quote> quoteList =[select id,status from Quote];
        Opportunity opp = [select id from opportunity limit 1];
        //q1.Status ='Accepted';
        //update q1;
        Id pricebookId = Test.getStandardPricebookId();            
        Quote q = new Quote();
        q.Name = QTNAME;
        q.opportunityId = Opp.Id;
        q.pricebook2Id = pricebookId;
        q.RecordTypeId = qTRecordTypeId;
        q.status = 'Draft';
        q.ASC_Carrier__c='BCBSM';
        //Database.insert(q,false);        
        Map<Id,Quote> qtoldMap = new Map<Id,Quote>();
        List<Quote> updtqtList = new List<Quote>();
          Id quoteRecordTypeId = Schema.SObjectType.Quote.getRecordTypeInfosByDeveloperName().get('ASC_Quote').getRecordTypeId();
        for(Quote qt:quoteList){
          qt.Status = 'Accepted';
          qt.RecordTypeId = quoteRecordTypeId;
          updtqtList.add(qt);
        }
        
        for(Quote qt1:updtqtList){
          qt1.Status = 'New';
          qtoldMap.put(qt1.Id,qt1);                              
        }
         //Database.update(updtqtList,false);   
        ASC_QuoteTriggerHandler.afterinsert(quoteList);
        ASC_QuoteTriggerHandler.beforeUpdate(quoteList,qtoldMap);
        ASC_QuoteTriggerHandler.afterUpdate(updtqtList,qtoldMap);
    }
    
}