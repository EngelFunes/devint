/******************************************************************************************************************************************
@Author : IDC Offshore
@Name: GA_Plan_PackageTrgr
@CreatedDate: 07- May 2019  
@Description: GA_Plan_PackageTrgr trigger is used to implement the DML operations of Plan package records.
@version : 1.0  
*****************************************************************************************************************************************/
trigger GA_Plan_PackageTrgr on GA_Plan_Package__c (after update,after insert) {
    static final String triggerName = 'GA_Plan_PackageTrgr';
    GA_OBJ_TriggerRunCheck__mdt triggrrunchk =GA_OBJ_TD01_TestDataCreation.triggercheck(triggerName);
    if(triggrrunchk.GA_TriggerTurnOn__c)
    {
    if(trigger.isInsert && trigger.isAfter)
    {
        GA_Plan_PackageTrgrhndlr.afterinsert(trigger.new);
    }
    if(trigger.isUpdate && trigger.isAfter)
    {
        GA_Plan_PackageTrgrhndlr.afterupdate(trigger.new,trigger.oldMap);
    }
    }
}