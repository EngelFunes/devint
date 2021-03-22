/******************************************************************************************************************************************
@Author : IDC offshore
@Name: GA_AccTerritoryHstry_Trigger
@CreatedDate: 21 - Dec 2018  
@Description: GA_AccTerritoryHstry_Trigger trigger is used to implement logics on DML operations of Association Third Party Biller records.
@version : 1.0  
*****************************************************************************************************************************************/
trigger GA_AccTerritoryHstry_Trigger on GA_Account_Territory_History__c (after insert, after update) {
    static final String triggerName = 'GA_AccTerritoryHstry_Trigger';
    GA_OBJ_TriggerRunCheck__mdt triggrrunchk =GA_OBJ_TD01_TestDataCreation.triggercheck(triggerName);
    
    if(triggrrunchk.GA_TriggerTurnOn__c)
    {
        if(trigger.isAfter && trigger.isInsert)
        {
            GA_AccTerritoryHstry_TriggerHndlr.afterInsert(trigger.New);
        }
        if(trigger.isAfter && trigger.isUpdate)
        {
            GA_AccTerritoryHstry_TriggerHndlr.afterUpdate(trigger.New,trigger.OldMap);
        }
    }
}