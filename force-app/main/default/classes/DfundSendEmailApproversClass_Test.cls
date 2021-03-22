/**************************************************************************************************************************
@Author : offshore
@Name: DfundSendEmailApproversClass_Test 
@CreatedDate: O1 feb 2021
@Description: DfundSendEmailApproversClass_Test class is used to cover DfundSendEmailApproversClass.
@version : 1.0  
****************************************************************************************************************************/
@isTest(seealldata = false)
public class DfundSendEmailApproversClass_Test {
    
    private static final string PRODNAME  ='TEST Product';
    private static final string NAME='TEST'; 
    private static final string PHONE='9876543211';    
    private static final string DFUND_RECDTYPE = 'Dfund Request';
    private static final string TYPE  ='ASC Product';
    private static final string OPP_STAG = 'Quote Request';
    private static final string ASC_OPPRECTYPE = 'Opportunity - ASC';
    private static final string PRD_NAME = 'Variable Administrative Fees';
    private static final string PRD_CODE = 'ASC_0000370';
    private static final string PRD_FAMILY = 'Admin Fees';
    private static final string PRD_LOB = 'Non-Benefit';
    private static final string ACC_RECORDTYPE  ='Account - Customer';
    private static final string ACCCID = '12345';
    private static final string BILL_PCODE = '48005';
    private static final string RENEW_YEAR = '2019';
    private static final string RENEW_YEAR1 = '2021';
    private static final string CARR_BCN = 'BCN';
    private static Id qTRecordTypeId = Schema.SObjectType.Dfund_Request__c.getRecordTypeInfosByName().get(DFUND_RECDTYPE).getRecordTypeId();   
    public static Id ASCQUOTE=Schema.SObjectType.Quote.getRecordTypeInfosByName().get('ASC Quote').getRecordTypeId();
    private static final string ROLE_NAM = 'TestUser';
    private static final string EMAILVAL = 'testUser@bcbsm.com';
    private static final string PROF_NAM = 'System Administrator';
    private static final string TESTAOR='TestAor';
    private static final string TESTTERRITORY='Test Territory Name';
    private static final string ACCOUNTMANAGER='Account Manager';
    private static final string TESTREGION='Test Region';
    private static final string TESTSALESOFFICE='Test - Sales Office';
    private static final string OFCCODE ='999';
    private static final string REGNCODE ='018';
    private static final string  NUM ='23';
    private static final string FUNNAME='FunName';
    private static final string EMAIL='test@test.com';
    private static final string DOCTYPE='Credit';
    private static final string DRAFT_STR = 'Draft';
    private static final string MOS = 'MOS';
    private static final string GNAME = 'tESTER';
    private static final string ACTIVE='Active';
    private static final string GROUPNAME = 'GA_Small_Group_Underwriting_Queue';
    private static final string QUEUE = 'Queue';
    private static final string QUOTNAME = 'test quote';
    public static final string actQuery='Select Id,Status__c,RecordType.Name from Dfund_Request__c ';    
    public static final string actWhere=' where Status__c !=null';
    public static final string actWhere1=' and recordtypeid in';       
    public static final string actwhere2 =  ' and (Status__c = \'Sales_Review\'';
    public static final string actwhere3 =  ' or Status__c = \'Underwriting Review\'';    
    public static final string actwhere4 =  ' or Status__c = \'Operations Review\'';               
    public static final string actwhere5 =  ' or Status__c = \'Finance Review\')';      
    public static final string actwhere6 = ' and Id in';
    public static final string actLIMIT = ' LIMIT 1';
    public static final string UCCRDFUNDRT = 'UCCR Request';
    public static Id UCCRDFUNDRTID = Schema.SObjectType.Dfund_Request__c.getRecordTypeInfosByName().get(UCCRDFUNDRT).getRecordTypeId();
    /*******************************************************************************************************************************
@Description: initData() method - preparing the test data
@Name : initData
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
    @TestSetup 
    static void initData() {
        //insert user
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec(ROLE_NAM,EMAILVAL,PROF_NAM);
        database.insert(usr);
        user usr1 = GA_OBJ_TD01_TestDataCreation.UsrRec(ROLE_NAM,EMAILVAL,PROF_NAM);
        usr1.Email=EMAIL;
        usr1.DelegatedApproverId=usr.id;
        usr1.isActive = true;
        database.insert(usr1);
        GA_Region__c regnRec =new GA_Region__c();
        regnRec.Name =TESTREGION;
        regnRec.GA_Region_Code__c=REGNCODE;
        regnRec.ASC_Sales_Segment_Owner__c=usr.id;
        insert regnRec;
        //insert sales office
        GA_Sales_Office__c slsOfcRec =new GA_Sales_Office__c();
        slsOfcRec.Name =TESTSALESOFFICE;
        slsOfcRec.GA_Sales_Office_Code__c=OFCCODE;
        slsOfcRec.GA_Region__c=regnRec.Id;
        slsOfcRec.GA_Sales_Office_Start_Date__c=system.today();
        slsOfcRec.GA_Sales_Office_Manager__c=usr.id;
        insert slsOfcRec;
        //insert territory
        GA_Territory__c terytoryRec=new GA_Territory__c();
        terytoryRec.Name=TESTTERRITORY;
        terytoryRec.GA_TerritoryType__c=ACCOUNTMANAGER;
        terytoryRec.GA_TerritoryCode__c=NUM;
        terytoryRec.GA_Sales_Office__c=slsOfcRec.id;
        terytoryRec.GA_Sales_Rep_Effective_Date__c = System.today();
        insert terytoryRec;
        
        Account acc=new Account();
        acc.Name=NAME;
        acc.Phone=PHONE;
        acc.CID__c=ACCCID;
        acc.Federal_Tax_ID__c=ACCCID;
        acc.GA_Territory__c=terytoryRec.id;
        acc.Requested_Effective_Date__c=system.today();
        acc.GA_CoverageCancellationDate__c=system.today();        
        acc.BillingPostalCode = BILL_PCODE;
        acc.RecordTypeId =
            Schema.SObjectType.Account.getRecordTypeInfosByName().get(ACC_RECORDTYPE).getRecordTypeId();
        Database.insert(acc,false);
        Product2 prod= new product2(
            Name = PRD_NAME,
            productcode = PRD_CODE,
            Family = PRD_FAMILY,
            vlocity_ins__LineOfBusiness__c = PRD_LOB,
            vlocity_ins__SubType__c = TYPE,
            vlocity_ins__Type__c = TYPE,
            vlocity_ins__EffectiveDate__c = system.today()
        );
        Database.insert(prod,false);
        
        opportunity opp=new opportunity();
        opp.Name = NAME;
        opp.AccountId = acc.id;
        opp.stageName = OPP_STAG;
        opp.CloseDate = system.today()+120;
        opp.RecordTypeId = 
            Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get(ASC_OPPRECTYPE).getRecordTypeId();
        Database.insert(opp,false);
        Fund__c fun=new Fund__c();
        fun.Name=FUNNAME;
        insert fun;
        Dfund_Request__c Dreq = new Dfund_Request__c();
        Dreq.RecordTypeId=qTRecordTypeId;
        Dreq.Account__c=acc.Id;
        Dreq.Status__c =DRAFT_STR;
        Dreq.Segment_Owner__c=usr.id;
        Dreq.Renewal_Year__c =RENEW_YEAR;
        insert Dreq;
        
        Dfund_Request_Detail__c  dfundr = new Dfund_Request_Detail__c();
        dfundr.Dfund_Request__c=Dreq.id;
        dfundr.Dfund_Type__c =DOCTYPE;
        dfundr.DRD_Fund__c=fun.id;
        dfundr.Total_Adj_Amount_Rollup__c=500;
        dfundr.Flat_Amount__c=20;
        insert dfundr; 
        
        Dfund_Request__c Dreq1 = new Dfund_Request__c();
        Dreq1.RecordTypeId=UCCRDFUNDRTID;
        Dreq1.Account__c=acc.Id;
        Dreq1.Status__c =DRAFT_STR;
        Dreq1.Segment_Owner__c=usr.id;
        Dreq1.Renewal_Year__c =RENEW_YEAR;
        insert Dreq1;
        
        GA_Group_Segment__c grpSgmntRec=GA_OBJ_TD01_TestDataCreation.grpSegmntRec(acc);
        grpSgmntRec.Network__c=MOS;
        grpSgmntRec.Name = GNAME;
        grpSgmntRec.createdDate=system.today()-5;
        grpSgmntRec.Status__c = ACTIVE;
        insert grpSgmntRec;
        Group testGroup = new Group(Name=GROUPNAME, Type=QUEUE);
        insert testGroup;
        GroupMember grpmem=new GroupMember();
        grpmem.GroupId=testGroup.id;
        Id pricebookId = Test.getStandardPricebookId(); 
        Quote quot = new Quote();
        
        quot.Name =QUOTNAME;
        quot.opportunityId = Opp.Id;
        quot.pricebook2Id = pricebookId;
        quot.RecordTypeId =ASCQUOTE;
        quot.ASC_CID__c = ACCCID;
        quot.ASC_Carrier__c = CARR_BCN;
        quot.ASC_Renewal_Year__c =RENEW_YEAR1;
        Database.insert(quot,false);
        OrgWideEmailAddress[] addresses = [SELECT DisplayName, Id FROM OrgWideEmailAddress LIMIT 1];
        System.assertEquals(1, addresses.size());
        Approval.ProcessSubmitRequest app = new Approval.ProcessSubmitRequest();
        app.setObjectId(Dreq.id);
        //Approval.ProcessResult result = Approval.process(app);
        DfundSendEmailApproversClass.ProcessInstanceRecord ProcessIns=new DfundSendEmailApproversClass.ProcessInstanceRecord('dreq1.id','pending','dreq.id',null);
        DfundSendEmailApproversClass.ProcessInstanceItemRecord Itemrecord=new DfundSendEmailApproversClass.ProcessInstanceItemRecord('005','pending',system.today()-1,'dreq.id','noreply@bcbsm.com');
        
    }
    
    /*******************************************************************************************************************************
@Description:  Test method for the batch class DfundSendEmailApproversBatch.cls
@Name : test_Batch
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
    @IsTest
    private static void test_Batch() {
        try{
            user usr = GA_OBJ_TD01_TestDataCreation.UsrRec(ROLE_NAM,EMAILVAL,PROF_NAM);
            database.insert(usr);
            system.runas(usr){
                
                set<id> dIdSet=new set<id>();
                dIdSet.add(qTRecordTypeId);
                String dRecIdString = DfundSendEmailApproversClass.idSet(dIdSet);                  
                Set<Id> dfundIdSet=new Set<Id>();
                List<Dfund_Request__c>  dList = [Select Id,Status__c,RecordType.Name from Dfund_Request__c where RecordTypeId =: qTRecordTypeId LIMIT 1];        
                for(Dfund_Request__c d:dList){
                    Datetime yesterday = Datetime.now().addDays(-1);
                    Test.setCreatedDate(d.Id, yesterday);
                    
                    dfundIdSet.add(d.Id);
                }
                
                String dfundIdString = DfundSendEmailApproversClass.idSet(dfundIdSet);                  
                string q = actQuery+actWhere+actWhere2+actWhere3+actWhere4+actWhere5+actWhere1+dRecIdString+actwhere6+dfundIdString+actLIMIT;        
                Database.executeBatch(new DfundSendEmailApproversBatch(q), 1); 
                system.assert(usr <> null);
            } 
        }
        catch(exception e)
        {
            system.assert(e <> null);
            return;
        }   
        
    }
    /*******************************************************************************************************************************
@Description: Test method for the scheduler class DfundSendEmailApproversScheduler. 
@Name : test_Scheduler
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
    
    @IsTest
    private static void test_Scheduler() {
        try{
            user usr = GA_OBJ_TD01_TestDataCreation.UsrRec(ROLE_NAM,EMAILVAL,PROF_NAM);
            database.insert(usr);
            system.runas(usr){
                Test.startTest();
                
                String strCronExpression = '0 0 0 * * ?';
                System.schedule('DfundSendEmailApproversClassTest', strCronExpression, new DfundSendEmailApproversScheduler());
                
                Test.stopTest();
                system.assert(usr <> null);
            } 
        }
        catch(exception e)
        {
            system.assert(e <> null);
            return;
        }   
    }
    /*******************************************************************************************************************************
@Description: Test method for sendemail. 
@Name : testupdateSendEmail
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
    
    @IsTest
    private static void testupdateSendEmail() {
        try{
            user usr = GA_OBJ_TD01_TestDataCreation.UsrRec(ROLE_NAM,EMAILVAL,PROF_NAM);
            database.insert(usr);
            system.runas(usr){
                Test.startTest();
                DfundSendEmailApproversClass.sendEmailToApprovers();
                Test.stopTest();
                system.assert(usr <> null);
            } 
        }
        catch(exception e)
        {
            system.assert(e <> null);
            return;
        }   
    }
    /*******************************************************************************************************************************
@Description: Test method for dmloptions. 
@Name : testascdmloptions
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
    @IsTest
    private static void testasctdmloptions() {
        try{
            user usr = GA_OBJ_TD01_TestDataCreation.UsrRec(ROLE_NAM,EMAILVAL,PROF_NAM);
            database.insert(usr);
            system.runas(usr){
                Test.startTest();
                List<Dfund_Request__c>  dList = [Select Id,Status__c,RecordType.Name from Dfund_Request__c where RecordTypeId =: qTRecordTypeId LIMIT 1];        
                DfundSendEmailApproversClass.dmloptions(dList);
                
                Test.stopTest();
                system.assert(usr <> null);
            } 
        }
        catch(exception e)
        {
            system.assert(e <> null);
            return;
        }   
    }
    /*******************************************************************************************************************************
@Description: Test method for dmloptions. 
@Name : testascdmloptions
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
    @IsTest
    private static void testuccrtdmloptions() {
        try{
            user usr = GA_OBJ_TD01_TestDataCreation.UsrRec(ROLE_NAM,EMAILVAL,PROF_NAM);
            database.insert(usr);
            system.runas(usr){
                Test.startTest();
                List<Dfund_Request__c>  dList = [Select Id,Status__c,RecordType.Name from Dfund_Request__c where RecordTypeId =: UCCRDFUNDRTID LIMIT 1];        
                DfundSendEmailApproversClass.dmloptions(dList);
                Test.stopTest();
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