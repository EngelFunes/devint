/**
@Author : IDC Offshore
@Name: GA_GSABatchToUpdateEndDates
@CreatedDate: 25 - Oct - 2018 
@Description: GA_GSABatchToUpdateEndDates batch class to update end dates of TPB history reocrds.
*/
global class GA_GSABatchToUpdateEndDates implements Database.Batchable<sObject>{
    global final string query;
    global final list<id> idLst=new list<id>();
    /**
@Description: GA_GSABatchToUpdateEndDates() Constructer method 
@Name : GA_GSABatchToUpdateEndDates
@Param : string gsaQry
@Return : void
@throws Exception : N/A;
*/  
    global GA_GSABatchToUpdateEndDates(string gsaQry)
    {
        query=gsaQry;
    }
    /**
@Description: start() method 
@Name : start
@Param : Database.BatchableContext BC
@Return : Database.QueryLocator
@throws Exception : N/A;
*/
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
        return Database.getQueryLocator(query); 
    }
    /**
@Description: execute() method 
@Name : execute
@Param : Database.BatchableContext BC, List<sObject> scope
@Return : Database.QueryLocator
@throws Exception : N/A;
*/ 
    global void execute(Database.BatchableContext bc, List<GA_Group_Association__c> scope)
    {
        GA_GSA_AP01_AssoctnUpdatngToGsLogic.updatEndDate(scope);
    }
    /**
@Description: finish() method 
@Name : finish
@Param : Database.BatchableContext BC
@Return : Void
@throws Exception : N/A;
*/ 
    global void finish(Database.BatchableContext bc)
    {
        
    }
}