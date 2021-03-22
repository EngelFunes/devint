/*******************************************************************************************************************************
@Author             :   Prasant ksatpathy
@Name               :   GA_AP_HightlightPanelCls
@CreatedDate        :   4/25/2018
@Description        :   GA_AP_HightlightPanelCls is for improving view of highlight panel.
@version            :   1.0  
********************************************************************************************************************************/
public with sharing class GA_AP_HightlightPanelCls {
    
    public static final string selectQuery='Select id,GA_WF_Workflow_ID__r.GA_Type__c,GA_WF_Workflow_ID__r.Sub_Type__c,GA_WF_Workflow_ID__r.GA_Carrier__c,GA_WF_Workflow_ID__r.GA_Method__c,GA_WF_Workflow_ID__r.ownerId,GA_WF_Workflow_ID__r.owner.Name,GA_WF_Workflow_ID__r.Name,GA_WF_Workflow_ID__r.GA_Account__c,GA_WF_Workflow_ID__r.GA_Account__r.Name from GA_WF_Step__c where ';
    public static final string whereClause=' id in';
    public static final string limitClause='limit 1';
    public static final string ErrorMsg='There is problem in fetching records';
    public static final string ClsName  ='GA_AP_HightlightPanelCls';
    public static final String excepSepartr=': ';
     public static final string wKflwStpRecInfo  ='wKflwStpRecInfo';

    /*******************************************************************************************************************************
@Description        :   wKflwStpRecInfo() method 
@Name               :   wKflwStpRecInfo
@Param              :   id wrfStepRecId
@Return             :   GA_WF_Step__c
@throws Exception   :   N/A;
********************************************************************************************************************************/    
    @AuraEnabled
    public static GA_WF_Step__c wKflwStpRecInfo(id wrfStepRecId)
    {
        try{
        set<id> wkflwStpIdSet=new set<id>();
        wkflwStpIdSet.add(wrfStepRecId);
        string wkflwStepIdString=GA_Util08_FilterProcessHelper.idSet(wkflwStpIdSet);
        list<GA_WF_Step__c> wKflwStepRecLst=GA_Util03_WrkflwStpDataAccessHelper.fetchwrkflowStpsMap(selectQuery, 
                                                                                             whereClause+wkflwStepIdString, 
                                                                                             GA_Util03_WrkflwDataAccessHelper.BLANK, 
                                                                                             limitClause).values();
        return wKflwStepRecLst[0];
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, ClsName, wKflwStpRecInfo);
            throw new AuraHandledException(ErrorMsg+excepSepartr+e.getMessage());  
        }
    }
}