/*****************************************************************************************
Class Name   : ASC_AP_ASCDocTypeGenBtchToDelDocs_Schdlr
Date Created : 18-May-2020
Created By   : IDC Offshore
Description  : 1. This is the schedule class to delete ASC Document Type Records.
******************************************************************************************/
global class ASC_AP_ASCDocTypeGenBtchToDelDocs_Schdlr implements Schedulable{
    
/****************************************************************************************************
Method Name : execute
Parameters  : SchedulableContext SC
Return type : Void
Description : This method is used  to delete ASC Document Type Records by running the execute method of schedule class.
******************************************************************************************************/      
    global void execute(SchedulableContext sc) {
        ASC_AP_ASCDocTypeGenBatchToDeleteDocs docBtch=new ASC_AP_ASCDocTypeGenBatchToDeleteDocs();
        database.executebatch(docBtch,200);
    }
}