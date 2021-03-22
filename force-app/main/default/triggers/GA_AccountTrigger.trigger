/**
@Author : PadmaHaarika Jayana
@Name: GA_AccountTrigger 
@CreatedDate: 31 - Jul 2017 
@Description: GA_AccountTrigger   trigger is for creating/Updateing Account
@version : 1.0  
*/
trigger GA_AccountTrigger on Account (before update,after update,after insert,before insert) {
    
    static final String triggerName = 'GA_AccountTrigger';
    GA_OBJ_TriggerRunCheck__mdt triggrrunchk =GA_OBJ_TD01_TestDataCreation.triggercheck(triggerName);
    Boolean partnerChange;
    partnerChange = GA_AccountTriggerHandlr.modifyPartner(trigger.newmap,trigger.oldmap);
    if(triggrrunchk.GA_TriggerTurnOn__c)
    {
        if(trigger.isbefore && trigger.isUpdate && !partnerChange)
        {            
            GA_AccountTriggerHandlr.beforeupdate(trigger.new, trigger.newmap,trigger.oldmap);
            GA_AccountTriggerHandlr.getAccountTeam(trigger.old, trigger.newmap,trigger.oldmap);
        }   
        if(trigger.isafter && trigger.isUpdate && !partnerChange)
        {         
            GA_AccountTriggerHandlr.afterupdate(trigger.new, trigger.newmap,trigger.oldmap);
        }
          
        if(trigger.isafter && trigger.isInsert)
        {
            GA_AccountTriggerHandlr.afterinsert(trigger.new, trigger.newmap,trigger.newmap);
        } 
        if(trigger.isbefore && trigger.isInsert)
        {
            GA_AccountTriggerHandlr.beforeinsert(trigger.new, trigger.newmap);
        } 
    }
    
}