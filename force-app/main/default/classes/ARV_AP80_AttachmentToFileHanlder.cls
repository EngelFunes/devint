/*****************************************************************************************
Class Name   : ARV_AP80_AttachmentToFileHanlder
Date Created : 19-Jan-2020
Created By   : IDC Offshore
Description  : This  class is called from ARV_TR02AttachmentTrigger to insert files of  attachments from docusign staus object into contract object.
******************************************************************************************/
public class ARV_AP80_AttachmentToFileHanlder{
    private static final string COMPLETED='Completed';
    private static final string SOBJ_NAME='dsfs__DocuSign_Status__c';
/*****************************************************************************************
Method Name   : covertAttachmentToFile
Date Created : 19-Jan-2020
Created By   : IDC Offshore
Description  : This method fetches attachments of docusign to convert them into files.
******************************************************************************************/
    public void covertAttachmentToFile(List<attachment> newlist){
        List<dsfs__DocuSign_Status__c> docuStatusList = new List<dsfs__DocuSign_Status__c>();
        set<Id> docuStatusIdSet = new set<Id>();             
        map<Id,attachment> parentAttachMap = new map<Id,attachment>();    
        set<Id> finalAttachSet = new set<Id>(); 
        Map<Id,Id> docuContractIdMap = new Map<Id,Id>();
        for (Attachment attach : newlist){
            parentAttachMap.put(attach.parentId,attach);   
        }
        System.debug(':::: parentAttachMap.keyset:::'+parentAttachMap.keySet());
        for(Id pId:parentAttachMap.keySet()){
            if (pId.getSobjectType().getDescribe().getName()==SOBJ_NAME){
                finalAttachSet.add(parentAttachMap.get(pId).Id);
                docuStatusIdSet.add(pId);
            }
        }
        //System.debug(':::parentAttachMap.keySet().getSobjectType().getDescribe().getName():::'+
                    //parentAttachMap.keySet().getSobjectType().getDescribe().getName());
        
        if(!docuStatusIdSet.isEmpty() && !finalAttachSet.isEmpty()){
            docuStatusList = [select dsfs__Contract__c from dsfs__DocuSign_Status__c where id in:docuStatusIdSet and dsfs__Envelope_Status__c=:COMPLETED];
            for(dsfs__DocuSign_Status__c docuStatus: docuStatusList){               
                docuContractIdMap.put(docuStatus.Id, docuStatus.dsfs__Contract__c);
            }
            ARV_AP79_FileQueueableServices updateJob = new ARV_AP79_FileQueueableServices(finalAttachSet,docuContractIdMap);
            Id jobID = System.enqueueJob(updateJob); // enqueue the job for processing       
        }
    }
}