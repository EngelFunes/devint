global class GA_DeleteGroupSegmentBatchPending implements Database.batchable<sObject> {
    /*********************************************************************************
Apex class : GA_DeleteGroupSegmentBatchPending 
Author: Knocky Lo
Description: Deletes Group Segment Batch Class
**********************************************************************************/
    //Start of this batch job
    global Database.QueryLocator start(Database.BatchableContext BC) {
        string query = 'SELECT Id,createddate  FROM GA_Group_Segment__c WHERE CreatedDate < LAST_N_MONTHS:6 and Status__c = \'Pending\'';
        return Database.getQueryLocator(query);
    }
    //Exeution of batch job
    global void execute(Database.BatchableContext BC, List<GA_Group_Segment__c> scope) {
        GA_DeleteGroupSegmentPending_Batch.deleteGroupSegment(scope);
    }
    //finish job
    global void finish(Database.BatchableContext BC) {
    }
    
}