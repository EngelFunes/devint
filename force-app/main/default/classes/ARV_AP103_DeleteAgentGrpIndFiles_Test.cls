@isTest(seealldata=false)
/**
*Class Name   : ARV_AP103_DeleteAgentGrpIndFiles_Test
*Date Created : 11-August-2020
*Created By   : IDC Offshore
*Description  : This class is used for testing ARV_AP103_DeleteAgentGrpIndFilesConga.
**/
public without sharing class ARV_AP103_DeleteAgentGrpIndFiles_Test {
	private static final string PROFILENAME1='System Administrator';
    private static final string IDS = 'id';
    private static final string USERNAME='bcbsm1@bcbsm.com';
    private static final string NAME1='AP96LastName';    

    
    /**************************************************************************************************
    @Description: testDataSetup() method 
    @Name : testDataSetup1
    @Param : N/A
    @Return : void
    @throws Exception : N/A;
	***************************************************************************************************/
    @testSetup static void testDataSetup() { 
        Account acc= ARV_AP05_TestDataCreation.accRec();
        acc.Account_Status__c='Active';
        acc.ARV_Renewal_Account_Type__c='SG';
        acc.GA_Opportunity_Renewal_Date__c=system.today();
        database.insert(acc);
        
        contract cont= ARV_AP05_TestDataCreation.createContractRec(acc.Id);        
        database.insert(cont);       
        
        GA_Group_Segment__c gseg1= ARV_AP05_TestDataCreation.groupSegmentRec(acc.Id,cont.Id);
        database.insert(gseg1);
        
        Package__c pck1=ARV_AP05_TestDataCreation.packageRec(cont.Id);
        database.insert(pck1);
        
        user usr = ARV_AP05_TestDataCreation.UsrRec(PROFILENAME1);
        usr.LastName = NAME1;
        usr.Username=USERNAME;
        database.insert(usr,true);
    }
    /**************  
	Method name : documentsCreation
	Params     : NA
	Return Type : testmethod
	Description :  documentsCreation() to create documents 
	*************/ 
	private static  void documentsCreation(String title,Id lndentityId){
		ContentVersion cv = new ContentVersion();
        cv.Title = title;        
        cv.PathOnClient = 'TestDocument.pdf';
        cv.VersionData = Blob.valueOf(title);
        cv.IsMajorVersion = true;
        database.insert(cv);
		ContentVersion contentVersion_2 = [SELECT Id, Title, ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id LIMIT 1];
		ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.ContentDocumentId = contentVersion_2.ContentDocumentId;
        cdl.LinkedEntityId = lndentityId;   
        database.insert(cdl);
	}

    /**************  
    Method name : internalUserTest
    Params     : NA
    Return Type : testmethod
    Description :  internalUserTest() method 
    *************/ 
    private static testmethod void contractDataTest(){
        user usr1 = [SELECT Id from User where LastName =: NAME1 limit 1];
        system.runAs(usr1){
        Account acc= ARV_AP05_TestDataCreation.accRec();       
        database.insert(acc);
        Id standardPriceBookRecId=Test.getStandardPricebookId();

        pricebook2 pb2=ARV_AP05_TestDataCreation.priceBookRec();
        database.insert(pb2);
        Opportunity opp= ARV_AP05_TestDataCreation.opportunityRec(acc.Id,standardPriceBookRecId);
        database.insert(opp);     
		Quote quot = ARV_AP05_TestDataCreation.quoteRec1(opp.Id,standardPriceBookRecId,usr1.Id);
        database.insert(quot);
        contract cont= ARV_AP05_TestDataCreation.createContractRec(acc.Id);
        cont.vlocity_ins__QuoteId__c=quot.id;
        database.insert(cont);
        try{
           documentsCreation('CongaAgentDocument',cont.id);
		   documentsCreation('CongaGroupDocument',cont.id);
            ARV_AP103_DeleteAgentGrpIndFilesConga renpkg = new ARV_AP103_DeleteAgentGrpIndFilesConga();
			ARV_AP103_DeleteAgentGrpIndFilesConga.RenewalPackages rpkg = new ARV_AP103_DeleteAgentGrpIndFilesConga.RenewalPackages();
			rpkg.contractId=cont.Id;
			rpkg.congaAgent='yes';
			rpkg.congaGroup='yes';
            test.startTest();
            List<ARV_AP103_DeleteAgentGrpIndFilesConga.RenewalPackages> rnwPkgs = new List<ARV_AP103_DeleteAgentGrpIndFilesConga.RenewalPackages>();
            rnwPkgs.add(rpkg);
			ARV_AP103_DeleteAgentGrpIndFilesConga.deleteRenwlPkgFiles(rnwPkgs);
            test.stopTest();
            //system.assertNotEquals(activepck,pendpck);
            }catch(Exception e){
                system.debug('***err occured at '+e.getLineNumber()+'::::'+e.getMessage());
            }
        }
    }
}