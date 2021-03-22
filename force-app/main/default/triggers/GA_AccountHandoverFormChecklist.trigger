/*******************************************************************************************************************************
@Author : Dilip Junapala
@Name: GA_AccountHandoverFormChecklist 
@CreatedDate: 15 - Dec 2017
@Description: GA_AccountHandoverFormChecklist trigger is to trigger the required operations before or after DML operations.
@version : 1.0  
********************************************************************************************************************************/
trigger GA_AccountHandoverFormChecklist on GA_AccountHandOver__c (after insert, after update) {
     static final String triggerName = 'GA_AccountHandoverFormChecklist';
    GA_OBJ_TriggerRunCheck__mdt triggrrunchk =GA_OBJ_TD01_TestDataCreation.triggercheck(triggerName);
    
    if(triggrrunchk.GA_TriggerTurnOn__c)
    {   
        if(trigger.isafter && trigger.isInsert)
        {
            GA_AccountHandoverHandler.afterinsert(trigger.new);
        }
        if(trigger.isafter && trigger.isUpdate){
            GA_AccountHandoverHandler.afterupdate(trigger.new,trigger.newmap,trigger.oldmap);
        }
    }

}