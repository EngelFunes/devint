/**************************************************************************************************************************
@Author : off shore
@Name:ASC_DocusignParticipentValidationsTest 
@CreatedDate: 29 Jan 2021
@Description: ASC_DocusignParticipentValidationsTest class is used to cover ASC_DocusignParticipentValidations class.
@version : 1.0  
@US Num: 
****************************************************************************************************************************/
@isTest(seealldata = false)
private class ASC_DocusignParticipentValidationsTest {

    private static final string TYPE  ='ASC Product';
    private static final string PRODNAME  ='TEST Product';
    private static final string NAME='TEST'; 
    private static final string NAME1='TEST1'; 
    private static final string PHONE='+1 9876543211';    
    private static final string ASC_QTRECTYPE = 'ASC Quote';
    private static final string RENW_YEAR = '2021';
    private static final string CONTXID = 'ContextId';
     private static final string TESTAOR='TestAor';
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
     private static final string FIRST  ='First';
    private static final string LAST = 'last';
    private static final string VOIDED = 'voided';
    private static final string PARPRD_CD = 'ASC_0000005';
    private static final string PARPRD_FAMILY = 'Medical';
    private static final string COV_SPEC = 'Coverage Spec';
    private static final string PRODT = 'Product';
    private static final string ASC_CONT = 'ASC Contract'; 
     private static final string BASE_ASC_CONTRACT ='Base ASC Contract';
    private static final string GROUPSIGNED ='Group Signed Package';
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
    public static final Id ASC_SIGNER_RECTYPEID = 
        Schema.SObjectType.DocuSign_Participant__c.getRecordTypeInfosByName().get('Group Signer').getRecordTypeId();
    public static final Id AGENT_RECTYPEID = 
        Schema.SObjectType.DocuSign_Participant__c.getRecordTypeInfosByName().get('Agent').getRecordTypeId();
    public static final Id SEGOWNER_RECTYPEID = 
        Schema.SObjectType.DocuSign_Participant__c.getRecordTypeInfosByName().get('Segment Owner').getRecordTypeId();
    private static final string DOCTYPE2='Stop-Loss Amendment';
    private static final string DOCSOURCE='Salesforce Generated';
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
        contact cont = new Contact();
        cont.FirstName = FIRST;
        cont.LastName =LAST;
        cont.phone=PHONE;
        cont.recordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact').getRecordTypeId();
        cont.AccountId = acc.Id;
        insert Cont;
        
        contact cnt = new Contact();
        cnt.AccountId = acc.Id;
        cnt.FirstName = FIRST ;
        cnt.LastName = LAST;
        cnt.recordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact - Agent').getRecordTypeId();
        database.insert(cnt);
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
        
        Id pricebookId = Test.getStandardPricebookId();                                    
        Quote quot = new Quote();
        quot.Name = QTNAME;
        quot.opportunityId = Opp.Id;
        quot.pricebook2Id = pricebookId;
        quot.RecordTypeId = QTRECTYPID;
        quot.ASC_CID__c = ACCCID;
        quot.ASC_Carrier__c = CARR_BCN;
        quot.ASC_Renewal_Year__c = RENW_YEAR;
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
        
        Account testAccount = GA_OBJ_TD01_TestDataCreation.AccRec();
        database.insert(testAccount);
        
        Contract cntrcRcrd = new Contract ();
        cntrcRcrd.AccountId = acc.Id;
        cntrcRcrd.ASC_Carrier__c = CARR_BCN;
        cntrcRcrd.Status = DRAFT_STR;
        cntrcRcrd.ASC_Signature_Status__c=VOIDED;
        cntrcRcrd.StartDate = system.today();
        cntrcRcrd.recordtypeid = ASCCON_RECID;
        database.insert(cntrcRcrd);
        Contract cntrcRcrd1 = new Contract ();
        cntrcRcrd1.AccountId = acc.Id;
        cntrcRcrd1.ASC_Carrier__c = CARR_BCN;
        cntrcRcrd1.Status = DRAFT_STR;
        cntrcRcrd1.ASC_Signature_Status__c=VOIDED;
        cntrcRcrd1.StartDate = system.today();
        cntrcRcrd1.recordtypeid = ASCCON_RECID;
        database.insert(cntrcRcrd1);
        GA_Aor__C aorRec = New GA_Aor__C();
        aorRec.Name =TESTAOR;
        aorRec.GA_Account_Id__c = acc.id;
        aorRec.GA_Contact_Id__c =cnt.id ;
        insert aorRec;
        DocuSign_Participant__c docu=new DocuSign_Participant__c();
        docu.recordtypeid=ASC_SIGNER_RECTYPEID;
        docu.Name=NAME;
        docu.Contact__c=cont.id;
        docu.Contract__c=cntrcRcrd.id;
        insert docu;
        DocuSign_Participant__c docu1=new DocuSign_Participant__c();
        docu1.recordtypeid=AGENT_RECTYPEID;
        docu1.Name=NAME1;
        docu1.Agent__c=cnt.id;
        docu1.Contract__c=cntrcRcrd.id;
        insert docu1;
        DocuSign_Participant__c docu2=new DocuSign_Participant__c();
        docu2.recordtypeid=SEGOWNER_RECTYPEID;
        docu2.Name=NAME1;
        docu2.Segment_Owner__c=usr.id;
        docu2.Contract__c=cntrcRcrd.id;
        insert docu2;
        ASC_Contractual_Document__c cntrcDocRcd = new ASC_Contractual_Document__c();
        cntrcDocRcd.Name = NAME;
        cntrcDocRcd.ASC_Do_Not_Include__c = False;
        cntrcDocRcd.Document_Source__c =DOCSOURCE;
        cntrcDocRcd.ASC_Contract__c = cntrcRcrd.id;
        cntrcDocRcd.ASC_Document_Type__c =BASE_ASC_CONTRACT;
        database.insert (cntrcDocRcd);
        ASC_Contractual_Document__c cntrcDocRcd1 = new ASC_Contractual_Document__c();
        cntrcDocRcd1.Name = NAME;
        cntrcDocRcd1.ASC_Do_Not_Include__c = False;
        cntrcDocRcd1.Document_Source__c =DOCSOURCE;
        cntrcDocRcd1.ASC_Contract__c = cntrcRcrd.id;
        cntrcDocRcd1.ASC_Document_Type__c =GROUPSIGNED;
        database.insert (cntrcDocRcd1);
        ContentVersion cntvs = new ContentVersion();
        cntvs.Title = 'TestCV_SGen';
        cntvs.PathOnClient = 'TestCV.jpg';
        cntvs.VersionData = Blob.valueOf('Test Content');
        cntvs.IsMajorVersion = true;
        cntvs.GA_Type__c ='Email';
        Database.insert(cntvs) ;
        ContentVersion contentVersionSelect = [SELECT Id, Title, ContentDocumentId FROM ContentVersion WHERE Id = :cntvs.Id LIMIT 1];
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument Limit 200];
        List<ContentDocumentLink> contentDocLink = [SELECT ContentDocumentId FROM ContentDocumentLink where LinkedEntityId = :cntrcDocRcd1.Id 
                                                    and LinkedEntity.Type='ASC_Contractual_Document__c' limit 100];
        
      
        ContentDocumentLink cd2 = New ContentDocumentLink();
        cd2.LinkedEntityId =cntrcDocRcd1.id;
        cd2.ContentDocumentId = documents[0].Id;
        cd2.shareType = 'V';
        //Database.insert(cd2);
    }
  /*******************************************************************************************************************************
    @Description: 
    @Name : testmethod1
    @Param : None
    @Return : void
    @throws Exception : N/A;
    ********************************************************************************************************************************/    
    public static testmethod void testmethod1(){ 
        Map<String,Object> inputMap = new Map<String,Object>();
        Map<String,Object> outMap = new Map<String,Object>();
        Map<String,Object> options = new Map<String,Object>();
        try{
            user usr = GA_OBJ_TD01_TestDataCreation.UsrRec(ROLE_NAM,EMAILVAL,PROF_NAM);
            database.insert(usr);
            system.runAs(usr){
                
                Contract contr = [Select Id,Status,CID__c,ASC_Carrier__c from Contract
                                  where RecordTypeId =:ASCCON_RECID Limit 1];            
                inputMap.put('ContextId',contr.id); 
                ASC_DocusignParticipentValidations dsc =new ASC_DocusignParticipentValidations();
                dsc.invokeMethod('throwValidations',inputMap,outMap,NULL);
                dsc.invokeMethod('showEmailContent',inputMap,outMap,NULL);
                dsc.invokeMethod('sendEnvelopeValidations',inputMap,outMap,NULL);
              //  dsc.invokeMethod('createDeleteConDocs',inputMap,outMap,NULL);
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
    @Description: 
    @Name : testmethod2
    @Param : None
    @Return : void
    @throws Exception : N/A;
    ********************************************************************************************************************************/    
    public static testmethod void testmethod2(){ 
        Map<String,Object> inputMap = new Map<String,Object>();
        Map<String,Object> outMap = new Map<String,Object>();
        Map<String,Object> options = new Map<String,Object>();
        try{
            user usr = GA_OBJ_TD01_TestDataCreation.UsrRec(ROLE_NAM,EMAILVAL,PROF_NAM);
            database.insert(usr);
            system.runAs(usr){
                
                List<Contract> contr = [Select Id,Status,CID__c,ASC_Carrier__c from Contract
                                        where RecordTypeId =:ASCCON_RECID ];            
                inputMap.put('ContextId',contr[1].id); 
                ASC_DocusignParticipentValidations dsc =new ASC_DocusignParticipentValidations();
                dsc.invokeMethod('createDeleteConDocs',inputMap,outMap,NULL);
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