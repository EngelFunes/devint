/*********************************************************************************
Apex class : GA_DeleteGroupSegmentPending_Scheduler 
Author: Knocky Lo
Description: Deletes Group Segment Scheduler
**********************************************************************************/
global class GA_DeleteGroupSegmentPending_Scheduler implements Schedulable {
 global void execute(SchedulableContext SC) {
        GA_DeleteGroupSegmentBatchPending b1 = new GA_DeleteGroupSegmentBatchPending();
        ID batchprocessid = Database.executebatch(b1,200);  
    }
}