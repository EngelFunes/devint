/***************************************************************************************************************
@Author : IDC Offshore
@Name:ASC_DfundRequestAgentName_Trigger 
@CreatedDate:  12 December 2020 
@Description: ASC_DfundRequestAgentName_Trigger is used to handle Trigger logic on Dfund_Request__c.
@version : 1.0  
***************************************************************************************************************/
trigger ASC_DfundRequestAgentName_Trigger on Dfund_Request__c (before insert,after insert, before update,after update) {
        if(trigger.isbefore && trigger.isInsert)
        {
            ASC_DfundRequestTriggerHandler.beforeInsert(trigger.new);
        } 
        if(trigger.isafter && trigger.isInsert)
        {
            ASC_DfundRequestTriggerHandler.afterInsert(trigger.new);
        } 
      if(trigger.isUpdate && trigger.isbefore)
        {
            ASC_DfundRequestTriggerHandler.beforeUpdate(trigger.new,trigger.oldmap);
        }  
    
    //Sreenu R added the below codes
    if(trigger.isAfter && trigger.isUpdate){
        ASC_DfundRequestTriggerHandler.afterUpdate(trigger.newmap,trigger.oldmap);
    }
}