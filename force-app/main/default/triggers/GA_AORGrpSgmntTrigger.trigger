/**
@Author : IDC Offshore
@Name: GA_AORGrpSgmntTrigger 
@CreatedDate: 06 - June 2019 
@Description: GA_AORGrpSgmntTrigger trigger is for updateing the AOR Group Segment.
@version : 1.0  
*/
trigger GA_AORGrpSgmntTrigger on GA_AOR_Group_Segment__c (before insert,after insert,after update,before update) {
    static final String triggerName = 'GA_AORGrpSgmntTrigger';
    GA_OBJ_TriggerRunCheck__mdt triggrrunchk =GA_OBJ_TD01_TestDataCreation.triggercheck(triggerName);
    if(triggrrunchk.GA_TriggerTurnOn__c)
    { 
        if(trigger.isbefore && trigger.isInsert)
        {
            GA_AORGrpSgmntTriggerHandler.beforeInsert(trigger.New);
        }
        if(trigger.isAfter && trigger.isInsert)
        {
            GA_AORGrpSgmntTriggerHandler.afterInsert(trigger.New);
            system.debug('====In After insert of AORGS===');
            GA_AORGrpSgmntTriggerHandler.commissionAgentOnGS(trigger.New); //Implemented as part of US-3418
        }
        if(trigger.isAfter && trigger.isUpdate)
        {
            GA_AORGrpSgmntTriggerHandler.afterUpdate(trigger.New,trigger.OldMap);
        }
        if(trigger.isbefore && trigger.isUpdate)
        {
            GA_AORGrpSgmntTriggerHandler.beforeUpdate(trigger.New,trigger.OldMap);
        }
    }
}