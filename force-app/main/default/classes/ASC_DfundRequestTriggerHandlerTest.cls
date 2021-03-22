/**************************************************************************************************************************
@Author : off shore
@Name:ASC_DfundRequestTriggerHandlerTest 
@CreatedDate: 02 feb 2021
@Description: ASC_DfundRequestTriggerHandlerTest class is used to cover ASC_DfundRequestTriggerHandler class.
@version : 1.0  
@US Num: 
****************************************************************************************************************************/
@isTest(seealldata = false)
public class ASC_DfundRequestTriggerHandlerTest {
    private static final string NAME='Test';
    private static final string PHONE='9298282721';    
    private static final string ACCCID = '700002';
    private static final string BILL_PCODE = '48005';
	private static final string FEDTID = '123456789';
    private static final string STATUS ='New';
    private static final string NUM = '2019';
    private static final string INPROGRESS ='Inprogress';
	private static final string ACC_RECORDTYPE  ='Account - Customer';
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
     @testSetup 
    static void initData(){
        //Insert an Account in the ASCDEV Application
        Account acc=new Account();
        acc.Name=NAME;
        acc.Phone=PHONE;
        acc.CID__c=ACCCID;
        acc.Federal_Tax_ID__c=FEDTID;
        acc.Requested_Effective_Date__c=system.today();
        acc.GA_CoverageCancellationDate__c=system.today();        
        acc.BillingPostalCode = BILL_PCODE;
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(ACC_RECORDTYPE).getRecordTypeId();
        Database.insert(acc, false);
        
        //Insert Defund request
        Dfund_Request__c Dreq = new Dfund_Request__c();
        Dreq.Account__c=acc.Id;
        Dreq.Renewal_Year__c =NUM;
        Dreq.Status__c =STATUS;	
        Dreq.Status_Text__c =INPROGRESS;
        Database.insert(Dreq, false);
    } 
     /*******************************************************************************************************************************
    @Description: This test method is used to Cover ASC_DfundRequestTriggerHandler
    @Name : testMethod1
    @Param : None
    @Return : void
    @throws Exception : N/A;
    ********************************************************************************************************************************/   
 private static testMethod void testMethod1(){
     try{
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec(ROLE_NAM,EMAILVAL,PROF_NAM);
        database.insert(usr);
        system.runas(usr){
        test.startTest();
        ASC_DfundRequestTriggerHandler.beforeInsert(null);
        ASC_DfundRequestTriggerHandler.afterInsert(null);
        ASC_DfundRequestTriggerHandler.beforeUpdate(null,null);
        test.stopTest();
        }
     }
     catch(exception e)
        {
            system.assert(e <> null);
            return;
        }      

	} 


}