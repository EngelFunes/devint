/*******************************************************************************************************************************
@Author : Raj Jena
@Name: ASC_Product_Trigger 
@CreatedDate: 12 - Feb 2020 
@Description: ASC_Product_Trigger trigger is for performing business logics on Product
@version : 1.0  
********************************************************************************************************************************/
trigger ASC_Product_Trigger on Product2 (before insert) {
    static final String triggerName = 'ASC_Product_Trigger';
    GA_OBJ_TriggerRunCheck__mdt triggrrunchk =GA_OBJ_TD01_TestDataCreation.triggercheck(triggerName);
    if(triggrrunchk.GA_TriggerTurnOn__c){   
        if(trigger.isbefore && trigger.isInsert){
            ASC_Product_TriggerHandler.beforeInsert(trigger.new);            
        }
    }
}