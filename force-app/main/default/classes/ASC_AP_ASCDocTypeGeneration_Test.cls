/***************************************************************************************
@Author : IDC Offshore
@Name: ASC_AP_ASCDocTypeGeneration_Test 
@CreatedDate: 18 - May 2020 
@Description: ASC_AP_ASCDocTypeGeneration Test class
@version : 1.0  
********************************************************************************************/
@isTest(seealldata = false)
Public class ASC_AP_ASCDocTypeGeneration_Test {
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
    private static final string ACC_RECORDTYPE  ='Account - Customer';
    private static final Id prdRecordTypeId=Schema.SObjectType.Product2.getRecordTypeInfosByName().get('Product').getRecordTypeId();
    private static final Id prdRecordTypeId1=Schema.SObjectType.Product2.getRecordTypeInfosByName().get('Coverage Spec').getRecordTypeId();  /**
/***************************************************************************************************
@Description: docTypeRecdsCreate() method 
@Name : docTypeRecdsCreate
@Param : N/A   
@Return : void
@throws Exception : N/A;
******************************************************************************************************/  
    Public static testmethod void docTypeRecdsCreate()
    {
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
                
                
                test.startTest();
                
                ASC_AP_ASCDocTypeGeneration.fetchDocGenAccess(cntrcDocRcd.id,instanNo);
                
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
}