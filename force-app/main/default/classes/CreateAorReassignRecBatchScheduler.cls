global class CreateAorReassignRecBatchScheduler implements Schedulable{

    public static String sched = '0 00 05 * * ?';  //Every Day at 5 PM 

    global static String scheduleMe() {
        CreateAorReassignRecBatchScheduler SC = new CreateAorReassignRecBatchScheduler(); 
        return System.schedule('CreateAorReassignRecBatch Scheduler', sched, SC);
    }

    global void execute(SchedulableContext sc) {

        CreateAorReassignRecBatch aorBatch = new CreateAorReassignRecBatch();
        ID batchprocessid = Database.executeBatch(aorBatch,200);           
    }
}