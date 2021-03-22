/*****************************************************************************************
Class Name   : GA_ATHBatchToUpdateOnAccSchdlr
Date Created : 21-Dec-2018
Created By   : IDC Offshore
Description  : 1. This is the schedule class to update Account Territory History to Account.
******************************************************************************************/
global class GA_ATHBatchToUpdateOnAccSchdlr implements Schedulable{
    public static final string CURDTE=string.valueof(system.today()).split(' ')[0];
    public static final String ATHQRY='select id, GA_Account_Id__c,GA_Start_Date__c,GA_End_Date__c,GA_Territory_Id__c,GA_Is_Processed__c,GA_Is_Active__c from GA_Account_Territory_History__c Where (GA_Is_Processed__c=false and GA_Start_Date__c<='+CURDTE +' AND GA_End_Date__c >='+CURDTE +') OR (GA_Is_Processed__c=false and  GA_End_Date__c<='+CURDTE+') ORDER BY createddate asc';
    /****************************************************************************************************
Method Name : execute
Parameters  : SchedulableContext SC
Return type : Void
Description : This method is used  to update Account Territory History to Account. 
by running the execute method of schedule class.
******************************************************************************************************/       
    global void execute(SchedulableContext sc) {
        GA_ATHBatchToUpdateOnAcc bathb=new GA_ATHBatchToUpdateOnAcc(ATHQRY);
        database.executebatch(bathb,200);
    }
}