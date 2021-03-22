/**
@Author : Steven Pascaran
@Name: GA_SalesOfficeBatch 
@CreatedDate: 22nd - July 2020 
@Description: GA_SalesOfficeBatch  Class is for updating the Account related to the Territories in the Sales Object.
@version : 1.0  
*/
global class GA_SalesOfficeBatch implements Database.Batchable<sObject>
{
    RecordType accRecType = [Select Id From RecordType  Where SobjectType = 'Account' and DeveloperName = 'Account_Customer' LIMIT 1];
    ID recTypeId = accRecType.Id;
    // Used by the constructor
    global Map<ID,GA_Sales_Office__c> terSalesMap = new Map<ID,GA_Sales_Office__c>();
    global List<String> terIdList = new List<String>();
    global String query = '';
    
    // Queries the Contacts that is updated and its Account Contact Relations
    global GA_SalesOfficeBatch(Map<ID,GA_Sales_Office__c> terMap){
        System.debug('Territory Map: ' +terMap);
        terSalesMap= terMap;
        for(String ter : terMap.keySet()){
            terIdList.add(ter);
        }
        query = 'SELECT Id, Name, Pharmacy_Team__c, GA_Territory__c FROM Account WHERE GA_Territory__c =: terIdList AND RecordTypeId =: recTypeId AND GA_Active_Account_Status__c = true ';
    }
    
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext bc,List<Account> batch){
        System.debug('Record : ' +batch);
        System.debug('terSalesMap : ' +terSalesMap);
        List<Account> accUpdateList = new List<Account>(); 
        for(Account acc : batch){
            GA_Sales_Office__c salesOff = terSalesMap.get(acc.GA_Territory__c);
            acc.Pharmacy_Team__c = salesOff.Pharmacy_Team__c;
            accUpdateList.add(acc);
        }
        
        update accUpdateList;
    }
    
    global void finish(Database.BatchableContext bc)
    {
        // Do nothing
    }
}