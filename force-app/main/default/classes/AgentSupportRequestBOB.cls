public without sharing class AgentSupportRequestBOB {

public static void sharingAgentSupportRequestRecord(list<case> CaseList, map<id, case> caseOldMap){
    List<Id> caseIdSet= new List<Id>();
    try{
        List<CaseShare> allShares = new List<CaseShare>();
        for (Case caseRec: CaseList) {
            system.debug('******* caseRec1 ***********'+caseRec );
            Map<ID, Schema.RecordTypeInfo> rtMap = Schema.SObjectType.Case.getRecordTypeInfosById();
             system.debug('******* caseRec2 ***********'+rtMap.get(caseRec.Recordtypeid).getName());
            if ((caseRec.Status=='New' || caseRec.Status=='Submitted') && 
            System.Label.Agent_Allowed_Case_Record_Types.contains(rtMap.get(caseRec.Recordtypeid).getName()) ) {
                caseIdSet.add(caseRec.id);
                if(caseRec.Status=='Submitted') {
                    CaseShare caseShareRec = new CaseShare();
                    caseShareRec.Caseid  = caseRec.Id;
                    caseShareRec.UserOrGroupId = UserInfo.getUserId();
                    caseShareRec.CaseAccessLevel = 'Edit';
                    caseShareRec.RowCause = Schema.CaseShare.RowCause.Manual;
                    allShares.add(caseShareRec);
                }
            }
        }
        if (allShares.size() > 0 ) {
            List<Database.SaveResult> sr = Database.insert(allShares,false);
        }
        if(caseIdSet!=null && caseIdSet.size()>0) {
            sharingSupportRequestRecords(caseIdSet);
        }
    }
    catch(Exception e) {
        system.debug(logginglevel.error,+e.getMessage());
        GA_LogExceptionCls.LogExcp(e, 'AgentSupportRequestBOB', 'sharingAgentSupportRequestRecord');
    }
}
 

@future(callout=true)
public static void sharingSupportRequestRecords(List<id> caserecordIds){
    Set<id> accountIds=new Set<id>();
    List<id> contactIds=new List<id>();
    Set<id> sharedUsers=new Set<id>();
    List<id> caserec=new List<id>();
    Map<Id, List<Id> > mapAccountContacts = new Map<Id, List<Id> >();
    Map<Id, Set<Id> > mapAccountUsers = new Map<Id, Set<Id> >();
    Set<id> agencyAccount=new Set<id>();
    Map<Id, Set<Id> > mapAccountAgency = new Map<Id, Set<Id> >();
    try{
        id recTypeIdofSupportReq = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get(System.label.Account_Record_Type_Customer).getRecordTypeId();
        List<Case> caselist= [SELECT id,AccountId,contactID,GA_AgentName__c,GA_WorkOrderCategory__c,GA_SupportRequest_Type__c,createdbyid,FSA_Delegated_Agent__c,GA_AgentName__r.accountid, GA_AgentName__r.Recordtypeid,createdby.id,createdby.profile.name,createdby.contact.vlocity_ins__Type__c FROM Case WHERE Id IN :caserecordIds and Account.Recordtypeid=: recTypeIdofSupportReq];
        system.debug(logginglevel.info,'Case List'+caselist);
        system.debug(logginglevel.info,'recTypeIdofSupportReq+++'+recTypeIdofSupportReq);
        system.debug(logginglevel.info,'caserecordIds+++'+caserecordIds);
        
        //if(caselist != null || caselist.size()>0){
       
        if(caselist != null) {
            for(Case rec:caselist) {
                contactIds.add(rec.GA_AgentName__c);
                accountIds.add(rec.AccountId);
                caserec.add(rec.id);
                agencyAccount.add(rec.GA_AgentName__r.accountid);
            }
            list<CaseShare> caseshareupdatelst=new list<CaseShare>();
            list<CaseShare> casesharelst=[SELECT Id, CaseId, UserOrGroup.Name,CaseAccessLevel  FROM CaseShare where  Rowcause='Manual' and CaseId in :caserec]; 
            if(casesharelst != null && casesharelst.size()>0){
                for(CaseShare casesharerec: casesharelst){
                    casesharerec.CaseAccessLevel  ='Read';
                    caseshareupdatelst.add(casesharerec);                
                }                
            }
            System.debug('********caseshareupdatelst**********'+caseshareupdatelst);
            if(caseshareupdatelst.size()>0){
                update caseshareupdatelst;
            }
            System.debug('&&&&&&&&&&caseshareupdatelst&&&&&&&&&&&&&&'+caseshareupdatelst);
            if(accountIds!=null) {
                List<Account> accountList= [select id,name,(select id,name,GA_Account_Id__c,GA_Contact_Id__c,GA_Contact_Id__r.AccountId from AOR__r where GA_Service_Start_Date__c<=Today and GA_Service_End_Date__c>= today ) from Account where ID IN :accountIds];
                for(Account accRec:accountList) {
                    List<GA_AOR__C> aorList= accRec.AOR__R;
                    for(GA_AOR__C aorRec: aorList) {
                        if(aorRec.GA_Contact_Id__c!=null) {
                            agencyAccount.add(aorRec.GA_Contact_Id__r.AccountId);
                            contactIds.add(aorRec.GA_Contact_Id__c);
                            // contactsList.add(aorRec.GA_Contact_Id__c);
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
                }
            }
            System.debug('****mapAccountContacts****'+mapAccountContacts);
            mapAccountUsers   = GA_updateAORBoB.getMapAccountUsersforBOB( mapAccountContacts, agencyAccount, contactIds, mapAccountAgency);
            set<id> userRecsetIds = new set<id> (); 
            for (set<id>  useridsSetRec : mapAccountUsers.values()) {
                userRecsetIds.addAll(useridsSetRec); 
            }
            map<id, id> userVsAgencyMap = new Map<id, id>();
             map<id, id> usercontactMap = new Map<id, id>(); 
            map<id, String> userVsContctRecordTypeIdMap = new Map<id, String>(); 
            List<User> userVsAgencyList = [select id, name, contactid, contact.Accountid, contact.vlocity_ins__Type__c from user where id in: userRecsetIds]; 
            for (User userRec : userVsAgencyList) {
                userVsAgencyMap.put(userRec.id, userRec.contact.Accountid); 
                usercontactMap.put(userRec.id,userRec.contactid);
                userVsContctRecordTypeIdMap.put(userRec.id, userRec.contact.vlocity_ins__Type__c); 
            }
          List<CaseShare> allShares = new List<CaseShare>();
            system.debug(logginglevel.info,'*****Case List******'+caselist);
            System.debug(logginglevel.info,'*****Account User List****'+mapAccountUsers);
            //  System.debug(logginglevel.info,'*****Map User List****'+mapcaseUsers);
            if( mapAccountUsers.size()>0 && caselist != null && caselist.size()>0 ) {
                for(Case caserecord:caselist) {
                    if(mapAccountUsers.get(caserecord.Accountid) != null &&
                        (caserecord.GA_WorkOrderCategory__c==null || (caserecord.GA_WorkOrderCategory__c!= null && (!caserecord.GA_WorkOrderCategory__c.contains(System.Label.Excluding_Quote_Case_Category_For_Agent)))) &&
                    (caserecord.GA_SupportRequest_Type__c==null || (caserecord.GA_SupportRequest_Type__c!=null && 
                    ( !caserecord.GA_SupportRequest_Type__c.contains(System.Label.Excluding_Quote_Case_Category_For_Agent) && !caserecord.GA_SupportRequest_Type__c.contains(System.Label.Excluding_Followup_Case_RequestTye_For_Agent))))
                 ) {
                        for(Id userRec: mapAccountUsers.get(caserecord.Accountid)) {
                            //userid.add(userRec);
                            String accessLevel = 'Read'; 
                            id currentAccountid = userVsAgencyMap.get(userRec);
                            system.debug('###########'+caserecord.createdby.profile.name);
                            system.debug('###########'+System.label.User_Profile_Name_MAUser);
                            List<String>  delegatecontacttype= System.label.Contact_Delegated_Agent.split('\\|');
                            if (( caserecord.GA_AgentName__r.accountid == currentAccountid && 
                                caserecord.createdby.profile.name!=System.label.User_Profile_Name_MAUser) &&
                                 ( caserecord.GA_AgentName__r.accountid == currentAccountid &&                                                             
                                  caserecord.createdby.profile.name != System.label.User_Profile_Name_MAcommunityLogin ) ) {
                                  
                                if (delegatecontacttype.contains(userVsContctRecordTypeIdMap.get(userRec))  ) {
                                    accessLevel = 'Edit'; 
                                }
                            }
                            if(String.isnotblank(caserecord.createdby.contact.vlocity_ins__Type__c) && 
                            delegatecontacttype.contains(caserecord.createdby.contact.vlocity_ins__Type__c) && 
                                ( caserecord.createdby.profile.name!=System.label.User_Profile_Name_MAUser ||                                                             
                                  caserecord.createdby.profile.name != System.label.User_Profile_Name_MAcommunityLogin )){
                                  
                                if(usercontactMap.get(userRec) != null && usercontactMap.get(userRec)== caserecord.GA_AgentName__c){
                                
                                     accessLevel = 'Edit';
                                }
                            }
                            CaseShare caseShareRec = new CaseShare();
                            caseShareRec.Caseid  = caserecord.Id;
                            caseShareRec.UserOrGroupId = userRec;
                            caseShareRec.CaseAccessLevel = accessLevel;
                            caseShareRec.RowCause = Schema.CaseShare.RowCause.Manual;
                            allShares.add(caseShareRec);
                        }
                    }
                }
            }
            System.debug(logginglevel.info,'All shares' +  allShares);

            if (allShares.size() > 0 ) {
                List<Database.SaveResult> sr = Database.insert(allShares,false);
            }

        }
    } catch(Exception e) {
        system.debug(logginglevel.error,+e.getMessage());
        GA_LogExceptionCls.LogExcp(e, 'AgentSupportRequestBOB', 'sharingSupportRequestRecords');
    }
}


}