/**************************************************************************************************************************
@Author :
@Name:ASC_AutoGenerateFiles_Test class is used to cover ASC_AutoGenerateFiles
@CreatedDate: 31-Aug-2020
@Description: ASC_AutoGenerateFiles_Test class is used to cover ASC_AutoGenerateFiles
@version : 1.0 
@US Num:
****************************************************************************************************************************/
@isTest(seealldata = false)
private class ASC_AutoGenerateFiles_Test {
    private static final string ACC_RECORDTYPE  ='Account - Customer';
    private static final string CONT_RECORDTYPE  ='ASC Base Contract';
    private static final string DRAFT  ='Draft';
    private static final string STR_TEST  ='Test';
    private static final string CONTAMENDMENT  ='Contract Amendment';
    private static final string BASE_CONTRACT  ='Base Contract';
    private static final string SCHEDULEA  ='Schedule A';
    private static final Integer QUANTY_LI = 2;
    private static final string ASC_QTRECTYPE = 'ASC Quote';
    private static final Integer UNIT_PRICE = 1;            
    public static final String BCBSM_CARRIER='BCBSM';
    public static final String BCN_CARRIER='BCN';
    private static final Id QTRECTYPID = 
        Schema.SObjectType.Quote.getRecordTypeInfosByName().get(ASC_QTRECTYPE).getRecordTypeId();   
    private static final string OPP_STAG = 'Quote Request';
    private static final string ASC_OPPRECTYPE = 'Opportunity - ASC';
    private static final string RENW_YEAR = '2021';
    private static final string CARR_BCN = 'BCN';
    private static final string TYPE  ='ASC Product';
    private static final string PRD_NAME = 'Variable Administrative Fees';
    private static final string PRD_CODE = 'ASC_0000160';
    private static final string PRD_FAMILY = 'Admin Fees';
    private static final string PRD_LOB = 'Non-Benefit';
    private static final string PARPRD_CD = 'ASC_0000005';
    private static final string DOCVERSION1 = '2021 Contract Amendment Default';
    private static final string DOCVERSION2 ='2021 Stop Loss Exhibit Default';
    private static final string PARPRD_FAMILY = 'Medical';
    private static final string PRODNAME  ='TEST Product';
    private static final string PARPRD_FAMILY1='Data Feeds';
    private static final string PRODT = 'Product';
    private static final string COV_SPEC = 'Coverage Spec';
    private static final string CONTRACTDOC ='ASC_Contractual_Document__c';   
    private static final Id PRDRECTYPID=
        Schema.SObjectType.Product2.getRecordTypeInfosByName().get(PRODT).getRecordTypeId();
    private static final Id PRDCOVSPECRECTYPEID = 
        Schema.SObjectType.Product2.getRecordTypeInfosByName().get(COV_SPEC).getRecordTypeId();    
    public static final Integer instanNo = 692057;
    private static final string NAME='TEST';
    private static final string NAME1='test1';
    private static final string YEAR='2020';
    private static final string DOCSOURCE='Salesforce Generated';    
    private static final string STATUS='Draft';
    private static final string CARRIER='BCBSM';
    private static final string DOCVERSION='2021 Schedule A Default';
    private static final string DOCTYPE='Stop-Loss Exhibit';
    private static final string PHONE='9876543211';    
    private static final string ACCCID = '12345';
    private static final string FEDTID = '123456789';
    private static final string BILL_PCODE = '48005';
    private static final Integer SEQUENCE = 20;
    private static final Integer NUM = 20;
    private static final string  SECTION= '20';
    private static final string  SECTION1='5A';
    private static final string  TESTCV='TestCV_SF_Gen_Te';
    private static final string  JPG= 'TestCV.jpg';
    private static final string  GATYPE='Email';
    private static final string  CONTENT='Test Content';
    private static final string QUOTNAME ='test quote';
    private static final string PRODNAME1='Testpdm';
    private static final string QUOTSTATUS='Accepted';
    private static final string SIGNED = 'Signed';
    private static final string V ='V';
    private static final string DOCULANG='Active  text changed';
    private static final string DOCULANG1='Active etstetstetste';
    private static final string ROLE_NAM = 'TestIntUser';
    private static final string EMAILVAL = 'testIntUser@bcbsm.com';
    private static final string PROF_NAM = 'Integration User';
    private static final string PROF_NAM1 = 'BCBSM Read Only';
    private static final Id prdRecordTypeId=Schema.SObjectType.Product2.getRecordTypeInfosByName().get('Product').getRecordTypeId();
    private static final Id prdRecordTypeId1=Schema.SObjectType.Product2.getRecordTypeInfosByName().get('Coverage Spec').getRecordTypeId();
    private static final string BASE_ASC_CONTRACT ='Base ASC Contract';

    /*******************************************************************************************************************************
@Description: initData() method - preparing the test data
@Name : initData
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/ 
    @testSetup static void initData(){
        
        Account acc=new Account();
        acc.Name=NAME;
        acc.Phone=PHONE;
        acc.CID__c=ACCCID;
        acc.Federal_Tax_ID__c=ACCCID;
        acc.Requested_Effective_Date__c=system.today();
        acc.GA_CoverageCancellationDate__c=system.today();        
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(ACC_RECORDTYPE).getRecordTypeId();
        database.insert (acc); 
        
        opportunity opp=new opportunity();
        opp.Name = NAME;
        opp.AccountId = acc.id;
        opp.stageName = OPP_STAG;
        opp.CloseDate = system.today()+120;
        opp.RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(ASC_OPPRECTYPE).getRecordTypeId();
        Database.insert(opp,false);
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
        
        Product2 prd2 = new Product2();
        prd2.vlocity_ins__Type__c = TYPE;
        prd2.ProductCode =PRD_CODE;
        prd2.IsActive = true;
        prd2.Name = PRODNAME;
        prd2.Family =PARPRD_FAMILY1;
        prd2.vlocity_ins__LineOfBusiness__c = PRD_LOB;
        prd2.RecordTypeId = PRDCOVSPECRECTYPEID;
        prd2.vlocity_ins__SubType__c = TYPE;
        Database.insert(prd2, false);
        
        Id pricebookId = Test.getStandardPricebookId();   
        list<Quote> Qlist=new list<Quote>();
        Quote quot = new Quote();
        quot.Name =QUOTNAME;
        quot.Status=QUOTSTATUS;
        quot.opportunityId = Opp.Id;
        quot.pricebook2Id = pricebookId;
        quot.RecordTypeId = QTRECTYPID;
        quot.ASC_CID__c = ACCCID;
        quot.ASC_Carrier__c =CARRIER;
        quot.ASC_Renewal_Year__c = RENW_YEAR;
        Database.insert(quot,false);
        quot.Status=QUOTSTATUS;
        Qlist.add(quot);
        Quote quot1 = new Quote();
        quot1.Name =QUOTNAME;
        quot1.opportunityId = Opp.Id;
        quot1.Status=QUOTSTATUS;
        quot1.pricebook2Id = pricebookId;
        quot1.RecordTypeId = QTRECTYPID;
        quot1.ASC_CID__c = ACCCID;
        quot1.ASC_Carrier__c = CARR_BCN;
        quot1.ASC_Renewal_Year__c = RENW_YEAR;
        Qlist.add(quot1);
        Database.insert(Qlist,false);
        pricebookEntry prc=new pricebookEntry ();
        prc.product2Id = prd1.Id;
        prc.Pricebook2Id = pricebookId;
        prc.UnitPrice = UNIT_PRICE;
        prc.isActive = true;
        Database.insert(prc,false);
        list<QuoteLineItem> Qlilist=new list<QuoteLineItem>();
        
        QuoteLineItem qli=new QuoteLineItem();
        qli.QuoteId = quot.Id;
        qli.product2Id = prd1.Id;
        qli.UnitPrice = UNIT_PRICE ;
        qli.Quantity = QUANTY_LI;
       		 qli.pricebookentryid = prc.Id;
        Qlilist.add(qli);
        
        QuoteLineItem qli1=new QuoteLineItem();
        qli1.QuoteId = quot1.Id;
        qli1.product2Id = prd2.Id;
        qli1.UnitPrice = UNIT_PRICE ;
        qli1.Quantity = QUANTY_LI;
        qli1.pricebookentryid = prc.Id;
        Qlilist.add(qli1);
        Database.insert(Qlilist,false); 
        
        Contract cntrcRcrd = new Contract ();
        cntrcRcrd.AccountId = acc.Id;
        cntrcRcrd.Status = STATUS;
        cntrcRcrd.StartDate = system.today();
        cntrcRcrd.ASC_Carrier__c=CARRIER;
        cntrcRcrd.recordtypeid=Schema.SObjectType.Contract.getRecordTypeInfosByName().get('ASC Contract').getRecordTypeId();
        database.insert (cntrcRcrd,false);
        
        List<ASC_Document_Language__c> docList=new List<ASC_Document_Language__c>();
        ASC_Document_Language__c docLang = new ASC_Document_Language__c();
        docLang.ASC_Document_Type__c=CONTAMENDMENT;
        docLang.ASC_End_Date__c=Date.today()+10;                
        docLang.ASC_Document_Language_Text__c=STR_TEST;
        docLang.Template__c = false;
        docLang.ASC_Document_Language_State__c=DRAFT;
        docLang.ASC_Quote__c=quot.id;
        docList.add(docLang);
        
        ASC_Document_Language__c docLang1 = new ASC_Document_Language__c();
        docLang1.ASC_Document_Type__c=DOCTYPE;
        docLang1.ASC_End_Date__c=Date.today()+10;                
        docLang1.ASC_Document_Language_Text__c=STR_TEST;
        docLang1.Template__c = false;
        docLang1.ASC_Document_Language_State__c=DRAFT;
        docLang1.ASC_Quote__c=quot.id;
        docList.add(docLang1);
        //insert docList;
        Database.insert(docList,false);
        List<ASC_Contractual_Document__c> acdcList=new List<ASC_Contractual_Document__c>();
        
        ASC_Contractual_Document__c cntrcDocRcd = new ASC_Contractual_Document__c();
        cntrcDocRcd.Name = NAME;
        cntrcDocRcd.ASC_Contract__c = cntrcRcrd.id;
        cntrcDocRcd.ASC_Document_Language__c=docLang1.id;
        cntrcDocRcd.ASC_Document_Type__c =DOCTYPE;      
        cntrcDocRcd.Document_Version__c =DOCVERSION2;
        cntrcDocRcd.Document_Source__c=DOCSOURCE;
        
        ASC_Contractual_Document__c cntrcDocRcd1 = new ASC_Contractual_Document__c();
        cntrcDocRcd1.Name = NAME;
        cntrcDocRcd1.ASC_Document_Language__c=docLang.id;
        cntrcDocRcd1.ASC_Contract__c = cntrcRcrd.id;
        cntrcDocRcd1.Doc_Reference_Year__c =YEAR;
        cntrcDocRcd1.ASC_Document_Type__c =CONTAMENDMENT;
        cntrcDocRcd1.Document_Source__c=DOCSOURCE;
        cntrcDocRcd1.Document_Version__c =DOCVERSION1;
        ASC_Contractual_Document__c cntrcDocRcd2 = new ASC_Contractual_Document__c();
        cntrcDocRcd2.Name = NAME;
        cntrcDocRcd2.ASC_Contract__c = cntrcRcrd.id;
        cntrcDocRcd2.Doc_Reference_Year__c =YEAR;
        cntrcDocRcd2.ASC_Document_Type__c =SCHEDULEA;
        cntrcDocRcd2.Document_Source__c=DOCSOURCE;
        cntrcDocRcd2.Document_Version__c =DOCVERSION;
        acdcList.add(cntrcDocRcd);
        acdcList.add(cntrcDocRcd1);
        acdcList.add(cntrcDocRcd2);
        insert acdcList;
        docLang.ASC_End_Date__c=Date.today()+10;                
        docLang.ASC_Document_Language_Text__c=NAME1;
        database.update(docLang,false);

        
         Contract cntrcRcrd1 = new Contract ();//jmt
        cntrcRcrd1.AccountId = acc.Id;
        cntrcRcrd1.Status = STATUS;
        cntrcRcrd1.StartDate = system.today();
        cntrcRcrd1.ASC_Carrier__c=CARRIER;
        cntrcRcrd1.recordtypeid=Schema.SObjectType.Contract.getRecordTypeInfosByName().get('ASC Contract').getRecordTypeId();
        database.insert (cntrcRcrd1,false);
        
        
        ASC_Contractual_Document__c aCON1 = new ASC_Contractual_Document__c();//JMT
        aCON1.ASC_Contract__c = cntrcRcrd1.id;
        aCON1.ASC_Document_Type__c = 'Contract Amendment';
        //insert aCON1;
        ASC_Contractual_Document__c aCON2 = new ASC_Contractual_Document__c();//JMT
        aCON2.ASC_Contract__c = cntrcRcrd1.id;
        aCON2.ASC_Document_Type__c = 'Stop-Loss Amendment';
        //insert aCON2;
        ASC_Contractual_Document__c aCON3 = new ASC_Contractual_Document__c();//JMT
        aCON3.ASC_Contract__c = cntrcRcrd1.id;
        aCON3.ASC_Document_Type__c = 'Schedule A - Ex 2';
        //insert aCON3;
        ASC_Contractual_Document__c aCON4 = new ASC_Contractual_Document__c();//JMT
        aCON4.ASC_Contract__c = cntrcRcrd1.id;
        aCON4.ASC_Document_Type__c = 'Stop-Loss Policy';
        //insert aCON4;
        
        
        
        ASC_Contractual_Document__c cntrcDoc = new ASC_Contractual_Document__c(id=cntrcDocRcd1.Id,
                                                                               Doc_Reference_Year__c =YEAR);
        
        update(cntrcDoc);
        Map<String,ASC_Contractual_Document__c> ctrMap=new Map<String,ASC_Contractual_Document__c>();
        ctrMap.put(cntrcDocRcd.id,cntrcDocRcd);
        ctrMap.put(cntrcDocRcd1.id,cntrcDocRcd1);
        list<vlocity_ins__ContractLineItem__c> cli = new list<vlocity_ins__ContractLineItem__c> ();
        
        
        vlocity_ins__ContractLineItem__c plan1 = new vlocity_ins__ContractLineItem__c();
        plan1.vlocity_ins__Product2Id__c=Prd2.Id;
        plan1.ASC_Effective_Start_Date__c=system.today();
        plan1.ASC_AAC_PCNT__c=NUM;
        plan1.vlocity_ins__ContractId__c=cntrcRcrd.id;
        
        vlocity_ins__ContractLineItem__c plan2 = new vlocity_ins__ContractLineItem__c();
        plan2.vlocity_ins__Product2Id__c=Prd2.Id;
        plan2.ASC_Effective_Start_Date__c=system.today();
        plan2.ASC_AAC_PCNT__c=10.00;
        plan2.vlocity_ins__ContractId__c=cntrcRcrd.id;
        plan2.vlocity_ins__ParentItemId__c=plan1.id;        
        
        cli.add(plan2);
        cli.add(plan1);
        insert cli;
        Test.startTest();
        List<Line_Item_Extension__c> lieList=new List<Line_Item_Extension__c>();
        Line_Item_Extension__c lie= new Line_Item_Extension__c();
        lie.Plan_ID__c= plan1.Id;
        lie.name=NAME;
        lie.LOU_Signed__c=SIGNED;
        lieList.add(lie);
        insert lieList;
        Line_Item_Extension__c LieUpdate=new Line_Item_Extension__c(id=lie.id,LOU_Signed__c='Not Required');
        update LieUpdate;
        Test.stopTest();
        
        Product_Document_Mapping__c pdm = new Product_Document_Mapping__c();
        pdm.Name=PRODNAME1;
        pdm.Parent_Product__c=prd1.id;
        pdm.Coverage_Product__c=prd2.id;
        pdm.Document_Type__c=SCHEDULEA;
        pdm.Document_Version__c=DOCVERSION;
        pdm.Sequence__c=10;
        pdm.Section__c=SECTION1;
        database.insert(pdm);
        
        
        ASC_Document_Type_Record__c docTypRec = new ASC_Document_Type_Record__c ();
        docTypRec.Name=NAME;
        docTypRec.Contract_Line_Item__c = plan2.id;
        docTypRec.Product_Document_Mapping__c =pdm.id;
        docTypRec.Instance__c = instanNo;
        database.insert (docTypRec,false);
        
        ContentVersion cntvs = new ContentVersion();
        cntvs.Title = TESTCV;
        cntvs.PathOnClient = JPG;
        cntvs.VersionData = Blob.valueOf(CONTENT);
        cntvs.IsMajorVersion = true;
        cntvs.GA_Type__c =GATYPE;
        Database.insert(cntvs) ;
        ContentVersion cntvs1 = new ContentVersion();
        cntvs1.Title =TESTCV;
        cntvs1.PathOnClient = JPG;
        cntvs1.VersionData = Blob.valueOf(CONTENT);
        cntvs1.IsMajorVersion = true;
        cntvs1.GA_Type__c =GATYPE;
      //  Database.insert(cntvs1) ;
        
        ContentVersion contentVersionSelect = [SELECT Id, Title, ContentDocumentId FROM ContentVersion WHERE Id = :cntvs.Id LIMIT 1];
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument Limit 10];
        
        
        List<ContentDocumentLink> contentDocLink = [SELECT ContentDocumentId FROM ContentDocumentLink where LinkedEntityId = :cntrcRcrd.Id 
                                                    and LinkedEntity.Type=:CONTRACTDOC limit 10];       
        
        ContentDocumentLink cdl = New ContentDocumentLink();
        cdl.LinkedEntityId =cntrcDocRcd1.id;
        
        cdl.ContentDocumentId = documents[0].Id;
        cdl.shareType =V;
        //Database.insert(cdl); 
        insert cdl;
    }
    
    
/*******************************************************************************************************************************
@Description: This test method is used to create/update the records in Contract and ASC_Contractual_Document__c Objects 
@Name : processControlsForPackageGenTest
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
    
    private static testMethod void testMethod1(){
        
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec(ROLE_NAM,EMAILVAL,PROF_NAM);
        database.insert(usr);
        
        system.runAs(usr)
        {
            try{
                
                List<ASC_Document_Language__c> dlList=[SELECT Id,ASC_Document_Language_Text__c FROM ASC_Document_Language__c limit 10]; 
                List<vlocity_ins__ContractLineItem__c> cli=[select id,Name,vlocity_ins__ContractId__c,
                                                            vlocity_ins__Product2Id__c,vlocity_ins__ParentItemId__c,vlocity_ins__ParentItemId__r.vlocity_ins__Product2Id__c
                                                            from vlocity_ins__ContractLineItem__c limit 50];
                
                Map<Id, ASC_Document_Language__c> m = new Map<Id, ASC_Document_Language__c>();
                m.put(dlList[0].id,dlList[0]);
                m.put(dlList[1].id,dlList[1]);
                
                List<ASC_Document_Language__c> updatedDL=new List<ASC_Document_Language__c>();
                dlList[0].ASC_Document_Language_Text__c=DOCULANG;
                dlList[1].ASC_Document_Language_Text__c=DOCULANG1;
                
                updatedDL.add(dlList[0]);                
                updatedDL.add(dlList[1]);
               //Contract contr = [Select Id,Status,CID__c,ASC_Carrier__c from Contract limit 1];
                //List<ContentDocumentLink> contentDocLink = [SELECT ContentDocumentId FROM ContentDocumentLink where LinkedEntityId = :contr.Id]; 
                
                test.startTest();
                ASC_AutoGenerateFiles.createDocTypeRec(cli,692057);
                
                ASC_AutoGenerateFiles.checkForDocLanguageTextUpdation(updatedDL,m);
                //ASC_AutoGenerateFiles.updateFiles(null);
                test.stopTest();
                system.assert(dlList <> null);
                
            }
            catch(exception e)
            {
                system.assert(e <> null);
                return;
            } 
        }
        
    }

//*******************************************************************************************************************************
//@Description: This test method is used to cover the data in the updateFiles method. 
//@Name : updateFiles
//@Param : None
//@Return : void
//@throws Exception : N/A;
//********************************************************************************************************************************   
 /*   private static testMethod void testMethod2(){
        
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec(ROLE_NAM,EMAILVAL,PROF_NAM1);
        database.insert(usr);
        
        system.runAs(usr)
        {
            try{
                
                Account acc=new Account();
                acc.Name=NAME;
                acc.Phone=PHONE;
                acc.CID__c=ACCCID;
                acc.Federal_Tax_ID__c=ACCCID;
                acc.Requested_Effective_Date__c=system.today();
                acc.GA_CoverageCancellationDate__c=system.today();        
                acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(ACC_RECORDTYPE).getRecordTypeId();
                database.insert (acc); 
                                
                Contract cntrcRcrd = new Contract ();
                cntrcRcrd.AccountId = acc.Id;
                cntrcRcrd.Status = STATUS;
                cntrcRcrd.StartDate = system.today();
                cntrcRcrd.ASC_Carrier__c=CARRIER;
                cntrcRcrd.recordtypeid=Schema.SObjectType.Contract.getRecordTypeInfosByName().get('ASC Contract').getRecordTypeId();
                //database.insert (cntrcRcrd,false);
                 List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument Limit 1];
                  ContentDocumentLink cd2 = New ContentDocumentLink();	
        cd2.LinkedEntityId =cntrcRcrd.id;
        cd2.ContentDocumentId = documents[0].Id;
        cd2.shareType = 'V';
        Database.insert(cd2);
                
                                        
                List<ContentDocumentLink> contentDocLink = [SELECT ContentDocumentId FROM ContentDocumentLink where LinkedEntityId = :cntrcRcrd.Id 
                                                    and LinkedEntity.Type=:CONTRACTDOC limit 1]; 
                                                    
                test.startTest();
                
                ASC_AutoGenerateFiles.updateFiles(contentDocLink);
                
                test.stopTest();
                
            }
            catch(exception e)
            {
                system.assert(e <> null);
                return;
            } 
        }
        
    }
    
    */
}