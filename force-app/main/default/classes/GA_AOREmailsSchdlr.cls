/*****************************************************************************************
Class Name   : GA_AOREmailsSchdlr
Date Created : 06-June-2019
Created By   : IDC Offshore
Description  : 1. This is the schedule class to send AOR emails
******************************************************************************************/
global class GA_AOREmailsSchdlr implements Schedulable
{
    public static final string CREATEDT=string.valueof(system.today()).split(' ')[0];
    public static final String  AORQRY='select id,Name,GA_Service_Start_Date__c,GA_Commission_Start_Date__c,GA_Letter_Type__c,GA_Customer_Letter_Type__c,GA_To__c,GA_CC__c,'+
        'GA_Process_Date__c,GA_Format_Process_Date__c,GA_Format_Commission_Start_Date__c,GA_Format_Commission_End_Date__c,GA_Contact_Id__c,	GA_Account_Id__r.GA_Decision_Maker__c,GA_Account_Id__r.Name,GA_Account_Id__r.BillingCity,GA_Account_Id__r.BillingState,'+
        'GA_Account_Id__r.OwnerId,GA_Account_Id__r.Account_Owner__c,GA_Account_Id__r.Owner.Email,GA_Account_Id__r.BillingPostalcode,GA_Contact_Id__r.Name,GA_Account_Id__r.BillingStreet,GA_Contact_Id__r.Agent_Code__c,GA_Agency__c,GA_Contact_Id__r.Mailingstreet,GA_Contact_Id__r.Mailingcity,'+
        'GA_Contact_Id__r.Mailingstate,GA_Contact_Id__r.MailingPostalcode,GA_Account_Id__r.CID__c,GA_Commission_End_Date__c from  GA_AOR__c '+
        'where (GA_Customer_Letter_Type__c <> null or GA_Letter_Type__c <> null) and GA_Process_Date__c = '+CREATEDT +' ORDER BY createddate asc';
/****************************************************************************************************
Method Name : execute
Parameters  : SchedulableContext SC
Return type : Void
Description : This method is used  to update Third party history information on GS 
by running the execute method of schedule class.
******************************************************************************************************/       
    global void execute(SchedulableContext sc) {
        GA_AORSendingEmail_Batch b=new GA_AORSendingEmail_Batch(AORQRY);
        database.executebatch(b,300);
    }
}