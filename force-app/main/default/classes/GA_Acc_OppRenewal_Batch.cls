/**
@Author : Prasant Kumar Satpathy
@Name: GA_Acc_OppRenewal_Batch 
@CreatedDate: 01-Aug-2017 
@Description: GA_Acc_OppRenewal_Batch class to create opportunity records based on the renewal dates
@version : 1.0  
*/
global class GA_Acc_OppRenewal_Batch implements Database.Batchable<sObject> {
    global final string queryString;
    /**constructor for batch*/ 
    global GA_Acc_OppRenewal_Batch(String q){
        queryString=q;
    }
    /**method to start batch*/
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
        String query= queryString;
        return Database.getQueryLocator(query); 
    }
    /**method to execute batch*/
    global void execute(Database.BatchableContext bc, List<Account> scope)
    {
     GA_Acc_OppRenewal.dmloprtions(scope);
        
    }
    /**method to execute post batch finishes*/
    global void finish(Database.BatchableContext bc)
    {
        
    }
}