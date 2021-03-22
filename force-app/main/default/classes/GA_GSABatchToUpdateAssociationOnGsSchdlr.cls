/*****************************************************************************************
Class Name   : GA_GSABatchToUpdateAssociationOnGsSchdlr
Date Created : 05-Nov-2018
Created By   : IDC Offshore
Description  : 1. This is the schedule class to update Group Segment association on GS
******************************************************************************************/
global class GA_GSABatchToUpdateAssociationOnGsSchdlr implements Schedulable{
    public static final string CURDTE=string.valueof(system.today()).split(' ')[0];
    public static final String GSAQRY='select id,GA_Group_Segment__c,GA_Account__c,GA_Start_Date__c,GA_End_Date__c,GA_System_Of_Record__c,GA_Is_Processed__c,GA_Is_Active__c from GA_Group_Association__c Where (GA_Is_Processed__c=false and GA_Is_Active__c=true and GA_System_Of_Record__c!=\'SMART\') or (GA_Is_Processed__c=false and GA_System_Of_Record__c!=\'SMART\' and GA_End_Date__c<='+CURDTE +') order by createddate asc';
/****************************************************************************************************
Method Name : execute
Parameters  : SchedulableContext SC
Return type : Void
Description : This method is used  to update Third party history information on GS 
by running the execute method of schedule class.
******************************************************************************************************/       
    global void execute(SchedulableContext sc) {
        GA_GSABatchToUpdateAssociationOnGS bgsab=new GA_GSABatchToUpdateAssociationOnGS(GSAQRY);
        database.executebatch(bgsab,200);
    }
}