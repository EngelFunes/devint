/*Batch calss written for Contracts to update RenewalBatchId on Contract*/
global class ARV_AP_BatchClassUpdateContracts implements Database.Batchable<sObject>{ 
    public set<id> updatedContracts=new set<ID>();
     public id batchId;
    public string emptyString;
    public ARV_AP_BatchClassUpdateContracts(Set<id> conId,Id btchId,string errString) {
        updatedContracts =conId ;
        batchId=btchId;
        emptyString=errString;
        system.debug('pllluu'+updatedContracts);
        system.debug('hhhh'+batchId);
        
    }

   global Database.QueryLocator start(Database.BatchableContext bc) {
      return Database.getQueryLocator( 'SELECT ID, Name,Renewal_Batch__c,ARV_Renewal_Error_Message__c,ARV_Renewal_Creation_Status__c,ARV_Renewal_Error__c from Contract where Id in:updatedContracts' );
   }     
   global void execute(Database.BatchableContext info, List<Contract> scope){
       List<Contract> consToUpdate = new List<Contract>();
       for(Contract cnt : scope){ 
           cnt.ARV_Is_Generate_Renewal__c = true;
            cnt.Renewal_Batch__c =batchId;
            cnt.ARV_Renewal_Error_Message__c = emptyString;
            cnt.ARV_Renewal_Creation_Status__c = emptyString;
            cnt.ARV_Renewal_Error__c = emptyString;
           consToUpdate.add(cnt); 
       } 
       if(consToUpdate.size()>0){
       database.update(consToUpdate); 
       }
   }     
   global void finish(Database.BatchableContext info){     
   } 
}