global class GA_UpdateAORSRShareBOBBatch implements Database.Batchable<sObject>, Database.Stateful,Schedulable {
    // public wrapRetunLists retunWrap {get; set;}
    private  String COMPLETED_BATCH = 'Completed';
    private static integer MAX_SIZE = 8000;
    public  List<CaseShare> caseSharestobeshared = new List<CaseShare>();
    global String query='select id ,GA_Contact_Id__c,GA_Account_Id__c,GA_Service_Start_Date__c,GA_Service_End_Date__c FROM GA_AOR__C where GA_Account_Id__r.Recordtype.Name = \'Account - Customer\' and isStatusDatesModified__c = true'; //  ';
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC,List<GA_AOR__C> scope)
    {
        System.debug(scope.size());
         List<CaseShare> caseSharestobesharedtemp = new List<CaseShare>();
        
        caseSharestobesharedtemp = GA_updateAORBoB.supportRequestShareBatchUpdateBoB(scope);
        try{ 
             if(caseSharestobesharedtemp.size() > 0 && caseSharestobesharedtemp.size()<=MAX_SIZE){                 
                            List<Database.SaveResult> sr = Database.insert(caseSharestobesharedtemp ,false);           
             }else{ 
                    caseSharestobeshared.addall(caseSharestobesharedtemp);
             }
         }catch(Exception e){     
                     system.debug(logginglevel.error,+ e.getMessage());
                     GA_LogExceptionCls.LogExcp(e, 'GA_UpdateAORSRShareBOBBatch', 'execute');                 
         } 
        
      //  CaseShareDeletionBatchHelper.supportRequestShareBatchDeleteBoB2(scope); 
    }
    global void finish(Database.BatchableContext BC)
    {
        if(caseSharestobeshared!=null && caseSharestobeshared.size()>0){
             CaseShareSeq02Batch  inserBatch=new CaseShareSeq02Batch(caseSharestobeshared);
             Database.executeBatch(inserBatch, 1500);
           }
    }
    global void execute(SchedulableContext sc)
    {
        GA_UpdateAORSRShareBOBBatch batchShare = new  GA_UpdateAORSRShareBOBBatch(); 
        Database.executeBatch(batchShare, 5); 
    }
    
    }