/**
@Author : Steven Pascaran
@Name: GA_SalesOfficeTrigger 
@CreatedDate: 6th - June 2020 
@Description: GA_SalesOfficeTrigger   Trigger is for doing updates on Sales office.
@version : 1.0  
*/
trigger GA_SalesOfficeTrigger on GA_Sales_Office__c (before update) {
    if(trigger.isbefore && trigger.isUpdate)
    {            
        GA_SalesOfficeTriggerHandler.beforeupdate(trigger.new, trigger.newmap,trigger.oldmap);
    }
    
}