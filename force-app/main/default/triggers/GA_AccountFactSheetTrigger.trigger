/**
@Author : Prasant Kumar Satpathy
@Name: GA_AccountFactSheetTrigger
@CreatedDate:  3- Jan 2018 
@Description: GA_AccountFactSheetTrigger trigger is for updating Account Factsheet information based on associated Contact Name
@version : 1.0  
*/
trigger GA_AccountFactSheetTrigger on GA_Account_Fact_Sheet__c (before insert,before update) {
    
    static final String triggerName = 'GA_AccountFactSheetTrigger';
    GA_OBJ_TriggerRunCheck__mdt triggrrunchk =GA_OBJ_TD01_TestDataCreation.triggercheck(triggerName);
    
    if(triggrrunchk.GA_TriggerTurnOn__c)
    {
        if(trigger.isbefore && trigger.isInsert)
        {
            GA_AccntFctShtTriggrHandler.beforeInsert(trigger.new,trigger.newmap);  
        }
        if(trigger.isbefore && trigger.isUpdate)
        {
            GA_AccntFctShtTriggrHandler.beforeupdate(trigger.new,trigger.oldmap); 
        }  
    }
    
    
}