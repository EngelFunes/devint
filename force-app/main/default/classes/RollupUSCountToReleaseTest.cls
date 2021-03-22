@isTest
private class RollupUSCountToReleaseTest {
    static testMethod void testUSCount1(){
        Release__c newRelease = new Release__c();
        newRelease.Name = 'Testing';
        insert newRelease;
 
        User_Story__c newStory = new User_Story__c();
        newStory.Release__c = newRelease.Id;
        newStory.Name = 'Test Story';
        newStory.Business_Requester__c = 'Test';
        newStory.Testing_Required__c = 'SIT Only';
        
        User_Story__c approvedStory = new User_Story__c();
        approvedStory.Release__c = newRelease.Id;
        approvedStory.Name = 'Approved Story';
        approvedStory.Business_Requester__c = 'Test';
        approvedStory.Testing_Required__c = 'SIT Only';
        approvedStory.Approvals_Completed__c = true;
        
        Test.startTest();
            insert newStory;
        	insert approvedStory;
        Test.stopTest();  
        
        Release__c releaseAfterInsert = [Select Total_User_Stories__c, Approved_User_Stories__c from Release__c where Id= :newRelease.Id];

        System.assertEquals(2, releaseAfterInsert.Total_User_Stories__c);
        System.assertEquals(1, releaseAfterInsert.Approved_User_Stories__c);
    }
    static testMethod void testUSCount2(){
        Release__c newRelease = new Release__c();
        newRelease.Name = 'Test1';
        insert newRelease;
        
        Release__c secondRelease = new Release__c();
        newRelease.Name = 'Test2';
        insert secondRelease;
 
        User_Story__c newStory = new User_Story__c();
        newStory.Release__c = newRelease.Id;
        newStory.Name = 'Test Story';
        newStory.Business_Requester__c = 'Test';
        newStory.Testing_Required__c = 'SIT Only';
        insert newStory;
        
        User_Story__c approvedStory = new User_Story__c();
        approvedStory.Release__c = newRelease.Id;
        approvedStory.Name = 'Approved Story';
        approvedStory.Business_Requester__c = 'Test';
        approvedStory.Testing_Required__c = 'UAT Only';
        approvedStory.Approvals_Completed__c = true;
        insert approvedStory;

        newStory.Release__c = secondRelease.Id;
        update newStory;
        
        Release__c release1After = [Select Total_User_Stories__c, Approved_User_Stories__c from Release__c where Id= :newRelease.Id];
        Release__c release2After = [Select Total_User_Stories__c, Approved_User_Stories__c from Release__c where Id= :secondRelease.Id];

        System.assertEquals(1, release1After.Total_User_Stories__c);
        System.assertEquals(1, release1After.Approved_User_Stories__c);

        System.assertEquals(1, release2After.Total_User_Stories__c);
        System.assertEquals(0, release2After.Approved_User_Stories__c);           
    }
}