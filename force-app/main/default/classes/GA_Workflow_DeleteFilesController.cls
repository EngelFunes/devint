/**
@Author : IDC Offshore
@Name: GA_Workflow_DeleteFilesController
@CreatedDate: 29 - July 2019
@Description: GA_Workflow_DeleteFilesController class is for mass delete  of Workflow files.
@version : 1.0  
*/ 
public class GA_Workflow_DeleteFilesController {

   
    public static final string CLSNAME='GA_GS_MassUpdateController';
    public static final string METHODNAMEST='gSgmtLst';
    public static final string CASEERRMSG='Unable to fetch Support Requests';
    public static final string METHODPROCESSG='processSelectedRecords';
    public static final string PROCESSINGERRORMSG='Unable to process';
    public static final string SMARTSTR = 'Canceled';
    public static final string INSUFFPRV = 'Insufficient privilege';
    public static final string NOFIL = 'No files';
    public static final string NOFILES =  'No files available';
    //public static final string whereId =  '  where  id =';
    public static final string CURRENTUSR = 'Current User';
    public static final string CURRENTTIME = 'Current Time';
    public static final string SUPPORTRQNUM = 'Workflow Name';
    public static final string SYSTEMCRT = 'System Created';
    public static final string INSUFFPRV1 = 'Canceled Workflow';
    public static final String WFLWID=system.label.GA_Workflow_RecordId;
    
    /**
@Description: caseLst() method 
@Name : caseLst
@Param : string accId, string currentId  
@Return : List
@throws Exception : N/A;
*/   
    @AuraEnabled     
    public static List<fileWrapper> workFlowLst(string currentId) {
        List<fileWrapper> gSWrperLst =  New List<fileWrapper> ();
        try{
            String rleName = '';
            list<User> curntUsr=[select id, Profile.Name, GA_RoleName__c from user where id=:userInfo.getUserId() Limit 1];
            if(curntUsr.size()>0)
            {
                rleName =curntUsr[0].GA_RoleName__c;
            }
            
            if(((system.label.GA_WrkFlwAllowDelProfiles.contains(curntUsr[0].Profile.Name)) || (system.label.GA_WrkAllowDelRoles.contains(rleName)))){
                String workflowStatus = [Select Id,GA_Status__c from GA_WF_Workflow__c where id= :currentId Limit 1].GA_Status__c ;
                if(workflowStatus == SMARTSTR){
                    fileWrapper obj = new fileWrapper();
                    obj.fileDocId = INSUFFPRV1;
                    
                    //List<fileWrapper> wrplst =  New List<fileWrapper> ();
                    gSWrperLst.add(obj);
                    return gSWrperLst;   
                }else{
                set<id> cntDocIdSet=new set<id>();
                for(ContentDocumentLink cntDoclnk:[SELECT ContentDocumentId FROM ContentDocumentLink where LinkedEntityId=:currentId Limit 50])
                {
                    if(cntDoclnk.ContentDocumentId <> null){
                          cntDocIdSet.add(cntDoclnk.ContentDocumentId);  
                   }
                }
                list<contentversion> cntVrsionLst=[select id,GA_Type__c,GA_Deletion_Notes__c,title,ContentDocument.createdDate,ContentDocumentId from contentversion where ContentDocumentId in:cntDocIdSet order by createddate asc limit 100];
                
                Map<Id,contentversion> cntVerDocMap = New Map<Id,contentversion>();
                
                for(contentversion cntVrsion : cntVrsionLst){
                    cntVerDocMap.put(cntVrsion.ContentDocumentId,cntVrsion); 
                }
                
                List<contentversion> newcntVrsionLst = New List<contentversion> ();
                for(contentversion ctntVer : cntVerDocMap.values()){
                    if(ctntVer<>null){
                    newcntVrsionLst.add(ctntVer);
                    }
                }              
                
                if( newcntVrsionLst.size() == 0){
                    fileWrapper obj = new fileWrapper();
                    obj.fileDocId = NOFILES;
                    
                    List<fileWrapper> wrplst =  New List<fileWrapper> ();
                    wrplst.add(obj);
                    return wrplst;  
                }
                  fileWrapper obj = new fileWrapper();
                
                for(contentversion cs : newcntVrsionLst){                    
                    obj = new fileWrapper();
                    obj.fileDocId = cs.id;
                    obj.filetype = cs.GA_Type__c;
                    obj.fileTitle = cs.title;
                    obj.isSelected = true;
                    obj.fileCreatedDate = cs.ContentDocument.createdDate;
                    gSWrperLst.add(obj);
                } 
                
                if(gSWrperLst.size() == 0){
                     obj = new fileWrapper();
                    obj.fileDocId = NOFIL;
                    gSWrperLst.add(obj);
                }
            }
            }
            
            else{
                fileWrapper obj = new fileWrapper();
                obj.fileDocId = INSUFFPRV;
                gSWrperLst.add(obj);
            }
            return gSWrperLst;  
        }
        catch(Exception e){
            GA_LogExceptionCls.LogExcp(e, CLSNAME, METHODNAMEST);
            throw new AuraHandledException(CASEERRMSG);
        }
    }
    /**
@Description: processSelectedRecords() method 
@Name : processSelectedRecords
@Param : string fileRecords,String currentCase  
@Return : N/A
@throws Exception : N/A;
*/     
    @AuraEnabled
    Public static void processSelectedRecords(string fileRecords,String currentCase){
        
        try{
            List<fileWrapper> fileList = new  List<fileWrapper>();
            List<Id> delContDocLst = New List<Id> ();
            
            if(!string.isBlank(fileRecords)){
                fileList = (List<fileWrapper>)System.JSON.deserialize(fileRecords,List<fileWrapper>.class);
                for(fileWrapper cw :fileList ){
                    
                    
                    delContDocLst.add(cw.fileDocId); 
                }
                list<contentversion> cntVrsionLst=[select id,GA_Type__c,OwnerId,GA_Deletion_Notes__c,title,ContentDocument.createdDate,ContentDocumentId from contentversion where Id in:delContDocLst order by createddate asc limit 100];
               
                string CustmLabel = Label.GA_WrkflowDeletionNotes;
                
                List<GA_WF_Workflow__c> SupNum = [select id,Name from GA_WF_Workflow__c where Id =:currentCase];
                List<user> SYSTEMCRTUsr = [Select id,Name from user where Name =:SYSTEMCRT];
                                
                List<Id> docLinkIds = new List<Id>();
                List<contentversion> UpdtCVLst = new List<contentversion>();
                
                for(contentversion cv : cntVrsionLst){
                    cv.GA_Deletion_Notes__c=CustmLabel.replace(CURRENTUSR, userInfo.getName()).replace(CURRENTTIME, system.Today().format()).replace(SUPPORTRQNUM, SupNum[0].Name);
                   // cv.OwnerId=SYSTEMCRTUsr[0].id;
                    docLinkIds.add(cv.ContentDocumentId);
                    UpdtCVLst.add(cv);
                }
                list<ContentDocumentLink> cntDcmtLst = [SELECT ContentDocumentId,sharetype,LinkedEntityId FROM ContentDocumentLink where ContentDocumentId in:docLinkIds ];
                
                list<ContentDocumentLink> delcntDcmtLst = New list<ContentDocumentLink> ();
                
                for(ContentDocumentLink cnttdc : cntDcmtLst){
                    
                    String  cntid = cnttdc.LinkedEntityId ;
                    if(cnttdc.sharetype  == 'V' && cntid.substring(0,3) == WFLWID)
                    {
                        delcntDcmtLst.add(cnttdc);                        
                    }
                }
                if(!UpdtCVLst.isEmpty()){
                    Database.update(UpdtCVLst);
                }
                if(!delcntDcmtLst.isEmpty()){
                    Database.delete(delcntDcmtLst, false);
                }
            }
        }
        catch(Exception e){
            GA_LogExceptionCls.LogExcp(e, CLSNAME, METHODPROCESSG);
            throw new AuraHandledException(PROCESSINGERRORMSG);
        }
    }
    /**
@Description: caseWrapper wrapper
@Name : caseWrapper
@Param : N/A 
@Return : N/A
@throws Exception : N/A;
*/    
    public without sharing class fileWrapper{
        @AuraEnabled
        public String fileDocId {get;set;}
        @AuraEnabled
        public String fileTitle {get;set;}
        @AuraEnabled
        public String filetype {get;set;}
        @AuraEnabled
        public boolean isSelected {get;set;}
        @AuraEnabled
        public Datetime fileCreatedDate {get;set;}
    }
}