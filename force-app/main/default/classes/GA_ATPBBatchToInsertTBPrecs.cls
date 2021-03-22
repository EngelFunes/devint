/**
@Author : IDC Offshore
@Name: GA_ATPBBatchToInsertTBPrecs
@CreatedDate: 21 - Dec - 2018 
@Description: GA_ATPBBatchToInsertTBPrecs batch class to insert TBP records based upon latest Association Third Party Biller data.
*/
global class GA_ATPBBatchToInsertTBPrecs implements Database.Batchable<sObject>{
    global final string query;
    global final list<id> idLst;
    /**
@Description: GA_ATPBBatchToInsertTBPrecs() Constructer method 
@Name : GA_ATPBBatchToInsertTBPrecs
@Param : string atpbQry
@Return : void
@throws Exception : N/A;
*/ 
    global GA_ATPBBatchToInsertTBPrecs(string atpbQry,list<id> atpbIds)
    {
        query=atpbQry;
        idLst=atpbIds;
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
        if(!scope.isEmpty()){
            GA_ATPB_UpdateThitdPrtyAcc.updtTpbhRecs(scope);    
        }
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