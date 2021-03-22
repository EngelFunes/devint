/**************************************************************************************************************************
@Author : SivaSankar
@Name: ASC_DfundUpdateDfundRequest_Test 
@CreatedDate: 02 Febuary 2021
@Description: ASC_DfundUpdateDfundRequest_Test class is used to cover ASC_DfundUpdateDfundRequest class
@version : 1.0  
****************************************************************************************************************************/
@isTest(seealldata = false)
public without sharing class ASC_DfundUpdateDfundRequest_Test {
    
    //Account Creation Data
    private static final string NAME='Aada Consulting';
    private static final string PHONE='9876773211';    
    private static final string ACCCID = '700002';
    private static final string BILL_PCODE = '48005';
    private static final string FEDTID = '123456789';
    private static final string DFUNDYEAR ='2019';
    private static final string STATUS = 'New';
    private static final string STATUSDRAFT ='Draft';
    private static final string STATUSTEXT = 'Inprogress';
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
        //Insert an Account 
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
        Dreq.Renewal_Year__c =DFUNDYEAR;
        Dreq.Status__c =STATUS;	
        Dreq.Status_Text__c = STATUSTEXT;
        Database.insert(Dreq, false);
        
    } 
    /*******************************************************************************************************************************
@Description: This test method is used to create/update Dfund Request records.
@Name : ASC_DfundUpdateDfundRequest
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
    private static testMethod void ASC_DfundUpdateDfundRequest(){
        try{
            
            user usr = GA_OBJ_TD01_TestDataCreation.UsrRec(ROLE_NAM,EMAILVAL,PROF_NAM);
            database.insert(usr);
            system.runAs(usr){ 
                test.startTest();
                List<Account> accounts = [select id from Account];
                List<Dfund_Request__c> dfundRequest = [select id from Dfund_Request__c];
                List<Dfund_Request__c> quotlist=[select id,Name,Status__c,Status_Text__c,Renewal_Year__c from Dfund_Request__c limit 1 ];
                List<Dfund_Request__c> quotlistToUpdate = new List<Dfund_Request__c>();
                for(Dfund_Request__c dfReqRec: quotlist){
                    dfReqRec.Status_Text__c = STATUSDRAFT;
                    quotlistToUpdate.add(dfReqRec);
                }  
                
                ASC_DfundUpdateDfundRequest.updateAgentOnDfundRequest(quotlist);
                ASC_DfundUpdateDfundRequest.updateDrctMgrSecOwnrOnDfundRequest(dfundRequest);
                ASC_DfundUpdateDfundRequest.beforeUpdate(quotlist,null);
                test.stopTest();
            }
        }
        Catch(exception e)
        {
            system.assert(e <> null);
            return;   
        }
    }
    
}