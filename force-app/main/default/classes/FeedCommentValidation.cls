public class FeedCommentValidation {
    public static void feedCommentValidation(List<FeedComment> feedCommentList){
        Id recTypeIdofcontact = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get(System.label.Contact_Delegate_Agent_Record_Type).getRecordTypeId();
        Set<Id> supportRequestIds = new Set<Id>();
        Map<Id,Case> supportRequestsMap = new Map<Id,Case>();
        Set<Id> userIds = new Set<Id>();
        Set<Id> agentIds = new Set<Id>();
        Map<Id,Id> userMap = new Map<Id,Id>();
        Id profileId = [Select Id From Profile Where Name='Retention Sales'].Id;
        Id currentUserId = UserInfo.getUserId();
        List<String>  delegatedtypes=System.label.Contact_Delegated_Agent.split('\\|');
        User user = [select Id,contact.vlocity_ins__Type__c,contactId,profile.name from user where Id =: UserInfo.getUserId()];
        system.debug('+++++++++++'+feedCommentList);
        for (FeedComment feedCommentFromPost : feedCommentList) {
            if (feedCommentFromPost.parentId != null && String.valueOf(feedCommentFromPost.parentId).startsWith('500')) {
                supportRequestIds.add(feedCommentFromPost.ParentId);
            }
        }
        if(supportRequestIds.size()>0){
            List<Case> cList = [select Id,RecordTypeId,ownerId,GA_AgentName__c,CreatedBy.ProfileId from Case where Id In: supportRequestIds];
            for(Case c : cList){
                agentIds.add(c.GA_AgentName__c);
                supportRequestsMap.put(c.Id,c);
            }
            if(agentIds.size()>0){
                List<User> userList = [select Id,contactId from user where contactId in: agentIds];
                if(userList.size()>0){
                    for(user u : userList){
                        userMap.put(u.contactId,u.Id);
                    }
                }
            }
            for (FeedComment feedCommentFromPost : feedCommentList) {
                if (feedCommentFromPost.parentId != null && String.valueOf(feedCommentFromPost.parentId).startsWith('500')) {
                    if(supportRequestsMap.get(feedCommentFromPost.parentId).CreatedBy.ProfileId != null && supportRequestsMap.get(feedCommentFromPost.parentId).CreatedBy.ProfileId == profileId){
                        if(user.Profile.Name == System.label.User_Profile_Name_Agent){
                            feedCommentFromPost.addError('You cannot comment on this Support Request');
                        }
                    }                    
                    if(supportRequestsMap.get(feedCommentFromPost.parentId) != null &&  userMap.get(supportRequestsMap.get(feedCommentFromPost.parentId).GA_AgentName__c) != null)
                    {
                        if(user.contactId != null && !delegatedtypes.contains(user.contact.vlocity_ins__Type__c))
                        {
                            if(userMap.get(supportRequestsMap.get(feedCommentFromPost.parentId).GA_AgentName__c) != UserInfo.getUserId()){
                                feedCommentFromPost.addError('You cannot comment on this Support Request');
                            }
                        } 
                    }
                }
            }
        }
    }
}