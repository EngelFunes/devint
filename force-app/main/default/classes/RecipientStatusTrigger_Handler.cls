Public class RecipientStatusTrigger_Handler{
	
	public static void AfterInsertOperationHandler(list<dfsle__RecipientStatus__c> RecipientStatusList, map<id,dfsle__RecipientStatus__c> trigger_oldValues){
		set<id> recStatusSourceContractId=new set<id>();
		for(dfsle__RecipientStatus__c recStatus: RecipientStatusList){
			if(recStatus.dfsle__SourceId__c!=NULL && recStatus.SourceContractID__c!=NULL && 
			recStatus.dfsle__Status__c=='sent' && 
			(trigger_oldValues==NULL || (trigger_oldValues!=NULL && recStatus.dfsle__Status__c!=trigger_oldValues.get(recStatus.id).dfsle__Status__c))) 
				recStatusSourceContractId.add(recStatus.SourceContractID__c);
		}
		system.debug('recStatusSourceContractId..***..'+recStatusSourceContractId);
		map<id,Contract> ContractUpdateMap=new map<id,Contract>();
		// map<contractID,map<DocuSignParticipant Email,DocuSign_Participant__c>>
		map<id,map<string,DocuSign_Participant__c>> DocuSignParticipant_Map=new map<id,map<string,DocuSign_Participant__c>>();
		for(Contract con:[SELECT ID,ASC_Signature_Status__c,
						(SELECT ID,Recipient_Email__c,RecordType.DeveloperName FROM DocuSign_Participants__r) 
						FROM Contract WHERE ID IN:recStatusSourceContractId]){
			ContractUpdateMap.put(con.id,con);			
			//loop through the related docusign participants records
			map<string,DocuSign_Participant__c> DocuSignParticipantInnerMap =new map<string,DocuSign_Participant__c>();
			for(DocuSign_Participant__c dp: con.DocuSign_Participants__r){
				DocuSignParticipantInnerMap.put(dp.Recipient_Email__c,dp);
			}
			if(DocuSignParticipantInnerMap.size()>0){
				DocuSignParticipant_Map.put(con.id, DocuSignParticipantInnerMap);
			}
		}
        system.Debug('ContractUpdateMap..***..'+ContractUpdateMap);
		system.debug('DocuSignParticipant_Map.***..'+DocuSignParticipant_Map);
        
		//create a map to maintain the singnature status value mapping with record type name
		map<string,string> SignatureStatus_RecordTypeName_Map=new map<string,string>();
		SignatureStatus_RecordTypeName_Map.put('Group_Signer','Group');        
		SignatureStatus_RecordTypeName_Map.put('Segment_Owner','VP');
        System.debug('***SignatureStatusSegmentOwner****'+SignatureStatus_RecordTypeName_Map);
		
		for(dfsle__RecipientStatus__c recStatus: RecipientStatusList){
			system.debug('recStatus....'+recStatus);
            if(recStatus.dfsle__SourceId__c!=NULL && recStatus.SourceContractID__c!=NULL && recStatus.dfsle__Status__c=='sent' && 
				DocuSignParticipant_Map.containsKey(recStatus.SourceContractID__c) && 
				DocuSignParticipant_Map.get(recStatus.SourceContractID__c).containsKey(recStatus.dfsle__Email__c)){
				string docPartRecordTypeName = DocuSignParticipant_Map.get(recStatus.SourceContractID__c).get(recStatus.dfsle__Email__c).RecordType.DeveloperName;
				system.debug('docPartRecordTypeName.***...'+docPartRecordTypeName);
                if(SignatureStatus_RecordTypeName_Map.containsKey(docPartRecordTypeName)){
					ContractUpdateMap.get(recStatus.SourceContractID__c).ASC_Signature_Status__c= SignatureStatus_RecordTypeName_Map.get(docPartRecordTypeName);
				}							
			}
		}			
		if(!ContractUpdateMap.isEmpty()) database.update(ContractUpdateMap.values(),false);
	}	
}