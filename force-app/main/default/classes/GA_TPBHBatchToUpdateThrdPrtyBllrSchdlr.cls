/*****************************************************************************************
Class Name   : GA_TPBHBatchToUpdateThrdPrtyBllrSchdlr
Date Created : 05-Nov-2018
Created By   : IDC Offshore
Description  : 1. This is the schedule class to update Third party history information on GS
******************************************************************************************/
global class GA_TPBHBatchToUpdateThrdPrtyBllrSchdlr implements Schedulable{
    public static final string CURDTE=string.valueof(system.today()).split(' ')[0];
    public static final String TPBQRY='select id,GA_TPB_Start_Date__c ,GA_TPB_End_Date__c , GA_Third_Party_Biller_Account__c, GA_Group_Segment_Id__c,GA_System_Of_Record__c,GA_Is_Processed__c,GA_Is_Active__c from GA_Third_Party_Biller_History__c Where (GA_Is_Processed__c = false and GA_Is_Active__c=true and GA_System_Of_Record__c !=\'SMART\') or (GA_Is_Processed__c = false and GA_System_Of_Record__c!=\'SMART\' and GA_TPB_End_Date__c<='+CURDTE +') order by createddate asc';
    /****************************************************************************************************
Method Name : execute
Parameters  : SchedulableContext SC
Return type : Void
Description : This method is used  to update Third party history information on GS 
by running the execute method of schedule class.
******************************************************************************************************/  
    global void execute(SchedulableContext sc) {
        GA_TPBHBatchToUpdateThrdPrtyBllrOnGS tpbhBatch=new GA_TPBHBatchToUpdateThrdPrtyBllrOnGS(TPBQRY);
        database.executebatch(tpbhBatch,200);
    }
}