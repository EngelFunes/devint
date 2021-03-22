/**
@Author : IDC Offshore
@Name: GA_WorkflowTrgr 
@CreatedDate: 24 - May 2017 
@Description: GA_WrkFlwProcessTrigger trigger is for updateing the workflow .
@version : 1.0  
*/
trigger GA_WorkflowTrgr on GA_WF_Workflow__c (after insert,after update, before insert) {
    static final String triggerName = 'GA_WorkflowTrgr';
    GA_OBJ_TriggerRunCheck__mdt triggrrunchk =GA_OBJ_TD01_TestDataCreation.triggercheck(triggerName);
    
    if(trigger.isInsert && trigger.isBefore){
        GA_WorkflowTrgrHndlr.beforeInsert(trigger.new);
    }
    if(trigger.isInsert && trigger.isAfter){
        GA_WorkflowTrgrHndlr.afterInsert(trigger.new);
    }
    
    if(trigger.isUpdate && trigger.isAfter){
        GA_WorkflowTrgrHndlr.afterUpdate(trigger.new,trigger.OldMap);
    }
    
}