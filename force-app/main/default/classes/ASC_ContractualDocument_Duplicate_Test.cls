/**************************************************************************************************************************
@Author :
@Name:ASC_ContractualDocument_DuplicateTest class is used to cover ASC_ContractualDocument_Duplicate
@CreatedDate: 31-Aug-2020
@Description: ASC_ContractualDocument_DuplicateTest class is used to cover ASC_ContractualDocument_Duplicate
@version : 1.0 
@US Num:
****************************************************************************************************************************/
@isTest(seealldata = false)
private class ASC_ContractualDocument_Duplicate_Test {
    private static final string ACC_RECORDTYPE  ='Account - Customer';    
    private static final string NAME='TEST';
    private static final string STATUS='Draft';
    private static final string CARRIER='BCBSM';
    private static final string DOCVERSION='2021 Schedule A Default';
    private static final string DOCTYPE='Schedule A';
    private static final string PHONE='9876543211';    
    private static final string ACCCID = '12345';
    private static final string ASCCONTRACT = 'ASC Contract';
    
    private static final Integer NUM = 20;
    
/*******************************************************************************************************************************
@Description: initData() method - preparing the test data
@Name : initData
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/ 
    @TestSetup static void initData(){
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
        cntrcRcrd.recordtypeid=Schema.SObjectType.Contract.getRecordTypeInfosByName().get(ASCCONTRACT).getRecordTypeId();
        database.insert (cntrcRcrd);
        
        
        List<ASC_Contractual_Document__c> ascdList=new List<ASC_Contractual_Document__c>();
        ASC_Contractual_Document__c cntrcDocRcd = new ASC_Contractual_Document__c();
        cntrcDocRcd.Name = NAME;
        cntrcDocRcd.ASC_Contract__c = cntrcRcrd.id;
        cntrcDocRcd.ASC_Document_Type__c =DOCTYPE;      
        cntrcDocRcd.Document_Version__c =DOCVERSION;
        database.insert (cntrcDocRcd);
        ascdList.add(cntrcDocRcd);
        test.startTest(); 
    }
    
    
    /***************************************************************************************************************************************
@Description: This test method is used to create/update the records in ASC_Contractual_Document__c Object - duplicateCheckUpdate records
@Name : testmethod1
@Param : None
@Return : void
@throws Exception : N/A;
****************************************************************************************************************************************/   
    private static testmethod void duplicateCheckInsertTest(){
        try{
            user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestSysAdm','testsysadm@bcbsm.com','System Administrator');
            database.insert(usr);
            system.runAs(usr)
            {  
                List<ASC_Contractual_Document__c> ascdList=new List<ASC_Contractual_Document__c>();
                ASC_Contractual_Document__c cntrDoc=[SELECT Name,Id,ASC_Do_Not_Include__c,Document_Source__c,
                                                     ASC_Document_Type__c From ASC_Contractual_Document__c Limit 1];
                test.startTest();
                ASC_ContractualDocument_Duplicate.duplicateCheckInsert(ascdList);
                test.stopTest();
            }
        }
        catch(exception e)
        {
            system.assert(e <> null);
            return;
            
        } 
    }
    
 /***************************************************************************************************************************************
@Description: This test method is used to create/update the records in ASC_Contractual_Document__c Object - duplicateCheckUpdate records
@Name : duplicateCheckUpdate
@Param : None
@Return : void
@throws Exception : N/A;
*****************************************************************************************************************************************/
    
    private static testmethod void duplicateCheckUpdate(){
        try{
            user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestSysAdm','testsysadm@bcbsm.com','System Administrator');
            database.insert(usr);
            system.runAs(usr)
            {  
                
                list<ASC_Contractual_Document__c> cdLst = new list<ASC_Contractual_Document__c>();
                ASC_Contractual_Document__c cntrcDocRcd=[SELECT Name,Id,ASC_Do_Not_Include__c,
                                         Document_Source__c,ASC_Document_Type__c From ASC_Contractual_Document__c Limit 1];   
                cdLst.add(cntrcDocRcd);
                Database.update(cdLst);    
                
                map<id,ASC_Contractual_Document__c> cdOldMap =new map<id,ASC_Contractual_Document__c>(
                    [select Id,Name,ASC_Document_Language__c,ASC_Document_Type__c,ASC_Signature_Required__c,
                     Document_Source__c from ASC_Contractual_Document__c limit 100]);
                test.startTest();
                ASC_ContractualDocument_Duplicate.duplicateCheckUpdate(cdLst,cdOldMap);
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