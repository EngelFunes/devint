/*****************************************************************************************
Class Name   : GA_CDLHelper
Date Created : 1/31/2018
Created By   : IDC Offshore
Description  : 1. This is the helper class to publish ContentDocument into another Library.

Change History : 
******************************************************************************************/
public without sharing class GA_CDLHelper {
    
    //Below are the final variables to check on the operation.
    public static boolean runOnce=false;
    public static final string SHRTYP = 'V';
    public static final string SHRTYPC = 'C';
    public static final string USRVSIBLTY = 'AllUsers';
    public static final string ERRORMSG = 'Unable to publish ContentDocument into another Library';
    public static final string INGPROF = 'Integration User';
    public static final String CLSNAME  ='GA_CDLHelper';
    public static final String METHODNME ='shareWithLibrary';
    public static final String OBJID='500';
    public static final String BLNK='';
    public static final String WFLWID=system.label.GA_Workflow_RecordId;
    
    /**
@Description: ValidateException() method 
@Name : ValidateException
@Param : None
@Return : void
@throws Exception : N/A;
*/    
    public with sharing class ValidateException extends Exception {}
    /**
@Description: Helper method to publish ContentDocument into another Library.
@Name : shareWithLibrary
@Param : shareWithLibrary
@Return : void
@throws Exception : N/A;
*/
    public static void shareWithLibrary(list<ContentDocumentLink> cndtDocLinkLst) {    
        
        try{
            Id prId = null;
            ContentDocumentLink cdl = New ContentDocumentLink();
            set<id> cntDocIds=new set<id>();
            List<ContentDocumentLink> docList = New List<ContentDocumentLink>();
            Map<Id,User> managerByIdMap = new Map<Id,User>();
            for(Profile P : [select id from Profile where Name =: INGPROF Limit 1]){
                prId = P.id;
            }
            // list<CollaborationGroup> grpLst=[select id from CollaborationGroup where name=:GrpNam limit 1];
            map<id,set<id>> cntDocOwnrIdMap =new map<id,set<id>>();
            set<id> owneridSet = New Set<Id>();
            boolean caseFile=false;
            boolean workflowFile=false;
            String mngrId = BLNK;
            for(ContentDocumentLink cdlRec:cndtDocLinkLst)
            {               
                cntDocIds.add(cdlRec.ContentDocumentId); 
                if(String.valueOf(cdlRec.LinkedEntityId).startsWith(OBJID))
                {
                    caseFile=true;
                }
                if(String.valueOf(cdlRec.LinkedEntityId).startsWith(WFLWID))
                {
                    workflowFile=true;
                }
                
            }
            
            // list<ContentDocumentLink> cntdocLinkLst=[select id,ContentDocumentId,LinkedEntityId from ContentDocumentLink where ContentDocumentId in:cntDocIds limit 50];
            for(ContentDocumentLink cdlRec:[select id,ContentDocumentId,LinkedEntityId from ContentDocumentLink where ContentDocumentId in:cntDocIds limit 50])
            {
                
                if(cntDocOwnrIdMap.get(cdlRec.ContentDocumentId) !=null)
                {
                    owneridSet=cntDocOwnrIdMap.get(cdlRec.ContentDocumentId);
                }
                else
                {
                    owneridSet=new set<id>();
                }
                owneridSet.add(cdlRec.LinkedEntityId);
                
                cntDocOwnrIdMap.put(cdlRec.ContentDocumentId, owneridSet);
            }
             /** 
            for(User u : [Select id, UserPreferencesDisableAllFeedsEmail from user Where Profileid =: prId and isactive=true Limit 100]){
                if(u.Id !=userinfo.getUserId())
                {
                    u.UserPreferencesDisableAllFeedsEmail = true;
                    managerByIdMap.put(u.Id,u);
                    //docList.addall(prepareDocList(cntDocOwnrIdMap,u.Id,SHRTYP));
                }
            }
           if(grpLst.size()>0) {
docList.addall(prepareDocList(cntDocOwnrIdMap,grpLst[0].id,shrTyp));
}   **/
            /*if(caseFile)
            {          
                List<User> mList = [Select Id,ManagerId, Manager.UserPreferencesDisableAllFeedsEmail  from user where id =: UserInfo.getUserId() and manager.isActive=true Limit 1];
                if(!mList.isEmpty()){
                    mngrId=mList[0].ManagerId;
                    
                    //Disable the email functionality for manager and put it into map for DML operation
                   // mList[0].Manager.UserPreferencesDisableAllFeedsEmail = true;
                   // managerByIdMap.put(mList[0].Id,mList[0].Manager);
                    //End
                }
                if(!String.isEmpty(mngrId)){
                    //docList.addall(prepareDocList(cntDocOwnrIdMap,mngrId,SHRTYPC));
                }  
                
            }
            if(workflowFile)
            {
                String ownerId=UserInfo.getUserId();
                List<User> adminList = [Select Id, UserPreferencesDisableAllFeedsEmail from user where  GA_RoleName__c IN ('Group Admin Manager','GA Team Leader','West Michigan Support Manager','Support Manager') AND IsActive=TRUE];
                if(!adminList.isEmpty()){
                    for(integer i=0;i<adminList.size();i++)
                    {
                        mngrId=adminList[i].Id;
                        if(!String.isEmpty(mngrId) && ownerId == mngrId){
                          docList.addall(prepareDocList(cntDocOwnrIdMap,mngrId,SHRTYPC));
                        }
                    }                    
                }

                //Disable the email functionality for managers and put it into map for DML operation
                /*for(User admin : adminList){
                    admin.UserPreferencesDisableAllFeedsEmail = true;
                    managerByIdMap.put(admin.Id,admin);
                }
                //End
            }*/
            if(managerByIdMap.size() > 0){
                update managerByIdMap.values();
            }
            if(!docList.isEmpty()){
                Database.insert(docList);
            }
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, CLSNAME, METHODNME);
            throw new ValidateException(ERRORMSG, e);
        }
    }
    /**
@Description: prepareDocList() method
@Name : prepareDocList
@Param : map<id,set<id>> cntDocOwnrIdMap,string entityIdVal,String shrTyp
@Return : List
@throws Exception : N/A;
*/
   /* private static list<ContentDocumentLink> prepareDocList(map<id,set<id>> cntDocOwnrIdMap,string entityIdVal,String shrTyp)
    {
        List<ContentDocumentLink> docListTmp = New List<ContentDocumentLink>();
        ContentDocumentLink cdl = New ContentDocumentLink();
        for(id cntDocId:cntDocOwnrIdMap.keyset())
       {
           
            if(!cntDocOwnrIdMap.get(cntDocId).contains(entityIdVal))
            {
                cdl = new ContentDocumentLink();
                cdl.ContentDocumentId = cntDocId;
                cdl.LinkedEntityId = entityIdVal;
                cdl.ShareType = shrTyp;
                cdl.Visibility = USRVSIBLTY; 
                docListTmp.add(cdl);  
            }
        }
        return docListTmp;
    } */  
    
    
}