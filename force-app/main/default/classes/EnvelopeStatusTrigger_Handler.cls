Public class EnvelopeStatusTrigger_Handler{
    
    public static void AfterInsertOperationHandler(list<dfsle__EnvelopeStatus__c> EnvelopeStatusList){
        try{
            set<id> envStatusSourceContractId=new set<id>();
            for(dfsle__EnvelopeStatus__c envStatus:EnvelopeStatusList){
                if(envStatus.dfsle__SourceId__c!=NULL && (envStatus.dfsle__Status__c=='sent' || envStatus.dfsle__Status__c=='Voided' || envStatus.dfsle__Status__c=='Completed' || envStatus.dfsle__Status__c=='Declined')) 
                    envStatusSourceContractId.add(envStatus.dfsle__SourceId__c);
                system.debug('Adding envStatus.dfsle__SourceId__c to source con ids...'+envStatus.dfsle__SourceId__c);
            }
            map<id,Contract> ContractUpdateMap=new map<id,Contract>([SELECT ID,ASC_Signature_Status__c, Status 
                                                                     FROM Contract WHERE ID IN:envStatusSourceContractId]);
            for(dfsle__EnvelopeStatus__c envStatus:EnvelopeStatusList){
                if(envStatus.dfsle__SourceId__c!=NULL && envStatus.dfsle__Status__c=='sent' && ContractUpdateMap.containsKey(envStatus.dfsle__SourceId__c) && 
                   (ContractUpdateMap.get(envStatus.dfsle__SourceId__c).ASC_Signature_Status__c==NULL ||ContractUpdateMap.get(envStatus.dfsle__SourceId__c).ASC_Signature_Status__c=='Declined'||ContractUpdateMap.get(envStatus.dfsle__SourceId__c).ASC_Signature_Status__c=='Voided')){
                       ContractUpdateMap.get(envStatus.dfsle__SourceId__c).ASC_Signature_Status__c='Requested';
                       ContractUpdateMap.get(envStatus.dfsle__SourceId__c).Status ='Accepted';
                   }
                System.debug('test before  ENV status'+envStatus.dfsle__SourceId__c);
                System.debug('test before ENV status'+envStatus.dfsle__Status__c);
                
                system.debug('ContractUpdateMap...'+ContractUpdateMap);
                
                System.debug('trying to set  declined status:' + envStatus.dfsle__Status__c);
                if(envStatus.dfsle__SourceId__c!=NULL && envStatus.dfsle__Status__c=='declined' 
                   && ContractUpdateMap.containsKey(envStatus.dfsle__SourceId__c) ){
                       System.debug('Inside Decline Status');
                       
                       ContractUpdateMap.get(envStatus.dfsle__SourceId__c).ASC_Signature_Status__c='Declined';
                       if(ContractUpdateMap.get(envStatus.dfsle__SourceId__c).Status=='Accepted'){
                           ContractUpdateMap.get(envStatus.dfsle__SourceId__c).Status ='Presented';
                       }                
                       
                       System.debug(ContractUpdateMap.get(envStatus.dfsle__SourceId__c).ASC_Signature_Status__c);
                   }
                
                
                if(envStatus.dfsle__SourceId__c!=NULL && envStatus.dfsle__Status__c=='Completed' && ContractUpdateMap.containsKey(envStatus.dfsle__SourceId__c)){
                    Map<Id,Contract> mapContractsPosting = new Map<Id,Contract>();
                    
                    ContractUpdateMap.get(envStatus.dfsle__SourceId__c).ASC_Signature_Status__c='Posting to CM';
                    
                    for( Contract con : ContractUpdateMap.values() ){
                        if( con.ASC_Signature_Status__c == 'Posting to CM' ){
                            mapContractsPosting.put( con.id, con );
                        }
                    }
                    
                    if( mapContractsPosting.size() > 0 ){
                        ASC_DocStarSubmitAPI.sentDocuments( mapContractsPosting );
                    }                
                }
                if(envStatus.dfsle__SourceId__c!=NULL && envStatus.dfsle__Status__c=='Voided' 
                   && ContractUpdateMap.containsKey(envStatus.dfsle__SourceId__c) ){                                                                                          
                       //ContractUpdateMap.get(envStatus.dfsle__SourceId__c).ASC_Signature_Status__c='Voided';
                       if(ContractUpdateMap.get(envStatus.dfsle__SourceId__c).Status=='Accepted'){
                           ContractUpdateMap.get(envStatus.dfsle__SourceId__c).Status ='Presented';
                       }                                       
                       System.debug(ContractUpdateMap.get(envStatus.dfsle__SourceId__c).ASC_Signature_Status__c);
                }
            } 
            
            //System.debug('@@@@@@values of status' +ContractUpdateMap);   
            if(!ContractUpdateMap.isEmpty()) database.update(ContractUpdateMap.values(),false);
        } 
        
        catch(Exception e){  GA_LogExceptionCls.LogExcp(e, 'EnvelopeStatusTrigger_Handler', 'AfterInsertOperationHandler');
                          }  
    }
    
    @future 
    public static void UpdateContractStatusToVoid(set<id> EnvelopeStatusIds){
        system.debug('UpdateContractStatusToVoid method Start....');
        map<id,Contract> ContractUpdateMap=new map<id,Contract>();
        for(dfsle__EnvelopeStatus__c envStatus: [SELECT id,dfsle__SourceId__c,dfsle__Status__c 
						FROM dfsle__EnvelopeStatus__c WHERE dfsle__Status__c='Voided'
                        And id IN:EnvelopeStatusIds]){
            Contract con=new Contract(
                id=envStatus.dfsle__SourceId__c,
                ASC_Signature_Status__c= envStatus.dfsle__Status__c
            );
            ContractUpdateMap.put(con.id, Con);              
        }
        system.debug('ContractUpdateMap...'+ContractUpdateMap);
        if(!ContractUpdateMap.isEmpty()) database.update(ContractUpdateMap.values(),false);
        system.debug('UpdateContractStatusToVoid method End....');
    }
}