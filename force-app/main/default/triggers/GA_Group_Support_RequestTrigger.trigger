/**
@Author : Prasant Kumar Satpathy
@Name: GA_Group_Support_RequestTrigger
@CreatedDate: 6/20/2018 
@Description: GA_Group_Support_RequestTrigger trigger is used to implement logics on 
DML operations of Support request relationship records.
@version : 1.0  
*/
trigger GA_Group_Support_RequestTrigger on GA_Group_Support_Request__c (before insert,before update) {
    static final String triggerName = 'GA_Group_Support_RequestTrigger';
    GA_OBJ_TriggerRunCheck__mdt triggrrunchk =GA_OBJ_TD01_TestDataCreation.triggercheck(triggerName);
    
    if(triggrrunchk.GA_TriggerTurnOn__c)
    {
        if(trigger.isBefore && trigger.isInsert)
        {
            GA_Group_Support_RqstTriggerHndlr.beforeInsert(trigger.New);
        }
        if(trigger.isBefore && trigger.isUpdate)
        {
            GA_Group_Support_RqstTriggerHndlr.beforeUpdate(trigger.New,trigger.OldMap);
        }
    }
}