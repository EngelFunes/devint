trigger FECChecklistTrigger on FEC_Checklist__c (before insert, before update) {
    
    
    if(Trigger.IsInsert && Trigger.IsBefore){
        Map<String,Group> groupMap = new Map<String,Group>();
        for(Group groups : [Select Id, DeveloperName from Group where Type = 'Queue']){
            groupMap.put(groups.DeveloperName,groups);
        }
        Id profileId= userinfo.getProfileId();
        String statusValue = '';
        Id groupId;
        String profileName = [Select Id,Name from Profile where Id=:profileId].Name;
        
        
        if(profileName == 'West Michigan Support'){
            groupId = groupMap.get('West_Michigan_Support_PCS_Queue').Id;
            statusValue = 'send to pcs';
        }else if(profileName == 'Support'){
            groupId = groupMap.get('GA_Account_Services').Id;
        } 
        
        //System.debug('--groupId----'+groupId);
        
        for(FEC_Checklist__c fcCheckist : Trigger.New){
            if(groupId != null ){
                fcCheckist.ownerId = groupId;
                if(statusValue != ''){
                    fcCheckist.Status__c = statusValue;
                }
            }
        }
        
        
    }
    if(Trigger.IsUpdate && Trigger.IsBefore){
        
        Group queue = [Select Id  from Group where Type = 'Queue' and DeveloperName  = 'West_Michigan_Support_PCS_Queue' limit 1];
        for(FEC_Checklist__c fcCheckist : Trigger.New){
            
            // If Recheck Needed is true or owner id is changing from pcs to created owner id than status = reverted to asr
            if(fcCheckist.CreatedById == fcCheckist.OwnerId || fcCheckist.Recheck_Needed__c){
                fcCheckist.Status__c = 'reverted to asr';                
            }
            
            // If the owner id set to pcs again from the original owner of record than status = resend to pcs
            if(queue.Id == fcCheckist.OwnerId){
                fcCheckist.Status__c = 'resend to pcs'; 
            }
            
            // If Quality check is true than status = completed
            if(fcCheckist.Quality_Check_OK__c){
                fcCheckist.Status__c = 'completed';               
            }
        }
    }
    
    
}