/******************************************************************************************************************************************
@Author : Dilip
@Name: GA_Group_Seg_AssociationTrigger
@CreatedDate: 09 - Sep 2018  
@Description: GA_Group_Seg_AssociationTrigger trigger is used to implement logics on 
DML operations of Group Segment Association records.
@version : 1.0  
*****************************************************************************************************************************************/
trigger GA_Group_Seg_AssociationTrigger on GA_Group_Association__c (before insert, before update,after insert,after update) {

static final String triggerName = 'GA_Group_Seg_AssociationTrigger';
    GA_OBJ_TriggerRunCheck__mdt triggrrunchk =GA_OBJ_TD01_TestDataCreation.triggercheck(triggerName);
    
    if(triggrrunchk.GA_TriggerTurnOn__c)
    {
        if(trigger.isBefore && trigger.isInsert)
        {
            GA_Group_Seg_AssociationTriggerHndlr.beforeInsert(trigger.New);
        }
        if(trigger.isBefore && trigger.isUpdate)
        {
            GA_Group_Seg_AssociationTriggerHndlr.beforeUpdate(trigger.New,trigger.OldMap);
        }
        if(trigger.isAfter && trigger.isInsert)
        {
            GA_Group_Seg_AssociationTriggerHndlr.afterInsert(trigger.New);
        }
        if(trigger.isAfter && trigger.isUpdate)
        {
            GA_Group_Seg_AssociationTriggerHndlr.afterUpdate(trigger.New,trigger.OldMap);
        }
    }
}