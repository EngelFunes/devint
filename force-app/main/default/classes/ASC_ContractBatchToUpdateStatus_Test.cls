/*******************************************************************************************************************************
@Author : IDC offshore
@Name: 
@CreatedDate:  
@Description: 
@version : 1.0  
********************************************************************************************************************************/
@isTest(seealldata = false)
private class ASC_ContractBatchToUpdateStatus_Test {
    private static final string ACC_RECORDTYPE  ='Account - Customer';
    private static final string ACTIVATED  ='Activated';
    private static final string EXPIRED  ='Expired';
    private static final string ACCEPTED  ='Accepted';
    private static final string CONTRACT  ='ASC Contract';    
    private static final string DRAFT  ='Draft';   
    private static final string TYPE  ='ASC Product';    
    private static final Id RECTYPEID=Schema.SObjectType.Contract.getRecordTypeInfosByName().get(CONTRACT).getRecordTypeId();  
    /*******************************************************************************************************************************
@Description: initData() method - preparing the test data
@Name : initData
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
    @TestSetup static void initData() 
    {
        Account acc=GA_OBJ_TD01_TestDataCreation.AccRec();
        acc.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get(ACC_RECORDTYPE).getRecordTypeId();
        database.insert(acc);
        
        Contract cont1 = new Contract();
        cont1.AccountId=acc.Id;
        cont1.Status=DRAFT;
        cont1.StartDate=Date.today()-10;
        cont1.EndDate=Date.today()+10;
        cont1.RecordTypeId=RECTYPEID;
        database.insert(cont1);
        
        cont1.Status = ACCEPTED;
        database.update(cont1);
        
        Contract cont = new Contract();
        cont.AccountId=acc.Id;
        cont.Status=DRAFT;
        cont.StartDate=Date.today()-10;
        cont.EndDate=Date.today()-1;
        cont.RecordTypeId=RECTYPEID;
        database.insert(cont);
        cont.status = ACTIVATED;
        database.update(cont);
    }
    /*******************************************************************************************************************************
@Description: This testmethod1 is used to cover ASC_ContractBatchToUpdateStatus class
@Name : testmethod1
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/   
    private static testmethod void testMethod1(){
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestSysAdm','testsysadm@bcbsm.com','System Administrator');
        database.insert(usr);
        
        system.runAs(usr){
            try{
                  ASC_ContractBatchToUpdateStatus_Schdlr sh1 =new ASC_ContractBatchToUpdateStatus_Schdlr();
                String sch = '0 0 23 * * ?'; 
                Test.startTest();
                system.schedule('docBtch update', sch, sh1);           
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