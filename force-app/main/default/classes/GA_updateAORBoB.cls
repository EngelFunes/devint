/*******************************************************************************************************************************
   @Name: GA_updateAORBoB
   @CreatedDate: 05-May-2020
   @Description: Account share to AOR.
   @version : 1.0
 ********************************************************************************************************************************/

public class GA_updateAORBoB {

public static void accountShareUpdateBoB(list<GA_AOR__c> aorLst, map<Id,GA_AOR__c> aorOldMap){
    List<Id> aorIdList= new List<Id>();
    for (GA_AOR__c aor: aorLst) {
        aorIdList.add(aor.id);
    }
    if(aorIdList!=null && aorIdList.size()>0) {
        accountSharing(aorIdList);
    }

}

@future
public static void accountSharing(List<Id> aorRecordIds){
    accountSharingBOB(aorRecordIds);
}
public static void accountSharingBOB(List<Id> aorRecordIds){
List<Id> contactsList = new List<Id>();
    List<AccountShare> allShareList = new List<AccountShare>();
    Map<Id, List<Id> > mapAccountContacts = new Map<Id, List<Id> >();
    Map<Id, List<Id> > mapAccountUsers = new Map<Id, List<Id> >();
    try{
        List<GA_AOR__C> accAORList=[select id,GA_Contact_Id__c,GA_Account_Id__c
                                    FROM GA_AOR__C WHERE GA_Service_Start_Date__c<=Today and GA_Service_End_Date__c>= today and ID IN:aorRecordIds  ];

        for(GA_AOR__c ga : accAORList) {

            if(ga.GA_Contact_Id__c!= Null || ga.GA_Contact_Id__c!='') {
                contactsList.add(ga.GA_Contact_Id__c);
                If(mapAccountContacts.containsKey(ga.GA_Account_Id__c)){
                    List<Id> tempContactListIds = mapAccountContacts.get(ga.GA_Account_Id__c);
                    tempContactListIds.add(ga.GA_Contact_Id__c);
                    mapAccountContacts.put(ga.GA_Account_Id__c,tempContactListIds);
                }
                else{
                    List<Id> tempContactListIds = new List<Id>();
                    tempContactListIds.add(ga.GA_Contact_Id__c);
                    mapAccountContacts.put(ga.GA_Account_Id__c, tempContactListIds);
                }

            }

        }


        List<User> userList = [SELECT ID, ContactId
                               FROM User WHERE ContactId =: contactsList];

        for(GA_AOR__c ga : accAORList) {
            for(User tempUser : userList) {
                for(Id contactId : contactsList) {
                    If(contactId == tempUser.ContactId){
                        If(mapAccountUsers.containsKey(ga.GA_Account_Id__c)){
                            List<Id> tempUserListIds = mapAccountUsers.get(ga.GA_Account_Id__c);
                            tempUserListIds.add(tempUser.Id);
                            mapAccountUsers.put(ga.GA_Account_Id__c,tempUserListIds);
                        }
                        else{
                            List<Id> tempUserListIds = new List<Id>();
                            tempUserListIds.add(tempUser.Id);
                            mapAccountUsers.put(ga.GA_Account_Id__c, tempUserListIds);
                        }
                    }
                }
            }
        }
        for(Id accountId : mapAccountUsers.keyset()) {

            for(Id tempUser: mapAccountUsers.get(accountId)) {
                System.debug(tempUser);
                AccountShare accShare = new AccountShare();
                accshare.AccountId = accountId;
                accshare.UserOrGroupId = tempUser;
                accshare.AccountAccessLevel  = 'Read';
                accshare.OpportunityAccessLevel  = 'None';
                accshare.CaseAccessLevel  = 'None';
                allShareList.add(accShare);
            }
        }
        if(allShareList.size() <> 0) {
            try{
                insert allShareList;
            }catch(DmlException e) {
                System.debug('The following exception has occurred: ' + e.getMessage());
            }
        }
    }catch(DmlException e) {
        System.debug('The following exception has occurred: ' + e.getMessage());
    }
}
public static void sharingSupportRequestRecordsBOB(list<GA_AOR__c> aorLst, map<Id,GA_AOR__c> aorOldMap,boolean isInsert){
    try{
        List<Id> aorIdSet= new List<Id>();
        for (GA_AOR__c aor: aorLst) {
            if(!isInsert && aorOldMap !=null && aorOldMap.get(aor.id) !=null ) {
                GA_AOR__c oldaorrec =aorOldMap.get(aor.id);
                //aor.GA_Service_Start_Date__c == system.today() &&
                if(aor.GA_Service_Start_Date__c !=null  && aor.GA_Service_End_Date__c !=null &&
                   ((( oldaorrec.GA_Service_Start_Date__c != null && oldaorrec.GA_Service_Start_Date__c  != aor.GA_Service_Start_Date__c ) || oldaorrec.GA_Service_Start_Date__c==null)||
                    (( oldaorrec.GA_Service_End_Date__c != null && oldaorrec.GA_Service_End_Date__c  != aor.GA_Service_End_Date__c ) || oldaorrec.GA_Service_End_Date__c==null)) )
                {
                    aorIdSet.add(aor.id);
                }
            }else{
                if(aor.GA_Service_Start_Date__c !=null && aor.GA_Service_Start_Date__c < system.today() ) {
                    aorIdSet.add(aor.id);
                }
            }
        }
        if(aorIdSet!=null && aorIdSet.size()>0) {
            System.debug(logginglevel.info,'*******aorIdSet******'+aorIdSet);
            sharingSupportRequestRecords(aorIdSet);
        }
    }catch(Exception e) {
        system.debug(logginglevel.error,+e.getMessage());
        GA_LogExceptionCls.LogExcp(e, 'GA_updateAORBoB', 'sharingSupportRequestRecordsBOB');
    }
}

@future(callout=true)
public static void sharingSupportRequestRecords(List<id> aorRecordIds){
    try{
        List<CaseShare>  caseshare=  sharingSupportRequestRecordsAOR(aorRecordIds);
        System.debug(LoggingLevel.INFO,'All shares' +  caseshare);
        if (caseshare!=null && caseshare.size() > 0 ) {
            List<Database.SaveResult> sr = Database.insert(caseshare,false);
        }
    }catch(Exception e) {
        system.debug(logginglevel.error,+e.getMessage());
        GA_LogExceptionCls.LogExcp(e, 'GA_updateAORBoB', 'sharingSupportRequestRecords');
    }
}
public static void sharingSupportRequestRecordsBatch(List<id> aorRecordIds){
    try{
        List<CaseShare>  caseshare=  sharingSupportRequestRecordsAOR(aorRecordIds);
        System.debug(LoggingLevel.INFO,'All shares' +  caseshare);
        if (caseshare!=null && caseshare.size() > 0 ) {
            List<Database.SaveResult> sr = Database.insert(caseshare,false);
        }
    }catch(Exception e) {
        system.debug(logginglevel.error,+e.getMessage());
        GA_LogExceptionCls.LogExcp(e, 'GA_updateAORBoB', 'sharingSupportRequestRecords');
    }
}

public static List<CaseShare>  sharingSupportRequestRecordsAOR(List<id> aorRecordIds){
    List<Id> contactsList = new List<Id>();
    set<Id> accountList = new set<Id>();
    Map<Id, List<Id> > mapAccountContacts = new Map<Id, List<Id> >();
    Map<Id, Set<Id> > mapAccountUsers = new Map<Id, Set<Id> >();
    Set<id> agencyAccount=new Set<id>();
    List<CaseShare> allShares = new List<CaseShare>();
    Map<Id, Set<Id> > mapAccountAgency = new Map<Id, Set<Id> >();
    try{
        List<GA_AOR__C> accAORList=[select id,GA_Contact_Id__c,GA_Account_Id__c,GA_Contact_Id__r.accountid from GA_AOR__C where GA_Service_Start_Date__c<=Today and GA_Service_End_Date__c>= today and ID IN:aorRecordIds  ];
        for(GA_AOR__c aorRec : accAORList) {
            accountList.add(aorRec.GA_Account_Id__c);
            if(aorRec.GA_Contact_Id__c!= Null || aorRec.GA_Contact_Id__c!='') {
                agencyAccount.add(aorRec.GA_Contact_Id__r.accountid);
                contactsList.add(aorRec.GA_Contact_Id__c);
                If(mapAccountContacts.containsKey(aorRec.GA_Account_Id__c)){
                    List<Id> tempContactListIds = mapAccountContacts.get(aorRec.GA_Account_Id__c);
                    tempContactListIds.add(aorRec.GA_Contact_Id__c);
                    mapAccountContacts.put(aorRec.GA_Account_Id__c,tempContactListIds);
                }
                else{
                    List<Id> tempContactListIds = new List<Id>();
                    tempContactListIds.add(aorRec.GA_Contact_Id__c);
                    mapAccountContacts.put(aorRec.GA_Account_Id__c, tempContactListIds);
                }
                If(mapAccountAgency.containsKey(aorRec.GA_Account_Id__c)){
                    Set<Id> agencyListIds = mapAccountAgency.get(aorRec.GA_Account_Id__c);
                    agencyListIds.add(aorRec.GA_Contact_Id__r.AccountId);
                    mapAccountAgency.put(aorRec.GA_Account_Id__c,agencyListIds);
                }
                else{
                    Set<Id> agencyListIds = new Set<Id>();
                    agencyListIds.add(aorRec.GA_Contact_Id__r.AccountId);
                    mapAccountAgency.put(aorRec.GA_Account_Id__c, agencyListIds);
                }

            }
        }
        System.debug(LoggingLevel.INFO,'****mapAccountContacts****'+mapAccountContacts);
        mapAccountUsers   =  getMapAccountUsersforBOB( mapAccountContacts, agencyAccount, contactsList, mapAccountAgency);

       
        List<AccountShare> allAccShares = new List<AccountShare>();
        for(Id key : accountList){
              for(Id userid: mapAccountUsers.get(key)){           
                         AccountShare accShareRec = new AccountShare(); 
                         accShareRec.Accountid  = key;
                         accShareRec.UserOrGroupId = userid;
                         accShareRec.AccountAccessLevel = 'Read';
                         accShareRec.RowCause = Schema.CaseShare.RowCause.Manual;
                         accShareRec.OpportunityAccessLevel='None';
                         accShareRec.CaseAccessLevel='None';
                         allAccShares.add(accShareRec);
              }
        }
        
        system.debug(logginglevel.info,'*****allAccShares*****'+allAccShares.size());
        if (allAccShares.size() > 0 ) {        
          List<Database.SaveResult> sr = Database.insert(allAccShares,false);
        } 
        /////////////////////////////
        Datetime dtTime=System.now();
        date dt= date.newinstance(dtTime.year(), dtTime.month(), dtTime.day());
        Integer months=Integer.valueof(System.label.Case_Historical_Data_Sharing_Target_Months);
        date dateBefore=dt.addMonths(-months);
        List<String> recordtypelist = System.Label.Agent_Allowed_Case_Record_Types.split(',');
        List<Case>  caseList= [Select id,AccountId,GA_WorkOrderCategory__c,GA_SupportRequest_Type__c from Case where createdDate>=:dateBefore and AccountId IN :accountList and Recordtype.name in :recordtypelist];
        if(mapAccountUsers != null && mapAccountUsers.size()>0 && caseList != null && caseList.size()>0 ) {
            for(Case caserec:caseList) {
             if( (caserec.GA_WorkOrderCategory__c==null || (caserec.GA_WorkOrderCategory__c!= null && (!caserec.GA_WorkOrderCategory__c.contains(System.Label.Excluding_Quote_Case_Category_For_Agent)))) &&
                    (caserec.GA_SupportRequest_Type__c==null || (caserec.GA_SupportRequest_Type__c!=null && 
                    ( !caserec.GA_SupportRequest_Type__c.contains(System.Label.Excluding_Quote_Case_Category_For_Agent) && !caserec.GA_SupportRequest_Type__c.contains(System.Label.Excluding_Followup_Case_RequestTye_For_Agent)))) &&
                         caserec.accountId != null && mapAccountUsers.get(caserec.accountId)!=null){
                for(Id userid: mapAccountUsers.get(caserec.accountId)) {
                    CaseShare caseShareRec = new CaseShare();
                    caseShareRec.Caseid  = caserec.Id;
                    caseShareRec.UserOrGroupId = userid;
                    caseShareRec.CaseAccessLevel = 'Read';
                    caseShareRec.RowCause = Schema.CaseShare.RowCause.Manual;
                    allShares.add(caseShareRec);
                }
            }

            }
        }
        System.debug(LoggingLevel.INFO,'All shares' +  allShares);
    }catch(Exception e) {
        system.debug(logginglevel.error,+e.getMessage());
        GA_LogExceptionCls.LogExcp(e, 'GA_updateAORBoB', 'sharingSupportRequestRecordsAOR');
    }
    return allShares;
}

public static void accountShareUpdateBoBDelete(list<GA_AOR__c> OldaorLst, Map<Id, GA_AOR__c> OldmapAOR){

    List<Id> listConId = new List<Id>();
    List<Id> listAccId = new List<Id>();
    List<GA_AOR__c> invalidAorList = new List<GA_AOR__c>();
    for(GA_AOR__c aor : OldaorLst) {
        if (OldmapAOR != null ) {
            GA_AOR__c olAOR = OldmapAOR.get(aor.Id);
            if( (aor.GA_Service_End_Date__c != olAOR.GA_Service_End_Date__c && aor.GA_Service_End_Date__c < system.today()) ||
                (aor.GA_Service_Start_Date__c != olAOR.GA_Service_Start_Date__c && aor.GA_Service_Start_Date__c >system.today())) {
                listConId.add(olAOR.GA_Contact_Id__c);
                listAccId.add(olAOR.GA_Account_Id__c);
                invalidAorList.add(aor);
            }
        }
        else {
            if( aor.GA_Service_Start_Date__c < system.today() &&  aor.GA_Service_End_Date__c < system.today()) {
                listConId.add(aor.GA_Contact_Id__c);
                listAccId.add(aor.GA_Account_Id__c);
                invalidAorList.add(aor);
            }
            else if ( aor.GA_Service_Start_Date__c > system.today() &&  aor.GA_Service_End_Date__c > system.today()){
                listConId.add(aor.GA_Contact_Id__c);
                listAccId.add(aor.GA_Account_Id__c);
                invalidAorList.add(aor);
            }
        }
    }
    List<User> userList = [SELECT ID, ContactId
                           FROM User WHERE ContactId =: listConId];
    Set<Id> userIds = new Set<Id>();
    Map<id, id> contactVsUser = new map<id, id>();
    for(User user: userList) {
        contactVsUser.put(user.contactid, user.Id);
    }

    String queryString = 'SELECT Id FROM AccountShare where  Rowcause=\'Manual\' and (';
    System.debug('leanght ' + queryString.length()); 
    for (GA_AOR__c aorRec : invalidAorList) {
        if (contactVsUser.get(aorRec.GA_Contact_Id__c) != null ) {
            id accountidvar = aorRec.GA_Account_Id__c;
            id useridVar = contactVsUser.get(aorRec.GA_Contact_Id__c);
            String subqry =  '(AccountId =\''+ String.valueOf(accountidvar) +'\'and UserOrGroup.Id = \'' + String.valueOf(useridVar)  + '\') or';
            queryString =  queryString + subqry;
        }
    }
    queryString =  queryString.removeEnd('or');
    queryString =  queryString + ')';
    System.debug('Final Query ' + queryString);
    List<AccountShare> AccountSharetodelete = new List<AccountShare>();
    if(queryString.length() > 60) {
         AccountSharetodelete =Database.query(queryString);
    }
    If(AccountSharetodelete.size() > 0){
        delete AccountSharetodelete;
    }
}


public static List<CaseShare>  supportRequestShareBatchUpdateBoB(list<GA_AOR__c> aorList){
    List<CaseShare> caseShare =null;
    try{
        List<id> aorRecordIds=new List<id>();
        List<GA_AOR__c> validlistAOR=new  List<GA_AOR__c>();
        for(GA_AOR__c aor : aorList) {
            if( aor.GA_Service_Start_Date__c == system.today() )
            {
                aorRecordIds.add(aor.Id);
                validlistAOR.add(aor);
            }
        }
       
        caseShare = sharingSupportRequestRecordsAOR(aorRecordIds);
        
        List<GA_AOR__c> updatelistAOR=new  List<GA_AOR__c>();
        for(GA_AOR__c aor : validlistAOR) {
            aor.isStatusDatesModified__c = false;
            updatelistAOR.add(aor);
        }
       update updatelistAOR;
    }catch(Exception e) {
        system.debug(logginglevel.error,+e.getMessage());
        GA_LogExceptionCls.LogExcp(e, 'GA_updateAORBoB', 'supportRequestShareBatchUpdateBoB');

    }
    return caseShare;
}

public static Map<Id, Set<Id> >  getMapAccountUsersforBOB(Map<Id, List<Id> > mapAccountContacts, Set<id> agencyAccount,List<Id> contactsList,Map<Id, set<Id> > mapAccountAgency){
    Map<Id, Set<Id> > mapAccountUsers = new Map<Id, Set<Id> >();
    System.debug(LoggingLevel.INFO,'****mapAccountContacts****'+mapAccountContacts);
    List<String> delegatetype=System.label.Contact_Delegated_Agent.split('\\|');
   List<Account> agencyaccountList=[select id ,name,recordtype.name,(select id,Delegate_Contact__c from contacts where vlocity_ins__Type__c IN :delegatetype ) from Account where Id IN :agencyAccount  ];
       
    Map<Id, List<Id> > mapagencyAccountContacts = new Map<Id, List<Id> >();
    for(Account accRec:agencyaccountList) {
        List<Contact> contactList= accRec.contacts;
        for(Contact contactRec: contactList) {
            contactsList.add(contactRec.id);
            List<Id> tempContactListIds =null;
            If(mapagencyAccountContacts.containsKey(accRec.id)){
                tempContactListIds = mapagencyAccountContacts.get(accRec.id);
                tempContactListIds.add(contactRec.id);
            } else {
                tempContactListIds = new List<Id>();
                tempContactListIds.add(contactRec.id);
            }
            if(tempContactListIds!=null) {
                mapagencyAccountContacts.put(accRec.id, tempContactListIds);
            }
        }
    }
    Set<id> sharedUsers=new Set<id>();
    System.debug(LoggingLevel.INFO,'****mapagencyAccountContacts****'+mapagencyAccountContacts);
    List<user> agentUser =null;
    Map<Id, List<Id> > caseAllAccessUsers = new Map<Id, List<Id> >();
    Map<Id, Id> contactuserid = new Map<Id, Id>();
    if(contactsList!=null) {
        agentUser = [select id, contactid, name from user where isactive=true and contactid in: contactsList];
        if(agentUser!=null && agentUser.size()>0) {
            for(User userRec:agentUser) {
                sharedUsers.add(userRec.id);
                contactuserid.put(userRec.contactid,userRec.id);
            }
        }
    }
   
    for (Id key : mapAccountContacts.keySet()) {
        if(mapAccountContacts.get(key) != null) {
            for(Id contactid: mapAccountContacts.get(key)) {
                set<Id> tempuserListIds =null;
                If(mapAccountUsers.containsKey(key)){
                    tempuserListIds = mapAccountUsers.get(key);
                } else {
                    tempuserListIds = new set<Id>();
                }

                if(contactuserid.get(contactid)!=null) {
                    tempuserListIds.add(contactuserid.get(contactid));
                }
               
                if(mapAccountAgency!=null && mapAccountAgency.get(key)!=null) {
                   
                    for(Id ageencyId:mapAccountAgency.get(key)) {
                       
                        if(mapagencyAccountContacts.get(ageencyId)!= null) {
                            system.debug('******mapagencyAccountContacts.get(ageencyId)*******'+mapagencyAccountContacts.get(ageencyId));
                            for(Id agentcontactid: mapagencyAccountContacts.get(ageencyId)) {
                                if(contactuserid.get(agentcontactid)!=null) {
                                   tempuserListIds.add(contactuserid.get(agentcontactid));
                                }
                            }
                        }
                    }
                }
                if(tempuserListIds!=null) {
                    mapAccountUsers.put(key, tempuserListIds);
                }
            }
        }
    }
    return mapAccountUsers;
}
}