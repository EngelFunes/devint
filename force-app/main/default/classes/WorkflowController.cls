/*****************************************************************************************
Class Name   : WorkflowController
Date Created : 10/05/2017
Created By   : IDC Offshore 
Description  : 1. This is controller class to workflow setup/Choose Next Step component 
******************************************************************************************/
public with sharing class WorkflowController {
    public static final String CLSNAME = 'WorkflowController';
    public static final String WORKFLOWCONTROLLERMTHD = 'WorkflowControllermthd';
    public static final String ERRORMSG = 'There is some problem in fetching data';
    private static final string SYSOFRECFLD ='GA_System_of_Record__c';
    private static final string ACCSTSFLD = 'Account_Status__c';
    public static final String EXCEPSEPARTR = ' : ';
    public static final String QRYOPEN ='Open';
    public static final String QRYCLOSED ='Closed';
    public static final String CMPLTE = 'Completed';
    public static final String CLSESTATUS = 'Resolved';
    public static final String CLSECOMNTS = 'Support Request Resolved';
    public static final String PROFASR = 'ASR';
    public static final String ALLWDNXTSTPNME = 'ASR To Modify';
    public static final String IDVAL = 'Id';
    public static final String CRNTWRKFLWSTPNAME = 'Automated Validation';
    public static final String WRKFLWSTPNAME = 'Pre-Processing';
    public static final String BLANK ='';
    public static final String QUEVAL = '00G';
    public static final String PROJSPRTTOREVW = 'Project Support - to Review';
    
    public static final String MSGTOADRES = '';
    public static final String MSGFILTR = 'FILTER';
    public static final String MSGSSUBJECT = 'Opt Out Test Message';
    public static final String MSGTXTBODY = 'Group Segments Assigned';
    public static final String HYPNVAL = ' - ';
    public static final String BNFTADMINREVW = 'Benefit Administration Review';
    public static final String HYPHN = '-';
    public static final String SEMICOLON = ';';
    public static final String DLMTR = '\n' ;
    public static final String MNTHYRFRMT = 'MMMM, YYYY';
    public static final String QRYSMRTREC = 'select id, GA_System_of_Record__c from  ';
    public static final String QRYSMRTRECWHR = ' Where Id= ';
    public static final String QRYSMRTRECLMT = ' Limit 01';
    public static final string SHRTYP = 'V'; 
    public static final string SMRT = 'SMART'; 
    public static final string ACNTOBJNAME = 'Account'; 
    public static final string NEWBUSINESS = 'New Business';  
    public static final string AGNTSLDENRLMNT  = 'Agent Sold Enrollment'; 
    public static final string SYSADMN= 'System Administrator';  
    public static final string INACTV= 'Inactive';
    public static final string ACTV= 'Active';
    private static final string PNDG = 'Pending';
    public static final string CSE= 'Case';
    public static final string USRVSIBLTY = 'AllUsers';
    private static final string CRRIER = 'Carrier';
    public static final String QRYACCSTATUS = 'select id, Account_Status__c from  ';
    public static final Datetime CURRENTTIME = system.now();
    private static final string OPN= 'Open';
    public static final String ABRTMPLT = 'BCBSM - N/A - ABR - N/A';
    private static final String WFASSIGNEMAILTMPLT  = 'GA_Workflow_Assignment_Email_Notify';
    private static final string TYP = 'Type';
    private static final string SUBTYP = 'SubType';
    private static final string METHD = 'Method';
    private static final string WFINPROGRESS = 'Workflow';
    private static final Datetime MYDT = Datetime.now();
    private static final String MYDATE = MYDT.format('MM/dd/yyyy h:mm:ss a');
    private static final String SPACE = ' ';
    private static final String COMMA = ',';
    private static final String ABRTYPE = 'ABR';
    private static final String SLTQRY ='Select Id,Account.Account_status__c  from ';
    private static final String NONEVAL ='--None--';
    Private static final string CASEOBJ='Case';
    Private static final string CONTRACTOBJ='Contract';
    
    
    /**
@Description: fetchaccName() method 
@Name : fetchaccName
@Param :string recId
@Return : account
@throws Exception : AuraHandledException;
*/     
    @AuraEnabled
    public static Contract fetchContractName(string recId)
    {
        try{
            contract csLst=[select id,Name,accountId,account.name from Contract where id=:recId Limit 200];
           
            return csLst;
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, CLSNAME, WORKFLOWCONTROLLERMTHD);
            throw new AuraHandledException(ERRORMSG+EXCEPSEPARTR+e.getMessage()); 
        }
    }
    
    /**
@Description: fetchWFCreate() method 
@Name : fetchWFCreate
@Param :null
@Return : GA_Workflow_Launch_Bypass__c
@throws Exception : AuraHandledException;
*/      
    @AuraEnabled
    public static GA_Workflow_Launch_Bypass__c fetchWFCreate(){
        try{
            return GA_Workflow_Launch_Bypass__c.getInstance();
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, CLSNAME, WORKFLOWCONTROLLERMTHD);
            throw new AuraHandledException(ERRORMSG+EXCEPSEPARTR+e.getMessage()); 
        }
    }
    /**
@Description: fetchSMARTInfo() method 
@Name : fetchSMARTInfo
@Param :string recId
@Return : account
@throws Exception : AuraHandledException;
*/     
    @AuraEnabled
    public static Boolean fetchSMARTInfo(string recId,string objAPIName)
    {
        try
        {   
            //changes done for us2724
            if(objAPIName!=CONTRACTOBJ){
            string quryStng = QRYSMRTREC+objAPIName+QRYSMRTRECWHR+GA_Util08_FilterProcessHelper.FltrString(recId)+ QRYSMRTRECLMT;
            
            Sobject sobj = Database.query(quryStng);
            if(sobj <> null){
                if( sobj.get(SYSOFRECFLD) == SMRT ){
                    return true;
                }
                else{
                    return false;
                }
            }
            }else{
            return false;
            }
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, CLSNAME, WORKFLOWCONTROLLERMTHD);
            throw new AuraHandledException(ERRORMSG+EXCEPSEPARTR+e.getMessage()); 
        }
        return null;
        
    }
    /**
@Description: fetchaccName() method 
@Name : fetchaccName
@Param :string recId
@Return : account
@throws Exception : AuraHandledException;
*/     
    @AuraEnabled
    public static account fetchaccName(string recId)
    {
        try{
            list<case> csLst=[select id,account.Name,accountId from case where id=:recId Limit 200];
            account acc=new account();
            acc.Id=csLst[0].accountId;
            acc.Name=csLst[0].account.Name;
            return acc;
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, CLSNAME, WORKFLOWCONTROLLERMTHD);
            throw new AuraHandledException(ERRORMSG+EXCEPSEPARTR+e.getMessage()); 
        }
    }
    
        /**
@Description: fetchWFStpNotes() method 
@Name : fetchWFStpNotes
@Param :string recId
@Return : Notes
@throws Exception : AuraHandledException;
*/     
    @AuraEnabled
    public static string fetchWFStpNotes(string workflowStepId)
    {
        try{
            list<GA_WF_Step__c> WFstep = [SELECT Name,GA_WF_Workflow_ID__c,GA_Notes__c FROM GA_WF_Step__c WHERE Id = :workflowStepId Limit 200];
            String stepNotes = WFstep[0].GA_Notes__c;            
            return stepNotes;
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, CLSNAME, WORKFLOWCONTROLLERMTHD);
            throw new AuraHandledException(ERRORMSG+EXCEPSEPARTR+e.getMessage()); 
        }
    }
    /**
@Description: fetchaccNameABR() method 
@Name : fetchaccNameABR
@Param :string recId
@Return : account
@throws Exception : AuraHandledException;
*/      
    @AuraEnabled
    public static account fetchaccNameABR(string recId)
    {
        try{
            list<GA_Account_Benefit_Review__c> abrLst=[select id,GA_Account__r.Name, Is_Logged_In_User_ABR_Spcl__c, GA_Account__c from GA_Account_Benefit_Review__c where id=:recId Limit 200];
            account acc=new account();
            acc.Id=abrLst[0].GA_Account__c;
            acc.Name=abrLst[0].GA_Account__r.Name;
            acc.GA_ABR_Logged_In__c=abrLst[0].Is_Logged_In_User_ABR_Spcl__c;
            return acc;
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, CLSNAME, WORKFLOWCONTROLLERMTHD);
            throw new AuraHandledException(ERRORMSG+EXCEPSEPARTR+e.getMessage()); 
        }
    }
    /**
@Description: insertWfRecABR() method 
@Name : insertWfRecABR
@Param :String accountId,String abrRecId,  
String carrier, 
String type, 
String subType, 
List<String> lstGroupSegments, 
String method
@Return : Id
@throws Exception : AuraHandledException;
*/ 
    @AuraEnabled
    public static Id insertWfRecABR(String accountId,String abrRecId,  
                                    String carrier, 
                                    String type, 
                                    String subType, 
                                    List<String> lstGroupSegments, 
                                    String method){ 
                                        try{
                                            // get the workflow tempalte for the given type, subtype, method and carrier
                                            GA_WFT_workflow__c objWorkflowTemplate =  GA_AP_01_WorkflowDetmntion.getreltedwfTemplate(type, subType, method, carrier);
                                            
                                            // create workflow using the template and details
                                            map<string, string> saveResults = GA_AP_01_WorkflowDetmntion.insertWfRec(new GA_WF_Workflow__c(Name = type + HYPNVAL +Datetime.now().format(MNTHYRFRMT),
                                                                                                                                           GA_Account__c = accountId,  
                                                                                                                                           GA_Account_Benefit_Review__c=abrRecId,
                                                                                                                                           Sub_Type__c = subType,
                                                                                                                                           GA_Type__c = type,
                                                                                                                                           GA_Carrier__c = carrier,
                                                                                                                                           GA_Method__c = method,
                                                                                                                                           GA_Workflow_Template__c = objWorkflowTemplate.Id,
                                                                                                                                           GA_Status__c = QRYOPEN,
                                                                                                                                           GA_Number_of_Group_Suffixes__c=lstGroupSegments.size(),
                                                                                                                                           GA_Date_Opened__c=system.today()));
                                            
                                            
                                            
                                            if(!string.isBlank(saveResults.get(IDVAL))){
                                                Id objWorkFlowId =saveResults.get(IDVAL); 
                                                list<account> abrSplstInfoLst=[select id,GA_Territory__r.GA_ABR_Specialist__c from account where id=:accountId limit 1];
                                                //create workflow group segments 
                                                list<GA_WF_Group_Segment__c> lstWFGroupSegments = new list<GA_WF_Group_Segment__c>();
                                                list<GA_Certs_Rider_Process__c> lstWFCertsRider= new list<GA_Certs_Rider_Process__c>();
                                                list<GA_WF_Group_Segment__c> lstWFStepGroupSegments = new list<GA_WF_Group_Segment__c>();
                                                list<GA_Group_Segment__c> grpLstInprgrss=new list<GA_Group_Segment__c>();
                                                GA_WF_Group_Segment__c wfGrpsgmnts = New GA_WF_Group_Segment__c();
                                                GA_Group_Segment__c gtpTmp = New GA_Group_Segment__c();
                                                for(string groupSegmentIds : lstGroupSegments){
                                                    
                                                    wfGrpsgmnts=new GA_WF_Group_Segment__c();
                                                    wfGrpsgmnts.GA_Workflow_ID__c=objWorkFlowId;
                                                    wfGrpsgmnts.GA_Group_Segment_ID__c=groupSegmentIds;
                                                    wfGrpsgmnts.GA_Date_Opened__c=CURRENTTIME;
                                                    wfGrpsgmnts.GA_Date_Closed__c=CURRENTTIME;
                                                    wfGrpsgmnts.GA_Status__c=QRYCLOSED;                                                    
                                                    lstWFGroupSegments.add(wfGrpsgmnts);
                                                    gtpTmp=new GA_Group_Segment__c();
                                                    gtpTmp.Id=groupSegmentIds;
                                                    // gtpTmp.GA_In_Progress__c=true;
                                                    // gtpTmp.GA_In_Progress_Type__c=WFINPROGRESS;
                                                    gtpTmp.GA_Is_Mass_Updating__c=True;
                                                    grpLstInprgrss.add(gtpTmp);
                                                }// end of for-each
                                                
                                                if(lstWFGroupSegments.size() > 0){
                                                    Database.insert(lstWFGroupSegments);  
                                                }
                                                GA_Certs_Rider_Process__c wfCertRidr = new GA_Certs_Rider_Process__c();                                               
                                                for(GA_Certs_Riders__c CertsRider : [select id,Name from GA_Certs_Riders__c where GA_AssetId__r.GA_Plan_Package_Id__r.GA_Group_Segment__r.Id in:lstGroupSegments 
                                                                                     and GA_AssetId__r.GA_Plan_Package_Id__r.GA_ACTIVE_IND__c =: ACTV limit 8000])
                                                {
                                                    wfCertRidr=new GA_Certs_Rider_Process__c();
                                                    wfCertRidr.GA_Workflow__c=objWorkFlowId;
                                                    wfCertRidr.GA_Certs_Rider__c=CertsRider.Id;
                                                    wfCertRidr.GA_Date_Opened__c=CURRENTTIME;
                                                    wfCertRidr.GA_Date_Closed__c=CURRENTTIME;
                                                    wfCertRidr.GA_Status__c=QRYCLOSED;                                                    
                                                    lstWFCertsRider.add(wfCertRidr);
                                                }// end of for-each
                                                
                                                if(lstWFCertsRider.size() > 0){
                                                    Database.insert(lstWFCertsRider);  
                                                }
                                                
                                                if(grpLstInprgrss.size()>0){
                                                    
                                                    GA_GS_AP02_Update_Address.isExecuting=true;
                                                    //GA_ExternlaAppleSrvcCls.isExecuting = true;
                                                    GA_GS_UpdateRatingType.isExecuting = true;
                                                    // GA_GroupSegmentTriggerHandler.beforeUpdateExecuting = true;
                                                    GA_GroupSegmentTriggerHandler.isExecuting = true;
                                                    GA_GS_AP04_UpdtStatus.isCnclGSChkd = true;
                                                    GA_GS_AP04_UpdtStatus.isExecuting = true;
                                                    //GA_GS_AP04_UpdtStatus.isInvoked = true;
                                                    GA_GS_UpdatWrappingFileTPA.isExecuting = true; 
                                                    GA_GroupSegAccUpdateCls.isExecuting = true;
                                                    GA_ExternalAppealSrvcCls_MOS.isExecuting = true;
                                                    GA_GS_Insert_ThrdPartyBillerRecs.isExecuting = true;
                                                    GA_GS_Insert_ThrdPartyBillerRecs.isInvoked = true;
                                                    GA_ExternalAppealRecdCrtnUpdt.isExecuting = true;
                                                    database.update(grpLstInprgrss);
                                                }
                                                //get the preprocessing step for the workflow tempate.
                                                GA_WFT_Step__c objWFTBnftAdminStep = GA_AP_01_WorkflowDetmntion.getRelatedFirstWFStepABR(objWorkflowTemplate, BNFTADMINREVW);
                                                map<id,id> gsParentWFPrcssMap=fetchParentWEFPrcess(objWorkFlowId);
                                                //create preprocessing step for the workflow with the selected group segments.
                                                GA_WF_Step__c objWFBnftAdminstep = new GA_WF_Step__c(Name = objWFTBnftAdminStep.GA_WFT_Inventory_Step_ID__r.Name,
                                                                                                     GA_WF_Workflow_ID__c = objWorkFlowId, 
                                                                                                     GA_WF_Template_Step__c = objWFTBnftAdminStep.Id,
                                                                                                     GA_Start__c = CURRENTTIME,
                                                                                                     GA_Status__c = QRYOPEN
                                                                                                    ); 
                                                Database.insert(objWFBnftAdminstep);
                                                //adding group segments to the workflow step. Not sure if its a good idea to use the same GA_WF_Group_Segment__c object for this. We might have
                                                // to create another junction object between Workflow Step and Group Segments.
                                                GA_WF_Group_Segment__c wfGrpsgmnt =new GA_WF_Group_Segment__c();
                                                for(string groupSegmentIds : lstGroupSegments){
                                                    wfGrpsgmnt=new GA_WF_Group_Segment__c();
                                                    wfGrpsgmnt.GA_Workflow_ID__c=objWorkFlowId;
                                                    wfGrpsgmnt.GA_Group_Segment_ID__c=groupSegmentIds;
                                                    wfGrpsgmnt.GA_WF_Step_ID__c=objWFBnftAdminstep.Id;
                                                    wfGrpsgmnt.GA_Parent_WF_Process__c=gsParentWFPrcssMap.get(groupSegmentIds);
                                                    wfGrpsgmnt.GA_Date_Opened__c = CURRENTTIME;
                                                    
                                                    if(abrSplstInfoLst[0].GA_Territory__r.GA_ABR_Specialist__c !=null)
                                                    {
                                                        wfGrpsgmnt.OwnerId= abrSplstInfoLst[0].GA_Territory__r.GA_ABR_Specialist__c;
                                                    }
                                                    lstWFStepGroupSegments.add(wfGrpsgmnt);
                                                }
                                                // end of for-each
                                                Database.insert(lstWFStepGroupSegments);
                                                return objWorkFlowId;
                                                //return objWorkFlowId;
                                                //return objWorkFlowId;
                                            }
                                            return null;
                                        }
                                        catch(exception e)
                                        {
                                            GA_LogExceptionCls.LogExcp(e, CLSNAME, WORKFLOWCONTROLLERMTHD);
                                            throw new AuraHandledException(ERRORMSG+EXCEPSEPARTR+e.getMessage()); 
                                        }
                                    }   //  end of insertWfRec
    
    /**
@Description: loadGroupSegmentsSize() method 
@Name : loadGroupSegmentsSize
@Param :string accountId, string carrierName
@Return :list<GA_Group_Segment__c> 
@throws Exception : AuraHandledException;
*/    
    @AuraEnabled
    public static Integer loadGroupSegmentsSize(string recId,string objAPIName){
        try{
            if(objAPIName==ACNTOBJNAME)
            {
                Integer gsCount = loadGSQuery(recId);
                return gsCount;
            }
            else if(objAPIName==CASEOBJ)
            {
                String accId = [select id, AccountId from Case Where Id= :recId Limit 1].AccountId;
                Integer gsCount = loadGSQuery(accId);
                return gsCount;
            }
            else{
                     //changes done for us2724
                 String accId = [select id, AccountId from contract Where Id= :recId Limit 1].AccountId;
                Integer gsCount = loadGSQuery(accId);
                return gsCount;
            }
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, CLSNAME, WORKFLOWCONTROLLERMTHD);
            throw new AuraHandledException(ERRORMSG+EXCEPSEPARTR+e.getMessage()); 
        }
        
    }
    /**
@Description: loadGSQuery() method 
@Name : loadGSQuery
@Param :String accountId
@Return :Integer
@throws Exception : AuraHandledException;
*/      
    public static Integer loadGSQuery(String accountId){
        try{
            /*list<GA_Group_Segment__c> lstGroupSegments = [SELECT Id FROM GA_Group_Segment__c WHERE GA_Account__c = :accountId and Status__c =: 'Active' Limit 5];

Integer gsSize = lstGroupSegments.size();
return gsSize;
*/
            List<GA_Group_Segment__c> gsEmptyReturn = new List<GA_Group_Segment__c>();
            Map<id,GA_Group_Segment__c> gsMap = New Map<id,GA_Group_Segment__c>([SELECT Id, Name, GA_Quote_ID__c FROM GA_Group_Segment__c WHERE GA_Account__c = :accountId and (Status__c =: ACTV or Status__c =: PNDG) and ( GA_In_Progress__c=false)  limit 4000]);
            
            /**   for(GA_WF_Group_Segment__c wfP: [select id, GA_Status__c, GA_Group_Segment_ID__c from GA_WF_Group_Segment__c Where GA_Group_Segment_ID__c In: gsMap.keySet() AND GA_Status__c=: OPN AND GA_WF_Step_ID__c<>null limit 4000])
{
if(gsMap.containsKey(wfP.GA_Group_Segment_ID__c)){
gsMap.remove(wfP.GA_Group_Segment_ID__c);
}
} **/
            Integer gsSize = gsMap.keyset().size();
            return gsSize;
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, CLSNAME, WORKFLOWCONTROLLERMTHD);
            throw new AuraHandledException(ERRORMSG+EXCEPSEPARTR+e.getMessage()); 
        }
        
    }
    /**
@Description: retrieveGroupSegments() method 
@Name : retrieveGroupSegments
@Param :string accountId, string carrierName,string typeNme,string subtypeNme
@Return :list<GA_Group_Segment__c>
@throws Exception : AuraHandledException;
*/    
    @AuraEnabled
    public static list<GA_Group_Segment__c> retrieveGroupSegments(string accountId, string carrierName,string typeNme,string subtypeNme,string contId){
        try{
            //changes done for us2724
            if(accountId==null){
                accountId=[select id,accountId from contract where id=:Id.valueof(contId)].accountId;
            }
            List<GA_Group_Segment__c> gsEmptyReturn = new List<GA_Group_Segment__c>();
            Map<id,GA_Group_Segment__c> gsMap = New Map<id,GA_Group_Segment__c>();
            if(typeNme ==NEWBUSINESS){
                gsMap = New Map<id,GA_Group_Segment__c>([SELECT Id, Name, GA_Quote_ID__c, GA_SourceASG__c FROM GA_Group_Segment__c WHERE GA_Account__c = :accountId and (Status__c =: PNDG) AND GA_Carrier__c=:carrierName AND GA_In_Progress__c=false ORDER BY Name ASC limit 4000]);
           }
            if(typeNme == ABRTYPE)
            {   
                gsMap = New Map<id,GA_Group_Segment__c>([SELECT Id, Name, GA_Quote_ID__c FROM GA_Group_Segment__c WHERE GA_Account__c = :accountId and (Status__c =: ACTV or Status__c =: PNDG) AND GA_Carrier__c=:carrierName AND (GA_In_Progress_Type__c = null or GA_In_Progress_Type__c=:BLANK or GA_In_Progress_Type__c=: WFINPROGRESS ) ORDER BY Name ASC limit 4000]);
                
             }
               if(typeNme !=NEWBUSINESS && typeNme != ABRTYPE)
            {
                gsMap = New Map<id,GA_Group_Segment__c>([SELECT Id, Name, GA_Quote_ID__c FROM GA_Group_Segment__c WHERE GA_Account__c = :accountId and (Status__c =: ACTV or Status__c =: PNDG) AND GA_Carrier__c=:carrierName AND GA_In_Progress__c=false ORDER BY Name ASC limit 4000]);
               
            }   
            return gsMap.values();
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, CLSNAME, WORKFLOWCONTROLLERMTHD);
            throw new AuraHandledException(ERRORMSG+EXCEPSEPARTR+e.getMessage());
        }
    }
    /**
@Description: retrieveClosedGroupSegments() method 
@Name : retrieveClosedGroupSegments
@Param :string accountId, string carrierName,string typeNme,string subtypeNme
@Return :list<GA_Group_Segment__c>
@throws Exception : AuraHandledException;
*/     
    @AuraEnabled
    public static list<GA_Group_Segment__c> retrieveClosedGroupSegments(string accountId, string carrierName,string typeNme,string contId){
        try{
            //changes done for us2724
             if(accountId==null){
                accountId=[select id,accountId from contract where id=:Id.valueof(contId)].accountId;
            }
            List<GA_Group_Segment__c> gsOpenGS = new List<GA_Group_Segment__c>();
            Map<id,GA_Group_Segment__c> gsOpenGSMap = New Map<id,GA_Group_Segment__c>();
            //Map<id,GA_Group_Segment__c> gsMap = New Map<id,GA_Group_Segment__c>([SELECT Id, Name, GA_Quote_ID__c FROM GA_Group_Segment__c WHERE GA_Account__c = :accountId and (Status__c ='Active' or Status__c ='Pending') AND GA_Carrier__c=:carrierName]);
            Map<id,GA_Group_Segment__c> gsMap = New Map<id,GA_Group_Segment__c>();
            if(typeNme != ABRTYPE){
                if(typeNme ==NEWBUSINESS)
                {
                    gsMap = New Map<id,GA_Group_Segment__c>([SELECT Id, Name, GA_Quote_ID__c FROM GA_Group_Segment__c WHERE GA_Account__c = :accountId and (Status__c =: PNDG) AND GA_Carrier__c=:carrierName AND GA_In_Progress__c=true ORDER BY Name ASC limit 4000]);
                }
                
                else
                {
                    gsMap = New Map<id,GA_Group_Segment__c>([SELECT Id, Name, GA_Quote_ID__c FROM GA_Group_Segment__c WHERE GA_Account__c = :accountId and (Status__c =: ACTV or Status__c =: PNDG) AND GA_Carrier__c=:carrierName  AND GA_In_Progress__c=true ORDER BY Name ASC limit 4000]);
                }
            }
            // List<GA_WF_Group_Segment__c> wfPList = [select id, GA_Status__c, GA_Group_Segment_ID__c from GA_WF_Group_Segment__c Where GA_Group_Segment_ID__c In: gsMap.keySet() AND GA_Status__c='Open' AND GA_WF_Step_ID__c<>null];
            
            /* for(GA_WF_Group_Segment__c wfP: wfPList){
if(gsMap.containsKey(wfP.GA_Group_Segment_ID__c)){
gsOpenGSMap.put(wfP.GA_Group_Segment_ID__c, gsMap.get(wfP.GA_Group_Segment_ID__c));
}
}*/
            return gsMap.values();
            
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, CLSNAME, WORKFLOWCONTROLLERMTHD);
            throw new AuraHandledException(ERRORMSG+EXCEPSEPARTR+e.getMessage());
        }
    }
    /**
@Description: addFilestoWRflw() method 
@Name : addFilestoWRflw
@Param :GA_WFT_workflow__c objWorkflowTemplate,string supportId,string wfId
@Return :NA
@throws Exception : AuraHandledException;
*/         
    public static void addFilestoWRflw(GA_WFT_workflow__c objWorkflowTemplate,string supportId,string wfId)
    {
        try{
            
            if(objWorkflowTemplate.GA_File_Type__c !=null)
            {           
                
                list<string> fileTypes=objWorkflowTemplate.GA_File_Type__c.split(SEMICOLON);
                if(fileTypes.size()>0)
                {
                    set<id> docIds=new set<id>();
                    for(ContentDocumentLink doc:[select id,contentdocumentId from ContentDocumentLink where linkedEntityId =:supportId limit 50])
                    {
                        if(doc.contentdocumentId <> null)
                        {
                            docIds.add(doc.contentdocumentId);
                        }
                    }
                    if(docIds.size()>0)
                    {
                        set<id> docIdsFltr=new set<id>();
                        for(contentversion cntv:[select id,GA_Type__c,ContentDocumentId from contentversion where ContentDocumentId in:docIds and GA_Type__c in :fileTypes limit 100])
                        {
                            if(cntv.ContentDocumentId <> null)
                            {
                                docIdsFltr.add(cntv.ContentDocumentId);
                            }
                        }
                        ContentDocumentLink cdl = new ContentDocumentLink();
                        list<ContentDocumentLink> docListTmp=new list<ContentDocumentLink>();
                        for(id docId:docIdsFltr)
                        {
                            cdl = new ContentDocumentLink();
                            cdl.ContentDocumentId = docId;
                            cdl.LinkedEntityId = wfId;
                            cdl.ShareType = SHRTYP;
                            cdl.Visibility = USRVSIBLTY; 
                            docListTmp.add(cdl); 
                        }
                        if(docListTmp.size()>0)
                        {
                            database.insert(docListTmp);
                        }  
                    }
                }
            }
            
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, CLSNAME, WORKFLOWCONTROLLERMTHD);
            throw new AuraHandledException(ERRORMSG+EXCEPSEPARTR+e.getMessage()); 
        }
    }
    /**
@Description: insertWfRec() method 
@Name : insertWfRec
@Param :String accountId,String supportId, String carrier, String type, 
String subType,List<String> lstGroupSegments,String method,boolean lnchFrmAcc
@Return :Id
@throws Exception : AuraHandledException;
*/     
    @AuraEnabled
    public static Id insertWfRec(String accountId, 
                                 String supportId, 
                                 String carrier, 
                                 String type, 
                                 String subType, 
                                 List<String> lstGroupSegments, 
                                 String method,List<string> gsIdQte,boolean lnchFrmAcc, string contId){ 
                                     try{
                                       if(contId==BLANK){ contId=null;}
                                         if(accountId==null){
                                             accountId=[select id,accountId from contract where id=:Id.valueof(contId)].accountId;
                                         }
                                         Map<Id,String> gsIdMap = new Map<Id,String>();
                                         if(!gsIdQte.isEmpty()){
                                             List<String> res = New List<String>();
                                             for(string str : gsIdQte){
                                                 res = str.split(HYPHN, 2);
                                                 if(res.size()==2){
                                                     gsIdMap.put(res[0],res[1]);
                                                 }
                                             }
                                         }
                                         system.debug('gsIdMap ==>' + gsIdMap);
                                         // get the workflow tempalte for the given type, subtype, method and carrier
                                         GA_WFT_workflow__c objWorkflowTemplate =  GA_AP_01_WorkflowDetmntion.getreltedwfTemplate(type, subType, method, carrier);
                                         // create workflow using the template and details
                                         date crpRecdDate = null ;
                                         if(supportId <> BLANK)
                                         {
                                             list<case> caseRec=[select id,GA_Corporate_Received_Date__c from case where id=:supportId limit 1];
                                             if(caseRec.size()>0)
                                             {
                                                 crpRecdDate=caseRec[0].GA_Corporate_Received_Date__c;
                                             }
                                         }
                                         
                                         String asepRecId = BLANK;
                                         List<String> asepRecIdLst = new List<String>();
                                         
                                         if((lstGroupSegments.size() > 0)&&(subType == AGNTSLDENRLMNT)){
                                             for(GA_Group_Segment__c gs : [select id,GA_Agent_Sold_Group__r.GA_Managing_Agent_Sale_Enroll_Id__r.Id from GA_Group_Segment__c where id in: lstGroupSegments and (GA_SourceASG__c =  True) limit 200])
                                             {
                                                 if(!string.isBlank(gs.GA_Agent_Sold_Group__r.GA_Managing_Agent_Sale_Enroll_Id__r.Id)){
                                                     asepRecIdLst.add(gs.GA_Agent_Sold_Group__r.GA_Managing_Agent_Sale_Enroll_Id__r.Id);
                                                 }
                                                 
                                             }
                                             if(asepRecIdLst.size() > 0) {
                                                 asepRecId = asepRecIdLst[0];
                                             }  
                                         } 
                                         
                                         map<string, string> saveResults = GA_AP_01_WorkflowDetmntion.insertWfRec(new GA_WF_Workflow__c(Name = type + HYPNVAL + subType + HYPNVAL +Datetime.now().format(MNTHYRFRMT),
                                                                                                                                        GA_Account__c = accountId, 
                                                                                                                                        GA_Support__c =  (supportId <> '' ?supportId:null),  
                                                                                                                                        GA_Corporate_Received_Date__c=crpRecdDate,
                                                                                                                                        Sub_Type__c = subType,
                                                                                                                                        GA_Type__c = type,
                                                                                                                                        GA_Carrier__c = carrier,
                                                                                                                                        GA_Method__c = method,
                                                                                                                                        GA_Workflow_Template__c = objWorkflowTemplate.Id,
                                                                                                                                        GA_Status__c = QRYOPEN,
                                                                                                                                        ARV_Enrollment_Contract__c=contId,
                                                                                                                                        GA_Number_of_Group_Suffixes__c=lstGroupSegments.size(),
                                                                                                                                        GA_ASEP__c = (asepRecId <> '' ?asepRecId:null),
                                                                                                                                        GA_Date_Opened__c=system.today()));
                                         
                                         
                                         if(!string.isBlank(saveResults.get(IDVAL))){
                                             /*if(!lnchFrmAcc)
{
case cs=new case();
cs.id= supportId;
cs.Status=QRYCLOSED;
cs.GA_CloseStatus__c= CLSESTATUS;
cs.GA_Close_Comments__c= CLSECOMNTS;
database.update(cs);
}*/
                                             Id objWorkFlowId =saveResults.get(IDVAL); 
                                             
                                             //create workflow group segments 
                                             list<GA_WF_Group_Segment__c> lstWFGroupSegments = new list<GA_WF_Group_Segment__c>();
                                             list<GA_Certs_Rider_Process__c> lstWFCertsRider= new list<GA_Certs_Rider_Process__c>();
                                             list<GA_WF_Group_Segment__c> lstWFStepGroupSegments = new list<GA_WF_Group_Segment__c>();
                                             list<GA_Group_Segment__c> grpInprgssLst=new list<GA_Group_Segment__c>();
                                             GA_WF_Group_Segment__c wfGSTmpry = new GA_WF_Group_Segment__c();
                                             GA_Group_Segment__c gtpTmp =new GA_Group_Segment__c();
                                             for(string groupSegmentIds : lstGroupSegments){
                                                 wfGSTmpry = new GA_WF_Group_Segment__c(GA_Workflow_ID__c = objWorkFlowId,
                                                                                        GA_Group_Segment_ID__c = groupSegmentIds , 
                                                                                        GA_Date_Opened__c = CURRENTTIME,
                                                                                        GA_Date_Closed__c=CURRENTTIME,
                                                                                        GA_Status__c=QRYCLOSED
                                                                                       );
                                                 lstWFGroupSegments.add(wfGSTmpry);
                                                 gtpTmp=new GA_Group_Segment__c();
                                                 gtpTmp.Id=groupSegmentIds;
                                                 gtpTmp.GA_In_Progress__c=true;
                                                 gtpTmp.GA_In_Progress_Type__c=WFINPROGRESS;
                                                 gtpTmp.GA_Is_Mass_Updating__c=True;
                                                 grpInprgssLst.add(gtpTmp);
                                             }// end of for-each
                                             
                                             if(lstWFGroupSegments.size() > 0){
                                                 Database.insert(lstWFGroupSegments);  
                                             }
                                             GA_Certs_Rider_Process__c wfCertRidr = new GA_Certs_Rider_Process__c();
                                             for(GA_Certs_Riders__c CertsRider : [select id,Name from GA_Certs_Riders__c where GA_AssetId__r.GA_Plan_Package_Id__r.GA_Group_Segment__r.Id=:lstGroupSegments and GA_AssetId__r.GA_Plan_Package_Id__r.GA_ACTIVE_IND__c =: ACTV limit 8000])
                                             {
                                                 wfCertRidr=new GA_Certs_Rider_Process__c();
                                                 wfCertRidr.GA_Workflow__c=objWorkFlowId;
                                                 wfCertRidr.GA_Certs_Rider__c=CertsRider.Id;
                                                 wfCertRidr.GA_Date_Opened__c=CURRENTTIME;
                                                 wfCertRidr.GA_Date_Closed__c=CURRENTTIME;
                                                 wfCertRidr.GA_Status__c= QRYCLOSED;                                                    
                                                 lstWFCertsRider.add(wfCertRidr);
                                             }// end of for-each
                                             
                                             if(lstWFCertsRider.size() > 0){
                                                 Database.insert(lstWFCertsRider);  
                                             }
                                             
                                             
                                             if(grpInprgssLst.size()>0){
                                                 
                                                 GA_GS_AP02_Update_Address.isExecuting=true;
                                                 // GA_ExternlaAppleSrvcCls.isExecuting = true;
                                                 GA_GS_UpdateRatingType.isExecuting = true;
                                                 //GA_GroupSegmentTriggerHandler.beforeUpdateExecuting = true;
                                                 GA_GroupSegmentTriggerHandler.isExecuting = true;
                                                 GA_GS_AP04_UpdtStatus.isCnclGSChkd = true;
                                                 GA_GS_AP04_UpdtStatus.isExecuting = true;
                                                 // GA_GS_AP04_UpdtStatus.isInvoked = true;
                                                 GA_GS_UpdatWrappingFileTPA.isExecuting = true;
                                                 GA_GroupSegAccUpdateCls.isExecuting = true;
                                                 GA_ExternalAppealSrvcCls_MOS.isExecuting = true;
                                                 GA_GS_Insert_ThrdPartyBillerRecs.isExecuting = true;
                                                 GA_GS_Insert_ThrdPartyBillerRecs.isInvoked = true;
                                                 GA_ExternalAppealRecdCrtnUpdt.isExecuting = true;
                                                 
                                                 database.update(grpInprgssLst);
                                             }
                                             //get the preprocessing step for the workflow tempate.
                                             GA_WFT_Step__c objWFTPreprocessingStep = GA_AP_01_WorkflowDetmntion.getRelatedFirstWFStep(objWorkflowTemplate);
                                             map<id,id> gsParentWFPrcssMap=fetchParentWEFPrcess(objWorkFlowId);
                                             //create preprocessing step for the workflow with the selected group segments.
                                             GA_WF_Step__c objWFPreprocessingstep = new GA_WF_Step__c(Name = objWFTPreprocessingStep.GA_WFT_Inventory_Step_ID__r.Name,
                                                                                                      GA_WF_Workflow_ID__c = objWorkFlowId, 
                                                                                                      GA_WF_Template_Step__c = objWFTPreprocessingStep.Id,
                                                                                                      GA_Start__c = CURRENTTIME,
                                                                                                      GA_Status__c = QRYOPEN
                                                                                                     ); 
                                             Database.insert(objWFPreprocessingstep);
                                             
                                             //adding group segments to the workflow step. Not sure if its a good idea to use the same GA_WF_Group_Segment__c object for this. We might have
                                             // to create another junction object between Workflow Step and Group Segments.
                                             GA_WF_Group_Segment__c wfGSTmpory = new GA_WF_Group_Segment__c();
                                             for(string groupSegmentIds : lstGroupSegments){
                                                 wfGSTmpory = new GA_WF_Group_Segment__c(
                                                     GA_Workflow_ID__c = objWorkFlowId, 
                                                     GA_Group_Segment_ID__c = groupSegmentIds, 
                                                     GA_Quote_ID__c=gsIdMap.get(groupSegmentIds),
                                                     GA_WF_Step_ID__c = objWFPreprocessingstep.Id, GA_Date_Opened__c = CURRENTTIME,
                                                     GA_Parent_WF_Process__c=gsParentWFPrcssMap.get(groupSegmentIds));
                                                 lstWFStepGroupSegments.add(wfGSTmpory);
                                                 system.debug('wfGSTmpory ==>' + wfGSTmpory.GA_Quote_ID__c);
                                                 
                                             }// end of for-each
                                             Database.insert(lstWFStepGroupSegments);
                                             
                                             if(supportId <>null)
                                             {
                                                 // addFilestoWRflw(objWorkflowTemplate,supportId,objWorkFlowId);
                                             }
                                             return objWFPreprocessingstep.Id;
                                             //return objWorkFlowId;
                                             //return objWorkFlowId;
                                             
                                         }
                                         
                                         return null;
                                     }
                                     catch(exception e)
                                     {
                                         GA_LogExceptionCls.LogExcp(e, CLSNAME, WORKFLOWCONTROLLERMTHD);
                                         throw new AuraHandledException(ERRORMSG+EXCEPSEPARTR+e.getMessage()); 
                                     }
                                 }   //  end of insertWfRec
    /**
@Description: retrieveNextSteps() method 
@Name : retrieveNextSteps
@Param :Id workflowStepId
@Return :list<GA_WFT_Allowed_Next_Step__c>
@throws Exception : AuraHandledException;
// given a workflow step template id, this method returns the next steps
*/       
    @AuraEnabled
    public static list<GA_WFT_Allowed_Next_Step__c> retrieveNextSteps(Id workflowStepId){
        try{
            GA_WF_Step__c objWorkFlowStep = [SELECT GA_WF_Workflow_ID__c,GA_WF_Workflow_ID__r.Owner.UserRole.Name, GA_WF_Template_Step__c FROM GA_WF_Step__c WHERE Id = :workflowStepId Limit 200];
            //if workflow created by ASR then at any point of time if next steps has asr to modify then show
            //else alothough next steps has asr to modify dont show
            list<User_Step_Role_Mapping__mdt> usrstpRlsMap=[select id,GA_User_Role__c,GA_Step_Role__c from User_Step_Role_Mapping__mdt where GA_User_Role__c=:objWorkFlowStep.GA_WF_Workflow_ID__r.Owner.UserRole.Name limit 1];
            if(usrstpRlsMap.size()>0 && usrstpRlsMap[0].GA_Step_Role__c == PROFASR)
            {
                // if(usrstpRlsMap[0].GA_Step_Role__c == PROFASR)
                {
                    return GA_AP_02_WkflwstepDetmntion.wfallwdSteps(objWorkFlowStep.GA_WF_Template_Step__c);  
                }
                
            }
            else
            {
                list<GA_WFT_Allowed_Next_Step__c> alwdSTpLst=  new list<GA_WFT_Allowed_Next_Step__c>();  
                for(GA_WFT_Allowed_Next_Step__c allwstp:GA_AP_02_WkflwstepDetmntion.wfallwdSteps(objWorkFlowStep.GA_WF_Template_Step__c))
                {
                    if(allwstp.GA_Allowed_Next_Step_Name__c != ALLWDNXTSTPNME)
                    {
                        alwdSTpLst.add(allwstp);   
                    }
                }
                
                return alwdSTpLst;
            }
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, CLSNAME, WORKFLOWCONTROLLERMTHD);
            throw new AuraHandledException(ERRORMSG+EXCEPSEPARTR+e.getMessage()); 
        }
    }
    /**
@Description: retrieveCurrentStepGroupSegments() method 
@Name : retrieveCurrentStepGroupSegments
@Param :Id workflowStepId
@Return :list<GA_WF_Group_Segment__c>
@throws Exception : AuraHandledException;
//given a workflow step id, this method returns the associated wf group segments.
*/      
    @AuraEnabled
    public static list<GA_WF_Group_Segment__c> retrieveCurrentStepGroupSegments(Id workflowStepId){
        try{
            list<user> currUsr=[select id,profile.Name from user where id=:userInfo.getUserId() limit 1];
            list<GA_WF_Group_Segment__c> lstCurrentStepGroupSegments = New List<GA_WF_Group_Segment__c>() ;
            if(currUsr.size()>0 && currUsr[0].profile.Name==SYSADMN)
            {
                lstCurrentStepGroupSegments = [SELECT Id, GA_Group_Segment_ID__c,GA_Group_Segment_Id__r.Name,GA_Group_Segment_Name__c,GA_Processed_By__c,GA_WF_Step_ID__c,GA_Status__c,
                                               GA_Workflow_ID__c, GA_Workflow_Next_Step__c, GA_Workflow_Next_Step__r.Name,owner.type
                                               FROM GA_WF_Group_Segment__c 
                                               WHERE GA_WF_Step_ID__c = :workflowStepId
                                               Limit 200]; 
                
            }
            else
            {
                lstCurrentStepGroupSegments = [SELECT Id, GA_Group_Segment_ID__c,GA_Group_Segment_Id__r.Name,GA_Group_Segment_Name__c,GA_Processed_By__c,GA_WF_Step_ID__c,GA_Status__c,
                                               GA_Workflow_ID__c, GA_Workflow_Next_Step__c, GA_Workflow_Next_Step__r.Name,owner.type
                                               FROM GA_WF_Group_Segment__c 
                                               WHERE GA_WF_Step_ID__c = :workflowStepId and ownerId=:userinfo.getUserId()
                                               Limit 200]; 
                
            }
            return lstCurrentStepGroupSegments;
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, CLSNAME, WORKFLOWCONTROLLERMTHD);
            throw new AuraHandledException(ERRORMSG+EXCEPSEPARTR+e.getMessage()); 
        }
    }
    /**
@Description: retrieveCurrentStepGroupSegmentsInNextStep() method 
@Name : retrieveCurrentStepGroupSegmentsInNextStep
@Param :Id workflowStepId
@Return :list<GA_WF_Group_Segment__c>
@throws Exception : AuraHandledException;
*/      
    @AuraEnabled
    public static list<GA_WF_Group_Segment__c> retrieveCurrentStepGroupSegmentsInNextStep(Id workflowStepId){
        try{
            list<GA_WF_Group_Segment__c> lstCurrentStepGroupSegments = [SELECT Id, GA_Group_Segment_ID__c, GA_Group_Segment_Id__r.Name,  GA_WF_Step_ID__c, 
                                                                        GA_Workflow_ID__c, GA_Workflow_Next_Step__r.Name                                                                      
                                                                        FROM GA_WF_Group_Segment__c 
                                                                        WHERE GA_WF_Step_ID__c = :workflowStepId
                                                                        AND GA_Workflow_Next_Step__c != null 
                                                                        Limit 200]; 
            return lstCurrentStepGroupSegments;
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, CLSNAME, WORKFLOWCONTROLLERMTHD);
            throw new AuraHandledException(ERRORMSG+EXCEPSEPARTR+e.getMessage()); 
        }
    }
    /**
@Description: nextStepQueueInfo() method 
@Name : nextStepQueueInfo
@Param :Id currentWorkflowStepId, Id selectedWorkFlowTemplateStepId,
string selectedWorkFlowStepName, List<String> lstGroupSegments        
@Return :boolean
@throws Exception : AuraHandledException;
*/     
    @AuraEnabled
    public static boolean nextStepQueueInfo(Id currentWorkflowStepId, Id selectedWorkFlowTemplateStepId, string selectedWorkFlowStepName, List<String> lstGroupSegments){
        try{
            GA_WF_Step__c objCurrentWorkFlowStep = [SELECT Name,GA_WF_Workflow_ID__c, OwnerId,GA_WF_Template_Step__c,GA_WF_Template_Step__r.GA_WFT_Inventory_Step_ID__r.Name, 
                                                    GA_Tracking_Status__c,GA_Problem_Identified_Values__c,GA_Notes__c,
                                                    GA_WF_Workflow_ID__r.GA_Workflow_Template__c FROM GA_WF_Step__c WHERE Id = :currentWorkflowStepId Limit 200];
            GA_WFT_Step__c objNextWorkFlowTemplateStep = [SELECT Id, Name, GA_WFT_Inventory_Step_ID__r.Name FROM GA_WFT_Step__c WHERE Id = :selectedWorkFlowTemplateStepId Limit 200];
            boolean nxtqueInfo=GA_AP_WFQueueAssignment.chkQueueVal(objCurrentWorkFlowStep.GA_WF_Workflow_ID__r.GA_Workflow_Template__c ,objNextWorkFlowTemplateStep.GA_WFT_Inventory_Step_ID__r.Name,objCurrentWorkFlowStep.GA_WF_Workflow_ID__c,lstGroupSegments);
            
            if(objNextWorkFlowTemplateStep.GA_WFT_Inventory_Step_ID__r.Name == PROJSPRTTOREVW){
                nxtqueInfo = true;
            }
            return nxtqueInfo;
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, CLSNAME, WORKFLOWCONTROLLERMTHD);
            throw new AuraHandledException(ERRORMSG+EXCEPSEPARTR+e.getMessage()); 
        }
    }
    /**
@Description: saveNextStep() method 
@Name : saveNextStep
@Param :(Id currentWorkflowStepId, Id selectedWorkFlowTemplateStepId, string selectedWorkFlowStepName,
List<String> lstGroupSegments,string assGnOwnr       
@Return :Id
@throws Exception : AuraHandledException;
*/     
    @AuraEnabled
    public static Id saveNextStep(Id currentWorkflowStepId, Id selectedWorkFlowTemplateStepId, string selectedWorkFlowStepName, List<String> lstGroupSegments,string assGnOwnr,boolean sendMailVal,String notes)
    {
        try{
            list<GA_WF_Group_Segment__c> lstWFStepGroupSegments = new list<GA_WF_Group_Segment__c>();
            Map<Id,String> gsQuoteIdMap = new Map<Id,String>();
            GA_WF_Step__c objNextWorkFlowStep =New GA_WF_Step__c();
            String ownId = BLANK;
            String nxtWFStpId = BLANK;  
            Boolean nxtStpsExists = false;
            set<Id> removeGrpId = New Set<Id>();
            String grpNames = BLANK;
            // To-do refactor the code so that we don't need to execute below SOQL to get the Workflow Id based on the step Id
            GA_WF_Step__c objCurrentWorkFlowStep = [SELECT Name,GA_WF_Workflow_ID__c,GA_WF_Workflow_ID__r.OwnerId,GA_WF_Workflow_ID__r.GA_Workflow_Owner_Role__c, OwnerId,GA_WF_Template_Step__c,GA_WF_Template_Step__r.GA_WFT_Inventory_Step_ID__r.Name, 
                                                    GA_Tracking_Status__c,GA_Problem_Identified_Values__c,GA_Notes__c,GA_Work_Type__c,
                                                    GA_WF_Workflow_ID__r.GA_Workflow_Template__c FROM GA_WF_Step__c WHERE Id = :currentWorkflowStepId Limit 200];
            
            
            GA_WFT_Step__c objNextWorkFlowTemplateStep = [SELECT Id, Name, GA_WFT_Inventory_Step_ID__r.Name, GA_WFT_Workflow_ID__r.Name FROM GA_WFT_Step__c WHERE Id = :selectedWorkFlowTemplateStepId Limit 200];
            //added to capture parent workflow process
            map<id,id> gsParentWFPrcssMap=fetchParentWEFPrcess(objCurrentWorkFlowStep.GA_WF_Workflow_ID__c);
            //To fetch ownerid 
            {
                for(id grpid:lstGroupSegments)
                {
                    for(GA_WF_Group_Segment__c wfgst :  [SELECT Id, GA_Workflow_ID__c, GA_Group_Segment_ID__c,  GA_WF_Step_ID__c ,
                                                         GA_Workflow_Next_Step__c,GA_Workflow_Next_Step__r.GA_Status__c,GA_Workflow_Next_Step__r.GA_WF_Template_Step__c, GA_Group_Segment_Name__c FROM GA_WF_Group_Segment__c 
                                                         WHERE GA_Workflow_ID__c = :objCurrentWorkFlowStep.GA_WF_Workflow_ID__c Limit 1000]){
                                                             
                                                             if(objNextWorkFlowTemplateStep.GA_WFT_Inventory_Step_ID__r.Name== CMPLTE && grpid==wfgst.GA_Group_Segment_ID__c && wfgst.GA_Group_Segment_Name__c.contains('GS-') && objNextWorkFlowTemplateStep.GA_WFT_Workflow_ID__r.Name != 'ABR'){ // Added by Steve
                                                                 return currentWorkflowStepId;
                                                             }
                                                             
                                                             if(wfgst.GA_Workflow_Next_Step__r.GA_WF_Template_Step__c == selectedWorkFlowStepName 
                                                                && (wfgst.GA_Workflow_Next_Step__r.GA_Status__c == QRYOPEN || 
                                                                    objNextWorkFlowTemplateStep.GA_WFT_Inventory_Step_ID__r.Name==CMPLTE)
                                                               ){
                                                                   
                                                                   if(grpid==wfgst.GA_Group_Segment_ID__c)
                                                                   {
                                                                       nxtStpsExists = false;
                                                                       break;
                                                                   }
                                                                   nxtWFStpId = wfgst.GA_Workflow_Next_Step__c;  
                                                                   nxtStpsExists = true;   
                                                               }
                                                         }
                    if(!nxtStpsExists)
                    {
                        break;
                    }
                }
                
            }
            /*else
{
nxtStpsExists = false;
}*/         
            
            if(nxtStpsExists){
                if(objNextWorkFlowTemplateStep.GA_WFT_Inventory_Step_ID__r.Name== CMPLTE)
                {
                    GA_WF_Step__c wfStpCmp=new GA_WF_Step__c(); 
                    wfStpCmp.Id=nxtWFStpId;
                    wfStpCmp.GA_End_Time__c=CURRENTTIME;
                    database.update(wfStpCmp);
                }
                for(string groupSegmentIds : lstGroupSegments){
                    for(GA_WF_Group_Segment__c wfgst :  [SELECT Id, GA_Workflow_ID__c, GA_Group_Segment_ID__c,  GA_WF_Step_ID__c ,GA_Group_Segment_Name__c,GA_Notes__c,GA_Quote_ID__c, 
                                                         GA_Workflow_Next_Step__c,GA_Workflow_Next_Step__r.GA_Status__c,GA_Workflow_Next_Step__r.GA_WF_Template_Step__c FROM GA_WF_Group_Segment__c 
                                                         WHERE GA_Workflow_ID__c = :objCurrentWorkFlowStep.GA_WF_Workflow_ID__c Limit 1000]){
                                                             if(wfgst.GA_WF_Step_ID__c==currentWorkflowStepId)
                                                             {
                                                                 if(wfgst.GA_Group_Segment_ID__c == groupSegmentIds ){
                                                                     wfgst.GA_Workflow_Next_Step__c = nxtWFStpId;
                                                                     wfgst.GA_Date_Closed__c = CURRENTTIME;
                                                                     wfgst.GA_Status__c = QRYCLOSED;
                                                                     wfgst.GA_Notes__c =  MYDATE + SPACE + userinfo.getName() + SPACE + wfgst.GA_Group_Segment_Name__c +SPACE + notes + ( wfgst.GA_Notes__c <> null ? DLMTR + wfgst.GA_Notes__c : BLANK);//objCurrentWorkFlowStep.GA_Notes__c ;
                                                                     wfgst.GA_Tracking_Status__c =objCurrentWorkFlowStep.GA_Tracking_Status__c ;
                                                                     wfgst.GA_Problem_Identified_Values__c= objCurrentWorkFlowStep.GA_Problem_Identified_Values__c;
                                                                     wfgst.GA_Work_Type__c = wfgst.GA_Work_Type__c;
                                                                     //wfgst.GA_Quote_ID__c   = wfgst.GA_Quote_ID__c;
                                                                     grpNames = grpNames + wfgst.GA_Group_Segment_Name__c+ COMMA;
                                                                     lstWFStepGroupSegments.add(wfgst);
                                                                     system.debug('wfgst ==>' + wfgst.GA_Quote_ID__c);
                                                                 }  
                                                             }
                                                             
                                                         }
                }
                objNextWorkFlowStep = new GA_WF_Step__c(id  = nxtWFStpId); 
                if( String.isBlank(ownId)) {
                    ownId =  Userinfo.getUserId();}
            }
            else {
                // To-do refactor the code so that we don't have to get the template step Name, might be use the work flow to set it.
                objNextWorkFlowStep = new GA_WF_Step__c(Name = objNextWorkFlowTemplateStep.GA_WFT_Inventory_Step_ID__r.Name, //selectedWorkFlowStepName,
                                                        GA_WF_Workflow_ID__c = objCurrentWorkFlowStep.GA_WF_Workflow_ID__c,
                                                        GA_Work_Type__c = objCurrentWorkFlowStep.GA_Work_Type__c,
                                                        GA_WF_Template_Step__c = selectedWorkFlowTemplateStepId,
                                                        GA_Start__c =CURRENTTIME,
                                                        GA_Status__c = QRYOPEN); // ownerid = queuename , queueid = queue on workflow step 
                
                
                //Assignt owner to WF step
                if( String.isBlank(ownId)) {
                    ownId =  Userinfo.getUserId();
                    objNextWorkFlowStep.ownerId = Userinfo.getUserId();
                }
                else{
                    objNextWorkFlowStep.ownerId = Userinfo.getUserId();
                }
                if(objNextWorkFlowTemplateStep.GA_WFT_Inventory_Step_ID__r.Name== CMPLTE)
                {
                    objNextWorkFlowStep.GA_Status__c=QRYCLOSED;
                    objNextWorkFlowStep.GA_End_Time__c= CURRENTTIME;
                }
                Database.insert(objNextWorkFlowStep);
                
                
                //Map<Id,String> gsQuoteIdMap = new Map<Id,String>();
                for(GA_WF_Group_Segment__c objWFGroupSegment : [SELECT Id, GA_Workflow_ID__c, GA_Group_Segment_ID__c, GA_Quote_ID__c,  GA_WF_Step_ID__c, GA_Workflow_Next_Step__c, 
                                                                GA_Group_Segment_Name__c,GA_Notes__c FROM GA_WF_Group_Segment__c 
                                                                WHERE GA_WF_Step_ID__c = :currentWorkflowStepId
                                                                AND GA_Group_Segment_ID__c IN :lstGroupSegments Limit 200])
                {
                    objWFGroupSegment.GA_Workflow_Next_Step__c = objNextWorkFlowStep.Id;
                    objWFGroupSegment.GA_Date_Closed__c = CURRENTTIME;
                    objWFGroupSegment.GA_Status__c = QRYCLOSED;
                    objWFGroupSegment.GA_Notes__c =  MYDATE +SPACE+ userinfo.getName()+SPACE+ objWFGroupSegment.GA_Group_Segment_Name__c +  SPACE + notes + ( objWFGroupSegment.GA_Notes__c <> null ? DLMTR + objWFGroupSegment.GA_Notes__c  : BLANK);// objCurrentWorkFlowStep.GA_Notes__c ;
                    objWFGroupSegment.GA_Tracking_Status__c =objCurrentWorkFlowStep.GA_Tracking_Status__c ;
                    objWFGroupSegment.GA_Problem_Identified_Values__c= objCurrentWorkFlowStep.GA_Problem_Identified_Values__c;
                    objWFGroupSegment.GA_Work_Type__c = objCurrentWorkFlowStep.GA_Work_Type__c;
                    grpNames = grpNames + objWFGroupSegment.GA_Group_Segment_Name__c + COMMA;                    
                    gsQuoteIdMap.put(objWFGroupSegment.GA_Group_Segment_ID__c, objWFGroupSegment.GA_Quote_ID__c); //us 4114
                    lstWFStepGroupSegments.add(objWFGroupSegment);                   
                    system.debug('objWFGroupSegment ==>' + objWFGroupSegment.GA_Quote_ID__c);
                    
                }// end of for-each                
            }
            //query GA_WF_Group_Segment__c related to lstGroupSegments and workflowid is current workflow
            list<GA_WF_Group_Segment__c> wfGrpSgmntLst=[select id,GA_WF_Process_Owner_Initial__c,GA_WF_Step_ID__r.Name,GA_Group_Segment_ID__c from GA_WF_Group_Segment__c 
                                                        where GA_WF_Step_ID__r.Name=: objNextWorkFlowTemplateStep.GA_WFT_Inventory_Step_ID__r.Name and GA_Workflow_ID__c=:objCurrentWorkFlowStep.GA_WF_Workflow_ID__c Limit 200];
            
            
            set<id> grpSgmntId=new set<id>();
            Id wfGsId = null;
            for(GA_WF_Group_Segment__c grpSgmnt:wfGrpSgmntLst)
            {
                wfGsId = grpSgmnt.GA_Group_Segment_ID__c;
                grpSgmntId.add(wfGsId); 
            }
            list<GA_WF_Group_Segment__c> lstWFStepGroupSegmentsNew=new list<GA_WF_Group_Segment__c>();
            list<GA_Group_Segment__c> grpRemoveInprgrssLst=new list<GA_Group_Segment__c>();
            Map<string,string> wfGSMap = new Map<string,string> (); 
            for(GA_WF_Group_Segment__c wfgs : [select Id,Name,GA_Group_Segment_ID__c,GA_Workflow_ID__c,GA_Status__c,GA_Workflow_ID__r.GA_Workflow_Template_Name__c from GA_WF_Group_Segment__c where GA_Workflow_ID__c !=: (objCurrentWorkFlowStep.GA_WF_Workflow_ID__c) and GA_Group_Segment_ID__c IN: lstGroupSegments 
                                               and GA_Status__c =:OPN and GA_Workflow_ID__r.GA_Workflow_Template_Name__c !=: ABRTMPLT limit 500]){
                                                   wfGSMap.put(wfgs.GA_Group_Segment_ID__c,wfgs.GA_Workflow_ID__c);
                                               }
            
            GA_Group_Segment__c gtpTmp = New GA_Group_Segment__c();
            GA_WF_Group_Segment__c wfgrpSgmnt = New GA_WF_Group_Segment__c();
            for(string groupSegmentIds : lstGroupSegments){
                wfgrpSgmnt=new GA_WF_Group_Segment__c();
                wfgrpSgmnt.GA_Workflow_ID__c=  objCurrentWorkFlowStep.GA_WF_Workflow_ID__c;
                wfgrpSgmnt.GA_Group_Segment_ID__c = groupSegmentIds;
                wfgrpSgmnt.GA_Parent_WF_Process__c=gsParentWFPrcssMap.get(groupSegmentIds);
                wfgrpSgmnt.GA_WF_Step_ID__c = objNextWorkFlowStep.Id;
                wfgrpSgmnt.GA_Quote_ID__c = gsQuoteIdMap.get(groupSegmentIds);
                system.debug('wfgrpSgmnt ==>' + wfgrpSgmnt.GA_Quote_ID__c);
                wfgrpSgmnt.GA_Date_Opened__c = CURRENTTIME;
                wfgrpSgmnt.GA_Work_Type__c = objCurrentWorkFlowStep.GA_Work_Type__c;
                if(assGnOwnr != BLANK)
                {
                    wfgrpSgmnt.OwnerId= assGnOwnr; 
                }
                else
                {
                    wfgrpSgmnt.OwnerId = ownId;
                }
                
                if(objNextWorkFlowTemplateStep.GA_WFT_Inventory_Step_ID__r.Name== CMPLTE)
                {
                    wfgrpSgmnt.GA_Date_Closed__c=CURRENTTIME;
                    wfgrpSgmnt.GA_Status__c=QRYCLOSED;
                    
                    
                    gtpTmp=new GA_Group_Segment__c();
                    gtpTmp.Id=groupSegmentIds;
                    removeGrpId.add(groupSegmentIds);
                    if(!wfGSMap.keySet().contains(groupSegmentIds))
                    {   
                        gtpTmp.GA_In_Progress__c=false;
                        gtpTmp.GA_In_Progress_Type__c=BLANK;
                        gtpTmp.GA_Is_Mass_Updating__c=True;
                        grpRemoveInprgrssLst.add(gtpTmp);
                    }
                }
                if(grpSgmntId.contains(groupSegmentIds))
                {
                    wfgrpSgmnt.GA_Return_to_Step_Chk__c=true; 
                    wfgrpSgmnt.GA_Return_to_Step_Count__c=system.Math.floor((wfGrpSgmntLst.size()/grpSgmntId.size()))+1;
                }
                
                lstWFStepGroupSegmentsNew.add(wfgrpSgmnt);
            }// end of for-each
            //call queueassigmnet class here by sending lstWFStepGroupSegments
            list<GA_WF_Group_Segment__c> grpsgmntToUpsrt=new list<GA_WF_Group_Segment__c>();
            if(assGnOwnr != BLANK)
            {
                grpsgmntToUpsrt= lstWFStepGroupSegmentsNew;
            }
            else
            {
                grpsgmntToUpsrt=GA_AP_WFQueueAssignment.getWFProcssOwnerInfo(objCurrentWorkFlowStep.GA_WF_Workflow_ID__r.GA_Workflow_Template__c ,objNextWorkFlowTemplateStep.GA_WFT_Inventory_Step_ID__r.Name,objCurrentWorkFlowStep.GA_WF_Workflow_ID__c, 
                                                                             objCurrentWorkFlowStep.Name, objCurrentWorkFlowStep.GA_WF_Workflow_ID__r.OwnerId, lstWFStepGroupSegmentsNew,objCurrentWorkFlowStep.GA_WF_Workflow_ID__r.GA_Workflow_Owner_Role__c);
            }
            boolean ownrque=true;
            if(assGnOwnr == BLANK)
            {
                if(grpsgmntToUpsrt.size()>0)
                {
                    if(string.valueof(grpsgmntToUpsrt[0].ownerId).startswith(QUEVAL))
                    {
                        ownrque=true;
                    }
                    else
                    {
                        ownrque=false;   
                    }
                }
            }
            else
            {
                ownrque=true;
            }
            grpsgmntToUpsrt.addall(lstWFStepGroupSegments);
            Database.upsert(grpsgmntToUpsrt);
            List <GA_WF_Group_Segment__c> unassignedGrps = [select Id from GA_WF_Group_Segment__c where GA_WF_Step_ID__c = :currentWorkflowStepId AND GA_Workflow_Next_Step__c = NULL  Limit 200];
            GA_WF_Step__c wfstRec =New GA_WF_Step__c(id = currentWorkflowStepId);
            String currenttemplName = objCurrentWorkFlowStep.GA_WF_Template_Step__r.GA_WFT_Inventory_Step_ID__r.Name;
            if (unassignedGrps.isEmpty() ){                
                wfstRec.GA_Status__c = QRYCLOSED;
                wfstRec.GA_End_Time__c = CURRENTTIME;                
                wfstRec.GA_Notes__c =  MYDATE + SPACE + userinfo.getName() + SPACE + grpNames.removeEnd(COMMA)+ SPACE+ notes + (objCurrentWorkFlowStep.GA_Notes__c <>null ? DLMTR + objCurrentWorkFlowStep.GA_Notes__c  : BLANK) ;// objCurrentWorkFlowStep.GA_Notes__c ;;
            }
            else{
                wfstRec.GA_Notes__c =  MYDATE + SPACE + userinfo.getName() + SPACE + grpNames.removeEnd(COMMA)+ SPACE+ notes + (objCurrentWorkFlowStep.GA_Notes__c <>null ? DLMTR + objCurrentWorkFlowStep.GA_Notes__c  : BLANK) ;// objCurrentWorkFlowStep.GA_Notes__c ;;
            }
            Database.update(wfstRec); 
            if(grpRemoveInprgrssLst.size()>0)
            {
                GA_GS_AP02_Update_Address.isExecuting=true;
                // GA_ExternlaAppleSrvcCls.isExecuting = true;
                GA_GS_UpdateRatingType.isExecuting = true;
                // GA_GroupSegmentTriggerHandler.beforeUpdateExecuting = true;
                GA_GroupSegmentTriggerHandler.isExecuting = true;     
                GA_GS_AP04_UpdtStatus.isCnclGSChkd = true;
                GA_GS_AP04_UpdtStatus.isExecuting = true;
                // GA_GS_AP04_UpdtStatus.isInvoked = true;
                GA_GS_UpdatWrappingFileTPA.isExecuting = true; 
                GA_GroupSegAccUpdateCls.isExecuting = true;
                GA_ExternalAppealSrvcCls_MOS.isExecuting = true;
                GA_GS_Insert_ThrdPartyBillerRecs.isExecuting = true;
                GA_GS_Insert_ThrdPartyBillerRecs.isInvoked = true;
                GA_ExternalAppealRecdCrtnUpdt.isExecuting = true;
                
                database.update(grpRemoveInprgrssLst);
            }
            if(objNextWorkFlowTemplateStep.GA_WFT_Inventory_Step_ID__r.Name.equals(CMPLTE))
            {
                List<GA_WF_Step__c> wfstReclst = [select Id,GA_WF_Workflow_ID__c,GA_Status__c from GA_WF_Step__c 
                                                  where GA_WF_Workflow_ID__c =: objCurrentWorkFlowStep.GA_WF_Workflow_ID__c and GA_Status__c =: OPN Limit 200];
                if(wfstReclst.size()==0)  
                {
                    GA_WF_Workflow__c currStpWFObj = New  GA_WF_Workflow__c(id = objCurrentWorkFlowStep.GA_WF_Workflow_ID__c);
                    currStpWFObj.GA_Status__c = QRYCLOSED;
                    currStpWFObj.GA_Date_Closed__c=system.today();
                    database.update(currStpWFObj);
                }
            }
            if(assGnOwnr != BLANK && sendMailVal)
            {
                notifyUseAssigned(assGnOwnr,objCurrentWorkFlowStep.GA_WF_Workflow_ID__c);
            }
            if(assGnOwnr==BLANK)
            {
                if(objCurrentWorkFlowStep.Name == WRKFLWSTPNAME && objNextWorkFlowTemplateStep.GA_WFT_Inventory_Step_ID__r.Name != CRNTWRKFLWSTPNAME){
                    if(!ownrque)
                    {  return objNextWorkFlowStep.Id;}
                }
            }
            return objCurrentWorkFlowStep.GA_WF_Workflow_ID__c;
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, CLSNAME, WORKFLOWCONTROLLERMTHD);
            throw new AuraHandledException(ERRORMSG+EXCEPSEPARTR+e.getMessage()); 
        }
        
    }// end of saveNextStep
    
    /**
@Description: notifyUseAssigned() method 
@Name : notifyUseAssigned
@Param :string assignOwnr       
@Return :None
@throws Exception : AuraHandledException;
*/     
    public static void notifyUseAssigned(string assignOwnr,Id wfId)
    {
        try{
            String assgnWrkflwTmplt = [SELECT Id FROM EmailTemplate WHERE DeveloperName =:WFASSIGNEMAILTMPLT limit 1].Id;
            if(assignOwnr != BLANK)
            {
                Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
                // Set recipients to two contact IDs.
                // Replace IDs with valid record IDs in your org.
                // message.toAddresses = new String[] { MSGTOADRES };
                message.optOutPolicy = MSGFILTR;
                message.setTargetObjectId(assignOwnr);
                message.setTemplateId(assgnWrkflwTmplt);
                message.setWhatId(wfId);
                message.saveAsActivity=false;
                //message.subject = MSGSSUBJECT;
                //message.plainTextBody = MSGTXTBODY;
                Messaging.SingleEmailMessage[] messages = 
                    new List<Messaging.SingleEmailMessage> {message};
                        Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
                if (results[0].success) {
                    
                } else {
                    
                }   
            }
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, CLSNAME, WORKFLOWCONTROLLERMTHD);
            throw new AuraHandledException(ERRORMSG+EXCEPSEPARTR+e.getMessage()); 
        }
        
    }
    /**
@Description: isPreprocessingStep() method 
@Name : isPreprocessingStep
@Param :string workflowStepId      
@Return :boolean
@throws Exception : AuraHandledException;
*/       
    @AuraEnabled
    public static boolean isPreprocessingStep(string workflowStepId){
        try{
            list<GA_WF_Step__c> lstWorkFlowSteps = [SELECT Id, Name FROM GA_WF_Step__c WHERE Id = :workflowStepId Limit 200];
            if(lstWorkFlowSteps.size()>0 ){
                if(lstWorkFlowSteps[0].Name == WRKFLWSTPNAME){
                    return true;
                }
            }
            
            return false;
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, CLSNAME, WORKFLOWCONTROLLERMTHD);
            throw new AuraHandledException(ERRORMSG+EXCEPSEPARTR+e.getMessage()); 
        }
    }
    
    /**
*  Give a carrier this method returns types 
*  @name retrieveCarriers
*  @param string 
*  @return list<string> - list of Carriers
*/ 
    @AuraEnabled
    public static list<string> retrieveCarriers(){
        try
        {
            list<user> currUsr=[select id,profile.Name from user where id=:userInfo.getUserId() limit 1];
            list<string> lstCarrier= new list<string>{NONEVAL};
                
                for(Workflow_Picklists__mdt objMDT : [SELECT Settings_Type__c, Carrier__c, GA_Applicable_Profile__c  
                                                      FROM Workflow_Picklists__mdt
                                                      WHERE  Settings_Type__c =: CRRIER
                                                      AND Carrier__c !=: BLANK
                                                      Limit 200])
            {
                if(!string.isBlank(objMDT.Carrier__c) && !string.isBlank(objMDT.GA_Applicable_Profile__c)){
                    
                    list<string> prfnms=objMDT.GA_Applicable_Profile__c.split(SEMICOLON);
                    if(prfnms.contains(currUsr[0].profile.Name))
                    {
                        lstCarrier.add(objMDT.Carrier__c); 
                    }
                }
            }// end of for-each
            
            return lstCarrier;
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, CLSNAME, WORKFLOWCONTROLLERMTHD);
            throw new AuraHandledException(ERRORMSG+EXCEPSEPARTR+e.getMessage()); 
        }
    }// end of retrieveCarrier
    
    
    /**
*  Added by Srinivas Sattoor on 5.10.2018
*  Give a carrier this method returns types 
*  @name retrieveCarriers
*  @param string 
*  @return list<string> - list of types
*/ 
    @AuraEnabled
    public static list<string> retrieveTypes(string carrier){
        try
        {
            list<user> currUsr=[select id,profile.Name from user where id=:userInfo.getUserId() limit 1];
            list<string> lstTypes= new list<string>();
            
            for(Workflow_Picklists__mdt objMDT : [SELECT Settings_Type__c, Carrier__c, Type__c, GA_Applicable_Profile__c  
                                                  FROM Workflow_Picklists__mdt
                                                  WHERE Carrier__c =:carrier
                                                  AND Settings_Type__c = : typ
                                                  AND Carrier__c !=: BLANK
                                                  AND isInactive__c = false
                                                  AND Type__c !=: BLANK Limit 200])
            { 
                if(!string.isBlank(objMDT.Type__c) && !string.isBlank(objMDT.GA_Applicable_Profile__c)){
                    
                    list<string> prfnms=objMDT.GA_Applicable_Profile__c.split(SEMICOLON);
                    if(prfnms.contains(currUsr[0].profile.Name))
                    {
                        lstTypes.add(objMDT.Type__c); 
                    }
                }
            }// end of for-each
            
            return lstTypes;
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, CLSNAME, WORKFLOWCONTROLLERMTHD);
            throw new AuraHandledException(ERRORMSG+EXCEPSEPARTR+e.getMessage()); 
        }
    }// end of retrieveTypes
    
    /**
*  Added by Srinivas Sattoor on 5.10.2018
*  Give a carrier and type this method returns sub-types 
*  @name retrieveCarriers
*  @param string and string
*  @return list<string> - list of sub-types
*/ 
    @AuraEnabled
    public static list<string> retrieveSubTypes(string carrier, string type){
        try{
            list<user> currUsr=[select id,profile.Name,GA_RoleName__c from user where id=:userInfo.getUserId() limit 1];
            list<string> lstSubTypes= new list<string>();
            
            for(Workflow_Picklists__mdt objMDT : [SELECT Settings_Type__c, Carrier__c, GA_Applicable_Profile__c,GA_Restricted_Role__c,Type__c, Sub_Type__c
                                                  FROM Workflow_Picklists__mdt
                                                  WHERE Carrier__c =:carrier
                                                  AND Type__c =:type
                                                  AND Settings_Type__c =: SUBTYP
                                                  AND Carrier__c !=: BLANK
                                                  AND Type__c !=: BLANK Limit 200])
            { 
                if(!string.isBlank(objMDT.Sub_Type__c) && !string.isBlank(objMDT.GA_Applicable_Profile__c)){
                    list<string> prfnms=objMDT.GA_Applicable_Profile__c.split(SEMICOLON);
                    
                    if(prfnms.contains(currUsr[0].profile.Name))
                    {
                        if(!string.isBlank(objMDT.GA_Restricted_Role__c))
                        {
                            list<string> rstrtdRolenms=objMDT.GA_Restricted_Role__c.split(SEMICOLON);
                            
                            if(!rstrtdRolenms.contains(currUsr[0].GA_RoleName__c))
                            {
                                lstSubTypes.add(objMDT.Sub_Type__c); 
                            }
                        }
                        else{
                            lstSubTypes.add(objMDT.Sub_Type__c); 
                        }
                    }
                }
                
            }// end of for-each
            return lstSubTypes;
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, CLSNAME, WORKFLOWCONTROLLERMTHD);
            throw new AuraHandledException(ERRORMSG+EXCEPSEPARTR+e.getMessage()); 
        }
    }// end of retrieveSubTypes
    
    /**
*  Added by Srinivas Sattoor on 5.10.2018
*  Give a carrier, type and sub-type this method returns benefit selection methods 
*  @name retrieveCarriers
*  @param string and string
*  @return list<string> - list of benefit selection methods
*/ 
    @AuraEnabled
    public static list<string> retrieveBenefitSelectionMethods(string carrier, string type, string subType){
        try{
            list<user> currUsr=[select id,profile.Name from user where id=:userInfo.getUserId() limit 1];
            list<string> lstBenefitSelectionMethods= new list<string>();
            for(Workflow_Picklists__mdt objMDT : [SELECT Settings_Type__c,GA_Applicable_Profile__c, Carrier__c, Type__c, Sub_Type__c,
                                                  GA_Benefit_Selection_Method__c
                                                  FROM Workflow_Picklists__mdt
                                                  WHERE Carrier__c =:carrier
                                                  AND Type__c =:type
                                                  AND Sub_Type__c=:subType
                                                  AND Settings_Type__c =: METHD
                                                  AND Carrier__c !=: BLANK
                                                  AND Type__c !=: BLANK
                                                  AND Sub_Type__c !=: BLANK Limit 200])
            {
                if(!string.isBlank(objMDT.GA_Benefit_Selection_Method__c) && !string.isBlank(objMDT.GA_Applicable_Profile__c)){
                    list<string> prfnms=objMDT.GA_Applicable_Profile__c.split(SEMICOLON);
                    if(prfnms.contains(currUsr[0].profile.Name))
                    {
                        lstBenefitSelectionMethods.add(objMDT.GA_Benefit_Selection_Method__c); 
                    }
                }
                
            }
            
            return lstBenefitSelectionMethods;
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, CLSNAME, WORKFLOWCONTROLLERMTHD);
            throw new AuraHandledException(ERRORMSG+EXCEPSEPARTR+e.getMessage()); 
        }
    }// end of retrieveBenefitSelectionMethods
    /**
*  @name wfCreateAccssStpVls
*  @param string typeVal,string subtypeVal
*  @return boolean
*/     
    @AuraEnabled
    public static boolean wfCreateAccssStpVls(string typeVal,string subtypeVal)
    {
        try{
            list<Workflow_Picklists__mdt> wrkflCrtAcc=[select id, Type__c,GA_Profile_Name__c from Workflow_Picklists__mdt where Type__c=:typeVal and GA_Restrict_to_Profile__c=true and Settings_Type__c =:TYP Limit 200];
            list<Workflow_Picklists__mdt> wrkflSubTypeCrtAcc=[select id, Sub_Type__c, GA_Profile_Name__c from Workflow_Picklists__mdt where Sub_Type__c=:subtypeVal and GA_Restrict_to_Profile__c=true and Settings_Type__c =:SUBTYP Limit 200];
            
            if(wrkflCrtAcc.size()>0)
            {
                user usr=[select profile.Name from user where id=:userinfo.getuserId() limit 1];
                
                list<string> prfnms=wrkflCrtAcc[0].GA_Profile_Name__c.split(SEMICOLON);
                if(prfnms.contains(usr.profile.Name))
                {
                    return true;
                }
                else
                {   return false;}
            }
            if(wrkflSubTypeCrtAcc.size()>0)
            {
                user usr=[select profile.Name from user where id=:userinfo.getuserId() limit 1];
                
                list<string> prfnms=wrkflSubTypeCrtAcc[0].GA_Profile_Name__c.split(SEMICOLON);
                if(prfnms.contains(usr.profile.Name))
                {
                    return true;
                }
                else
                {
                    return false;
                }   
            }
            return true;
            
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, CLSNAME, WORKFLOWCONTROLLERMTHD);
            throw new AuraHandledException(ERRORMSG+EXCEPSEPARTR+e.getMessage()); 
        }
    }
    
    /**
*  @name processSelectedRecords
*  @param List<string> gsIdQte
*  @return NA
*/       
    @AuraEnabled
    Public static void processSelectedRecords(List<string> gsIdQte){
        try{
            Map<Id,String> gsIdMap = new Map<Id,String>();
            if(!gsIdQte.isEmpty()){
                List<String> res = New List<String>();
                for(string str : gsIdQte){
                    res = str.split(HYPHN, 2);
                    if(res.size()==2){
                        gsIdMap.put(res[0],res[1]);
                    }
                }
            }
            List<GA_Group_Segment__c> gsList = New List<GA_Group_Segment__c>();
            
            for(GA_Group_Segment__c gs : [select id, name , GA_Quote_ID__c from GA_Group_Segment__c Where id IN: gsIdMap.keySet() limit 4000])
            {
                if(gsIdMap.containsKey(gs.id)){
                    gs.GA_Quote_ID__c = gsIdMap.get(gs.id); 
                    gs.GA_Is_Mass_Updating__c = true;
                    gsList.add(gs); 
                }
            }
            if(!gsList.isEmpty()){
                Database.update(gsList, false);
            }
            
            
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, CLSNAME, WORKFLOWCONTROLLERMTHD);
            throw new AuraHandledException(ERRORMSG+EXCEPSEPARTR+e.getMessage()); 
        }
    }
    /**
*  @name fetchAccStatus
*  @param string recId,string objAPIName
*  @return Boolean
*/     
    @AuraEnabled
    public static Boolean fetchAccStatus(string recId,string objAPIName)
    {
        try
        {  
            string quryStng = BLANK;
            boolean isInactive = false;
            if(objAPIName == ACNTOBJNAME){
                quryStng = QRYACCSTATUS+objAPIName+QRYSMRTRECWHR+GA_Util08_FilterProcessHelper.FltrString(recId)+ QRYSMRTRECLMT;
                Sobject sobj = Database.query(quryStng);
                if( sobj.get(ACCSTSFLD) == INACTV){
                    isInactive =  true;
                    
                }
            }
            if(objAPIName == CSE){
                quryStng = SLTQRY+objAPIName+QRYSMRTRECWHR+GA_Util08_FilterProcessHelper.FltrString(recId)+ QRYSMRTRECLMT;
                
                Sobject sobj = Database.query(quryStng);
                String accStatus = (String) sobj.getSobject(ACNTOBJNAME).get(ACCSTSFLD);
                if( String.isNotEmpty(accStatus)  &&  accStatus == INACTV){
                    isInactive =  true;
                    
                }
            }
            return isInactive;
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, CLSNAME, WORKFLOWCONTROLLERMTHD);
            throw new AuraHandledException(ERRORMSG+EXCEPSEPARTR+e.getMessage()); 
        }
        return null;
    }
    /**
*  @name fetchParentWEFPrcess
*  @param string wfId
*  @return map<id,id>
*/     
    public static map<id,id> fetchParentWEFPrcess(string wfId)
    {
        try{
            map<id,id> grpPrntWfPrcssMap=new map<id,id>();
            for(GA_WF_Group_Segment__c wfGs:[select id,GA_Group_Segment_ID__c from GA_WF_Group_Segment__c 
                                             where GA_WF_Step_ID__c=null and GA_Workflow_ID__c=:wfId Limit 2000])
            {
                grpPrntWfPrcssMap.put(wfGs.GA_Group_Segment_ID__c,wfGs.id);
            }
            return grpPrntWfPrcssMap;
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, CLSNAME, WORKFLOWCONTROLLERMTHD);
            throw new AuraHandledException(ERRORMSG+EXCEPSEPARTR+e.getMessage()); 
        }
    }
    /**
@Description: saveStepNotes() method 
@Name : saveStepNotes
@Param : string wfStpId,string noteComments,List<String> grpIds
@Return : string
@throws Exception : ValidateException;
*/    
    @AuraEnabled
    public static String saveStepNotes(string wfStpId,List<String> grpIds,string noteComments){
        Boolean svNts = false;
        set<id> ownerIds=new set<id>();
        String grpNames = BLANK;
        Map<id,string> gsNameMap = new Map<id,string> ();
        String redirectId = wfStpId;
        for(GA_Group_Segment__c gsRec:[select Id,Name from GA_Group_Segment__c where ID IN: grpIds]){
            grpNames=grpNames+gsRec.Name+ COMMA; 
            gsNameMap.put(gsRec.Id,gsRec.Name);
        }
        GA_WF_Step__c udtWfStep = New GA_WF_Step__c();
        List<GA_WF_Step__c>  wfStp= [Select id,Name,GA_WF_Workflow_ID__c,GA_Notes__c,GA_End_Time__c from  GA_WF_Step__c 
                                     where id=: wfStpId Limit 1];
        if(!wfStp.isEmpty()){
            udtWfStep = New GA_WF_Step__c(id = wfStp[0].id);
            udtWfStep.GA_Notes__c = MYDATE + SPACE + userinfo.getName() + SPACE + grpNames.removeEnd(COMMA)+ SPACE+noteComments +' \r\n'+ ( wfStp[0].GA_Notes__c <> null ? DLMTR + wfStp[0].GA_Notes__c : BLANK) ;
            database.update(udtWfStep); 
        }
        redirectId = wfStp[0].GA_WF_Workflow_ID__c;
        
        list<GA_WF_Group_Segment__c> grpSgmntWFLst=new list<GA_WF_Group_Segment__c>(); 
        GA_WF_Group_Segment__c wfGrpsgmnt =new GA_WF_Group_Segment__c();
        
        Map<string,string> wfGSMap = new Map<string,string> (); 
        for(GA_WF_Group_Segment__c wfgst :  [select Id,Name,GA_Group_Segment_ID__c,GA_Workflow_ID__c,GA_Status__c,GA_Group_Segment_Name__c,
                                             GA_Workflow_ID__r.GA_Workflow_Template_Name__c,GA_Notes__c from GA_WF_Group_Segment__c 
                                             where  GA_Group_Segment_ID__c IN: grpIds and GA_Status__c =:OPN
                                             and GA_WF_Step_ID__c =: wfStpId
                                             limit 500]){
                                                 wfGrpsgmnt = new   GA_WF_Group_Segment__c(id =wfgst.id );
                                                 wfGrpsgmnt.GA_Notes__c =  MYDATE + SPACE + userinfo.getName() + SPACE + wfgst.GA_Group_Segment_Name__c +SPACE + noteComments +' \r\n'+ ( wfgst.GA_Notes__c <> null ? DLMTR + wfgst.GA_Notes__c : BLANK);//objCurrentWorkFlowStep.GA_Notes__c ;
                                                 grpSgmntWFLst.add(wfGrpsgmnt);  
                                             }
        if(!grpSgmntWFLst.isEmpty())
        {
            database.update(grpSgmntWFLst);   
        }
        return redirectId;
    }
}   //  end of WorkflowController