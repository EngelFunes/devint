/******************************************************************************************************************************************
@Author : IDC offshore
@Name: GA_AssocThrdPrtyBllr_Trigger
@CreatedDate: 21 - Dec 2018  
@Description: GA_AssocThrdPrtyBllr_Trigger trigger is used to implement logics on DML operations of Association Third Party Biller records.
@version : 1.0  
*****************************************************************************************************************************************/
trigger GA_AssocThrdPrtyBllr_Trigger on GA_Association_Third_Party_Biller__c (after insert, after update) {
    static final String triggerName = 'GA_AssocThrdPrtyBllr_Trigger';
    GA_OBJ_TriggerRunCheck__mdt triggrrunchk =GA_OBJ_TD01_TestDataCreation.triggercheck(triggerName);
    
    if(triggrrunchk.GA_TriggerTurnOn__c)
    {
        if(trigger.isAfter && trigger.isInsert)
        {
            GA_AssocThrdPrtyBlr_TriggerHandler.afterInsert(trigger.New);
        }
        if(trigger.isAfter && trigger.isUpdate)
        {
            GA_AssocThrdPrtyBlr_TriggerHandler.afterUpdate(trigger.New,trigger.OldMap);
        }
    }
}