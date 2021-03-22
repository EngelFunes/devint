/**
@Author : Dilip
@Name: GA_HandoverBatchForInsertingTasks 
@CreatedDate: 02 - Jan 2018 
@Description: GA_HandoverBatchForInsertingTasks class to insert tasks and event records on insertion of handover records.
@version : 1.0  
*/
global class GA_HandoverBatchForInsertingTasks implements Database.Batchable<sObject>,Database.Stateful {
    global final string query;
    Public Static boolean isBatchTaskInsert = false;
    global final list<id> idLst=new list<id>();
    global list<id> EventInsertIds=new list<id> ();
    Public static final String  qryCreateinvitees='SELECT Id, WhatId from Event where id in:idLst';
    /**Constructor*/
    global GA_HandoverBatchForInsertingTasks(string qryCreateTsks, list<id> achIdLstTmp)
    {
        query=qryCreateTsks;
        idLst.addall(achIdLstTmp);
    }
    /**method to start batch*/
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
        return Database.getQueryLocator(query); 
    }
    /**method to execute batch*/
    global void execute(Database.BatchableContext bc, List<GA_AccountHandOver__c> scope)
    {
        Map<Id,GA_AccountHandOver__c> accHandOverMap =new Map<Id,GA_AccountHandOver__c>();
        
        for(GA_AccountHandOver__c a: scope){
            accHandOverMap.put(a.id, a);
        }
        
        GA_HandoverBatchForInsertingTasks.isBatchTaskInsert = true;
        List<Event> EvtList = GA_ACH_AP01_CreateHandoverTasks.createtasks(scope);
        if(EvtList !=null && !EvtList.isEmpty()){
            Id evId;
            for(Event ev :EvtList){
                evId=ev.id;
                EventInsertIds.add(evId);
            }
        }
    }
    /**method to execute post batch finishes*/
    global void finish(Database.BatchableContext bc)
    {
        GA_EventBatchForInsertingInvitees crtInviteesBtch=new GA_EventBatchForInsertingInvitees(qryCreateinvitees, EventInsertIds);
        ID createInviteesbatchprocessid = Database.executeBatch(crtInviteesBtch,200); 
    }
}