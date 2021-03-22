/*****************************************************************************************
Class Name   : GA_WorkflowStpSaveCls
Date Created : 10/05/2017
Created By   : IDC Offshore 
Description  : 1. This is controller class to save  Workflow Step record
******************************************************************************************/
public class GA_WorkflowStpSaveCls {
    
    public static final string hyphenVal='-';
    public static final string ClsName = 'GA_WorkflowStpSaveCls';
    public static final string fetchwrkStpDetails = 'fetchwrkStpDetails';
    public static final string ErrorMsg = 'There is some problem in saving workflow step record';
    public static final string excepSepartr = ' : ';
    public static final string SelectWFstps = 'select Id,GA_Carrier__c,GA_Sub_Type__c,Requested_Cancellation_Date__c,Cancellation_Reason__c,Name,(select GA_Group_Segment_ID__r.Name,GA_Group_Segment_ID__c,owner.Name from GA_WF_Group_Segments__r),'+
        'GA_Status__c,GA_Start__c,GA_End_Time__c,GA_Notes__c,GA_WF_Workflow_ID__r.GA_Date_Opened__c,owner.Name,GA_Benefit_Effective_Date__c,'+
        'GA_Problem_Identified_Values__c,   GA_Tracking_Status__c,GA_WF_Workflow_ID__r.GA_Date_Closed__c, GA_WF_Workflow_ID__r.GA_Renewal_Date__c, GA_WF_Workflow_ID__r.Name,GA_WF_Workflow_ID__r.GA_Account__r.Federal_Tax_ID__c,'+
        'GA_WF_Workflow_ID__r.GA_Account__r.NumberOfEmployees,GA_WF_Workflow_ID__r.GA_Account__r.Name,  GA_WF_Workflow_ID__r.GA_Support__r.casenumber,'+
        'GA_WF_Workflow_ID__r.GA_Sold_After_3PM__c,GA_WF_Workflow_ID__r.GA_Method__c,GA_WF_Workflow_ID__r.GA_Account__r.Id,GA_WF_Workflow_ID__r.GA_Support__r.Id, GA_WF_Workflow_ID__r.GA_Status__c,GA_WF_Workflow_ID__r.ARV_Enrollment_Contract__c,GA_WF_Workflow_ID__r.ARV_Enrollment_Contract__r.ContractNumber, GA_WF_Workflow_ID__r.GA_Account_Benefit_Review__c,GA_WF_Workflow_ID__r.GA_Account_Benefit_Review__r.Name'+
        ',GA_WF_Template_Step__r.GA_Role__c,GA_WF_Workflow_ID__r.GA_Corporate_Received_Date__c,GA_WF_Template_Step__r.GA_Department__c,GA_Work_Type__c,GA_Other_please_specify__c,GA_Grace_Code__c,GA_ClosedWFUpdate__c from GA_WF_Step__c where ';
    
    public static final string whereid = 'Id = ';//: wrkflwStpId
    public static final string limitClause = ' Limit 200';
    public static final string wfStepAPINm = 'GA_WF_Step__c';
    public static final string trckingSts = 'GA_Tracking_Status__c';
    public static final string prbIndVal= 'GA_Problem_Identified_Values__c';
    public static final string wrktypVal= 'GA_Work_Type__c';
    public static final string otherPIDval = 'GA_Other_please_specify__c';
    public static final string cancelReason = 'Cancellation_Reason__c';    
    public static final string SelectCurrentWFstpQry  = 'select Id,Requested_Cancellation_Date__c,Cancellation_Reason__c,GA_WF_Workflow_ID__c,GA_WF_Workflow_ID__r.GA_Workflow_Template__c,'+
        'GA_Status__c,GA_Notes__c ,GA_Tracking_Status__c,GA_Problem_Identified_Values__c,GA_Other_please_specify__c,GA_Work_Type__c  from GA_WF_Step__c where ';
    public static final string limitStr = ' Limit 1';
    public static final string wherewfid = ' GA_WF_Workflow_ID__c =';
    public static final string wherests = ' and GA_Status__c = ';
    public static final string open = 'Open';
    public static final string whereidnot = ' and id !=';
    public static final string closed = 'Closed';
    public static final string Success = 'Success';
    public static final string Failed = 'Failed';
    
    
    /**
@Description: fetchwrkStpDetails() method 
@Name : fetchwrkStpDetails
@Param :string wrkflwStpId
@Return : list<wrkflwStpHstryWrp>
@throws Exception : AuraHandledException;
*/      
    @AuraEnabled
    public static list<wrkflwStpHstryWrp> fetchwrkStpDetails(string wrkflwStpId)
    {
        try{
            list<user> currUsr=[select id,profile.Name from user where id=:userInfo.getUserId() limit 1];
            list<wrkflwStpHstryWrp> wrkflwStpHstryWrpLst=new list<wrkflwStpHstryWrp>();
            String userprofileName;
            String userroleName;
            User lgdusr=GA_Util08_FilterProcessHelper.fetchUsrDtls(Userinfo.getUserId());

            list<GA_WF_Step__c> wrkdflowStpLst=GA_Util03_WrkflwStpDataAccessHelper.fetchwrkflowStpsMap(SelectWFstps, 
                                                                                                       whereid + GA_Util08_FilterProcessHelper.FltrString(wrkflwStpId),
                                                                                                       GA_Util03_WrkflwStpDataAccessHelper.BLANK, 
                                                                                                       limitClause).values();
            
            GA_WF_Step__c preProcessingStep = new GA_WF_Step__c();
            List<GA_WF_Step__c>  workFlowStepList = [select name, Cancellation_Reason__c, Requested_Cancellation_Date__c from GA_WF_Step__c
                                                     where name = 'Pre-Processing' and  GA_WF_Workflow_ID__c =: wrkdflowStpLst[0].GA_WF_Workflow_ID__c limit 1];
            if(workFlowStepList.size() > 0){
                preProcessingStep = workFlowStepList[0];
            }            
            
            for(GA_WF_Step__c wfstp:wrkdflowStpLst)
            {
                List<string> grpSgmnets=New List<String>();
                Set<string> ownerSet=New Set<String>();
                set<string> ownerIdSet=new set<string>();
                if(wfstp.GA_WF_Group_Segments__r.size()>0)
                {
                    for(integer i=0;i<wfstp.GA_WF_Group_Segments__r.size();i++)
                    {
                        grpSgmnets.add(wfstp.GA_WF_Group_Segments__r[i].GA_Group_Segment_ID__r.Name);
                        ownerSet.add(wfstp.GA_WF_Group_Segments__r[i].owner.Name);
                        string ownrid=String.valueOf(wfstp.GA_WF_Group_Segments__r[i].ownerId);
                        
                        ownerIdSet.add(ownrid);
                    }
                    
                    if(currUsr.size()>0 && currUsr[0].profile.Name=='System Administrator')
                    {
                        ownerIdSet.add(userInfo.getUserId());
                    }
                }
                List<string> ownerName=New List<String>(ownerSet);
                List<string> ownerids=New List<string>(ownerIdSet);
                if(String.isNotBlank(userinfo.getProfileId()))
                    userprofileName=[Select Id,Name from Profile where Id=:userinfo.getProfileId()].Name;
                
                if(String.isNotBlank(userinfo.getUserRoleId()))
                    userroleName = [Select Id,Name from userrole where Id=:userinfo.getUserRoleId()].Name;
                
                sObject sObj = Schema.getGlobalDescribe().get(wfStepAPINm).newSObject() ;
                
                
                
                List<String> trackingStatus = GA_AP06_fetchPicklistValues.getselectOptions(sObj,trckingSts);
                List<String> problemIdentified = GA_AP06_fetchPicklistValues.getselectOptions(sObj, prbIndVal);
                List<String> wrkTypeValues = GA_AP06_fetchPicklistValues.getselectOptions(sObj, wrktypVal);
                List<String> otherPIDValues = GA_AP06_fetchPicklistValues.getselectOptions(sObj, otherPIDval);
                List<String> cancelReasonValues = GA_AP06_fetchPicklistValues.getselectOptions(sObj, cancelReason);
                
                Date corporateRcvdDt = wfstp.GA_WF_Workflow_ID__r.GA_Corporate_Received_Date__c  ;
                
                wrkflwStpHstryWrp wrkflwHstry=new wrkflwStpHstryWrp(wfstp.GA_WF_Workflow_ID__r.Name,ownerName,
                                                                    wfstp.GA_Start__c,
                                                                    wfstp.GA_End_Time__c,
                                                                    wfstp.GA_WF_Workflow_ID__r.GA_Account__r.Federal_Tax_ID__c,
                                                                    wfstp.GA_WF_Workflow_ID__r.GA_Account__r.NumberOfEmployees,
                                                                    wfstp.GA_WF_Workflow_ID__r.GA_Renewal_Date__c,                                                                
                                                                    wfstp.GA_Notes__c,
                                                                    wfstp.GA_WF_Workflow_ID__r.GA_Status__c,
                                                                    wfstp.GA_Status__c,
                                                                    wfstp.GA_WF_Workflow_ID__r.GA_Account__r.Name,
                                                                    wfstp.GA_WF_Workflow_ID__r.GA_Support__r.casenumber,
                                                                    wfstp.GA_WF_Workflow_ID__r.GA_Account__r.Id,
                                                                    wfstp.GA_WF_Workflow_ID__r.GA_Support__r.Id,
                                                                    userprofileName, userroleName,
                                                                    wfstp.GA_WF_Workflow_ID__c,
                                                                    lgdusr,
                                                                    trackingStatus,
                                                                    problemIdentified,
                                                                    wfstp.GA_Tracking_Status__c,
                                                                    wfstp.GA_Problem_Identified_Values__c,
                                                                    wfstp.GA_Work_Type__c,
                                                                    wrkTypeValues,
                                                                    otherPIDValues,
                                                                    wfstp.GA_Other_please_specify__c,
                                                                    wfstp.GA_ClosedWFUpdate__c,
                                                                    wfstp.GA_Benefit_Effective_Date__c != null? wfstp.GA_Benefit_Effective_Date__c.format() : null,
                                                                    corporateRcvdDt != null ? corporateRcvdDt.format() : null,
                                                                    wfstp.GA_WF_Workflow_ID__r.GA_Sold_After_3PM__c,
                                                                    wfstp.GA_WF_Workflow_ID__r.GA_Method__c,
                                                                    wfstp.Name

                                                                   );
                wrkflwHstry.abrId=wfstp.GA_WF_Workflow_ID__r.GA_Account_Benefit_Review__c;
                wrkflwHstry.abrName=wfstp.GA_WF_Workflow_ID__r.GA_Account_Benefit_Review__r.Name;
                wrkflwHstry.usrRole =wfstp.GA_WF_Template_Step__r.GA_Role__c;
                wrkflwHstry.userDepartment =wfstp.GA_WF_Template_Step__r.GA_Department__c;
                wrkflwHstry.stepOwnerIds=ownerids;
                wrkflwHstry.contractId=wfstp.GA_WF_Workflow_ID__r.ARV_Enrollment_Contract__c;
                wrkflwHstry.contractNum=wfstp.GA_WF_Workflow_ID__r.ARV_Enrollment_Contract__r.ContractNumber;
                wrkflwHstry.cancellationDate = (wfstp.Requested_Cancellation_Date__c == null ? preProcessingStep.Requested_Cancellation_Date__c : wfstp.Requested_Cancellation_Date__c);
                wrkflwHstry.cancellationReason = (wfstp.Cancellation_Reason__c == null ? preProcessingStep.Cancellation_Reason__c : wfstp.Cancellation_Reason__c);
                wrkflwHstry.cancelReasonOption = cancelReasonValues;
                wrkflwHstry.carrier = wfstp.GA_Carrier__c;
                wrkflwHstry.subtype = wfstp.GA_Sub_Type__c;
                wrkflwStpHstryWrpLst.add(wrkflwHstry);
            }
            return wrkflwStpHstryWrpLst;
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, ClsName, fetchwrkStpDetails);
            throw new AuraHandledException(ErrorMsg+excepSepartr+e.getMessage()); 
        }
    }
    /**
@Description: validationChk() method 
@Name : validationChk
@Param :string wrkflwStpId
@Return : boolean
@throws Exception : AuraHandledException;
*/      
    @AuraEnabled
    public static boolean  validationChk(String wfstpId)
    {
        try
        {
            List<GA_AP_ShowValidationMessages.errormessage> errmsgs = New   List<GA_AP_ShowValidationMessages.errormessage>();
            errmsgs = GA_AP_ShowValidationMessages.wrktStepValidatePrepocessing(wfstpId);
            
            if(errmsgs.size() > 0)
                return true;
            else
                return false;
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, ClsName, fetchwrkStpDetails);
            throw new AuraHandledException(ErrorMsg+excepSepartr+e.getMessage()); 
        }
    }
    
    /**
@Description: fetchWFName() method 
@Name : fetchWFName
@Param : NA
@Return : String 
@throws Exception : NA;
*/ 
    @AuraEnabled
    public static String  updateWFStep(String nts,String wfstpId)
    {
        try
        {
            
            
            GA_WF_Step__c wfstRec = New GA_WF_Step__c(Id = wfstpId );
            if(String.isNotEmpty(nts))
                wfstRec.GA_Notes__c = nts;
            
            if(wfstRec <> null){ 
                List<GA_WF_Step__c> wfStpLst= New List<GA_WF_Step__c>();
                wfStpLst.add(wfstRec);
                GA_Util03_WrkflwStpDataAccessHelper.dmlOnwrkflwstp(wfStpLst,GA_Util03_WrkflwStpDataAccessHelper.UPDATE_OPERATION);
                
            }
            
            return String.valueOf(wfstRec.GA_WF_Workflow_ID__c);    
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, ClsName, fetchwrkStpDetails);
            throw new AuraHandledException(ErrorMsg+excepSepartr+e.getMessage()); 
        }
    } 
    
    @AuraEnabled
    public static List<String >  completeCurrentStep(String nts,String wfstpId,String trackingStatus,String problemIdentified,String workType,String otherPID,boolean soldafter3PM,String cancelReason,Date cancelDate)
    {
        try
        {
            
            List<String > validationMessages = New List<String > ();
            Boolean NoValidationFired = false;
            list<GA_WFT_Allowed_Next_Step__c> nxtSteps = New  list<GA_WFT_Allowed_Next_Step__c>();
            
            validationMessages.clear();
            
            List<GA_WF_Step__c> wfstRecLst = GA_Util03_WrkflwStpDataAccessHelper.fetchwrkflowStpsMap(SelectCurrentWFstpQry, 
                                                                                                     whereid + GA_Util08_FilterProcessHelper.FltrString(wfstpId), 
                                                                                                     GA_Util03_WrkflwStpDataAccessHelper.BLANK, 
                                                                                                     limitStr).values();
            
            GA_WF_Step__c  wfstRec =wfstRecLst[0];
            
            validationMessages = GA_AP_03_WkflwValidation.wfallwdSteps(wfstRec.GA_WF_Workflow_ID__r.GA_Workflow_Template__c,wfstRec.GA_WF_Workflow_ID__c,wfstpId);
            
           // wfstRec.GA_Notes__c = nts;
            wfstRec.GA_Tracking_Status__c = trackingStatus;
            wfstRec.GA_Problem_Identified_Values__c = problemIdentified;
            wfstRec.GA_Work_Type__c=workType;
            wfstRec.GA_Other_please_specify__c = otherPID;
            wfstRec.Cancellation_Reason__c = cancelReason;
            wfstRec.Requested_Cancellation_Date__c = cancelDate;
            
            List<GA_WF_Step__c> wfStpLst= New List<GA_WF_Step__c>();
            wfStpLst.add(wfstRec);
            GA_Util03_WrkflwStpDataAccessHelper.dmlOnwrkflwstp(wfStpLst,GA_Util03_WrkflwStpDataAccessHelper.UPDATE_OPERATION);
            

            GA_AP05_UpdateStpDtsOnWFGS.updateWFGSdtls(wfstRec);
            
             GA_WF_Workflow__c wrkflw=new GA_WF_Workflow__c();
             wrkflw.id=wfstRec.GA_WF_Workflow_ID__c;
             wrkflw.GA_Sold_After_3PM__c=soldafter3PM;
             database.update(wrkflw);
            
            nxtSteps =  WorkflowController.retrieveNextSteps(wfstRec.id);
            
            return validationMessages;  
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, ClsName, fetchwrkStpDetails);
            throw new AuraHandledException(ErrorMsg+excepSepartr+e.getMessage()); 
        }
    } 
    
    @AuraEnabled
    public static String closeWorkflow(String wfstpId)
    {
        try
        {
            
            
            
            String wfclosureMessages = '';           
            list<GA_WFT_Allowed_Next_Step__c> nxtSteps = New  list<GA_WFT_Allowed_Next_Step__c>();
            
            List<GA_WF_Step__c> wfStplSt = GA_Util03_WrkflwStpDataAccessHelper.fetchwrkflowStpsMap(SelectCurrentWFstpQry, 
                                                                                                   whereid + GA_Util08_FilterProcessHelper.FltrString(wfstpId), 
                                                                                                   GA_Util03_WrkflwStpDataAccessHelper.BLANK, 
                                                                                                   limitStr).values();
            GA_WF_Step__c wfstRec =wfStplSt[0];
            
            
            wfstRec.GA_Status__c = closed;
            
            nxtSteps =  WorkflowController.retrieveNextSteps(wfstRec.id);
            
            
            List<GA_WF_Step__c> wfstReclst = GA_Util03_WrkflwStpDataAccessHelper.fetchwrkflowStpsMap(SelectCurrentWFstpQry, 
                                                                                                     wherewfid + GA_Util08_FilterProcessHelper.FltrString(wfstRec.GA_WF_Workflow_ID__c) +
                                                                                                     wherests + GA_Util08_FilterProcessHelper.FltrString(open) +
                                                                                                     whereidnot + GA_Util08_FilterProcessHelper.FltrString(wfstRec.id ), 
                                                                                                     GA_Util03_WrkflwStpDataAccessHelper.BLANK, 
                                                                                                     limitClause).values();
            
            
            List<GA_WF_Step__c> updatewfStpLst= New List<GA_WF_Step__c>();
            List<GA_WF_Workflow__c> updatewfLst= New List<GA_WF_Workflow__c>();
            if( nxtSteps.size() == 0  && wfstReclst.size() == 0){
                
                GA_WF_Workflow__c currStpWFObj = New  GA_WF_Workflow__c(id = wfstRec.GA_WF_Workflow_ID__c);
                currStpWFObj.GA_Status__c = closed;
                updatewfLst.add(currStpWFObj);
                GA_Util03_WrkflwDataAccessHelper.dmlOnwrkflw(updatewfLst, GA_Util03_WrkflwDataAccessHelper.UPDATE_OPERATION);
                
                wfclosureMessages = Success;
                wfstRec.GA_Status__c = closed;
                updatewfStpLst.add(wfstRec);
                GA_Util03_WrkflwStpDataAccessHelper.dmlOnwrkflwstp(updatewfStpLst,GA_Util03_WrkflwStpDataAccessHelper.UPDATE_OPERATION);
                //  Database.update(wfstRec);
            }
            
            if( nxtSteps.size() == 0  && wfstReclst.size() > 0) {
                wfclosureMessages = Failed;
                
            }

            
            return wfclosureMessages;  
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, ClsName, fetchwrkStpDetails);
            throw new AuraHandledException(ErrorMsg+excepSepartr+e.getMessage()); 
        }
    } 
    
    @AuraEnabled
    public static String  fetchWfId(String wfstpId,String nts,Boolean chckCnl,String trackingStatus,String problemIdentified,String workType,String otherPID,boolean soldafter3PM,String cancelReason,Date cancelDate)
    {
        try
        {
            
            List<GA_WF_Step__c> wfstReclst = GA_Util03_WrkflwStpDataAccessHelper.fetchwrkflowStpsMap(SelectCurrentWFstpQry, 
                                                                                                     whereid + GA_Util08_FilterProcessHelper.FltrString(wfstpId) , 
                                                                                                     GA_Util03_WrkflwStpDataAccessHelper.BLANK, 
                                                                                                     limitStr).values();
            
            GA_WF_Step__c wfsteprec  = wfstReclst[0];
            
            if(!chckCnl){
                wfsteprec.GA_Notes__c = nts;
                wfsteprec.GA_Tracking_Status__c = trackingStatus;
                wfsteprec.GA_Problem_Identified_Values__c = problemIdentified;
                wfsteprec.GA_Work_Type__c=workType;
                wfsteprec.GA_Other_please_specify__c = otherPID;
                wfsteprec.Cancellation_Reason__c = cancelReason;
                wfsteprec.Requested_Cancellation_Date__c = cancelDate;
                                
                List<GA_WF_Step__c> wfStpLst= New List<GA_WF_Step__c>();
                wfStpLst.add(wfsteprec);
                GA_Util03_WrkflwStpDataAccessHelper.dmlOnwrkflwstp(wfStpLst,GA_Util03_WrkflwStpDataAccessHelper.UPDATE_OPERATION);
                
                
                
                GA_AP05_UpdateStpDtsOnWFGS.updateWFGSdtls(wfsteprec);
                GA_WF_Workflow__c wrkflw=new GA_WF_Workflow__c();
                wrkflw.id=wfsteprec.GA_WF_Workflow_ID__c;
                wrkflw.GA_Sold_After_3PM__c=soldafter3PM;
                database.update(wrkflw);
                    
            }
            
            
            
            return String.valueOf(wfsteprec.GA_WF_Workflow_ID__c);  
            
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, ClsName, fetchwrkStpDetails);
            throw new AuraHandledException(ErrorMsg+excepSepartr+e.getMessage()); 
        }
    } 
    @AuraEnabled
    public static GA_Workflow_Field_Visibility__mdt fieldVisibilty()
    {
        list<user> usr=[select id,GA_RoleName__c,profile.Name from user where id=:userInfo.getUserId()];
        if(usr.size()>0)
        {
            string RoleNm=usr[0].GA_RoleName__c;
            if(RoleNm!='')
            {
                list<GA_Workflow_Field_Visibility__mdt> wflfildVsbllst=[select id,label,GA_Problem_Identified_Editable__c,
                                                                        GA_Problem_Identified_Visible__c,GA_Tracking_Status_Code__c,
                                                                        GA_Work_Type__c
                                                                        from GA_Workflow_Field_Visibility__mdt where label=:RoleNm];  
                if(wflfildVsbllst.size()>0)
                {
                    return wflfildVsbllst[0];
                }
            }
            
        }
        return null;
    }
    public class wrkflwStpHstryWrp
    {
        @AuraEnabled
        public string Name;
        @AuraEnabled
        public List<String> stepOwner;
        @AuraEnabled
        public List<String> stepOwnerIds;
        @AuraEnabled
        public datetime openDate;
        @AuraEnabled
        public datetime closedDate;
        @AuraEnabled
        public string fedTxId; 
        @AuraEnabled
        public Integer employees; 
        @AuraEnabled
        public datetime renewalDate; 
        @AuraEnabled
        public String Notes; 
        @AuraEnabled
        public String status; 
        @AuraEnabled
        public String wfstpstatus; 
        @AuraEnabled
        public String accName; 
        @AuraEnabled
        public String caseNum; 
        @AuraEnabled
        public String accId; 
        @AuraEnabled
        public String caseId; 
        @AuraEnabled
        public String contractId;
        @AuraEnabled
        public String contractNum;
        @AuraEnabled
        public String userDepartment; 
        @AuraEnabled
        public String usrRole; 
        @AuraEnabled
        public String wrkFlwid;
        @AuraEnabled
        public User loginUser;
        @AuraEnabled
        public List<String> trackSts; 
        @AuraEnabled
        public List<String> problemIdentified;
        @AuraEnabled
        public List<String> wrkType;
        @AuraEnabled
        public List<String> otherPID;
        @AuraEnabled
        public String selectedTrackingstatus; 
        @AuraEnabled
        public String selectedProbIdentified;
        @AuraEnabled
        public String selectedWrkType;
        @AuraEnabled
        public String selectedOtherPID;
        @AuraEnabled
        public String abrId;
        @AuraEnabled
        public String abrName;
        @AuraEnabled
        public Boolean closedWFUpdate;
        @AuraEnabled
        public String BnftEffDate;
        @AuraEnabled
        public String corporateRcvdDt;
        @AuraEnabled
        public Boolean soldAfter3PM;
         @AuraEnabled
        public String methodType;
         @AuraEnabled
        public String stepName;
        @AuraEnabled
        public datetime cancellationDate;
        @AuraEnabled
        public String cancellationReason;
        @AuraEnabled
        public List<String> cancelReasonOption;
        @AuraEnabled
        public String carrier;
        @AuraEnabled
        public String subtype;
        
        public wrkflwStpHstryWrp(string NameTmp,List<string> stepOwnerTmp, Datetime openDateTmp,
                                 Datetime closedDateTmp, string fedTxIdTmp, 
                                 Integer employeesTmp,Date renewalDateTmp,String NotesTmp,String statusTmp,String wfstpstatusTmp,
                                 String accNameTmp,string caseNumTmp,String accIdTmp,String caseIdTmp,
                                 string userDepartmentTmp,String usrRoleTmp,String wrkFlwidTmp,User loginUserTmp,List<String> trackStsTmp,List<String> problemIdentifiedTmp,
                                 String selectedTrackingstatusTmp,String selectedProbIdentifiedTmp, string selectedWrkTypeTmp,List<String> wrkTypeTmp,
                                 List<String> otherPIDTmp,String selectedOtherPIDTmp,Boolean closedWFUpdateTmp,String BnftEffDateTmp, String corporateRcvdDtTmp,Boolean soldAFter3PMTmp,String methodTypeTmp,String stepNameTmp)
        {
            Name=NameTmp;
            stepOwner=stepOwnerTmp;
            openDate=openDateTmp;
            closedDate=closedDateTmp;
            fedTxId=fedTxIdTmp;
            employees = employeesTmp;
            renewalDate = renewalDateTmp;
            Notes = NotesTmp;
            status= statusTmp;
            wfstpstatus = wfstpstatusTmp;
            accName=accNameTmp;
            caseNum=caseNumTmp;
            accId = accIdTmp;
            caseId =caseIdTmp;
            userDepartment = userDepartmentTmp;
            usrRole = usrRoleTmp ;
            wrkFlwid = wrkFlwidTmp;
            loginUser=loginUserTmp;
            trackSts = trackStsTmp;
            problemIdentified = problemIdentifiedTmp;
            selectedTrackingstatus=  selectedTrackingstatusTmp;
            selectedProbIdentified = selectedProbIdentifiedTmp;
            wrkType=wrkTypeTmp;
            selectedwrkType=selectedwrkTypeTmp;
            otherPID=otherPIDTmp;
            selectedOtherPID = selectedOtherPIDTmp;
            closedWFUpdate =  closedWFUpdateTmp;
            BnftEffDate=BnftEffDateTmp;
            corporateRcvdDt= corporateRcvdDtTmp;
            soldAfter3PM = soldAFter3PMTmp;
            methodType = methodTypeTmp;
            stepName = stepNameTmp;
        }
    }
    
    @AuraEnabled
    public static string chkLoggedInUsrprfle()
    {
        list<user> usrLst=[select profile.Name from user where id=:userInfo.getUserId()];
        return usrLst[0].profile.Name;
    }
}