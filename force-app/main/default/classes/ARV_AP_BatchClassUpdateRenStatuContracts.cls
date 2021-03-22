/*Batch calss written for Contracts to update Relse to backend for Contracts*/
global class ARV_AP_BatchClassUpdateRenStatuContracts implements Database.Batchable<sObject>{ 
    public map<id,string> constatusmap;
    public set<id> setOfIds;
    public ARV_AP_BatchClassUpdateRenStatuContracts(map<id,string>ConstattoUpdate) {
		constatusmap=ConstattoUpdate;
        setOfIds=constatusmap.keySet();
        
    }

   global Database.QueryLocator start(Database.BatchableContext bc) {
      return Database.getQueryLocator( 'SELECT Id,ARV_Renewal_Status__c from Contract where id IN:setOfIds' );
   }     
   global void execute(Database.BatchableContext info, List<Contract> scope){
       List<Contract> conlist=new list<Contract>();
       for(Contract con:scope){
          con.ARV_Renewal_Status__c= constatusmap.get(con.Id);
          conlist.add(con);
       }
       if(conlist.size()>0){
		database.update(conlist);
       }
   }     
   global void finish(Database.BatchableContext info){     
   } 
}