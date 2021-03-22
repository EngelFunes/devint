/*****************************************************************************************
Class Name   : GA_DCSmallGroupBatchSuiteUpdtSchdlr
Date Created : 21-Dec-2018
Created By   : IDC Offshore
Description  : 1. This is the schedule class to update Suite Information to Group Segment.
******************************************************************************************/
global class GA_DCSmallGroupBatchSuiteUpdtSchdlr implements Schedulable{
    public static final string CURDTE=string.valueof(system.today()).split(' ')[0];
    public static final String  DCMQRY='select id, GA_Suite__c, GA_Group_Segment_Id__c, GA_Suite_Start_Date__c,'+ 
        'GA_Suite_End_Date__c,GA_Is_Processed__c,GA_Is_Active__c from GA_DC_Small_Grp_History__c Where '+ 
        '(GA_Is_Processed__c=false and GA_Suite_Start_Date__c<='+CURDTE +' AND GA_Suite_End_Date__c >='+CURDTE +') '+
        'OR (GA_Is_Processed__c=false and GA_Suite_End_Date__c<='+CURDTE +') ORDER BY createddate asc';
    /****************************************************************************************************
Method Name : execute
Parameters  : SchedulableContext SC
Return type : Void
Description : This method is used  to update Suite Information to Group Segment. 
by running the execute method of schedule class.
******************************************************************************************************/    
    global void execute(SchedulableContext sc) {
        GA_DCSmallGroupBatchForSuiteUpdate dcsgb=new GA_DCSmallGroupBatchForSuiteUpdate(DCMQRY);
        database.executebatch(dcsgb,200);
    }
}