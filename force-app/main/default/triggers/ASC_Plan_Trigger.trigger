/*******************************************************************************************************************************
@Author : Mida Komal
@Name: ASC_Plan_Trigger 
@CreatedDate: 9 - May 2020 
@Description: ASC_Plan_Trigger trigger is for performing business logics on Plan
@version : 1.0  
********************************************************************************************************************************/

trigger ASC_Plan_Trigger on vlocity_ins__ContractLineItem__c(before insert,before update,after insert,after update){
    static final String triggerName = 'ASC_Plan_Trigger';
    
    GA_OBJ_TriggerRunCheck__mdt triggrrunchk =GA_OBJ_TD01_TestDataCreation.triggercheck(triggerName);
    if(triggrrunchk.GA_TriggerTurnOn__c)
    { 
        if(trigger.isbefore && trigger.isInsert)
        {
            ASC_PlanTriggerHandler.beforeInsert(trigger.new);          
            ASC_PlanTriggerHandler.duplicatePlanInsert(trigger.new);                                      
        }
        if(trigger.isbefore && trigger.isUpdate){
            ASC_PlanTriggerHandler.beforeUpdate(trigger.new);
        }
        if(trigger.isAfter && trigger.isInsert){
            ASC_PlanTriggerHandler.afterInsert(trigger.new);
        }
        if(trigger.isAfter && trigger.isUpdate){
            ASC_PlanTriggerHandler.afterUpdate(trigger.new,trigger.oldmap);
        }
    }
}