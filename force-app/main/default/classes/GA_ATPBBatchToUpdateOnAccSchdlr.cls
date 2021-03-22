/*****************************************************************************************
Class Name   : GA_ATPBBatchToUpdateOnAccSchdlr
Date Created : 21-Dec-2018
Created By   : IDC Offshore
Description  : 1. This is the schedule class to update Association Third Party Biller to Account.
******************************************************************************************/
global class GA_ATPBBatchToUpdateOnAccSchdlr implements Schedulable{
    public static final string CURDTE=string.valueof(system.today()).split(' ')[0];
    public static final String ATPBQRY='select id,GA_Is_Active__c,GA_Third_Party_Biller_Account_Id__c,GA_Start_Date__c,GA_End_Date__c,GA_Association_Account_Id__c,GA_Is_Processed__c from GA_Association_Third_Party_Biller__c Where (GA_Is_Processed__c=false and GA_Start_Date__c<='+CURDTE +' AND GA_End_Date__c >='+CURDTE +') OR (GA_Is_Processed__c=false and GA_End_Date__c<='+CURDTE+') ORDER BY createddate asc';
    /****************************************************************************************************
Method Name : execute
Parameters  : SchedulableContext SC
Return type : Void
Description : This method is used  to update Association Third Party Biller to Account 
by running the execute method of schedule class.
******************************************************************************************************/       
    global void execute(SchedulableContext sc) {
        GA_ATPBBatchToUpdateOnAcc batpb=new GA_ATPBBatchToUpdateOnAcc(ATPBQRY);
        database.executebatch(batpb,200);
    }
}