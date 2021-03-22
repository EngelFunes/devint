global class GA_DCSmallGroupBatchForSuiteUpdate implements Database.Batchable<sObject>{
    global final string query;
    /**Constructor*/
    global GA_DCSmallGroupBatchForSuiteUpdate(string dcmQry)
    {
        query=dcmQry;
    }
    /**method to start batch*/
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
        return Database.getQueryLocator(query); 
    }
    /**method to execute batch*/
    global void execute(Database.BatchableContext bc, List<GA_DC_Small_Grp_History__c> scope)
    {
        GA_DCSGH_AP01_SuiteLogic.updateSuiteInfoToGS(scope, null);
    }
    /**method to execute post batch finishes*/
    global void finish(Database.BatchableContext bc)
    {
        
    }
}