/*****************************************************************************************
Class Name   : GA_UpdateAccntsPltinmSts_Scheduler
Date Created : 01/05/2018
Created By   : IDC Offshore
Description  : 1. This is the schedule class for renewal opportunity creation.
******************************************************************************************/
global class GA_UpdateAccntsPltinmSts_Scheduler implements Schedulable {
    
    /****************************************************************************************************
Method Name : execute
Parameters  : SchedulableContext SC
Return type : Void
Description : This method is used to update the Account Platinum checkbox record based on 
Agency Relationship active status by running the execute method of schedule class.
******************************************************************************************************/
    global void execute(SchedulableContext SC) {
        GA_UpdateAccntsPltinmStsBatch updtpltnmbtch=new GA_UpdateAccntsPltinmStsBatch();
        database.executeBatch(updtpltnmbtch, 2000);
    }
}