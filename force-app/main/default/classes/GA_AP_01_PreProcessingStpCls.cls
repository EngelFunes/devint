/*******************************************************************************************************************************************
@Author             :   Prasant ksatpathy
@Name               :   GA_AP_01_PreProcessingStpCls
@CreatedDate        :   4/13/2018
@Description        :   GA_AP_01_PreProcessingStpCls is for preprocessing step logic for workflow initiation.
@version            :   1.0  
*******************************************************************************************************************************************/
public with sharing class GA_AP_01_PreProcessingStpCls {    
    public Static Final string SELECTQURY='Select id,GA_Carrier__c,GA_Sub_Type__c,Requested_Cancellation_Date__c,Cancellation_Reason__c,GA_WF_Workflow_ID__r.GA_Account__c,GA_WF_Workflow_ID__c ,GA_WF_Workflow_ID__r.GA_Customer_Signed_Date__c,GA_WF_Workflow_ID__r.GA_Account__r.Name,GA_WF_Workflow_ID__r.GA_Support__c,GA_Current_User_Profile__c,'+
        'GA_WF_Workflow_ID__r.GA_Support__r.CaseNumber,GA_WF_Workflow_ID__r.GA_Support__r.GA_Corporate_Received_Date__c,GA_WF_Workflow_ID__r.GA_Support__r.GA_Quote_ID__c,'+
        'GA_WF_Workflow_ID__r.ARV_Enrollment_Contract__c,GA_WF_Workflow_ID__r.ARV_Enrollment_Contract__r.ContractNumber,'+
        'GA_WF_Workflow_ID__r.GA_Sold_After_3PM__c,GA_WF_Workflow_ID__r.GA_Corporate_Received_Date__c,GA_WF_Workflow_ID__r.GA_Benefit_Effective_Date__c,GA_WF_Workflow_ID__r.GA_Method__c,GA_WF_Workflow_ID__r.OwnerId,GA_WF_Workflow_ID__r.Owner.Name,GA_WF_Workflow_ID__r.GA_Date_Opened__c,'+
        'GA_WF_Workflow_ID__r.GA_Date_Closed__c,GA_WF_Workflow_ID__r.Name,GA_WF_Workflow_ID__r.GA_Notes__c,GA_Status__c,GA_Notes__c,'+
        '(select id,GA_Group_Segment_ID__r.Name,GA_Group_Segment_ID__r.GA_Group_Effective_Date__c,GA_Group_Segment_ID__r.GA_Rate_Renewal_Date__c,'+
        'GA_Group_Segment_ID__r.GA_Servicing_Agent__c,GA_Group_Segment_ID__r.GA_Group_Factor_Cluster_Code__c,'+
        'GA_Group_Segment_ID__r.GA_Customer_Signed_Date__c,GA_Group_Segment_ID__r.GA_Rating_Type__c,GA_Group_Segment_ID__c from GA_WF_Group_Segments__r limit 100)'+ 
        'from GA_WF_Step__c where ';
    public Static Final string WHERECLAUSE=' id in';
    public Static Final string LIMITCLAUSE='limit 1';
    public Static Final String PREPRSSING = 'Pre-Processing';
    public Static Final String EMPTY = '';
    public static final string wfStepAPINm = 'GA_WF_Step__c';
    public Static Final String WFOBJECT = 'GA_WF_Workflow__c';
    public static final string cancelReason = 'Cancellation_Reason__c';   
    private static list<GA_WF_Step__c> wkflwStepRecLst=new list<GA_WF_Step__c>();
    public Static Final string ERRORMSG='There is problem in fetching record';
    public Static Final string CLSNAME  ='GA_AP_01_PreProcessingStpCls';
    public Static Final String EXCEPSEPRATOR=': ';
    public Static Final string WORKFLOWRECINFO  ='wrkflowRecInfo';
    public Static Final string VALIDATIONCHK  = 'validationChk';
    public Static Final string SAVEWRKFLWREC  = 'SavewrkflowRec';
    public Static Final string ERRORMSGVAL='There is some issue in record. Please contact System administartor: Workflow Step database operation failed';
    
    
    /*************************************************************************************************************************************
@Description        :   wrkflowRecInfo() method 
@Name               :   wrkflowRecInfo
@Param              :   string wrfStepRecId
@Return             :   GA_WF_Step__c
@throws Exception   :   N/A;
*****************************************************************************************************************************************/  
    @AuraEnabled
    public static WorkflowWrapper  wrkflowRecInfo(string wrfStepRecId)
    {
        try{
            WorkflowWrapper workFlowWrp = new WorkflowWrapper();
            sObject sObj = Schema.getGlobalDescribe().get(wfStepAPINm).newSObject() ;
            
            set<id> wkflwStpIdSet=new set<id>();
            wkflwStpIdSet.add(wrfStepRecId);
            string wkflwStepIdString=GA_Util08_FilterProcessHelper.idSet(wkflwStpIdSet);
            wkflwStepRecLst=GA_Util03_WrkflwStpDataAccessHelper.fetchwrkflowStpsMap(SELECTQURY, 
                                                                                    WHERECLAUSE+wkflwStepIdString, 
                                                                                    GA_Util03_WrkflwDataAccessHelper.BLANK, 
                                                                                    LIMITCLAUSE).values();
            if(wkflwStepRecLst.size() > 0){
                workFlowWrp.workflowStep =  wkflwStepRecLst[0];
                workFlowWrp.cancelReasonOptions = GA_AP06_fetchPicklistValues.getselectOptions(sObj, cancelReason);
            }            
            return workFlowWrp;
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, CLSNAME, WORKFLOWRECINFO);
            throw new AuraHandledException(ERRORMSG+EXCEPSEPRATOR+e.getMessage());  
        }
    }
    
    /*************************************************************************************************************************************
@Description        :   validationChk() method 
@Name               :   validationChk
@Param              :   GA_WF_Step__c wKflwStepRec,list<GA_WF_Group_Segment__c> wKflwStepGrpRec
@Return             :   boolean
@throws Exception   :   N/A;
*****************************************************************************************************************************************/      
    @AuraEnabled
    public static boolean validationChk(GA_WF_Step__c wKflwStepRec,list<GA_WF_Group_Segment__c> wKflwStepGrpRec)
    {
        try
        {
            list<string> customMessge=new list<string>();
            boolean resp = false;
            List<GA_AP_ShowValidationMessages.errormessage> errmsgs = New   List<GA_AP_ShowValidationMessages.errormessage>();
            errmsgs = GA_AP_ShowValidationMessages.wrktStepValidatePrepocessing(wKflwStepRec.id);        
            if(errmsgs.size() > 0)
            {
                resp = true;
            }
            else
            {                
                resp = false;
            }
            
            return resp;
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, CLSNAME, VALIDATIONCHK);
            throw new AuraHandledException(ERRORMSG+EXCEPSEPRATOR+e.getMessage());  
        }
        
    }
    /*************************************************************************************************************************************
@Description        :   SavewrkflowRec() method 
@Name               :   SavewrkflowRec
@Param              :   GA_WF_Step__c workflowStpRec,boolean stpCmp,boolean clckComplete
@Return             :   boolean
@throws Exception   :   N/A;
*****************************************************************************************************************************************/  
    @AuraEnabled
    public static Boolean savewrkflowRec(GA_WF_Step__c workflowStpRec,boolean stpCmp,boolean clckComplete){
        try{
            Boolean errExists = false;
            GA_WF_Workflow__c wrkflw=new GA_WF_Workflow__c();
            wrkflw.id=workflowStpRec.GA_WF_Workflow_ID__c;
            wrkflw.GA_Notes__c=workflowStpRec.GA_WF_Workflow_ID__r.GA_Notes__c;
            
            //wrkflw.GA_Sold_After_3PM__c=workflowStpRec.GA_WF_Workflow_ID__r.GA_Sold_After_3PM__c;
            wrkflw.GA_Benefit_Effective_Date__c=workflowStpRec.GA_WF_Workflow_ID__r.GA_Benefit_Effective_Date__c;
            wrkflw.GA_Corporate_Received_Date__c= workflowStpRec.GA_WF_Workflow_ID__r.GA_Corporate_Received_Date__c; 
            wrkflw.GA_Customer_Signed_Date__c =  workflowStpRec.GA_WF_Workflow_ID__r.GA_Customer_Signed_Date__c; 
            database.update(wrkflw);
            
            GA_WF_Step__c wrkflwStp=workflowStpRec;
            // wrkflwStp.GA_Notes__c=workflowStpRec.GA_WF_Workflow_ID__r.GA_Notes__c; 
            
            GA_AP05_UpdateStpDtsOnWFGS.updateWFGSdtls(wrkflwStp);
            
            List<GA_AP_ShowValidationMessages.errormessage> errmsgs = New   List<GA_AP_ShowValidationMessages.errormessage>();
            errmsgs = GA_AP_ShowValidationMessages.wrktStepValidatePrepocessing(wrkflwStp.id);
            
            if(!errmsgs.isempty()){
                errExists =true;             
            }   
            database.update(wrkflwStp);
            
            return errExists;
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, CLSNAME, SAVEWRKFLWREC);
            throw new AuraHandledException(ERRORMSGVAL);  
        }
    }
    
    public class WorkflowWrapper {
        @AuraEnabled
    	public GA_WF_Step__c workflowStep = new GA_WF_Step__c();
        
        @AuraEnabled
        public List<String> cancelReasonOptions = new List<String>();
    }
    
}