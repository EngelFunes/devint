/*****************************************************************************************
Class Name   : GA_AP_DeleteDocuments_Scheduler
Date Created : 02/7/2018
Created By   : IDC Offshore
Description  : This is the schedule class that invokes GA_AP_DeleteDocumentsBatch for deleting documents in BCBSM External Service Document folder.
******************************************************************************************/
global class GA_AP_DeleteDocuments_Scheduler implements Schedulable {
    
/****************************************************************************************************
Method Name : execute
Parameters  : SchedulableContext SC
Return type : Void
Description : This method is used to retrieve and update CID service. 
******************************************************************************************************/
    global void execute(SchedulableContext SC) {
        GA_AP_DeleteDocumentsBatch dltDocsbtch=new GA_AP_DeleteDocumentsBatch ();
        database.executeBatch(dltDocsbtch, 2000);
    }
}