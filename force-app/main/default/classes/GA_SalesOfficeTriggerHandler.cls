/**
@Author : Steven Pascaran
@Name: GA_SalesOfficeTriggerHandler 
@CreatedDate: 6th - June 2020 
@Description: GA_SalesOfficeTriggerHandler   Class is for handling Sales office trigger handler.
@version : 1.0  
*/
public class GA_SalesOfficeTriggerHandler {
    
    public static final String OFTERR ='OF';
    public static final String CLTERR ='CL';
    public static final String CDTERR ='CD';
    
    public static void beforeupdate(list<GA_Sales_Office__c> salesOffList, map<id,GA_Sales_Office__c> salesOffNewMap, map<id,GA_Sales_Office__c>  salesOffOldMap)
    {
        Map<ID,GA_Sales_Office__c> terMap = new Map<ID,GA_Sales_Office__c>();
        //List<Account> accUpdateList = new List<Account>();
        //List<Id> accUpdateList = new List<Id>();
        
        for(GA_Territory__c ter : [SELECT ID, GA_TerritoryCode__c, GA_Sales_Office__c FROM GA_Territory__c WHERE GA_Sales_Office__c =: salesOffNewMap.keySet()]){
            if(ter.GA_TerritoryCode__c != OFTERR && ter.GA_TerritoryCode__c != CLTERR && ter.GA_TerritoryCode__c != CDTERR){
                terMap.put(ter.Id,salesOffNewMap.get(ter.GA_Sales_Office__c));
            }
        }
        
        /*for(Account acc : [SELECT ID, Pharmacy_Team__c, GA_Territory__c FROM Account WHERE GA_Territory__c =: terMap.keySet()]){
            GA_Sales_Office__c salesOff = terMap.get(acc.GA_Territory__c);
            //acc.Pharmacy_Team__c = salesOff.Pharmacy_Team__c;
            //accUpdateList.add(acc);
            accUpdateList.add(acc.Id);
        }*/
        
        system.debug(terMap.size());
        if(terMap.size() > 0){
            Database.executeBatch(new GA_SalesOfficeBatch(terMap), 100);
        }
        
        //database.update(accUpdateList);
    }
}