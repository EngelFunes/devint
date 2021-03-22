/**
@Author : IDC Offshore
@Name: GA_ATHBatchToUpdateOnAcc
@CreatedDate: 21 - Dec - 2018 
@Description: GA_ATHBatchToUpdateOnAcc batch class to update latest Account Territory History to Account.
*/
global class GA_ATHBatchToUpdateOnAcc implements Database.Batchable<sObject>{
    global final string query;
    /**
@Description: GA_ATHBatchToUpdateOnAcc() Constructer method 
@Name : GA_ATHBatchToUpdateOnAcc
@Param : string athQry
@Return : void
@throws Exception : N/A;
*/ 
    global GA_ATHBatchToUpdateOnAcc(string athQry)
    {
        query=athQry;
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
    global void execute(Database.BatchableContext bc, List<GA_Account_Territory_History__c> scope)
    {
        GA_ATH_AP01_TerritoryUpdatngToAcc.updateATHtoAcc(scope,null);
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