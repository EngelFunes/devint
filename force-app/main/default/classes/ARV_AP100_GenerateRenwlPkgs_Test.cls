/*****************************************************************************************
Class Name   : ARV_AP100_GenerateRenwlPkgs_Test 
Date Created : 18-Jun-2020
Created By   : IDC Offshore
Description  : This class is used for ARV_AP100_GenerateRenwlPkgs_Test
******************************************************************************************/
@isTest
public class ARV_AP100_GenerateRenwlPkgs_Test {
	private static final string PROFILENAME='BCBSM Agent';
    private static final string PROFILENAME1='System Administrator';
    private static final string IDS = 'id';
    private static final string NAME='AP95LastName';
    private static final string NAME1='InternalUSer';
    private static final string USERNAME='bcbsm1@bcbsm.com';
    private static string prdType='CongaGroup';
	/**************  
	Method name : testDataSetup
	Params     : NA
	Return Type : testmethod
	Description :  testDataSetup() method 
	*************/     
    @testSetup static void testDataSetup() {
        Account acc= ARV_AP05_TestDataCreation.accRec();
        acc.Account_Status__c='Active';
        acc.ARV_Renewal_Account_Type__c='SG';
        database.insert(acc); 
        
        contact con= ARV_AP05_TestDataCreation.ContactRec(acc.Id);
        database.insert(con);
        User user2=ARV_AP05_TestDataCreation.UsrRec(PROFILENAME1);
        user2.LastName = NAME;
        database.insert(User2,true);
        
    }
    /**************  
	Method name : internalUserTest
	Params     : NA
	Return Type : testmethod
	Description :  internalUserTest() method 
	*************/ 
    private static testmethod void internalUserTest(){
        Account accnt= ARV_AP05_TestDataCreation.accRec();
        accnt.Account_Status__c='Active';
        accnt.ARV_Renewal_Account_Type__c='SG';
        database.insert(accnt); 
        
        contract cont= ARV_AP05_TestDataCreation.createContractRec(accnt.Id);
        cont.vlocity_ins__ExpiredContractId__c =cont.Id;
        cont.ARV_CF_CNTRCT_CarrierCodes__c ='BCBSM & BCN';
        cont.ARV_Requested_Effective_Date__c=system.today();
        Id parentCntrctId=cont.vlocity_ins__ExpiredContractId__c;
        database.insert(cont);
        
        user usr = ARV_AP05_TestDataCreation.UsrRec(PROFILENAME1);
        usr.LastName = NAME1;
        usr.Username=USERNAME;
        database.insert(usr,true);
        
        Product2 prd = ARV_AP05_TestDataCreation.productRec2();
        prd.name='jkh';
        prd.ProductCode='jhh';
        prd.vlocity_ins__SubType__c='PPO';
        database.insert(prd);
        
        vlocity_ins__ContractLineItem__c planattr = new vlocity_ins__ContractLineItem__c();
        planattr.Name ='dfsadf';
        planattr.vlocity_ins__ContractId__c= cont.id;
        database.insert(planattr);
        
                
        Package__c pck1=ARV_AP05_TestDataCreation.packageRec(cont.Id);
        pck1.ARV_Medical_Plan__c = planattr.id;
        //pck1.ARV_Medical_Plan__r.vlocity_ins__ProductSubType__c='PPO';
        pck1.ARV_Dental_Plan__c = planattr.id;
        pck1.ARV_Vision_Plan__c = planattr.id;
        database.insert(pck1);
        
		ARV_RenewalContractStaticDocs_Config__c arn = new ARV_RenewalContractStaticDocs_Config__c();
        arn.Name = 'sddsc';
        arn.ARV_Package_Type__c='Agent';
        arn.ARV_Product_Type__c='PPO';
        arn.ARV_Start_Date__c=system.today();
        arn.ARV_End_Date__c=system.today();
        database.insert(arn);
        documentsCreation('Marketing',arn.id);
		/*documentsCreation('Small Group Reimbursement Policy Document',arn.id);
        documentsCreation('Appendix A',arn.id);
        documentsCreation('Appendix B',arn.id);
		documentsCreation('Copyright',arn.id);
		documentsCreation('Thank You Letter',arn.id);
		documentsCreation('Ped Dental Reminder',arn.id);
        documentsCreation('Glossary',arn.id);*/

        List<ARV_RenewalContractStaticDocs_Config__c> docId =[ select ID from ARV_RenewalContractStaticDocs_Config__c where (ARV_Product_Type__c='PPO' or ARV_Product_Type__c='') and (ARV_Package_Type__c='Both' or ARV_Package_Type__c='Agent')]; 
        system.runAs(usr){
            PageReference pageRef = Page.ARV_VF06_RateGridPage;
            pageRef.getParameters().put(IDS, String.valueOf(cont.Id));
           
            Test.setCurrentPage(pageRef);
            ARV_AP100_GenerateRenwlPkgs grpa = new ARV_AP100_GenerateRenwlPkgs(cont.Id,'CongaAgent');
            test.startTest();

            ID jobID1 =System.enqueueJob(grpa);
           
            test.stopTest();
        }
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
	Method name : testCongaGroupScenario
	Params     : NA
	Return Type : testmethod
	Description :  testCongaGroupScenario() to cover ARV_AP101_GenerateRenwlPkgsForGroup class for Conga Group 
	*************/ 
    private static testmethod void testCongaGroupScenario(){
        Account accnt= ARV_AP05_TestDataCreation.accRec();
        accnt.Account_Status__c='Active';
        accnt.ARV_Renewal_Account_Type__c='SG';
        database.insert(accnt); 
        
        contract cont= ARV_AP05_TestDataCreation.createContractRec(accnt.Id);
        cont.vlocity_ins__ExpiredContractId__c =cont.Id;
        cont.ARV_CF_CNTRCT_CarrierCodes__c ='BCBSM';
        Id parentCntrctId=cont.vlocity_ins__ExpiredContractId__c;
        database.insert(cont);
        
        user usr = ARV_AP05_TestDataCreation.UsrRec(PROFILENAME1);
        usr.LastName = NAME1;
        usr.Username=USERNAME;
        database.insert(usr,true);
        ARV_RenewalContractStaticDocs_Config__c arn = new ARV_RenewalContractStaticDocs_Config__c();
        arn.Name = 'sddsc';
        arn.ARV_Package_Type__c='Group';
        arn.ARV_Product_Type__c='PPO';
        arn.ARV_Start_Date__c=system.today();
        arn.ARV_End_Date__c=system.today();
        database.insert(arn);
        documentsCreation('Marketing',arn.id);
		/*documentsCreation('Small Group Reimbursement Policy Document',arn.id);
        documentsCreation('Appendix A',arn.id);
        documentsCreation('Appendix B',arn.id);
		documentsCreation('Copyright',arn.id);
		documentsCreation('Thank You Letter',arn.id);
		documentsCreation('Ped Dental Reminder',arn.id);
        documentsCreation('Glossary',arn.id);*/

        List<ARV_RenewalContractStaticDocs_Config__c> docId =[ select ID from ARV_RenewalContractStaticDocs_Config__c where (ARV_Product_Type__c='PPO' or ARV_Product_Type__c='') and (ARV_Package_Type__c='Both' or ARV_Package_Type__c='Group')]; 
		system.debug('**********docid'+docId);
        system.runAs(usr){
			ARV_AP101_GenerateRenwlPkgsForGroup grpa = new ARV_AP101_GenerateRenwlPkgsForGroup(cont.Id,'CongaGroup','BCBSM & BCN',cont.ARV_Requested_Effective_Date__c);
			test.startTest();
			ID jobID1 =System.enqueueJob(grpa);
			test.stopTest();
		}
    }
}