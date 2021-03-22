@isTest
public class UnlockUserStoryRecordTest {
    static testMethod void testUSUnlock(){
        Release__c newRelease = new Release__c();
        newRelease.Name = 'Testing';
        insert newRelease;
        
		//insert new story        
        User_Story__c newStory = new User_Story__c();
        newStory.Name = 'Test';
        newStory.Release__c = newRelease.Id;
        newStory.Business_Requester__c = 'Test';
        newStory.Testing_Required__c = 'SIT Only';
        
        insert newStory;
        
        //update story with requirements for trigger
        newStory.Status__c = 'Approved to Deploy';
        newStory.Approvals_Completed__c = true;
        Approval.Lock(newStory);
        
        update newStory;

        System.assert(Approval.isLocked(newStory) == false);
    }
}