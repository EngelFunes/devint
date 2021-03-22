global with sharing class CreateAorReassignRecBatch implements Database.Batchable<sObject>,Database.Stateful,Schedulable{
    global String query;
    global Map <String,AOR_Reassign__c> accIdvsObjMap = new Map<String,AOR_Reassign__c>();
    public CreateAorReassignRecBatch() {
      query = 'select id, AccountId__c , To_Contact__c ,Service_Start_Date__c,Commission_Start_Date__c,  AOR__c,To_Contact__r.Name,Processed__c , AOR_Group_Segment__r.GA_Group_Segment_Id__c   from AOR_Reassign__c where Processed__c  = false ';
    }

    global Database.QueryLocator start(Database.BatchableContext bc){      
        
        system.debug('*** query--'+query);
        return Database.getQueryLocator(query);
    }
     
    global void execute(Database.BatchableContext BC, list<AOR_Reassign__c> accountScope_List){     
        List<GA_AOR__c > AORListToUpdate = new List<GA_AOR__c >();
        List<GA_AOR__c > AORListToInsert = new List<GA_AOR__c >();
        List<GA_AOR_Group_Segment__c > GroupSegToInsert = new List<GA_AOR_Group_Segment__c >();
        Map<Id, List<AOR_Reassign__c>> mapOfAorIdVSAORReaasignRecords = new Map<Id, List<AOR_Reassign__c>>();
        if(accountScope_List != null && !accountScope_List.isEmpty()){
            for(AOR_Reassign__c re : accountScope_List){
                if(mapOfAorIdVSAORReaasignRecords.containsKey(re.AOR__c) && mapOfAorIdVSAORReaasignRecords.get(re.AOR__c) != null) {
                    List<AOR_Reassign__c> lst_terr = mapOfAorIdVSAORReaasignRecords.get(re.AOR__c);
                    lst_terr.add(re);
                    mapOfAorIdVSAORReaasignRecords.put(re.AOR__c,lst_terr); 
                }   
                else {
                    mapOfAorIdVSAORReaasignRecords.put(re.AOR__c, new List<AOR_Reassign__c> {re});
                }
            }
        }
        
        if(mapOfAorIdVSAORReaasignRecords != null && mapOfAorIdVSAORReaasignRecords.size() > 0 ){
            system.debug('mapOfAorIdVSAORReaasignRecords---->'+JSON.serializepretty(mapOfAorIdVSAORReaasignRecords));
            for(GA_AOR__c aor : [select Id,GA_Contact_Id__c from GA_AOR__c where Id IN:  mapOfAorIdVSAORReaasignRecords.keyset()]){
                aor.GA_Service_End_Date__c = system.today(); //mapOfAorIdVSAORReaasignRecords.get(aor.Id)[0].To_Contact__c;
                AORListToUpdate.add(aor);
            }
        }
        //List<Id> successIds = new  List<Id>();
        if(AORListToUpdate != null && !AORListToUpdate.isEmpty()){
            Database.SaveResult[] saveresult    =   Database.update(AORListToUpdate, true);
            /*for (Database.SaveResult resultRecord : saveresult) {
                if (resultRecord.isSuccess()) {
                    system.debug('Success');
                    successIds.add( resultRecord.getId());
                }
                else {
                    for(Database.Error errorRecord : resultRecord.getErrors()) {
                        system.debug('Error- '+errorRecord.getMessage());
                    }
                }
            }
            List<AOR_Reassign__c> aorReassign = new List<AOR_Reassign__c>();
            if(successIds != null && !successIds.isEmpty()){
                for(AOR_Reassign__c re : accountScope_List){
                    re.Processed__c = true;
                    aorReassign.add(re);
                }
                if(aorReassign != null && aorReassign.size() > 0){
                    update aorReassign;
                }
            }*/
        }
        if(mapOfAorIdVSAORReaasignRecords != null && mapOfAorIdVSAORReaasignRecords.size() > 0 ){
            system.debug('mapOfAorIdVSAORReaasignRecords---->'+JSON.serializepretty(mapOfAorIdVSAORReaasignRecords));
            for(Id aorId : mapOfAorIdVSAORReaasignRecords.keyset()){
                
                    AOR_Reassign__c reassign = mapOfAorIdVSAORReaasignRecords.get(aorId)[0];
                    GA_AOR__c newAOR = new GA_AOR__c();
                    newAOR.GA_Contact_Id__c=reassign.To_Contact__c;
                    newAOR.GA_Account_Id__c =reassign.AccountId__c;
                    newAOR.Name =reassign.To_Contact__r.Name+'( )'+system.today();
                    newAOR.GA_Service_Start_Date__c  =reassign.Service_Start_Date__c ;
                    newAOR.GA_Commission_Start_Date__c =reassign.Commission_Start_Date__c;
                     
                    newAOR.ExternalId__c =aorId;
                    AORListToInsert.add(newAOR);
                
            }
        }
        
        
         List<Id> successIds = new  List<Id>();
          List<Id> successGSIds = new  List<Id>();
        if(AORListToInsert != null && !AORListToInsert.isEmpty()){
            system.debug('AORListToInsert----->'+JSON.serializepretty(AORListToInsert));
            Database.SaveResult[] saveresult    =   Database.insert(AORListToInsert, true);
            for (Database.SaveResult resultRecord : saveresult) {
                if (resultRecord.isSuccess()) {
                    system.debug('Success');
                    successIds.add( resultRecord.getId());
                }
                else {
                    for(Database.Error errorRecord : resultRecord.getErrors()) {
                        system.debug('Error- '+errorRecord.getMessage());
                    }
                }
            }
            
            if(successIds != null && !successIds.isEmpty()){
                List<GA_AOR__c> newAors = [select id, ExternalId__c, GA_Account_Id__c, GA_Contact_Id__r.Name from GA_AOR__c where Id IN: successIds];
                for(GA_AOR__c newAor : newAors){
                    for(AOR_Reassign__c reassignGS : mapOfAorIdVSAORReaasignRecords.get(newAor.ExternalId__c)){
                        GA_AOR_Group_Segment__c newGS = new GA_AOR_Group_Segment__c();
                        newGS.GA_AOR_Id__c = newAor.Id;
                        newGS.GA_Group_Segment_Id__c = reassignGS.AOR_Group_Segment__r.GA_Group_Segment_Id__c;
                        newGs.Name =  newAor.GA_Contact_Id__r.Name+' '+system.today();
                        GroupSegToInsert.add(newGS);
                        
                    }
                }                          
            }
            Database.SaveResult[] saveresultGS;
            if(GroupSegToInsert != null && !GroupSegToInsert.isEmpty()){
                    try{
                            saveresultGS    =   Database.insert(GroupSegToInsert, true);
                            for (Database.SaveResult resultRecord : saveresultGS) {
                            if (resultRecord.isSuccess()) {
                                system.debug('Success');
                                successGSIds.add( resultRecord.getId());
                            }
                            else {
                                for(Database.Error errorRecord : resultRecord.getErrors()) {
                                    system.debug('Error- '+errorRecord.getMessage());
                                }
                            }
                        }
                        
                        List<AOR_Reassign__c> aorReassign = new List<AOR_Reassign__c>();
                        if(successIds != null && !successIds.isEmpty()){
                            for(AOR_Reassign__c re : accountScope_List){
                                re.Processed__c = true;
                                aorReassign.add(re);
                            }
                            if(aorReassign != null && aorReassign.size() > 0){
                                update aorReassign;
                            }
                        }
                    } catch(dmlException e){
                        system.debug('error----'+e.getMessage());
                    }
                    
            }
        }
        
    }
    
    global void finish(Database.BatchableContext BC){
                 
    }

    global void execute(SchedulableContext sc){    
        CreateAorReassignRecBatch batch = new CreateAorReassignRecBatch();
        Database.executeBatch(batch, 100);
    }
    



}