public class FeedItemTriggerHandler {
    public static Boolean isFirstTime = true;
    public static void updateVisibilityForSupportRequest(List<FeedItem> newFeedItemLst){
        Set<Id> supportRequestIds = new Set<Id>();
        Map<Id, Case> supportRequestMap = new Map<Id, Case>();
        List<String> toAddresses = new List<String>();
        Id currentUserId = userInfo.getUserId();
        User currentUser = [
            SELECT profile.name
            FROM user
            WHERE Id = :currentUserId
        ];
        for (FeedItem feedItemRecord : newFeedItemLst) {
            if (feedItemRecord.parentId != null && String.valueOf(feedItemRecord.parentId).startsWith('500')) {
                supportRequestIds.add(feedItemRecord.ParentId);
            }
        }
        System.debug(supportRequestIds);
        if (supportRequestIds != null) {
            set<Id> exitingParentSet = new set<Id>();
            set<id> feeditemid = new set<id>();
            List<FeedItem> exitingFeedItems = [select Id, parentId, createdby.profile.name from feeditem where parentid in:supportRequestids];
            System.debug(exitingFeedItems); 
            
            for (feeditem feedrec : exitingFeedItems) {
                System.debug('lsr2  ' +feedrec.createdby.profile.name);
                System.debug('lsr   ' +System.label.User_Profile_Name_WestMichiganSup);
                if (feedrec.createdby.profile.name == System.label.User_Profile_Name_Support || feedrec.createdby.profile.name == System.label.User_Profile_Name_WestMichiganSup || feedrec.createdby.profile.name == 'PCS - Support' || feedrec.createdby.profile.name == 'PCS - West Michigan Support') {
                        exitingParentSet.add(feedrec.parentId);
                        feeditemid.add(feedrec.Id);
                    }
            }
            for (Case supportRequestRecord : [
                SELECT Id, CaseNumber, Account.Name, Account.AccountNumber, ContactId,
                GA_AgentName__r.email, FSA_Delegated_Agent__r.email, GA_ASR__r.Name
                FROM Case
                WHERE Id in :supportRequestIds
            ]) {
                supportRequestMap.put(supportRequestRecord.Id, supportRequestRecord);
            }
            for (FeedItem feedItemFromPost : newFeedItemLst) {
                if (supportRequestMap.containsKey(feedItemFromPost.ParentId)) {
                    //feedItemFromPost.Visibility = 'AllUsers';
                    if (currentUser.Profile.Name != System.label.User_Profile_Name_Support && currentUser.Profile.Name != System.label.User_Profile_Name_WestMichiganSup && currentUser.Profile.Name != 'PCS - Support' &&  currentUser.Profile.Name != 'PCS - West Michigan Support'){
                           if (!exitingParentSet.contains(feedItemFromPost.parentid)|| 
                               !feeditemid.contains(feedItemFromPost.BestCommentId)) {
                                   system.debug('@@@@@@@@@@@@@@@@@@@1');
                                   feedItemFromPost.addError('Only ASR can initiate chatter on a support request');
                               }
                       }
                    
                }
            }
        }
    }
    public static void setRequestNumberAccountDetails(List<FeedItem> newFeedItemLst) {
        
        
        
        Set<Id> supportRequestIds = new Set<Id>();
        Map<Id, Case> supportRequestMap = new Map<Id, Case>();
        List<String> toAddresses = new List<String>();
        Id currentUserId = userInfo.getUserId();
        User currentUser = [
            SELECT profile.name
            FROM user
            WHERE Id = :currentUserId
        ];
        for (FeedItem feedItemRecord : newFeedItemLst) {
            if (feedItemRecord.parentId != null && String.valueOf(feedItemRecord.parentId).startsWith('500')) {
                supportRequestIds.add(feedItemRecord.ParentId);
                
            }
        }
        
        if (supportRequestIds != null) {
            List<Contact> conList = [Select id, LastName, AccountId From Contact Limit 1];
            set<Id> exitingParentSet = new set<Id>();
            set<id> feeditemid = new set<id>();
            List<FeedItem> exitingFeedItems = [select Id, parentId, createdby.profile.name from feeditem where parentid in:supportRequestids];
            for (feeditem feedrec : exitingFeedItems) {
                
                if (feedrec.createdby.profile.name == System.label.User_Profile_Name_Support || feedrec.createdby.profile.name == System.label.User_Profile_Name_WestMichiganSup || feedrec.createdby.profile.name == 'PCS - Support' || feedrec.createdby.profile.name == 'PCS - West Michigan Support') {
                        exitingParentSet.add(feedrec.parentId);
                        feeditemid.add(feedrec.Id);
                    }
            }
            for (Case supportRequestRecord : [
                SELECT Id, CaseNumber, Account.Name, Account.AccountNumber, ContactId,
                GA_AgentName__r.email, FSA_Delegated_Agent__r.email, GA_ASR__r.Name
                FROM Case
                WHERE Id in :supportRequestIds
            ]) {
                supportRequestMap.put(supportRequestRecord.Id, supportRequestRecord);
            }
            string address1 =  System.Label.OrgwideEmailAddress;
            EmailTemplate emailTemplate = [Select Id, Subject, Description, HtmlValue,DeveloperName,Body
                                           FROM EmailTemplate where Name = 'Notification to Agent when ASR uses @mention'];
            
            OrgWideEmailAddress owa = [select id, Address, DisplayName from OrgWideEmailAddress WHERE Address =:address1];
            for (FeedItem feedItemFromPost : newFeedItemLst) {
                if (supportRequestMap.containsKey(feedItemFromPost.ParentId)) {    
                    if (
                    currentUser.Profile.Name != System.label.User_Profile_Name_Support && currentUser.Profile.Name != System.label.User_Profile_Name_WestMichiganSup &&  currentUser.Profile.Name != System.label.User_Profile_Name_RetentionSales && currentUser.Profile.Name != System.label.User_Profile_Name_LargeGroup && currentUser.Profile.Name != System.label.User_Profile_Name_BusiSales && currentUser.Profile.Name != System.label.User_Profile_Name_WestMichiganSales && currentUser.Profile.Name != 'PCS - Support' && currentUser.Profile.Name != 'PCS - West Michigan Support'  ) {
                           if (!exitingParentSet.contains(feedItemFromPost.parentid)|| 
                               !feeditemid.contains(feedItemFromPost.BestCommentId)) {
                                   feedItemFromPost.addError('Only ASR can initiate chatter on a support request');
                                   system.debug('@@@@@@@@@@@@@@@@@2');
                               }
                       } else {
                           Case supportRequestRecord = supportRequestMap.get(feedItemFromPost.ParentId);
                           
                           if (supportRequestRecord.GA_AgentName__r.email != null) {
                               toAddresses.add(supportRequestRecord.GA_AgentName__r.email);
                           }
                           
                           if (supportRequestRecord.FSA_Delegated_Agent__r.email != null) {
                               toAddresses.add(supportRequestRecord.FSA_Delegated_Agent__r.email);
                           }
                           System.debug(toAddresses);
                           if (toAddresses.size() > 0) {
                               // FeedItemEmailManagerFuture.sendEmailForFeedItem(toAddresses, supportRequestRecord.Id);
                               
                               Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                               mail.setToAddresses(toAddresses);
                               mail.setTargetObjectId(conList[0].Id);
                               mail.setTemplateId(emailTemplate.Id);
                               mail.setWhatId(supportRequestRecord.Id);
                               mail.setSaveAsActivity(false);
                               mail.setOrgWideEmailAddressId(owa.id);
                               mail.setTreatTargetObjectAsRecipient(false);
                           /**    Messaging.SendEmailResult[] results = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {
                                   mail
                                       }); 
                               System.debug(results);
                               if (results[0].success) {
                                   System.debug('The email was sent successfully.');
                               } else {
                                   System.debug('The email failed to send: '
                                                + results[0].errors[0].message);
                               }   **/
                               
                           } else {
                               System.debug('No Email Address Found');
                           }
                       }
                }
            }
        }
    }
    
    Public static void postChatterBeforeInsertAndUpdate(List<FeedItem> feedItemNew) {
        
        // Update the case object and mark the first chatter post has been made.
        /* for (FeedItem feedCommentFromPost : feedItemNew) {
if (Case.SObjectType == feedCommentFromPost.ParentId.getSobjectType()) {
Case existingCase = [SELECT Id,ASR_Chatter_Post_Made__c FROM Case WHERE Id = :feedCommentFromPost.ParentId];
existingCase.ASR_Chatter_Post_Made__c = true;
update existingCase;
Profile p = [SELECT Name from Profile WHERE Id = :UserInfo.getProfileId()];

}
}*/
        
        Set<id> caseids = new Set<id>();
        List<Case>listOfCase = new List<Case>();
        Map<Id, Case> mapCase = new Map<Id, Case>();
        Id currentUserId = UserInfo.getUserId();
        User currentUser = [
            SELECT Id, profileid, profile.name
            FROM User
            WHERE Id = :currentUserId
        ];
        for (FeedItem feedItem : feedItemNew) {
            if (feedItem.parentId != null && string.valueOf(feedItem.parentId).startsWith('500')) {
                caseIds.add(feedItem.ParentId);
            }
        }
        listOfCase = [
            SELECT Id,Status
            FROM Case
            WHERE Id in :caseids
        ];
        for (Case caseRecord : listOfCase) {
            mapCase.put(caseRecord.Id, caseRecord);
        }
        for (FeedItem feedItem : feedItemNew) {
            if (mapCase.containskey(feedItem.ParentId)) {
                if (mapCase.get(feedItem.ParentId).Status == 'Closed' || mapCase.get(feedItem.ParentId).Status == 'New') {
                    // && (currentUser.Profile.Name == 'Support' || currentUser.Profile.Name == 'BCBSM Agent' || currentUser.Profile.Name == 'Retention Sales' || currentUser.Profile.Name == 'West Michigan Sales')) {
                    feedItem.addError('You cannot Post Chatter when the support request status is New OR Closed ');
                }
            }
        }
    }
    
    public static void noResponseEmailChecktoAgent(List<FeedItem> feedItemNew ){
        Profile p = [SELECT Name from Profile WHERE Id = :UserInfo.getProfileId()];
        Set<id> caseids = new Set<id>();
        for (FeedItem feedItemRec : feedItemNew) {
            if (feedItemRec.parentId != null && string.valueOf(feedItemRec.parentId).startsWith('500') && feedItemRec.Type == 'TextPost' ) {
                caseIds.add(feedItemRec.ParentId);
            }
        }
        boolean updateCase = false;
        List<Case> caseList = [select id, Field_reoccurrence_email_check__c ,recordtype.name from case where id in: caseids];
        for (case caseRec: caseList) {
            //  if (p.name == 'Support' ) { 
            if (caseRec.recordtype.name== 'Agent Support Request' && (p.name == System.label.User_Profile_Name_Support || p.name == System.label.User_Profile_Name_WestMichiganSup || p.name == System.label.User_Profile_Name_RetentionSales || p.name == System.label.User_Profile_Name_LargeGroup || p.name == System.label.User_Profile_Name_BusiSales || p.name == System.label.User_Profile_Name_WestMichiganSales || p.name == 'PCS - Support' || p.name == 'PCS - West Michigan Support')) {
                    caseRec.Field_reoccurrence_email_check__c = true;
                }
            else {
                // caseRec.Field_reoccurrence_email_check__c = false;
                updateCase = true;
            }
        }
        if(!updateCase){
            update caseList;
        }  
    }
}