/*****************************************************************************************************************************************************
@Author : Sreenu Ravilla
@Name: TaskSendEmailApproversScheduler
@CreatedDate:  25-Feb-2021 
@Description: TaskSendEmailApproversScheduler is used to send  Email notifications for task owners.

@US Number: US-3921

*/
global class ASC_TaskSendEmailApproversScheduler implements Schedulable {
    global void execute(SchedulableContext SC){
        Id batchJobId = Database.executeBatch(new ASC_TaskSendEmailApproversBatch(), 8);
    }

}