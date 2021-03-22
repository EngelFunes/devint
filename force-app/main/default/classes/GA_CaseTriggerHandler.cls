/**
@Author : Dilip
@Name: GA_CaseTriggerHandler
@CreatedDate: 21 - Nov 2017 
@Description: GA_CaseTriggerHandler class is for creating/updating Case is changed
@version : 1.0  
*/    
public without sharing class GA_CaseTriggerHandler {
    public static final String ClsName  ='GA_CaseTriggerHandler';
    public static final String methodNmeafterinsert  ='afterinsert';
    public static final String methodNmebeforeupdate ='beforeupdate';
    public static final String methodNmebeforeinsert ='beforeinsert';
    public static final String methodNmeafterupdate ='afterupdate';
    public static final String methodNmeafterdelete ='afterdelete';
    public static final String methodNmebeforedelete = 'beforeDelete';
    public static final GA_Profile_ByPass__c profBypass = GA_Profile_ByPass__c.getInstance();
    
    
    /**
@Description: afterinsert() method 
@Name : afterinsert
@Param : list<Case> caseList, map<id,Case> caseNewMap  
@Return : void
@throws Exception : N/A;
*/ 
    public static void afterinsert(list<Case> caseList, map<id,Case> caseNewMap,map<id,Case>caseoldMap)
    {
       try
        {   
            
            if(!profBypass.Bypass__c){
                if(!GA_CaseUpdateCls.isExecuting)
                {
                    GA_CaseUpdateCls.isExecuting=true;
                    GA_CaseUpdateCls.crteJeopardyRec(caseList,null);  
                }
            }
            GA_AssignCaseOwnerCls.caseOwnerAssignAfter(caseList);
             GA_AssignCaseOwnerCls.caseAccessSharetoSuperUserAfter(caseList, null );
            ServicingAgentSREmail.sendEmailtoASRSalesreps(caseList, null);
            AgentSupportRequestBOB.sharingAgentSupportRequestRecord(caseList, null);
            //FSA_SupportRequestChatter.followCaseRecordByAgent(caseList);
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, ClsName, methodNmeafterinsert);
            caseList[0].adderror(e);
        }
        
    }
    
    /**
@Description: beforeupdate() method 
@Name : beforeupdate
@Param : list<Case> caseList, map<id,Case> caseNewMap,map<id,Case>  caseoldMap  
@Return : void
@throws Exception : N/A;
*/ 
    public static void beforeupdate(list<Case> caseList, map<id,Case> caseNewMap,map<id,Case> caseoldMap)
    {
        try{
        //GA_CaseUpdateCls.updateCaseAccountNametechfield(caseList);
            if(!GA_AssignCaseOwnerCls.isExecuting)
            {
                GA_AssignCaseOwnerCls.isExecuting=true;
                GA_AssignCaseOwnerCls.caseOwnerAssignBefore(caseList,caseoldMap);
            }
            if(!profBypass.Bypass__c){
                GA_CaseUpdateCls.updteCasefields(caseList,caseoldMap);
                
            }

            GA_AssignCaseOwnerCls.aSRAssignmentforAgnetCaseBefore(caseList, caseoldMap);
            UpdateDelegatedAgent.updateDelegatedAgentOnCase(caseList);
            
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, ClsName, methodNmebeforeupdate);
            caseList[0].adderror(e);
        }
    }
    /**
@Description: beforeinsert() method 
@Name : beforeinsert
@Param : list<Case> caseList, map<id,Case> caseNewMap  
@Return : void
@throws Exception : N/A;
*/ 
    public static void beforeinsert(list<Case> caseList,map<id,Case> caseoldMap)
    {
        try{
          GA_CaseUpdateCls.updateCaseAccountNametechfield(caseList);
            if(!GA_AssignCaseOwnerCls.isExecuting)
            {
                GA_AssignCaseOwnerCls.isExecuting=true;
                GA_AssignCaseOwnerCls.caseOwnerAssignBefore(caseList,caseoldMap);
             }
            if(!profBypass.Bypass__c){
                GA_CaseUpdateCls.updteCasefields(caseList,caseoldMap);
                
            }

            GA_AssignCaseOwnerCls.aSRAssignmentforAgnetCaseBefore(caseList, Null);
            UpdateDelegatedAgent.updateDelegatedAgentOnCase(caseList);
            
            
            
            Set<Id> setAccountIds = new Set<Id>();
            String salesProfiles = System.label.Sales_profiles;
              String asrpcsProfile= System.label.ASR_PCS_Profile;
            Map<Id, Account> mapAccountId_ServicingAgent;
            String currentUserprofileName;
            for(Case objCase : caseList){
                if(objCase.GA_AgentName__c == null && objCase.AccountId != null){
                    setAccountIds.add(objCase.AccountId);
                }
            }
            if(!setAccountIds.isEmpty()){
                currentUserprofileName = [SELECT name FROM profile WHERE Id = :userinfo.getProfileId()].Name;
                if(salesProfiles.contains(currentUserprofileName) || asrpcsProfile.contains(currentUserprofileName)){
                    mapAccountId_ServicingAgent = new Map<Id, Account>([SELECT Id, Servicing_Agent__c FROM Account WHERE Id IN :setAccountIds]);
                    for(Case objCase : caseList){
                        if(objCase.GA_AgentName__c == null && mapAccountId_ServicingAgent.get(objCase.AccountId).Servicing_Agent__c != null){
                             objCase.GA_AgentName__c = mapAccountId_ServicingAgent.get(objCase.AccountId).Servicing_Agent__c;
                        }
                    }
                }
            }
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, ClsName, methodNmebeforeinsert);
            caseList[0].adderror(e);
        }
    }
    
    /**
@Description: afterupdate() method 
@Name : afterupdate
@Param : list<Case> caseList, map<id,Case> caseNewMap  
@Return : void
@throws Exception : N/A;
*/ 
    public static void afterupdate(list<Case> caseList,map<id,Case>caseoldMap)
    {
        
        try{
            if(!profBypass.Bypass__c){
                if(!GA_CaseUpdateCls.isExecuting)
                {
                    GA_CaseUpdateCls.isExecuting=true;
                    GA_CaseUpdateCls.crteJeopardyRec(caseList,caseoldMap);  
                    
                }
            }
           ServicingAgentSREmail.sendEmailtoASRSalesreps(caseList, caseoldMap);
            GA_AssignCaseOwnerCls.caseAccessSharetoSuperUserAfter(caseList, caseoldMap );
            AgentSupportRequestBOB.sharingAgentSupportRequestRecord(caseList, null);
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, ClsName, methodNmeafterupdate);
            caseList[0].adderror(e);
        }
    }
    
    /**
@Description: afterdelete() method 
@Name : afterdelete
@Param : list<Case> caseList  
@Return : void
@throws Exception : N/A;
*/
    public static void afterDelete(list<Case> caseList)
    {
       
        try
        {
            GA_ArchiveCaseCls.archiveCaseRecs(caseList);
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, ClsName, methodNmeafterdelete); 
        }
    }
        /**
@Description: beforeDelete() method 
@Name : beforeDelete
@Param : list<Case> caseOldList  
@Return : void
@throws Exception : N/A;
*/
    public static void beforeDelete(list<Case> caseOldList)
    {
        try
        {
            GA_ArchiveCaseCls.restrictDelete(caseOldList);
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, ClsName, methodNmebeforedelete); 
        }
    }
}