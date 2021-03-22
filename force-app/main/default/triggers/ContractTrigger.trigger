trigger ContractTrigger on Contract (after undelete, before delete, after update,before update,after insert,before insert) {
    
    set<ID> cIds = new set<ID>();
    List<String> apIds = new List<String>();
    List<ActionPlan__c> deletePermantently_apIds= new List<ActionPlan__c>();    
    //Delete related action plans
    if(trigger.isdelete){
        for( Contract c : trigger.old ){
            cIds.add( c.Id );
        }
        
        /* GET Action Plans to delete from recycle bin */
        deletePermantently_apIds = [ select Id, Name , LastModifiedDate from ActionPlan__c where Contract__c in : cIds and isDeleted = true ALL ROWS ];
        
        if ( deletePermantently_apIds.size() >0 ){          
            Database.emptyRecycleBin(deletePermantently_apIds);
        }           
        
        //Get all action plans associated with Campaigns
        for( Contract a : [Select (Select Id From Action_Plans__r) From Contract a where Id in : cIds]){
            if (a.Action_Plans__r.size() >0 ){
                for(ActionPlan__c ap :a.Action_Plans__r ){
                    apIds.add(ap.Id);
                }
            }
        }
        if ( apIds.size() >0 ){         
            ActionPlansBatchDelete aPBatch = new ActionPlansBatchDelete(apIds, Userinfo.getUserId());
            Database.ExecuteBatch( aPBatch );       
        }
    }
    
    //Undelete related action plans
    if ( trigger.isUnDelete ){
        for( Contract c : trigger.new ){
            cIds.add( c.Id );
        }
        list <ActionPlan__c> aPs = [ select Id from ActionPlan__c where Contract__c in : cIds ALL ROWS ];
        
        try{
            //throw dmlException
            if(ActionPlanObjectTriggerTest.isTest){   insert new Contact();   
                                                  }
            //undelete aPs;
            Database.undelete( aPs,false);
        } catch ( Dmlexception e ){
            for (Contract c: trigger.new){  c.addError('You can not undelete an action plan whose related object is deleted.');
                                         }
        }
    }
    
    //Update related action plans
    //Automatic Opportunity Stage updates
    if(trigger.isAfter && trigger.isUpdate) {
        List<Contract> activatedContracts = new List<Contract>();
        List<Contract> cancelledContracts = new List<Contract>();
        
        Id ASC_CONTRACT_RECTYPEID = Schema.SObjectType.Contract.getRecordTypeInfosByDeveloperName().get('ASC_Contract').getRecordTypeId();
        for(Contract ct : trigger.new) {
            if(ct.RecordTypeId == ASC_CONTRACT_RECTYPEID) {
                if((trigger.oldMap.get(ct.Id).Status != ct.Status) && ct.Status == 'Activated') {
                    activatedContracts.add(ct);
                }
                else if((trigger.oldMap.get(ct.Id).Status != ct.Status) && ct.Status == 'Cancelled') {
                    cancelledContracts.add(ct);
                }
            }
        }
        
        if(activatedContracts.size() > 0) {
            ContractTriggerHandler.updateOpportunitiesOnActivatedContracts(activatedContracts);
            ContractTriggerHandler.updatePlansOnActivatedContracts(activatedContracts);
        }
        
        if(cancelledContracts.size() > 0) {
            ContractTriggerHandler.updateQuotesOnCancelledContracts(cancelledContracts);
            ContractTriggerHandler.updatePlansOnCancelledContracts(cancelledContracts);
        }
        
        /*US-3625 -Added By Dinesh -  after update - This class is used to create/update the Status History Tracking records when there is an update on
          Contract - Status, Invoice Setup ,Signature Status
          Opportunity - StageName , Sub Stage
          Quote - Status
          Plan - Activation Status*/ 
        ContractTriggerHandler.updateHistoryTrackingrecords(trigger.new,trigger.oldMap);      
        
        /*US-3625 -Added By Dinesh -  before update - to update the Contract - Status,Signature Status , Quote - Status, Opportunity - StageName ,Sub Stage.*/        
        ContractTriggerHandler.updateOpportunityStage(trigger.new,trigger.oldMap);      
    }
    
    if(trigger.isAfter && trigger.isInsert) {
       /*US-3625 -Added By Dinesh -  after update - This class is used to create/update the Status History Tracking records when there is an update on
          Contract - Status, Invoice Setup ,Signature Status
          Opportunity - StageName , Sub Stage
          Quote - Status
          Plan - Activation Status*/ 
        ContractTriggerHandler.createHistoryTrackingrecords(trigger.new); 
        
    }
    
    //US-4433
     if(trigger.isBefore && trigger.isInsert) {
         
         ContractTriggerHandler.ascBaseContractValidation(trigger.new); 
        
     }
    
    /*US-3625 Added By Sundeep to update contract status to Activated. */
    if(trigger.isBefore && trigger.isUpdate) {
       
        ContractTriggerHandler.updateContractStatus(trigger.new,trigger.oldMap);
    }
}