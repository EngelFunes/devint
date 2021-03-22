trigger GA_AgentSoldGroupTrigger on GA_Agent_Sold_Group__c (after insert, after update) 
{
    
    static final String triggerName = 'GA_AgentSoldGroupTrigger';
    GA_OBJ_TriggerRunCheck__mdt triggerrunchk = GA_OBJ_TD01_TestDataCreation.triggercheck(triggerName);
    if(triggerrunchk.GA_TriggerTurnOn__c)
    {
        if(trigger.isAfter)
        {
            if(trigger.isInsert)
            {
                GA_AgentSoldGroupTriggerHandler.updateAgentSoldEnrollment(Trigger.new, null);
            }
            if(trigger.isUpdate)
            {
                GA_AgentSoldGroupTriggerHandler.updateAgentSoldEnrollment(Trigger.new, Trigger.oldMap);
            }
            
        }
    }
}