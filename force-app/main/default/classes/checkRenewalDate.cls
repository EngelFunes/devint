public class checkRenewalDate{
    public static void checkRenewalDateWithGS(map<id,Account> accNewMap, map<id,Account>  accoldMap){
       Set<Id> accIds = new Set<Id>();
       for (Account thisRecord: accNewMap.values()) {
            if (thisRecord.GA_Opportunity_Renewal_Date__c != null && accoldMap.get(thisRecord.Id).GA_Opportunity_Renewal_Date__c != thisRecord.GA_Opportunity_Renewal_Date__c) {
                accIds.add(thisRecord.Id);
            }
        }
        
        if(accIds != null && !accIds.isEmpty()){
            List<Account> accounts = [Select Id, GA_Opportunity_Renewal_Date__c, Renewal_Month_Variation_in_Groups__c, (SELECT GA_Rate_Renewal_Date__c FROM Group_Segments__r where Status__c = 'Active' ) from Account where Id IN: accIds];
              List<Account> accList = new List<Account>();
            for (Account account : accounts) {
            Integer accMmonth = account.GA_Opportunity_Renewal_Date__c.month();
            for (GA_Group_Segment__c groupSegment : account.Group_Segments__r) {
                if(groupSegment.GA_Rate_Renewal_Date__c != null){
                    Integer segmentMonth = groupSegment.GA_Rate_Renewal_Date__c.month();
                    if(accMmonth != segmentMonth){
                        account.Renewal_Month_Variation_in_Groups__c = true;
                        accList.add(account);
                        break;
                    } else{
                        account.Renewal_Month_Variation_in_Groups__c = false;
                        accList.add(account);
                    }
                }
                
            }
        }
        MAP<Id,Account> accMap = new MAP<Id,Account>(); 
            accMap.putall(accList); 
            if(accmap.size()>0){ 
                update accmap.values();
            }
        }
        
    }
}