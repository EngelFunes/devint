public class GA_Account_TriggerHandler{
      @InvocableMethod
    public static void handleAORsOnAccount(List<Account> accountsMap){
        List<User> user = [Select Id, GA_ByPass_WF__c from User where Id =: UserInfo.getUserId() LIMIT 1];
        Set<Id> idsSet = new Set<Id>();
        Map<Id, GA_AOR__c> aorsToUpdate = new Map<Id, GA_AOR__c>();
        system.debug('I am in class' + JSON.serializePretty(accountsMap) );
        //List<Account> accs = [Select Account_Status__c, RecordType.DeveloperName from Account where Id IN: accountsMap];
        for(Account acc : accountsMap){
            if(acc.Account_Status__c == 'Inactive'  && !(user[0].GA_ByPass_WF__c)){
                system.debug('acc>>>>>'+acc);
                idsSet.add(acc.Id);
            }
        }
        system.debug('ID set' + idsSet);
        if(idsSet != null && idsSet.size() > 0){
            List< GA_AOR__c > AORs = [SELECT Id, 
                                                GA_BCN_Agent_Auth_Letter__c,
                                                GA_Applies_to_Agency__c, 
                                                GA_Release_BCN_ASC_PHI_to_Agent__c,
                                                GA_Release_BCN_ERS_PHI_to_Agent__c,
                                                Release_BCBSM_ASC_PHI_to_Agent__c,
                                                Release_BCBSM_ERS_PHI_to_Agent__c,
                                                BCBSM_PHI_End_Date__c,
                                                GA_PHI_End_Date__c
                                              from GA_AOR__c where GA_Account_Id__c IN: idsSet];
          if(AORs != null && AORs.size() > 0){
              for(GA_AOR__c aor : AORs){
                  //if(aor.GA_BCN_Agent_Auth_Letter__c == true || aor.GA_Applies_to_Agency__c == true){
                        aor.GA_Release_BCN_ASC_PHI_to_Agent__c = false;
                        aor.GA_Release_BCN_ERS_PHI_to_Agent__c = false;
                        aor.Release_BCBSM_ASC_PHI_to_Agent__c = false;
                        aor.Release_BCBSM_ERS_PHI_to_Agent__c = false;
                        aor.GA_BCN_Agent_Auth_Letter__c = false;
                        aor.GA_Applies_to_Agency__c = false;
                 // }
                  if(aor.BCBSM_PHI_End_Date__c > Date.today()){
                      aor.BCBSM_PHI_End_Date__c = Date.today(); 
                  }
                  
                  if(aor.GA_PHI_End_Date__c > Date.today()){
                      aor.GA_PHI_End_Date__c = Date.today(); 
                  }
                  aorsToUpdate.put(aor.Id, aor);
              }
              
              if(aorsToUpdate != null && aorsToUpdate.size() > 0 ){
                  update aorsToUpdate.values();
              }
          }
        }
        
    }
}