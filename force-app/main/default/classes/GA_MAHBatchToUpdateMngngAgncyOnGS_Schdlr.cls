/*****************************************************************************************
Class Name   : GA_MAHBatchToUpdateMngngAgncyOnGS_Schdlr
Date Created : 08-May-2019
Created By   : IDC Offshore
Description  : 1. This is the schedule class to update Managing Agency on GS.
******************************************************************************************/
global class GA_MAHBatchToUpdateMngngAgncyOnGS_Schdlr implements Schedulable{
    public static final string CURDTE=string.valueof(system.today()).split(' ')[0];
    public static final String  MAHQRY='select id, GA_Managing_Agency__c, GA_Group_Segment__c, GA_Start_Date__c,'+ 
        'GA_End_Date__c,GA_Is_Processed__c,GA_Is_Active__c from GA_Managing_Agency_History__c Where'+ 
        '(GA_Is_Processed__c=false and GA_Start_Date__c<='+CURDTE +' AND GA_End_Date__c >='+CURDTE +')'+
        'OR (GA_Is_Processed__c=false and GA_End_Date__c<='+CURDTE +')' +
        'OR (GA_Is_Processed__c=false and MA_Override_Start_Date__c<='+CURDTE +' AND MA_Override_End_Date__c >='+CURDTE +')'+
        'OR (GA_Is_Processed__c=false and MA_Override_End_Date__c<='+CURDTE +') ORDER BY createddate asc';
    /****************************************************************************************************
Method Name : execute
Parameters  : SchedulableContext SC
Return type : Void
Description : This method is used  to update Managing Agency information on GS 
by running the execute method of schedule class.
******************************************************************************************************/       
    global void execute(SchedulableContext sc) {
        GA_MAHBatchToUpdateMngngAgncyOnGS mahBtch=new GA_MAHBatchToUpdateMngngAgncyOnGS(MAHQRY);
        database.executebatch(mahBtch,200);
    }
}