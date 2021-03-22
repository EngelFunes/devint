public class UpdateDelegatedAgent {
    public static void  updateDelegatedAgentOnCase(List<Case> supportRequestLst){
        user currentUser = [SELECT Id,Delegate_User__c 
                            FROM user 
                            WHERE id =: UserInfo.getUserId()];
        
        for(Case supportRequest: supportRequestLst){
            if(currentUser.Delegate_User__c){
                supportRequest.FSA_Delegated_Agent__c = currentUser.Id;
            }
        }
    }
}