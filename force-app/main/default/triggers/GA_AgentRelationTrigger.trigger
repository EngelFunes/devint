/**
@Author : PadmaHaarika Jayana
@Name: GA_AgentRelationTrigger 
@CreatedDate: 31 - Jul 2017 
@Description: GA_AgentRelationTrigger  trigger is for creating agency relationship record
@version : 1.0  
*/
trigger GA_AgentRelationTrigger on GA_AgencyRelationship__c (after insert,after update,after delete) {
    static final String triggerName = 'GA_AgentRelationTrigger';
    GA_OBJ_TriggerRunCheck__mdt triggrrunchk =GA_OBJ_TD01_TestDataCreation.triggercheck(triggerName);
    
    if(triggrrunchk.GA_TriggerTurnOn__c)
    {
    if(trigger.isafter && trigger.isinsert )
    {
        GA_AgentRelationTriggerhndlr.afterinsert(trigger.new, trigger.newmap);
    }  
    if(trigger.isafter && trigger.isupdate )
    {
        GA_AgentRelationTriggerhndlr.afterupdate(trigger.new, trigger.newmap,trigger.oldmap);
    } 
    if(trigger.isafter && trigger.isdelete)
    {
        GA_AgentRelationTriggerhndlr.afterdelete(trigger.old,trigger.oldmap);
    }
    }
}