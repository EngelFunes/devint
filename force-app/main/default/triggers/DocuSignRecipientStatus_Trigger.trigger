trigger DocuSignRecipientStatus_Trigger on dfsle__RecipientStatus__c (after Insert,after Update) {
    if(trigger.isInsert && trigger.isAfter){
        RecipientStatusTrigger_Handler.AfterInsertOperationHandler(trigger.new,NULL);
    }
    if(trigger.isUpdate && trigger.isAfter){
        RecipientStatusTrigger_Handler.AfterInsertOperationHandler(trigger.new,trigger.oldmap);
    }
}