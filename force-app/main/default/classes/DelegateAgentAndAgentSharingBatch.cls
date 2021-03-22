global  class DelegateAgentAndAgentSharingBatch implements Database.Batchable<sObject>,Database.Stateful,Schedulable{
   List<String> delegatedtypes=System.label.BCBSM_Community_Agent_Types.split('\\|');
    //List<String> ContactIds = new List<String>{'0033s0000151lLkAAI','0033s000014Nd7VAAS'};
   //   global String query='select id, name, accountid, Active__c , vlocity_ins__Type__c ,  Batch_Action_Flag__c from contact where Batch_Action_Flag__c != \'Batch Processed\' and Batch_Action_Flag__c != \'None\' and Batch_Action_Flag__c != \'\' and recordtype.Name = \'Contact - Agent\' and vlocity_ins__Type__c  in :delegatedtypes and Id in :ContactIds' ;
    global String query; 
    global DelegateAgentAndAgentSharingBatch(string q){
        query = q;
    } 
    global DelegateAgentAndAgentSharingBatch(){
        query='select id, name, accountid, Active__c , vlocity_ins__Type__c ,  Batch_Action_Flag__c from contact where Batch_Action_Flag__c != \'Batch Processed\' and Batch_Action_Flag__c != \'None\' and Batch_Action_Flag__c != \'\' and recordtype.Name = \'Contact - Agent\' and vlocity_ins__Type__c  in :delegatedtypes' ; 
    }
    global Database.QueryLocator start(Database.BatchableContext bc){
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext BC,List<Contact> scope){
        List<Contact> newContactAgentList = new List<Contact>(); 
        List<Contact> newContactDAAgentList = new List<Contact>(); 
        List<Contact> UpdateContactDAAgentList = new List<Contact>(); 
        List<Contact> updateContactAgentList = new List<Contact>(); 
        set<id> contactIdsChangedToAgent = new set<id>();
            set<id> contactIdsChangedToaor = new set<id>();
        set<id> contactIdsChangedToDA = new set<id>();
        set<id> finalids = new set<id>();
        List<Contact> finaliupdatelist = new List<contact>(); 
        List<String> delegatecontacttype= System.label.Contact_Delegated_Agent.split('\\|');
        for (Contact contactRec : scope) {
           
           if(contactRec.Batch_Action_Flag__c == 'Updated To Agent' && contactRec.vlocity_ins__Type__c == 'Agent'){
                updateContactAgentList.add(contactRec); 
                contactIdsChangedToAgent.add(contactRec.Id);
                finalids.add(contactRec.Id);
                contactRec.Batch_Action_Flag__c = 'Batch Processed'; 
                finaliupdatelist.add(contactRec); 
            }
            else if(contactRec.Batch_Action_Flag__c == 'Updated to DA' && delegatecontacttype.contains(contactRec.vlocity_ins__Type__c)){
                UpdateContactDAAgentList.add(contactRec); 
                contactIdsChangedToaor.add(contactRec.Id);
                finalids.add(contactRec.Id);
                contactRec.Batch_Action_Flag__c = 'Batch Processed'; 
            finaliupdatelist.add(contactRec); 
            }
            

        }
        List<user> agentUser=new List<user>();
        if(finalids.size()>0){
             agentUser =  [SELECT id, contactid, name FROM user WHERE contactid in: finalids];
              set<id> agentids = new set<id>();
              if(agentUser.size()>0){
                  for(User usr:agentUser){
                     agentids.add(usr.id);
                  }
              }
            List<CaseShare> casesharedata=[SELECT Id, CaseId, UserOrGroup.Name,caseaccesslevel FROM CaseShare WHERE Rowcause='Manual' AND UserOrGroupid in :agentids];
            if (casesharedata.size() > 0 ) {
                delete casesharedata;
            }
            List<AccountShare> accountShareData=[SELECT Id, AccountId, UserOrGroup.Name, Accountaccesslevel FROM AccountShare where Rowcause='Manual' AND UserOrGroupid in :agentids];
            if (accountShareData.size() > 0 ) {
                delete accountShareData;
            }
        }
        
        if (updateContactAgentList.size() > 0 ) {
            if (contactIdsChangedToAgent.size() > 0 ) {
                List<GA_AOR__c> aorrecords = [select id, GA_Contact_Id__c, GA_Account_Id__c,GA_Service_Start_Date__c from ga_aor__c where GA_Contact_Id__c in:contactIdsChangedToAgent ];
                List<id> aorrecIdList = new List<Id>();
                for (GA_Aor__c aorRec : aorrecords) {
                     if(aorRec.GA_Service_Start_Date__c !=null && aorRec.GA_Service_Start_Date__c <= system.today()){
                        aorrecIdList.add(aorRec.id);
                     }
                }           
                    GA_updateAORBoB.sharingSupportRequestRecordsBatch(aorrecIdList);
                    List<user> agentUser1=new List<user>();
                 agentUser1 =  [SELECT id, contactid, name FROM user WHERE contactid in: contactIdsChangedToAgent];
                         Map<Id, Id> contactuserid = new Map<Id, Id>();
              if(agentUser1!=null && agentUser1.size()>0){
                for(User userRec:agentUser1){
                    contactuserid.put(userRec.id,userRec.contactid);                    
                }
            }
            if( contactuserid.keyset() != null){
                 List<Case> supportRequesListToUpdate = new List<Case>();
                for(Case supportRequest: [SELECT Id, FSA_Delegated_Agent__c FROM Case where FSA_Delegated_Agent__c =: contactuserid.keyset()]){
                    supportRequest.FSA_Delegated_Agent__c = null;
                    supportRequesListToUpdate.add(supportRequest);
                }
                update supportRequesListToUpdate;
            }
                
        }            
            
        }       
          
        if (UpdateContactDAAgentList.size() > 0 ) {
            DelegateContactBOBBatchHelper.delegateContactAccountCaseBOB(UpdateContactDAAgentList);          
            if (contactIdsChangedToaor.size() > 0 ) {
                List<GA_AOR__c> aorrecords1 = [select id, GA_Contact_Id__c, GA_Account_Id__c,GA_Service_Start_Date__c from ga_aor__c where GA_Contact_Id__c in:contactIdsChangedToaor ];
                List<id> aorrecIdList1 = new List<Id>();
                for (GA_Aor__c aorRec : aorrecords1) {
                     if(aorRec.GA_Service_Start_Date__c !=null && aorRec.GA_Service_Start_Date__c <= system.today()){
                        aorrecIdList1.add(aorRec.id);
                     }
                }                
                    GA_updateAORBoB.sharingSupportRequestRecordsBatch(aorrecIdList1);               
                
            }
            
        
            
        }
        if(finaliupdatelist.size()>0){
            update finaliupdatelist; 
        }
    }
    global void finish(Database.BatchableContext BC){
        DelegateAgentBatch  batch= new DelegateAgentBatch();
        if(!Test.isRunningTest())
         Database.executeBatch(batch, 2);
       
    }
    global void execute(SchedulableContext sc)
    {
        DelegateAgentAndAgentSharingBatch batchShare = new  DelegateAgentAndAgentSharingBatch(); 
        Database.executeBatch(batchShare, 1); 
    }
    }