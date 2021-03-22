/**
@Author : Steven John Pascaran
@Name: GA_UpdateTerRetSalesRepBatch 
@CreatedDate: 24-Mar-2020 
@Description: GA_UpdateTerRetSalesRepBatch class to update Territory object's Retention Sales Representative
@version : 1.0  
*/
global class GA_UpdateTerRetSalesRepBatch implements Database.Batchable<sObject>,Database.AllowsCallouts {
    global static final string curdte=string.valueof(system.today()).split(' ')[0];
    /*Query has been modified to accomodate the Past Dates wherein prev. only the Future date*/
    global static final string queryString = 'SELECT Id, Name, Territory__c, Future_Retention_Sales_Representative__c, Future_Effective_Rep_Date__c FROM Retention_Sales_Representative_History__c WHERE (Future_Effective_Rep_Date__c  < '+curdte +'AND Override_Past_Date__c = true) OR Future_Effective_Rep_Date__c  = '+curdte;
    
    /**method to start batch*/
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
        String query= queryString;
        return Database.getQueryLocator(query); 
    }
    /**method to execute batch*/
    global void execute(Database.BatchableContext bc, List<Retention_Sales_Representative_History__c> scope)
    {   
        Map<String,Retention_Sales_Representative_History__c> terMap = new Map<String,Retention_Sales_Representative_History__c>();
            
        For(Retention_Sales_Representative_History__c salesRep : scope){
            terMap.put(salesRep.Territory__c , salesRep);
        }        
        
        List<GA_Territory__c> terList = [SElECT Id, GA_RetentionSalesRepresentative__c, GA_Sales_Rep_Effective_Date__c  FROM GA_Territory__c WHERE Id =: terMap.keySet()];
        List<GA_Territory__c> terListUpdate = new List<GA_Territory__c>();
        List<Retention_Sales_Representative_History__c> retSalesListUpdate = new List<Retention_Sales_Representative_History__c>();
        
        For(GA_Territory__c ter : terList){
            Retention_Sales_Representative_History__c salesRep = terMap.get(ter.Id);
            salesRep.Override_Past_Date__c = false;
            ter.GA_RetentionSalesRepresentative__c = salesRep.Future_Retention_Sales_Representative__c;
            ter.GA_Sales_Rep_Effective_Date__c = salesRep.Future_Effective_Rep_Date__c;
            terListUpdate.add(ter);
            retSalesListUpdate.add(salesRep);
        }
        update terListUpdate;
        update retSalesListUpdate;
    }
    /**method to execute post batch finishes*/
    global void finish(Database.BatchableContext bc)
    {
    }
}