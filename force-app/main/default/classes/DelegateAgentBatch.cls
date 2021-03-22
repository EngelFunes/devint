global  class DelegateAgentBatch implements Database.Batchable<sObject>,Database.Stateful,Schedulable{
    
    List<String> agentprofiles=System.Label.BCBSM_Community_Agent_Profiles.split('\\|'); 
    global String query='select id, Contactid from user where contactid!=null and user.profile.name in :agentprofiles and Createddate= LAST_N_DAYS:3';
    
   // global String query='select id, Contactid from user where contactid!=null and user.profile.name in(\'BCBSM Both\',\'BCBSM FSA\',\'BCBSM Both Login\',\'BCBSM FSA Login\') and Createddate= LAST_N_DAYS:3';
    global Database.QueryLocator start(Database.BatchableContext bc){
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext BC,List<User> scope){
        Set<id> contactIDs=new set<id>();
        for(User userrec:scope){
            contactIDs.add(userrec.contactid);
        }
         List<String>  delegatedtypes=System.label.Contact_Delegated_Agent.split('\\|');
        List<String> agenttypes=System.label.Contact_Agent_Types.split('\\|');
        List<Contact> contactlist=[Select id, name, accountid, Active__c , vlocity_ins__Type__c ,  Batch_Action_Flag__c from contact where Batch_Action_Flag__c != 'Batch Processed'  and vlocity_ins__Type__c  in :agenttypes and ID in :contactIDs ];
   
        List<Contact> newContactDAAgentList = new List<Contact>(); 
       
        set<id> contactIdsChangedToAgent = new set<id>();
       
       List<Contact> finaliupdatelist = new List<contact>(); 
                
        for (Contact contactRec : contactlist) {
           
            if (contactRec.vlocity_ins__Type__c == 'Agent') {
                contactIdsChangedToAgent.add(contactRec.id); 
                 contactRec.Batch_Action_Flag__c = 'Batch Processed'; 
            finaliupdatelist.add(contactRec); 

              }
            else if( delegatedtypes.contains(contactRec.vlocity_ins__Type__c )){
                newContactDAAgentList.add(contactRec);
                     contactRec.Batch_Action_Flag__c = 'Batch Processed'; 
            finaliupdatelist.add(contactRec); 

            }
            
           
        }
        if(contactIdsChangedToAgent.size()>0){
             if (contactIdsChangedToAgent.size() > 0 ) {
               List<GA_AOR__c> aorrecords = [select id, GA_Contact_Id__c, GA_Account_Id__c,GA_Service_Start_Date__c from ga_aor__c where GA_Contact_Id__c in:contactIdsChangedToAgent ];
               List<id> aorrecIdList = new List<Id>();
               for (GA_Aor__c aorRec : aorrecords) {
                   if(aorRec.GA_Service_Start_Date__c !=null && aorRec.GA_Service_Start_Date__c <= system.today()){
                    aorrecIdList.add(aorRec.id);
                   }                    
               }
             
              GA_updateAORBoB.sharingSupportRequestRecordsBatch(aorrecIdList);
            }
        }
       
        if (newContactDAAgentList.size() > 0 ) {
            DelegateContactBOBBatchHelper.delegateContactAccountCaseBOB(newContactDAAgentList);
        }
       update finaliupdatelist; 
    }
    global void finish(Database.BatchableContext BC){
      GA_UpdateAORSRShareBOBBatch batch= new GA_UpdateAORSRShareBOBBatch();
           Database.executeBatch(batch, 2);
    }
     global void execute(SchedulableContext sc)
    {
        DelegateAgentBatch  batch= new DelegateAgentBatch();
           Database.executeBatch(batch, 2);
    }
}