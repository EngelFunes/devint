/**************************************************************************************************************************
@Author : Dinesh
@Name: ASC_ContractRenewalQuoteCreation_Test 
@CreatedDate: 23 Apr 2020
@Description: ASC_ContractRenewalQuoteCreation_Test class is used to cover ASC_ContractRenewalQuoteCreation class
@version : 1.0  
****************************************************************************************************************************/
@isTest(seealldata = false)
private class ASC_ContractRenewalQuoteCreation_Test {
    
    private static final string TYPE  ='ASC Product';
    private static final string PRODNAME  ='TEST Product';
    private static final string NAME='TEST'; 
    private static final string PHONE='9876543211';    
    private static final string ASC_QTRECTYPE = 'ASC Quote';
    private static final string RENW_YEAR = 'JustCatch';//value: 2021
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
    private static final string COV_SPEC = 'Coverage Spec';
    private static final string PRODT = 'Product';
    private static final string ASC_CONT = 'ASC Contract';  
    private static final Id PRDRECTYPID=
    Schema.SObjectType.Product2.getRecordTypeInfosByName().get(PRODT).getRecordTypeId();   
    private static final Id ASCCON_RECID = Schema.SObjectType.Contract.getRecordTypeInfosByName().get(ASC_CONT).getRecordTypeId(); 
    private static final string ROLE_NAM = 'TestUser';
    private static final string EMAILVAL = 'testUser@bcbsm.com';
    private static final string PROF_NAM = 'System Administrator';
    private static final Id PRDCOVSPECRECTYPEID = 
    Schema.SObjectType.Product2.getRecordTypeInfosByName().get(COV_SPEC).getRecordTypeId(); 
    private static final string CARR_BCN = 'BCN';
    private static final string DRAFT_STR = 'Draft';
    private static final string DATE_ST = '05/05/2021';
    private static final string DATE_END = '06/06/2021';
    /*******************************************************************************************************************************
    @Description: initData() method - preparing the test data
    @Name : initData
    @Param : None
    @Return : void
    @throws Exception : N/A;
    ********************************************************************************************************************************/
     @TestSetup static void initData(){
            
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
         acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(ACC_RECORDTYPE).getRecordTypeId();
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
         opp.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(ASC_OPPRECTYPE).getRecordTypeId();
         Database.insert(opp,false);
         
         user usr = GA_OBJ_TD01_TestDataCreation.UsrRec(ROLE_NAM,EMAILVAL,PROF_NAM);
         database.insert(usr);
         
         Id pricebookId = Test.getStandardPricebookId();
         Quote quot = ARV_AP05_TestDataCreation.quoteRec1(opp.Id,pricebookId,usr.Id);
         database.insert(quot);
          
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
            
         Account testAccount = GA_OBJ_TD01_TestDataCreation.AccRec();
         database.insert(testAccount);
         
         Contract cntrcRcrd = new Contract ();
         cntrcRcrd.AccountId = acc.Id;
         cntrcRcrd.ASC_Carrier__c = CARR_BCN;
         cntrcRcrd.Status = DRAFT_STR;
         cntrcRcrd.StartDate = system.today();
         cntrcRcrd.recordtypeid = ASCCON_RECID;
         database.insert(cntrcRcrd);
         
         Contract cntrcRcrd1 = new Contract ();
         cntrcRcrd1.AccountId = acc.Id;
         cntrcRcrd.ASC_Carrier__c = CARR_BCN;
         cntrcRcrd1.Status = DRAFT_STR;
         cntrcRcrd1.StartDate = system.today();
         cntrcRcrd1.recordtypeid = ASCCON_RECID;
         database.insert(cntrcRcrd1);
         Contract cntrcRcrd2 = new Contract ();
         cntrcRcrd2.AccountId = acc.Id;
         cntrcRcrd2.Status = DRAFT_STR;
         cntrcRcrd2.StartDate = system.today();
         cntrcRcrd2.recordtypeid = ASCCON_RECID;
         database.insert(cntrcRcrd2);
    }
    /*******************************************************************************************************************************
    @Description: This test method is used to cover the create quote and getquote details method.
    @Name : testmethod1
    @Param : None
    @Return : void
    @throws Exception : N/A;
    ********************************************************************************************************************************/
    public static testmethod void testmethod1(){ 
     try{
       	user usr = GA_OBJ_TD01_TestDataCreation.UsrRec(ROLE_NAM,EMAILVAL,PROF_NAM);
       	database.insert(usr);
        system.runAs(usr){
        test.startTest();
       	Contract contr = [Select Id,Status,CID__c,ASC_Carrier__c from Contract
                          where RecordTypeId =:ASCCON_RECID Limit 1]; 
        ASC_ContractRenewalQuoteCreation.getQuoteDetails(RENW_YEAR,contr.Id);
        ASC_ContractRenewalQuoteCreation.createQuote(contr.Id,RENW_YEAR,DATE_ST,DATE_END);
        ASC_ContractRenewalQuoteCreation.validateContractDetails(contr.Id);  
        test.stopTest(); 
            system.assert(contr <> null);
        }
      }
      catch(exception e)
      {
            system.assert(e <> null);
            return;
      }
    }   
    /*******************************************************************************************************************************
    @Description: This test method is used to cover the Contract Data in validateContractDetails method.
    @Name : testmethod2
    @Param : None
    @Return : void
    @throws Exception : N/A;
    ********************************************************************************************************************************/
    public static testmethod void testmethod2(){ 
     try{
         user usr = GA_OBJ_TD01_TestDataCreation.UsrRec(ROLE_NAM,EMAILVAL,PROF_NAM);
         database.insert(usr);
         system.runAs(usr){
         test.startTest();
             Contract contr = [Select Id,Status,CID__c,ASC_Carrier__c from Contract 
                               where RecordTypeId =:ASCCON_RECID and
                               ASC_Carrier__c = null Limit 1];                
             ASC_ContractRenewalQuoteCreation.validateContractDetails(contr.Id);
             ASC_ContractRenewalQuoteCreation.validateContractDetails(null);
         test.stopTest();
             system.assert(contr <> null);

         }
     }
     catch(exception e)
     {
            system.assert(e <> null);
            return;
     }      
   }
    /*******************************************************************************************************************************
    @Description: This test method is used to cover the Contract Data in validateContractDetails method.
    @Name : testmethod3
    @Param : None
    @Return : void
    @throws Exception : N/A;
    ********************************************************************************************************************************/
    public static testmethod void testmethod3(){ 
       try{
         user usr = GA_OBJ_TD01_TestDataCreation.UsrRec(ROLE_NAM,EMAILVAL,PROF_NAM);
         database.insert(usr);
        PermissionSet prmsnSet =  [SELECT Id FROM PermissionSet WHERE Name = 'ASC_Sales_Specialist' ];
        
        PermissionSetAssignment prmsnSetAsgnmnt = new PermissionSetAssignment(
            AssigneeId = usr.Id,
            PermissionSetId = prmsnSet.Id
        );
        database.insert(prmsnSetAsgnmnt);
         system.runAs(usr){
         test.startTest();
             Contract contr = [Select Id,Status,CID__c,ASC_Carrier__c from Contract 
                               where RecordTypeId =:ASCCON_RECID and
                               ASC_Carrier__c = null Limit 1];                
             ASC_ContractRenewalQuoteCreation.validateContractDetails(contr.Id);
         test.stopTest();
             system.assert(contr <> null);


       	}
     }
     catch(exception e)
     {
            system.assert(e <> null);
            return;
     }      
   }
}