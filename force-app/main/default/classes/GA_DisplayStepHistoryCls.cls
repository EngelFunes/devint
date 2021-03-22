/*****************************************************************************************
Class Name   : GA_DisplayStepHistoryCls
Date Created : 10/05/2017
Created By   : IDC Offshore
Description  : 1. This is controller class to fetch Workflow history
******************************************************************************************/
public class GA_DisplayStepHistoryCls {
    
    public static final string hyphenVal='-';
    public static final string ClsName = 'GA_DisplayStepHistoryCls';
    public static final string fetchwrkStpRec = 'fetchwrkStpRec';
    public static final string ErrorMsg = 'There is some problem in fetching workflow history';
    public static final string excepSepartr = ' : ';
    public static final string SelectWfStpQry = 'select Id,Name,'+
        '(select GA_Group_Segment_ID__r.Name, GA_Group_Segment_ID__c, GA_Workflow_Next_Step__r.Name,owner.Name from GA_WF_Group_Segments__r),'+
        'GA_Status__c,GA_Start__c,GA_End_Time__c,GA_WF_Workflow_ID__r.GA_Status__c,OwnerId,Owner.Name,GA_Notes__c '+
        ' from GA_WF_Step__c where ';
    public static final string wherewfid = ' GA_WF_Workflow_ID__c = ';//: wrkflwId 
    public static final string orderstrtDt = ' order by GA_Start__c desc ';
    public static final string limitClause = ' Limit 1000';
    public static final string SelectWFQuery = 'Select Id,Name,GA_Status__c,GA_Support__r.CaseNumber,GA_Support__r.Id,GA_Account_Benefit_Review__c,GA_Account_Benefit_Review__r.Name,'+
        'GA_Account__r.Name,GA_Account__r.Id,GA_Workflow_Owner__c,GA_WorkflowOwner__r.Name,owner.Name from GA_WF_Workflow__c where ';
    public static final String whereId = 'id =';
    public static final String  limitStr = ' Limit 1';
    public static final String SelectPreprocessQry = 'SELECT Id, GA_Status__c FROM GA_WF_Step__c WHERE ';
    
    public static final String wherwfStpTmpNm = ' AND GA_WF_Template_Step__r.Name = ';
    public static final string preprocessing = 'Pre-Processing';
    public static final string completed = 'Completed';
    public static final string Canceled = 'Cancel';
    public static final string CancelStp = 'Canceled';
    /**
@Description: fetchwrkStpRec() method 
@Name : fetchwrkStpRec
@Param :string wrkflwId
@Return : list<wrkflwStpHstryWrp>
@throws Exception : AuraHandledException;
*/    
    @AuraEnabled
    public static list<wrkflwStpHstryWrp> fetchwrkStpRec(string wrkflwId)
    {
        try{
            list<wrkflwStpHstryWrp> wrkflwStpHstryWrpLst=new list<wrkflwStpHstryWrp>();
            list<GA_WF_Step__c> wrkdflowStpLst=GA_Util03_WrkflwStpDataAccessHelper.fetchwrkflowStpsMap(SelectWfStpQry,
                                                                                                       wherewfid + GA_Util08_FilterProcessHelper.FltrString(wrkflwId),
                                                                                                       orderstrtDt, 
                                                                                                       limitClause).values();
            /** [select Id,Name,
(select GA_Group_Segment_ID__r.Name, GA_Group_Segment_ID__c, GA_Workflow_Next_Step__r.Name,owner.Name from GA_WF_Group_Segments__r),
GA_Status__c,GA_Start__c,GA_End_Time__c,GA_WF_Workflow_ID__r.GA_Status__c,OwnerId,Owner.Name,GA_Notes__c 
from GA_WF_Step__c where GA_WF_Workflow_ID__c =: wrkflwId order by GA_Start__c asc Limit 1000]; **/
            wrkflwStpHstryWrp wrkflwHstryCnl;
            wrkflwStpHstryWrp wrkflwHstryCmp;
            for(GA_WF_Step__c wfstp:wrkdflowStpLst)
            {
                List<string> grpSgmnets=New List<String>();
                List<string> nxtStps=New List<String>();
                
                List<String> ownernames =  New List<String>();
                if(wfstp.GA_WF_Group_Segments__r.size()>0)
                {
                    for(integer i=0;i<wfstp.GA_WF_Group_Segments__r.size();i++)
                    {
                        string grpSegment=wfstp.GA_WF_Group_Segments__r[i].GA_Group_Segment_ID__r.Name;
                        string nextstep = '';
                        string owner = '';
                        if (wfstp.GA_WF_Group_Segments__r[i].GA_Workflow_Next_Step__c != NULL || wfstp.Name==CancelStp) 
                        {
                            grpSegment = grpSegment ;
                            if(wfstp.GA_WF_Group_Segments__r[i].GA_Workflow_Next_Step__c != NULL)
                                nextstep = nextstep + wfstp.GA_WF_Group_Segments__r[i].GA_Workflow_Next_Step__r.Name ;
                            owner = owner +  wfstp.GA_WF_Group_Segments__r[i].owner.Name ;
                        }
                        grpSgmnets.add(grpSegment);
                        nxtStps.add(nextstep); 
                        ownernames.add(owner);
                        
                    }
                }
                
                List<String> liststpStrings = new List<String>(nxtStps);
                List<String> processedBy = New List<String>(ownernames);
                if(wfstp.Name!=CancelStp && wfstp.Name!=completed)
                {
                wrkflwStpHstryWrp wrkflwHstry=new wrkflwStpHstryWrp(wfstp.Name,grpSgmnets,liststpStrings,processedBy,
                                                                    wfstp.GA_Start__c,
                                                                    wfstp.GA_End_Time__c,
                                                                    wfstp.GA_Status__c,
                                                                    wfstp.GA_WF_Workflow_ID__r.GA_Status__c,
                                                                    wfstp.Id,
                                                                    wfstp.OwnerId,
                                                                    wfstp.Owner.Name,
                                                                    wfstp.GA_Notes__c);
                wrkflwStpHstryWrpLst.add(wrkflwHstry);
                }
                if(wfstp.Name==CancelStp)
                {
                 wrkflwHstryCnl=new wrkflwStpHstryWrp(wfstp.Name,grpSgmnets,liststpStrings,processedBy,
                                                                    wfstp.GA_Start__c,
                                                                    wfstp.GA_End_Time__c,
                                                                    wfstp.GA_Status__c,
                                                                    wfstp.GA_WF_Workflow_ID__r.GA_Status__c,
                                                                    wfstp.Id,
                                                                    wfstp.OwnerId,
                                                                    wfstp.Owner.Name,
                                                                    wfstp.GA_Notes__c); 
                }
                if(wfstp.Name==completed)
                {
                    wrkflwHstryCmp=new wrkflwStpHstryWrp(wfstp.Name,grpSgmnets,liststpStrings,processedBy,
                                                                    wfstp.GA_Start__c,
                                                                    wfstp.GA_End_Time__c,
                                                                    wfstp.GA_Status__c,
                                                                    wfstp.GA_WF_Workflow_ID__r.GA_Status__c,
                                                                    wfstp.Id,
                                                                    wfstp.OwnerId,
                                                                    wfstp.Owner.Name,
                                                                    wfstp.GA_Notes__c); 
                }
            }
            if(wrkflwHstryCnl !=null && wrkflwHstryCmp==null)
            {
                wrkflwStpHstryWrpLst.add(0,wrkflwHstryCnl);
            }
            if(wrkflwHstryCnl ==null && wrkflwHstryCmp!=null)
            {
                wrkflwStpHstryWrpLst.add(0,wrkflwHstryCmp);
            }
            if(wrkflwHstryCnl !=null && wrkflwHstryCmp!=null)
            {
                wrkflwStpHstryWrpLst.add(0,wrkflwHstryCmp);
                wrkflwStpHstryWrpLst.add(1,wrkflwHstryCnl);
            }
            return wrkflwStpHstryWrpLst;
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, ClsName, fetchwrkStpRec);
            throw new AuraHandledException(ErrorMsg+excepSepartr+e.getMessage()); 
        }
    }
    /**
@Description: fetchWFName() method 
@Name : fetchWFName
@Param :String wrkflwId
@Return : GA_WF_Workflow__c 
@throws Exception : NA;
*/ 
    @AuraEnabled
    public static GA_WF_Workflow__c fetchWFName(String wrkflwId)
    {
        try
        {
            GA_WF_Workflow__c wfRec = New GA_WF_Workflow__c();
            if(String.isNotEmpty(wrkflwId))
                wfRec = GA_Util03_WrkflwDataAccessHelper.fetchwrkflowMap(SelectWFQuery, 
                                                                         whereId + GA_Util08_FilterProcessHelper.FltrString(wrkflwId), 
                                                                         GA_Util03_WrkflwDataAccessHelper.BLANK,
                                                                         limitStr).values();
            
            //[Select Id,Name,GA_Status__c,GA_Support__r.CaseNumber,GA_Support__r.Id,GA_Account__r.Name,GA_Account__r.Id,GA_Workflow_Owner__c,GA_WorkflowOwner__r.Name,owner.Name from GA_WF_Workflow__c where id =: wrkflwId];
            return wfRec;  
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, ClsName, fetchwrkStpRec);
            throw new AuraHandledException(ErrorMsg+excepSepartr+e.getMessage());  
        }
    }
    
    /**
@Description: wrkflwStpHstryWrp() wrapper class 
@Name : wrkflwStpHstryWrp
*/ 
    public class wrkflwStpHstryWrp
    {
        @AuraEnabled
        public string Name;
        @AuraEnabled
        public List<String> grpSgmnts;
        @AuraEnabled
        public List<String> nextStps;
        @AuraEnabled
        public List<String> processBy;      
        @AuraEnabled
        public datetime StartCol;
        @AuraEnabled
        public datetime EndCol;
        @AuraEnabled
        public string StepStatus; 
        @AuraEnabled
        public string WrkflwStatus; 
        @AuraEnabled
        public string WrkflwStpId; 
        @AuraEnabled
        public string ProcessedBy;
        @AuraEnabled
        public string ProcessedById;
        @AuraEnabled
        public string Notes;
        
        public wrkflwStpHstryWrp(string NameTmp,List<string> grpSgmntsTmp,List<String> nextStpsTmp,List<string>  processByTmp, datetime StartColTmp,
                                 datetime EndColTmp, string StepStatusTmp, 
                                 string WrkflwStatusTmp,String WrkflwStpIdTmp,string ProcessedByIdTmp,string ProcessedByTmp,string NotesTmp)
        {
            Name=NameTmp;
            grpSgmnts=grpSgmntsTmp;           
            nextStps=nextStpsTmp;
            processBy = processByTmp;
            StartCol=StartColTmp;
            EndCol=EndColTmp;
            StepStatus=StepStatusTmp;
            WrkflwStatus=WrkflwStatusTmp;
            WrkflwStpId = WrkflwStpIdTmp;
            ProcessedById=ProcessedByIdTmp;
            ProcessedBy=ProcessedByTmp;
            Notes=NotesTmp;
        }
    }
    /**
@Description: isPreprocessingStepIsComplete() method 
@Name : isPreprocessingStepIsComplete
@Param :String wrkflwId
@Return : boolean 
@throws Exception : NA;
*/ 
    @AuraEnabled
    public static boolean isPreprocessingStepIsComplete(string wrkflwId){
        
        list<GA_WF_Step__c> lstWorkFlowSteps = GA_Util03_WrkflwStpDataAccessHelper.fetchwrkflowStpsMap(SelectWfStpQry,
                                                                                                       wherewfid + GA_Util08_FilterProcessHelper.FltrString(wrkflwId) +
                                                                                                       wherwfStpTmpNm + GA_Util08_FilterProcessHelper.FltrString(preprocessing),
                                                                                                       GA_Util03_WrkflwStpDataAccessHelper.BLANK, 
                                                                                                       GA_Util03_WrkflwStpDataAccessHelper.BLANK).values();
        
        //[SELECT Id, GA_Status__c FROM GA_WF_Step__c WHERE GA_WF_Workflow_ID__c =: wrkflwId  AND GA_WF_Template_Step__r.Name = 'Pre-Processing'];
        
        if(lstWorkFlowSteps.size()>0 && lstWorkFlowSteps[0].GA_Status__c == completed) { 
            return false; 
        }
        
        return false;
        
        
    } // end of isPreprocessingStepIsComplete
    
    
    
}