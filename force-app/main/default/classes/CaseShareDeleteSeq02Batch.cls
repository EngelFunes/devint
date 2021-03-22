global class CaseShareDeleteSeq02Batch  implements Database.Batchable<sobject> {
    global List<SObject> globallist = new List<SObject>(); 
    global CaseShareDeleteSeq02Batch(List<SObject> caseShareListToDelete) {
        globallist = caseShareListToDelete;
    }
    global Iterable<sObject> start(Database.BatchableContext bc){
        return globallist; 
    }
    global void execute(database.BatchableContext bc, List<SObject> deletionList){
    
        set<id> rmv = new set<id>(); 
        for(SObject casrec : deletionList){
            rmv.add(casrec.id); 
        }
        List<id> ls = new List<id>(rmv); 
        system.debug('deletionlist size' + deletionList.size());
        Database.delete(ls, false);
    }
    global void finish(Database.BatchableContext bc){
    }
}