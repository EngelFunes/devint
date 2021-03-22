/**
@Author : Offshore
@Name: ASC_Group_Specific_Pricing 
@CreatedDate: 23 - March 2020 
@Description: ASC_Group_Specific_Pricing   trigger is for creating/Updateing Group Specific Pricing
@version : 1.0  
**/
trigger ASC_Group_Specific_Pricing on ASC_Group_Specific_Pricing__c (after update,after insert,before insert,before update) {
    static final String triggerName = 'ASC_Group_Specific_Pricing';
    GA_OBJ_TriggerRunCheck__mdt triggrrunchk =GA_OBJ_TD01_TestDataCreation.triggercheck(triggerName);
    if(triggrrunchk.GA_TriggerTurnOn__c)
    {
        if(trigger.isafter && trigger.isUpdate)
        {         
            ASC_GroupSpecPricingTriggerHndlr.afterupdate(trigger.new, trigger.newmap,trigger.oldmap);
        }
        if(trigger.isafter && trigger.isInsert)
        {         
            ASC_GroupSpecPricingTriggerHndlr.afterinsert(trigger.new, trigger.newmap,trigger.oldmap);
        }
        if(trigger.isbefore && trigger.isInsert)
        {         
            ASC_GroupSpecPricingTriggerHndlr.beforeinsert(trigger.new);
        }
        if(trigger.isbefore && trigger.isUpdate)
        {         
            ASC_GroupSpecPricingTriggerHndlr.beforeUpdate(trigger.new,trigger.oldmap);
        }

    }
}