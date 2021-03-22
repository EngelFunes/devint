/**
@Author : IDC Offshore
@Name: GA_WorkflowTrgr 
@CreatedDate: 24 - Oct 2017 
@Description: GA_ASEPTrigger trigger is for  ASEP .
@version : 1.0  
*/
trigger GA_WFStepTrigger on GA_WF_Step__c (before insert, after insert) {
  static final String triggerName = 'GA_WFStepTrigger';
  GA_OBJ_TriggerRunCheck__mdt triggrrunchk =GA_OBJ_TD01_TestDataCreation.triggercheck(triggerName);
    
  if(trigger.isInsert && trigger.isAfter){
  GA_WFStepTriggerHandler.afterInsert(Trigger.New,Trigger.NewMap);
  }

  if(trigger.isBefore){
    if(trigger.isInsert){
      GA_WFStepTriggerHandler.beforeInsert(trigger.new);  
    }
  }
}