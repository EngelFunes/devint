/******************************************************************************************************************************************
@Author : IDC Offshore
@Name: GA_ManagngAgncyHistory_Trigger
@CreatedDate: 07- May 2019  
@Description: GA_ManagngAgncyHistory_Trigger trigger is used to implement the DML operations of Managing Agency History records.
@version : 1.0  
*****************************************************************************************************************************************/
trigger GA_ManagngAgncyHistory_Trigger on GA_Managing_Agency_History__c (before insert,after insert,after update) {
    
    static final String triggerName = 'GA_ManagngAgncyHistory_Trigger';
    GA_OBJ_TriggerRunCheck__mdt triggrrunchk =GA_OBJ_TD01_TestDataCreation.triggercheck(triggerName);
    
    if(triggrrunchk.GA_TriggerTurnOn__c)
    {
        if(trigger.isBefore && trigger.isInsert)
        {
            GA_MangngAgncyHstry_TriggerHndlr.beforeInsert(trigger.New);
        }
        if(trigger.isAfter && trigger.isInsert)
        {
            GA_MangngAgncyHstry_TriggerHndlr.afterInsert(trigger.New);
        }
        if(trigger.isAfter && trigger.isUpdate)
        {
            GA_MangngAgncyHstry_TriggerHndlr.afterUpdate(trigger.New,trigger.OldMap);
        }
    }
}