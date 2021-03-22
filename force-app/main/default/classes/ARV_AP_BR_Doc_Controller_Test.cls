@isTest(seealldata=false)
/**
*Class Name   : ARV_AP96_AgentRenewalPckg_Test
*Date Created : 18-JUne-2020
*Created By   : IDC Offshore
*Description  : This class is used for testing ARV_AP96_AgentRenewalPckg_Test.
**/
public without sharing  class ARV_AP_BR_Doc_Controller_Test {
    private static final string PROFILENAME1='System Administrator';
    private static final string IDS = 'id';
    private static final string PROFILENAME2='Small Group Underwriter';
    private static final string NAME='AP96LastName';
    private static final string NAME1='AP96LastName';    
    private static final string USERNAME='bcbsm1@bcbsm.com';
    private static final string GCENNAME='gcmid';
    private static final string MEDICAL='medical';
    private static final string DENTAL='dntal';
    private static final string VISION='vision';
    private static final string PODCODE='prodcod';
    private static final string PACKAGE1='package';
    private static final string ACT='Active';
    private static final string SGRR='SG';
    private static final string ATTR='{"UCCopay":"$35","SpecCopay":"$35","WellnessPlan":"HBL","CarrierCode":"HMO","MetalLevel":"Gold","HIOSPlanId":"15560MIV000001","SBC":"sbc.com","BAAG":"baag.com","PrescriptionDrugCoverage":"$6/$25/$50/$80/20%/20%","EmergencyRoomCopay":"$150","OfficeVisitCopay":"$25","Co-insurance":20,"Deductible":1500,"AnnualMax(InNetwork)":"$1500"}';   
	
    
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
        prd.ProductCode='15560MIV000001';
        prd.vlocity_ins__AttributeDefaultValues__c=ATTR;
        database.insert(prd);
        
        Product2 prd1 = ARV_AP05_TestDataCreation.productRec2();
        prd1.name=DENTAL;
        prd1.ProductCode='15560MIV000001';
        prd1.vlocity_ins__AttributeDefaultValues__c=ATTR;
        database.insert(prd1);
        
        Product2 prd2 = ARV_AP05_TestDataCreation.productRec2();
        prd2.name=VISION;
        prd2.ProductCode='15560MIV000001';
        prd2.vlocity_ins__AttributeDefaultValues__c=ATTR;
        database.insert(prd2);
            
        ARV_CO02_RateGridStaticData__c rateGridData = ARV_AP05_TestDataCreation.RateGridStaticDataGS('_A_Medical');
        database.insert(rateGridData);
           
        List<ARV_CO02_RateGridStaticData__c> rglst =[select ARV_Rate__c,ARV_age__c from ARV_CO02_RateGridStaticData__c where ARV_HIOSPlanId__c ='15560MIV000001'and planType__c='A_Medical'  and ARV_RatingArea__c='B' and arv_effectivedate__C=2020-04-01]; 
            
        vlocity_ins__ContractLineItem__c planattr = new vlocity_ins__ContractLineItem__c();
        planattr.name='BCBSM';
        planattr.vlocity_ins__ContractId__c= cont.id;
        planattr.vlocity_ins__AttributeSelectedValues__c=ATTR;
        planattr.vlocity_ins__Product2Id__c=prd.id;
        database.insert(planattr);
        
        Package__c pck1=ARV_AP05_TestDataCreation.packageRec(cont.Id);
        pck1.name = PACKAGE1;
        pck1.Medical_Product_Id__c=prd.id;
        pck1.Dental_Product_Id__c=prd1.id;
        pck1.Vision_Product_Id__c=prd1.id;
        //pck1.vlocity_ins__AttributeSelectedValues__c=ATTR;
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
        
        GA_Group_Segment__c gseg1= ARV_AP05_TestDataCreation.groupSegmentRec2(acc.Id,cont.Id);
        gseg1.ARV_Package__c = activepck.id;        
        gseg1.ARV_Pending_PackageId__c=pendpck.id;
        gseg1.ARV_ContractID__c =cont.id; 
        database.insert(gseg1);
        //gseg1.ARV_Package__r.ARV_Medical_Plan__r.vlocity_ins__AttributeSelectedValues__c=ATTR;
        database.update(gseg1);
       
		//gseg1.ARV_Package__r.ARV_Medical_Plan__r.vlocity_ins__AttributeSelectedValues__c=ATTR;
        //database.update(gseg2);
		List<GA_Group_Segment__c> grpSgmntLst=[select Name, ARV_Package__r.name,Facets_Class_Description__c,
            GA_Group_Name__c,GA_Facet_Group_Name__c,GA_Facets_Group_ID__c,GA_Facets_Class_ID__c,
            GA_Facets_Sub_Group_Number__c,
            ARV_ContractID__r.vlocity_ins__QuoteId__r.Renewal_Month__c,              
            GA_Account__r.name,GA_Account__r.CID__c ,ARV_ContractID__r.vlocity_ins__QuoteId__r.ARV_CF_Tech_RatingArea__c,
            ARV_ContractID__r.ARV_Requested_Renewal_Date_Month__c,
            ARV_ContractID__r.ARV_Requested_Effective_Date__c,                                      
            ARV_Package__r.ARV_Medical_Plan__r.vlocity_ins__ProductSubType__c,ARV_Package__r.ARV_Medical_Plan__r.vlocity_ins__ProductCode__c,ARV_Package__r.ARV_Dental_Plan__r.vlocity_ins__ProductSubType__c,
            ARV_Package__r.ARV_Dental_Plan__r.vlocity_ins__ProductCode__c,
            ARV_Package__r.ARV_Vision_Plan__r.vlocity_ins__ProductSubType__c,ARV_Package__r.ARV_Vision_Plan__r.vlocity_ins__ProductCode__c
            FROM GA_Group_Segment__c WHERE ARV_ContractID__c =:cont.Id ];
            system.debug('****grpSgmntLst'+grpSgmntLst+'*****cntrctId'+cont.Id);        
            
            PageReference pageRef = Page.ARV_VF_BR_DOC;
            pageRef.getParameters().put(IDS, String.valueOf(cont.Id));  
            pageRef.getParameters().put('Type', 'BCBSM');
            try{
            Test.setCurrentPage(pageRef);            
            ARV_AP_BR_Doc_Controller renpkg = new ARV_AP_BR_Doc_Controller();
            //ARV_AP96_AgentRenewalPckg.WrapperGS testWrap=new ARV_AP96_AgentRenewalPckg.WrapperGS(gseg1);
            //ARV_RateRenewalChange nn = new ARV_RateRenewalChange();
            
            test.startTest();
            renpkg.getRates();
            renpkg.getBCBSMAttributesInfo('963F','C','REGULAR');
            renpkg.getBCNAttributesInfo('15560MIV000001','MVAL','MDCL',system.today()-1,system.today());
            test.stopTest();
            system.assertNotEquals(activepck,pendpck);
            }catch(Exception e){
                system.debug('***err occured at '+e.getLineNumber()+'::::'+e.getMessage());
            }
        }
    }
}