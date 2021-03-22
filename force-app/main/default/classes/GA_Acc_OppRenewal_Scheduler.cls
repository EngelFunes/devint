/*****************************************************************************************
Class Name   : GA_Acc_OppRenewal_Scheduler
Date Created : 12/22/2017
Created By   : IDC Offshore
Description  : 1. This is the schedule class for renewal opportunity creation.
******************************************************************************************/
global class GA_Acc_OppRenewal_Scheduler implements Schedulable {
    
/****************************************************************************************************
Method Name : execute
Parameters  : SchedulableContext SC
Return type : Void
Description : This method is used to create the Opportunity record based on 
			  account renewal notification date by running the execute method of schedule class.
******************************************************************************************************/
    global void execute(SchedulableContext SC) {
        GA_Acc_OppRenewal.createoppty(); 
    }
}