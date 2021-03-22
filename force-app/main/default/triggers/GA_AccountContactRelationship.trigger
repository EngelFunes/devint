/*******************************************************************************************************************************
@Author : Dilip Junapala
@Name: GA_AccountContactRelationship 
@CreatedDate: 19 - Apr 2018
@Description: GA_AccountContactRelationship trigger is to perform the required operations before or after DML operations.
@version : 1.0  
********************************************************************************************************************************/
trigger GA_AccountContactRelationship on AccountContactRelation (before insert) {
    static final String triggerName = 'GA_AccountContactRelationship';
    GA_OBJ_TriggerRunCheck__mdt triggrrunchk =GA_OBJ_TD01_TestDataCreation.triggercheck(triggerName);
    
    if(triggrrunchk.GA_TriggerTurnOn__c)
    {   
        if(trigger.isbefore && trigger.isInsert)
        {
            GA_AccntContRelTriggerHandler.beforeinsert(trigger.new);
        }  
    }
}