/**
@Author : IDC Offshore
@Name: GA_MAHBatchToUpdateMngngAgncyOnGS
@CreatedDate: 08 - May - 2019
@Description: GA_MAHBatchToUpdateMngngAgncyOnGS batch class to update latest Managing Agency information on GS
*/
global class GA_MAHBatchToUpdateMngngAgncyOnGS implements Database.Batchable<sObject>{
    private final string query;
    /**
@Description: GA_MAHBatchToUpdateMngngAgncyOnGS() Constructer method 
@Name : GA_MAHBatchToUpdateMngngAgncyOnGS
@Param : string mahQry
@Return : void
@throws Exception : N/A;
*/ 
    global GA_MAHBatchToUpdateMngngAgncyOnGS(string mahQry)
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
        GA_MngngAgncyHstry_AP01_UpdtToGrpSgmnt.updtMngngAgncytoGs(scope,null);
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