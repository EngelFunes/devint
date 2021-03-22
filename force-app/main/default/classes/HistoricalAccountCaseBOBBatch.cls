global class HistoricalAccountCaseBOBBatch implements Database.Batchable<sObject>, Database.Stateful,Schedulable {

    private static String COMPLETED_BATCH = 'Completed';
    private static integer MAX_SIZE = 8000;
    global  List<CaseShare> caseShares = new List<CaseShare>();
    id recTypeIdofSupportReq = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get(System.label.Account_Record_Type_Customer).getRecordTypeId();
    global String query='select id ,name,recordtype.name,(select id,name,GA_Account_Id__c,GA_Contact_Id__c,GA_Contact_Id__r.AccountId from AOR__r where GA_Service_Start_Date__c<=Today and GA_Service_End_Date__c>= today ) from Account';
    global Database.QueryLocator start(Database.BatchableContext bc) {
      id recTypeIdofSupportReq = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get(System.label.Account_Record_Type_Customer).getRecordTypeId();
      query=query+ '  where  recordtype.id='+'\'' + String.valueOf(recTypeIdofSupportReq )  + '\'' ;
         return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC,List<Account> scope)    {
      List<CaseShare> allSharestemp =new List<CaseShare>();
      try{
       allSharestemp=shareHistoricalData(scope);       
           if(allSharestemp.size() > 0 && allSharestemp.size()<=MAX_SIZE){                 
                    List<Database.SaveResult> sr = Database.insert(allSharestemp,false);           
           }else{       
               caseShares.addall(allSharestemp);
           }
        }catch(Exception e){     
             system.debug(logginglevel.error,+ e.getMessage());
             GA_LogExceptionCls.LogExcp(e, 'HistoricalAccountCaseBOBBatch', 'execute');
         
         } 
    }
    global void finish(Database.BatchableContext BC)
    {
        system.debug('*****************finishcaseSharestobeDeleted '+caseShares.size() );
        if(caseShares!=null && caseShares.size()>0){
            CaseShareSeq02Batch  batch = new CaseShareSeq02Batch(caseShares);
            database.executebatch(batch,1500);
        }
     }
    
    
    global void execute(SchedulableContext sc) {
        HistoricalAccountCaseBOBBatch batch = new HistoricalAccountCaseBOBBatch();
        Database.executeBatch(batch, 3);
        
    }
    
    Public static List<CaseShare> shareHistoricalData(List<Account> allaccountList){
    List<CaseShare> allShares = new List<CaseShare>();
    system.debug('In Method');
        set<Id> contactsList = new set<Id>();
        set<Id> accountList = new set<Id>();
        Map<Id, List<Id>> mapAccountContacts = new Map<Id, List<Id>>();
        Map<Id, Id> mapaorAgency = new Map<Id, Id>();
        set<Id> agencyAccount = new set<Id>();
        List<GA_AOR__C> accAORList= new List<GA_AOR__C>();   
        try{
            //id recTypeIdofSupportReq = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get(System.label.Account_Record_Type_Customer).getRecordTypeId();
            //List<Account> allaccountList=[select id ,name,recordtype.name,(select id,name,GA_Account_Id__c,GA_Contact_Id__c,GA_Contact_Id__r.AccountId from AOR__r where GA_Service_Start_Date__c<=Today and GA_Service_End_Date__c>= today ) from Account where recordtypeid=:recTypeIdofSupportReq and id='0016w000001psig'];
            for(Account accRec:allaccountList){
             List<GA_AOR__C> aorList= accRec.AOR__R;
             accountList.add(accRec.id);
             for(GA_AOR__C aorRec: aorList){
               if(aorRec.GA_Contact_Id__c!=null){
                     contactsList.add(aorRec.GA_Contact_Id__c);
                     agencyAccount.add(aorRec.GA_Contact_Id__r.AccountId);
                     mapaorAgency.put(aorRec.GA_Contact_Id__c,aorRec.GA_Contact_Id__r.AccountId);
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
                    
                }
              }
            }
        id recTypeIdofcontact = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get(System.label.Contact_Delegate_Agent_Record_Type).getRecordTypeId();
           // List<Account> agencyaccountList=[select id ,name,recordtype.name,(select id,Delegate_Contact__c from contacts where vlocity_ins__Type__c=:System.Label.Contact_Type_Delegate  and Active__c=true) from Account where Id IN :agencyAccount  ];
            List<String> delegatetype=System.label.Contact_Delegated_Agent.split('\\|');
              List<Account> agencyaccountList=[select id ,name,recordtype.name,(select id,Delegate_Contact__c from contacts where vlocity_ins__Type__c IN :delegatetype ) from Account where Id IN :agencyAccount  ];
       
            Map<Id, List<Id>> mapagencyAccountContacts = new Map<Id, List<Id>>();   
        for(Account accRec:agencyaccountList){
           List<Contact> contactList= accRec.contacts;
           for(Contact contactRec: contactList){
                contactsList.add(contactRec.id);
                List<Id> tempContactListIds =null;
                If(mapagencyAccountContacts.containsKey(accRec.id)){
                        tempContactListIds = mapagencyAccountContacts.get(accRec.id);
                        tempContactListIds.add(contactRec.id);
                } else {
                        tempContactListIds = new List<Id>();
                        tempContactListIds.add(contactRec.id);                    
                }
                if(tempContactListIds!=null){
                    mapagencyAccountContacts.put(accRec.id, tempContactListIds);
                }
           }
        }
        system.debug(logginglevel.info,'*********'+contactsList.size()); 
        List<user> agentUser =null;
        Map<Id, list<Id>> caseAllAccessUsers = new Map<Id,list<Id>>();
        Map<Id, Id> contactuserid = new Map<Id, Id>();
        if(contactsList!=null){
           agentUser = [select id, contactid, name from user where isactive=true and contactid in: contactsList];
           if(agentUser!=null && agentUser.size()>0){
                for(User userRec:agentUser){
                   contactuserid.put(userRec.contactid,userRec.id);                    
                 }
            }
        }
        system.debug(logginglevel.info,'***********contactuserid**********'+contactuserid.size());
        for (Id key : mapAccountContacts.keySet()) {
            if(mapAccountContacts.get(key) != null){
                for(Id contactid: mapAccountContacts.get(key)){
                            List<Id> tempuserListIds =null;
                            If(caseAllAccessUsers.containsKey(key)){
                                tempuserListIds = caseAllAccessUsers.get(key);
                            } else {
                                tempuserListIds = new List<Id>();                                           
                            }
                  if(contactuserid.get(contactid)!=null){
                     tempuserListIds.add(contactuserid.get(contactid));
                  }
                  if(mapaorAgency.get(contactid)!=null&& mapagencyAccountContacts.get(mapaorAgency.get(contactid)) !=null){
                            for(Id agentcontactid: mapagencyAccountContacts.get(mapaorAgency.get(contactid))){
                                if(contactuserid.get(agentcontactid)!=null){
                                    tempuserListIds.add(contactuserid.get(agentcontactid));
                                }
                            }
                          }
                    if(tempuserListIds!=null){
                        caseAllAccessUsers.put(key, tempuserListIds);
                    }
                    system.debug(logginglevel.info,'***tempuserListIds*******'+tempuserListIds.size());
                }
            } 
         
        }        
        List<AccountShare> allAccShares = new List<AccountShare>();
        for(Id key : caseAllAccessUsers.keySet()){
              for(Id userid: caseAllAccessUsers.get(key)){           
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
       // system.debug(logginglevel.info,'*****allAccShares*****'+allAccShares); 
        
         Datetime dtTime=System.now();
         date dt= date.newinstance(dtTime.year(), dtTime.month(), dtTime.day());
         Integer months=Integer.valueof(System.label.Case_Historical_Data_Sharing_Target_Months);
         date dateBefore=dt.addMonths(-months);
         List<String> recordtypelist = System.Label.Agent_Allowed_Case_Record_Types.split(',');
         List<Case>  caseList= [Select id,AccountId,GA_WorkOrderCategory__c,GA_SupportRequest_Type__c from Case where createdDate>=:dateBefore and AccountId IN :accountList and Recordtype.name in :recordtypelist];
         //List<Case>  caseList= [Select id,AccountId from Case where createdDate>=:dateBefore and AccountId IN :accountList ];
         system.debug('****caseList*****'+caseList.size()); 
        if(caseAllAccessUsers != null && caseAllAccessUsers.size()>0 && caseList != null && caseList.size()>0 ){
                for(Case caserec:caseList){ 
                    if(  (caserec.GA_WorkOrderCategory__c==null || (caserec.GA_WorkOrderCategory__c!= null && (!caserec.GA_WorkOrderCategory__c.contains(System.Label.Excluding_Quote_Case_Category_For_Agent)))) &&
                    (caserec.GA_SupportRequest_Type__c==null || (caserec.GA_SupportRequest_Type__c!=null && 
                    ( !caserec.GA_SupportRequest_Type__c.contains(System.Label.Excluding_Quote_Case_Category_For_Agent) && !caserec.GA_SupportRequest_Type__c.contains(System.Label.Excluding_Followup_Case_RequestTye_For_Agent)) ))
                    &&  caserec.accountId != null && caseAllAccessUsers.get(caserec.accountId)!=null){ 
                     for(Id userid: caseAllAccessUsers.get(caserec.accountId)){           
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
        System.debug(LoggingLevel.INFO,'All shares' +  allShares.size());          
         /**   if (allShares.size() > 0 ) {        
                List<Database.SaveResult> sr = Database.insert(allShares,false);
            } **/
         }catch(Exception e){     
             system.debug(logginglevel.error,+ e.getMessage());
             GA_LogExceptionCls.LogExcp(e, 'HistoricalAccountCaseBOBBatch', 'shareHistoricalData');
         
         } 
         return allShares;        
    }
    
    }