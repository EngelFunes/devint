public with sharing class GetRelatedSupportRequestHelper {
    @AuraEnabled
    public static List<Case> getRelatedCases(String accId){
          List<Case> relatedCasesList= New List<Case>();
          
        try{ 
            relatedCasesList = [Select id, Subject, CaseNumber, Case_Owner__c, Contact.Name, Account.Name, Status,External_Status__c,
            CreatedDate, Support_Number__c from Case where Accountid =: accId]; 
        }   
        catch(Exception ex){throw new AuraHandledException(ex.getMessage());}
        return relatedCasesList; 
    }  
}