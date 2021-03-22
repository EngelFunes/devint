/**
@Author : IDC Offshore
@Name: GA_ATPBBatchToUpdateOnAcc
@CreatedDate: 21 - Dec - 2018 
@Description: GA_ATPBBatchToUpdateOnAcc batch class to update latest Association Third Party Biller to Account.
*/
global class GA_ATPBBatchToUpdateOnAcc implements Database.Batchable<sObject>{
    global final string query;
    /**
@Description: GA_ATPBBatchToUpdateOnAcc() Constructer method 
@Name : GA_ATPBBatchToUpdateOnAcc
@Param : string atpbQry
@Return : void
@throws Exception : N/A;
*/ 
    global GA_ATPBBatchToUpdateOnAcc(string atpbQry)
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
        system.debug('Query...'+query);
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
        GA_ATPB_UpdateThitdPrtyAcc.updtetThrdPrtyHstryToAcc(scope,null);
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