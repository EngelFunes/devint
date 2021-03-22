public class GA_UpdateAORAccountAccessSchedular Implements Schedulable {
    public void execute(SchedulableContext sc){
        List<GA_AOR__C> accAORList=[select id ,GA_Contact_Id__c,GA_Account_Id__c,GA_Service_Start_Date__c,GA_Service_End_Date__c
                                     FROM GA_AOR__C WHERE GA_Service_Start_Date__c = Today];
        Map<Id,GA_AOR__C> aorMap = new Map<Id,GA_AOR__C>();
        
        if(accAORList.size()>0){
            for(GA_AOR__C aor : accAORList){
                aorMap.put(aor.Id, aor);
            }
            GA_updateAORBoB.accountShareUpdateBoB(accAORList,aorMap);
        }
    }  
}