trigger ARV_TR02_AttachmentTrigger on Attachment (after insert) {
if(trigger.isAfter && trigger.isInsert){
        ARV_AP80_AttachmentToFileHanlder fileObj = new ARV_AP80_AttachmentToFileHanlder();
        fileObj.covertAttachmentToFile(trigger.new);
    }

    /*List<dsfs__DocuSign_Status__c> docuStatusList = new List<dsfs__DocuSign_Status__c>();
    set<Id> docuStatusIdSet = new set<Id>();
    //set<Id> contractIdSet = new set<Id>();
    set<Id> updatedDocusignStatusIdSet = new set<Id>();
    Map<Id,Id> attachmentsparentIdMap = new Map<Id,Id> ();
    List<Attachment> filteredAttachmentsLst = new List<Attachment>();
    string sobjectName = 'dsfs__DocuSign_Status__c';
    ID parentIdObj;
    set<Id> attachIdSet = new set<Id>();
    
    Map<Id,Id> docuContractIdMap = new Map<Id,Id>();
    for (Attachment attach : trigger.new){
        docuStatusIdSet.add(attach.parentId);
        parentIdObj = attach.ParentId;
        attachIdSet.add(attach.Id);
    }    
    if (parentIdobj.getSobjectType().getDescribe().getName()==sobjectName)
    {
        docuStatusList = [select dsfs__Contract__c from dsfs__DocuSign_Status__c where id in:docuStatusIdSet and dsfs__Envelope_Status__c='Completed'];
        for (dsfs__DocuSign_Status__c dcstatus : docuStatusList)
        {            
            docuContractIdMap.put(dcstatus.Id, dcstatus.dsfs__Contract__c);
            updatedDocusignStatusIdSet.add(dcstatus.id);            
        }               
        system.debug('updatedDocusignStatusIdSet:'+updatedDocusignStatusIdSet);
        ARV_AP70_FileQueueableServices updateJob = new ARV_AP70_FileQueueableServices(attachIdSet,docuContractIdMap);
        Id jobID = System.enqueueJob(updateJob); // enqueue the job for processing        
    }*/
}