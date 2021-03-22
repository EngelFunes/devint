/*******************************************************************************************************************************
@Author : IDC Offshore
@Name: ASC_ProductDocMapping_Trigger 
@CreatedDate:  29 April 2020 
@Description: ASC_ProductDocMapping_Trigger trigger is for performing business logics on Product Document Mapping.
@version : 1.0  
********************************************************************************************************************************/
trigger ASC_ProductDocMapping_Trigger on Product_Document_Mapping__c (before insert, before update) {
    static final String triggerName = 'ASC_ProductDocMapping_Trigger'; 
    GA_OBJ_TriggerRunCheck__mdt triggrrunchk =GA_OBJ_TD01_TestDataCreation.triggercheck(triggerName);
    if(triggrrunchk.GA_TriggerTurnOn__c){
        if(trigger.isbefore && trigger.isInsert)
        {
            ASC_ProductDocMapping_TriggerHandler.beforeInsert(trigger.new);
        } 
        if(trigger.isbefore && trigger.isUpdate)
        {  
            ASC_ProductDocMapping_TriggerHandler.beforeUpdate(trigger.new, trigger.oldMap);
        }
    }
    
}