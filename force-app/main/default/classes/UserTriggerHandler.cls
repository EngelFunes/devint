public with sharing class UserTriggerHandler {
public static void afterInsert(list<User> userList, map<id, user> userNewMap)
{
    set<id> contactIdset = new set<id>(); 
     list<id> supportRequestIds=new list<id>();
     
     /**   Map<String ,String> profileMap=new Map<String ,String>();
        String[] profileslist=System.label.Agent_CaseBOB_UserProfiles.split(';');
        for(String str:profileslist){  
        String rectype=''; 
            String[]  Profilrstr=str.split(':'); 
                 rectype=Schema.SObjectType.User.getRecordTypeInfosByName().get(Profilrstr[1]).getRecordTypeId(); 
            profileMap.put(rectype,Profilrstr[0]);
        }**/
    for (User userRec : userList) {
    system.debug('************8userRec.profile.name'+userRec.profile.name);
        if (userRec.contactid != null && System.label.Agent_CaseBOB_UserProfiles.contains(userRec.profileid)){
        /**(userRec.profile.name == System.label.User_Profile_Name_BCBSM_Both 
                    || userRec.Profile.Name == System.label.User_Profile_Name_BCBSM_Both_Login 
                    || userRec.Profile.Name == System.label.User_Profile_Name_BCBSM_FSA_login 
                    || userRec.profile.name == System.label.User_Profile_Name_BCBSM_FSA 
                   ) ) {**/
            contactIdset.add(userRec.contactid); 
        }
    }
    system.debug('*****contactIdset*******'+contactIdset);
    List<Contact> delegateContacts = [select id, AccountId, vlocity_ins__Type__c from contact where id in: contactIdset ]; 
    
    List<Contact> conlist1=new List<Contact>();

        for (Contact con : delegateContacts){            
            con.Batch_Action_Flag__c='User Created';
            conlist1.add(con);
        }
        update conlist1;
    /**system.debug('******delegateContacts ******'+delegateContacts );
    set<id> idstopass = new set<id>(); 
    for ( contact  contactrec : delegateContacts) {
        idstopass.add(contactrec.Id); 
    }
     system.debug('*******idstopass*****'+idstopass);
    //dalegateAgentSharing(idstopass); **/
}
//@future
public static void dalegateAgentSharing(set<Id> ids){
    List<Contact> cntList = [select id, accountid from contact where id in:ids ]; 

    set<id> accountIds = new set<id>(); 
    set<id> contactids = new set<id>(); 
    map<id, id> contactVsAccount = new map<id, id>(); 
    for (Contact contactRec : cntList) {
        accountIds.add(contactRec.AccountId);
        contactids.add(contactRec.Id); 
    }
    // map<id, List<Contact>> acccountIdVsContactListMap = new map<id, List<contact>>(); 
    // // List<Account> accuntList = [select id, name, (select id, vlocity_ins__Type__c from contacts where vlocity_ins__Type__c != 'Delegate Agent') from account where id in: accountIds]; 
    // // set<id> contactids = new set<id>(); 
    // // for (Account accountRec : accuntList) {
    // //     acccountIdVsContactListMap.put(accountRec.Id, accountRec.Contacts); 
    // //     for (Contact contactRec : accountRec.Contacts) {
    // //         contactids.add(contactRec.Id); 
    // //     }
    // // }
    map<id, set<id>> contactVsAORAccountMap = new map<id, set<id>>(); 
    List<GA_AOR__c> aorlist = [Select id, GA_Account_Id__c, GA_Contact_Id__c, GA_Contact_Id__r.AccountId from GA_AOR__c where GA_Contact_Id__r.AccountId in: accountIds]; 
    for (GA_AOR__c aorRec : aorlist) {
        set<id> tmpAccountSet = new set<id>(); 
        if (contactVsAORAccountMap.get(aorRec.GA_Contact_Id__r.AccountId) != null) {
            tmpAccountSet.addAll(contactVsAORAccountMap.get(aorRec.GA_Contact_Id__r.AccountId)); 
        }
        tmpAccountSet.add(aorRec.GA_Account_Id__c); 
        contactVsAORAccountMap.put(aorRec.GA_Contact_Id__r.AccountId, tmpAccountSet); 
    }
    List<User> contactUsers = [select id, name, ContactId from user where ContactId in: contactids]; 
    map<id, id> contactIdVsUserId = new Map<id,id>(); 
    for (user  userRec : contactUsers) {
        contactIdVsUserId.put(userRec.ContactId, userRec.id); 
    }
    List<AccountShare> finalAccountSharetoinsert = new List<AccountShare>(); 
    for (Contact contactRec : cntList) {
        if (contactIdVsUserId.get(contactRec.Id) != null ) {
            id daUserId = contactIdVsUserId.get(contactRec.Id); 
            set<id> accooutssetTobeShared = contactVsAORAccountMap.get(contactRec.Accountid); 
            if (accooutssetTobeShared.size() > 0 ) {
                for (id idRec : accooutssetTobeShared) {
                    AccountShare accShare = new AccountShare();
                    accshare.AccountId = idRec; 
                    accshare.UserOrGroupId = daUserId;
                    accshare.AccountAccessLevel  = 'Read'; 
                    accshare.OpportunityAccessLevel  = 'None'; 
                    accshare.CaseAccessLevel  = 'Edit'; 
                    accshare.RowCause = Schema.CaseShare.RowCause.Manual;
                    finalAccountSharetoinsert.add(accshare); 
                }   
            }
        }
    }
    Database.insert(finalAccountSharetoinsert); 
}
}