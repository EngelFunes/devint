global class GA_AP_CreatePartnerUsers implements Database.Batchable<sObject>{
    
       global Set<Id> listOfContacts = new Set<Id>();
       global String query = '';           
       global GA_AP_CreatePartnerUsers(Set<Id> contactsList){
         System.debug('Contacts List : ' +contactsList);
          listOfContacts= contactsList;
          query = 'select id, Email,ARV_Agent_Portal_User_Id__c, phone, FirstName, LastName, AccountId,Account.Name, MailingStateCode, Agent_Code__c,vlocity_ins__Type__c from contact where id in :listOfContacts AND ARV_Agent_Portal_User_Id__c != Null AND AccountId != Null';
       }
    
       global Database.QueryLocator start(Database.BatchableContext BC){
          return Database.getQueryLocator(query);
       }
    
       global void execute(Database.BatchableContext BC, List<sObject> scope){
         Map<Id, Account> accMap = new Map<Id, Account>();
         Set<Id> accSet = new Set<Id>();
         Map<String, User> userConMap = new Map<String, User>();
         Map<String, Contact> conMap = new Map<String, Contact>();
         List<User> usersToUpsert = new List<User>();
         
         system.debug('scope:'+scope);
         
         for(sobject s : scope){
              Contact con = (Contact)s;
              conMap.put(con.Id, con);
              accSet.add(con.AccountId);
         }
         System.debug('***ConMap :***' +conMap);
         System.debug('***accSet*** ' +accSet);
         for(Account acc : [SELECT Id, Name, GA_Agency_Code__c, IsPartner FROM Account WHERE Id IN :accSet]){
             System.debug('***acc*** ' +acc);                            
             if(acc.IsPartner)
               accMap.put(acc.Id, acc); 
         }
         System.debug('***accMap***' +accMap);
         for(User usr : [select id, contactid,FederationIdentifier from User where contactid in : conMap.keySet() and profile.Name = 'BCBSM FSA Login']){
              userConMap.put(usr.contactId, usr);
         }
         System.debug('***userConMap***' +userConMap);
         Organization thisOrg = [SELECT InstanceName,IsSandbox,Name,NamespacePrefix,OrganizationType FROM Organization];
         Profile BCBSMFSAProfile = [SELECT Id FROM Profile WHERE Name LIKE '%BCBSM FSA Login%' Limit 1];
            for(String conId : conMap.keySet()){
              Contact con = conMap.get(conId);
              User usr = userConMap.get(conId);
              System.debug('***con***' +con);
              System.debug('***ConMapSize***'+conMap.size());
              System.debug('***usr**:'+usr);
              if(con != Null && (accMap.containsKey(con.AccountId) && accMap.get(con.AccountId) != null && accMap.get(con.AccountId).GA_Agency_Code__c != null) && string.isNotBlank(con.Email) && String.isNotBlank(con.ARV_Agent_Portal_User_Id__c))
              {
              System.debug('***Debug Statement***');
              
              if(usr != null){
                  System.debug('*UserIf*');
                    User u = new User(Id = usr.Id); 
                         u.FederationIdentifier = con.Email;                       
                         u.Email=con.Email;                        
                         /*Nickname is updated by concatenating the full name with Agent */  
						 if (con.vlocity_ins__Type__c != 'Agent') 
						{
							u.CommunityNickname = con.FirstName.substring(0,1) + string.valueof(con.Id).substring(12,18); 
						}
						else{
							u.CommunityNickname = con.FirstName +' '+ con.LastName +' '+ con.Agent_Code__c; 
						}
                 
                    usersToUpsert.add(u);
                     
               }
               else{
                   System.debug('***UserElse***');
                    String buildUserNameExt = '';
					String UsrName ='';
					String CommName = '';
                    If (thisOrg.isSandbox){
                      buildUserNameExt = '.'+ thisOrg.InstanceName;
                    }   
                    if (con.vlocity_ins__Type__c != 'Agent') 
		    		{
						   UsrName = con.Email+'.'+'bcbsmagentgroup'+buildUserNameExt;
						   CommName = con.FirstName.substring(0,1)+ string.valueof(con.Id).substring(12,18);
		    		}
		    		else
		    		{
						    UsrName = con.FirstName.deleteWhitespace()+'.'+con.LastName.deleteWhitespace()+'-'+con.Agent_Code__c+'@bcbsm.agent'+buildUserNameExt;
							CommName = con.FirstName +' '+ con.LastName +' '+ con.Agent_Code__c; 
		    		}						
                    User PartnerUser = new User(FirstName = con.FirstName, 
                         Username = UsrName,
			 			 ContactId = con.Id, 
                         ProfileId = BCBSMFSAProfile.Id,
                         Alias =con.FirstName.substring(0,1) + string.valueof(con.Id).substring(12,18), 
                         Email = con.Email,
                         EmailEncodingKey = 'UTF-8',
                         LastName = con.LastName,
                         /*Nickname is updated from Agent Id to Contact Full Name */
			 			 CommunityNickname = CommName, 
                         TimeZoneSidKey = 'America/New_York',
                         LocaleSidKey = 'en_US',
                         LanguageLocaleKey = 'en_US',
                         StateCode = con.MailingStateCode,
                         FederationIdentifier = con.email,                         
                         isActive=true);
                         System.debug('PartnerUser Object&&&&&&&:'+PartnerUser );
                         usersToUpsert.add(PartnerUser);
                   }
               }
          }
                     
           List<Database.UpsertResult> upsertResults = Database.upsert(usersToUpsert,false);
           System.debug('***usersToUpsert***' +usersToUpsert);  
           for(Integer i=0;i<upsertResults.size();i++){				
			 if (!upsertResults.get(i).isSuccess()){
			   // DML operation failed
					Database.Error error = upsertResults.get(i).getErrors().get(0);
				    String failedDML = error.getMessage();
			  }

			}
           
        }
    
       global void finish(Database.BatchableContext BC){
       }
    }