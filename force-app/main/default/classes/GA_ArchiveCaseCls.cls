/*****************************************************************************************
Class Name   : GA_ArchiveCaseCls
Date Created : 06/27/2018
Created By   : IDC Offshore
Description  : 1. This is the service class for Archive support request. to insert record when a support request is deleted
Change History : 
******************************************************************************************/
public without sharing class GA_ArchiveCaseCls {
    /**Class to throw exception*/
    public with sharing class ValidateException extends exception{}
    public static final string ClsName = 'GA_ArchiveCaseCls';
    public static final string methodNme = 'archiveCaseRecs';
    public static final string methodNme1 = 'restrictDelete';
    public static final string ErrorMsg = 'Archive support request database operation failed :';
    //Public Static final Id profileId=userinfo.getProfileId();
   // Public Static final String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
    Public Static String RoleName='';
    public Static final String wmRecType = 'Support - Support / West Michigan';
    public Static final String wmRecTpeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(wmRecType).getRecordTypeId();
    
    /**
@Description: archiveCaseRecs() method 
@Name : archiveCaseRecs
@Param : list<case> CasLst
@Return : void
@throws Exception : N/A;
*/ 
    public static void archiveCaseRecs(list<case> CasLst)
    {
        try
        {
            list<GA_Archive_Case_Config__mdt> archiveCSMapLst =[SELECT Label,GA_Case_API_Name__c,GA_Archive_Case_API_Name__c FROM GA_Archive_Case_Config__mdt limit 100];
            map<string,string> archiveFiledMps=new map<string,string>();
            list<GA_Support_Request_Arch__c> archCsLst=new list<GA_Support_Request_Arch__c>();
            for(SObject cs : CasLst)
            {  
                GA_Support_Request_Arch__c archCs=new GA_Support_Request_Arch__c();
                for(GA_Archive_Case_Config__mdt casArch:archiveCSMapLst)
                {
                    
                    archCs.put(casArch.GA_Archive_Case_API_Name__c,cs.get(casArch.GA_Case_API_Name__c));
                    
                }
                archCsLst.add(archCs);
            }
            
            
            if(archCsLst.size()>0)
            {
                database.insert(archCsLst);
            } 
        }
        
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, ClsName, methodNme);
            throw new ValidateException(ErrorMsg, e); 
            
        }
    }
    /**
@Description: restrictDelete() method 
@Name : restrictDelete
@Param : list<case> caseoldList
@Return : void
@throws Exception : N/A;
 **/
    public static void restrictDelete(list<Case> caseoldList)
    {
        try
        {
            list<User> curntUsr=[select id,GA_RoleName__c,Profile.Name from user where id=:userInfo.getUserId()];
            if(curntUsr.size()>0)
            {
                RoleName=curntUsr[0].GA_RoleName__c;
            }
            
            for(case cs : caseoldList)  {
                if(cs.RecordTypeid == wmRecTpeId){
                    if(!((system.label.GA_CaseAllowDelProfiles.contains(curntUsr[0].Profile.Name)) || (system.label.GA_CaseAllowDelRoles.contains(RoleName)))){
                        
                       cs.addError(system.label.GA_LauchWFErrMsg);
                    }
                }
           } 
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, ClsName, methodNme1); 
        }
    }
   
}