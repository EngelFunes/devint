/**
@Author : IDC Offshore
@Name: GA_MAHBatchToUpdateEndDates
@CreatedDate: 08 - May - 2019 
@Description: GA_MAHBatchToUpdateEndDates batch class to update end dates of Managing Agency history reocrds.
*/
global class GA_MAHBatchToUpdateEndDates implements Database.Batchable<sObject>{
    private final string query;
    private final list<id> idLst=new list<id>();
    /**
@Description: GA_MAHBatchToUpdateEndDates() Constructer method 
@Name : GA_MAHBatchToUpdateEndDates
@Param : string mahQry
@Return : void
@throws Exception : N/A;
*/  
    global GA_MAHBatchToUpdateEndDates(string mahQry)
    {
        query=mahQry;
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
    global void execute(Database.BatchableContext bc, List<GA_Managing_Agency_History__c> scope)
    {
        GA_MngngAgncyHstry_AP01_UpdtToGrpSgmnt.updatEndDate(scope);
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