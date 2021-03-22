/**
@Author : Prasant Kumar Satpathy
@Name: GA_CaseUpdateCls
@CreatedDate:  18- Dec 2017 
@Description: GA_CaseUpdateCls class is for updating Case info
@version : 1.0  
*/
public with sharing class GA_CaseUpdateCls {
    public static final string caseRecTyp='GA_Support_Issues';
    //public static final string caseRecTyp='Support - Issues';
    public static final string jeocrteErrMsg = 'Could not create Jeopardy :';
    public static final string ClsName  ='GA_CaseUpdateCls';
    public static final string methodNmeCaseFields  ='updteCasefields';
    public static final string methodNmeJeoRec ='crteJeopardyRec'; 
    public static final string BLANK='';
    public static final string OtherVal='Other';
    public static final string statusVal='Created';
    public static final string openbrckt='J-(';
    public static final string clsbrckt=')';
    public static final String recordTypeId = 'RecordTypeId';
    //public static final Id IssueRecTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(caseRecTyp).getRecordTypeId();
    public static final Id IssueRecTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get(caseRecTyp).getRecordTypeId();
    public static boolean isExecuting=false;
    public static  id currentUserId = userinfo.getUserId();
    public static User currentUser = [SELECT profile.name, Delegate_User__c FROM user WHERE Id =: currentUserId];
    
    
    /**
@Description: updteCasefields() method 
@Name : updteCasefields
@Param : list<Case> caseList, map<id,Case> caseoldMap  
@Return : void
@throws Exception : N/A;
*/
    public static void updteCasefields(list<case> casLst,map<id,Case> caseoldMap)
    {
        try{
            id RecTypeId;
            
            for(case cs:casLst)
            {
                cs.GA_CaseSupportManager__c=cs.GA_Support_Manager_Email_Frml__c;
                // cs.EntitlementId=system.label.GA_EntitlementASRWMId;
                if((cs.issue__c  && cs.RecordTypeId!=IssueRecTypeId) && !string.isBlank(cs.GA_Retention_Rep_Case_Owner_Frml__c))
                {
                    cs.GA_WorkOrderCategory__c=BLANK;
                    cs.GA_SupportRequest_Type__c=BLANK;
                    cs.OwnerId=cs.GA_Retention_Rep_Case_Owner_Frml__c;
                    cs.RecordTypeId=IssueRecTypeId;   
                }
            }
        }
        catch(Exception e){
            GA_LogExceptionCls.LogExcp(e, ClsName, methodNmeCaseFields);
            casLst[0].adderror(jeocrteErrMsg);
        }
    }
    /**
@Description: crteJeopardyRec() method 
@Name : crteJeopardyRec
@Param : list<Case> caseList, map<id,Case> caseoldMap  
@Return : void
@throws Exception : N/A;
*/ 
    public static void crteJeopardyRec(list<case> casLst,map<id,case> casOldMap)
    {
        try{
            List<Case> updCaseList = New List<Case> ();
            GA_Jeopardy__c jeoPardy;
            boolean jeoCrt=false;
            list<GA_Jeopardy__c> jeoPardyCrtLst=new list<GA_Jeopardy__c>();
            for(case cs:casLst){
                if(casOldMap !=null){
                    case csOld=casOldMap.get(cs.id);
                    if(csOld.GA_Jeopardy__c != cs.GA_Jeopardy__c && (cs.GA_Jeopardy__c))
                    {
                        jeoCrt=true;
                    }
                }
                else {
                    if(cs.GA_Jeopardy__c)
                    {
                        jeoCrt=true;
                    }
                }
                
                if(cs.RecordTypeId == Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get(caseRecTyp).getRecordTypeId() && (jeoCrt) && (cs.AccountId !=null))
                {
                    jeoPardy=new GA_Jeopardy__c();
                    jeoPardy.GA_Company__c=cs.accountid;
                    jeoPardy.GA_Case__c=cs.id;
                    jeoPardy.GA_JeopardyReason__c=OtherVal;
                    jeoPardy.GA_OtherPleaseSpecify__c=cs.GA_IssuesCategory__c;
                    jeoPardy.GA_Status__c=statusVal;
                    jeoPardy.Name=openbrckt+cs.CaseNumber+clsbrckt;
                    jeoPardyCrtLst.add(jeoPardy);
                    
                }
            }
            if(jeoPardyCrtLst.size()>0)
                database.insert(jeoPardyCrtLst);
        }
        catch(Exception e){
            GA_LogExceptionCls.LogExcp(e, ClsName, methodNmeJeoRec);
            casLst[0].adderror(jeocrteErrMsg);
        }
    }
    
    public static void updateCaseAccountNametechfield(List<Case> caseList){
        list<id> supportRequestIds=new list<id>();
        for (Case  caserec: caseList) { 
            supportRequestIds.add(caserec.id);
            if(System.label.ASR_PCS_PROFILE_DEVELOPERNAMES.contains(currentUser.profile.name)){
                caserec.status='Submitted';  
            }
            
        }
        
        updateCaseAccountNametechfieldfuture(supportRequestIds);
    }
    
    
    public static void updateCaseAccountNametechfieldfuture(List<id> caserecordIds){
        List<Case> caselist= [SELECT id,Account.name,Account_Name_Tech__c FROM Case WHERE Id IN :caserecordIds ];
        try{
            for(Case caserec:caselist){
                if(String.isnotblank(caserec.Account_Name_Tech__c) && String.isNotBlank(caserec.Account.name)){
                    caserec.Account_Name_Tech__c =caserec.Account.name;
                }            
            }
            
        } catch(Exception e) {
            system.debug(logginglevel.error,+e.getMessage());
            GA_LogExceptionCls.LogExcp( e, ClsName, 'updateCaseAccountNametechfieldfuture');
        }   
        
    }
}