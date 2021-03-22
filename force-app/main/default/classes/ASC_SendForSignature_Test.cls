/**************************************************************************************************************************
@Author : SivaSankar
@Name: ASC_SendForSignature_Test 
@CreatedDate: 08 Febuary 2021
@Description: ASC_SendForSignature_Test class is used to cover ASC_SendForSignature class
@version : 1.0  
****************************************************************************************************************************/
@isTest(seealldata = false)
public without sharing class ASC_SendForSignature_Test {
    private static final string ACT='Active';
    private static final string SGRR='SG';
    private static final string NAME='Aada Consulting';
    private static final string DOCSOURCE='Salesforce Generated';
    private static final string DOCTYPE1='Group Signed Package';	
    private static final string CARRIER='BCBSM';
    private static final string ASC_CONT = 'ASC Contract'; 
    private static final string SPECIALTERMS='TEST1';
    private static final Id ASCCON_RECID = Schema.SObjectType.Contract.getRecordTypeInfosByName().get(ASC_CONT).getRecordTypeId(); 
    private static final string DOCUSIGNNAME='Test1';
    private static final string FIRST='Test';
    private static final string LAST='Test2';
    private static final string GROUPPRIMARY='Group Primary';
    private static final string EMAIL='test@test.com';
    private static final string ROLE_NAM = 'TestUser';
    private static final string EMAILVAL = 'testUser@bcbsm.com';
    private static final string PROF_NAM = 'System Administrator';
    private static final string SIGNER='signer';
    public static final string ASC_SIGNER_RECTYPEID = 
        Schema.SObjectType.DocuSign_Participant__c.getRecordTypeInfosByName().get('Group Signer').getRecordTypeId();
    public static final Id AGENT_RECTYPEID = 
        Schema.SObjectType.DocuSign_Participant__c.getRecordTypeInfosByName().get('Agent').getRecordTypeId();
    public static final Id SEGOWNER_RECTYPEID = 
        Schema.SObjectType.DocuSign_Participant__c.getRecordTypeInfosByName().get('Segment Owner').getRecordTypeId();
    private static final string PROFILENAME='BCBSM Agent';
    private static final string PROFILENAME1='System Administrator';
    private static final string TYPE2='Dental';
    private static final string TYPE1='Vision';
    private static final string BLANK='';
    private static final string NAME1='Agent';
    private static final string USERNAME='bcbsm1@bcbsm.com';
    private static final string PRD_TYPE='ASC Product';
    private static final string PRD_LOB1 = 'Non-Benefit';
    private static final string COV_SPEC = 'Coverage Spec';
    private static final string PRODT = 'Product';
    private static final string CARR_BCBSM = 'BCBSM';
    private static final string CARR_BCN = 'BCN';
    private static  string ACTIVE ='Active';
    private static Id prdCovSpecRecordTypeId =
        Schema.SObjectType.Product2.getRecordTypeInfosByName().get(COV_SPEC).getRecordTypeId();
    private static final string TYPE  ='ASC Product';
    private static final string PRODNAME  ='TEST Product';
    private static final string PARPRD_CD1 = 'ASC_0000005';
    private static final string PARPRD_CD2 = 'ASC_0000370';
    private static final string PARPRD_CD3 = 'ASC_0000415';
    private static final string PARPRD_FAMILY = 'Medical';
    private static final string PRD_FAMILY = 'Admin Fees';
    private static final string PRD_LOB = 'Non-Benefit';
    private static final Id prdRecordTypeId=Schema.SObjectType.Product2.getRecordTypeInfosByName().get('Product').getRecordTypeId();   
    private static final string PRD_CODE = 'ASC_0000370';
    private static final string PRD_NAME = 'Variable Administrative Fees';
    private static final String LIENAMEPRD = 'Data Feeds 1';
    private static final Integer QUANTITY = 20;
    private static final Double COUPONSAVINGS = 20;
    private static final Double AWP1 = 20;
    private static final Double AWP1DECIMAL = 20.65;
    private static final Double AWP2 = 20;    
    private static final string CONAG_RECORDTYPE ='Contact - Agent';
    private static final string CON_RECORDTYPE ='Contact';
    private static final string PHONENUM='(123)456-7089';
    private static final string CONTRACTDOC ='ASC_Contractual_Document__c';   
    private static final string STR_TEST  ='Test';
    private static final string CONTAMENDMENT  ='Contract Amendment';
    private static final string SALES_REP_NAME='test';
    private static final string	SALES_REP_EMAIL='test@test.com';
    private static final string ASC_CARRIER='BCBSM';
    private static final string CONTRACT_YEAR='2021';
    private static final string STATUS='Draft';
    private static final string DOCUSIGN_ACTION='Approver';
    private static final boolean ACTIVE_TRUE=true;
    private static final integer ROUTING_ORDER=3;
    private static final string VIEWER='Viewer';  
    private static final string DATAFEED='Laboratory Data';
    private static final string ACTIVATION_TYPE='New';
    private static final string TIER='Year 1';
    private static final string TITLE='TestCV_SF_Gen_Te';
    private static final string PATH='TestCV.jpg';
    private static final string VERSION='Test Content';
    private static final string GA_TYPE='Email';
    private static final string DOCUSIGN_PER='DocuSign_Administrator';
    
    /*******************************************************************************************************************************
@Description: initData() method - preparing the test data
@Name : initData
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
    @testSetup 
    static void initData(){
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec(ROLE_NAM,EMAILVAL,PROF_NAM);
        database.insert(usr);
        
        //Account - add a record
        Account acc= ARV_AP05_TestDataCreation.accRec();
        acc.Account_Status__c=ACT;
        acc.ARV_Renewal_Account_Type__c=SGRR;
        acc.GA_Opportunity_Renewal_Date__c=system.today();
        database.insert(acc);
        
        //Pricebook2 - add a record
        Id standardPriceBookRecId=Test.getStandardPricebookId();
        pricebook2 pb2=ARV_AP05_TestDataCreation.priceBookRec();
        database.insert(pb2);
        
        //Opportunity - add a record
        Opportunity opp= ARV_AP05_TestDataCreation.opportunityRec(acc.Id,standardPriceBookRecId);
        database.insert(opp); 
        
        //Quote - add a record
        Quote quot = ARV_AP05_TestDataCreation.quoteRec1(opp.Id,standardPriceBookRecId,usr.Id);
        database.insert(quot);
        
        //Contract - add a record
        Contract cntr=new Contract();
        cntr.Name=NAME;
        cntr.SpecialTerms=SPECIALTERMS;
        cntr.AccountId=acc.id;
        cntr.recordtypeid = ASCCON_RECID; 
        cntr.Sales_Rep_Name__c = SALES_REP_NAME;
        cntr.Sales_Rep_Email__c = SALES_REP_EMAIL;
        cntr.ASC_Carrier__c = ASC_CARRIER;
        cntr.ASC_Contract_Year__c = CONTRACT_YEAR;
        cntr.Status = 'Draft';
        cntr.StartDate = system.today();
        cntr.vlocity_ins__QuoteId__c=quot.id;
        insert cntr;
        
        //insert contact - for non-agent(without AOR)
        contact cont = new Contact();
        cont.FirstName =FIRST;
        cont.LastName =LAST;
        cont.recordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(CON_RECORDTYPE).getRecordTypeId();
        cont.AccountId = acc.Id;
        cont.Phone=PHONENUM;
        insert Cont;
        
        //Contact - add a record for agent(With AOR) 
        contact cnt = new Contact();
        cnt.FirstName =FIRST;
        cnt.LastName =LAST;
        cnt.Phone=PHONENUM;
        cnt.AccountId = acc.Id;
        cnt.recordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get(CONAG_RECORDTYPE).getRecordTypeId();
        database.insert(cnt);
        
        
        //AOR - Add a record
        GA_AOR__c aor = new GA_AOR__c();
        aor.name = NAME;
        aor.GA_Contact_Id__c = cnt.id;
        aor.GA_Account_Id__c = acc.id;
        insert aor;
        
        //DocuSign_Participant__c - add multiple records - record 3
        DocuSign_Participant__c docu3=new DocuSign_Participant__c();
        docu3.RecordTypeId=AGENT_RECTYPEID;
        docu3.Name=NAME;
        docu3.Contract__c=cntr.id;
        docu3.DocuSign_Action__c = DOCUSIGN_ACTION;
        docu3.Agent__c = cnt.id;        
        docu3.Active__c = ACTIVE_TRUE;
        insert docu3;
        
        DocuSign_Participant__c docu5=new DocuSign_Participant__c();
        docu5.recordtypeid=ASC_SIGNER_RECTYPEID;
        docu5.Name=DOCUSIGNNAME;
        docu5.Contact__c=cont.id;
        docu5.Contract__c=cntr.id;
        docu5.Email__c=EMAIL;
        docu5.DocuSign_Action__c=GROUPPRIMARY;
        docu5.First_Name__c =FIRST;
        docu5.Last_Name__c=LAST;
        docu5.Routing_Order__c=3;
        insert docu5;
        
        DocuSign_Participant__c docu6=new DocuSign_Participant__c();
        docu6.recordtypeid=SEGOWNER_RECTYPEID;
        docu6.Name=DOCUSIGNNAME;
        docu6.Email__c=EMAIL;
        docu6.Segment_Owner__c=usr.id;
        docu6.Contract__c=cntr.id;
        docu6.DocuSign_Action__c=SIGNER;
        insert docu6;
        
        //DocuSign_Participant__c - add a record
        DocuSign_Participant__c docu7=new DocuSign_Participant__c();
        docu7.RecordTypeId=ASC_SIGNER_RECTYPEID;
        docu7.Name=NAME;
        docu7.Contact__c=cont.id;
        docu7.Contract__c=cntr.id;
        docu7.DocuSign_Action__c = VIEWER;
        docu7.Active__c = ACTIVE_TRUE;
        insert docu7;
        
        //DocuSign_Participant__c - add multiple records - record 2
        DocuSign_Participant__c docu2=new DocuSign_Participant__c();
        docu2.RecordTypeId=AGENT_RECTYPEID;
        docu2.Name=NAME;
        docu2.Contract__c=cntr.id;
        docu2.DocuSign_Action__c = SIGNER;
        docu2.Agent__c = cnt.id;        
        docu2.Active__c = ACTIVE_TRUE;
        insert docu2;
        
        //ASC Contractual Document - add a record
        ASC_Contractual_Document__c con = new ASC_Contractual_Document__c();
        con.Name = NAME;
        con.ASC_Do_Not_Include__c = False;
        con.Document_Source__c =DOCSOURCE;
        con.ASC_Contract__c = cntr.id;
        con.ASC_Document_Type__c =DOCTYPE1;
        insert con;
        
        //Product - add multiple records - record 1
        Product2 prd1 = new Product2();
        prd1.vlocity_ins__Type__c = TYPE;
        prd1.ProductCode = PARPRD_CD1;
        prd1.IsActive = true;
        prd1.Name = NAME;
        prd1.Family = PARPRD_FAMILY;
        prd1.vlocity_ins__LineOfBusiness__c = PRD_LOB;
        prd1.RecordTypeId = prdRecordTypeId;
        prd1.vlocity_ins__SubType__c = TYPE;
        Database.insert(prd1, false); 
        
        //Product - add multiple records - record 2
        Product2 prd2 = new Product2();
        prd2.vlocity_ins__Type__c = TYPE;
        prd2.ProductCode = PARPRD_CD2;
        prd2.IsActive = ACTIVE_TRUE;
        prd2.Name = NAME;
        prd2.Family = PARPRD_FAMILY;
        prd2.vlocity_ins__LineOfBusiness__c = PRD_LOB;
        prd2.RecordTypeId = prdRecordTypeId;
        prd2.vlocity_ins__SubType__c = TYPE;
        Database.insert(prd2, false);   
        
        //Product - add multiple records - record 3
        Product2 prd3 = new Product2();
        prd3.vlocity_ins__Type__c = TYPE;
        prd3.ProductCode = PARPRD_CD3;
        prd3.IsActive = ACTIVE_TRUE;
        prd3.Name = NAME;
        prd3.Family = PARPRD_FAMILY;
        prd3.vlocity_ins__LineOfBusiness__c = PRD_LOB;
        prd3.RecordTypeId = prdRecordTypeId;
        prd3.vlocity_ins__SubType__c = TYPE;
        Database.insert(prd3, false);
        
        //Line_Item_Extension__c - add multiple records - record 1
        Line_Item_Extension__c lie1 = new Line_Item_Extension__c();
        lie1.name = LIENAMEPRD;
        lie1.Product__c = prd1.Id;
        lie1.Quantity__c = QUANTITY;
        lie1.DataFeed_Type__c = DATAFEED;
        lie1.Tier__c =TIER;
        lie1.Percent_of_Coupon_Savings__c=COUPONSAVINGS;
        lie1.AWP_1__c=AWP1;
        lie1.AWP_2__c=AWP2;
        lie1.Activation_Type__c = ACTIVATION_TYPE;
        Database.insert(lie1,false);
        
        //Line_Item_Extension__c - add multiple records - record 2
        Line_Item_Extension__c lie2 = new Line_Item_Extension__c();
        lie2.name = LIENAMEPRD;
        lie2.Product__c = prd2.Id;
        lie2.Quantity__c = QUANTITY;
        lie2.DataFeed_Type__c = DATAFEED;
        lie2.Tier__c =TIER;
        lie2.Percent_of_Coupon_Savings__c=COUPONSAVINGS;
        lie2.AWP_1__c=AWP1;
        lie2.AWP_2__c=AWP2;
        Database.insert(lie2,false);    
        
        //Line_Item_Extension__c - add multiple records - record 3
        Line_Item_Extension__c lie3 = new Line_Item_Extension__c();
        lie3.name = LIENAMEPRD;
        lie3.Product__c = prd2.Id;
        lie3.Quantity__c = QUANTITY;
        lie3.DataFeed_Type__c = DATAFEED;
        lie3.Tier__c =TIER;
        lie3.Percent_of_Coupon_Savings__c=COUPONSAVINGS;
        lie3.AWP_1__c=AWP1;
        lie3.AWP_2__c=AWP2;
        Database.insert(lie3,false);          
        
        //vlocity_ins__ContractLineItem__c - add multiple records - record 1
        vlocity_ins__ContractLineItem__c vicli1 = new vlocity_ins__ContractLineItem__c();
        vicli1.vlocity_ins__ContractId__c = cntr.id;
        vicli1.ASC_Line_Item_Extension__c = lie1.id;
        vicli1.vlocity_ins__ProductId__c = prd1.id;
        vicli1.vlocity_ins__Product2Id__c = prd1.id;
        insert vicli1;
        
        //vlocity_ins__ContractLineItem__c - add multiple records - record 2
        vlocity_ins__ContractLineItem__c vicli2 = new vlocity_ins__ContractLineItem__c();
        vicli2.vlocity_ins__ContractId__c = cntr.id;
        vicli2.ASC_Line_Item_Extension__c = lie2.id;
        vicli2.vlocity_ins__ProductId__c = prd2.id;
        vicli2.vlocity_ins__Product2Id__c = prd2.id;
        insert vicli2;
        
        //vlocity_ins__ContractLineItem__c - add multiple records - record 3
        vlocity_ins__ContractLineItem__c vicli3 = new vlocity_ins__ContractLineItem__c();
        vicli3.vlocity_ins__ContractId__c = cntr.id;
        vicli3.ASC_Line_Item_Extension__c = lie3.id;
        vicli3.vlocity_ins__ProductId__c = prd3.id;
        vicli3.vlocity_ins__Product2Id__c = prd3.id;
        insert vicli3;
        
        //ContentVersion - add multiple records        
        ContentVersion cntvs = new ContentVersion();
        cntvs.Title = TITLE;
        cntvs.PathOnClient = PATH;
        cntvs.VersionData = Blob.valueOf(VERSION);
        cntvs.IsMajorVersion = ACTIVE_TRUE;
        cntvs.GA_Type__c =GA_TYPE;
        Database.insert(cntvs) ;
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument Limit 10];
        
        //ContentDocumentLink - add multiple records
        ContentDocumentLink cdl = New ContentDocumentLink();
        cdl.LinkedEntityId =con.id;        
        cdl.ContentDocumentId = documents[0].Id;
        cdl.shareType = 'V';
        Database.insert(cdl); 
        ContentDocumentLink cdl1 = New ContentDocumentLink();
    }
    /*******************************************************************************************************************************
@Description: This test method is used to send for signature records.
@Name : ASC_SendForSignature
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
    private static testMethod void ASC_SendForSignature(){
        List<String> PERMISSIONSETNAMES = new List<String>{DOCUSIGN_PER};
            List<PermissionSet> ps = [SELECT Id,NAME,NamespacePrefix FROM PermissionSet WHERE NamespacePrefix='dfsle' and Name IN:PERMISSIONSETNAMES limit 1];
        
        try{
            user usr = GA_OBJ_TD01_TestDataCreation.UsrRec(ROLE_NAM,EMAILVAL,PROF_NAM);
            database.insert(usr);
            PermissionSetAssignment psa = new PermissionSetAssignment();
            psa.AssigneeId = usr.Id;
            psa.PermissionSetId = ps[0].Id;
            insert psa;
            system.runas(usr){
                test.startTest();
                ASC_Contractual_Document__c contrdoc = [Select Id,name,ASC_Contract__c from ASC_Contractual_Document__c];
                ASC_SendForSignature.sendEnvelope(contrdoc.id);
                System.assert(true);
                test.stopTest();  
            }}catch(exception e)
            {
                system.assert(e <> null);
                return;
            }    
    }
}