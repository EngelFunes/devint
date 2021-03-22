/*****************************************************************************************
@Author : IDC Offshore
@Name: ASC_AP_ASCDocTypeGenBatchToDeleteDocs
@CreatedDate: 18 - May - 2020
@Description: ASC_AP_ASCDocTypeGenBatchToDeleteDocs batch class to delete ASC Document Type Records.
******************************************************************************************/
global class ASC_AP_ASCDocTypeGenBatchToDeleteDocs implements Database.Batchable<sObject>{
   
global final string query='select id,instance__c from ASC_Document_Type_Record__c';

/*****************************************************************************************
@Description: start() method 
@Name : start
@Param : Database.BatchableContext BC
@Return : Database.QueryLocator
@throws Exception : N/A;
******************************************************************************************/
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
        
        return Database.getQueryLocator(query); 
    }

/*****************************************************************************************
Description: execute() method 
@Name : execute
@Param : Database.BatchableContext BC, List<sObject> scope
@Return : Database.QueryLocator
@throws Exception : N/A;
******************************************************************************************/ 
    global void execute(Database.BatchableContext bc, List<ASC_Document_Type_Record__c> scope)
    {
        delete scope;
    }
/******************************************************************************************
@Description: finish() method 
@Name : finish
@Param : Database.BatchableContext BC
@Return : Void
@throws Exception : N/A;
******************************************************************************************/ 
    global void finish(Database.BatchableContext bc)
    {
        
    }
}