/**
@Author : IDC Offshore
@Name: GA_CAS_DeleteFilesController
@CreatedDate: 02 - April 2019
@Description: GA_CAS_DeleteFilesController class is for mass delete  of case files.
@version : 1.0  
*/ 
public without Sharing class GA_CAS_DeleteFilesController {
    public static final string casQuery='select id, caseNumber, GA_Quote_ID__c, AccountId,status,GA_System_of_Record__c from Case ';
    public static final string casWhere='where AccountId in'; 
    public static final string casWhere2=' and id !=';
    public static final string casWhere3=' and Status !=';
    public static final string casWhere4=' and recordtypeid =';
    public static final Id WmSupportReqId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Support - Support / West Michigan').getRecordTypeId();
    public static final string casStatus='Closed';
    public static final string casOrdrBy='order by createddate desc';
    public static final string casLstLimit=' Limit 800';
    public static final string casLstLimit1=' Limit 1';
    public static final string ClsName='GA_GS_MassUpdateController';
    public static final string methodNmeLst='gSgmtLst';
    public static final string casErrMsg='Unable to fetch Support Requests';
    public static final string methodPrcsng='processSelectedRecords';
    public static final string PrcsngErrMsg='Unable to process';
    public static final string smartStr = 'SMART';
    public static final string insuffPrv = 'Insufficient privilege';
    public static final string NoFil = 'No files';
    public static final string Nofiles =  'No files available';
    public static final string whereId =  '  where  id =';
    public static final string CurrentUsr = 'Current User';
    public static final string CurrentTime = 'Current Time';
    public static final string SupRqNum = 'Case Number';
    public static final string SytmCrtd = 'System Created';
    
    /**
@Description: caseLst() method 
@Name : caseLst
@Param : string accId, string currentId  
@Return : List
@throws Exception : N/A;
*/   
    @AuraEnabled     
    public static List<fileWrapper> caseLst(string accId, string currentId) {
        List<fileWrapper> gSWrperLst =  New List<fileWrapper> ();
        
        try{
            String RleName = '';
            list<User> curntUsr=[select id, Profile.Name, GA_RoleName__c from user where id=:userInfo.getUserId()];
            if(curntUsr.size()>0)
            {
                RleName =curntUsr[0].GA_RoleName__c;
            }
            
            if(((system.label.GA_CaseAllowDelProfiles.contains(curntUsr[0].Profile.Name)) || (system.label.GA_CaseAllowDelRoles.contains(RleName)))){
                
                String caseSystOfRec = [Select GA_System_of_Record__c from case where id= :currentId ].GA_System_of_Record__c;
                list<ContentDocumentLink> cntDocLnkLst=[SELECT ContentDocumentId FROM ContentDocumentLink where LinkedEntityId=:currentId];
                set<id> CntDocIdSet=new set<id>();
                for(ContentDocumentLink cntDoclnk:cntDocLnkLst)
                {
                    CntDocIdSet.add(cntDoclnk.ContentDocumentId);  
                }
                list<contentversion> cntVrsionLst=[select id,GA_Type__c,GA_Deletion_Notes__c,title,ContentDocument.createdDate,ContentDocumentId from contentversion where ContentDocumentId in:CntDocIdSet order by createddate asc limit 100];
                
                Map<Id,contentversion> cntVerDocMap = New Map<Id,contentversion>();
                
                for(contentversion cntVrsion : cntVrsionLst){
                    cntVerDocMap.put(cntVrsion.ContentDocumentId,cntVrsion); 
                }
                
                List<contentversion> newcntVrsionLst = New List<contentversion> ();
                for(contentversion ctntVer : cntVerDocMap.values()){
                    newcntVrsionLst.add(ctntVer);
                }
                
                if(caseSystOfRec == smartStr){
                    fileWrapper obj = new fileWrapper();
                    obj.fileDocId = insuffPrv;
                    
                    List<fileWrapper> Wrplst =  New List<fileWrapper> ();
                    Wrplst.add(obj);
                    return Wrplst;   
                }
                
                if( newcntVrsionLst.size() == 0){
                    fileWrapper obj = new fileWrapper();
                    obj.fileDocId = Nofiles;
                    
                    List<fileWrapper> Wrplst =  New List<fileWrapper> ();
                    Wrplst.add(obj);
                    return Wrplst;  
                }
                
                
                for(contentversion cs : newcntVrsionLst){
                    
                    fileWrapper obj = new fileWrapper();
                    obj.fileDocId = cs.id;
                    obj.filetype = cs.GA_Type__c;
                    obj.fileTitle = cs.title;
                    obj.isSelected = true;
                    obj.fileCreatedDate = cs.ContentDocument.createdDate;
                    gSWrperLst.add(obj);
                } 
                
                if(gSWrperLst.size() == 0){
                    fileWrapper obj = new fileWrapper();
                    obj.fileDocId = NoFil;
                    gSWrperLst.add(obj);
                }
            }
            
            else{
                fileWrapper obj = new fileWrapper();
                obj.fileDocId = insuffPrv;
                gSWrperLst.add(obj);
            }
            return gSWrperLst;  
        }
        catch(Exception e){
            GA_LogExceptionCls.LogExcp(e, ClsName, methodNmeLst);
            throw new AuraHandledException(casErrMsg);
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
               
                string CustmLabel = Label.GA_DeletionNotes;
                
                List<Case> SupNum = [select id,CaseNumber from case where Id =:currentCase];
                List<user> SytmCrtdUsr = [Select id,Name from user where Name =:SytmCrtd];
                
                List<Id> docLinkIds = new List<Id>();
                List<contentversion> UpdtCVLst = new List<contentversion>();
                
                for(contentversion cv : cntVrsionLst){
                    cv.GA_Deletion_Notes__c=CustmLabel.replace(CurrentUsr, userInfo.getName()).replace(CurrentTime, system.Today().format()).replace(SupRqNum, SupNum[0].CaseNumber);
                    cv.OwnerId=SytmCrtdUsr[0].id;
                    docLinkIds.add(cv.ContentDocumentId);
                    UpdtCVLst.add(cv);
                }
                system.debug('docLinkIds...'+docLinkIds);
                
                list<ContentDocumentLink> cntDcmtLst = [SELECT ContentDocumentId,sharetype,LinkedEntityId FROM ContentDocumentLink where ContentDocumentId in:docLinkIds ];
                
                list<ContentDocumentLink> delcntDcmtLst = New list<ContentDocumentLink> ();
                
                for(ContentDocumentLink cnttdc : cntDcmtLst){
                    
                    String  cntid = cnttdc.LinkedEntityId ;
                    if(cnttdc.sharetype  == 'V' && cntid.substring(0,3) == '500' )
                    {
                        delcntDcmtLst.add(cnttdc);
                        
                    }
                }
                
                system.debug('delcntDcmtLst...'+delcntDcmtLst);
                
                if(!UpdtCVLst.isEmpty()){
                    Database.update(UpdtCVLst);
                }
                
                if(!delcntDcmtLst.isEmpty()){
                    Database.delete(delcntDcmtLst, false);
                }
            }
        }
        catch(Exception e){
            GA_LogExceptionCls.LogExcp(e, ClsName, methodPrcsng);
            throw new AuraHandledException(PrcsngErrMsg);
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