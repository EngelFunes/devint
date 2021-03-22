global class GA_UpdateAORSRBOBBatch implements Database.Batchable<sObject>, Database.Stateful,Schedulable {
    // public wrapRetunLists retunWrap {get; set;}
    private  String COMPLETED_BATCH = 'Completed';
    private static integer MAX_SIZE = 8000;
    public  List<CaseShare> caseSharestobeshared = new List<CaseShare>();
    global String query='select id ,GA_Contact_Id__c,GA_Account_Id__c,GA_Service_Start_Date__c,GA_Service_End_Date__c FROM GA_AOR__C where GA_Account_Id__r.Recordtype.Name = \'Account - Customer\' and isStatusDatesModified__c = true'+(Test.isRunningTest()?' LIMIT 200':''); //  ';
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC,List<GA_AOR__C> scope)
    {
        
        CaseShareDeletionBatchHelper.supportRequestShareBatchDeleteBoB2(scope); 
    }
    global void finish(Database.BatchableContext BC)
    {
       
         DelegateAgentAndAgentSharingBatch batch=new DelegateAgentAndAgentSharingBatch();
         if(!Test.isRunningTest())
         Database.executeBatch(batch, 1);

    }
    global void execute(SchedulableContext sc)
    {
        GA_UpdateAORSRBOBBatch batchShare = new  GA_UpdateAORSRBOBBatch(); 
        Database.executeBatch(batchShare, 2); 
    }
    
    }