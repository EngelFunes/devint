/******************************************************************************************************************************************
@Author : Dilip
@Name: GA_DC_Small_Grp_History__c
@CreatedDate: 28 - Sep 2018  
@Description: GA_DC_Small_Grp_History__c trigger is used to implement logics on 
DML operations of Small Group History records.
@version : 1.0  
*****************************************************************************************************************************************/
trigger GA_GA_DCSmallGrpHistryTrigger on GA_DC_Small_Grp_History__c (after insert, after update) {
static final String triggerName = 'GA_GA_DCSmallGrpHistryTrigger';
    GA_OBJ_TriggerRunCheck__mdt triggrrunchk =GA_OBJ_TD01_TestDataCreation.triggercheck(triggerName);
    
    if(triggrrunchk.GA_TriggerTurnOn__c)
    {
        if(trigger.isAfter && trigger.isInsert)
        {
            GA_GA_DCSmallGrpHistryTriggerHndlr.afterInsert(trigger.New);
        }
        if(trigger.isAfter && trigger.isUpdate)
        {
            GA_GA_DCSmallGrpHistryTriggerHndlr.afterUpdate(trigger.New,trigger.OldMap);
        }
    }
}