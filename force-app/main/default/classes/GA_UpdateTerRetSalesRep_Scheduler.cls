/*****************************************************************************************
Class Name   : GA_UpdateTerRetSalesRep_Scheduler
Date Created : 3/24/2020
Created By   : Accenture Support
Description  : This is the schedule class that invokes GA_AP_DeleteFilesBatch for updating the Retention Sales Representative of the Territory Object.
******************************************************************************************/
global class GA_UpdateTerRetSalesRep_Scheduler implements Schedulable {
    
/****************************************************************************************************
Method Name : execute
Parameters  : SchedulableContext SC
Return type : Void
Description : This method is used to update Retention Sales Representative of the Territory Object. 
******************************************************************************************************/
    global void execute(SchedulableContext SC) {
        GA_UpdateTerRetSalesRepBatch updtTerSalesbtch = new GA_UpdateTerRetSalesRepBatch ();
        database.executeBatch(updtTerSalesbtch, 1);
    }
}