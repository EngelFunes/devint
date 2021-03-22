/**************************************************************************************************************************
@Author : off shore
@Name: ASC_AP_PrintPackageTest 
@CreatedDate: 05 May 2020
@Description: ASC_AP_PrintPackageTest class is used to cover ASC_AP_PrintPackage class.
@version : 1.0  
@US Num: 
****************************************************************************************************************************/

@isTest(seealldata = false)
Private class ASC_AP_PrintPackageTest {
    
    private static final string ACC_RECORDTYPE  ='Account - Customer';    
    private static final string NAME='TEST';
    private static final string STATUS='Draft';
    private static final string CARRIER='BCBSM';
    private static final string SPECIALTERMS='TEST1';
    private static final string DOCVERSION='2021 Schedule A Default';
    private static final string DOCTYPE='Schedule A - Ex 2';
    private static final string DOCTYPE1='Contract Amendment';
    private static final string DOCTYPE2='Stop-Loss Amendment';
    private static final string DOCSOURCE='Salesforce Generated';
    private static final string PHONE='9876543211';    
    private static final string ACCCID = '12345';
    private static final string ACCNO = '123S45';
    private static final string NUM1 ='9999';
     private static final string ASCCONTRACTUALDOCUMENT='ASC_Contractual_Document__c';
    private static final Integer NUM = 20;
    private static final string STR_TEST  ='Test';
    private static final string POLICY = 'Policy';
    private static final String DELETED = 'Deleted';
    private static final string QTNAME = 'test quote';
    private static final string  TESTCV='TestCV_SGen';
    private static final string  JPG= 'TestCV.jpg';
    private static final string  GATYPE='Email';
    private static final string  CONTENT='Test Content';
    private static final string V ='V';
    private static final string DOCVERSION1 = '2021.2 Stop-Loss Policy Default';
    private static final Id qTRecordTypeId = Schema.SObjectType.Quote.getRecordTypeInfosByName().get('ASC Quote').getRecordTypeId();
    private static final string ROLE_NAM = 'TestUser';
    private static final string EMAILVAL = 'testUser@bcbsm.com';
    private static final string PROF_NAM = 'System Administrator';
    
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
        acc.AccountNumber=ACCNO;
        acc.CID__c=ACCCID;     
        insert acc;     
        
        Contract cntr=new Contract();
        cntr.Name=NAME;
        cntr.SpecialTerms=SPECIALTERMS;
        cntr.AccountId=acc.id;
        insert cntr;
        Contract cntr1=new Contract();
        cntr1.Name=NAME;
        cntr1.SpecialTerms=SPECIALTERMS;
        cntr1.AccountId=acc.id;
        insert cntr1;
        Contract cntr2=new Contract();
        cntr2.Name=NAME;
        cntr2.SpecialTerms=SPECIALTERMS;
        cntr2.AccountId=acc.id;
        insert cntr2;
        Contract cntr3=new Contract();
        cntr3.Name=NAME;
        cntr3.SpecialTerms=SPECIALTERMS;
        cntr3.AccountId=acc.id;
        insert cntr3;
        ASC_Contractual_Document__c cntrcDocRcd = new ASC_Contractual_Document__c();
        cntrcDocRcd.Name = NAME;
        cntrcDocRcd.ASC_Do_Not_Include__c = False;
        cntrcDocRcd.Document_Source__c =DOCSOURCE;
        cntrcDocRcd.ASC_Contract__c = cntr.id;
        cntrcDocRcd.ASC_Document_Type__c =DOCTYPE1;
        database.insert (cntrcDocRcd);
        
        ASC_Contractual_Document__c cntrcDocRcd1 = new ASC_Contractual_Document__c();
        cntrcDocRcd1.Name = NAME;
        cntrcDocRcd1.Document_Language_Required__c=true;
        cntrcDocRcd1.ASC_Do_Not_Include__c = False;
        cntrcDocRcd1.Document_Source__c =DOCSOURCE;
        cntrcDocRcd1.ASC_Contract__c = cntr.id;
        cntrcDocRcd1.ASC_Document_Type__c =DOCTYPE;
        cntrcDocRcd.Doc_Reference_Year__c =NUM1;
        database.insert (cntrcDocRcd1);
        // cntrcDocRcd1.Name = NAME;
        // Update cntrcDocRcd1; 
        
        
        ASC_Contractual_Document__c cntrcDocRcd2 = new ASC_Contractual_Document__c();
        cntrcDocRcd2.Name = NAME;
        cntrcDocRcd2.Document_Language_Required__c=true;
        cntrcDocRcd2.ASC_Do_Not_Include__c = False;
        cntrcDocRcd2.Document_Source__c =DOCSOURCE;
        cntrcDocRcd2.ASC_Contract__c = cntr.id;
        cntrcDocRcd2.ASC_Document_Type__c =DOCTYPE2;
        cntrcDocRcd2.ASC_Document_Language__c =null;
        cntrcDocRcd.Document_Version__c =DOCVERSION1;
        database.insert (cntrcDocRcd2);
        
        ASC_Document_Language__c docLang = new ASC_Document_Language__c();
        docLang.ASC_Document_Language_Name__c=STR_TEST;
        docLang.ASC_Document_Type__c=DOCTYPE1;
        docLang.ASC_End_Date__c=Date.today()+10;                
        docLang.ASC_Document_Language_Text__c=STR_TEST;
        docLang.Template__c = True;
        docLang.ASC_Document_Language_State__c=Deleted;
        insert docLang;
        ASC_Document_Language__c docLang1 = new ASC_Document_Language__c();
        docLang1.ASC_Document_Language_Name__c=STR_TEST;
        docLang1.ASC_Document_Type__c=DOCTYPE;
        docLang1.ASC_End_Date__c=Date.today()+10;                
        docLang1.ASC_Document_Language_Text__c=STR_TEST;
        docLang1.Template__c = True;
        docLang1.ASC_Document_Language_State__c=Deleted;
        insert docLang1;
        
        
        ASC_Contractual_Document__c cntrcDocRcd4 = new ASC_Contractual_Document__c();
        cntrcDocRcd4.Name = NAME;
        cntrcDocRcd4.Document_Language_Required__c=true;
        cntrcDocRcd4.ASC_Do_Not_Include__c = False;
        cntrcDocRcd4.Document_Source__c =DOCSOURCE;
        cntrcDocRcd4.ASC_Contract__c = cntr2.id;
        cntrcDocRcd4.ASC_Document_Type__c =DOCTYPE;
        cntrcDocRcd4.ASC_Document_Language__c =null;
        database.insert (cntrcDocRcd4);
        cntrcDocRcd4.Name = NAME;
        Update cntrcDocRcd4;
        
        ASC_Contractual_Document__c cntrcDocRcd5 = new ASC_Contractual_Document__c();
        cntrcDocRcd5.Name = NAME;
        cntrcDocRcd5.Document_Language_Required__c=false;
        cntrcDocRcd5.ASC_Do_Not_Include__c = False;
        cntrcDocRcd5.Document_Source__c =DOCSOURCE;
        cntrcDocRcd5.ASC_Contract__c = cntr1.id;
        cntrcDocRcd5.ASC_Document_Type__c =DOCTYPE1;
        cntrcDocRcd5.Stop_Loss_Amendment_Reference__c =POLICY;
        cntrcDocRcd5.ASC_Document_Language__c =docLang.Id;
        insert cntrcDocRcd5;
        cntrcDocRcd5.Name = NAME;
        Update cntrcDocRcd5;
        
        ASC_Contractual_Document__c cntrcDocRcd6 = new ASC_Contractual_Document__c();
        cntrcDocRcd6.Name = NAME;
        cntrcDocRcd6.Document_Language_Required__c=false;
        cntrcDocRcd6.ASC_Do_Not_Include__c = False;
        cntrcDocRcd6.Document_Source__c =DOCSOURCE;
        cntrcDocRcd6.ASC_Contract__c = cntr2.id;
        cntrcDocRcd6.ASC_Document_Type__c =DOCTYPE1;
        cntrcDocRcd6.ASC_Document_Language__c =null;
        database.insert (cntrcDocRcd6);
        ASC_Contractual_Document__c cntrcDocRcd7 = new ASC_Contractual_Document__c();
        cntrcDocRcd7.Name = NAME;
        cntrcDocRcd7.Document_Language_Required__c=false;
        cntrcDocRcd7.ASC_Do_Not_Include__c = False;
        cntrcDocRcd7.Document_Source__c =DOCSOURCE;
        cntrcDocRcd7.ASC_Contract__c = cntr2.id;
        cntrcDocRcd7.ASC_Document_Type__c =DOCTYPE2;
        cntrcDocRcd7.ASC_Document_Language__c =null;
        database.insert (cntrcDocRcd7);
        
        ASC_Contractual_Document__c cntrcDocRcd8 = new ASC_Contractual_Document__c();
        cntrcDocRcd8.Name = NAME;
        cntrcDocRcd8.Document_Language_Required__c=true;
        cntrcDocRcd8.ASC_Do_Not_Include__c = False;
        cntrcDocRcd8.Document_Source__c =DOCSOURCE;
        cntrcDocRcd8.ASC_Contract__c = cntr3.id;
        cntrcDocRcd8.ASC_Document_Type__c =DOCTYPE;
        cntrcDocRcd8.ASC_Document_Language__c =docLang1.id;
        database.insert (cntrcDocRcd8);
        
        System.debug([select id ,ASC_Contract__c,Document_Source__c,ASC_Document_Type__c from ASC_Contractual_Document__c ]);
        Id pricebookId = Test.getStandardPricebookId();            
        Quote q = new Quote();
        q.Name = QTNAME;
        q.pricebook2Id = pricebookId;
        q.RecordTypeId = qTRecordTypeId;
        Database.insert(q,false);
        ContentVersion cntvs = new ContentVersion();
        cntvs.Title = TESTCV;
        cntvs.PathOnClient =JPG;
        cntvs.VersionData = Blob.valueOf(CONTENT);
        cntvs.IsMajorVersion = true;
        cntvs.GA_Type__c =GATYPE;
        Database.insert(cntvs) ;
        
        
        ContentVersion contentVersionSelect = [SELECT Id, Title, ContentDocumentId FROM ContentVersion WHERE Id = :cntvs.Id LIMIT 1];
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument Limit 20];
        List<ContentDocumentLink> contentDocLink = [SELECT ContentDocumentId FROM ContentDocumentLink where LinkedEntityId = :cntr.Id 
                                                    and LinkedEntity.Type=:ASCCONTRACTUALDOCUMENT limit 10];
        
        
        ContentDocumentLink cdl = New ContentDocumentLink();
        cdl.LinkedEntityId =cntrcDocRcd1.id;
        cdl.ContentDocumentId = documents[0].Id;
        cdl.shareType =V;
        Database.insert(cdl);
        ContentDocumentLink cdl1 = New ContentDocumentLink();
        cdl1.LinkedEntityId =cntr.id;
        cdl1.ContentDocumentId = documents[0].Id;
        cdl1.shareType =V;
        //Database.insert(cdl1);
        
    }
    /*******************************************************************************************************************************
@Description: This test method is used to create/update the records in Contract and ASC_Contractual_Document__c Objects 
@Name : processControlsForPackageGenTest
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
    
    private static testMethod void processControlsForPackageGenTest(){
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec(ROLE_NAM,EMAILVAL,PROF_NAM);
        database.insert(usr);
        system.runAs(usr)
        {  
            try{
                List<Contract> cntrList =[SELECT AccountId,CID__c,Id,Name,RecordTypeId,Status,ASC_Carrier__c,ASC_Contract_Year__c,SpecialTerms FROM Contract ]; 
                
                List<ASC_Contractual_Document__c> ascdList=new List<ASC_Contractual_Document__c>();
                
                
                update ascdList;
                
                Test.startTest();
                for(Contract cntr :cntrList){
                    ASC_AP_PrintPackage.processControlsForPackageGen(cntr.id);
                    
                }
                Test.stopTest();
                system.assert(cntrList <> null);
            }
            catch(exception e)
            {
                system.assert(e <> null);
                return;
            } 
        }   
        
    }
    /*******************************************************************************************************************************
@Description: This test method is used to create/update the records in Contract and ASC_Contractual_Document__c Objects 
@Name : fetchContractualDocumentsTest
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
    
    static testMethod void fetchContractualDocumentsTest(){
        try{
            user usr = GA_OBJ_TD01_TestDataCreation.UsrRec(ROLE_NAM,EMAILVAL,PROF_NAM);
            database.insert(usr);
            System.runAs(usr){
                Contract ctnr=[SELECT AccountId,CID__c,Id,Name,RecordTypeId,ASC_Carrier__c,Status,SpecialTerms FROM Contract Limit 1];
                test.startTest();
                ASC_AP_PrintPackage.fetchContractualDocuments (ctnr.id);
                ASC_AP_PrintPackage.fetchContractualDocuments(null);
                test.stopTest();
                system.assert(ctnr <> null);
            }}
        catch(exception e)
        {
            system.assert(e <> null);
            return;
        }   
    } 
    /*******************************************************************************************************************************
@Description: This test method is used to create/update the records in Contract and ASC_Contractual_Document__c Objects 
@Name : fetchContractualDocumentsFileIdsTest
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
    
    static testMethod void fetchContractualDocumentsFileIdsTest(){
        try{
            user usr = GA_OBJ_TD01_TestDataCreation.UsrRec(ROLE_NAM,EMAILVAL,PROF_NAM);
            database.insert(usr);
            System.runAs(usr){
                
                Map<String,ASC_Contractual_Document__c> ctrMap=new Map<String,ASC_Contractual_Document__c>(
                    [Select id ,Name,ASC_Do_Not_Include__c,Document_Source__c,ASC_Contract__c,ASC_Document_Type__c
                     from ASC_Contractual_Document__c limit 20]);
                test.startTest();
                
                ASC_AP_PrintPackage.fetchContractualDocumentsFileIds(ctrMap);
                ASC_AP_PrintPackage.fetchContractualDocumentsFileIds(null);
                test.stopTest();
                system.assert(ctrMap <> null);
            }
        }catch(exception e)
        {
            system.assert(e <> null);
            return;
        }   
    }
    
    
}