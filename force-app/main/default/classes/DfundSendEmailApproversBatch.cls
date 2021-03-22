/*****************************************************************************************************************************************************
@Author : Dinesh P
@Name: DfundSendEmailApproversBatch
@CreatedDate:  20-Dec-2020 
@Description: DfundSendEmailApproversBatch is used to send Reminder Email if dfund request is assigned to same approver if more than one day.

@version : 1.0  
@US Number: US-4293 ,US-4098, US-4100

*/
global class DfundSendEmailApproversBatch implements Database.Batchable<sObject>{
    global final string queryString;
    /**constructor for batch*/ 
    global DfundSendEmailApproversBatch(String q){
        queryString=q;
    }
    /**method to start batch*/
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
        String query= queryString;
        return Database.getQueryLocator(query); 
    }
    /**method to execute batch*/
    global void execute(Database.BatchableContext bc, List<Dfund_Request__c> scope)
    {
      DfundSendEmailApproversClass.dmloptions(scope);        
    }
    /**method to execute post batch finishes*/
    global void finish(Database.BatchableContext bc)
    {
        
    }
}