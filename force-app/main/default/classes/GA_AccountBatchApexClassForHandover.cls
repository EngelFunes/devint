/**
@Author : Dilip
@Name: GA_AccountBatchApexClassForHandover 
@CreatedDate: 02 - Jan 2018 
@Description: GA_AccountBatchApexClassForHandover class to insert handover form and checklist records on flipping the customer to prospect accounts.
@version : 1.0  
*/
global class GA_AccountBatchApexClassForHandover implements Database.Batchable<sObject>,Database.Stateful {
    global final string query;
    global final list<id> idLst=new list<id>();
    global final Map<Id, Account>  accOldMapRec;
    global list<id> hndovrInsertIds=new list<id> ();
    public Static boolean isBatchHandoInsert = false;
    Public Static final String  qryCreateTsks='SELECT Id, Name, GA_CompanyFullLegalName__c from GA_AccountHandOver__c where id in:idLst';
    
    
    /**Constructor*/
    global GA_AccountBatchApexClassForHandover(string qryCreateHandover, list<id> accIdLstTmp,  Map<id, Account> accOldMapRecTmp)
    {
        query=qryCreateHandover;
        idLst.addall(accIdLstTmp);
        accOldMapRec = accOldMapRecTmp;
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
        
        GA_AccountBatchApexClassForHandover.isBatchHandoInsert = true;
        list<GA_AccountHandOver__c> hndOveLst= GA_ACC_AP05_CreateHandoverRecord.createhandoverrec(scope, accMap, accOldMapRec);
        
        if(hndOveLst!= null && !hndOveLst.isEmpty()){
            id hndovrId;
            for(GA_AccountHandOver__c hndOvr:hndOveLst)
            {
                hndovrId=hndOvr.id;
                hndovrInsertIds.add(hndovrId);
            }
        }
        
    }
    /**method to execute post batch finishes*/
    global void finish(Database.BatchableContext bc)
    {	
        GA_HandoverBatchForInsertingTasks crtTasksBtch=new GA_HandoverBatchForInsertingTasks(qryCreateTsks, hndovrInsertIds);
        ID createTasksbatchprocessid = Database.executeBatch(crtTasksBtch,200); 
        
    }
}