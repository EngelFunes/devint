/*****
 * Name: Knocky Lo
 * Class Name: UnlockRecordBatchJob
 * Date Created: October 25, 2019
 *****/

global class UnlockRecordBatchJob implements Database.batchable<sObject> {
    //Start of this batch job
    public static final String CLSNAME = 'UnlockRecordBatchJob';
    public static final String methodNmeunlockRecords  ='unlockRecords';
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        String query = 'SELECT Id FROM Contact where Account.RecordType.Name = \'Account - Customer\'LIMIT 1000000 '; //1M records
        return Database.getQueryLocator(query);
    }
    //Exeution of batch job
    global void execute(Database.BatchableContext BC, List<Contact> scope) { //Scope max = 2000
        //Check locked records
        
        List<Contact> contactLockList = new List<Contact>();
        
        for(Contact c : scope)
        {
            if(Approval.isLocked(c.id)){
                contactLockList.add(c);
            }
        }
        try{
            if(!contactLockList.isEmpty()){
                //Unlock records
                List<Approval.UnlockResult> ulrList = Approval.unlock(contactLockList, false);
                
                // Iterate through each returned result
                for(Approval.UnlockResult  ulr : ulrList) {
                    if (ulr.isSuccess()) {
                        //Operation was successful, so get the ID of the record that was processed
                        System.debug('Successfully unlocked Contact with ID: ' + ulr.getId());
                    }
                    else {
                        //Operation failed, so get all errors                
                        for(Database.Error err : ulr.getErrors()) {
                            System.debug('The following error has occurred.');                    
                            System.debug(err.getStatusCode() + ': ' + err.getMessage());
                            System.debug('Contact fields that affected this error: ' + err.getFields());
                        }
                    }
                }
            }
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, ClsName, methodNmeunlockRecords);  
        }
        
    }
    //finish job
    global void finish(Database.BatchableContext BC) {
    }
}