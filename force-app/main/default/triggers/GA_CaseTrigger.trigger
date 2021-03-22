/**
@Author : Dilip Junapala
@Name: GA_CaseTrigger 
@CreatedDate: 21 - Nov 2017 
@Description: GA_CaseTrigger trigger is for creating/Updateing Case
@version : 1.0  
*/
trigger GA_CaseTrigger on Case (after insert, before update, before insert,after update, before delete, after delete) {
    static final String triggerName = 'GA_CaseTrigger';
    GA_OBJ_TriggerRunCheck__mdt triggrrunchk =GA_OBJ_TD01_TestDataCreation.triggercheck(triggerName);
    
    if(triggrrunchk.GA_TriggerTurnOn__c)
    {   
        if(trigger.isafter && trigger.isInsert)
        {
            GA_CaseTriggerHandler.afterinsert(trigger.new, trigger.newmap,trigger.newmap);
        }  
        if(trigger.isbefore && trigger.isInsert)
        {
            GA_CaseTriggerHandler.beforeinsert(trigger.new,trigger.oldmap);
            
        }
        if(trigger.isbefore && trigger.isUpdate)
        {
            GA_CaseTriggerHandler.beforeupdate(trigger.new, trigger.newmap,trigger.oldmap);
        }  
        if(trigger.isafter && trigger.isUpdate)
        {
            GA_CaseTriggerHandler.afterupdate(trigger.new, trigger.oldmap);
        }
        if(trigger.isafter && trigger.isDelete)
        {
            GA_CaseTriggerHandler.afterDelete(trigger.old);
        }
        if(trigger.isbefore && trigger.isDelete)
        {
            GA_CaseTriggerHandler.beforeDelete(trigger.old);
        }
    }
    
}