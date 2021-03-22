@isTest
public class RequestsForCRPF2FTestMethod {
    //Method for creation of Rquest record 
    	public static Request__c createRequest(User_Story__c userstory) {
            Request__c requestObj = new Request__c(Request_Title__c = 'Test',GA_Build_Type__c = 'Integration', User_Story__c = userstory.Id);
            return requestObj;
    	}
        
        //Method for creation of UserStory record
        public static User_Story__c createUserStory() {
            User_Story__c userstory = new User_Story__c(Name = 'Test');
            return userstory;
        }
    
    	//Method for creation of UserStory record linked to an Request
        public static User_Story__c createUserStory1() {
            User_Story__c userstory1 = new User_Story__c(Name = 'Test1');
            return userstory1;
        }
        
         public static testMethod void testRequestsForCRPF2F(){
             Release__c rel = new Release__c();
             rel.Name = 'Test Release ';
             rel.Release__c = 24;
             rel.Id = null;
             rel.Plan_Start_Date__c = System.today();
             rel.Release_Planned_End_Date__c= System.today() + 10;
             rel.Status__c = 'Red';
             rel.Description__c = 'Test description ';
             rel.Status_Update__c = 'Test Comments';
             insert rel;
             
             User_Story__c userstory = createUserStory();
             userstory.Release__c=rel.Id;
             userstory.Business_Requester__c ='test';
             userstory.Testing_Required__c ='SIT Only';
             insert userstory;
             
             User_Story__c userstory1 = createUserStory1();
             userstory1.Release__c=rel.Id;
             userstory1.Business_Requester__c ='test';
             userstory1.Testing_Required__c ='SIT Only';
             insert userstory1;
             
             List<Request__c> requestList = new List<Request__c>();
        	 requestList.add(createRequest(userstory));
        	 requestList.add(createRequest(userstory1));
        	 insert requestList;
             
             
             //set pageReference 
        PageReference testPageRef = Page.View_Requests_v9;
        Test.setCurrentPage(testPageRef);
        
        test.startTest();
            ApexPages.StandardSetController standardsetController = new ApexPages.StandardSetController(requestList);
            standardsetController.setSelected(requestList);
            RequestsForCRPF2F showUserStories = new RequestsForCRPF2F(standardsetController); 
            showUserStories.GoToRequestsTab();
            showUserStories.getStories();
        test.stopTest();
         }
}