/******************************************************************************************************************************************
@Author : IDC Offshore
@Name: GA_BCN_PlanException_HistoryTrigger
@CreatedDate: 07- May 2019  
@Description: GA_BCN_PlanException_HistoryTrigger trigger is used to implement the DML operations of BCN_PlanException_History records.
@version : 1.0  
*****************************************************************************************************************************************/
trigger GA_PlanException_HistoryTrigger on GA_Plan_Year_Exception_History__c (before insert,after insert,after update,before update) {
    
    static final String triggerName = 'GA_BCN_PlanException_HistoryTrigger';
    GA_OBJ_TriggerRunCheck__mdt triggrrunchk =GA_OBJ_TD01_TestDataCreation.triggercheck(triggerName);
    
    if(triggrrunchk.GA_TriggerTurnOn__c)
    {
        if(trigger.isBefore && trigger.isInsert)
        {
            GA_BCNHstry_TriggerHandlr.beforeInsert(trigger.new);
        }
        if(trigger.isAfter && trigger.isInsert)
        {
            GA_BCNHstry_TriggerHandlr.afterInsert(trigger.New);
        }
        if(trigger.isAfter && trigger.isUpdate)
        {
            GA_BCNHstry_TriggerHandlr.afterUpdate(trigger.New,trigger.OldMap);
        }
        if(trigger.isBefore && trigger.isUpdate)
        {
            GA_BCNHstry_TriggerHandlr.beforeUpdate(trigger.New,trigger.OldMap);
        }
    }
}