/**
@Author : IDC Offshore
@Name: GA_ATPBBatchToUpdateEndDates
@CreatedDate: 25 - Oct - 2018 
@Description: GA_ATPBBatchToUpdateEndDates batch class to update end dates of ATPB history records.
*/
global class GA_ATPBBatchToUpdateEndDates implements Database.Batchable<sObject>{
    global final string query;
    global final list<id> idLst=new list<id>();
    /**
@Description: GA_ATPBBatchToUpdateEndDates() Constructer method 
@Name : GA_ATPBBatchToUpdateEndDates
@Param : string atpbQry
@Return : void
@throws Exception : N/A;
*/  
    global GA_ATPBBatchToUpdateEndDates(string atpbQry)
    {
        query=atpbQry;
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
    global void execute(Database.BatchableContext bc, List<GA_Association_Third_Party_Biller__c> scope)
    {
        GA_ATPB_UpdateThitdPrtyAcc.updatEndDate(scope);
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