@isTest
public class ASC_DocStarSubmitAPI_Test {
    @isTest 
    static void sentDocumentBaseASC() {
        Test.setMock( 
            HttpCalloutMock.class, 
            new ASC_DocStarSubmitAPI_MockHttpResponse() 
        );
        
        Contract con = creationDataBase(0);
        
        Test.startTest();
        Map<Id, Contract > mapContractsPosting = new Map<Id, Contract>();
        mapContractsPosting.put( con.id, con );
        ASC_DocStarSubmitAPI.sentDocuments( mapContractsPosting );
        System.assert(true);

        Test.stopTest();
    }
    @isTest 
    static void sentDocumentContractAmendment() {
        Test.setMock( 
            HttpCalloutMock.class, 
            new ASC_DocStarSubmitAPI_MockHttpResponse() 
        );
        
        Contract con = creationDataBase(1);
        
        Test.startTest();
        Map<Id, Contract > mapContractsPosting = new Map<Id, Contract>();
        mapContractsPosting.put( con.id, con );
        ASC_DocStarSubmitAPI.sentDocuments( mapContractsPosting );
        System.assert(true);

        Test.stopTest();
    }
    
    public static Contract creationDataBase(Integer numTypeDoc){
        Map<Id,Contract> mapContractsPosting = new Map<Id,Contract>();
        
        Account acc = new Account( CID__c = '1', Name = '1' );
        Insert acc;
        
        Contract con = new Contract( AccountId = acc.id );
        Insert con;

        ASC_Contractual_Document__c contractualDocument = new ASC_Contractual_Document__c(
            ASC_Document_Type__c = 'Group Signed Package', 
            ASC_Contract__C = con.Id 
        );
        Insert contractualDocument;


        List<String> pickListValuesList= new List<String>();
		Schema.DescribeFieldResult fieldResult = ASC_Contractual_Document__c.ASC_Document_Type__c.getDescribe();
		List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
		for( Schema.PicklistEntry pickListVal : ple){
			pickListValuesList.add(pickListVal.getLabel());
        } 
        
        ContentVersion contentVersionInsert = new ContentVersion(
            Title = pickListValuesList[numTypeDoc] + '.pdf',
            PathOnClient = pickListValuesList[numTypeDoc] + '.pdf',
            VersionData = Blob.valueOf('Test Content Data'),
            IsMajorVersion = true
        );
        Insert contentVersionInsert;
        
        ContentVersion contentVersionSelect = [SELECT Id, Title, ContentDocumentId FROM ContentVersion WHERE Id = :contentVersionInsert.Id LIMIT 1];
        
        ContentDocumentLink contentDocumentLinkSelect = new ContentDocumentLink( 
            LinkedEntityId = contractualDocument.Id, 
            ContentDocumentId = contentVersionSelect.ContentDocumentId 
        );
        Insert contentDocumentLinkSelect;

        ContentDocumentLink contentDocumentLinkSelectCD = new ContentDocumentLink( 
            LinkedEntityId = con.Id, 
            ContentDocumentId = contentVersionSelect.ContentDocumentId 
        );
        Insert contentDocumentLinkSelectCD;

        Return con;
    }    
}