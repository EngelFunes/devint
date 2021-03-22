/*****************************************************************************************
Class Name   : GA_AP_02_WkflwstepDetmntion
Date Created : 10/05/2017
Created By   : IDC Offshore
Description  : 1. GA_AP_02_WkflwstepDetmntion class is to determine the worklfow steps. 
******************************************************************************************/
public with sharing class GA_AP_02_WkflwstepDetmntion {
    // public static final string selectQuery='Select Id,Name,GA_WFT_Prev_Step_Pool_ID__c,GA_WFT_Step_ID__c,GA_WFT_Step_Pool_ID__c from GA_WFT_Allowed_Next_Step__c where ';
    public static final string selectQuery='Select Id,Name,GA_WFT_Parent_Step_ID__c, GA_Allowed_Next_Step_Name__c, GA_Allowed_Next_Step__c,GA_Conditional_Application_1__c,GA_Allowed_Next_Step__r.GA_Role__c,GA_Allowed_Next_Step__r.GA_Department__c from GA_WFT_Allowed_Next_Step__c where ';
    public static final string whereClause='GA_WFT_Parent_Step_ID__c in ';
    public static final string limitClause=' limit 100';
    public static final String ErrMsg = 'Could not perform the actions :';
    public static final String ClsName  ='GA_AP_02_WkflwstepDetmntion';
    public static final String method1  ='wfallwdSteps';
    //	To return list of next allowed steps for the workflow by calling wfallwdSteps method.
    /*************************************************************************************************************************************
@Description        :   wfallwdSteps() method 
@Name               :   wfallwdSteps
@Param              :   id wfstepTmpId
@Return             :   list<GA_WFT_Allowed_Next_Step__c>
@throws Exception   :   N/A;
*****************************************************************************************************************************************/  
    @AuraEnabled
    public static list<GA_WFT_Allowed_Next_Step__c> wfallwdSteps(id wfstepTmpId)
    {
        try
        {
            set<id> curridSet=new set<id>();
            curridSet.add(wfstepTmpId);
            string wfstptIdString=GA_Util08_FilterProcessHelper.idSet(curridSet);
            list<GA_WFT_Allowed_Next_Step__c> wftAlwdSteps=GA_Util14_WFAllwStepTmpltDataAccesHelper.fetchwrkflowAllwStpTmpsMap(selectQuery, 
                                                                                                                               whereClause+wfstptIdString, 
                                                                                                                               GA_Util14_WFAllwStepTmpltDataAccesHelper.BLANK, 
                                                                                                                               limitClause).values();
            list<GA_WFT_Allowed_Next_Step__c> wftAlwdStepsSrted=new list<GA_WFT_Allowed_Next_Step__c>();
            GA_WFT_Allowed_Next_Step__c wfCmpSTp;
            for(GA_WFT_Allowed_Next_Step__c wfSTp:wftAlwdSteps)
            {
                if(wfSTp.GA_Allowed_Next_Step_Name__c !='Completed')
                wftAlwdStepsSrted.add(wfSTp);
                else
                {
                    wfCmpSTp=wfSTp;
                }
            }
            if(wfCmpSTp !=null)
            {
               wftAlwdStepsSrted.add(wfCmpSTp); 
            }
            return wftAlwdStepsSrted;
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, ClsName, method1);
            return null;
        }
    }
}