/*******************************************************************************************************************************
@Author : IDC offshore
@Name: ASC_CD_DocumentType_Test
@CreatedDate: 13 - Feb 2020 
@Description: ASC_CD_DocumentType_Test class is for Contractual Document.
@version : 1.0  
********************************************************************************************************************************/
@isTest(seealldata = false)
private class ASC_CD_DocumentType_Test {
    private static final string ACC_RECORDTYPE  ='Account - Customer';
    private static final string CONT_RECORDTYPE  ='ASC Base Contract';
    private static final string DRAFT  ='Draft';
    private static final string STR_TEST  ='Test';
    private static final string CONTAMENDMENT  ='Contract Amendment';
    private static final string BASE_CONTRACT  ='Base Contract';
    private static final string SCHEDULEA  ='Schedule A';
    //private static final string ACC_RECORDTYPE  ='Account - Customer';
    
    public static final Integer instanNo = 324242;
    private static final string TYPE  ='ASC Product';
    private static final string PRODNAME  ='TEST Product';
    private static final string PRDNAME  ='Multi Year Admin Fee Year';
    private static final string PARPRD_CD = 'ASC_0000005';
    private static final string PARPRD_FAMILY = 'Medical';
    private static final string PRD_FAMILY = 'Admin Fees';
    private static final string PRD_LOB = 'Non-Benefit';
    private static final string NAME='TEST';
    private static final string STATUS='Draft';
    private static final string CARRIER='BCBSM';
    private static final string DOCVERSION='2021 Schedule A Default';
    private static final string DOCTYPE='Schedule A';
    private static final string PHONE='9876543211';    
    private static final string ACCCID = '12345';
    private static final string FEDTID = '123456789';
    private static final string BILL_PCODE = '48005';
    private static final Integer SEQUENCE = 20;
    private static final Integer NUM = 20;
    private static final string  SECTION= '20';
    private static final Id prdRecordTypeId=Schema.SObjectType.Product2.getRecordTypeInfosByName().get('Product').getRecordTypeId();
    private static final Id prdRecordTypeId1=Schema.SObjectType.Product2.getRecordTypeInfosByName().get('Coverage Spec').getRecordTypeId();
    

    /*******************************************************************************************************************************
@Description: updtsigntrReqTest() method 
@Name : updtsigntrReqTest
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
 @TestSetup static void initData() {
                list<ASC_Contractual_Document__c> cdLst = new list<ASC_Contractual_Document__c>();
                Account acc=GA_OBJ_TD01_TestDataCreation.AccRec();
                acc.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get(ACC_RECORDTYPE).getRecordTypeId();
                database.insert(acc);
                
                Contract cont = new Contract();
                cont.AccountId=acc.Id;
                cont.Status=DRAFT;
                cont.StartDate=Date.today();
                cont.RecordTypeId=Schema.SObjectType.Contract.getRecordTypeInfosByName().get(CONT_RECORDTYPE).getRecordTypeId();
                database.insert(cont);
                
                ASC_Document_Language__c docLang = new ASC_Document_Language__c();
               // docLang.ASC_Document_Language_Name__c=STR_TEST;
                docLang.ASC_Document_Type__c=CONTAMENDMENT;
                docLang.ASC_End_Date__c=Date.today()+10;                
                docLang.ASC_Document_Language_Text__c=STR_TEST;
                docLang.Template__c = True;
                database.insert(docLang);
                
                ASC_Contractual_Document__c contDoc = new ASC_Contractual_Document__c();
                contDoc.Name=STR_TEST;
                contDoc.ASC_Contract__c=cont.Id;
                contDoc.ASC_Document_Language__c=docLang.Id;
                contDoc.ASC_Document_Type__c=CONTAMENDMENT;
                cdLst.add(contDoc);
                Database.insert(cdLst);
                /*contDoc.ASC_Document_Type__c=BASE_CONTRACT;
                contDoc.ASC_Signature_Required__c=true;
                contDoc.Document_Language_Required__c=true;
                cdLst.add(contDoc);
                database.update(cdLst); */
}
private static testmethod void updtsigntrReqTest(){
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestSysAdm','testsysadm@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr){
            try{
                list<ASC_Contractual_Document__c> cdLst =new list<ASC_Contractual_Document__c>([select Id,Name,
                ASC_Document_Type__c,ASC_Signature_Required__c from ASC_Contractual_Document__c where 
                ASC_Document_Type__c='Base Contract' limit 100]);
              
                Test.startTest();
                ASC_CD_DocumentType.updtSignatrReq(cdLst,null);
                ASC_CD_NamingConvention.updtContractDocName(cdLst,null);
                
                //ASC_ContractualDocument_Duplicate.duplicateCheckInsert(cdLst);
                //ASC_ContractualDocument_Duplicate.duplicateCheckUpdate(cdLst,null);
                
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
@Description: updtsigntrReqTestExp() method 
@Name : updtsigntrReqTestExp
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
    private static testmethod void updtsigntrReqTestExp(){
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestSysAdm','testsysadm@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr){
            try{
                Test.startTest();
                ASC_CD_DocumentType.updtSignatrReq(null,null);
                ASC_ContractualDoc_TriggerHandler.beforeInsert(null);
                ASC_ContractualDoc_TriggerHandler.beforeUpdate(null,null);
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
@Description: updtContractDocNameTest() method 
@Name : updtContractDocNameTest
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
    private static testmethod void updtContractDocNameTest(){
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestSysAdm','testsysadm@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr){
            try{
                list<ASC_Contractual_Document__c> cdLst = new list<ASC_Contractual_Document__c>();
                Account acc=GA_OBJ_TD01_TestDataCreation.AccRec();
                acc.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get(ACC_RECORDTYPE).getRecordTypeId();
                database.insert(acc);
                
                Contract cont = new Contract();
                cont.AccountId=acc.Id;
                cont.Status=DRAFT;
                cont.StartDate=Date.today();
                cont.RecordTypeId=Schema.SObjectType.Contract.getRecordTypeInfosByName().get(CONT_RECORDTYPE).getRecordTypeId();
                database.insert(cont);
                
                ASC_Document_Language__c docLang = new ASC_Document_Language__c();
              //  docLang.ASC_Document_Language_Name__c=STR_TEST;
                docLang.ASC_Document_Type__c=SCHEDULEA;
                docLang.ASC_End_Date__c=Date.today()+10;
                docLang.ASC_Document_Language_Text__c=STR_TEST;
                database.insert(docLang);
                 map<id,ASC_Contractual_Document__c> cdOldMap=new map<id,ASC_Contractual_Document__c>();
                ASC_Contractual_Document__c contDoc = new ASC_Contractual_Document__c();
                contDoc.Name=STR_TEST;
                contDoc.ASC_Contract__c=cont.Id;
                contDoc.ASC_Document_Language__c=docLang.Id;
                contDoc.ASC_Document_Type__c=CONTAMENDMENT;
                cdLst.add(contDoc);
                Database.insert(cdLst);
                contDoc.ASC_Document_Type__c=CONTAMENDMENT;
                contDoc.ASC_Signature_Required__c=true;
                cdLst.add(contDoc);
                //database.update(cdLst);
                Test.startTest();
                
                cdOldMap.put(contDoc.id,contDoc);
                ASC_ContractualDoc_TriggerHandler.beforeInsert(cdLst);
                ASC_ContractualDoc_TriggerHandler.beforeUpdate(cdLst,cdOldMap);
                ASC_CD_NamingConvention.updtContractDocName(cdLst,cdOldMap);                
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
@Description: contDocHndlr() method 
@Name : contDocHndlr
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
    private static testmethod void contDocHndlr(){
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestSysAdm','testsysadm@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr){
            try{
                list<ASC_Contractual_Document__c> cdLst = new list<ASC_Contractual_Document__c>();
                map<id,ASC_Contractual_Document__c> cdOldMap = new map<id,ASC_Contractual_Document__c>();
                Account accRec=GA_OBJ_TD01_TestDataCreation.AccRec();
                accRec.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get(ACC_RECORDTYPE).getRecordTypeId();
                database.insert(accRec);
                
                Contract contRec = new Contract();
                contRec.AccountId=accRec.Id;
                contRec.Status=DRAFT;
                contRec.StartDate=Date.today();
                contRec.RecordTypeId=Schema.SObjectType.Contract.getRecordTypeInfosByName().get(CONT_RECORDTYPE).getRecordTypeId();
                database.insert(contRec);
                
                ASC_Document_Language__c docLangRec = new ASC_Document_Language__c();
            //  docLangRec.ASC_Document_Language_Name__c=STR_TEST;
                docLangRec.ASC_Document_Type__c=SCHEDULEA;
                docLangRec.ASC_End_Date__c=Date.today()+10;
                docLangRec.ASC_Document_Language_Text__c=STR_TEST;
                database.insert(docLangRec);
                
                ASC_Contractual_Document__c cdRec = new ASC_Contractual_Document__c();
                cdRec.Name=STR_TEST;
                cdRec.ASC_Contract__c=contRec.Id;
                cdRec.ASC_Document_Language__c=docLangRec.Id;
                cdRec.ASC_Document_Type__c=CONTAMENDMENT;
                cdLst.add(cdRec);
                Database.insert(cdLst);
                cdRec.ASC_Document_Type__c=BASE_CONTRACT;
                cdRec.ASC_Signature_Required__c=true;
                cdLst.add(cdRec);
                database.update(cdLst);
                
                Test.startTest();
                ASC_ContractualDoc_TriggerHandler.beforeInsert(cdLst);
                ASC_ContractualDoc_TriggerHandler.beforeUpdate(cdLst,cdOldMap);
                Test.stopTest();
            }
            catch(exception e)
            {
                system.assert(e <> null);
                return;
            }
        }
    }
    //
    private static testmethod void conDocDuplicateTest(){
        try{
            user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestSysAdm','testsysadm@bcbsm.com','System Administrator');
            database.insert(usr);
            system.runAs(usr)
            {  
                
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
                database.insert (cntrcRcrd);
                
                ASC_Contractual_Document__c cntrcDocRcd = new ASC_Contractual_Document__c();
                cntrcDocRcd.Name = NAME;
                cntrcDocRcd.ASC_Contract__c = cntrcRcrd.id;
                cntrcDocRcd.ASC_Document_Type__c =DOCTYPE;      
                cntrcDocRcd.Document_Version__c =DOCVERSION;
                database.insert (cntrcDocRcd);
                
                Product2 prd1 = new Product2();
                prd1.vlocity_ins__Type__c = TYPE;
                prd1.ProductCode = PARPRD_CD;
                prd1.IsActive = true;
                prd1.Name = PRDNAME;
                prd1.Family = PARPRD_FAMILY;
                prd1.vlocity_ins__LineOfBusiness__c = PRD_LOB;
                prd1.RecordTypeId = prdRecordTypeId;
                prd1.vlocity_ins__SubType__c = TYPE;
                database.insert (prd1); 
                Product2 prd2 = new Product2();
                prd2.vlocity_ins__Type__c = TYPE;
                prd2.ProductCode = PARPRD_CD;
                prd2.IsActive = true;
                prd2.Name =PRDNAME;
                prd2.Family = PARPRD_FAMILY;
                prd2.vlocity_ins__LineOfBusiness__c = PRD_LOB;
                prd2.RecordTypeId = prdRecordTypeId1;
                prd2.vlocity_ins__SubType__c = TYPE;
                database.insert (prd2); 
                
                vlocity_ins__ContractLineItem__c plan1 = new vlocity_ins__ContractLineItem__c();
                plan1.vlocity_ins__Product2Id__c=Prd1.Id;
                plan1.ASC_Effective_Start_Date__c=system.today();
                plan1.ASC_AAC_PCNT__c=NUM;
                plan1.vlocity_ins__ContractId__c=cntrcRcrd.id;
                
                database.insert (plan1); 
                
                vlocity_ins__ContractLineItem__c plan2 = new vlocity_ins__ContractLineItem__c();
                plan2.vlocity_ins__Product2Id__c=Prd2.Id;
                plan2.ASC_Effective_Start_Date__c=system.today();
                plan2.ASC_AAC_PCNT__c=NUM;
                plan2.vlocity_ins__ContractId__c=cntrcRcrd.id;
                
                database.insert (plan2); 
                plan2.vlocity_ins__ParentItemId__c=plan1.id;
                database.update(plan2);
                system.debug(plan2.Id);
                
                Product_Document_Mapping__c pd=new Product_Document_Mapping__c();
                pd.name=NAME;
                pd.Coverage_Product__c=Prd2.id;
                pd.Parent_Product__c= prd1.id;
                database.insert (pd);
                
                ASC_Document_Type_Record__c docTypRec = new ASC_Document_Type_Record__c ();
                docTypRec.Name=NAME;
                docTypRec.Contract_Line_Item__c = plan2.id;
                docTypRec.Product_Document_Mapping__c =pd.id;
                docTypRec.Instance__c = instanNo;
                database.insert (docTypRec);
                
                ContentVersion cntvs = new ContentVersion();
                cntvs.Title = 'TestCV';
                cntvs.PathOnClient = 'TestCV.jpg';
                cntvs.VersionData = Blob.valueOf('Test Content');
                cntvs.IsMajorVersion = true;
                cntvs.GA_Type__c ='Email';
                Database.insert(cntvs) ;
                
                ContentVersion contentVersionSelect = [SELECT Id, Title, ContentDocumentId FROM ContentVersion WHERE Id = :cntvs.Id LIMIT 1];
                List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument Limit 200];
                
                list<ASC_Contractual_Document__c> cdLst = new list<ASC_Contractual_Document__c>();
                cdLst.add(cntrcDocRcd);
                 /*ASC_Document_Language__c docLangRec = new ASC_Document_Language__c();
                //docLangRec.ASC_Document_Language_Name__c='test';
                docLangRec.ASC_Document_Type__c='Schedule A';
                docLangRec.ASC_End_Date__c=Date.today()+10;
                docLangRec.ASC_Document_Language_Text__c='abcd';
                database.insert(docLangRec);
                docLangRec.ASC_Document_Language_Text__c='xyz';
               database.update(docLangRec);
*/
                map<id,ASC_Contractual_Document__c> cdOldMap =new map<id,ASC_Contractual_Document__c>([select Id,Name,
                ASC_Document_Type__c,ASC_Signature_Required__c from ASC_Contractual_Document__c]);
               
                test.startTest();
                ASC_AP_ASCDocTypeGeneration.fetchDocGenAccess(cntrcDocRcd.id,instanNo);
                ASC_ContractualDocument_Duplicate.duplicateCheckInsert(cdLst);
                ASC_ContractualDocument_Duplicate.duplicateCheckUpdate(cdLst,cdOldMap);
                
                ASC_ContractualDoc_TriggerHandler.beforeInsert(cdLst);
                ASC_ContractualDoc_TriggerHandler.beforeUpdate(cdLst,cdOldMap);
                list<ASC_Document_Language__c> docLangRec1 = new list<ASC_Document_Language__c>();
                ASC_Document_Language__c docLangRec = new ASC_Document_Language__c();
                //docLangRec.ASC_Document_Language_Name__c='test';
                docLangRec.ASC_Document_Type__c='Schedule A';
                docLangRec.ASC_End_Date__c=Date.today()+10;
                docLangRec.ASC_Document_Language_Text__c='abcd';
                docLangRec1.add(docLangRec);
                database.insert(docLangRec1);
                docLangRec.ASC_Document_Language_Text__c='xyz';
               database.update(docLangRec1);
                list<ASC_Document_Language__c> f1 = [select id,ASC_Document_Language_Text__c,ASC_Document_Type__c from ASC_Document_Language__c];
                map<id,ASC_Document_Language__c> f2 = new map<id,ASC_Document_Language__c>([select id,ASC_Document_Language_Text__c,ASC_Document_Type__c from ASC_Document_Language__c]);
                 ASC_AutoGenerateFiles.checkForDocLanguageTextUpdation(f1,f2);
                test.stopTest();
                
                system.assert(usr <> null);
                
            }
        }
        catch(exception e)
        {
            system.assert(e <> null);
            return;
        } 
    }
    //
    
}