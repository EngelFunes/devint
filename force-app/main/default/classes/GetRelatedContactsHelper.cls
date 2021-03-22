public with sharing class GetRelatedContactsHelper {
    @AuraEnabled
    public static List<AccountContactRelation> getRelatedContacts(String accId){
          List<AccountContactRelation> relatedContactsList= New List<AccountContactRelation>();
        try{ 
            relatedContactsList = [Select id, Contact.Name, Contact.Phone, Contact.GA_Contact_Role__c from AccountContactRelation where Contact.Active__c=true and AccountId =: accId]; 
        }   
        catch(Exception ex){throw new AuraHandledException(ex.getMessage());}
        return relatedContactsList; 
    }  
}