/***************************************************************************************************************************
@Author : Rahul
@Name: UnProcessedCityRecordsBatch 
@CreatedDate:  03/20/2020 
@Description: UnProcessedCityRecordsBatch class to update city records which are pending from future method 
@version : 1.0  
***************************************************************************************************************************/
global class UnProcessedCityRecordsBatch implements Database.Batchable<sObject>
{
    global final string query = 'SELECT Id, LastModifiedDate, GA_Billing_City_Other__c, GA_Mailing_City_Other__c, GA_Physical_City_Other__c FROM GA_Group_Segment__c WHERE Status__c=\'Active\' AND (GA_Billing_City_Other__c != null OR GA_Mailing_City_Other__c != null OR GA_Physical_City_Other__c  != null)';
    
    /**method to start batch*/
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
        return Database.getQueryLocator(this.query); 
    }
    /**method to execute batch*/
    global void execute(Database.BatchableContext bc, List<GA_Group_Segment__c> scope)
    {	
        List<Id> gsList = new List<Id>();
        for(GA_Group_Segment__c gs: scope)
        {
           gsList.add(gs.Id);
        }
        if(gsList.size()>0)
        {
            GA_GS_AP02_Update_Address.updateCityForBatch(gsList);
        }
    }
    /**method to execute post batch finishes*/
    global void finish(Database.BatchableContext bc)
    {
        
    }
}