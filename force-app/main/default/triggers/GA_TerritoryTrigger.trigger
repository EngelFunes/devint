/**
@Author : IDCOffshore
@Name: GA_TerritoryTrigger
@CreatedDate: 1/7/2019
@Description: GA_TerritoryTrigger trigger is for performing business logics on Territory object.
@version : 1.0  
*/
trigger GA_TerritoryTrigger on GA_Territory__c (before update,before insert) {
    
    static final String triggerName = 'GA_TerritoryTrigger';
    GA_OBJ_TriggerRunCheck__mdt triggrrunchk =GA_OBJ_TD01_TestDataCreation.triggercheck(triggerName);
    
    if(triggrrunchk.GA_TriggerTurnOn__c)
    {
        if(trigger.isUpdate && trigger.isbefore){
            GA_TerritoryTriggerHandler.beforeupdate(trigger.new,trigger.oldMap); 
        }
      /*  if(trigger.isInsert && trigger.isbefore){
            GA_TerritoryTriggerHandler.beforeInsert(trigger.new); 
        } */
    }
}