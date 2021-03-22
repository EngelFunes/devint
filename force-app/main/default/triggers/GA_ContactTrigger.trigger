/*******************************************************************************************************************************
@Author : Dilip Junapala
@Name: GA_ContactTrigger 
@CreatedDate: 19 - Apr 2018 
@Description: GA_ContactTrigger trigger is for performing business logics on contact
@version : 1.0  
********************************************************************************************************************************/
trigger GA_ContactTrigger on Contact (after update, before insert, before update, after insert) {
	static final String triggerName = 'GA_ContactTrigger';
	Map<String, User> conUserMap = new Map<String, User>();
	Set<Id> contactsToUpsert = new Set<Id>();
    List<String> newConList = new List<String>();   
	Set<Id> contactsToInsert = new Set<Id>();
    
    GA_OBJ_TriggerRunCheck__mdt triggrrunchk =GA_OBJ_TD01_TestDataCreation.triggercheck(triggerName);
    
    if(triggrrunchk.GA_TriggerTurnOn__c)
    {   
        if(trigger.isbefore && trigger.isInsert)
        {
            GA_ContactTriggerHandler.checkExistingContactsForDuplicate(trigger.new);
            GA_ContactTriggerHandler.beforeInsert(trigger.new);			
        }
		
		if(trigger.isAfter && trigger.isInsert)		
        {
			for(Contact contct : [select id, Email,ARV_Agent_Portal_User_Id__c, FirstName, LastName, AccountId, Account.Name, MailingStateCode, Agent_Code__c 
		      from contact WHERE ARV_Agent_Portal_User_Id__c != null AND Email != null AND Id IN :trigger.new]){
              contactsToInsert.add(contct.id);
			}
		    system.debug('contactsToInsert '+contactsToInsert);
			if (contactsToInsert.size() > 0) {           
                System.debug('***Contacts to Insert***'+contactsToInsert);
				Database.executeBatch(new GA_AP_CreatePartnerUsers(contactsToInsert), 20); 
			}    
        }
        
        if(trigger.isbefore && trigger.isUpdate)
        {
            GA_ContactTriggerHandler.beforeUpdate(trigger.new, trigger.oldMap);
            
        } 
        
        if(trigger.isafter && trigger.isUpdate){
		  
          System.debug('entering Update');
		  for(User u : [SELECT Id, ContactId, Email,FederationIdentifier FROM User WHERE ContactId IN :Trigger.New]){
              conUserMap.put(u.ContactId, u);
              System.debug('***conUserMap***'+conUserMap);
          }
		  
		  for(Contact con : Trigger.New){
              User usr = conUserMap.get(con.Id);
              if(usr != null){
                  if(usr.Email != con.Email){
                      contactsToUpsert.add(con.Id);
                      System.debug('***New Contact to Upsert***'+con.Id);
                  }
              }else{
                  
                  newConList.add(con.Id); 
                  System.debug('***New Contact List***'+con.Id);
              }
            }
			conUserMap = null;
			for(Contact con : [SELECT Id, Account.IsPartner FROM Contact WHERE Id IN :newConList]){
              if(con.Account.IsPartner )
                 contactsToUpsert.add(con.Id);
			}
			if(System.IsBatch() == false && System.isFuture() == false && contactsToUpsert.size() > 0){ 
				Database.executeBatch(new GA_AP_CreatePartnerUsers(contactsToUpsert), 20);
			}
		  
            GA_ContactTriggerHandler.afterupdate(trigger.new, trigger.newmap,trigger.oldmap);
        }  
    }
}