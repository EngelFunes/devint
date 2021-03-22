trigger GA_LocalUnionTrigger on GA_Union_Representation__c (before insert,before update) {
    
     static final String triggerName = 'GA_LocalUnionTrigger';
    GA_OBJ_TriggerRunCheck__mdt triggrrunchk =GA_OBJ_TD01_TestDataCreation.triggercheck(triggerName);
    
    if(triggrrunchk.GA_TriggerTurnOn__c)
        if(trigger.isbefore && trigger.isInsert)
    {
        GA_LocalUnionTriggerHandler.beforeInsert(trigger.new);
    } 
       if(trigger.isbefore && trigger.isUpdate)
    {
        GA_LocalUnionTriggerHandler.beforeInsert(trigger.new);
    } 

}