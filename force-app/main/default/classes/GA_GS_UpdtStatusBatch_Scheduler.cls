/*****************************************************************************************
Class Name   : GA_GS_UpdtStatusBatch_Scheduler
Date Created : 12/22/2017
Created By   : IDC Offshore
Description  : 1. This is the schedule class to update GS status and related accnt record type 
based on active grp segments availability
******************************************************************************************/
global class GA_GS_UpdtStatusBatch_Scheduler implements Schedulable{
    /***method to execute batchclass to update account*/
    public static final string curdte=string.valueof(system.today()).split(' ')[0];
 /***   public static final String gsQry='select id,Name,GA_Account__c,Network__c,GA_Transaction_Posted__c,GA_Post_Transaction__c,'+
        '(select id from GA_WF_Group_Segment__r where GA_Status__c=\'Closed\' and GA_Workflow_Next_Step__c=null and GA_WF_Step_ID__c !=null),'+
        'GA_Account_Record_Type__c,GA_Account_Status__c,Status__c,GA_Group_Effective_Date__c,'+
        'GA_Cancellation_Date__c,GA_Third_Party_Biller_History__c from GA_Group_Segment__c where (GA_Is_Processed__c=false and Status__c=\'Pending\' and ((GA_Cancellation_Date__c=null or GA_Cancellation_Date__c >'+curdte+') and GA_Group_Effective_Date__c<='+curdte+'))'+
        'or (Status__c=\'Canceled\' and ((GA_Cancellation_Date__c=null or GA_Cancellation_Date__c >'+curdte+') and GA_Group_Effective_Date__c<='+curdte+'))'+
        'or (Status__c=\'Active\' and GA_Cancellation_Date__c<='+curdte+')'; **/
    
    public static final String gsQry='select id,Name,GA_Account__c,Network__c,GA_Transaction_Posted__c,GA_Post_Transaction__c,'+
        '(select id from GA_WF_Group_Segment__r where GA_Status__c=\'Closed\' and GA_Workflow_Next_Step__c=null and GA_WF_Step_ID__c !=null),'+
        'GA_Account_Record_Type__c,GA_Account_Status__c,Status__c,GA_Group_Effective_Date__c,'+
        'GA_Cancellation_Date__c,GA_Third_Party_Biller_History__c,GA_PA_250__c,GA_DOL__c from GA_Group_Segment__c where (GA_Is_Processed__c=false and Status__c=\'Pending\'  )'+
        'or (Status__c=\'Canceled\' and ((GA_Cancellation_Date__c=null or GA_Cancellation_Date__c >'+curdte+') and GA_Group_Effective_Date__c<='+curdte+'))'+
        'or (Status__c=\'Active\' and GA_Cancellation_Date__c<='+curdte+')';
/****************************************************************************************************
Method Name : execute
Parameters  : SchedulableContext SC
Return type : Void
Description : This method is used  to update GS status and related accnt record type 
based on active grp segments availability by running the execute method of schedule class.
******************************************************************************************************/    
    global void execute(SchedulableContext sc) {
        GA_GS_UpdtStatusBatch  b=new GA_GS_UpdtStatusBatch (gsQry);
        database.executebatch(b,200);
     }
}