global class ADRAccountShare implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext BC) {
        Id recTypeIdagency = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Account_Agency').getRecordTypeId();
        String query = 'select id,name,recordtype.name from Account WHERE RecordTypeId = \'' + recTypeIdagency + '\'';
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext BC, List<Account> accList) {
        System.debug(accList.size());
        Map<Id,Account> accMap = new Map<Id,Account>();
        Map<Id,List<Contact>> cMap = new Map<Id,List<Contact>>();
        for(Account a : accList){
            accMap.put(a.Id,a);
        }
        List<Contact> cList = [select Id,AccountId,Name,RecordTypeId,vlocity_ins__Type__c from Contact where AccountId =: accMap.keyset()];
        for(Contact c : cList){
            if(cMap.get(c.AccountId) != null){
                List<Contact> tmpCon = new List<Contact>();
                for(contact tc : cMap.get(c.AccountId)){
                    tmpCon.add(tc);
                }
                tmpCon.add(c);
                cMap.put(c.AccountId,tmpCon);
            }
            else{
                List<Contact> tmpCon = new List<Contact>();
                tmpCon.add(c);
                cMap.put(c.AccountId,tmpCon);
            }
        }
        Map<Id,Set<Id>> conAccMap = new Map<Id,Set<Id>>();
        Id recTypeIdofcontact = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get(System.label.Contact_Delegate_Agent_Record_Type).getRecordTypeId();
        Set<Id> conIds = new Set<Id>();
        List<Accountshare> deleteAccShareList = new List<Accountshare>();
        List<Accountshare> accShareList = new List<Accountshare>();
        Map<Id,Contact> conMap;
        Map<Id,Id> userMap = new Map<Id,Id>();
        List<Account> accountList = accMap.values();
        System.debug(accountList);
        for(Id accId : accMap.keyset()){
            if(cMap.get(accId) != null && cMap.get(accId).size()>0){
                for(Contact con : cMap.get(accId))
                {
                    conIds.add(con.Id);
                }
            }
        }
        System.debug(conIds);
        if(conIds.size()>0){
            List<User> userList = [select Id,contactId from user where contactId in: conIds];
            if(userList.size()>0){
                for(user u : userList){
                    userMap.put(u.contactId, u.Id);
                }
            }
            conMap = new Map<Id,Contact>([select id,RecordTypeId,vlocity_ins__Type__c,Name,recordtype.name,(select id,name,GA_Service_Start_Date__c,GA_Account_Id__c,GA_Contact_Id__c,GA_Contact_Id__r.AccountId,GA_Service_End_Date__c from AOR_Changes__r) from Contact where Id In: conIds]);
        }
        for(Account a : accountList){
            if(cMap.get(a.Id) != null && cMap.get(a.Id).size()>0){
                System.debug(cMap.get(a.Id));
                for(contact c : cMap.get(a.Id)){
                   // if(c.RecordTypeId == recTypeIdofcontact){
                      if(c.vlocity_ins__Type__c == 'Delegate Agent'){
                        Set<Id> accIds = new Set<Id>();
                        for(contact siblingContacts : cMap.get(a.Id)){
                            if(siblingContacts.Id != c.Id  && conMap.get(siblingContacts.Id).AOR_Changes__r.size()>0){
                                for(GA_AOR__c aor : conMap.get(siblingContacts.Id).AOR_Changes__r){
                                    if(aor.GA_Account_Id__c != null && userMap.get(c.Id) !=null)
                                    {
                                        if(aor.GA_Service_End_Date__c>= Date.today() && aor.GA_Service_Start_Date__c <= Date.today())
                                        {
                                            AccountShare accShare = new AccountShare();
                                            accshare.AccountId = aor.GA_Account_Id__c; 
                                            accshare.UserOrGroupId = userMap.get(c.Id);
                                            accshare.AccountAccessLevel  = 'Read'; 
                                            accshare.OpportunityAccessLevel  = 'None'; 
                                            accshare.CaseAccessLevel  = 'None'; 
                                            accshare.RowCause = Schema.CaseShare.RowCause.Manual;
                                            accShareList.add(accshare);
                                        }else{
                                            accIds.add(aor.GA_Account_Id__c);
                                        }
                                    }
                                }
                            }
                        }
                        if(accIds.size() > 0)
                            conAccMap.put(c.Id,accIds);
                    }
                }
                if(conAccMap != null){
                    Set<Id> userIds = new Set<Id>();
                    Set<Id> cIds = conAccMap.keyset();
                    Set<Id> accIds = new Set<Id>();
                    for(Id cId : cIds){
                        if(conAccMap.get(cId).size() > 0){
                            accIds.addAll(conAccMap.get(cId));
                        }
                        if(userMap.get(cId) != null)
                            userIds.add(userMap.get(cId));
                    }
                    if(userIds.size() > 0)
                    {
                        List<AccountShare> accShare = [select AccountId,Id,UserOrGroupId from AccountShare where UserOrGroupId In: userIds];
                        if(accShare.size()>0){
                            for(AccountShare accsh : accShare){
                                if(accIds.contains(accsh.AccountId) == true){
                                    deleteAccShareList.add(accsh);
                                }
                            }
                        }
                    }
                }
            }
        }
        try{
            System.debug(accShareList.size());
            System.debug(deleteAccShareList.size());
            if(deleteAccShareList.size()>0){
                Set<sobject> myset = new Set<sobject>();
                List<sobject> result = new List<sobject>();
                for (sobject s : deleteAccShareList) {
                    if (myset.add(s)) {
                        result.add(s);
                    }
                }
                delete result;
            }
            if(accShareList.size()>0){
                Map<String,AccountShare> asMap = new Map<String,AccountShare>();
                for(AccountShare ash : accShareList){
                    System.debug(ash.UserOrGroupId);
                    asMap.put(ash.AccountId+'-'+ash.UserOrGroupId,ash);
                }
                System.debug(asMap.keyset());
                Insert asMap.values();
            }
        }catch(Exception e){
            System.debug(e.getMessage()+e.getLineNumber());
        }
    }
    global void finish(Database.BatchableContext BC) {
        // execute any post-processing operations like sending email
    }
}