/**
@Author : IDC Offshore
@Name: GA_AP_CancelWorkflowCls
@CreatedDate: 21 - Oct 2017 
@Description: GA_AP_CancelWorkflowCls class to cancel group segments or  Workflow 
@version : 1.0  
*/
public with sharing class GA_AP_CancelWorkflowCls { 
    public Static Final string CLSNAME='GA_AP_CancelWorkflowCls';
    public Static Final string MTHDCANCLWRFLW='canclWrflw';
    public Static Final string MTHDWRKFLWINFO='wrkFlwInfo';
    public Static Final string MTHDCHECKCANCELWRKFLWACCSS = 'checkCancelWrkflwAccss';
    public Static Final string MTHDRETRIEVGRPSGMNTS = 'retrievGrpSgmnts';
    private Static string succsMsg=system.label.GA_Workflow_Cancel_Msg;
    public Static Final string WRKFLWCNCLEDMSG=system.label.GA_Workflow_Alrdy_Cancel_Msg;
    public Static Final string ERRMSG='Something went wrong. Please contact your System Admin';
    public Static Final String SYSADMINPROF='System Administrator';
    public Static Final String MTHDSENDMAILTOUSRS= 'sendMailtoUsrs';
    public Static Final String OPNSTS= 'Open';
    public Static Final string CLSDSTS= 'Closed';
    public Static Final string CNCLD = 'Canceled';
    public static final String ABRTMPLT = 'BCBSM - N/A - ABR - N/A';
    public Static Final string CNCLMSG = 'Group Segments are canceled';
    public Static Final string CNCLVFTMPLT ='GA_Cancel_Workflow_VF_Template';
    public Static Final string GSCNCLVFTMPLT ='Cancel_Workflow_GS_VF_Template';
    public Static Final String SUPTSNRALYSTROLE='Support Senior Analyst';
    public Static Final String PCSSUPTROLE='PCS - Support';
    public Static Final String PCSWMSUPTROLE='PCS - West Michigan Support';
    public Static Final String SUPTMNGRROLE='Support Manager';
    public Static Final String WMSUPTMNGRROLE='West Michigan Support Manager';
    public Static Final String BCNGMTPROFILE='BCN GMT Processor';
    public Static Final String BREAKSYMBL='<br/>';
    public static final string NULLSTRNG='';
    public static TimeZone tzn = UserInfo.getTimeZone();
    public static Datetime currenttime = system.now();
    private static final Datetime myDT = Datetime.now();
    private static final String myDate = myDT.format('MM/dd/yyyy h:mm:ss a');
    private static final String sPace = ' ';
    public static final String BLANK = '';
    private static final String coMma = ',';
    public Static Final String NEWLINESYMBL='\n';
    
    /**
@Description: wrkFlwInfo() method 
@Name : wrkFlwInfo
@Param : string wfId
@Return : Boolean
@throws Exception : ValidateException;
*/    
    @AuraEnabled
    public static boolean wrkFlwInfo(string wfId)
    {
        try{
            list<GA_WF_Workflow__c> wfRecLst=[select id,GA_Status__c from GA_WF_Workflow__c 
                                              where id=:wfId and GA_Status__c =:OPNSTS Limit 2000];
            if(wfRecLst.size()>0)
            {
                return true;
            }
            return false;
        }
        catch(Exception e){
            
            GA_LogExceptionCls.LogExcp(e, CLSNAME, MTHDWRKFLWINFO);
            throw new AuraHandledException(ERRMSG);
        }
        
    }
    /**
@Description: canclWrflw() method 
@Name : canclWrflw
@Param : string wfId,string cnclCmnts,List<String> grpIds
@Return : string
@throws Exception : ValidateException;
*/    
    @AuraEnabled
    public static string canclWrflw(string wfId,string cnclCmnts,List<String> grpIds)
    {
        try
        {   
            list<GA_WF_Group_Segment__c> grpSgmentLstSndMl=new list<GA_WF_Group_Segment__c>();
            list<GA_WF_Group_Segment__c> grpSgmentCnlLstSndMl=new list<GA_WF_Group_Segment__c>();
            set<id> ownerIds=new set<id>();
            String grpNames = BLANK;
            Map<id,string> gsNameMap = new Map<id,string> ();
            for(GA_Group_Segment__c gsRec:[select Id,Name from GA_Group_Segment__c where ID IN: grpIds]){
                grpNames=grpNames+gsRec.Name+ coMma; 
                gsNameMap.put(gsRec.Id,gsRec.Name);
            }
            List<GA_WF_Step__c>  cnclWfStp= [Select id,Name,GA_WF_Workflow_ID__c,GA_Notes__c,GA_End_Time__c from  GA_WF_Step__c 
                                             where GA_WF_Workflow_ID__c =:wfId
                                             and Name =: CNCLD Limit 1];
            GA_WF_Step__c wfSTpCnl = New GA_WF_Step__c();
            if( grpIds != null){
                
                if(cnclWfStp.size() == 0){
                    
                    wfSTpCnl = new GA_WF_Step__c(Name = CNCLD,
                                                 GA_WF_Workflow_ID__c = wfId,                                                                      
                                                 GA_Start__c = currenttime,
                                                 GA_End_Time__c=currenttime,
                                                 GA_Status__c = CNCLD,
                                                 GA_Notes__c=myDate + sPace + userinfo.getName() + sPace + grpNames.removeEnd(coMma)+ sPace+cnclCmnts); 
                    
                    database.insert(wfSTpCnl);
                    
                }
                else
                {
                    
                    cnclWfStp[0].GA_End_Time__c=currenttime;
                    cnclWfStp[0].GA_Notes__c=myDate + sPace + userinfo.getName() + sPace + grpNames.removeEnd(coMma)+ sPace+cnclCmnts + ( cnclWfStp[0].GA_Notes__c <> null ? NEWLINESYMBL + cnclWfStp[0].GA_Notes__c : BLANK);
                    database.update(cnclWfStp[0]);
                }
                
                list<GA_WF_Group_Segment__c> grpSgmntWFLst=new list<GA_WF_Group_Segment__c>(); 
                list<GA_Group_Segment__c> grpInprgssLst=new list<GA_Group_Segment__c>();
                GA_WF_Group_Segment__c wfGrpsgmnt =new GA_WF_Group_Segment__c();
                GA_Group_Segment__c gtpTmp = new GA_Group_Segment__c();
                
                Map<string,string> wfGSMap = new Map<string,string> (); 
                for(GA_WF_Group_Segment__c wfgs :  [select Id,Name,GA_Group_Segment_ID__c,GA_Workflow_ID__c,GA_Status__c,
                                                    GA_Workflow_ID__r.GA_Workflow_Template_Name__c from GA_WF_Group_Segment__c 
                                                    where GA_Workflow_ID__c !=: wfId and GA_Group_Segment_ID__c IN: grpIds 
                                                    and GA_Status__c =:OPNSTS
                                                    and GA_Workflow_ID__r.GA_Workflow_Template_Name__c !=: ABRTMPLT limit 500]){
                                                        wfGSMap.put(wfgs.GA_Group_Segment_ID__c,wfgs.GA_Workflow_ID__c);
                                                    }
                
                for(String grpsgmntId:grpIds)
                {
                    wfGrpsgmnt=new GA_WF_Group_Segment__c(
                        GA_Workflow_ID__c=wfId,
                        GA_Group_Segment_ID__c=grpsgmntId,
                        GA_WF_Step_ID__c= (cnclWfStp.size() > 0) ? cnclWfStp[0].id : wfSTpCnl.Id ,
                        //wfGrpsgmnt.GA_WF_Step_ID__c= wfSTpCnl.Id ;
                        GA_Date_Opened__c = currenttime,
                        GA_Date_Closed__c=currenttime,
                        GA_Status__c=CNCLD,
                        GA_Notes__c=myDate + sPace + userinfo.getName() + sPace + gsNameMap.get(grpsgmntId)+ sPace+cnclCmnts,
                        OwnerId=userInfo.getUserId());
                    grpSgmntWFLst.add(wfGrpsgmnt);  
                    
                    
                    gtpTmp=new GA_Group_Segment__c();
                    gtpTmp.Id=grpsgmntId;
                    if(!wfGSMap.keySet().contains(grpsgmntId))
                    {  
                        gtpTmp.GA_In_Progress__c=false;
                        gtpTmp.GA_In_Progress_Type__c=NULLSTRNG;
                        gtpTmp.GA_Is_Mass_Updating__c=True;
                        grpInprgssLst.add(gtpTmp);
                    }
                }
                database.insert(grpSgmntWFLst);
                if(grpInprgssLst.size()>0)
                {
                    GA_GS_AP02_Update_Address.isExecuting=true;
                    //GA_ExternlaAppleSrvcCls.isExecuting = true;
                    GA_GS_UpdateRatingType.isExecuting = true;
                    GA_GroupSegmentTriggerHandler.beforeUpdateExecuting = true;
                    GA_GroupSegmentTriggerHandler.isExecuting = true;
                    GA_GS_AP04_UpdtStatus.isCnclGSChkd = true;
                    GA_GS_AP04_UpdtStatus.isExecuting = true;
                    GA_GS_AP04_UpdtStatus.isInvoked = true;
                    GA_GS_UpdatWrappingFileTPA.isExecuting = true;
                    GA_GroupSegAccUpdateCls.isExecuting = true;
                    GA_ExternalAppealSrvcCls_MOS.isExecuting = true;
                    GA_GS_Insert_ThrdPartyBillerRecs.isExecuting = true;
                    GA_GS_Insert_ThrdPartyBillerRecs.isInvoked = true;
                    GA_GS_Insert_ThrdPartyBillerRecs.isInvoking = true;
                    GA_ExternalAppealRecdCrtnUpdt.isExecuting = true;
                    database.update(grpInprgssLst);
                }
                list<GA_WF_Group_Segment__c> grpSgmentLstToCncl=new list<GA_WF_Group_Segment__c>();
                
                
                
                /*list<GA_WF_Group_Segment__c> grpSgmentLst=[select Id,GA_Status__c,GA_WF_Step_ID__c,GA_Group_Segment_ID__c,OwnerId,GA_Is_Owner_Queue__c,	GA_Workflow_Next_Step__c
                                                           from GA_WF_Group_Segment__c where GA_Workflow_ID__c=:wfId  
                                                           and GA_Group_Segment_ID__c =: grpIds and GA_WF_Step_ID__c !=null limit 2000];*/ //and GA_Status__c =: OPNSTS
                
                list<GA_WF_Group_Segment__c> grpSgmentLst=[select Id,GA_Status__c,GA_WF_Step_ID__c,GA_Group_Segment_ID__c,OwnerId,Owner.Profile.Name,GA_Is_Owner_Queue__c,	GA_Workflow_Next_Step__c
                                                           from GA_WF_Group_Segment__c where GA_Workflow_ID__c=:wfId  
                                                           and GA_Group_Segment_ID__c =: grpIds and GA_WF_Step_ID__c !=null limit 2000];
                
                
                set<id> wfSTpIds=new set<id>();
                for(GA_WF_Group_Segment__c grpSgmnt : grpSgmentLst){
                    if(grpSgmnt.GA_Status__c == OPNSTS ) {
                        wfSTpIds.add(grpSgmnt.GA_WF_Step_ID__c);
                        grpSgmnt.GA_Status__c = CNCLD;
                        grpSgmnt.GA_Workflow_Next_Step__c =(cnclWfStp.size() > 0) ? cnclWfStp[0].id : wfSTpCnl.Id ;
                        //grpSgmnt.GA_Workflow_Next_Step__c = wfSTpCnl.Id ;
                        grpSgmentLstToCncl.add(grpSgmnt); }
                    if(!grpSgmnt.GA_Is_Owner_Queue__c){
                        grpSgmentCnlLstSndMl.add(grpSgmnt);
                    }
                }
                
                
                database.update(grpSgmentLstToCncl);  
                list<GA_WF_Step__c> wfSTpLst=[select id,GA_Status__c,
                                              (select id,GA_Status__c from GA_WF_Group_Segments__r Limit 10000) 
                                              from GA_WF_Step__c where id in:wfSTpIds Limit 5000];
                list<GA_WF_Step__c> wfSTpLstTpUpdte=new list<GA_WF_Step__c>();
                for(GA_WF_Step__c wfSTp:wfSTpLst)
                {
                    integer cnlCnt=0;
                    integer clsCnt=0;
                    for(GA_WF_Group_Segment__C wfGsmnt:wfSTp.GA_WF_Group_Segments__r)
                    {
                        if(wfGsmnt.GA_Status__c ==OPNSTS)
                        {
                            break; 
                        }
                        else if(wfGsmnt.GA_Status__c ==CNCLD)
                        {
                            cnlCnt++;
                        }
                        else
                        {
                            clsCnt++;
                        }
                    }
                    if(cnlCnt==wfSTp.GA_WF_Group_Segments__r.size())
                    {
                        wfSTp.GA_Status__c=CNCLD; 
                        wfSTpLstTpUpdte.add(wfSTp);
                    }
                    else if(cnlCnt+clsCnt==wfSTp.GA_WF_Group_Segments__r.size())
                    {
                        wfSTp.GA_Status__c=CLSDSTS;
                        wfSTpLstTpUpdte.add(wfSTp);
                    }
                }
                if(wfSTpLstTpUpdte.size()>0)
                {
                    database.update(wfSTpLstTpUpdte);
                }
                succsMsg = CNCLMSG;
            }
            
            list<GA_WF_Group_Segment__c> opngrpSgmentLst=[select Id,GA_Status__c,OwnerId,GA_Group_Segment_ID__r.Name,GA_Group_Segment_ID__c from GA_WF_Group_Segment__c
                                                          where GA_Workflow_ID__c=:wfId and GA_Status__c =: OPNSTS and GA_WF_Step_ID__c !=null  Limit 2000] ;
            
            if(opngrpSgmentLst.size() == 0){
                
                GA_WF_Workflow__c wfRec=new GA_WF_Workflow__c();
                wfRec.Id=wfId;
                wfRec.GA_Status__c=CNCLD;
                list<GA_WF_Step__c> wfStpLst=[select Id,GA_Status__c from GA_WF_Step__c where GA_WF_Workflow_ID__c=:wfId Limit 1000];
                list<GA_WF_Step__c> wfStpLstToCncl=new list<GA_WF_Step__c>();
                
                //list<GA_WF_Group_Segment__c> grpSgmentLst=[select Id,GA_Status__c,GA_Group_Segment_ID__c,OwnerId,GA_Is_Owner_Queue__c from GA_WF_Group_Segment__c where GA_Workflow_ID__c=:wfId and GA_WF_Step_ID__c !=null Limit 2000];
                list<GA_WF_Group_Segment__c> grpSgmentLst=[select Id,GA_Status__c,GA_Group_Segment_ID__c,OwnerId,Owner.Profile.Name,GA_Is_Owner_Queue__c from GA_WF_Group_Segment__c where GA_Workflow_ID__c=:wfId and GA_WF_Step_ID__c !=null Limit 2000];
                list<GA_WF_Group_Segment__c> grpSgmentLstToCncl=new list<GA_WF_Group_Segment__c>();
                for(GA_WF_Step__c wfStp:wfStpLst)
                {
                    if(wfStp.GA_Status__c==OPNSTS)
                    {
                        wfStp.GA_Status__c=CNCLD;
                        wfStpLstToCncl.add(wfStp);  
                    }
                    
                }                
                
                for(GA_WF_Group_Segment__c wfGrpSGmnt:grpSgmentLst)
                {
                    if(wfGrpSGmnt.GA_Status__c==OPNSTS)
                    {
                        wfGrpSGmnt.GA_Status__c=CNCLD;
                        grpSgmentLstToCncl.add(wfGrpSGmnt);  
                    }
                    
                    
                    if(!wfGrpSGmnt.GA_Is_Owner_Queue__c){
                        grpSgmentLstSndMl.add(wfGrpSGmnt);
                    }
                }
                list<SObject> objLst=new list<SObject>();
                objLst.add(wfRec);
                objLst.addAll(wfStpLstToCncl);
                objLst.addAll(grpSgmentLstToCncl);
                //list<GA_WF_Group_Segment__c> grpSgmentLstSndMl=[select Id,GA_Status__c,OwnerId from GA_WF_Group_Segment__c where GA_Workflow_ID__c=:wfId and GA_Is_Owner_Queue__c=false];                                              
                
                database.update(objLst);  
                succsMsg=system.label.GA_Workflow_Cancel_Msg;
                
            }              
            if(grpSgmentLstSndMl != null){
                for(GA_WF_Group_Segment__c grp:grpSgmentLstSndMl)
                {
                    if(grp.OwnerId <> null && grp.Owner.Profile.Name != BCNGMTPROFILE){
                        ownerIds.add(grp.OwnerId);
                    }
                }
                if(ownerIds.size()>0)
                {
                    sendMailtoUsrs(ownerIds,(cnclWfStp.size() > 0) ? cnclWfStp[0].id : wfSTpCnl.Id,CNCLVFTMPLT); 
                }
            }
            
            if(grpSgmentCnlLstSndMl != null){ // Workflow Group Segment List
                for(GA_WF_Group_Segment__c grp:grpSgmentCnlLstSndMl)
                {
                    if(grp.OwnerId <> null && grp.Owner.Profile.Name != BCNGMTPROFILE){
                        ownerIds.add(grp.OwnerId);
                    }
                }
                if(ownerIds.size()>0)
                {
                    sendMailtoUsrs(ownerIds,(cnclWfStp.size() > 0) ? cnclWfStp[0].id : wfSTpCnl.Id,GSCNCLVFTMPLT); 
                }
            }
            
            
            return succsMsg;
            
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, CLSNAME, MTHDCANCLWRFLW);
            throw new AuraHandledException(ERRMSG); 
        }
        
    }
    /**
@Description: checkCancelWrkflwAccss() method 
@Name : checkCancelWrkflwAccss
@Param : string wfId
@Return : boolean
@throws Exception : ValidateException;
*/     
    @AuraEnabled
    public static boolean checkCancelWrkflwAccss(string wfId)
    {
        try{
            set<id> ownerIdsOpen=new set<id>();
            set<id> ownerIdsClosed=new set<id>();
            list<GA_WF_Workflow__c> wfRec=[select ownerId,owner.UserRoleId,GA_WFCreatedBySupportTeam__c from GA_WF_Workflow__c where id=:wfId limit 1];
            if(wfRec.size()>0)
            {
                ownerIdsOpen.add(wfRec[0].ownerId);
                /*list<GA_WF_Group_Segment__c> grpSgmentLst=[select Id,GA_Status__c,OwnerId from GA_WF_Group_Segment__c 
where GA_Workflow_ID__c=:wfId and GA_WF_Step_ID__c != null 
and GA_Is_Owner_Queue__c=false Limit 2000];

for(GA_WF_Group_Segment__c grp:grpSgmentLst)
{
String sts = grp.GA_Status__c;

if(sts.equalsIgnoreCase(OPNSTS)){
ownerIdsOpen.add(grp.OwnerId);
}
if(sts.equalsIgnoreCase(CLSDSTS)){
ownerIdsClosed.add(grp.OwnerId);
}
}*/
                user usr=[select profile.name,GA_RoleName__c from user where id=:userInfo.getUserId() limit 1];
                string prfNm=usr.profile.name;
                string roleNm=usr.GA_RoleName__c;
                
                if(ownerIdsOpen.contains(userInfo.getUserId()) || prfNm==SYSADMINPROF || ((roleNm==SUPTSNRALYSTROLE || roleNm==PCSSUPTROLE || roleNm==PCSWMSUPTROLE || roleNm==SUPTMNGRROLE || roleNm==WMSUPTMNGRROLE ) && wfRec[0].GA_WFCreatedBySupportTeam__c))
                {
                    return true;  
                }
            }
            return false;
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, CLSNAME, MTHDCHECKCANCELWRKFLWACCSS);
            throw new AuraHandledException(ERRMSG); 
        }
    }
    /**
@Description: retrievGrpSgmnts() method 
@Name : retrievGrpSgmnts
@Param : string wfId
@Return : list<GA_WF_Group_Segment__c>
@throws Exception : ValidateException;
*/      
    @AuraEnabled
    public static  list<GA_WF_Group_Segment__c>  retrievGrpSgmnts(string wfId)
    {
        try{  
            list<GA_WF_Group_Segment__c> grpSgmentLst=[select Id,GA_Status__c,OwnerId,GA_Group_Segment_ID__r.Name,GA_Group_Segment_ID__c
                                                       from GA_WF_Group_Segment__c where GA_Workflow_ID__c=:wfId 
                                                       and GA_Status__c =: OPNSTS and GA_WF_Step_ID__c !=null Limit 2000] ;
            
            
            return grpSgmentLst;
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, CLSNAME, MTHDRETRIEVGRPSGMNTS);
            throw new AuraHandledException(ERRMSG); 
        }
    }
    /**
@Description: sendMailtoUsrs() method 
@Name : sendMailtoUsrs
@Param : set<id> userIds,string wfStpId
@Return : void
@throws Exception : ValidateException;
*/      
    public static void sendMailtoUsrs(set<id> userIds,string wfStpId,String vftmplt)
    {
        try{
            List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();
            
            String canclWrkflwTmplt = [SELECT Id FROM EmailTemplate WHERE DeveloperName = :vftmplt Limit 1].Id;
            // String wfStpEml = [SELECT Id,Name FROM GA_WF_Step__c WHERE Name = 'Cancel' and GA_WF_Workflow_ID__c=:wfId limit 1].Id;
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            for(id user:userIds)
            {
                mail = new Messaging.SingleEmailMessage();
                
                mail.setSaveAsActivity(false);
                mail.setTemplateId(canclWrkflwTmplt);
                mail.setTargetObjectId(user);
                mail.setWhatId(wfStpId);
                // mail.setToAddresses(new String[] {'rajkishore3939@hotmail.com'}); 
                emails.add(mail);
            }
            
            Messaging.sendEmail(emails);   
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, CLSNAME, MTHDSENDMAILTOUSRS);
            throw new AuraHandledException(ERRMSG); 
        }
    }
    /*public static Boolean recordHierarchyCheck(String checkRoleId, String checkOwnerId)
{
Map<Id,UserRole> all_roles;
// If we are checking the same role as the logged-in user, it is not considered 'above' unless the user is the owner.
if( checkRoleId == UserInfo.getUserRoleId() ){ return UserInfo.getUserId() == checkOwnerId; } 

if( all_roles == NULL ){ all_roles = new Map<Id,UserRole>([SELECT Id, ParentRoleId FROM UserRole]); } // Get the roles.        
if( !all_roles.containsKey(checkRoleId) ){ return false; } // Return false if an invalid role was provided.
UserRole role = all_roles.get(checkRoleId); // Otherwise get the role we are checking.

// if there is no parent role, the checked role is the ceo and no one is above them in heirarchy except themselves (which we checked for in the prior step).
if( role.ParentRoleId == NULL ){ return False; } 

// Loop through them until the end of the hierarchy is reached, or the user's role is found as a parent.
do {
role = all_roles.get(role.ParentRoleId); // Advance to the next parent.
}
// End the loop when the parent is null (CEO is reached) or the current user's role is reached.
while ( role.ParentRoleId != NULL && role.Id != UserInfo.getUserRoleId() );

// Now that the loop has ended, either we reached the end of the hierarchy (no match to user) or we found the current user's role (in which case they are above).
return  role.Id == UserInfo.getUserRoleId();
}*/
    
}