/**
@Author : Dilip
@Name: GA_EventBatchForInsertingInvitees 
@CreatedDate: 02 - Jan 2018 
@Description: GA_EventBatchForInsertingInvitees class to insert event invitees on insertion of event records on handover record.
@version : 1.0  
*/
global class GA_EventBatchForInsertingInvitees implements Database.Batchable<sObject> {
    global final string query;
    global final list<id> idLst=new list<id>();
    /**Constructor*/
    global GA_EventBatchForInsertingInvitees(string qryCreateinvitees, list<id> evtIdLstTmp)
    {
        query=qryCreateinvitees;
        idLst.addall(evtIdLstTmp);
    }
    /**method to start batch*/
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
       return Database.getQueryLocator(query); 
    }
    /**method to execute batch*/
    global void execute(Database.BatchableContext bc, List<Event> scope)
    {
        Map<Id,Event> evtMap =new Map<Id,Event>();
        
        for(Event e: scope){
            evtMap.put(e.id, e);
        }
        GA_EVE_AP01_AddInvitees.addInvites(scope);
        
    }
    /**method to execute post batch finishes*/
    global void finish(Database.BatchableContext bc)
    {
        
    }
}