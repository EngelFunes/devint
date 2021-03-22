global  class CaseShareOwnerChangeSeq02Batch  implements Database.Batchable<sobject> {
    global List<Case> globallist = new List<Case>(); 
    global CaseShareOwnerChangeSeq02Batch(List<Case> casetoUpdate) {
        globallist = casetoUpdate;
    }
    global Iterable<sObject> start(Database.BatchableContext bc){
        return globallist; 
    }
    global void execute(database.BatchableContext bc, List<Case> updationList){
        Update updationList; 
    }
    global void finish(Database.BatchableContext bc){

    }
}