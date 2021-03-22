/*******************************************************************************************************************************
@Author : Raj Jena
@Name: ASC_ContractualDoc_Trigger 
@CreatedDate: 12 - Feb 2020 
@Description: ASC_ContractualDoc_Trigger trigger is for performing business logics on Contractual Document
@version : 1.0  
********************************************************************************************************************************/
trigger ASC_ContractualDoc_Trigger on ASC_Contractual_Document__c (before insert, before update, after insert) {
    static final String triggerName = 'ASC_ContractualDoc_Trigger';
    GA_OBJ_TriggerRunCheck__mdt triggrrunchk =GA_OBJ_TD01_TestDataCreation.triggercheck(triggerName);
    
    if(triggrrunchk.GA_TriggerTurnOn__c)
    {   
        if(trigger.isbefore && trigger.isInsert)
        {
            ASC_ContractualDoc_TriggerHandler.beforeInsert(trigger.new);           
        }
        
        if(trigger.isafter && trigger.isInsert)
        {      
                  
        }
        
        if(trigger.isbefore && trigger.isUpdate)
        {
            ASC_ContractualDoc_TriggerHandler.beforeUpdate(trigger.new, trigger.oldMap);
        } 
    }
}