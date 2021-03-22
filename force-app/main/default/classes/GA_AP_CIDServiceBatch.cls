/**
@Author : Raj Jena
@Name: GA_AP_CIDServiceBatch 
@CreatedDate: 15-Jan-2018 
@Description: GA_AP_CIDServiceBatch class to update CID in account for failed accounts 
@version : 1.0  
*/
global class GA_AP_CIDServiceBatch implements Database.Batchable<sObject>,Database.AllowsCallouts {
    global static final string queryString = 'SELECT Id,Object_ID__c from ExceptionLog__c WHERE Object_ID__c  != Null AND WSCallingApplication__c=\''+system.label.GA_CIDService+'\' AND ExceptionCode__c  != \''+String.escapeSingleQuotes('S0000')+'\' AND NumberOfTimesOccured__c <= 4  AND status__c = \''+String.escapeSingleQuotes('Failure')+'\'';
    global static final string cidValue = '';
    global static final string accProsRecTyp='Account - Prospect';
    /**method to start batch*/
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
        String query= queryString;
        return Database.getQueryLocator(query); 
    }
    /**method to execute batch*/
    global void execute(Database.BatchableContext bc, List<ExceptionLog__c> scope)
    {
        List<String> accIdList = new  List<String> ();
        string prspctRecTpId=Schema.SObjectType.Account.getRecordTypeInfosByName().get(System.Label.GA_ProspectRecType).getRecordTypeId();
         
        if(scope.size() > 0){
            for(ExceptionLog__c Exp : scope){
                Id accId = Exp.Object_ID__c;
                accIdList.add(accId);
            }
        }
        if(accIdList.size() > 0){
            Map<ID, Account> accMap = new Map<ID, Account>([select id,ShippingStateCode, CID__c,GA_SMART_ID__c,Name,Federal_Tax_ID__c,GA_Territory__r.GA_TerritoryCode__c,phone,ShippingStreet, ShippingCity, ShippingState, ShippingPostalCode,ShippingCountry,RecordTypeId from account where id in: accIdList and CID__c =: cidValue and recordtypeid=:prspctRecTpId Limit 100]);
              
                   GA_AP_InvokeCIServOnBatch.fetchCIDServiceResponses(accMap);
               
            
        }
    }
    /**method to execute post batch finishes*/
    global void finish(Database.BatchableContext bc)
    {
        
    }
}