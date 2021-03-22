@isTest
public class FilesManagerControllerTest{
    @isTest
    public static void testSaveFileToSave(){
        Case supportRequest = TestDataFactory.supportRequestRecord(System.label.Support_Request_Status_In_Progress );
        Blob file = Blob.valueOf('Test Content'); 
        ContentVersion contentVersion = new ContentVersion( FirstPublishLocationId = supportRequest.id, Title = 'test', PathOnClient = 'test.jpg',
                                                             VersionData = file, IsMajorVersion = true);

        test.startTest();
			ContentVersion contentVersionRecord = FilesManagerController.saveFile(contentVersion.FirstPublishLocationId, contentVersion.Title, file.toString());
        test.stopTest();
        Boolean hasRecord;
        if(contentVersionRecord != null){
            hasRecord = true;
        }
        else{
			hasRecord = false;
        }
		System.assertEquals(true, hasRecord, 'Should have record');
        
    }
    
    @isTest
    public static void testSaveFileToCheckTheList(){
        Case supportRequest = TestDataFactory.supportRequestRecord(System.label.Support_Request_Status_In_Progress );
        blob file = Blob.valueOf('Test Content'); 
        ContentVersion contentVersion = new ContentVersion( FirstPublishLocationId = supportRequest.id, Title = 'test', PathOnClient = 'test.jpg',
                                                             VersionData = file, IsMajorVersion = true);

        test.startTest();
			insert contentVersion;
			ContentVersion contentVersionRecord = FilesManagerController.saveFile(contentVersion.FirstPublishLocationId, contentVersion.Title, file.toString());
        test.stopTest();
        
        Boolean hasRecord;
        if(contentVersionRecord == null){
            hasRecord = true;
        }
        else{
			hasRecord = false;
        }
		System.assertEquals(true, hasRecord, 'Should have record');
    }
    
    @isTest
    public static void testReleatedFiles(){
        Case supportRequest = TestDataFactory.supportRequestRecord(System.label.Support_Request_Status_In_Progress );
        blob file = Blob.valueOf('Test Content'); 
        ContentVersion contentVersion = new ContentVersion( FirstPublishLocationId = supportRequest.id, Title = 'test', PathOnClient = 'test.jpg',
                                                             VersionData = file, IsMajorVersion = true);
		
        test.startTest();
            insert contentVersion;
			List<contentversion> contentVersionList = FilesManagerController.releatedFiles(contentVersion.FirstPublishLocationId);
        test.stopTest();
        
		System.assertEquals(1, contentVersionList.size(), 'Should return 1 record');
    }
    
    @isTest
    public static void testReleatedFilesToCheckListWithNull(){
        Case supportRequest = TestDataFactory.supportRequestRecord(System.label.Support_Request_Status_In_Progress );
        blob file = Blob.valueOf('Test Content'); 
        ContentVersion contentVersion = new ContentVersion( FirstPublishLocationId = supportRequest.id, Title = 'test', PathOnClient = 'test.jpg',
                                                             VersionData = file, IsMajorVersion = true);

        system.debug(contentVersion);
        test.startTest();
			List<contentversion> contentVersionList = FilesManagerController.releatedFiles(contentVersion.FirstPublishLocationId);
        test.stopTest();
		
        system.debug(contentVersionList);

		System.assertEquals(null, contentVersionList, 'Should return null');
    }
        
    @isTest
    public static void testDeleteDocuments(){
        Case supportRequest = TestDataFactory.supportRequestRecord(System.label.Support_Request_Status_In_Progress );
        blob file = Blob.valueOf('Test Content'); 
        ContentVersion contentVersion = new ContentVersion( FirstPublishLocationId = supportRequest.id, Title = 'test', PathOnClient = 'test.jpg',
                                                             VersionData = file, IsMajorVersion = true);
        insert contentVersion;
        Id contentDocumentId = [SELECT Id, ContentDocumentId  
                                FROM ContentVersion 
                                WHERE Id =: contentVersion.Id].ContentDocumentId;
        List<Id> contentDocumentIdList = new List<Id>();
		contentDocumentIdList.add(contentDocumentId);
        system.debug(contentDocumentIdList);
        
        test.startTest();
        	String result = FilesManagerController.deleteDocuments(contentDocumentIdList);
        test.stopTest();
        
        System.assertEquals('SUCCESS', result, 'Should return SUCCESS');
    }
}