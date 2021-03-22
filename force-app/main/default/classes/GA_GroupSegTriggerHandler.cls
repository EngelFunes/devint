public class GA_GroupSegTriggerHandler{
    
   public static boolean firstrun = true;     
   public static void updateGroupSegment(List<GA_Group_Segment__c> newList, Map<Id, GA_Group_Segment__c> oldMap){
        
        Set<String> facetGroupSet = new Set<String>();
        Set<String> facetSubGroupSet = new Set<String>();
        Map<Id,GA_Group_Segment__c> accAndGroupSegmentMap = new Map<Id,GA_Group_Segment__c>();
        List<GA_Group_Segment__c> updateGroupSegmentList = new List<GA_Group_Segment__c>();
        
        for(GA_Group_Segment__c gs : newList){
            if(gs.Status__c == 'Active' && gs.GA_Carrier__c == 'BCN' &&  
               (gs.GA_Administrative_Contact_Id__c != oldMap.get(gs.Id).GA_Administrative_Contact_Id__c || 
               	gs.GA_Billing_Contact_Id__c != oldMap.get(gs.Id).GA_Billing_Contact_Id__c))
            {
                accAndGroupSegmentMap.put(gs.GA_Account__c,gs);
                facetGroupSet.add(gs.GA_Facets_Group_ID__c);
                facetSubGroupSet.add(gs.GA_Facets_Sub_Group_Number__c);
            }
        }
        
        List<account> accList = [select id,(select id,GA_Carrier__c,Status__c, GA_Billing_Contact_Id__c,GA_Administrative_Contact_Id__c
                                            from Group_Segments__r where Status__c = 'Active' and  GA_Facets_Group_ID__c IN: facetGroupSet and  
                                            GA_Facets_Sub_Group_Number__c IN: facetSubGroupSet
                                            and GA_Carrier__c = 'BCN' ) from account where 
                                 id IN: accAndGroupSegmentMap.keySet()];
        
        system.debug('---accList---'+accList.size());
        
        for(account acc: accList){
            for(GA_Group_Segment__c gs : acc.Group_Segments__r){
                if(accAndGroupSegmentMap.containskey(acc.Id)){
                    GA_Group_Segment__c tempGS = accAndGroupSegmentMap.get(acc.Id);
                    system.debug('----tempGS---'+tempGS);
                    
                    if(gs.GA_Carrier__c == 'BCN' && gs.Status__c == 'Active')
                    {
                        if(tempGS.GA_Billing_Contact_Id__c != oldMap.get(tempGS.Id).GA_Billing_Contact_Id__c){
                            gs.GA_Billing_Contact_Id__c = tempGS.GA_Billing_Contact_Id__c;
                        }
                        if(tempGS.GA_Administrative_Contact_Id__c != oldMap.get(tempGS.Id).GA_Administrative_Contact_Id__c){
                            gs.GA_Administrative_Contact_Id__c = tempGS.GA_Administrative_Contact_Id__c;
                        }
                        updateGroupSegmentList.add(gs);
                    }                  
                    
                }               
                
            }
        }
        system.debug('---updateGroupSegmentList---'+updateGroupSegmentList.size());
        if(updateGroupSegmentList.size() > 0){
            update updateGroupSegmentList;
        }
    }
}