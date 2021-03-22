/*
@Author : Padmahaarika Jayana
@Name: GA_AccountBatchApexClassForTerritory 
@CreatedDate: 01-Aug-2017 
@Description: GA_AccountBatchApexClassForTerritory class to build update of respective retention sales rep in 
Account team based assigned territory and update the platinum status 
@version : 1.0  
*/
global class GA_AccountBatchApexClassForTerritory implements Database.Batchable<sObject> {
    global final string query;
    global final list<id> idLst=new list<id>();
    /**Constructor*/
    global GA_AccountBatchApexClassForTerritory(string qryUpdtSlsTm,list<id> accIdLstTmp)
    {
        query=qryUpdtSlsTm;
        idLst.addall(accIdLstTmp);
    }
    /**method to start batch*/
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
       return Database.getQueryLocator(query); 
    }
    /**method to execute batch*/
    global void execute(Database.BatchableContext bc, List<Account> scope)
    {
        Map<Id,Account> accMap =new Map<Id,Account>();
        
        
        for(Account a: scope){
            accMap.put(a.id, a);
        }
        GA_ACC_AP02_IdentifySalesRepOnAccount.createsalesTeamOnAccount( scope, accMap, accMap);
       // GA_ACC_AP01_CheckPlatinumStatusOnAgency.updateCustomerAccountOfAgency(scope, accMap, accMap);
        
    }
    /**method to execute post batch finishes*/
    global void finish(Database.BatchableContext bc)
    {
        
    }
}