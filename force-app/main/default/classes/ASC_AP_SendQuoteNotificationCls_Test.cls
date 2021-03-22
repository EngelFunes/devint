/**************************************************************************************************************************
@Author : Dinesh
@Name: ASC_AP_SendQuoteNotificationCls_Test 
@CreatedDate: 23 Apr 2020
@Description: ASC_AP_SendQuoteNotificationCls_Test class is used to cover ASC_AP_SendQuoteNotificationCls class
@version : 1.0  
@US Number: US-2534

---Modified --
@US3350 Added By Dinesh- updated - 07/21/2020
****************************************************************************************************************************/
@isTest(seealldata = false)
private class ASC_AP_SendQuoteNotificationCls_Test {
    
    private static final string TYPE  ='ASC Product';
    private static final string PRODNAME  ='TEST Product';
    private static final string NAME='TEST'; 
    private static final string PHONE='9876543211';    
    private static final string ASC_QTRECTYPE = 'ASC Quote';
    private static final string RENW_YEAR = '2021';
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
    private static final Id ASCCON_RECID = 
    Schema.SObjectType.Contract.getRecordTypeInfosByName().get(ASC_CONT).getRecordTypeId(); 
    private static final string ROLE_NAM = 'TestUser';
    private static final string EMAILVAL = 'testUser@bcbsm.com';
    private static final string EMAILINVALID = 'testUser@bcbsm.com.invalid';
    private static final string PROF_NAM = 'System Administrator';
    private static final Id PRDCOVSPECRECTYPEID = 
    Schema.SObjectType.Product2.getRecordTypeInfosByName().get(COV_SPEC).getRecordTypeId(); 
    private static final string CARR_BCN = 'BCN';
    private static final string DRAFT_STR = 'Draft';
    private static final string DATE_ST = '05/05/2021';
    private static final string DATE_END = '06/06/2021';
    //private static final String EMAILTEMPLATE ='ASC_Quote_Notification_VF';     
    private static final string ACNAME  ='test acc name';
    private static final string REN_MONTH  ='12';
    private static final string QUOTSTR  ='Quote';
    private static final string TESTTITLE  ='test title';
    private static final string TESTMSG  ='test msg';
    private static final string SALES_CHK ='Sales';
    private static final string UW_CHK ='UW';
    private static final string SPOC_CHK ='SPOC';
    private static final string UNDERWRITING = 'Underwriting';
    private static final string TESTITLE = 'Test Title';
    private static final string TESTMSG1 = 'Test Msg';
    private static final string FEDTXID = '123456';
    private static final String TESTASCQUOTENOTIFICATION ='Test ASC Quote Notification';
    private static final String TEST_ASC_QUOTE_NOTIFICATION ='Test_ASC_Quote_Notification';
    private static final String TYPETEXT ='text';
    private static final String HTMLTEST ='html test';
    private static final String STR_EMPTY ='';

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

            user usr = GA_OBJ_TD01_TestDataCreation.UsrRec(ROLE_NAM,EMAILVAL,PROF_NAM);
            usr.Department = UNDERWRITING;
            database.insert(usr);

            Account acc=new Account();
            acc.Name=NAME;
            acc.Phone=PHONE;
            acc.CID__c=ACCCID;
            acc.Federal_Tax_ID__c=ACCCID;
            acc.Requested_Effective_Date__c=system.today();
            acc.GA_CoverageCancellationDate__c=system.today();        
            acc.BillingPostalCode = BILL_PCODE;
            acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(ACC_RECORDTYPE).getRecordTypeId();
            acc.GA_Underwriting__c  = usr.Id;
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
            
            Id pricebookId = Test.getStandardPricebookId();                                    
            Quote quot = new Quote();
            quot.Name = QTNAME;
            quot.opportunityId = Opp.Id;
            quot.pricebook2Id = pricebookId;
            quot.RecordTypeId = QTRECTYPID;
            quot.ASC_CID__c = ACCCID;
            quot.ASC_Carrier__c = CARR_BCN;
            quot.ASC_Renewal_Year__c = RENW_YEAR;
            quot.ASC_Email_Title__c = TESTTITLE;
            quot.ASC_Email_Message__c = TESTMSG1;
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
            cntrcRcrd.StartDate = system.today();
            cntrcRcrd.recordtypeid = ASCCON_RECID;
            database.insert(cntrcRcrd);
            
            Contract cntrcRcrd1 = new Contract ();
            cntrcRcrd1.AccountId = acc.Id;
            cntrcRcrd1.Status = DRAFT_STR;
            cntrcRcrd1.StartDate = system.today();
            cntrcRcrd1.recordtypeid = ASCCON_RECID;
            database.insert(cntrcRcrd1);
            
            user usr1 = GA_OBJ_TD01_TestDataCreation.UsrRec(ROLE_NAM,EMAILVAL,PROF_NAM);
            usr1.Department = UNDERWRITING;
            database.insert(usr1);

            Account acc1=new Account();
            acc1.Name=NAME;
            acc1.Phone=PHONE;
            acc1.CID__c=ACCCID;
            acc1.Federal_Tax_ID__c= FEDTXID;
            acc1.Requested_Effective_Date__c=system.today();
            acc1.GA_CoverageCancellationDate__c=system.today();        
            acc1.BillingPostalCode = BILL_PCODE;
            acc1.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(ACC_RECORDTYPE).getRecordTypeId();
            acc1.GA_Underwriting__c  = usr1.Id;
            Database.insert(acc1,false);
    }
    /*******************************************************************************************************************************
    @Description: This test method is used to cover the sendQuoteNotification and sendQuoteMails method.
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
        String[] usrMailIds= New String[]{};

        List<String> selectedchk = new List<String>{SALES_CHK,UW_CHK,SPOC_CHK};
        Quote quot1 = [Select Id from Quote where RecordTypeId =:QTRECTYPID Limit 1];
        Account acc =[Select Id, Name,Owner.Email,GA_Underwriting__r.Email,ASC_SPOC_Mail_Id__c,
                          ASC_Contract_Renewal_Month__c from Account Limit 1];
        usrMailIds.add(acc.Owner.Email);
        usrMailIds.add(acc.GA_Underwriting__r.Email);

        String [] emailsAsArray = new String[]{};
                        
        EmailTemplate validEmailTemplate = new EmailTemplate();
        validEmailTemplate.isActive = true;
        validEmailTemplate.Name = TESTASCQUOTENOTIFICATION;
        validEmailTemplate.DeveloperName = TEST_ASC_QUOTE_NOTIFICATION;
        validEmailTemplate.TemplateType = TYPETEXT;
        validEmailTemplate.FolderId = UserInfo.getUserId();
        validEmailTemplate.HtmlValue = HTMLTEST;        
        Database.insert(validEmailTemplate,false);
                      
        string orgURL=system.label.GA_Org_Base_URL;
        string emailTmpltId=validEmailTemplate.Id;
        String toemailmsg = STR_EMPTY;
        String htmlBody = validEmailTemplate.HtmlValue;
      
        ASC_AP_SendQuoteNotificationCls.reviewBttn();        
        ASC_AP_SendQuoteNotificationCls.sendQuoteNotification(quot1.Id,TESTTITLE,TESTMSG,selectedchk);
        ASC_AP_SendQuoteNotificationCls.sendQuoteMails(ACNAME,REN_MONTH,
                                                       quot1,QUOTSTR,
                                                       TEST_ASC_QUOTE_NOTIFICATION, usrMailIds, true);
        }
      }
      catch(exception e)
      {
            system.assert(e <> null);
            return;
      }
    }
    /*******************************************************************************************************************************
    @Description: This test method is used to add the GA Underwriting Email.
    @Name : testmethod1
    @Param : None
    @Return : void
    @throws Exception : N/A;
    ********************************************************************************************************************************/    
    public static testmethod void testmethod2(){ 
     try{
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec(ROLE_NAM,EMAILVAL,PROF_NAM);
        
        database.insert(usr);
        system.runAs(usr){
        String[] usrMailIds= New String[]{};

        List<String> selectedchk = new List<String>{SALES_CHK,UW_CHK,SPOC_CHK};
        Quote quot1 = [Select Id,Name,ASC_CID__c,ASC_Email_Title__c,ASC_Carrier__c,ASC_Email_Message__c
                         from Quote where RecordTypeId =:QTRECTYPID Limit 1];
        Account acc =[Select Id, Name,Owner.Email,GA_Underwriting__r.Email,ASC_SPOC_Mail_Id__c,
                          ASC_Contract_Renewal_Month__c from Account where Federal_Tax_ID__c= '123456' Limit 1];

        usrMailIds.add(acc.GA_Underwriting__r.Email);
        String [] emailsAsArray = new String[]{};
        
        /*EmailTemplate emailTmplt= [SELECT Id,HtmlValue,Subject,Markup FROM EmailTemplate 
                      WHERE DeveloperName = :emailTemplate Limit 1];  */
                                      
        EmailTemplate validEmailTemplate = new EmailTemplate();
        validEmailTemplate.isActive = true;
        validEmailTemplate.Name = TESTASCQUOTENOTIFICATION;
        validEmailTemplate.DeveloperName = TEST_ASC_QUOTE_NOTIFICATION;
        validEmailTemplate.TemplateType = TYPETEXT;
        validEmailTemplate.FolderId = UserInfo.getUserId();
        validEmailTemplate.HtmlValue = HTMLTEST;        
        Database.insert(validEmailTemplate,false);
                      
        string orgURL=system.label.GA_Org_Base_URL;
        string emailTmpltId=validEmailTemplate.Id; //emailTmplt.Id;
        String toemailmsg = STR_EMPTY;
        String htmlBody = validEmailTemplate.HtmlValue; //emailTmplt.HtmlValue;

        ASC_AP_SendQuoteNotificationCls.reviewBttn();
        ASC_AP_SendQuoteNotificationCls.sendQuoteNotification(quot1.Id,TESTTITLE,TESTMSG,selectedchk);
        ASC_AP_SendQuoteNotificationCls.sendQuoteMails(ACNAME,REN_MONTH,quot1,QUOTSTR,TEST_ASC_QUOTE_NOTIFICATION, usrMailIds, true);
        }
      }
      catch(exception e)
      {
            system.assert(e <> null);
            return;
      }
    }      
}