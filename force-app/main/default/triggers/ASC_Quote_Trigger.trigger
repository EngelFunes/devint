/***************************************************************************************************************
@Author : Mida Komal
@Name: ASC_Quote_Trigger 
@CreatedDate: 21 - May 2020 
@Description: ASC_Quote_Trigger is for performing business logics on Quote
@version : 1.0  
***************************************************************************************************************/
trigger ASC_Quote_Trigger on Quote (before insert,before update,after insert,after update) {
    static final String triggerName = 'ASC_Quote_Trigger';
    GA_OBJ_TriggerRunCheck__mdt triggrrunchk =GA_OBJ_TD01_TestDataCreation.triggercheck(triggerName);
    if(triggrrunchk.GA_TriggerTurnOn__c)
    { 
        if(trigger.isbefore && trigger.isUpdate)
        {
            ASC_QuoteTriggerHandler.beforeUpdate(trigger.new,trigger.oldMap);
        }
        if(trigger.isbefore && trigger.isInsert)
        {
            ASC_QuoteTriggerHandler.beforeInsert(trigger.new);
        }
        if(trigger.isafter && trigger.isInsert)
        {
            ASC_QuoteTriggerHandler.afterInsert(trigger.new);
        }        
        if(trigger.isafter && trigger.isUpdate)
        {
            ASC_QuoteTriggerHandler.afterUpdate(trigger.new,trigger.oldMap);
            ASC_AutoCreateDfund_Account.checkQuoteData(trigger.newmap,trigger.oldMap);
        }
    }
}