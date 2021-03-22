/*********************************************************************************************************************************************
@Author :IDC offshore
@Name: GA_AccOwnerUpdateQueueble
@CreatedDate: 31 - Jul 2017 
@Description: GA_AccOwnerUpdateQueueble class is for creating/updating Account is changed
@version : 1.0  
**********************************************************************************************************************************************/
public class GA_AccOwnerUpdateQueueble implements Queueable {
    
    private List<Account> accounts;
    
    /**
@Description: GA_AccOwnerUpdateQueueble() Constructor method 
@Name : GA_AccOwnerUpdateQueueble
@Param : List<Account> records
@Return : void
@throws Exception : N/A;
*/      
    public GA_AccOwnerUpdateQueueble(List<Account> records) {
        this.accounts = records;
        
    }
    
    /**
@Description: execute()  method 
@Name : execute
@Param :ueueableContext context
@Return : void
@throws Exception : N/A;
*/      
    public void execute(QueueableContext context) {
        List<Database.SaveResult> accSrList = new List<Database.SaveResult>();
        List<ExceptionLog__c> excpLst = New List<ExceptionLog__c>();
        integer occurence = 1;
        String excpSvrty='ERROR';
        
        
        if(!accounts.isEmpty())
        {
            GA_AccountTriggerHandlr.isExecuting = true;
            GA_ACC_AP01_CheckPlatinumStatusOnAgency.isExecuting = true;
            GA_Util_lockRecords.isExecuting = true;
            // GA_ACC_AP02_IdentifySalesRepOnAccount.isExecuting = true;
            GA_ACC_AP05_CreateHandoverRecord.isExecuting = true;
            // GA_ACC_UpdateChildContctsOnAccOwnrChange.isExecuting = true;
            GA_ACC_AP04_UpdtCntOnAccLockUnlock.isExecuting = true;
            // GA_ACC_AP_UpdtAssmntOwnrMgrChnge.isExecuting = true; 
            GA_AccountBatchToUpdateContactOwner.isInvodedFrmBtch = true;
            GA_ACC_AP_UpdtAssmntOwnrMgrChnge.isExecuting = true;
            GA_AccountTriggerHandlr.acntlcklmt = Integer.valueof(system.label.GA_UpdateAccOwner_Limit);
            accSrList = Database.update(accounts,false);
        } 
        
        
        
        Integer i=0;
        if(!accSrList.isEmpty()){
            for(Database.SaveResult obj : accSrList){
                
                for(Database.Error objErr : obj.getErrors()){
                    if(!obj.isSuccess()){
                        ExceptionLog__c objLog = new ExceptionLog__c(
                            Object_ID__c =accounts[i].id,
                            ExceptionDescription__c = objErr.getMessage(),
                            ExceptionCode__c =  String.valueOf(objErr.getStatusCode()),
                            NumberOfTimesOccured__c = occurence,
                            ExceptionDetails__c = objErr.getMessage(),
                            Severity__c = excpSvrty);
                        excpLst.add(objLog);
                    } 
                }
                i++;
            }
        }
        if(!excpLst.isEmpty()){
            Database.insert(excpLst);
        }
    }
}