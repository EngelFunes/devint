/**
@Author : IDC Offshore
@Name: GA_AORTrigger 
@CreatedDate: 06 - June 2019 
@Description: GA_AORTrigger trigger is for updateing the AOR Group Segment.
@version : 1.0  
*/
trigger GA_AORTrigger on GA_AOR__c (before insert,before update, after Insert,after update, before delete) {
    static final String TRIGGERNAME = 'GA_AORTrigger';    
    GA_OBJ_TriggerRunCheck__mdt triggrrunchk =GA_OBJ_TD01_TestDataCreation.triggercheck(TRIGGERNAME);
    
    if(triggrrunchk.GA_TriggerTurnOn__c)
    { 
        if(trigger.isBefore && trigger.isInsert)
        {
            GA_AORTriggerHandler.beforeInsert(trigger.New);
        }
        
        if(trigger.isBefore && trigger.isUpdate)
        {
            GA_AORTriggerHandler.beforeUpdate(trigger.new,trigger.oldmap);
        }    
       
        if(trigger.isAfter && trigger.isInsert){
            GA_AORTriggerHandler.afterInsert(trigger.new, trigger.newMap);
        }
        if(trigger.isAfter && trigger.isUpdate){
        
            GA_AORTriggerHandler.afterUpdate(trigger.new, trigger.oldMap);
           
        }
        
    }
}