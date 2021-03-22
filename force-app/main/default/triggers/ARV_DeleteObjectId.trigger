trigger ARV_DeleteObjectId on ARV_Renewal_Batch_Log__c (after insert){
    if(trigger.isAfter&&trigger.isInsert){
    ARV_AP100_DeleteRenewalBatchRecords.deletelogRecords(trigger.new);
   }
}