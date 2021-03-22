/***************************************************************************************************************************
@Author : Dilip
@Name: GA_GroupSegmentBatchForAddressUpdate 
@CreatedDate:  7/4/2018 
@Description: GA_GroupSegmentBatchForAddressUpdate class to update other city for bulk records.
@version : 1.0  
***************************************************************************************************************************/
global class GA_GroupSegmentBatchForAddressUpdate implements Database.Batchable<sObject>{
    global final string query;
    global final list<id> idLst=new list<id>();
    global List<Id> idsToProcess =new List<Id>();
    /**Constructor*/
    global GA_GroupSegmentBatchForAddressUpdate(string qrytoupdate, list<id> gsIds)
    {
        query=qrytoupdate;
        idLst.addall(gsIds);
    }
    /**method to start batch*/
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
        return Database.getQueryLocator(query); 
    }
    /**method to execute batch*/
    global void execute(Database.BatchableContext bc, List<GA_Group_Segment__c> scope)
    {	
        List<id> gsList = new List<id>();
        id grpId;
        for(GA_Group_Segment__c gs: scope){
            grpId=gs.id;
            gsList.add(grpId);
        }
        if(!gsList.isEmpty()){
            GA_GS_AP02_Update_Address.updateCityForBatch(gsList);
        }
    }
    /**method to execute post batch finishes*/
    global void finish(Database.BatchableContext bc)
    {
        
    }
}