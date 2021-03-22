/***************************************************************************************************************************
Class Name   : GA_AP_ShowGrpSgmntWFCls
Date Created : 10/05/2017
Created By   : IDC Offshore
Description  : 1. This is controller class to fetch Workflow Group segment list and to display.
*****************************************************************************************************************************/
public with sharing class GA_AP_ShowGrpSgmntWFCls { 
    
    public Static Final string ERRORMSG='Unable to fetch Workflow information';
    public Static Final string SELECTWFWUERY = 'Select Id,Name,GA_Status__c,GA_Support__r.CaseNumber,GA_Support__r.Id,'+
        'GA_Account__r.Name,GA_Account__r.Id,GA_Workflow_Owner__c,GA_WorkflowOwner__r.Name,'+
        'owner.Name from GA_WF_Workflow__c where ';
    public Static Final String WHEREID = 'id =';
    public Static Final String  LIMITSTR = ' Limit 1';
    public Static Final string SELECTWFPQURY = 'select Name,GA_Group_Segment_ID__c,GA_Group_Segment_ID__r.Name,GA_Workflow_ID__r.Name,GA_Workflow_ID__c,'+
        'GA_Workflow_ID__r.GA_Date_Closed__c,GA_Workflow_ID__r.GA_Date_Opened__c,GA_Workflow_ID__r.GA_Status__c,'+
        'GA_Account__c,GA_Support_Request__c,GA_Workflow_ID__r.GA_Support__r.CaseNumber,GA_Sub_Type__c,GA_Type__c from GA_WF_Group_Segment__c where ';
    public Static Final String WHEREGSID = 'GA_Group_Segment_ID__c =';
    public Static Final String ANDINQ = 'AND';
    public Static Final String WHERESTPID = 'GA_WF_Step_ID__c = null';
    public Static Final String WHERESTPID1 = 'GA_IsfirstStep__c = TRUE';
    public Static Final string  ORDERWFDTOP = ' order by  GA_Workflow_ID__r.GA_Date_Opened__c desc';
    public Static Final String  LIMITSTRWP = ' Limit 2000';	
    /*******************************************************************************************************************
@Description: fetchWFlst() method 
@Name : fetchWFlst
@Param : NA
@Return : list<GA_WF_Group_Segment__c> 
@throws Exception : NA;
*****************************************************************************************************************************/     
    @AuraEnabled
    public static list<GA_WF_Group_Segment__c> fetchWFlst(string GrpSgmntId)
    {
        try
        {
            Set<id>SetWorkflowIDunique = new Set <id>();
            list<GA_WF_Group_Segment__c> wrkdflowGrpPrssLst = (GA_Util15_WFGSDataAccesHelper.fetchwrkflwGrpSgmMap(SELECTWFPQURY,  WHEREGSID + GA_Util08_FilterProcessHelper.FltrString(GrpSgmntId) + GA_Util15_WFGSDataAccesHelper.BLANK +ANDINQ + GA_Util15_WFGSDataAccesHelper.BLANK + WHERESTPID1, ORDERWFDTOP, LIMITSTRWP)).values();
            List<GA_WF_Group_Segment__c> wrkdflowGrpPrssLstClone = new List <GA_WF_Group_Segment__c>();
            
            for (GA_WF_Group_Segment__c gfw : wrkdflowGrpPrssLst)
            {
                if (!SetWorkflowIDunique.contains(gfw.GA_Workflow_ID__c))
                {
                    wrkdflowGrpPrssLstClone.add(gfw);
                }
                SetWorkflowIDunique.add(gfw.GA_Workflow_ID__c);
            }
            return wrkdflowGrpPrssLstClone;
            
        }
        catch(exception e)
        {	
            throw new AuraHandledException(ERRORMSG);
        }
    }
    
    /*******************************************************************************************************************
@Description: fetchWFName() method 
@Name : fetchWFName
@Param : NA
@Return : GA_WF_Workflow__c 
@throws Exception : NA;
*****************************************************************************************************************************/ 
    @AuraEnabled
    public static GA_WF_Workflow__c fetchWFName(String wrkflwId)
    {
        try
        {
            GA_WF_Workflow__c wfRec = New GA_WF_Workflow__c();
            if(String.isNotEmpty(wrkflwId))
            {
                wfRec = GA_Util03_WrkflwDataAccessHelper.fetchwrkflowMap(SELECTWFWUERY, 
                                                                         WHEREID + GA_Util08_FilterProcessHelper.FltrString(wrkflwId), 
                                                                         GA_Util03_WrkflwDataAccessHelper.BLANK,
                                                                         LIMITSTR).values();
            }
            
            return wfRec;  
        }
        catch(exception e)
        {	
            throw new AuraHandledException(ERRORMSG);
        }
    } 
}