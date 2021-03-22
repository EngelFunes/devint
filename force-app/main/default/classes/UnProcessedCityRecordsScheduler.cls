/***************************************************************************************************************************
@Author : Rahul
@Name: UnProcessedCityRecordsScheduler 
@CreatedDate:  03/20/2020 
@Description: UnProcessedCityRecordsScheduler is to sc hedule UnProcessedCityRecordsBatch
@version : 1.0  
***************************************************************************************************************************/
global class UnProcessedCityRecordsScheduler  Implements Schedulable
{
	global void execute(SchedulableContext sc)
    {
        Database.executeBatch(new UnProcessedCityRecordsBatch(), 200);
    }
}