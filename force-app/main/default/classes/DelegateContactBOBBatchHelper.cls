global with sharing class DelegateContactBOBBatchHelper{

  public static wrapRetunLists delegateContactAccountCaseBOB(List<Contact> agentcontactList){  
    wrapRetunLists retunrWrap = new wrapRetunLists();
     List<CaseShare> caseShares =null;
     List<User> inActiveUsers = null; 
      try{
            Set<id> agencyAccount=new Set<id>();
            Set<id> aorContactids=new Set<id>();
            Set<id> contactids=new Set<id>();
            Set<id> agencycontact=new Set<id>();
            Set<id> activeContact=new Set<id>();
            //Set<id> inactiveContact=new Set<id>();
            Map<Id, Id> mapContactAgency = new Map<Id, Id>();
            Map<Id, Set<Id>> mapAccountAgency = new Map<Id, Set<Id>>();
            for(Contact cotactrec:agentcontactList){
                agencyAccount.add(cotactrec.accountid);
                contactids.add(cotactrec.id);
               
                    activeContact.add(cotactrec.id);
                
                mapContactAgency.put(cotactrec.id,cotactrec.accountid);
            }
           // inActiveUsers = [select id, name from user where contactid in: inactiveContact]; 
            List<Account> agencyaccountList=[select id ,name,recordtype.name,(select id,Delegate_Contact__c from contacts ) from Account where Id IN :agencyAccount  ];
            Map<Id, List<Id>> mapagencyAccountContacts = new Map<Id, List<Id>>(); 
            if(agencyaccountList!=null){  
                for(Account accRec:agencyaccountList){
                  List<Contact> contactList= accRec.contacts;
                  if(contactList!=null){                   
                       for(Contact contactRec: contactList){                      
                            aorContactids.add(contactRec.id);  
                       }
                   }
                }
            }
            List<GA_AOR__C> accAORList=[select id ,GA_Contact_Id__c,GA_Account_Id__c,GA_Contact_Id__r.Accountid from GA_AOR__C where GA_Service_Start_Date__c<=Today and GA_Service_End_Date__c>= today and GA_Contact_Id__c IN:aorContactids ];
            Set<Id> accountList=new Set<Id>() ;
            if(accAORList!=null){            
                for(GA_AOR__C aorRec:accAORList){
                if(aorRec.GA_Account_Id__c!=null){
                    Set<Id> accountIds =null;
                    accountList.add(aorRec.GA_Account_Id__c);
                    If(mapAccountAgency.containsKey(aorRec.GA_Contact_Id__r.Accountid)){
                        accountIds = mapAccountAgency.get(aorRec.GA_Contact_Id__r.Accountid);
                        accountIds.add(aorRec.GA_Account_Id__c);
                        
                    }
                    else{
                        accountIds = new Set<Id>();
                        accountIds.add(aorRec.GA_Account_Id__c);
                     }
                    if(accountIds!=null){
                        mapAccountAgency.put(aorRec.GA_Contact_Id__r.Accountid,accountIds);
                    }
                }
                }
            }
            List<user> agentUser =null;
            Map<Id, List<Id>> caseAllAccessUsers = new Map<Id, List<Id>>();
            Map<Id, Id> contactuserid = new Map<Id, Id>();
            if(contactIds!=null){
                agentUser = [select id, contactid, name from user where isactive=true and contactid in: contactIds];
                if(agentUser!=null && agentUser.size()>0){
                 for(User userRec:agentUser){
                    contactuserid.put(userRec.contactid,userRec.id);                    
                }
              }
            }
            if(activeContact!=null){
             caseShares=   sharingAccountCaseBOB(activeContact,accountList,mapContactAgency,mapAccountAgency,contactuserid );
            }
            system.debug('%%%%%caseShares%%%%%%%%%'+caseShares);
            if(caseShares.size()>=1){
                insert caseShares;
            }
      
     }catch(Exception e){     
        system.debug(logginglevel.error,+ e.getMessage());
        GA_LogExceptionCls.LogExcp(e, 'DelegateContactBOBBatchHelper', 'delegateContactAccountCaseBOB');     
     } 
     retunrWrap.caseShareToInsert = caseShares;
    // retunrWrap.caseShareToDelete = [SELECT Id, CaseId, UserOrGroup.Name FROM CaseShare where Rowcause='Manual' and UserorGroupId in: inActiveUsers ]; 
     //retunrWrap.accountsharetoDelete = [Select Id, UserOrGroup.Name from AccountShare where   Rowcause='Manual' and UserorGroupId in: inActiveUsers ]; 
     return  retunrWrap; 
   }
   public static List<CaseShare> sharingAccountCaseBOB(Set<id> activeContact,Set<Id> accountList,Map<Id, Id> mapContactAgency,Map<Id, Set<Id>> mapAccountAgency,Map<Id, Id> contactuserid){    
      List<CaseShare> caseShares = new List<CaseShare>();
      try{
      
                 Datetime dtTime=System.now();
             Map<Id, List<Id>> mapAccountcase = new Map<Id, List<Id>>();
            date dt= date.newinstance(dtTime.year(), dtTime.month(), dtTime.day());
            Integer months=Integer.valueof(System.label.Case_Historical_Data_Sharing_Target_Months);
            date dateBefore=dt.addMonths(-months);
             List<String> recordtypelist = System.Label.Agent_Allowed_Case_Record_Types.split(',');
            List<Case>  caseList= [Select id,AccountId,GA_WorkOrderCategory__c,GA_SupportRequest_Type__c from Case where createdDate>=:dateBefore and AccountId IN :accountList and Recordtype.name in :recordtypelist];
            for(Case caserec:caseList){
                List<Id> caseids =null;
                if((caserec.GA_WorkOrderCategory__c==null || (caserec.GA_WorkOrderCategory__c!= null && (!caserec.GA_WorkOrderCategory__c.contains(System.Label.Excluding_Quote_Case_Category_For_Agent)))) &&
                    (caserec.GA_SupportRequest_Type__c==null || (caserec.GA_SupportRequest_Type__c!=null && 
                    ( !caserec.GA_SupportRequest_Type__c.contains(System.Label.Excluding_Quote_Case_Category_For_Agent) && !caserec.GA_SupportRequest_Type__c.contains(System.Label.Excluding_Followup_Case_RequestTye_For_Agent))))){
                    If(mapAccountcase.containsKey(caserec.Accountid)){
                        caseids = mapAccountcase.get(caserec.Accountid);
                        caseids.add(caserec.id);            
                    }
                    else{
                        caseids = new List<Id>();
                        caseids.add(caserec.id);
                    }
                    if(caseids!=null){
                        mapAccountcase.put(caserec.Accountid,caseids);
                    }
                }
            }
            List<AccountShare> accountShares = new List<AccountShare>();  
            if(contactuserid!=null){
             
                for(Id key : contactuserid.keySet()){
                 if(activeContact.contains(key) && mapContactAgency.get(key)!= null && mapAccountAgency.get(mapContactAgency.get(key)) !=null){
                        for(Id accountid : mapAccountAgency.get(mapContactAgency.get(key))){
                            AccountShare accountShareRec = new AccountShare(); 
                            accountShareRec.AccountID  = accountid;
                            accountShareRec.UserOrGroupId = contactuserid.get(key);
                            accountShareRec.AccountAccessLevel= 'Read';
                               accountShareRec.OpportunityAccessLevel='None';
                         accountShareRec.CaseAccessLevel='None';
                            accountShareRec.RowCause = Schema.AccountShare.RowCause.Manual;
                            accountShares.add(accountShareRec);
                            if(mapAccountcase.get(accountid)!=null){
                                for(Id caseId:mapAccountcase.get(accountid)){
                                    CaseShare caseShareRec = new CaseShare(); 
                                    caseShareRec.Caseid  = caseId;
                                    caseShareRec.UserOrGroupId = contactuserid.get(key);
                                    caseShareRec.CaseAccessLevel = 'Edit';
                                    caseShareRec.RowCause = Schema.CaseShare.RowCause.Manual;
                                    caseShares.add(caseShareRec);
                                }
                            }
                        }
                    }
                }
            }
            System.debug('******accountShares***********'+accountShares);
            if(accountShares.size()>=1){
                insert accountShares;
            }
           
      }catch(Exception e){     
        system.debug(logginglevel.error,+ e.getMessage());
        GA_LogExceptionCls.LogExcp(e, 'DelegateContactBOBBatchHelper', 'sharingAccountCaseBOB');     
     } 
     return caseShares;
   }
   global class wrapRetunLists {
    public List<caseshare> caseShareToInsert = new  List<caseshare>(); 
    public List<AccountShare> accountsharetoDelete  = new List<AccountShare>(); 
    public List<CaseShare> caseShareToDelete = new  List<caseshare>(); 
}

      
}