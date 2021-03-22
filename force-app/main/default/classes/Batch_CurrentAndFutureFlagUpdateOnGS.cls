/***************************************************************************************************************************
@Author : Rahul
@Name: Batch_CurrentAndFutureFlagUpdateOnGS 
@CreatedDate:  04/14/2020 
@Description: Batch_CurrentAndFutureFlagUpdateOnGS class to update GA_Current_Plan_Package__c & GA_Future_Plan_Package__c on Group Segments
@version : 1.0  
***************************************************************************************************************************/
global class Batch_CurrentAndFutureFlagUpdateOnGS implements Database.Batchable<sObject>
{
    String query;
    global Batch_CurrentAndFutureFlagUpdateOnGS()
    {
    	this.query = 'SELECT Id, GA_Future_Plan_Package_Chk__c, GA_Current_Plan_Package__c FROM GA_Group_Segment__c WHERE (GA_Current_Plan_Package__c = True OR GA_Future_Plan_Package_Chk__c = True)';
    }
    global Batch_CurrentAndFutureFlagUpdateOnGS(String query)
    {
    	this.query = query;
    }
    
    /**method to start batch*/
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
        return Database.getQueryLocator(this.query); 
    }
    /**method to execute batch*/
    global void execute(Database.BatchableContext bc, List<GA_Group_Segment__c> scope)
    {	
        List<GA_Group_Segment__c> lstGStoUpdate = new List<GA_Group_Segment__c>();
        for(GA_Group_Segment__c gs: scope)
        {
            gs.GA_Future_Plan_Package_Chk__c = False;
            gs.GA_Current_Plan_Package__c = False;
           	lstGStoUpdate.add(gs);
        }
        system.debug('===lstGStoUpdate=='+lstGStoUpdate.size());
        if(lstGStoUpdate.size()>0)
        {
            update lstGStoUpdate;
        }
    }
    /**method to execute post batch finishes*/
    global void finish(Database.BatchableContext bc)
    {
        
    }
}