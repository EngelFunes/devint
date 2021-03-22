/***************************************************************************************************************************
@Author : Rahul
@Name: removeCommissionAgentonGS_Batch 
@CreatedDate:  09/18/2020 
@Description: CommissionAgentonGS_Batch class to update commissioning agent on Group segment records. 
@version : 1.0  
***************************************************************************************************************************/
global class removeCommissionAgentonGS_Batch implements Database.Batchable<sObject>
{
    String query;
    global removeCommissionAgentonGS_Batch()
    {
    	this.query = 'SELECT Id, GA_Group_Segment_Id__c FROM GA_AOR_Group_Segment__c WHERE GA_Commission_End_Date__c = YESTERDAY';
    }
    global removeCommissionAgentonGS_Batch(String query)
    {
    	this.query = query;
    }
    
    /**method to start batch*/
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
        return Database.getQueryLocator(this.query); 
    }
    /**method to execute batch*/
    global void execute(Database.BatchableContext bc, List<GA_AOR_Group_Segment__c> scope)
    {	
        GA_AORGrpSgmntTriggerHandler.removeCommissionAgentFlag = true;
        GA_AORGrpSgmntTriggerHandler.commissionAgentOnGS(scope);
    }
    /**method to execute post batch finishes*/
    global void finish(Database.BatchableContext bc)
    {
    
    }
}