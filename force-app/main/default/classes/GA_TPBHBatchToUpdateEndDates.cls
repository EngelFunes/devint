/**
@Author : IDC Offshore
@Name: GA_TPBHBatchToUpdateEndDates
@CreatedDate: 25 - Oct - 2018 
@Description: GA_TPBHBatchToUpdateEndDates batch class to update end dates of TPB history reocrds.
*/
global class GA_TPBHBatchToUpdateEndDates implements Database.Batchable<sObject>{
    global final string query;
    global final list<id> idLst=new list<id>();
    /**
@Description: GA_TPBHBatchToUpdateEndDates() Constructer method 
@Name : GA_TPBHBatchToUpdateEndDates
@Param : string tpbQry
@Return : void
@throws Exception : N/A;
*/  
    global GA_TPBHBatchToUpdateEndDates(string tpbQry)
    {
        query=tpbQry;
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
    global void execute(Database.BatchableContext bc, List<GA_Third_Party_Biller_History__c> scope)
    {
        GA_TPBH_AP01_ThrdPrtyBllrUpdtngToGSLogic.updatEndDate(scope);
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