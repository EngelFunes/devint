/**
@Author : Prasant Kumar Satpathy
@Name: GA_AR_AP_UpdatePlatinumStatusBatchCls 
@CreatedDate: 05-Jan-2018  
@Description: GA_AR_AP_UpdatePlatinumStatusBatchCls class to update the platinum status 
@version : 1.0  
*/
global class GA_AR_AP_UpdatePlatinumStatusBatchCls implements Database.Batchable<sObject> {
    global final string query;
    global final list<id> idLst=new list<id>();
    global final list<GA_AgencyRelationship__c> agencyRelDelList=new list<GA_AgencyRelationship__c>();
    global final map<id,GA_AgencyRelationship__c> agncyRelMapVal=new map<id,GA_AgencyRelationship__c>();
    
    global GA_AR_AP_UpdatePlatinumStatusBatchCls(string QueryStng,list<id> agncyid,map<id,GA_AgencyRelationship__c> agncyRelMap,list<GA_AgencyRelationship__c> agencyRelDelListTmp)
    {
        query=QueryStng;
        idLst.addAll(agncyid);
        agncyRelMapVal.putAll(agncyRelMap);
        agencyRelDelList.addAll(agencyRelDelListTmp);
        
    }
    /**method to start batch*/
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
        return Database.getQueryLocator(query); 
    }
    /**method to execute batch*/
    global void execute(Database.BatchableContext bc, List<GA_AgencyRelationship__c> scope)
    {
        GA_AR_AP01_UpdatePlatinumStatusOnAccount.isExecuting = true;
        GA_AR_AP01_UpdatePlatinumStatusOnAccount.createAgencyRelation(agencyRelDelList, agncyRelMapVal);
    }
    /**method to execute post batch finishes*/
    global void finish(Database.BatchableContext bc)
    {
        
    }
}