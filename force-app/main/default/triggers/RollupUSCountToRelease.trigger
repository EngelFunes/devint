trigger RollupUSCountToRelease on User_Story__c (after insert, after update, after delete) {
    List<Id> ReleaseIds = new List<Id>();

    for(User_Story__c u: Trigger.new) {
      ReleaseIds.add(u.Release__c);
      if(Trigger.isUpdate || Trigger.isDelete) {
        for(User_Story__c us: Trigger.old) {
            if(u.Release__c != us.Release__c) {
            	ReleaseIds.add(us.Release__c);
        		}
        	}
    	} 
    }

    AggregateResult[] totalResults = [SELECT count(id)userStoryCount, Release__c FROM User_Story__c WHERE Release__c in :ReleaseIds AND Status__c NOT IN ('Duplicate', 'Cancelled') GROUP BY Release__c];
    AggregateResult[] approvedResults = [SELECT count(id)userStoryCount, Release__c FROM User_Story__c WHERE Release__c in :ReleaseIds AND Approvals_Completed__c = true GROUP BY Release__c];

    Map<Id,Release__c> releaseMap = new Map<Id,Release__c>([SELECT id, Total_User_Stories__c, Approved_User_Stories__c FROM Release__c WHERE Id in :ReleaseIds]);

    for(AggregateResult ar: totalResults ) {
      releaseMap.get((Id)ar.get('Release__c')).Total_User_Stories__c = (decimal)ar.get('userStoryCount');
      releaseMap.get((Id)ar.get('Release__c')).Approved_User_Stories__c = 0;
    }
        
    for(AggregateResult ar: approvedResults ) {
      releaseMap.get((Id)ar.get('Release__c')).Approved_User_Stories__c = (decimal)ar.get('userStoryCount');
    }

    try {
      update releaseMap.values();
    } catch(Exception e) {
      System.debug(e.getMessage());
    }
}