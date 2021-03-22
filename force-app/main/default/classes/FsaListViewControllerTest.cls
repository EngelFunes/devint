@isTest
public class FsaListViewControllerTest {

    @isTest
    static void testGetCaseList(){
		Case supportRequest = TestDataFactory.supportRequestRecord(System.label.Support_Request_Status_In_Progress );
		String listName = 'AllSupportRequest';
		List<FsaListViewController.CaseDto> caseDtos = new List<FsaListViewController.CaseDto>();
        
        Test.startTest();
        	caseDtos = FsaListViewController.getCaseList(listName);
        Test.stopTest();
        
        System.assertEquals(1, caseDtos.size(), 'Should return 1 record');
    }
    
    @isTest
    static void testGetCaseListForMySupportRequest()
    {
        Case supportRequest = TestDataFactory.supportRequestRecord(System.label.Support_Request_Status_In_Progress );
		String listName = 'MySupportRequest';
		List<FsaListViewController.CaseDto> caseDtos = new List<FsaListViewController.CaseDto>();
        
        Test.startTest();
        	caseDtos = FsaListViewController.getCaseList(listName);
        Test.stopTest();
        
        System.assertEquals(1, caseDtos.size(), 'Should return 1 record');
    }

    @isTest
    static void testGetCaseListForOpenSupportRequest()
    {
        Case supportRequest = TestDataFactory.supportRequestRecord(System.label.Suppport_Request_Status_New);
		String listName = 'OpenSupportRequest';
		List<FsaListViewController.CaseDto> caseDtos = new List<FsaListViewController.CaseDto>();
        
        Test.startTest();
        	caseDtos = FsaListViewController.getCaseList(listName);
        Test.stopTest();
        
        System.assertEquals(1, caseDtos.size(), 'Should return 1 record');
    }
    
    @isTest
    static void testGetCaseDtoList()
    {
        Case supportRequest = TestDataFactory.supportRequestRecord(System.label.Support_Request_Status_In_Progress );
 
        List<FsaListViewController.CaseDto> caseDtos = new List<FsaListViewController.CaseDto>();

        Test.startTest();
        	caseDtos = FsaListViewController.getCaseDtoList();
        Test.stopTest();
        
        System.assertEquals(1, caseDtos.size(), 'Should return 1 record');
    }
    
    @isTest
    static void testCaseDto()
    {
        Case supportRequest = TestDataFactory.supportRequestRecord(System.label.Support_Request_Status_Waiting_On_Internal_Response );
 
        List<FsaListViewController.CaseDto> caseDtos = new List<FsaListViewController.CaseDto>();

        Test.startTest();
        	caseDtos = FsaListViewController.getCaseDtoList();
        Test.stopTest();
        
        System.assertEquals(1, caseDtos.size(), 'Should return 1 record');
    }
    
}