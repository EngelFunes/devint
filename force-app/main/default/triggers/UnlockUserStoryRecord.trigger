trigger UnlockUserStoryRecord on User_Story__c (after update) {
    List<User_Story__c> unlockStories= new List<User_Story__c>();
    
   for(User_Story__c u: Trigger.new) {
      if(u.Status__c == 'Approved to Deploy' && u.Approvals_Completed__c && Approval.isLocked(u))
          unlockStories.add(u);
    }
    
    Approval.UnlockResult[] results = Approval.unlock(unlockStories, false);

}