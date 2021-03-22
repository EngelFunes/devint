/*****************************************************************************************
Class Name   : GA_AP_FileUploadCls
Date Created : 01/10/2018
Created By   : IDC Offshore
Description  : 1. To Upload files
******************************************************************************************/
public class ARV_AP_FileUploadCls {
    public static final String wrkflow= 'ContentVersion';
    public static final String  filetype= 'GA_Type__c';
    public static final string fileErrMsg = 'Failed to upload files';
    public static final string ClsName  ='GA_AP_FileUploadCls';
    public static final string methodNmeUpdateFiletyp ='updateFileType';
    
    /**
@Description: FileTypeValues() method 
@Name : FileTypeValues
@Param : NA
@Return : List<String>
@throws Exception : NA;
*/   
    @AuraEnabled
    public static List<String> FileTypeValues()
    {
        sObject sObj = Schema.getGlobalDescribe().get(wrkflow).newSObject() ; 
        List<String> fileTypeVals = GA_AP06_fetchPicklistValues.getselectOptions(sObj, filetype);
        return fileTypeVals;
    }
    /**
@Description: updateFileType() method 
@Name : updateFileType
@Param : string docIdLst,string fileTypeVal
@Return : None
@throws Exception : NA;
*/      
    @AuraEnabled
    public static void updateFileType(string docIdLst,string fileTypeVal)
    {
        try{
            
            system.debug('docIdLst->'+docIdLst);
            set<id> docIds=new set<id>();
            List<docWrapCls> DocmntsLst = (List<docWrapCls>)JSON.deserialize(docIdLst, List<docWrapCls>.class);
            for(docWrapCls doc:DocmntsLst)
            {
                docIds.add(doc.documentId);
            }
            list<contentversion> cntvLst=[select id,GA_Type__c from contentversion where ContentDocumentId in:docIds];
            list<contentversion> cntvLstToUpdt=new list<contentversion>();
            
            
            for(contentversion cntv:cntvLst)
            {
                cntv.GA_Type__c=fileTypeVal;
                cntvLstToUpdt.add(cntv);
            }
            
            database.update(cntvLstToUpdt);
        }
        catch(Exception e){
            GA_LogExceptionCls.LogExcp(e, ClsName, methodNmeUpdateFiletyp);
            throw new AuraHandledException(fileErrMsg);
        }
    }
    
    /**
@Description: fileLstRecs() method 
@Name : fileLstRecs
@Param : string suppId
@Return :list<contentversion>
@throws Exception : NA;
*/      
    public class docWrapCls{
        string name;
        string documentId;
    }
    @AuraEnabled
    public static list<contentversion> fileLstRecs(string suppId)
    {
       
            list<ContentDocumentLink> cntDocLnkLst=[SELECT ContentDocumentId FROM ContentDocumentLink where LinkedEntityId=:suppId];
            set<id> CntDocIdSet=new set<id>();
            for(ContentDocumentLink cntDoclnk:cntDocLnkLst)
            {
                CntDocIdSet.add(cntDoclnk.ContentDocumentId);  
            }
            
        list<contentversion> cntVrsionLst=[select id,GA_Type__c,title,ContentDocument.createdDate,ContentDocumentId from contentversion where ContentDocumentId in:CntDocIdSet order by createddate asc limit 100];
        
        Map<Id,contentversion> cntVerDocMap = New Map<Id,contentversion>();
        
        for(contentversion cntVrsion : cntVrsionLst){
            cntVerDocMap.put(cntVrsion.ContentDocumentId,cntVrsion); 
        }
        
        List<contentversion> newcntVrsionLst = New List<contentversion> ();
        for(contentversion ctntVer : cntVerDocMap.values()){
            newcntVrsionLst.add(ctntVer);
        }
        return newcntVrsionLst;
    
    }

    /**
@Description: getCaseNumbr() method 
@Name : getCaseNumbr
@Param : string suppId
@Return : string
@throws Exception : NA;
*/       
    @AuraEnabled
    public static string getCaseNumbr(string suppId){
        case cs=[select caseNumber from case where id=:suppId];
        return cs.caseNumber;
    }
    
}