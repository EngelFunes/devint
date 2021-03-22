global class AORAccountAccessRemoveSchedule Implements Schedulable {
    global void execute(SchedulableContext sc){
        List<GA_AOR__C> accAORList=[select id ,GA_Contact_Id__c,GA_Service_Start_Date__c,GA_Service_End_Date__c,GA_Account_Id__c FROM GA_AOR__C];
        GA_updateAORBoB.accountShareUpdateBoBDelete(accAORList,null );
    }  
}