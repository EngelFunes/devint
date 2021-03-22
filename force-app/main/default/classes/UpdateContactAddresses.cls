global class UpdateContactAddresses implements Database.Batchable<sObject>, Database.Stateful{
    global String query;
    global Database.QueryLocator start(Database.BatchableContext bc){
        query = 'SELECT ID, GA_CEO__r.FIRSTNAME, GA_CEO__r.LASTNAME,'
            +'CID__c,'
            +'GA_Decision_Maker__r.FIRSTNAME, GA_Decision_Maker__r.LASTNAME,'
            +'GA_Consultant__r.FIRSTNAME, GA_Consultant__r.LASTNAME,'
            +'GA_Mutual_Voter__r.FIRSTNAME, GA_Mutual_Voter__r.LASTNAME,'
            +'GA_Principal_Admin__r.FIRSTNAME, GA_Principal_Admin__r.LASTNAME,'
            +'GA_Principal_Admin_Pin__c,'
            +'(SELECT Id, FirstName, LastName, GA_SMART_ID__c, Email, AccountId, Active__c, GA_Contact_Role__c,Title,Phone FROM Contacts WHERE Active__c = TRUE)'
            +'FROM Account WHERE Account.RecordType.Name = \'Account - Prospect\' AND GA_Territory__r.GA_TerritoryCode__c NOT IN (\'AF\',\'AG\',\'AH\',\'AI\',\'AK\',\'AL\',\'AM\',\'AN\',\'AO\',\'AP\',\'AS\',\'AT\',\'AV\',\'AW\',\'AZ\') LIMIT 50000';
        
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext bc, List<Account> scope){
        List<Account> intcntlist = new List<Account>(scope);
        
        Set<String> tempAccountId = new Set<String>();
        for(Account tempintcntlist: intcntlist){
            if(tempintcntlist.Id != Null){
                tempAccountId.add(tempintcntlist.Id);
            }
        }
        List<Contact> samecnctlist = new List<Contact>();
        List<Contact> contactToInactivate = new List<Contact>();
        List<Contact> contactToActivate = new List<Contact>();
        List<Contact> contactsForUpdate = new List<Contact>();
        List<Account> accountsToUpdate = new List<Account>();
         //List<GA_Group_Segment__c> groupSegmentList = new List<GA_Group_Segment__c>();
      	List<GA_Group_Segment__c> groupSegmentList = [SELECT Id, GA_Administrative_Contact_Id__r.FIRSTNAME, GA_Administrative_Contact_Id__r.LASTNAME,
            GA_Billing_Contact_Id__r.FIRSTNAME, GA_Billing_Contact_Id__r.LASTNAME,
            GA_Commissioning_Agent__r.FIRSTNAME, GA_Commissioning_Agent__r.LASTNAME,
            GA_Consultant_Id__r.FIRSTNAME, GA_Consultant_Id__r.LASTNAME,
            GA_Level_1_Appeals_Contact__r.FIRSTNAME, GA_Level_1_Appeals_Contact__r.LASTNAME,
            GA_Level_2_Appeals_Contact__r.FIRSTNAME, GA_Level_2_Appeals_Contact__r.LASTNAME,
            GA_Servicing_Agent__r.FIRSTNAME, GA_Servicing_Agent__r.LASTNAME,
            GA_Account__c FROM GA_Group_Segment__c WHERE (Status__c = 'Canceled' AND GA_Account__c IN: tempAccountId)];
        
        List<GA_Group_Segment__c> groupSegmentToUpdate = new List<GA_Group_Segment__c>();
        Set<String> superContactInText = new Set<String>();
        Set<String> superContactInTextNoRole = new Set<String>();
        Map<String, Id> suprcnct = new Map<String, Id>();
        Map<String, Id> suprcnctNoRole = new Map<String, Id>();
        String tempContactText;
        String tempContactText2;
        
        
        List<Contact> CompareCon1 = new List<Contact>(contactToActivate);
        List<Contact> CompareCon2 = new List<Contact>(contactToInactivate);
        
        
        //GET ALL CONTACT AND GROUP SEGMENT LISTS
        for(Account custAcc: intcntlist){
            samecnctlist.addAll(custAcc.Contacts);
            
            //for(GA_Group_Segment__c gs : custAcc.Group_Segments__r){
			//	groupSegmentList.add(gs);                
           // }
            //groupSegmentList.addAll(custAcc.Group_Segments__r);
        }
        
        //THIS IS TO GET THE SUPER CONTACT
        for(Contact conRecord: samecnctlist){
            if(conRecord.FirstName != NULL && conRecord.LastName != NULL && conRecord.GA_SMART_ID__c != NULL /*&& conRecord.Email != NULL*/ 
               && conRecord.GA_Contact_Role__c != NULL){
                   tempContactText = conRecord.AccountId+conRecord.FirstName+conRecord.LastName/*+conRecord.GA_Contact_Role__c*/;
                   if(!superContactInText.contains(tempContactText)){
                       superContactInText.add(tempContactText);
                       //SUPER CONTACTS WILL BE STORED HERE (suprcnct) - It contains the AccountId+FirstName+Lastname as the Map Keys, value is the Contact Id
                       suprcnct.put(String.ValueOf(conRecord.AccountId+conRecord.FirstName+conRecord.LastName/*+conRecord.GA_Contact_Role__c*/),conRecord.Id);
                       contactToActivate.add(new Contact(Id = conRecord.Id, Active__c = TRUE, FirstName = conRecord.FirstName,LastName = conRecord.LastName, GA_Contact_Role__c = conRecord.GA_Contact_Role__c));
                   } 
                   else {
                       //CONTACTS THAT WILL BE INACTIVATED
                       conRecord.Active__c = FALSE;
                       conRecord.GA_SMART_ID__c = '';
                       contactToInactivate.add(conRecord);
                       
                   }
                   tempContactText = '';
               }
            else if(conRecord.FirstName != NULL && conRecord.LastName != NULL /*&& conRecord.Email != NULL*/ && conRecord.GA_SMART_ID__c != NULL 
                    && conRecord.GA_Contact_Role__c == NULL){
                        tempContactText2 = conRecord.AccountId+conRecord.FirstName+conRecord.LastName;
                        if(!superContactInTextNoRole.contains(tempContactText2)){
                            superContactInTextNoRole.add(tempContactText2);
                            //SUPER CONTACTS WILL BE STORED HERE (suprcnctNoRole) - It contains the AccountId+FirstName+Lastname as the Map Keys, value is the Contact Id
                            suprcnctNoRole.put(String.ValueOf(conRecord.AccountId+conRecord.FirstName+conRecord.LastName),conRecord.Id);
                            
                            
                        } 
                        else {
                            //CONTACTS THAT WILL BE INACTIVATED
                            conRecord.Active__c = FALSE;
                            conRecord.GA_SMART_ID__c = '';
                            contactToInactivate.add(conRecord);
                            
                        }
                        tempContactText2 = '';
                    }
             else if(conRecord.FirstName != NULL && conRecord.LastName != NULL && conRecord.GA_SMART_ID__c == NULL && (conRecord.Title != NULL || conRecord.Email != NULL || conRecord.Phone != NULL)){
                        tempContactText2 = conRecord.AccountId+conRecord.FirstName+conRecord.LastName;
                        if(!superContactInTextNoRole.contains(tempContactText2)){
                            superContactInTextNoRole.add(tempContactText2);
                            //SUPER CONTACTS WILL BE STORED HERE (suprcnctNoRole) - It contains the AccountId+FirstName+Lastname as the Map Keys, value is the Contact Id
                            suprcnctNoRole.put(String.ValueOf(conRecord.AccountId+conRecord.FirstName+conRecord.LastName),conRecord.Id);
                            
                            
                        } 
                        else {
                            //CONTACTS THAT WILL BE INACTIVATED
                            conRecord.Active__c = FALSE;
                            conRecord.GA_SMART_ID__c = '';
                            contactToInactivate.add(conRecord);
                            
                        }
                        tempContactText2 = '';
                    }
            else {
                //CONTACTS THAT WILL BE INACTIVATED
                conRecord.Active__c = FALSE;
                conRecord.GA_SMART_ID__c = '';
                contactToInactivate.add(conRecord);
            }
        }
        
        //This function will compare the inactive and super contact and transfer the picklist value of the inactive contact to the supercontact
        list<Contact> rolecontact = new list<Contact>();
        If(!contactToActivate.isEmpty())
        {
            for(Contact con: contactToActivate)
            {
                If(!contactToInactivate.isEmpty())
                {
                    for(Contact con2: contactToInactivate)
                    {
                        If(con2.GA_Contact_Role__c != Null)
                        {
                            if((con.FirstName == con2.FirstName) && (con.LastName == con2.LastName) && (con2.GA_Contact_Role__c != NULL))
                            {
                                List<string> RoleList = string.valueOf(con2.GA_Contact_Role__c).split(';');
                                
                                
                                for(string str : RoleList)
                                {
                                    if(!string.valueOf(con.GA_Contact_Role__c).contains(str))
                                    {
                                        con.GA_Contact_Role__c = con.GA_Contact_Role__c+';'+str;
                                    }
                                }     
                                con2.GA_Contact_Role__c = NULL;
                                break;
                            }    
                        }                                 
                    } 
                }                    
            } 
        }                         
        
        for(String sprConNoRole: suprcnctNoRole.keyset()){
            if(suprcnct.containsKey(sprConNoRole)){
                contactToInactivate.add(new Contact(Id = suprcnctNoRole.get(sprConNoRole), Active__c = FALSE/*, GA_SMART_ID__c = ''*/));
            } 
            else if(!suprcnct.containsKey(sprConNoRole)){
                superContactInText.add(sprConNoRole);
                suprcnct.put(sprConNoRole, suprcnctNoRole.get(sprConNoRole));
                contactToActivate.add(new Contact(Id = suprcnctNoRole.get(sprConNoRole), Active__c = TRUE));
            }
        }
        //system.debug('Inactive Contacts' +contactToInactivate);
        
        //system.debug('Active Contacts' +contactToActivate);
        
        //THIS IS TO UPDATE ACCOUNTS
        for(Account custAcc: intcntlist){
            if(custAcc.GA_CEO__r.FIRSTNAME != NULL || custAcc.GA_CEO__r.LASTNAME != NULL){
                if(suprcnct.get(String.ValueOf(custAcc.Id+custAcc.GA_CEO__r.FIRSTNAME+custAcc.GA_CEO__r.LASTNAME)) != NULL){
                    custAcc.GA_CEO__c = suprcnct.get(String.ValueOf(custAcc.Id+custAcc.GA_CEO__r.FIRSTNAME+custAcc.GA_CEO__r.LASTNAME));
                }
            }
            if(custAcc.GA_Decision_Maker__r.FIRSTNAME != NULL || custAcc.GA_Decision_Maker__r.LASTNAME != NULL){
                if(suprcnct.get(String.ValueOf(custAcc.Id+custAcc.GA_Decision_Maker__r.FIRSTNAME+custAcc.GA_Decision_Maker__r.LASTNAME)) != NULL){
                    custAcc.GA_Decision_Maker__c = suprcnct.get(String.ValueOf(custAcc.Id+custAcc.GA_Decision_Maker__r.FIRSTNAME+custAcc.GA_Decision_Maker__r.LASTNAME));
                }
            }
            if(custAcc.GA_Consultant__r.FIRSTNAME != NULL || custAcc.GA_Consultant__r.LASTNAME != NULL){
                if(suprcnct.get(String.ValueOf(custAcc.Id+custAcc.GA_Consultant__r.FIRSTNAME+custAcc.GA_Consultant__r.LASTNAME)) != NULL){
                    custAcc.GA_Consultant__c = suprcnct.get(String.ValueOf(custAcc.Id+custAcc.GA_Consultant__r.FIRSTNAME+custAcc.GA_Consultant__r.LASTNAME));
                }
            }
            if(custAcc.GA_Mutual_Voter__r.FIRSTNAME != NULL || custAcc.GA_Mutual_Voter__r.LASTNAME != NULL){
                if(suprcnct.get(String.ValueOf(custAcc.Id+custAcc.GA_Mutual_Voter__r.FIRSTNAME+custAcc.GA_Mutual_Voter__r.LASTNAME)) != NULL){
                    custAcc.GA_Mutual_Voter__c = suprcnct.get(String.ValueOf(custAcc.Id+custAcc.GA_Mutual_Voter__r.FIRSTNAME+custAcc.GA_Mutual_Voter__r.LASTNAME));
                }
            }
            if(custAcc.GA_Principal_Admin__r.FIRSTNAME != NULL || custAcc.GA_Principal_Admin__r.LASTNAME != NULL){
                if(suprcnct.get(String.ValueOf(custAcc.Id+custAcc.GA_Principal_Admin__r.FIRSTNAME+custAcc.GA_Principal_Admin__r.LASTNAME)) != NULL){
                    custAcc.GA_Principal_Admin__c = suprcnct.get(String.ValueOf(custAcc.Id+custAcc.GA_Principal_Admin__r.FIRSTNAME+custAcc.GA_Principal_Admin__r.LASTNAME));
                }
            }
            
            accountsToUpdate.add(custAcc);
        }
        
        //THIS IS TO UPDATE GROUP SEGMENTS
        for(GA_Group_Segment__c gSegment: groupSegmentList){
            if(gSegment.GA_Administrative_Contact_Id__r.FIRSTNAME != NULL || gSegment.GA_Administrative_Contact_Id__r.LASTNAME != NULL){
                if(suprcnct.get(String.ValueOf(gSegment.GA_Account__c+gSegment.GA_Administrative_Contact_Id__r.FIRSTNAME+gSegment.GA_Administrative_Contact_Id__r.LASTNAME)) != NULL){
                    gSegment.GA_Administrative_Contact_Id__c = suprcnct.get(String.ValueOf(gSegment.GA_Account__c+gSegment.GA_Administrative_Contact_Id__r.FIRSTNAME+gSegment.GA_Administrative_Contact_Id__r.LASTNAME));
                }
            }
            if(gSegment.GA_Billing_Contact_Id__r.FIRSTNAME != NULL || gSegment.GA_Billing_Contact_Id__r.LASTNAME != NULL){
                if(suprcnct.get(String.ValueOf(gSegment.GA_Account__c+gSegment.GA_Billing_Contact_Id__r.FIRSTNAME+gSegment.GA_Billing_Contact_Id__r.LASTNAME)) != NULL){
                    gSegment.GA_Billing_Contact_Id__c = suprcnct.get(String.ValueOf(gSegment.GA_Account__c+gSegment.GA_Billing_Contact_Id__r.FIRSTNAME+gSegment.GA_Billing_Contact_Id__r.LASTNAME));
                }
            }
            if(gSegment.GA_Consultant_Id__r.FIRSTNAME != NULL || gSegment.GA_Consultant_Id__r.LASTNAME != NULL){
                if(suprcnct.get(String.ValueOf(gSegment.GA_Account__c+gSegment.GA_Consultant_Id__r.FIRSTNAME+gSegment.GA_Consultant_Id__r.LASTNAME)) != NULL){
                    gSegment.GA_Consultant_Id__c = suprcnct.get(String.ValueOf(gSegment.GA_Account__c+gSegment.GA_Consultant_Id__r.FIRSTNAME+gSegment.GA_Consultant_Id__r.LASTNAME));
                }
            }
            if(gSegment.GA_Level_1_Appeals_Contact__r.FIRSTNAME != NULL || gSegment.GA_Level_1_Appeals_Contact__r.LASTNAME != NULL){
                if(suprcnct.get(String.ValueOf(gSegment.GA_Account__c+gSegment.GA_Level_1_Appeals_Contact__r.FIRSTNAME+gSegment.GA_Level_1_Appeals_Contact__r.LASTNAME)) != NULL){
                    gSegment.GA_Level_1_Appeals_Contact__c = suprcnct.get(String.ValueOf(gSegment.GA_Account__c+gSegment.GA_Level_1_Appeals_Contact__r.FIRSTNAME+gSegment.GA_Level_1_Appeals_Contact__r.LASTNAME));
                }
            }
            if(gSegment.GA_Level_2_Appeals_Contact__r.FIRSTNAME != NULL || gSegment.GA_Level_2_Appeals_Contact__r.LASTNAME != NULL){
                if(suprcnct.get(String.ValueOf(gSegment.GA_Account__c+gSegment.GA_Level_2_Appeals_Contact__r.FIRSTNAME+gSegment.GA_Level_2_Appeals_Contact__r.LASTNAME)) != NULL){
                    gSegment.GA_Level_2_Appeals_Contact__c = suprcnct.get(String.ValueOf(gSegment.GA_Account__c+gSegment.GA_Level_2_Appeals_Contact__r.FIRSTNAME+gSegment.GA_Level_2_Appeals_Contact__r.LASTNAME));
                }
            }
            if(gSegment.GA_Administrative_Contact_Id__c != NULL){
            }
            groupSegmentToUpdate.add(gSegment);
        }
        
        if(contactToInactivate.size() > 0){
            contactsForUpdate.addAll(contactToInactivate);
        }
        if(contactToActivate.size() > 0){
            contactsForUpdate.addAll(contactToActivate);
        }
        if(contactsForUpdate.size() > 0){
            update contactsForUpdate;
        }
        if(accountsToUpdate.size() > 0){
            update accountsToUpdate;
        }
        if(groupSegmentToUpdate.size() > 0){
            update groupSegmentToUpdate;
        }
    }
    
    global void finish(Database.BatchableContext bc){
        
    }    
}