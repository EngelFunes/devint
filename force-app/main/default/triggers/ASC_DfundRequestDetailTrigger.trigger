/*******************************************************************************************************************************
@Author : IDC Offshore
@Name:ASC_DfundRequestDetailTrigger 
@CreatedDate:  2-23-2021 
@Description: ASC_DfundRequestDetailTrigger is used to handle Trigger logic on Dfund_Request_Detail__c.
@version : 1.0  
********************************************************************************************************************************/
trigger ASC_DfundRequestDetailTrigger on Dfund_Request_Detail__c (after update ,before update) {
    	
        
    	 if(trigger.isUpdate && trigger.isafter) {
         	
            ASC_DfundRequestDetailTriggerHandler.afterUpdate(trigger.new,trigger.oldmap);
        
        }  
    if(trigger.isUpdate && trigger.isbefore) {
         	
           ASC_DfundRequestDetailTriggerHandler.beforeUpdate(trigger.new,trigger.oldmap);
        
        }   
	
}