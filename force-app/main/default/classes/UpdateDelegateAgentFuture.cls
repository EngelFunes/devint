public class UpdateDelegateAgentFuture {
	@future
    public static void updateDelegateAgentOnCase(Set<Id> supportRequestIds, Id currentUserId, String currentUserEmail, String agentType){
	    List<Case> CaseListupdate = new List<Case>();
        id UserId = UserInfo.getUserId();
        user currentUser = [
            SELECT id, profileid, profile.name
            FROM user
            WHERE id = :UserId
        ];
        for(Case supportRequest: [Select id,FSA_Delegated_Agent__c,Delegated_Agent_Email__c,FSA_Delegated_Agent__r.email,Managing_Agent__c,Managing_Agent_Email__c,Managing_Agent__r.email from case where id =: supportRequestIds]){
                if(agentType == 'Delegate Agent'){
                    supportRequest.FSA_Delegated_Agent__c = currentUserId;
                    supportRequest.Delegated_Agent_Email__c = currentUserEmail;
                    CaseListupdate.add(supportRequest);
                }
                if(currentUser.Profile.Name == System.label.User_Profile_Name_MAUser){
                    supportRequest.Managing_Agent__c = currentUserId;
                    supportRequest.Managing_Agent_Email__c = currentUserEmail;
                    CaseListupdate.add(supportRequest);
                }
            }
            update CaseListupdate;       
    }
}