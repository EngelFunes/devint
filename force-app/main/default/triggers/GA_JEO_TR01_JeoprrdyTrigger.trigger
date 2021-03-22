/**
@Author : Prasant Kumar Satpathy
@Name: GA_JEO_TR01_JeoprrdyTrigger
@CreatedDate: 24- Jul 2017 
@Description: GA_JEO_TR01_JeoprrdyTrigger trigger is for creating/updating task whenever Assigned To field in jeopardy record 
is changed
@version : 1.0  
*/
trigger GA_JEO_TR01_JeoprrdyTrigger on GA_Jeopardy__c (after update, after insert,before insert) {
    
    static final String triggerName = 'GA_JEO_TR01_JeoprrdyTrigger';
    GA_OBJ_TriggerRunCheck__mdt triggrrunchk =GA_OBJ_TD01_TestDataCreation.triggercheck(triggerName);
    
    if(triggrrunchk.GA_TriggerTurnOn__c)
    {
        if(trigger.isafter && trigger.isupdate)
        {
            GA_JEO_TR01_JeoprdyTriggerhndlr.afterupdate(trigger.new, trigger.oldmap);
        }  
        
        if(trigger.isafter && trigger.isinsert)
        {
            GA_JEO_TR01_JeoprdyTriggerhndlr.afterinsert(trigger.new);
        } 
        if(trigger.isbefore && trigger.isinsert)
        {
            GA_JEO_TR01_JeoprdyTriggerhndlr.beforeInsert(trigger.new);
        } 
    }
}