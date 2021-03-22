trigger EnvelopeStatusTrigger on dfsle__EnvelopeStatus__c (after Insert, after Update) {
    if(trigger.IsAfter && (trigger.isInsert || trigger.IsUpdate)){
        EnvelopeStatusTrigger_Handler.AfterInsertOperationHandler(trigger.new);
        if(!System.isFuture())
        EnvelopeStatusTrigger_Handler.UpdateContractStatusToVoid(trigger.newMap.KeySet());    
    }
}