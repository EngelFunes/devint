/**
@Author : IDC Offshore
@Name: GA_BCNBatchToUpdateEndDates
@CreatedDate: 08 - May - 2019 
@Description: GA_BCNBatchToUpdateEndDates batch class to update end dates of BCN history reocrds.
*/
global class GA_BCNBatchToUpdateEndDates implements Database.Batchable<sObject>{
    global final string query;
    global final list<id> idLst=new list<id>();
    /**
@Description: GA_BCNBatchToUpdateEndDates() Constructer method 
@Name : GA_BCNBatchToUpdateEndDates
@Param : string bcnQry
@Return : void
@throws Exception : N/A;
*/  
    global GA_BCNBatchToUpdateEndDates(string bcnQry)
    {
        query=bcnQry;
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
    global void execute(Database.BatchableContext bc, List<GA_Plan_Year_Exception_History__c> scope)
    {
        GA_BCNHstry_AP01_UpdtToGrpSgmnt.updatEndDate(scope);
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