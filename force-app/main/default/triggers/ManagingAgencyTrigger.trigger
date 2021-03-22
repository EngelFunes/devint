/**
@Author : Rahul
@Name: ManagingAgencyTrigger
@CreatedDate: 10 - Mar 2020 
@Description: ManagingAgencyTrigger trigger to handle update ManagingAgencyHistory when there is an EndDate update. Refer:
@version : 1.0  
*/ 
trigger ManagingAgencyTrigger on Managing_Agency__c (before insert, after insert, after update)
{
    static final String triggerName = 'ManagingAgencyTrigger';
    GA_OBJ_TriggerRunCheck__mdt triggrrunchk =GA_OBJ_TD01_TestDataCreation.triggercheck(triggerName);
    
    if(triggrrunchk.GA_TriggerTurnOn__c)
    {
        if(trigger.isBefore)
        {
            if(trigger.isInsert)
            {
                ManagingAgencyTriggerHandler.updateMAName(trigger.new);    
                
            }
        }
        if(trigger.isAfter)
        {
            if(trigger.isInsert)
            {
                ManagingAgencyTriggerHandler.updateMAEndDate(trigger.New);
            }
            if(trigger.isUpdate)
            {
                ManagingAgencyTriggerHandler.updateMAHEndDate(trigger.new, trigger.oldMap);            
            }
        }
    }
}