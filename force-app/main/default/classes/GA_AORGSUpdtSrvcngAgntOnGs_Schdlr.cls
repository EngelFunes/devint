/*****************************************************************************************
Class Name   : GA_AORGSUpdtSrvcngAgntOnGs_Schdlr
Date Created : 06-June-2019
Created By   : IDC Offshore
Description  : 1. This is the schedule class to update External Appeal records on GS
******************************************************************************************/
global class GA_AORGSUpdtSrvcngAgntOnGs_Schdlr implements Schedulable
{
    public static final string CURDTE=string.valueof(system.today()).split(' ')[0];
    public static final String  AORGSQRY='select id,name, GA_Group_Segment_Id__c,GA_Cancel_Date__c,GA_Is_StartDateProcessed__c,GA_Is_EndDateProcessed__c,GA_Service_Start_Date__c,GA_Service_End_Date__c,GA_Process_Agent__c,GA_Process_End_Date__c,GA_Process_Start_Date__c,GA_Cancel_Flag__c,GA_ProcessAgentId__c from GA_AOR_Group_Segment__c Where (GA_Is_StartDateProcessed__c=false and GA_Service_Start_Date__c<='+CURDTE +' AND GA_Service_End_Date__c >='+CURDTE +') OR (GA_Is_EndDateProcessed__c=false and GA_Service_End_Date__c<'+CURDTE +') OR (GA_Cancel_Flag__c=true)ORDER BY createddate asc';
    /****************************************************************************************************
Method Name : execute
Parameters  : SchedulableContext SC
Return type : Void
Description : This method is used  to update Third party history information on GS 
by running the execute method of schedule class.
******************************************************************************************************/       
    global void execute(SchedulableContext sc) {
        GA_AORGSUpdtSrvcngAgntOnGs_Batch aorgsBtch=new GA_AORGSUpdtSrvcngAgntOnGs_Batch(AORGSQRY);
        database.executebatch(aorgsBtch,100);
    }
}