@isTest
public class FeedItemTriggerHandlerTest {
    @isTest
    public static void testsetRequestNumberAccountDetailsForTextPost(){
        User u  = [SELECT Id, name FROM user WHERE Id =:UserInfo.getUserId()];
        User aSRUserRecord;
        Case supportRequest;
        FeedItem feedItemPostForSupportRequest;
        System.runAs(u){
            aSRUserRecord = TestDataFactory.userRecord(System.label.User_Profile_Name_Support, 'test@test.com.bcbsm');
            supportRequest = TestDataFactory.supportRequestRecord(System.label.Support_Request_Status_In_Progress );
            feedItemPostForSupportRequest = new FeedItem( ParentId = supportRequest.Id, Type = 'TextPost', 
                                                                  Body = '<p>test</p>', IsRichText=true, Visibility='InternalUsers');
        }
        
        test.startTest();
        try{
            System.runAs(aSRUserRecord){
                insert feedItemPostForSupportRequest;
            }
        }
        catch(Exception e){}
        test.stopTest();
        System.assert( !ApexPages.hasMessages(), 'No exception to be thrown for updating Text Post' );
        
    }
    @isTest
    public static void testupdateVisibilityForSupportRequest(){
        User u  = [SELECT Id, name FROM user WHERE Id =:UserInfo.getUserId()];
        List<FeedItem> fiList  = new List<FeedItem>();
        User aSRUserRecord;
        Case supportRequest;
        FeedItem feedItemPostForSupportRequest2;
        FeedItem feedItemPostForSupportRequest;
        System.runAs(u){
            aSRUserRecord = TestDataFactory.userRecord(System.label.User_Profile_Name_Support, 'test@test.com.bcbsm');
            supportRequest = TestDataFactory.supportRequestRecord('In Progress');
            //Insert supportRequest;
            feedItemPostForSupportRequest2 = new FeedItem( ParentId = supportRequest.Id, Type = 'TextPost', 
                                                                   Body = '<p>testing</p>', IsRichText=true, Visibility='InternalUsers');
            feedItemPostForSupportRequest = new FeedItem( ParentId = supportRequest.Id, Type = 'TextPost', 
                                                                  Body = '<p>test</p>', IsRichText=true, Visibility='InternalUsers');
        }
        
       
        test.startTest();
        try{
            System.runAs(aSRUserRecord){
                set<Id> fiId  = new Set<Id>();
                 fiList.add(feedItemPostForSupportRequest);
                fiList.add(feedItemPostForSupportRequest2);
                insert fiList;
               
                for(feeditem f : filist){
                    fiId.add(f.id);
                }
                System.debug(fiId);
               List<feedItem> fi = [select Id,ParentId,Type,Body,IsRichText,Visibility from feedItem where Id In : fiId];
               System.debug(fi);
                FeedItemTriggerHandler.noResponseEmailChecktoAgent(fi);
                FeedItemTriggerHandler.updateVisibilityForSupportRequest(fi);
           }
        }
        catch(Exception e){
            System.debug(e.getMessage()+e.getLineNumber());
        }
        test.stopTest();
        //System.assert( !ApexPages.hasMessages(), 'No exception to be thrown for updating Text Post' );
        
    }
    @isTest
    public static void testsetRequestNumberAccountDetailsForQuestionPost(){
        User u  = [SELECT Id, name FROM user WHERE Id =:UserInfo.getUserId()];
        User aSRUserRecord;
        Case supportRequest;
        FeedItem feedItemPostForSupportRequest;
        System.runAs(u){
         aSRUserRecord = TestDataFactory.userRecord(System.label.User_Profile_Name_Support, 'test@test.com.bcbsm');
        supportRequest = TestDataFactory.supportRequestRecord(System.label.Support_Request_Status_In_Progress );
        feedItemPostForSupportRequest = new FeedItem( ParentId = supportRequest.Id, Type = 'QuestionPost', Title = 'Test',
                                                              Body = 'test', IsRichText=false, Visibility='InternalUsers');
        }
       
        test.startTest();
        try{
            System.runAs(aSRUserRecord){
                insert feedItemPostForSupportRequest;
            }
        }
        catch(Exception e){}
        test.stopTest();
        System.assert( !ApexPages.hasMessages(), 'No exception to be thrown for updating question Post' );
        
    }
    @isTest
    public static void testPostChatterBeforeInsertAndUpdate(){
    User u  = [SELECT Id, name FROM user WHERE Id =:UserInfo.getUserId()];
    User aSRUserRecord;
    FeedItem feedItemPostForSupportRequest;
        System.runAs(u){
            aSRUserRecord = TestDataFactory.userRecord(System.label.User_Profile_Name_Support, 'test@test.com.bcbsm');
        Case supportRequest = TestDataFactory.supportRequestRecord('New');//System.label.Support_Request_Status_New
       feedItemPostForSupportRequest = new FeedItem( ParentId = supportRequest.Id, Type = 'QuestionPost', Title = 'Test',
                                                              Body = 'test', IsRichText=false, Visibility='InternalUsers');
        }
        
        test.startTest();
        try{
            System.runAs(aSRUserRecord){
                insert feedItemPostForSupportRequest;
            }
        }
        catch(Exception e){}
        test.stopTest();
        System.assert( ApexPages.hasMessages(), 'Exception to be thrown for updating question Post' );
        System.assertEquals('You cannot Post Chatter when the support request status is New OR Closed ', ApexPages.getMessages()[0].getDetail(),
            'Appropriate duplicate error message should be thrown');
    }
    @isTest
    public static void testsetRequestNumberAccountDetailsForNonSupport(){
        User u  = [SELECT Id, name FROM user WHERE Id =:UserInfo.getUserId()];
        User userRecord;
        Case supportRequest;
        FeedItem feedItemPostForSupportRequest;
        System.runAs(u){
         userRecord = TestDataFactory.userRecord(System.label.User_Profile_Name_Support , 'admin@test.com.bcbsm');
        supportRequest = TestDataFactory.supportRequestRecord(System.label.Support_Request_Status_In_Progress );
 
        feedItemPostForSupportRequest = new FeedItem( ParentId = supportRequest.Id, Type = 'TextPost', 
                                                              Body = '<p>test</p>', IsRichText=true, Visibility='InternalUsers');
        }
       
        test.startTest();
        try{
            System.runAs(userRecord){
                insert feedItemPostForSupportRequest;
            }
        }
        catch(Exception e){}
        test.stopTest();
        //System.assert( ApexPages.hasMessages(), 'An exception to be thrown and added to the page' );
       // System.assertEquals(System.Label.Feed_Item_Error_Message_Non_Support_User, ApexPages.getMessages()[0].getDetail(),
           // 'Appropriate duplicate error message should be thrown');
    }
}