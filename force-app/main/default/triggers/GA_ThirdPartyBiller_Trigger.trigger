/******************************************************************************************************************************************
@Author : IDC offshore
@Name: GA_ThirdPartyBiller_Trigger
@CreatedDate: 28 - Sep 2018  
@Description: GA_ThirdPartyBiller_Trigger trigger is used to implement logics on 
DML operations of TPB History records.
@version : 1.0  
*****************************************************************************************************************************************/
trigger GA_ThirdPartyBiller_Trigger on GA_Third_Party_Biller_History__c (before insert, after insert, after update) {
    static final String triggerName = 'GA_ThirdPartyBiller_Trigger';
    GA_OBJ_TriggerRunCheck__mdt triggrrunchk =GA_OBJ_TD01_TestDataCreation.triggercheck(triggerName);
    
    if(triggrrunchk.GA_TriggerTurnOn__c)
    {
         if(trigger.isbefore && trigger.isInsert)
        {
            GA_ThrdPrtyBllr_TriggerHandler.beforeInsert(trigger.New);
        }
        if(trigger.isAfter && trigger.isInsert)
        {
            GA_ThrdPrtyBllr_TriggerHandler.afterInsert(trigger.New);
        }
        if(trigger.isAfter && trigger.isUpdate)
        {
            GA_ThrdPrtyBllr_TriggerHandler.afterUpdate(trigger.New,trigger.OldMap);
        }
    }
}