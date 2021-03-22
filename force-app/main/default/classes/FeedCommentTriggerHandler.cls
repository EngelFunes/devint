public class FeedCommentTriggerHandler {
    public static void feedCommentBeforeIU(List<FeedComment> feedCommentList) {
        
        id currentUserId = UserInfo.getUserId();
        user currentUser = [
            SELECT id, profileid, profile.name
            FROM user
            WHERE id = :currentUserId
        ];
        Set<Id> supportRequestIds = new Set<Id>();
        
        for (FeedComment feedCommentFromPost : feedCommentList) {
            if (feedCommentFromPost.parentId != null && String.valueOf(feedCommentFromPost.parentId).startsWith('500')) {
                if (currentUser.Profile.Name == System.label.User_Profile_Name_BCBSM_FSA ||
                    currentUser.Profile.Name == System.label.User_Profile_Name_BCBSM_Both ||
//                    currentUser.Profile.Name == System.label.User_Profile_Name_BCBSM_Both_Login ||
                    currentUser.Profile.Name == System.label.User_Profile_Name_BCBSM_FSA_login ||
                    currentUser.Profile.Name == System.label.User_Profile_Name_RetentionSales ||
                    currentUser.Profile.Name == System.label.User_Profile_Name_WestMichiganSales ||
                    currentUser.Profile.Name == System.label.User_Profile_Name_MAUser ||
                    currentUser.Profile.Name == System.label.User_Profile_Name_Pilot ||
                    currentUser.Profile.Name == System.label.User_Profile_Name_MAcommunityLogin ||
                    currentUser.Profile.Name == System.label.User_Profile_Name_LargeGroup ||
                    currentUser.Profile.Name == System.label.User_Profile_Name_MediSales ||
                    currentUser.Profile.Name == System.label.User_Profile_Name_BusiSales) {
                        supportRequestIds.add(feedCommentFromPost.ParentId);
                    }
            }
        }
        system.debug('supportRequestIds==>'+supportRequestIds+'==='+currentUser.Profile.Name);
        set<id> exitingParentSet = new set<id>();
        set<id> feeditemid = new set<id>();
        Map<Id, FeedItem> fitem = new  Map<Id, FeedItem>();
        List<string> exitingfeedBody = new List<string>();
        List<FeedItem> exitingFeedItems = [select id, parentid, Body,type, createdby.profile.name from feeditem where parentid in:supportRequestids];
        if(exitingFeedItems.size()  > 0){
        for (feeditem feedrec : exitingFeedItems) {
            if (feedrec.createdby.profile.name == System.label.User_Profile_Name_Support || 
                feedrec.createdby.profile.name == System.label.User_Profile_Name_WestMichiganSup ||
                feedrec.createdby.profile.name == 'PCS - Support' ||
                feedrec.createdby.profile.name == 'PCS - West Michigan Support') {
                exitingParentSet.add(feedrec.parentid);
                exitingfeedBody.add(feedrec.Body);
                feeditemid.add(feedrec.Id);
                fitem.put(feedrec.id, feedrec);
            }
        }
        }
        // This code prevent the Agent from Using Chatter until an ASR has started the chat.
        for (FeedComment feedCommentFromPost : feedCommentList) {
            if (supportRequestids.contains(feedCommentFromPost.parentid)) {
                if (currentUser.Profile.Name != System.label.User_Profile_Name_Support && 
                    currentUser.profile.name != System.label.User_Profile_Name_WestMichiganSup &&
                    currentUser.Profile.Name != 'PCS - Support' &&
                    currentUser.Profile.Name != 'PCS - West Michigan Support') {
                        if (!exitingParentSet.contains(feedCommentFromPost.parentid) || 
                            !feeditemid.contains(feedCommentFromPost.FeedItemId) || 
                           fitem.get(feedCommentFromPost.FeedItemId).body ==null || fitem.get(feedCommentFromPost.FeedItemId).body =='') 
                        {
                            feedCommentFromPost.addError('Only ASR can initiate chatter on a support request');
                        }
                        
                    }
            }
        }
    }
    
    Public static void deligateAgentUpdate(List<FeedComment> feedCommentList) {
        Set<Id> supportRequestIds = new Set<Id>();
        List<Case> CaseListupdate = New List<Case>();
        for (FeedComment feedCommentFromPost : feedCommentList) {
            if (feedCommentFromPost.parentId != null && String.valueOf(feedCommentFromPost.parentId).startsWith('500')) {
                supportRequestIds.add(feedCommentFromPost.ParentId);
                system.debug('===========feedCommentFromPost.ParentId'+feedCommentFromPost.ParentId);
            }
        }  
        user currentUser = [SELECT Id,Delegate_User__c,Email,contact.vlocity_ins__Type__c,ProfileId, Profile.name 
                            FROM user 
                            WHERE id =: UserInfo.getUserId()];
        
        system.debug('=============username==>'+currentUser.id);
        
        if(supportRequestIds.Size()>0){ 
            UpdateDelegateAgentFuture.updateDelegateAgentOnCase(supportRequestIds, currentUser.id, currentUser.Email,currentUser.contact.vlocity_ins__Type__c );
        }
    }
    
    Public static void postcommentBeforeInsertAndUpdate(List<FeedComment> FeedCommentNew) {
        Set<id> caseIds = new Set<id>();
        List<Case>listOfCase = new List<Case>();
        Map<Id, Case> mapCase = new Map<Id, Case>();
        Id currentUserId = UserInfo.getUserId();
        User currentUser = [
            SELECT Id, profileid, profile.name
            FROM User
            WHERE Id = :currentUserId
        ];
        for (FeedComment FeedComment : FeedCommentNew) {
            if (FeedComment.parentId != null && string.valueOf(FeedComment.parentId).startsWith('500')) {
                caseIds.add(FeedComment.ParentId);
            }
        }
        listOfCase = [
            SELECT Id,Status
            FROM Case
            WHERE Id in :caseIds
        ];
        for (Case caseRecord : listOfCase) {
            mapCase.put(caseRecord.Id, caseRecord);
        }
        for (FeedComment FeedComment : FeedCommentNew) {
            if (mapCase.containskey(FeedComment.ParentId)) {
                if ((mapCase.get(FeedComment.ParentId).Status == 'Closed' || mapCase.get(FeedComment.ParentId).Status == 'New')
                   /** &&
                    (currentUser.Profile.Name == System.label.User_Profile_Name_Support ||    currentUser.profile.name == System.label.User_Profile_Name_WestMichiganSup ||
                     currentUser.Profile.Name == System.label.User_Profile_Name_BCBSM_Both ||        currentUser.Profile.Name == System.label.User_Profile_Name_BCBSM_FSA ||
                     currentUser.Profile.Name == System.label.User_Profile_Name_BCBSM_Both_Login ||      currentUser.Profile.Name == System.label.User_Profile_Name_BCBSM_FSA_login ||
                     currentUser.Profile.Name == System.label.User_Profile_Name_RetentionSales ||      currentUser.Profile.Name == System.label.User_Profile_Name_WestMichiganSales ||
                     currentUser.Profile.Name == System.label.User_Profile_Name_MAUser ||      currentUser.Profile.Name == System.label.User_Profile_Name_Pilot ||
                     currentUser.Profile.Name == System.label.User_Profile_Name_MAcommunityLogin ||   currentUser.Profile.Name == System.label.User_Profile_Name_LargeGroup ||
                     currentUser.Profile.Name == System.label.User_Profile_Name_MediSales ||     currentUser.Profile.Name == System.label.User_Profile_Name_BusiSales)  **/
                   ) {
                         FeedComment.addError('You cannot comment when the support request status is New OR Closed ');
                     }
            }
        }
    }
    
    public static void setRequestNumberAccountDetails(List<FeedComment> feedCommentList) {
        Set<Id> supportRequestIds = new Set<Id>();
        Map<Id, Case> supportRequestMap = new Map<Id, Case>();
        List<String> toAddresses = new List<String>();
        Boolean notsupportprofile = false;
        Id currentUserId = UserInfo.getUserId();
        string currentUserId1 = UserInfo.getUserId();
        List<Contact> conList = [Select id, LastName, AccountId From Contact Limit 1];
        string address =  System.Label.OrgwideEmailAddress;
        OrgWideEmailAddress owa = [select id, Address, DisplayName from OrgWideEmailAddress WHERE Address =:address];
        User currentUser = [
            SELECT profile.name, Name
            FROM user
            WHERE Id = :currentUserId
        ];
        for (FeedComment feedCommentRecord : feedCommentList) {
            if (feedCommentRecord.parentId != null && String.valueOf(feedCommentRecord.parentId).startsWith('500')) {
                supportRequestIds.add(feedCommentRecord.ParentId);              
            }
        }
        system.debug('supportRequestIds-=>'+supportRequestIds);
        string AORemail;
        if (supportRequestIds != null) {
            for (Case supportRequestRecord : [
                SELECT Id, CaseNumber, Account.Name,Delegated_Agent_Email__c, Account.AccountNumber, GA_ASR__c, GA_ASR__r.Email,ASR_Email__c,GA_ASR__r.Name,
                ASR_Name__c, GA_AgentName__r.email, ContactId, FSA_Delegated_Agent__r.email, GA_AgentName__r.Name, FSA_Delegated_Agent__r.Name,Managing_Agent__r.email
                FROM Case
                WHERE Id in :supportRequestIds
            ]) {
                supportRequestMap.put(supportRequestRecord.Id, supportRequestRecord);
            }

            for (FeedComment feedCommentFromPost : feedCommentList) {
                if (supportRequestMap.containskey(feedCommentFromPost.ParentId)) 
                {
                    if (currentUser.profile.name == System.label.User_Profile_Name_Support ||
                        currentUser.profile.name == System.label.User_Profile_Name_WestMichiganSup ||
                        currentUser.Profile.Name == System.label.User_Profile_Name_BCBSM_FSA ||
                        currentUser.profile.name == System.label.User_Profile_Name_BCBSM_Both ||
                        currentUser.Profile.Name == System.label.User_Profile_Name_BCBSM_Both_Login ||
                        currentUser.Profile.Name == System.label.User_Profile_Name_BCBSM_FSA_login ||
                        currentUser.Profile.Name == System.label.User_Profile_Name_MAUser ||
                        currentUser.Profile.Name == System.label.User_Profile_Name_Pilot ||
                        currentUser.Profile.Name == System.label.User_Profile_Name_MAcommunityLogin)
                    {
                        system.debug('---1');
                            Case supportRequestRecord = supportRequestMap.get(feedCommentFromPost.ParentId);
                            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                            Messaging.SingleEmailMessage mail1 = new Messaging.SingleEmailMessage();
                            if (currentUser.profile.name == System.label.User_Profile_Name_Support ||
                                currentUser.profile.name == System.label.User_Profile_Name_WestMichiganSup)
                            {
                                    if (supportRequestRecord.GA_AgentName__r.email != null) {
                                        toAddresses.add(supportRequestRecord.GA_AgentName__r.email);
                                    }
                                    if (supportRequestRecord.FSA_Delegated_Agent__r.email != null) {
                                        toAddresses.add(supportRequestRecord.FSA_Delegated_Agent__r.email);
                                    }
                                    if (supportRequestRecord.Managing_Agent__r.email != null) {
                                        system.debug('---2');
                                        toAddresses.add(supportRequestRecord.Managing_Agent__r.email);
                                    }
                                }
                            else {
                                if (supportRequestRecord.ASR_Email__c != null) {
                                    toAddresses.add(supportRequestRecord.ASR_Email__c);
                                    notsupportprofile = true;
                                    System.debug(supportRequestRecord.ASR_Email__c);
                                }
                            }
                            
                            System.debug('Test');
                     /**       if (toAddresses.size() > 0 && notsupportprofile == false) {
                                 system.debug('---Email Verification');
                                EmailTemplate emailTemplate = [Select Id, Subject, Description, HtmlValue,DeveloperName,Body
                                                               FROM EmailTemplate where Name = 'Notification to Agent when ASR uses @mention'];
                                System.debug('emailTemplate   '+emailTemplate );
                                mail.setToAddresses(toAddresses);
                                mail.setTargetObjectId(conList[0].Id);
                                mail.setTemplateId(emailTemplate.Id);
                                mail.setWhatId(supportRequestRecord.Id);
                                mail.setSaveAsActivity(false);
                                mail.setOrgWideEmailAddressId(owa.id);
                                mail.setTreatTargetObjectAsRecipient(false);
                                
                                Messaging.SendEmailResult[] results = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {
                                    mail
                                        });
                                if (results[0].success) {
                                    System.debug('The email was sent successfully.');
                                } else {
                                    System.debug('The email failed to send: '
                                                 + results[0].errors[0].message);
                                }
                                
                            }**/
                            
                           /** else if(toAddresses.size() > 0 && notsupportprofile == true) {
                                System.debug('non profit profile');
                                EmailTemplate emailTemplate = [Select Id, Subject, Description, HtmlValue,DeveloperName,Body
                                                               FROM EmailTemplate where Name = 'Notification to ASR when Agent responds to chatter'];
                                
                                EmailTemplate emailTemplate1 = [Select Id, Subject, Description, HtmlValue,DeveloperName,Body
                                                                FROM EmailTemplate where Name = 'Email to agent when DA responses on chatter by ASR'];
                                
                                
                                
                                mail.setToAddresses(toAddresses);
                                mail.setTargetObjectId(conList[0].Id);
                                mail.setTemplateId(emailTemplate.Id);
                                mail.setWhatId(supportRequestRecord.Id);
                                mail.setSaveAsActivity(false);
                                mail.setOrgWideEmailAddressId(owa.id);
                                mail.setTreatTargetObjectAsRecipient(false);
                                
                                List<String> newtoAddress =new List<String> {supportRequestRecord.GA_AgentName__r.email};
                                    mail1.setToAddresses(newtoAddress);
                                mail1.setTargetObjectId(conList[0].Id);
                                mail1.setTemplateId(emailTemplate1.Id);
                                mail1.setWhatId(supportRequestRecord.Id);
                                mail1.setSaveAsActivity(false);
                                mail1.setOrgWideEmailAddressId(owa.id);
                                mail.setTreatTargetObjectAsRecipient(false);
                                system.debug('---'+currentUserId1+'--->'+supportRequestRecord.FSA_Delegated_Agent__c+'----'+supportRequestRecord.GA_AgentName__c);
                                if(currentUserId1 == supportRequestRecord.FSA_Delegated_Agent__c) {
                                    Messaging.SendEmailResult[] results1 = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {
                                        mail,mail1
                                            });
                                    if (results1[0].success) {
                                        System.debug('The email was sent successfully.');
                                    } else {
                                        System.debug('The email failed to send: '
                                                     + results1[0].errors[0].message);
                                    }
                                }else if(currentUserId1 != supportRequestRecord.FSA_Delegated_Agent__c) {
                                    Messaging.SendEmailResult[] results1 = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {
                                        mail
                                            });
                                    if (results1[0].success) {
                                        System.debug('The email was sent successfully.');
                                    } else {
                                        System.debug('The email failed to send: '
                                                     + results1[0].errors[0].message);
                                    }
                                }
                                
                                
                            }  **/
                        }
                }
            }
        }
    }
    public static void noResponseEmailChecktoAgent(List<FeedComment> feedItemNew ){
        Profile p = [SELECT Name from Profile WHERE Id = :UserInfo.getProfileId()];
        
        system.debug('==========>'+p.name);
        Set<id> caseids = new Set<id>();
        for (FeedComment feedItem : feedItemNew) {
            if (feedItem.parentId != null && string.valueOf(feedItem.parentId).startsWith('500')) {
                caseIds.add(feedItem.ParentId);
            }
        }
        boolean updateCase = false;
        if (p.name != System.label.User_Profile_Name_RetentionSales 
            ||  p.name != System.label.User_Profile_Name_BCBSM_FSA
            ||  p.name != System.label.User_Profile_Name_BCBSM_Both
            ||  p.name != System.label.User_Profile_Name_BCBSM_Both_Login
            ||  p.name != System.label.User_Profile_Name_BCBSM_FSA_login
            ||  p.name != System.label.User_Profile_Name_MAUser
            ||  p.name != System.label.User_Profile_Name_Pilot
            ||  p.name != System.label.User_Profile_Name_MAcommunityLogin
            ||  p.name != System.label.User_Profile_Name_WestMichiganSales
            ||  p.name != System.label.User_Profile_Name_LargeGroup
            ||  p.name != System.label.User_Profile_Name_MediSales
            ||  p.name != System.label.User_Profile_Name_BusiSales
           ) {
               List<Case> caseList = [select id, Status,RecordType.DeveloperName,Field_reoccurrence_email_check__c from case where id in: caseids];
               for (case caseRec: caseList) {
                   if (caseRec.RecordType.DeveloperName =='Agent_Support_Request' && (p.name == System.label.User_Profile_Name_Support || 
                                                                                      p.name == System.label.User_Profile_Name_WestMichiganSup ||
                                                                                      p.name == 'PCS - Support' ||
                                                                                      p.name == 'PCS - West Michigan Support')) {
                       caseRec.Field_reoccurrence_email_check__c = false;
                   }
                   else {
                       //   caseRec.Field_reoccurrence_email_check__c = false;
                       updateCase = true;
                       
                   }
                   if(caseRec.status == 'Closed'){
                       updateCase = true;
                   } 
               }
               if(!updateCase){
                   update caseList;
               }  
               
           }
    }
    
    
}