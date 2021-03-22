/**
@Author : Prasant Kumar Satpathy
@Name: GA_AP_DeleteDocumentsBatch 
@CreatedDate: 15-Jan-2018 
@Description: GA_AP_DeleteDocumentsBatch class to delete documents generated due to external service document creation
@version : 1.0  
*/
global class GA_AP_DeleteDocumentsBatch implements Database.Batchable<sObject>,Database.AllowsCallouts {
    //global static final string queryString = 'Select Id,folder.name from Document where folder.name=\'BCBSM External Service Document\'';
    global static final string queryString = 'SELECT Id, Title, ContentDocumentId FROM ContentVersion WHERE Description =\'TO BE DELETED BY BATCH\'';
    /**method to start batch*/
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
        String query= queryString;
        return Database.getQueryLocator(query); 
    }
    /**method to execute batch*/
    global void execute(Database.BatchableContext bc, List<ContentVersion> scope)
    {
        List<String> contentDocIDList = new List<String>();
        
        For(ContentVersion ver : scope){
            contentDocIDList.add(ver.ContentDocumentId);
        }
        
        List<ContentDocument> contentDocList = [SElECT Id FROM ContentDocument WHERE Id =: contentDocIDList];
        
        database.delete(contentDocList);
        //database.delete(scope);
    }
    /**method to execute post batch finishes*/
    global void finish(Database.BatchableContext bc)
    {
        
    }
}