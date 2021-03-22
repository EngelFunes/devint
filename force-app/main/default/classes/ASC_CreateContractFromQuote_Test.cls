/**************************************************************************************************************************
@Author :
@Name:ASC_CreateContractFromQuote_Test class is used to cover ASC_CreateContractFromQuote
@CreatedDate: 31-Aug-2020
@Description: ASC_CreateContractFromQuote_Test class is used to cover ASC_CreateContractFromQuote
@version : 1.0 
@US Num:
****************************************************************************************************************************/
@isTest(seealldata = false)
public class ASC_CreateContractFromQuote_Test {
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
    private static final string PRD_NAME1 = 'Data Feeds 1';
    private static final string PRD_CODE = 'ASC_0000370';
    private static final string PRD_CODE1 = 'ASC_0000160';
    private static final string PRD_FAMILY = 'Admin Fees';
    private static final string PRD_FAMILY1 = 'Data Feeds';
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
    private static final String DRAFT = 'Draft';
    private static final String BCBSM = 'BCBSM';
    private static final String BCN = 'BCN';
    private static final String ACCEPTED = 'Accepted';
    private static final string ROLE_NAM = 'TestIntUser';
    private static final string EMAILVAL = 'testIntUser@bcbsm.com';
    private static final string PROF_NAM = 'Integration User';
    private static final String ASC_DOCLANG = 'Active text';
    private static final Id prdCovSpecRecordTypeId = Schema.SObjectType.Product2.getRecordTypeInfosByName().get('Coverage Spec').getRecordTypeId(); 
    private static final Id prdRecordTypeId=Schema.SObjectType.Product2.getRecordTypeInfosByName().get('Product').getRecordTypeId();    
    /*******************************************************************************************************************************
@Description: initData() method - preparing the test data
@Name : initData
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/ 
    @TestSetup static void initData(){
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec(ROLE_NAM,EMAILVAL,PROF_NAM);
        database.insert(usr);
        
        Bank_Info__c bankInfo = new Bank_Info__c();
        bankInfo.American_Bank_Association__c =NAME;
        bankInfo.Wire_Number__c=NAME;
        bankInfo.Name =NAME;
        Database.insert(bankInfo,false);
        
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
        Database.insert(acc,false);
        
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
        Database.insert(p,false);  
        
        Product2 prod1= new product2(
            Name = PRD_NAME1,
            productcode = PRD_CODE1,
            Family = PRD_FAMILY1,
            vlocity_ins__LineOfBusiness__c = PRD_LOB,
            vlocity_ins__SubType__c = TYPE,
            vlocity_ins__Type__c = TYPE,
            vlocity_ins__EffectiveDate__c = system.today(),
            RecordTypeId = prdCovSpecRecordTypeId
        );
        Database.insert(prod1,false);  
        
        opportunity opp=new opportunity();
        opp.Name = NAME;
        opp.AccountId = acc.id;
        opp.stageName = OPP_STAG;
        opp.CloseDate = system.today()+120;
        opp.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(ASC_OPPRECTYPE).getRecordTypeId();
        Database.insert(opp,false);  
        
        Id pricebookId = Test.getStandardPricebookId();            
        Quote q = new Quote();
        q.Name = QTNAME;
        q.opportunityId = Opp.Id;
        q.pricebook2Id = pricebookId;
        q.RecordTypeId = qTRecordTypeId;
        q.status = DRAFT;
        q.ASC_Carrier__c=BCBSM;
        Database.insert(q,false);
        
        Quote q1 = new Quote();
        q1.Name = QTNAME;
        q1.opportunityId = Opp.Id;
        q1.pricebook2Id = pricebookId;
        q1.RecordTypeId = qTRecordTypeId;
        q1.status = DRAFT;
        q1.ASC_Carrier__c=BCN;
        Database.insert(q1,false);
        
        pricebookEntry prc=new pricebookEntry ();
        prc.product2Id = p.Id;
        prc.Pricebook2Id = pricebookId;
        prc.UnitPrice = UNIT_PRICE;
        prc.isActive = true;
        Database.insert(prc,false);  
        List<QuoteLineItem> qliList=new List<QuoteLineItem>();
        
        QuoteLineItem qli=new QuoteLineItem();
        qli.QuoteId = q.Id;
        qli.product2Id = p.Id;
        qli.UnitPrice = UNIT_PRICE ;
        qli.Quantity = QUANTY_LI;
        qli.pricebookentryid = prc.Id;
        qliList.add(qli);
        
        QuoteLineItem qli1=new QuoteLineItem();
        qli1.QuoteId = q.Id;
        qli1.product2Id = prod1.Id;
        qli1.UnitPrice = UNIT_PRICE ;
        qli1.Quantity = QUANTY_LI;
        qli1.pricebookentryid = prc.Id;
        qliList.add(qli1);
        
        QuoteLineItem qli2=new QuoteLineItem();
        qli2.QuoteId = q1.Id;
        qli2.product2Id = p.Id;
        qli2.UnitPrice = UNIT_PRICE ;
        qli2.Quantity = QUANTY_LI;
        qli2.pricebookentryid = prc.Id;
        qliList.add(qli2);
        
        QuoteLineItem qli3=new QuoteLineItem();
        qli3.QuoteId = q1.Id;
        qli3.product2Id = prod1.Id;
        qli3.UnitPrice = UNIT_PRICE ;
        qli3.Quantity = QUANTY_LI;
        qli3.pricebookentryid = prc.Id;
        qliList.add(qli3);
        Database.insert(qliList,false);  
        
        List<ASC_Document_Language__c> docList=new List<ASC_Document_Language__c>();
        
        ASC_Document_Language__c docLang = new ASC_Document_Language__c();
        docLang.ASC_Document_Type__c=SCHEDULEA_EXHIBIT_2;
        docLang.ASC_Document_Language_State__c=ACTIVE;
        docLang.ASC_Quote__c=q.id;
        docLang.ASC_Document_Language_Text__c=ASC_DOCLANG;
        docList.add(docLang);
        ASC_Document_Language__c docLang1 = new ASC_Document_Language__c();
        docLang1.ASC_Document_Type__c=SCHEDULEA_EXHIBIT_2;
        docLang1.ASC_Document_Language_State__c=ACTIVE;
        docLang1.ASC_Quote__c=q1.id;
        docLang1.ASC_Document_Language_Text__c=ASC_DOCLANG;
        docList.add(docLang1);
        
        ASC_Document_Language__c docLang2 = new ASC_Document_Language__c();
        docLang2.ASC_Document_Type__c=CONTRACT_AMENDMENT;
        docLang2.ASC_Document_Language_State__c=ACTIVE;
        docLang2.ASC_Quote__c=q.id;
        docLang2.ASC_Document_Language_Text__c=ASC_DOCLANG;
        docList.add(docLang2);
        
        ASC_Document_Language__c docLang3 = new ASC_Document_Language__c();
        docLang3.ASC_Document_Type__c=CONTRACT_AMENDMENT;
        docLang3.ASC_Document_Language_State__c=ACTIVE;
        docLang3.ASC_Quote__c=q1.id;
        docLang3.ASC_Document_Language_Text__c=ASC_DOCLANG;
        docList.add(docLang3);
        
        ASC_Document_Language__c docLang4 = new ASC_Document_Language__c();
        docLang4.ASC_Document_Type__c=STOPLOSS_AMENDMENT;
        docLang4.ASC_Document_Language_State__c=ACTIVE;
        docLang4.ASC_Quote__c=q.id;
        docLang4.ASC_Document_Language_Text__c=ASC_DOCLANG;
        docList.add(docLang4);
        
        ASC_Document_Language__c docLang5 = new ASC_Document_Language__c();
        docLang5.ASC_Document_Type__c=STOPLOSS_AMENDMENT;
        docLang5.ASC_Document_Language_State__c=ACTIVE;
        docLang5.ASC_Quote__c=q1.id;
        docLang5.ASC_Document_Language_Text__c=ASC_DOCLANG;
        docList.add(docLang5); 
        Database.insert(docList,false);  
        
    }
    /*******************************************************************************************************************************
@Description        :   createProductRecords() method 
@Name               :   createProductRecords
@Param              :   None
@Return             :   void
@throws Exception   :   N/A;
********************************************************************************************************************************/ 
    
    private static testmethod void createQuoteRecords(){ 
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestSysAdm','testsysadm@bcbsm.com','System Administrator');
        database.insert(usr);
        
        system.runAs(usr)
        {
            try{
                Test.startTest();            
                
                ASC_CreateContractFromQuote.createContractFrmQuote(null,null);
                List<Quote> Qlist=[select id,Name,status from quote where Status like'%Draft%'];
                Map<id,Quote> oldmap = new Map<id,Quote>();
                oldmap.put(Qlist[0].id,Qlist[0]);
                oldmap.put(Qlist[1].id,Qlist[1]);
                
                Qlist[0].Status=ACCEPTED;
                Qlist[1].Status=ACCEPTED;
                Database.update(Qlist);
                
                ASC_CreateContractFromQuote.createContractFrmQuote(Qlist,oldmap);
                
                Test.stopTest(); 
            }
            catch(exception e)
            {
                system.assert(e <> null);
                return;
            }
        }
    }
    /*******************************************************************************************************************************
@Description        :   createProductRecords1() method 
@Name               :   createProductRecords
@Param              :   None
@Return             :   void
@throws Exception   :   N/A;
********************************************************************************************************************************/ 
    
    private static testmethod void createQuoteRecords1(){ 
        try{
            user usr = GA_OBJ_TD01_TestDataCreation.UsrRec(ROLE_NAM,EMAILVAL,PROF_NAM);
            database.insert(usr);
            system.runAs(usr){
                test.startTest();
                ASC_CreateContractFromQuote.createContractualDocuments(null,null,null,null);
                ASC_CreateContractFromQuote.PopulateBankInfo(null,null,null);
                ASC_CreateContractFromQuote.buildContractProps(null,null);
                ASC_CreateContractFromQuote.buildInsertContractLineProps(null,null,null);  
                ASC_CreateContractFromQuote.createContractFrmQuote(null,null);
ASC_CreateContractFromQuote.cloneFilesFromContractualDocument(null,null);
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