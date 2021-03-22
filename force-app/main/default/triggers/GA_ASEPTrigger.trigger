/**
@Author : IDC Offshore
@Name: GA_WorkflowTrgr 
@CreatedDate: 24 - Oct 2017 
@Description: GA_ASEPTrigger trigger is for  ASEP .
@version : 1.0  
*/
trigger GA_ASEPTrigger on GA_Agent_Sold_Enrollment__c (before insert,before update,after update) {
    
    static final String triggerName = 'GA_ASEPTrigger';
    GA_OBJ_TriggerRunCheck__mdt triggrrunchk =GA_OBJ_TD01_TestDataCreation.triggercheck(triggerName);
    if(triggrrunchk.GA_TriggerTurnOn__c)
    {
        if(trigger.isInsert && trigger.isBefore){
            GA_ASEPTriggrHandler.beforeinsert(Trigger.New,Trigger.NewMap);
        }
        
        if(trigger.isUpdate && trigger.isBefore){
            GA_ASEPTriggrHandler.beforeupdate(Trigger.New,Trigger.NewMap);
        }
        
        if(trigger.isafter && trigger.isUpdate)
        {
            GA_ASEPTriggrHandler.afterupdate(trigger.new, trigger.newmap,trigger.oldmap);
        }   
    }
    
    
}