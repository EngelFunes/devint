/*****************************************************************************************
Class Name   : GA_UpdateUnlockBatchScheduler
Date Created : 11/20/2018
Created By   : Rohith Adulla
Description  : This is the schedule class for Unlocking Salesforce owned Accounts.
******************************************************************************************/
global class GA_UpdateUnlockBatchScheduler implements Schedulable {

/****************************************************************************************************
Method Name : execute
Parameters  : SchedulableContext SC
Return type : Void
Description : This method is used to update the Account Platinum checkbox record based on 
Agency Relationship active status by running the execute method of schedule class.
******************************************************************************************************/
    global void execute(SchedulableContext SC) {
        GA_UpdateUnlockBatch unlockAccounts =new GA_UpdateUnlockBatch();
        database.executeBatch(unlockAccounts, 2000);
    }
}