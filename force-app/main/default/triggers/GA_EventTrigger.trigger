/*******************************************************************************************************************************
@Author : Dilip Junapala
@Name: GA_EventTrigger 
@CreatedDate: 02 - Jan 2018
@Description: GA_EventTrigger trigger is to peform the required operations before or after DML operations.
@version : 1.0  
********************************************************************************************************************************/
trigger GA_EventTrigger on Event (after insert) {
     static final String triggerName = 'GA_EventTrigger';
    GA_OBJ_TriggerRunCheck__mdt triggrrunchk =GA_OBJ_TD01_TestDataCreation.triggercheck(triggerName);
    
    if(triggrrunchk.GA_TriggerTurnOn__c)
    {   
        if(trigger.isafter && trigger.isInsert)
        {
            GA_EventTriggerHandler.afterinsert(trigger.new);
        }  
    }

}