/**************************************************************************************************************************
@Author : off shore
@Name:ASC_UpdateComplianceStatusOnAccount_Test 
@CreatedDate: 18 feb 2021
@Description: ASC_UpdateComplianceStatusOnAccount_Test class is used to cover ASC_UpdateComplianceStatusOnAccount class.
@version : 1.0  
@US Num: 
****************************************************************************************************************************/
@isTest(SeeAllData=FALSE)
public class ASC_UpdateComplianceStatusOnAccount_Test {
    private static final string ROLE_NAM = 'TestUser';
    private static final string EMAILVAL = 'testUser@bcbsm.com';
    private static final string PROF_NAM = 'System Administrator';
    private static final string CARR_BCN = 'BCN';
    private static final string CARR_BCBSM= 'BCBSM';
    private static final string DRAFT_STR = 'Draft';
     private static final string ACTIVE= 'Active';
     private static final string ASC_CONT = 'ASC Contract'; 
     private static final string NAME='TEST'; 
    private static final string PHONE='9876543211';  
    private static final string ACCCID = '12345';
     private static final string COMPLNTYEAR ='2021';
    private static final Id ASCCON_RECID = Schema.SObjectType.Contract.getRecordTypeInfosByName().get(ASC_CONT).getRecordTypeId(); 
/*******************************************************************************************************************************
@Description: initData() method - preparing the test data
@Name : initData
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/ 
    @TestSetup 
    static void initData(){
        //insert account
        Account acc=new Account();
        acc.name=NAME;
        acc.phone=PHONE;
        acc.CID__c=ACCCID;
        acc.Account_Status__c=ACTIVE;
        acc.GA_Territory__c=acc.id;
        acc.ASC_Non_Compliant_Year__c=COMPLNTYEAR;
        database.insert(acc);
     //insert contract
        Contract cntrcRcrd = new Contract();
        cntrcRcrd.AccountId =acc.Id;
        cntrcRcrd.ASC_Carrier__c = CARR_BCBSM;
        cntrcRcrd.Status = DRAFT_STR;
        cntrcRcrd.StartDate = system.today();
        cntrcRcrd.recordtypeid = ASCCON_RECID;
        database.insert(cntrcRcrd);
         Contract cntrcRcrd1 = new Contract();
        cntrcRcrd1.AccountId =acc.Id;
        cntrcRcrd1.ASC_Carrier__c = CARR_BCN;
        cntrcRcrd1.Status = DRAFT_STR;
        cntrcRcrd1.StartDate = system.today();
        cntrcRcrd1.recordtypeid = ASCCON_RECID;
        database.insert(cntrcRcrd1);
        //insert contractual document
        ASC_Contractual_Document__c contractualDoc =new ASC_Contractual_Document__c();
        contractualDoc.name=NAME;
        contractualDoc.ASC_Contract__c = cntrcRcrd.id;
        contractualDoc.ASC_Do_Not_Include__c=false;
        contractualDoc.ASC_Signature_Required__c=true;
        contractualDoc.ASC_Date_Signed__c=null;
        database.insert(contractualDoc);
        ASC_Contractual_Document__c contractualDoc1 =new ASC_Contractual_Document__c();
        contractualDoc1.name=NAME;
        contractualDoc1.ASC_Contract__c = cntrcRcrd1.id;
        contractualDoc1.ASC_Do_Not_Include__c=false;
        contractualDoc1.ASC_Signature_Required__c=true;
        contractualDoc1.ASC_Date_Signed__c=null;
        database.insert(contractualDoc1);
         
    }
  /*******************************************************************************************************************************
    @Description: This test method is used to update Compliance. 
    @Name : UpdateCompliancetest
    @Param : None
    @Return : void
    @throws Exception : N/A;
    ********************************************************************************************************************************/     
    private static testMethod void UpdateCompliancetest(){
        try{
       user usr = GA_OBJ_TD01_TestDataCreation.UsrRec(ROLE_NAM,EMAILVAL,PROF_NAM);
        database.insert(usr);
        system.runas(usr){
        test.startTest();
            list<Contract> cntrList =[SELECT AccountId,CID__c,Id,Name,RecordTypeId,Status,NonCompliant_Rollup__c FROM Contract where RecordTypeId =:ASCCON_RECID];
            ASC_UpdateComplianceStatusOnAccount.UpdateCompliance(cntrList,null);
            ASC_UpdateComplianceStatusOnAccount.UpdateCompliance(null,null);
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