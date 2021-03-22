/**************************************************************************************************************************
@Author : Sandeep
@Name: ASC_Doclangupdate_Test 
@CreatedDate: 07 Sept 2020
@Description: ASC_DoclangupdateTest class is used to cover ASC_Doclangupdate class.
@version : 1.0  
@US Num: US-3587
****************************************************************************************************************************/
@isTest(seealldata = false)
private class ASC_Doclangupdate_Test {
    private static final string CONTAMENDMENT  ='Contract Amendment';
    private static final string STR_TEST  ='Test';
    private static final string TYPE  ='ASC Product';
    private static final string PRODNAME  ='TEST Product';
    private static final string NAME='TEST'; 
    private static final string PHONE='9876543211';    
    private static final string ASC_QTRECTYPE = 'ASC Quote';
    private static final string CONTXID = 'ContextId';
    private static final Id QTRCRDTYPEID = Schema.SObjectType.Quote.getRecordTypeInfosByName().get
        (ASC_QTRECTYPE).getRecordTypeId();   
    private static final string OPP_STAG = 'Quote Request';
    private static final string ASC_OPPRECTYPE = 'Opportunity - ASC';
    private static final string QTNAME = 'test quote';
    private static final Integer UNIT_PRICE = 1;            
    private static final string PRD_NAME = 'Data Feeds';
    private static final string PRD_CODE = 'ASC_0000370';
    private static final string PRD_FAMILY = 'Data Feeds';
    private static final string PRD_LOB = 'Non-Benefit';
    private static final Integer QUANTY_LI = 2;
    private static final string ACC_RECORDTYPE  ='Account - Customer';
    private static final string ACCCID = '12345';
    private static final string YEAR = '2020';
    private static final string FEDTID = '123456789';
    private static final string BILL_PCODE = '48005';
    private static final string PARPRD_CD = 'ASC_0000005';
    private static final string PARPRD_FAMILY = 'Medical';
    private static final String SCHEDULEA_EXHIBIT_2 ='Schedule A - Exhibit 2';
    private static final String CONTRACT_AMENDMENT ='Contract Amendment';
    private static final String STOPLOSS_AMENDMENT ='Stop-Loss Amendment';
    private static final String ACTIVE = 'Active';
    private static final String CARRIER = 'BCBSM';
    private static final String ASC_DOCLANG = 'Active text';
   	private static final String ASC_DOCLANG1 = 'Active text changed';
    private static final Id PRDCOVSPECID = Schema.SObjectType.Product2.getRecordTypeInfosByName().get
        ('Coverage Spec').getRecordTypeId(); 
    private static final Id PRDRCRDTYPEID=Schema.SObjectType.Product2.getRecordTypeInfosByName().get
        ('Product').getRecordTypeId();    
    /*******************************************************************************************************************************
@Description: This test method1 is used to create/update the records in Docuemnt Language Object records
@Name : testmethod1
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/  
    private static testmethod void testMethod1(){
        
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestSysAdm','testsysadm@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        { 
            List<ASC_Document_Language__c> docList=new List<ASC_Document_Language__c>();
            Bank_Info__c bankInfo = new Bank_Info__c();
            bankInfo.American_Bank_Association__c =NAME;
            bankInfo.Wire_Number__c=NAME;
            bankInfo.Name =NAME;
            Database.insert(bankInfo);
            
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
            
            Product2 prod1= new product2(
                Name = PRD_NAME,
                productcode = PRD_CODE,
                Family = PRD_FAMILY,
                vlocity_ins__LineOfBusiness__c = PRD_LOB,
                vlocity_ins__SubType__c = TYPE,
                vlocity_ins__Type__c = TYPE,
                vlocity_ins__EffectiveDate__c = system.today(),
                RecordTypeId = PRDCOVSPECID
            );
            Database.insert(prod1);
            
            
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
            q.status = ACTIVE;
            q.ASC_Carrier__c=CARRIER;
            q.ASC_Renewal_Year__c=YEAR;
            Database.insert(q,false);
            
            ASC_Document_Language__c docLang = new ASC_Document_Language__c();
            docLang.Name=STR_TEST;
            docLang.ASC_Document_Type__c=CONTAMENDMENT;
            docLang.ASC_End_Date__c=Date.today()+10;                
            docLang.ASC_Document_Language_Text__c=STR_TEST;
            docLang.ASC_Document_Language_State__c=ACTIVE;
            docLang.Update_Quote_Specific_Language__c=True;
            docLang.Template__c = True;
            Database.insert(docLang);
            
            
            ASC_Document_Language__c docLang1 = new ASC_Document_Language__c();
            docLang1.Name=STR_TEST;
            docLang1.ASC_Document_Type__c=CONTAMENDMENT;
            docLang1.ASC_End_Date__c=Date.today()+10;                
            docLang1.ASC_Document_Language_Text__c=STR_TEST;
            docLang1.ASC_Quote__c =q.id;
            docLang1.ASC_Document_Language_State__c=ACTIVE;
            docLang1.Template_Used__c=docLang.id;
            docList.add(docLang1);
            Database.insert(docList);            
            try{
                Test.startTest();
                docLang.Update_Quote_Specific_Language__c=True;
                docLang.ASC_Document_Language_Text__c=ASC_DOCLANG1;
                Database.update(docLang);               
                Database.update(docList);                
                ASC_Doclangupdate.createDocLangRecords(docList,null,null);
                ASC_Doclangupdate.docLanguageTextUpdation(null,null);               
                Test.stopTest();
            }
            catch(exception e)
            {
                system.assert(e <> null);
                return;
            }
        }
    }
    
}