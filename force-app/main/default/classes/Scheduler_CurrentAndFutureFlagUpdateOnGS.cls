/***************************************************************************************************************************
@Author : Rahul
@Name: Scheduler_CurrentAndFutureFlagUpdateOnGS 
@CreatedDate:  04/14/2020 
@Description: Scheduler_CurrentAndFutureFlagUpdateOnGS is to schedule Batch_CurrentAndFutureFlagUpdateOnGS
@version : 1.0  
***************************************************************************************************************************/
global class Scheduler_CurrentAndFutureFlagUpdateOnGS Implements Schedulable
{
	global void execute(SchedulableContext sc)
    {
        Database.executeBatch(new Batch_CurrentAndFutureFlagUpdateOnGS(), 200);
    }
}