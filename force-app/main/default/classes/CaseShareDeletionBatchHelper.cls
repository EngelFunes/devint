global with sharing class CaseShareDeletionBatchHelper {

public static void  supportRequestShareBatchDeleteBoB2(list<GA_AOR__c> aorList){

    wrapRetunLists retunWrap = new wrapRetunLists();
    List<caseShare> finalCasesahreList = new List<CaseShare>();
    set<id> aorAccountidset = new set<id>();
    for(GA_AOR__c aor : aorList) {
        aorAccountidset.add(aor.GA_Account_Id__c);
        // aor.isStatusDatesModified__c = false ;
    }
    List<Account> aorAccountDetailList = [Select id, name, (select id, GA_Service_Start_Date__c, GA_Account_Id__c,  GA_Service_End_Date__c, GA_Contact_Id__c from AOR__r) from account where id in: aorAccountidset];
    map<id,map<id,id> > validAccount = new map<id,map<id,id > >();
    map<id, set<id> > invalidAccountContacts = new map<id, set<id> >();
    map<id, List<id> > validAccountContacts = new map<id, List<id> >();
    map<id, LIst<id> > ownerChangeAccountContact = new map<id, List<id> >();
    Set<Id> allContactIds = new Set<Id>();
    System.debug('Account details list full ' + aorAccountDetailList);
    List<GA_AOR__c> invalidAorList = new List<GA_AOR__c>();
    List<Id> listConId = new List<Id>();

    for (Account aorAccount : aorAccountDetailList) {
        map<id, id > validAORContact = new map<id, id >();
        map<id, id > invalidAORContact = new map<id, id >();
        set<id> finalinvalidContact = new Set<Id>();

        for (GA_AOR__c aor : aorAccount.AOR__r) {
            if( aor.GA_Service_Start_Date__c < system.today() &&  aor.GA_Service_End_Date__c < system.today()) {
                invalidAORContact.put(aor.GA_Contact_Id__c, aor.GA_Contact_Id__c);
                invalidAorList.add(aor);
                listConId.add(aor.GA_Contact_Id__c);
                finalinvalidContact.add(aor.GA_Contact_Id__c);
            }
            else if( aor.GA_Service_Start_Date__c > system.today() &&  aor.GA_Service_End_Date__c > system.today()) {
                invalidAORContact.put(aor.GA_Contact_Id__c, aor.GA_Contact_Id__c);
                invalidAorList.add(aor);
                listConId.add(aor.GA_Contact_Id__c);
                finalinvalidContact.add(aor.GA_Contact_Id__c);
            }
            else {
                validAORContact.put(aor.GA_Contact_Id__c, aor.GA_Contact_Id__c);
            }
            allContactIds.add(aor.GA_Contact_Id__c);
        }
        validAccountContacts.put(aorAccount.Id, validAORContact.values());

        if (validAccountContacts.get(aorAccount.Id).size() == 1 ) {
            system.debug('aorAccountid' +aorAccount.Id );
            system.debug('validaccountcontact retun list ' + validAccountContacts.get(aorAccount.Id) );
            id lstid = validAccountContacts.get(aorAccount.Id)[0];
            system.debug('lstid retun list ' + lstid );
            retunWrap.accountOwnerChangeList.put(aorAccount.Id, lstid);
        }
        invalidAccountContacts.put(aorAccount.Id, finalinvalidContact);
    }
    
    List<User> userList = [SELECT ID, ContactId
                           FROM User WHERE ContactId =: listConId];
    Set<Id> userIds = new Set<Id>();
    Map<id, id> contactVsUser = new map<id, id>();
    for(User user: userList) {
        contactVsUser.put(user.contactid, user.Id);
    }
    String queryString1 = 'SELECT Id FROM AccountShare where  Rowcause=\'Manual\' and (';
    System.debug('leanght ' + queryString1.length());
    for (GA_AOR__c aorRec : invalidAorList) {
        if (contactVsUser.get(aorRec.GA_Contact_Id__c) != null ) {
            id accountidvar = aorRec.GA_Account_Id__c;
            id useridVar = contactVsUser.get(aorRec.GA_Contact_Id__c);
            String subqry =  '(AccountId =\''+ String.valueOf(accountidvar) +'\'and UserOrGroup.Id = \'' + String.valueOf(useridVar)  + '\') or';
            queryString1 =  queryString1 + subqry;
        }
    }
    queryString1 =  queryString1.removeEnd('or');
    queryString1 =  queryString1 + ')';
    System.debug('Final Query ' + queryString1);


    List<User> allUsers = [select id, name, Contactid from user where Contactid in: allContactIds];
    for (user userRec : allUsers) {
        retunWrap.contacVsUser.put(userRec.contactId, userRec.Id);
        retunWrap.userVsContact.put(userRec.id, userRec.contactid);
    }

    String queryString = 'SELECT Id, CaseId, UserOrGroup.Name FROM CaseShare where  Rowcause=\'Manual\' and (';
    for (id accountkeyRec : invalidAccountContacts.keySet()) {
        set<id> contactRecs = invalidAccountContacts.get(accountkeyRec);
        for (Id contRec  : contactRecs) {
            id contctUserRec = retunWrap.contacVsUser.get(contRec);
            if (contctUserRec <> null ) {
                String subqry =  '(Case.Account.Id =\''+ String.valueOf(accountkeyRec) +'\'and UserOrGroup.Id = \'' + String.valueOf(contctUserRec)  + '\') or';
                queryString =  queryString + subqry;
            }
        }
    }
    queryString =  queryString.removeEnd('or');
    queryString =  queryString + ')';
if(invalidAorList.size()>0){
    retunWrap.listOfCases = [select id, OwnerId, GA_AgentName__c, AccountId from case where AccountId in: retunWrap.accountOwnerChangeList.keySet() and recordtype.Name = 'Agent Support Request' and status = 'New'];

    for (case CaseRec: retunWrap.listOfCases) {
        id contctIds = retunWrap.accountOwnerChangeList.get(CaseRec.AccountId);
            if (contctIds <> null) {
            id ownrid = retunWrap.contacVsUser.get(contctIds);
                    if(ownrid <> null ) {
                        CaseRec.OwnerId = ownrid;
                        CaseRec.GA_AgentName__c = contctIds;
            }
                
            
        }
        
        
    }
    if (retunWrap.listOfCases.size() > 0) {
        system.debug('update list ' + retunWrap.listOfCases);
        update retunWrap.listOfCases;
    }
    }

    System.debug('Query String final' + queryString);
    List<caseshare> caseShareList = new List<Caseshare>();
    if(queryString.length() > 83) {
        caseShareList =Database.query(queryString);
        System.debug('Caselist to delete'  + caseShareList);
        delete caseShareList;
    }

    List<AccountShare> AccountSharetodelete = new List<AccountShare>();
    if(queryString1.length() > 60) {
        AccountSharetodelete =Database.query(queryString1);
    }
    If(AccountSharetodelete.size() > 0){
        retunWrap.AccountSharetodelete = AccountSharetodelete;
        System.debug('Account List to Delete '  + AccountSharetodelete);
        delete AccountSharetodelete;
    }
    List<GA_AOR__c> updatelistAOR=new  List<GA_AOR__c>();
    for(GA_AOR__c aor : invalidAorList) {

        aor.isStatusDatesModified__c = false;
        updatelistAOR.add(aor);
    }
    update updatelistAOR;
    
}
global class wrapRetunLists {
public List<caseshare> caseShareReturn =  new List<caseshare>();
public map<id, id> accountOwnerChangeList = new map<id, id>();
public List<Case> listOfCases = new List<case>();
public map<id, id> contacVsUser = new map<id, id>();
public map<id, id> userVsContact = new map<id, id>();
public List<AccountShare> AccountSharetodelete = new    List<AccountShare>();
}
}