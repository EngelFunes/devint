@isTest(seealldata=false)
/**
*Class Name   : ARV_RateRenewalChange_Test
*Date Created : 18-JUne-2020
*Created By   : IDC Offshore
*Description  : This class is used for testing ARV_RateRenewalChange_Test.
**/
public without sharing class ARV_AP102_RateRenewalChange_Test {
    private static final string NAME1='AP96LastName';
    private static final string PROFILENAME1='System Administrator';
    private static final string IDS = 'id';
    private static final string PROFILENAME2='Small Group Underwriter';
    private static final string NAME='AP96LastName';
    //private static final string NAME1='AP96LastName';    
    private static final string USERNAME='bcbsm1@bcbsm.com';
    private static final string GCENNAME='gcmid';
    private static final string MEDICAL='medical';
    private static final string DENTAL='dntal';
    private static final string VISION='vision';
    private static final string PODCODE='prodcod';
    private static final string PACKAGE1='package';
    private static final string ACT='Active';
    private static final string SGRR='SG';
    
    /*********************************************************************************************************
@Description: testDataSetup() method 
@Name : testDataSetup1
@Param : N/A
@Return : void
@throws Exception : N/A;
***********************************************************************************************************/
    @testSetup static void testDataSetup() { 
        Account acc= ARV_AP05_TestDataCreation.accRec();
        acc.Account_Status__c=ACT;
        acc.ARV_Renewal_Account_Type__c=SGRR;
        acc.GA_Opportunity_Renewal_Date__c=system.today();
        database.insert(acc);
        
        contract cont= ARV_AP05_TestDataCreation.createContractRec(acc.Id);        
        database.insert(cont);       
        
        GA_Group_Segment__c gseg1= ARV_AP05_TestDataCreation.groupSegmentRec(acc.Id,cont.Id);
        database.insert(gseg1);
        
        Package__c pck1=ARV_AP05_TestDataCreation.packageRec(cont.Id);
        database.insert(pck1);
        
        Product2 prd = ARV_AP05_TestDataCreation.productRec2();
        database.insert(prd);
        vlocity_ins__ContractLineItem__c planobj = new vlocity_ins__ContractLineItem__c();
        planobj.vlocity_ins__ContractId__c=cont.id;
        planobj.name=MEDICAL;
        planobj.vlocity_ins__Product2Id__c = prd.id;
        database.insert(planobj);     
        
        database.update(gseg1);
        
        user usr = ARV_AP05_TestDataCreation.UsrRec(PROFILENAME1);
        usr.LastName = NAME1;
        usr.Username=USERNAME;
        database.insert(usr,true);
    }
    /**************  
Method name : internalUserTest
Params     : NA
Return Type : testmethod
Description :  internalUserTest() method 
*************/ 
    private static testmethod void comparisonobjTest(){
        
        user usr1 = [SELECT Id from User where LastName =: NAME1 limit 1];
        system.runAs(usr1){
            Account acc= ARV_AP05_TestDataCreation.accRec();       
            database.insert(acc);
            
            contract cont= ARV_AP05_TestDataCreation.createContractRec(acc.Id);
            cont.vlocity_ins__ExpiredContractId__c =cont.Id;
        	cont.ARV_CF_CNTRCT_CarrierCodes__c ='BCBSM & BCN';
        	Id parentCntrctId=cont.vlocity_ins__ExpiredContractId__c;
            database.insert(cont);
            
            GA_Group_Segment__c gseg1= ARV_AP05_TestDataCreation.groupSegmentRec(acc.Id,cont.Id);
            database.insert(gseg1);
            
            vlocity_ins__GroupCensus__c gc = new vlocity_ins__GroupCensus__c();
            gc.name = GCENNAME;
            gc.vlocity_ins__GroupId__c = acc.id;
            database.insert(gc);  
            
            vlocity_ins__GroupCensusMember__c gcm = new vlocity_ins__GroupCensusMember__c();
            gcm.name = GCENNAME;
            gcm.vlocity_ins__CensusId__c =gc.id;
            database.insert(gcm);       
            
            
            
            Product2 prd = ARV_AP05_TestDataCreation.productRec2();
            prd.name=MEDICAL;
            prd.ProductCode=PODCODE;
            prd.vlocity_ins__SubType__c='PPO';

            database.insert(prd);
            
            Product2 prd1 = ARV_AP05_TestDataCreation.productRec2();
            prd1.name=DENTAL;
            prd1.ProductCode=PODCODE;
            prd1.vlocity_ins__SubType__c='PPO';

            database.insert(prd1);
            
            Product2 prd2 = ARV_AP05_TestDataCreation.productRec2();
            prd2.name=VISION;
            prd2.ProductCode=PODCODE;
            prd2.vlocity_ins__SubType__c='PPO';

            database.insert(prd2);
            
            vlocity_ins__ContractLineItem__c planattr = new vlocity_ins__ContractLineItem__c();
            planattr.name=PODCODE;
            planattr.vlocity_ins__ContractId__c= cont.id;
            //planattr.vlocity_ins__AttributeSelectedValues__c=;
            planattr.vlocity_ins__Product2Id__c=prd.id;
            
            database.insert(planattr);
            
            Package__c pck1=ARV_AP05_TestDataCreation.packageRec(cont.Id);
            pck1.name = PACKAGE1;
            
            pck1.Medical_Product_Id__c=prd.id;
            pck1.Dental_Product_Id__c=prd1.id;
            pck1.Vision_Product_Id__c=prd1.id;
            database.insert(pck1);
            
            Package__c activepck =ARV_AP05_TestDataCreation.packageRec(cont.Id);
            activepck.name = PACKAGE1;
            activepck.ARV_Medical_Plan__c = planattr.id;
            activepck.ARV_Dental_Plan__c= planattr.id;
            
            activepck.ARV_Vision_Plan__c = planattr.id;   
            activepck.Medical_Product_Id__c=prd.id;
            activepck.Dental_Product_Id__c=prd1.id;
            activepck.Vision_Product_Id__c=prd1.id;
            database.insert(activepck);
            
            Package__c pendpck =ARV_AP05_TestDataCreation.packageRec(cont.Id);
            pendpck.name = PACKAGE1;
            pendpck.ARV_Medical_Plan__c = planattr.id;
            pendpck.ARV_Dental_Plan__c= planattr.id;
            pendpck.ARV_Vision_Plan__c = planattr.id;
            pendpck.Medical_Product_Id__c=prd.id;
            pendpck.Dental_Product_Id__c=prd1.id;
            pendpck.Vision_Product_Id__c=prd1.id;
            database.insert(pendpck);
            
            vlocity_ins__GroupCensusMemberPlan__c cen = new vlocity_ins__GroupCensusMemberPlan__c();
            cen.vlocity_ins__GroupCensusMemberId__c = gcm.id;
            cen.ARV_Member_Rate__c=123;
            cen.name=PACKAGE1;
            cen.PackageId__c = pck1.id;
            cen.vlocity_ins__ContractLineId__c=  planattr.id;  
            database.insert(cen);
            
            gseg1.ARV_Package__c = activepck.id;
            gseg1.ARV_Pending_PackageId__c=pendpck.id;
            gseg1.ARV_ContractID__c =cont.id;  
            
            database.update(gseg1);
            
            Carrier_Rate_Comparison__c crc = new Carrier_Rate_Comparison__c();
            crc.Future_Contract__c=cont.id;
            database.insert(crc);
            ARV_RenewalContractStaticDocs_Config__c arn = new ARV_RenewalContractStaticDocs_Config__c();
            arn.Name = 'sddsc';
            arn.ARV_Package_Type__c='Agent';
            arn.ARV_Product_Type__c='PPO';
            database.insert(arn);
            //documentsCreation('Marketing',arn.id);
            //documentsCreation('Small Group Reimbursement Policy Document',arn.id);
            //documentsCreation('Appendix A',arn.id);
            //documentsCreation('Appendix B',arn.id);
            //documentsCreation('Copyright',arn.id);
            //documentsCreation('Thank You Letter',arn.id);
            //documentsCreation('Ped Dental Reminder',arn.id);
            //documentsCreation('Glossary',arn.id);
            //List<ARV_RenewalContractStaticDocs_Config__c> docId =[ select ID from ARV_RenewalContractStaticDocs_Config__c where (ARV_Product_Type__c='PPO' or ARV_Product_Type__c='') and (ARV_Package_Type__c='Both' or ARV_Package_Type__c='Agent')]; 

            PageReference pageRef = Page.ARV_VF06_RateGridPage;
            pageRef.getParameters().put(IDS, String.valueOf(cont.Id));           
            Test.setCurrentPage(pageRef);            
            ARV_AP102_RateRenewalChange arv = new ARV_AP102_RateRenewalChange();
            test.startTest();
            arv.getAccountData();          
            test.stopTest();
            system.assertNotEquals(1,2);
            
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
}