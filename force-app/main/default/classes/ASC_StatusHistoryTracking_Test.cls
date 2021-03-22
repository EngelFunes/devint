/**************************************************************************************************************************
@Author :IDC__Off Shore
@Name:ASC_StatusHistoryTracking
@CreatedDate:sep 17-2020
@Description: ASC_StatusHistoryTracking_Test is  test class for the class ASC_StatusHistoryTracking
@version :  
@US Num:
****************************************************************************************************************************/
@isTest(seealldata = false)

public class ASC_StatusHistoryTracking_Test {
    
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
    private static final String OPP_RECORDTYPE ='ASC_Quote';
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
    private static final String CANCELLED ='Cancelled';
    private static final String GRUP ='Group';
    private static final String FINALSUBMTD='Final Submitted';
    private static final string SUBMITED='Submitted';
    private static final string ROLE_NAM = 'TestIntUser';
    private static final string EMAILVAL = 'testIntUser@bcbsm.com';
    private static final string PROF_NAM = 'Integration User';
    private static final String ASC_DOCLANG = 'Active text';
    private static final string CONT_RECORDTYPE  ='ASC Contract';
    private static final string OPP_RECRDTYPE = 'Opportunity_ASC';
    
    private static final String STATUS = 'Status';
    private static final String STAGENAME = 'new';
    private static final String REVIEW = 'Needs Review';
            private static final string ASC_CONT = 'ASC Contract';  
    private static final Id prdCovSpecRecordTypeId = Schema.SObjectType.Product2.getRecordTypeInfosByName().get('Coverage Spec').getRecordTypeId(); 
    private static final Id prdRecordTypeId=Schema.SObjectType.Product2.getRecordTypeInfosByName().get('Product').getRecordTypeId();    
   private static final Id ASCCON_RECID = Schema.SObjectType.Contract.getRecordTypeInfosByName().get(ASC_CONT).getRecordTypeId(); 
   
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
        
        //Create Account
        Account newAcc1 = new Account();
        newAcc1.Name = NAME;
        newAcc1.CID__c = ACCCID;
        database.insert (newAcc1);
        
        //Create Opportunity
        Id OPP_ASC_RECTYPEID = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(OPP_RECRDTYPE).getRecordTypeId();
        List<Opportunity> newOpps = new List<Opportunity>();
        Opportunity opp1 = new Opportunity();
        opp1.Name = NAME;
        opp1.AccountId = newAcc1.Id;
        opp1.StageName = STAGENAME;
        opp1.CloseDate = Date.valueOf('2020-11-16');
        opp1.RecordTypeId = OPP_ASC_RECTYPEID;
        //database.insert(opp1);
        newOpps.add(opp1);
        insert (newOpps);
        //database.insert(List<Opportunity> newOpps);
                
        //Create Quotes
        Id ASC_QUOTE_RECTYPEID = Schema.SObjectType.Quote.getRecordTypeInfosByDeveloperName().get(OPP_RECORDTYPE).getRecordTypeId();
        List<Quote> newQuotes = new List<Quote>();
        Quote qt1 = new Quote();
        qt1.Name = NAME;
        qt1.OpportunityId = newOpps.get(0).Id;
        qt1.Status = DRAFT;
        qt1.RecordTypeId = ASC_QUOTE_RECTYPEID;
        newQuotes.add(qt1);
        
        Quote qt2 = new Quote();
        qt2.Name = NAME;
        qt2.OpportunityId = newOpps.get(0).Id;
        qt2.Status = DRAFT;
        qt2.RecordTypeId = ASC_QUOTE_RECTYPEID;
        newQuotes.add(qt2);
        insert newQuotes;
        //setup data end
        
        opportunity opp=new opportunity();
        opp.Name = NAME;
        opp.AccountId = acc.id;
        opp.stageName = OPP_STAG;
        opp.CloseDate = system.today()+120;
        opp.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(ASC_OPPRECTYPE).getRecordTypeId();
        Database.insert(opp,false);  
        opp.ASC_Sub_stage__c='Initial Doc Underway';
        update opp;
        
        Id pricebookId = Test.getStandardPricebookId();            
        Quote q = new Quote();
        q.Name = QTNAME;
        q.opportunityId = Opp.Id;
        q.pricebook2Id = pricebookId;
        q.RecordTypeId = qTRecordTypeId;
        q.CreatedDate=DateTime.Now();
        q.vlocity_ins__EndDate__c=system.today(); 
        q.status = DRAFT;
        q.ASC_Carrier__c=BCBSM;
        Database.insert(q,false);
        q.status ='Approved';
        //update q;
        Database.update(q,false);
        
        Quote q1 = new Quote();
        q1.Name = QTNAME;
        q1.opportunityId = Opp.Id;
        q1.pricebook2Id = pricebookId;
        q1.RecordTypeId = qTRecordTypeId;
        q1.status = DRAFT;
        q1.ASC_Carrier__c=BCN;
        Database.insert(q1,false);
        q1.status ='Approved';
        //update q1;
        Database.update(q1,false);
        
        Contract cont1 = new Contract();
        cont1.AccountId=acc.Id;
        cont1.Status=DRAFT;
        cont1.vlocity_ins__QuoteId__c=q1.id;
        //cont1.Status=STATUS;
        cont1.StartDate=Date.today();
        cont1.RecordTypeId=Schema.SObjectType.Contract.getRecordTypeInfosByName().get(CONT_RECORDTYPE).getRecordTypeId();
        cont1.ASC_Signature_Status__c = 'Group';
        cont1.ASC_Invoice_Setup__c = 'New';
        insert cont1;
        
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
                        
        vlocity_ins__ContractLineItem__c plan2 = new vlocity_ins__ContractLineItem__c();
        plan2.vlocity_ins__Product2Id__c=prod1.Id;
        plan2.ASC_Effective_Start_Date__c=system.today();
        plan2.ASC_AAC_PCNT__c=10.00;
        plan2.vlocity_ins__ContractId__c=cont1.id;        
        insert plan2;
        
    }
    
    /*******************************************************************************************************************************
    @Description: testMethod1() for the update contracts
    @Name : testMethod1
    @Param : None
    @Return : void
    @throws Exception : N/A;
    ********************************************************************************************************************************/    
    private static testmethod void testMethod1(){
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestSysAdm','testsysadm@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr){
            try{
                List<Contract> conts=[select id,ASC_Signature_Status__c,Status  from Contract];
                System.debug(conts);
                List<ASC_Contract_Opp_Stage_Mapping__mdt> testConQuoteOpp = (List<ASC_Contract_Opp_Stage_Mapping__mdt>)Json.deserialize('[{"Input_Object_Name1__c": "Contract","Input_Field_Name1__c": "Status","Input_Field_Name1_Value__c" : "Accepted"}]', List<ASC_Contract_Opp_Stage_Mapping__mdt>.class);
                
                List<Quote> quotes=[select id,Status  from Quote];
                quotes[0].Status='Presented';
                update quotes;
                vlocity_ins__ContractLineItem__c plans=[select id,ASC_Activation_Status__c  from vlocity_ins__ContractLineItem__c limit 1];
                plans.ASC_Activation_Status__c = SUBMITED;
                update plans;
                ASC_StatusHistoryTracking.createUpdateStatusHistoryTracking(null,null,null);               
            }
            
            catch(exception e){
                system.assert(e <> null);
                return;
            } 
        } 
    }
}