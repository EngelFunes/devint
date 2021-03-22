/**
@Author : IDC offshore
@Name: GA_UpdtAccAssmntForBatch 
@CreatedDate: 30 - Jul 2018 
@Description: GA_UpdtAccAssmntForBatch class to update account assessment when related Account owner is changed list for batch
@version : 1.0  
*/

global class GA_UpdtAccAssmntForBatch implements Database.Batchable<sObject> {

    global final list<id> accIdlst=new list<id>();
    global static final string queryString = 'SELECT Id,GA_Account_Owner_Manager__c from account where id in:accIdlst';
    /**method to start batch*/
    global GA_UpdtAccAssmntForBatch(list<id> accIds)
    {
        accIdlst.addall(accIds);
    }
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
        String query= queryString;
        return Database.getQueryLocator(query); 
    }
    /**method to execute batch*/
    global void execute(Database.BatchableContext bc, List<account> scope)
    {
        GA_ACC_AP_UpdtAssmntOwnrMgrChnge.updtownrMgrEml(scope);
    }
    /**method to execute post batch finishes*/
    global void finish(Database.BatchableContext bc)
    {
        
    }
}