/***************************************************************************************************************************
@Author : Rahul
@Name: CommissionAgentonGS_Scheduler 
@CreatedDate:  10/06/2020 
@Description: CommissionAgentonGS_Scheduler is to scheduler class for  CommissionAgentonGS_Batch
@version : 1.0  
***************************************************************************************************************************/
global class CommissionAgentonGS_Scheduler Implements Schedulable
{
	global void execute(SchedulableContext sc)
    {
        Database.executeBatch(new CommissionAgentonGS_Batch(), 50);
    }
}