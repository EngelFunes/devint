/*****************************************************************************************
Class Name   : GA_AP_CIDServiceBatch_Scheduler
Date Created : 01/21/2018
Created By   : IDC Offshore
Description  : This is the schedule class for retrieve and update CID service.
******************************************************************************************/
global class GA_AP_CIDServiceBatch_Scheduler implements Schedulable {
    
/****************************************************************************************************
Method Name : execute
Parameters  : SchedulableContext SC
Return type : Void
Description : This method is used to retrieve and update CID service. 
******************************************************************************************************/
    global void execute(SchedulableContext SC) {
        GA_AP_CIDServiceBatch updtcidbtch=new GA_AP_CIDServiceBatch ();
        database.executeBatch(updtcidbtch, 4);
    }
}