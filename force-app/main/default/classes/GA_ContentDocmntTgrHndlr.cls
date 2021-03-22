/**
@Author : Prasant
@Name: GA_ContentDocmntTgrHndlr
@CreatedDate: 4 - May 2018 
@Description: GA_ContentDocmntTgrHndlr class is for edit, insert and delete operation of content documents.
@version : 1.0  
*/ 
public with sharing class GA_ContentDocmntTgrHndlr {
    //public static final GA_System_Admin_Bypass__c profBypass = GA_System_Admin_Bypass__c.getInstance();
    public static final GA_Files_ByPass__c fileBypass = GA_Files_ByPass__c.getInstance();
    public static final string targtObj = 'Case';
    public static final string targtObjWF = 'GA_WF_Workflow__c';
    public static final string objId = '500';
    public static final string deleteErrMsg = 'You do not have privileges to delete this file';
    public static final string editErrMsg = 'You do not have privileges to edit the details of this file';   
    public static final string insrtErrMsg = 'You do not have privileges to upload the file';
    public static final string wfInsrtErrMsg = 'You do not have privileges to perform this action. Please contact the System Administrator';
    Public Static final Id profileId=userinfo.getProfileId();
    Public Static final Id RoleId=userinfo.getUserRoleId();
    Public Static final String profileName=[Select Id,Name from Profile where Id=:profileId Limit 1].Name;
    //Public Static final String suppIssurRecTypNm='Support - Issues';
    Public Static final String suppIssurRecTypNm='GA_Support_Issues';
    Public Static final String suppMARecTypNm='Support - Medicare Advantage';
    Public Static final String MASalesProf='Medicare Advantage Sales';
    Public Static final String MASuppProf='Medicare Advantage Support';
    Public Static final String SUPPMNGRROLE='Support Manager';
    Public Static final String WMSUPPORTMNGRROLE='West Michigan Support Manager';
    Public Static final String GATEAMLEADROLE='GA Team Leader';
    Public Static final String GAMNGRROLE='Group Admin Manager';
    Public Static final String CLSDSUPPRECTYP='Support - Closed Support/West Michigan';
    Public Static final String GRPSUPPRECTYP='Support - Group Medicare Advantage';
    Public Static final String ASRWMRECTYPE=  'Support - Support / West Michigan';
    public static final string supReq = 'Support - Request';
    Public Static String RleName='';
    public static final string clsName  ='GA_ContentDocmntTgrHndlr';
    public static final string updateCntAttRecsMthd  ='updateCntAttRecs';
    public static final string restrictCaseFilesDeletionMthd  ='restrictCaseFilesDeletion';
    public static final string restrictCaseFilesEditMthd  ='restrictCaseFilesEdit';
    public static final string restrictCaseFilesInsertMthd ='restrictCaseFilesInsert';
    public static final String CLSD = 'Closed';
    Public Static final String BENEFITADMINLGRROLE='Benefit Admin LG';
    
    /**
@Description: updateCntAttRecs() method 
@Name : updateCntAttRecs
@Param : string accId, string currentIdlist<ContentDocument> cntDocLst  
@Return : void
@throws Exception : N/A;
*/       
    public static void updateCntAttRecs(list<ContentDocument> cntDocLst)
    {
        try{
            list<id> cntDocIds=new list<id>();
            list<ContentDocumentLink> cntdocLinkLsttoUpdate=new list<ContentDocumentLink>();
            for(ContentDocument cntDoc:cntDocLst)
            {
                if(cntDoc.id <> null){
                    cntDocIds.add(cntDoc.id);                    
                }
            }
            //list<ContentDocumentLink> cntdocLinkLst=;
            
            set<string> objSet=new set<string>();
            //  list<GA_Content_Attachment_Config__mdt> cntAtchConfigLst=[select id,GA_Object_API_Name__c from GA_Content_Attachment_Config__mdt limit 50];
            for(GA_Content_Attachment_Config__mdt cntAtchConfig:[select id,GA_Object_API_Name__c from GA_Content_Attachment_Config__mdt limit 50]){
                if(cntAtchConfig.GA_Object_API_Name__c <> null){
                    objSet.add(cntAtchConfig.GA_Object_API_Name__c);                    
                }
            }
            for(ContentDocumentLink cdlRec:[select id,ContentDocumentId,LinkedEntityId from ContentDocumentLink where ContentDocumentId in:cntDocIds limit 100])
            {
                String sObjName = cdlRec.LinkedEntityId.getSObjectType().getDescribe().getName();
                if(objSet.contains(sObjName))
                {
                    cntdocLinkLsttoUpdate.add(cdlRec);
                }
            }
            if(cntdocLinkLsttoUpdate.size()>0)
                database.update(cntdocLinkLsttoUpdate,false);
        }
        catch(Exception e)
        {
            GA_LogExceptionCls.LogExcp(e, clsName, updateCntAttRecsMthd);
        }
    }
    
    /**
@Description: restrictCaseFilesDeletion() method 
@Name : restrictCaseFilesDeletion
@Param : map<id,ContentDocument> cntDocOldMap  
@Return : void
@throws Exception : N/A;
*/     
    public static void restrictCaseFilesDeletion(map<id,ContentDocument> cntDocOldMap)
    {
        try{
            list<User> curntUsr=[select id, Profile.Name,GA_RoleName__c from user where id=:userInfo.getUserId() Limit 1];
            PermissionSetAssignment psA = new PermissionSetAssignment();
            psA=[SELECT Id, PermissionSet.Name, AssigneeId FROM PermissionSetAssignment WHERE AssigneeId =:userInfo.getUserId() and PermissionSet.Name='Underwriting_Support_Updates' limit 1];
            if(curntUsr.size()>0)
            {
                RleName =curntUsr[0].GA_RoleName__c;
            }
            if(!((system.label.GA_CaseAllowDelProfiles.contains(curntUsr[0].Profile.Name)) || (system.label.GA_CaseAllowDelRoles.contains(RleName)))) 
            {
                Set<id> cntDocIds=cntDocOldMap.keyset();
                for(ContentDocument a : cntDocOldMap.values()){
                    for(ContentDocumentLink cdlRec:[select id,ContentDocumentId,LinkedEntityId from ContentDocumentLink where ContentDocumentId in:cntDocIds limit 100])
                    {  
                        String sObjName = cdlRec.LinkedEntityId.getSObjectType().getDescribe().getName();
                        if(targtObj.equals(sObjName) && psA == NULL)
                        {
                            a.addError(deleteErrMsg); 
                        } 
                    }
                }
            }
            if(!((system.label.GA_WrkFlwAllowDelProfiles.contains(curntUsr[0].Profile.Name)) || (system.label.GA_WrkAllowDelRoles.contains(RleName))))  
            {
                Set<id> cntDocIds=cntDocOldMap.keyset();
                // list<ContentDocumentLink> cntdocLinkLst=;
                //String targtObjct = targtObjWF;
                for(ContentDocument a : cntDocOldMap.values()){
                    for(ContentDocumentLink cdlRec:[select id,ContentDocumentId,LinkedEntityId from ContentDocumentLink where ContentDocumentId in:cntDocIds limit 100])
                    {  
                        String sObjName = cdlRec.LinkedEntityId.getSObjectType().getDescribe().getName();
                        if(targtObjWF.equals(sObjName))
                        {
                            a.addError(deleteErrMsg);   
                        }
                    }
                }
            }             
            if(!((system.label.GA_CaseAllowDelProfiles.contains(curntUsr[0].Profile.Name))))  
            {
                Set<id> cntDocIds=cntDocOldMap.keyset();
                // list<ContentDocumentLink> cntdocLinkLst=;
                String targtObjct = targtObj;
                for(ContentDocument a : cntDocOldMap.values()){
                    for(ContentDocumentLink cdlRec:[select id,ContentDocumentId,LinkedEntityId from ContentDocumentLink where ContentDocumentId in:cntDocIds limit 100])
                    {   
                        String sObjName = cdlRec.LinkedEntityId.getSObjectType().getDescribe().getName();
                        if(targtObjWF.equals(sObjName) && !((system.label.GA_WrkFlwAllowDelProfiles.contains(curntUsr[0].Profile.Name)) || (system.label.GA_WrkAllowDelRoles.contains(RleName))))
                        {
                            a.addError(deleteErrMsg);   
                        }
                    }
                }
            }
        }
        catch(Exception e)
        {
            GA_LogExceptionCls.LogExcp(e, clsName, restrictCaseFilesDeletionMthd);
        }
    }
    /**
@Description: restrictCaseFilesEdit() method 
@Name : restrictCaseFilesEdit
@Param : List<ContentDocument> cntDocNewList  
@Return : void
@throws Exception : N/A;
*/ 
    public static void restrictCaseFilesEdit(List<ContentDocument> cntDocNewList)
        
    {   
        try{
            list<User> curntUsr=[select id,GA_RoleName__c,Profile.Name from user where id=:userInfo.getUserId() Limit 1];
            PermissionSetAssignment psA = new PermissionSetAssignment();
            psA=[SELECT Id, PermissionSet.Name, AssigneeId FROM PermissionSetAssignment WHERE AssigneeId =:userInfo.getUserId() and PermissionSet.Name='Underwriting_Support_Updates' limit 1];
            if(curntUsr.size()>0)
            {
                RleName =curntUsr[0].GA_RoleName__c;
            }    
            
            if(!((system.label.GA_CaseAllowDelProfiles.contains(curntUsr[0].Profile.Name)) || (system.label.GA_CaseAllowDelRoles.contains(RleName))) || (psA != null))  // if(!profBypass.GA_By_Pass__c)
            {
                Set<Id> docIds = new Set<Id>();
                for(ContentDocument obj : cntDocNewList){
                    if(obj.Id <> null){
                        docIds.add(obj.Id);                        
                    }
                }                 
                // list<ContentDocumentLink> cntdocLinkLst=;
                String targtObjct = targtObj;
                //Id issuesRecTpeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(suppIssurRecTypNm).getRecordTypeId();
                Id issuesRecTpeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get(suppIssurRecTypNm).getRecordTypeId();
                Id groupRecTpeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(GRPSUPPRECTYP).getRecordTypeId(); // newly added
                Id MARecTpeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(suppMARecTypNm).getRecordTypeId();
                Id supportReqRecTpeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(supReq).getRecordTypeId();
                Id asrReqRecTpeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(ASRWMRECTYPE).getRecordTypeId();
                Id closdSuppReqRecTpeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(CLSDSUPPRECTYP).getRecordTypeId();
                
                user CurrUsr=[select id,profile.Name,GA_RoleName__c from user where id=:userInfo.getUserId() Limit 1];
                for(ContentDocument a :  cntDocNewList){
                    for(ContentDocumentLink cdlRec:[select id,ContentDocumentId,LinkedEntityId,LinkedEntity.recordtypeId from ContentDocumentLink where ContentDocumentId in: docIds limit 100])
                    {   
                        
                        String sObjName = cdlRec.LinkedEntityId.getSObjectType().getDescribe().getName();
                        if(targtObjct.equals(sObjName))
                        {
                            if(!((cdlRec.LinkedEntity.recordtypeId ==issuesRecTpeId) ||
                                 (cdlRec.LinkedEntity.recordtypeId ==asrReqRecTpeId) || (cdlRec.LinkedEntity.recordtypeId ==groupRecTpeId) || // Newly added
                                 ((CurrUsr.profile.Name==BENEFITADMINLGRROLE )  && cdlRec.LinkedEntity.recordtypeId == supportReqRecTpeId) ||
                                 ((CurrUsr.profile.Name==MASalesProf || CurrUsr.profile.Name==MASuppProf)  && cdlRec.LinkedEntity.recordtypeId == MARecTpeId) ||
                                 ((CurrUsr.GA_RoleName__c == SUPPMNGRROLE || CurrUsr.GA_RoleName__c == WMSUPPORTMNGRROLE)  && cdlRec.LinkedEntity.recordtypeId ==closdSuppReqRecTpeId)))
                                a.addError(editErrMsg); 
                            
                        }
                    }
                }
            }
        }
        catch(Exception e)
        {
            GA_LogExceptionCls.LogExcp(e, clsName, restrictCaseFilesEditMthd);
        }
    }
    /**
@Description: restrictCaseFilesInsert() method 
@Name : restrictCaseFilesInsert
@Param : List<ContentDocument> cntDocNewList  
@Return : void
@throws Exception : N/A;
*/    
    public static void restrictCaseFilesInsert(List<ContentDocumentLink> cntDocNewList)
        
    {   
        try{ 
            Set<Id> docmntIds = new Set<Id>();
            id cntId;
            list<string> csIds=new list<string>();
            list<string> wfIds=new list<string>();
            user currUsr=[select id,profile.Name,GA_RoleName__c from user where id=:userInfo.getUserId() Limit 1];
            //Id issuesRecTpeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(suppIssurRecTypNm).getRecordTypeId();
            Id issuesRecTpeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get(suppIssurRecTypNm).getRecordTypeId();
            Id MARecTpeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(suppMARecTypNm).getRecordTypeId();
            Id supportReqRecTpeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(supReq).getRecordTypeId();
            Id asrReqRecTpeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(ASRWMRECTYPE).getRecordTypeId();
            Id closdSuppReqRecTpeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(CLSDSUPPRECTYP).getRecordTypeId();
            for(ContentDocumentLink obj : cntDocNewList){
                String sObjName = obj.LinkedEntityId.getSObjectType().getDescribe().getName();
                if(String.valueOf(obj.LinkedEntityId).startsWith(objId) )
                {
                    csIds.add(obj.LinkedEntityId);
                }
                if( targtObjWF.equals(sObjName) )
                {
                    wfIds.add(obj.LinkedEntityId);
                }
                
                
            }
            if(!(system.label.GA_CaseAllowDelProfiles.contains(currUsr.Profile.Name))){
                if(csIds.size()>0)
                {
                    // list<case> caseDocLst=[select id,recordtypeId from case where id in:csIds limit 100];
                    
                    map<id,id> caseRecMap=new map<id,id>();
                    for(case cse:[select id,recordtypeId from case where id in:csIds limit 100])
                    {
                        caseRecMap.put(cse.id,cse.recordtypeId);
                    }
                    
                    Set<Id> docIds = new Set<Id>();
                    for(ContentDocumentLink obj : cntDocNewList){
                        
                        if(String.valueOf(obj.LinkedEntityId).startsWith(objId)){
                            
                            if(((CurrUsr.GA_RoleName__c <> SUPPMNGRROLE &&
                                 CurrUsr.GA_RoleName__c <> WMSUPPORTMNGRROLE) 
                                && caseRecMap.get(obj.LinkedEntityId) ==closdSuppReqRecTpeId)||((CurrUsr.GA_RoleName__c<> BENEFITADMINLGRROLE) && (obj.LinkedEntity.recordtypeId ==supportReqRecTpeId)) 
                              ){
                                  obj.LinkedEntityId.addError(insrtErrMsg);
                              }
                        }
                        docIds.add(obj.LinkedEntityId);
                        
                    }   
                }
                if(wfIds.size()>0)
                {
                    // list<case> caseDocLst=[select id,recordtypeId from case where id in:csIds limit 100];
                    //p<id,id> wfStsMap=new map<id,id>();
                    map<id,Id> wfStsMap = New map<id,Id>();
                    map<Id,String> wfStatusMap = New map<Id,String>();
                    set<Id> suppWFLst= New   set<Id> ();
                    for(GA_WF_Workflow__c wf:[select id,GA_Status__c,GA_Workflow_Template__c from GA_WF_Workflow__c where id in:wfIds limit 100])
                    {
                        wfStsMap.put(wf.GA_Workflow_Template__c,wf.id);
                        wfStatusMap.put(wf.id,wf.GA_Status__c);
                    }
                    
                    for(GA_WFT_Step__c wftmpStp : [select id,GA_WFTInventoryName__c,GA_WFT_Workflow_ID__c from GA_WFT_Step__c where
                                                   GA_WFT_Workflow_ID__c in:wfStsMap.keyset()  and GA_WFTInventoryName__c like '%ASR To Modify%'limit 100]  ){
                                                       if(wfStsMap.keyset().contains(wftmpStp.GA_WFT_Workflow_ID__c)){
                                                           suppWFLst.add(wfStsMap.get(wftmpStp.GA_WFT_Workflow_ID__c));   
                                                       }
                                                   }
                    
                    
                    Set<Id> docIds = new Set<Id>();
                    for(ContentDocumentLink obj : cntDocNewList){
                        String sObjName = obj.LinkedEntityId.getSObjectType().getDescribe().getName();
                        if(targtObjWF.equals(sObjName) ){
                            String  wfSts = wfStatusMap.get(obj.LinkedEntityId) ;
                            if(((CurrUsr.GA_RoleName__c <> SUPPMNGRROLE &&
                                 CurrUsr.GA_RoleName__c <> WMSUPPORTMNGRROLE && 
                                 CurrUsr.GA_RoleName__c <> GATEAMLEADROLE && 
                                 CurrUsr.GA_RoleName__c <> GAMNGRROLE 
                                ) 
                                && wfSts.equalsIgnoreCase(CLSD) )
                              )
                            {
                                obj.LinkedEntityId.addError(insrtErrMsg);
                            }
                            
                            if((CurrUsr.GA_RoleName__c == SUPPMNGRROLE ||
                                CurrUsr.GA_RoleName__c == WMSUPPORTMNGRROLE) 
                               && wfSts.equalsIgnoreCase(CLSD)  && !suppWFLst.contains(obj.LinkedEntityId) 
                              ){
                                  obj.LinkedEntityId.addError(insrtErrMsg);
                              }
                            
                            
                        }
                        docIds.add(obj.LinkedEntityId);
                        
                    }   
                }
                
            }
            
            
            
        }
        catch(Exception e)
        {
            GA_LogExceptionCls.LogExcp(e, clsName, restrictCaseFilesInsertMthd);
        }
    }
}