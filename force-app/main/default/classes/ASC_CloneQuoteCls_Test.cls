/**************************************************************************************************************************
@Author : 
@Name: ASC_CloneQuoteCls_Test 
@CreatedDate: 07 Sept 2020
@Description: ASC_CloneQuoteCls_Test class is used to cover ASC_CloneQuoteCls class.
@version : 1.0  
@US Num: US-3587
****************************************************************************************************************************/
@isTest
public class ASC_CloneQuoteCls_Test {
    
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
    private static final Id QTRCRDTYPEID = Schema.SObjectType.Quote.getRecordTypeInfosByName().get(ASC_QTRECTYPE).getRecordTypeId();   
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
    private static final Id PRDCOVSPECID = Schema.SObjectType.Product2.getRecordTypeInfosByName().get('Coverage Spec').getRecordTypeId(); 
    private static final Id PRDRCRDTYPEID=Schema.SObjectType.Product2.getRecordTypeInfosByName().get('Product').getRecordTypeId();    
  /*******************************************************************************************************************************
@Description: This cloneAnySobjet is used to create/update the records in Quote Object records
@Name : cloneAnySobjet
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/  
     
    private static testMethod void cloneAnySobjet(){
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestCompetitr','testsalesrepmail@bcbsm.com','Integration User');
        database.insert(usr);
        system.runAs(usr){
            
            Product2 prd1 = new Product2();
            prd1.vlocity_ins__Type__c = TYPE;
            prd1.ProductCode = PARPRD_CD;
            prd1.IsActive = true;
            prd1.Name = PRODNAME;
            prd1.Family = PARPRD_FAMILY;
            prd1.vlocity_ins__LineOfBusiness__c = PRD_LOB;
            prd1.RecordTypeId = PRDRCRDTYPEID;
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
            acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(ACC_RECORDTYPE).getRecordTypeId();
            Database.insert(acc, false);
            
            Product2 p= new product2(
                Name = PRD_NAME,
                productcode = PRD_CODE,
                Family = PRD_FAMILY,
                vlocity_ins__LineOfBusiness__c = PRD_LOB,
                vlocity_ins__SubType__c = TYPE,
                vlocity_ins__Type__c = TYPE,
                vlocity_ins__EffectiveDate__c = system.today(),
                RecordTypeId = PRDCOVSPECID
            );
            Database.insert(p);
            
            opportunity opp=new opportunity();
            opp.Name = NAME;
            opp.AccountId = acc.id;
            opp.stageName = OPP_STAG;
            opp.CloseDate = system.today()+120;
            opp.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(ASC_OPPRECTYPE).getRecordTypeId();
            Database.insert(opp);
            
            Id pricebookId = Test.getStandardPricebookId();            
            Quote q = new Quote();
            q.Name = QTNAME;
            q.opportunityId = Opp.Id;
            q.pricebook2Id = pricebookId;
            q.RecordTypeId = QTRCRDTYPEID;
            Database.insert(q,false);
            
            pricebookEntry prc=new pricebookEntry ();
            prc.product2Id = p.Id;
            prc.Pricebook2Id = pricebookId;
            prc.UnitPrice = UNIT_PRICE;
            prc.isActive = true;
            Database.insert(prc);
            
            
            Line_Item_Extension__c lie = new Line_Item_Extension__c();
            lie.name = 'TestLie';
            lie.Quantity__c = 5;
            Database.insert(lie);
            
            QuoteLineItem qli=new QuoteLineItem();
            qli.QuoteId = q.Id;
            qli.product2Id = p.Id;
            qli.UnitPrice = UNIT_PRICE ;
            qli.Quantity = QUANTY_LI;
            qli.pricebookentryid = prc.Id;
            qli.ASC_Line_Item_Extension__c=lie.id;
            Database.insert(qli,false);  
            
            QuoteLineItem qli1=new QuoteLineItem();
            qli1.QuoteId = q.Id;
            qli1.product2Id = prd1.Id;
            qli1.UnitPrice = UNIT_PRICE ;
            qli1.Quantity = QUANTY_LI;
            qli1.pricebookentryid = prc.Id;
            qli1.ASC_Line_Item_Extension__c=lie.id;
            qli1.vlocity_ins__ParentItemId2__c=qli.id;
            Database.insert(qli1,false);    
            
            if(q.id !=null){
                ASC_CloneQuoteCls.cloneAnySobjet(q.id);
            }
            ASC_CloneQuoteCls.fetchQuoteClone();
            
            // ASC_CloneQuoteCls.cloneLineItemExtensionRecords('Line_Item_Extension__c',lie.Id);
            
            
            system.assert(usr <> null);
        }
    }
 /*******************************************************************************************************************************
@Description: This copyFileRecords is used to create/update the records in Quote Object records
@Name : copyFileRecords
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/  
     
    private static testMethod void copyFileRecords(){
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestCompetitr','testsalesrepmail@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr){
            
            Product2 prd1 = new Product2();
            prd1.vlocity_ins__Type__c = TYPE;
            prd1.ProductCode = PARPRD_CD;
            prd1.IsActive = true;
            prd1.Name = PRODNAME;
            prd1.Family = PARPRD_FAMILY;
            prd1.vlocity_ins__LineOfBusiness__c = PRD_LOB;
            prd1.RecordTypeId = PRDRCRDTYPEID;
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
            acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(ACC_RECORDTYPE).getRecordTypeId();
            Database.insert(acc);
            
            Product2 p= new product2(
                Name = PRD_NAME,
                productcode = PRD_CODE,
                Family = PRD_FAMILY,
                vlocity_ins__LineOfBusiness__c = PRD_LOB,
                vlocity_ins__SubType__c = TYPE,
                vlocity_ins__Type__c = TYPE,
                vlocity_ins__EffectiveDate__c = system.today(),
                RecordTypeId = PRDCOVSPECID
            );
            Database.insert(p);
            
            opportunity opp=new opportunity();
            opp.Name = NAME;
            opp.AccountId = acc.id;
            opp.stageName = OPP_STAG;
            opp.CloseDate = system.today()+120;
            opp.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(ASC_OPPRECTYPE).getRecordTypeId();
            Database.insert(opp);
            
            Id pricebookId = Test.getStandardPricebookId();            
            Quote q = new Quote();
            q.Name = QTNAME;
            q.opportunityId = Opp.Id;
            q.pricebook2Id = pricebookId;
            q.RecordTypeId = QTRCRDTYPEID;
            Database.insert(q);
            ContentVersion cntvs = new ContentVersion();
            cntvs.Title = 'TestCV';
            cntvs.PathOnClient = 'TestCV.jpg';
            cntvs.VersionData = Blob.valueOf('Test Content');
            cntvs.IsMajorVersion = true;
            cntvs.GA_Type__c ='Email';
            Database.insert(cntvs) ;
            
            ContentVersion contentVersionSelect = [SELECT Id, Title, ContentDocumentId FROM ContentVersion WHERE Id = :cntvs.Id LIMIT 1];
            
            List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument Limit 200];
            
            
            ContentDocumentLink cdl = New ContentDocumentLink();
            cdl.LinkedEntityId = q.id;
            cdl.ContentDocumentId = documents[0].Id;
            cdl.shareType = 'V';
            Database.insert(cdl);   
            
            ASC_CloneQuoteCls.cloneAnySobjet(q.id);
            
            system.assert(usr <> null);
        }
    }
/*******************************************************************************************************************************
@Description: 
@Name : testmethod1
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/  
   
    static testmethod void testMethod1(){
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('Test','testm@bcbsm.com','BCBSM Read Only');
        database.insert(usr);
        system.runAs(usr)
        {
            try{
                ASC_CloneQuoteCls.fetchQuoteClone();
                ASC_CloneQuoteCls.copyFileLinksFromParentQuote(null,null);
            }
            catch(exception e)
            {
                system.assert(e <> null);
                return;
            }
        }
    }
}