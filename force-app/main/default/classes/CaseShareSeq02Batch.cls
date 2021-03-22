global class CaseShareSeq02Batch  implements Database.Batchable<sobject> {
    global List<CaseShare> globallist = new List<caseShare>(); 
    global CaseShareSeq02Batch(List<CaseShare> caseShareList) {
    system.debug('$$$$$caseshareList$$$$$$$$'+caseshareList);
        globallist = caseShareList;
    }
    global Iterable<sObject> start(Database.BatchableContext bc){
    system.debug('$$$$$globallist$$$$$$$$'+globallist);
        return globallist; 
    }
    global void execute(database.BatchableContext bc, List<CaseShare> caseshareList){
    try{
          system.debug('$$$$$caseshareList$$$$$$$$'+caseshareList);
         if (caseshareList!=null && caseshareList.size() > 0 ) {
              Database.insert(caseshareList,false);
         }
      } catch(Exception e) {     
         system.debug(logginglevel.error,+ e.getMessage());
         GA_LogExceptionCls.LogExcp(e, 'caseShareSeq02Batch', 'batchexecute');     
     }
        
    }
    global void finish(Database.BatchableContext bc){
    }
}