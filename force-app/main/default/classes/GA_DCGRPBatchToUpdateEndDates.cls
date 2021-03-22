/**
@Author : IDC Offshore
@Name: GA_DCGRPBatchToUpdateEndDates
@CreatedDate: 25 - Oct - 2018 
@Description: GA_DCGRPBatchToUpdateEndDates batch class to update end dates of DC Small Group history records.
*/
global class GA_DCGRPBatchToUpdateEndDates implements Database.Batchable<sObject>{
    global final string query;
    global final list<id> idLst=new list<id>();
    /**
@Description: GA_DCGRPBatchToUpdateEndDates() Constructer method 
@Name : GA_DCGRPBatchToUpdateEndDates
@Param : string atpbQry
@Return : void
@throws Exception : N/A;
*/  
    global GA_DCGRPBatchToUpdateEndDates(string dcSmlQry)
    {
        query=dcSmlQry;
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
    global void execute(Database.BatchableContext bc, List<GA_DC_Small_Grp_History__c> scope)
    {
        GA_DCSGH_AP01_SuiteLogic.updatEndDate(scope);
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