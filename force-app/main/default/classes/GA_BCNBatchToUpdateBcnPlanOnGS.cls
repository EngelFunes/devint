/**
@Author : IDC Offshore
@Name: GA_BCNBatchToUpdateBcnPlanOnGS
@CreatedDate: 08 - May - 2019
@Description: GA_BCNBatchToUpdateBcnPlanOnGS batch class to update latest BCN History information on GS
*/
global class GA_BCNBatchToUpdateBcnPlanOnGS implements Database.Batchable<sObject>{
    global final string query;
    /**
@Description: GA_BCNBatchToUpdateBcnPlanOnGS() Constructer method 
@Name : GA_BCNBatchToUpdateBcnPlanOnGS
@Param : string bcnQry
@Return : void
@throws Exception : N/A;
*/ 
    global GA_BCNBatchToUpdateBcnPlanOnGS(string bcnQry)
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
        GA_BCNHstry_AP01_UpdtToGrpSgmnt.updtBCNtoGs(scope,null);
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