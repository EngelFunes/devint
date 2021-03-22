/*****************************************************************************************
Class Name   : ARV_AP78_AttachToFileQueubleClass 
Date Created : 29-Jan-2020
Created By   : IDC Offshore
Description  : This  class is called from ARV_AP79_FileQueueableServices to Convert docusign attachemnts into files for contract.
******************************************************************************************/
public class ARV_AP78_AttachToFileQueubleClass {
    private static final String CONTENTLOCTION='S';
    private static final String CONTENTORIGIN='C';
    private static final String SHARETYPE='V';
    private static final String VISIBILITY='AllUsers';
    private static final String ANDAMPER ='&amp;';
    private static final String AMPERSAND ='&';
    private static final String DOT ='.';
    private static final String PEDIATRIC ='Pediatric';
    private static final String MLR ='Medical Loss Ratio';
    private static final String COVAGREMENT ='Coverage Agreement';
    private static final String DENTAL_ATTEST ='Dental Attestation';
    private static final String MLR_FORM='Medical Loss Ratio Reporting & Enrollment Attestation Form';
    private static final String ESIGN_FORM='Group E-Sign Attestation';
    private static final String COVAGREMENT_FORM ='Agreements (MLR, Attestations, etc)';
    private static map<Id,Id> attachmentContractMap = new Map<Id,Id>();
    private static map<id,contentVersion> attachVersionMap = new Map<Id,contentVersion>(); 
/*****************************************************************************************
Method Name   : ARV_AP78_AttachToFileQueubleClass 
Date Created : 29-Jan-2020
Created By   : IDC Offshore
Description  : This  Method converts attahments into Content versions.
******************************************************************************************/ 
    public static void attachmentsConversion(set<Id> attachmetIdSet,Map<Id,Id> docuContractIdMap){
        Map<Id,Id> attachmentsParentIdMap = new Map<Id,Id>(); // Map for attachmentId, DocusignStatusId     
        List <Contentversion> contentversionLst = new List<Contentversion>(); //To insert Content version Records
        for (Attachment attach : [select id,Name,OwnerId,Body,ParentId from attachment where Id in:attachmetIdSet]){
            ContentVersion cVersion = new ContentVersion();
            cVersion.ContentLocation = CONTENTLOCTION;  //S-Document is in Salesforce. E-Document is outside of Salesforce.
            cVersion.PathOnClient = attach.Name;    //File name with extention
            cVersion.Origin = CONTENTORIGIN;        //C-Content Origin. H-Chatter Origin.
            cVersion.OwnerId = attach.OwnerId;  //Owner of the file
            cVersion.Title = attach.Name.substringBeforeLast(DOT).replace(ANDAMPER,AMPERSAND); //Name of the file
            cVersion.GA_Type__c = insertFileType(attach.Name);              
            cVersion.VersionData = attach.Body; //File content
            cVersion.NetworkId = Network.getNetworkId();    //Portal Community NetworkId          
            attachVersionMap.put(attach.Id,cVersion);
            attachmentsParentIdMap.put(attach.Id,attach.ParentId);
            contentversionLst.add(cVersion);
        }
        //system.debug('contentversionLst'+contentversionLst.size());        
        if (!contentversionLst.isEmpty()){
            Database.insert(contentversionLst);
        }
        for (Id attachKey : attachmentsParentIdMap.keyset()){
            if (docuContractIdMap.get(attachmentsParentIdMap.get(attachKey))!=null){
                attachmentContractMap.put(attachKey,docuContractIdMap.get(attachmentsParentIdMap.get(attachKey))); 
            }
        }
        insertContentDocumentLink();
       
    }
/*****************************************************************************************
Method Name   : Change File Names 
Date Created : 29-Jan-2020
Created By   : IDC Offshore
Description  : This  Method prepares File Type.
******************************************************************************************/ 
private static string insertFileType(String attachName ){
    String fileType=null;
    if(attachName.contains(PEDIATRIC)){
        fileType =DENTAL_ATTEST;
    }else if(attachName.contains(MLR)){
        fileType =MLR_FORM;
    }else if(attachName.contains(COVAGREMENT)){
        fileType=COVAGREMENT_FORM;
    }else if(attachName.contains(ESIGN_FORM)){
        fileType=ESIGN_FORM;    
    }else{fileType=null;}
    return fileType;
}
 /*****************************************************************************************
Method Name   : insertContentDocumentLink 
Date Created : 29-Jan-2020
Created By   : IDC Offshore
Description  : This  Method creates the Content documentsLink.
******************************************************************************************/    
    private static void insertContentDocumentLink(){
        Map<Id,Id> cVersionParentIdMap = new Map<Id,Id>();
        ContentDocumentLink cDocLink = null;
        contentversion contVersion = null;
        List<ContentDocumentLink> contnetDocList = new List<ContentDocumentLink>();              
        for (Id attachId : attachVersionMap.keyset()){
            if(attachmentContractMap.get(attachId) != null){
                contVersion = attachVersionMap.get(attachId);
                cVersionParentIdMap.put(contVersion.id,attachmentContractMap.get(attachId));
                                               
            }               
        }
       // system.debug('@@cVersionParentIdMap'+cVersionParentIdMap);        
        if(!cVersionParentIdMap.isEmpty()){
           //List<contentversion> cVersionUpdatedLst = [select id,ContentDocumentId from contentversion where Id in: cVersionParentIdMap.keyset()];
            //if (cVersionUpdatedLst.size()>0){
                for (contentversion cv : [select id,ContentDocumentId from contentversion where Id in: cVersionParentIdMap.keyset()]){
                    if (cVersionParentIdMap.get(cv.id)!=null){                    
                        cDocLink = new ContentDocumentLink();
                        cDocLink.ContentDocumentId = cv.ContentDocumentId;//Add ContentDocumentId
                        cDocLink.LinkedEntityId = cVersionParentIdMap.get(cv.id);
                        cDocLink.ShareType = SHARETYPE;//V - Viewer permission. C - Collaborator permission. I - Inferred permission.
                        cDocLink.Visibility = VISIBILITY;//AllUsers, InternalUsers, SharedUsers
                        contnetDocList.add(cDocLink);
                    }
                }
           // }
                 //  system.debug('@@contnetDocList'+contnetDocList);        

            if (!contnetDocList.isEmpty()){
                Database.insert(contnetDocList);
            }
        }
    }
}