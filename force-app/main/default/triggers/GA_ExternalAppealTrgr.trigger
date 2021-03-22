trigger GA_ExternalAppealTrgr on GA_External_Appeal__c (before insert,before update) {
    if(trigger.isInsert && trigger.isBefore){
        //GA_ExternalAppealTriggerHandler.beforeinsert(trigger.new);
    }     
    if(trigger.isUpdate && trigger.isBefore){
       // GA_ExternalAppealTriggerHandler.beforeupdate(trigger.new,trigger.oldMap);
    }    
}