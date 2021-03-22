/*****************************************************************************************************************************************************
@Author : Dinesh P
@Name: DfundSendEmailApproversScheduler
@CreatedDate:  20-Dec-2020 
@Description: DfundSendEmailApproversScheduler is used to send Reminder Email if dfund request is assigned to same approver if more than one day.

@version : 1.0  
@US Number: US-4293 ,US-4098, US-4100

*/
global class DfundSendEmailApproversScheduler implements Schedulable {
    
/****************************************************************************************************
Method Name : execute
Parameters  : SchedulableContext SC
Return type : Void
Description : This method is used to send Reminder Email if dfund request is assigned to same approver if more than one day.
******************************************************************************************************/
    global void execute(SchedulableContext SC) {
        DfundSendEmailApproversClass.sendEmailToApprovers(); 
    }
}