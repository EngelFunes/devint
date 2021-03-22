/*****************************************************************************************
Class Name   : ARV_AP52_CenOSPremCal_Test
Date Created : 21-NOV-2019
Created By   : IDC Offshore
Description  : This class is used provide test coverage...
******************************************************************************************/
@isTest()
public without sharing class ARV_AP52_CenOSPremiumCal_Test {
    ARV_AP52_CenOSPremiumCal_Test(){}
    private static final string ADMINPROFILE='System Administrator';
    private static final string AGENTPROFILE='BCBSM Agent';
	private static final string CLASSNAME='ARV_AP52_CenOSPremCal';
    private static final string NAME='Test User';
 	private static final string USERNAME='bcbsm1@bcbsm.com';
 	private static final string DENTAL='Dental';
 	private static final string VISION='Vision';
 	private static final string MEDICAL='Medical';
 	private static final string BLANK='';
    /**************  
    Method name : testDataSetup
    Params     : NA
    Return Type : testmethod
    Description :  testDataSetup() method 
    *************/ 
    @testSetup static void testDataSetup() {
        //Create County
        List<GA_County_Code__c> countyList = ARV_AP05_TestDataCreation.createCounties(1);
        database.insert(countyList);
        System.debug('County is created '+countyList[0]);
        
        //Create Account
        Account acnt= ARV_AP05_TestDataCreation.accRec();
        acnt.GA_Mailing_County_id__c = countyList[0].id;
        acnt.ARV_Requested_Renewal_Date__c=System.Today().toStartOfMonth();
        acnt.Renewal_Month__c = 'January';
        //acnt.Renewal_Month__c = System.Today().month(); //covert this from string to interger based on month
        database.insert(acnt);
        System.debug('Account is created '+acnt);
        System.debug('R R D is '+acnt.ARV_Requested_Renewal_Date__c);
        
        
       
        
        //Create Census
        vlocity_ins__GroupCensus__c census = ARV_AP05_TestDataCreation.groupCensus(acnt.Id);
        database.insert(census);
        System.debug('Census is created'+census.Id);
        
        //Create StandardPriceBook
        Id standardPriceBookRecId=Test.getStandardPricebookId();
        
         //Create PriceBook
        pricebook2 pb2=ARV_AP05_TestDataCreation.priceBookRec();
        database.insert(pb2);
        
         //Create Opportunity
        Opportunity opp= ARV_AP05_TestDataCreation.opportunityRec(acnt.Id,standardPriceBookRecId);
        database.insert(opp);
        
        //create Census Member 1
        vlocity_ins__GroupCensusMember__c cnsMbr = ARV_AP05_TestDataCreation.groupCensusMember(census.Id);
        cnsMbr.status__c = 'Enrolling';
        cnsMbr.ARV_Is_Medical_Selected__c = true;
        cnsMbr.ARV_Is_Medical_Selected__c = true;
        cnsMbr.ARV_Is_Vision_Selected__c = true;
        cnsMbr.Medical_Premium__c = 50;
        cnsMbr.Dental_Premium__c = 50;
        cnsMbr.Vision_Premium__c = 50;
        cnsMbr.ARV_Is_Valid__c = true;
        cnsMbr.vlocity_ins__IsPrimaryMember__c = true;
        //cnsMbr.vlocity_ins__Birthdate__c = 1989-01-01;
        cnsMbr.MemberAge__c = 29;
        database.insert(cnsMbr);
        System.debug('Census Member 1 is created'+cnsMbr.Id);
        
        //create Census Member 2
        vlocity_ins__GroupCensusMember__c cnsMbr2 = ARV_AP05_TestDataCreation.groupCensusMember(census.Id);
        cnsMbr2.status__c = 'Enrolling';
        //cnsMbr2.vlocity_ins__RelatedCensusMemberId__r.ARV_Is_Valid__c = true;
        cnsMbr2.ARV_Is_Valid__c = true;
        cnsMbr2.vlocity_ins__IsPrimaryMember__c = false;
         cnsMbr2.ARV_Is_Medical_Selected__c = true;
        cnsMbr2.ARV_Is_Medical_Selected__c = true;
        cnsMbr2.ARV_Is_Vision_Selected__c = true;
        cnsMbr2.Medical_Premium__c = 50;
        cnsMbr2.Dental_Premium__c = 50;
        cnsMbr2.Vision_Premium__c = 50;
        cnsMbr2.MemberAge__c = 29;
        database.insert(cnsMbr2);
        System.debug('Census Member 2 is created'+cnsMbr2.Id);
        
        //Create Contract
        Contract cntrct = ARV_AP05_TestDataCreation.createContractRec(acnt.Id);
        cntrct.ARV_RatingArea__c = 'B';
        cntrct.ARV_Requested_Effective_Date__c = System.Today().toStartOfMonth();
        cntrct.vlocity_ins__EnrollmentCensusId__c = census.id;
        database.insert(cntrct);
        
         //Create Location Package
        LocationPackage__c lctnPckg1 = New LocationPackage__c();
        lctnPckg1.ARV_ContractId__c = cntrct.id;
        lctnPckg1.ARV_AccountId__c = acnt.id;
        
        //Create Contact
        Contact cntct = ARV_AP05_TestDataCreation.contactRec(acnt.Id);
        database.insert(cntct);
        
         //Create Sister Product
        Product2 sisPrd= ARV_AP05_TestDataCreation.productRec();        
        database.insert(sisPrd);
        
         //Create Medical Product
        Product2 mdclPrdct= ARV_AP05_TestDataCreation.productRec();
        mdclPrdct.PCP_Focus__c = true;
        mdclPrdct.ARV_PCPFocus_SisterPlan__c = sisPrd.id;
        database.insert(mdclPrdct);
        
         //Create Dental Product
        Product2 prd= ARV_AP05_TestDataCreation.productRec();
        //prd.vlocity_ins__Type__c = 'Dental';
        database.insert(prd);
        
         //Create Medical Plan
        vlocity_ins__ContractLineItem__c mdclPln= ARV_AP05_TestDataCreation.planRec(mdclPrdct.Id,cntrct.Id);
        //plan.vlocity_ins__ProductCode__c = prd.ProductCode;
        database.insert(mdclPln);
        System.debug('Plan is created'+mdclPln.Id);
        
         //Create Dental Plan
         vlocity_ins__ContractLineItem__c dntlPln= ARV_AP05_TestDataCreation.planRec(prd.Id,cntrct.Id);
        //plan.vlocity_ins__ProductCode__c = prd.ProductCode;
        database.insert(dntlPln);
        System.debug('Plan is created'+dntlPln.Id);
        
        //Create Vision Plan
        vlocity_ins__ContractLineItem__c vsnPln= ARV_AP05_TestDataCreation.planRec(prd.Id,cntrct.Id);
        //plan.vlocity_ins__ProductCode__c = prd.ProductCode;
        database.insert(vsnPln);
        System.debug('Plan is created'+vsnPln.Id);
        
        //Create Admin User
        user usr = ARV_AP05_TestDataCreation.UsrRec(ADMINPROFILE);
        usr.LastName = Name;
        usr.Username=USERNAME;
        database.insert(usr,true);
        
        //Create Quote
        Quote quot = ARV_AP05_TestDataCreation.quoteRec2(opp.Id,standardPriceBookRecId,usr.Id,census.Id); 
        database.insert(quot);
        
        //Create Packages here
       Package__c pckg = New Package__c();
     	pckg.ARV_Medical_Plan__c = mdclPln.id;
        pckg.ARV_Dental_Plan__c = dntlPln.id;
        pckg.ARV_Vision_Plan__c = vsnPln.id;
        pckg.ARV_Contract_Id__c  = cntrct.Id;       
        database.insert(pckg);
        System.debug('Package is created'+pckg.Id);
        
        // Create RateGridStaticData
        ARV_CO02_RateGridStaticData__c rtGrid = ARV_AP05_TestDataCreation.RateGridStaticData();
        rtGrid.ARV_RatingArea__c = cntrct.ARV_RatingArea__c;
        rtGrid.ARV_Rate__c = 2323.90;
        rtGrid.ARV_HIOSPlanId__c='908RSDSDSDS';
        database.insert(rtGrid);
    }
    	private static testmethod void getCensusMembers(){
            map<string,object> inputMap = new map<string,object>();       
            Map<String,Object> outMap = new Map<String,Object>();
            Map<String,Object> options = new Map<String,Object>();
            user usr = ARV_AP05_TestDataCreation.UsrRec(ADMINPROFILE);
            System.runAs(usr){
            Contract con=[select id,name from Contract limit 1];
            inputMap.put('ContextId',con.id);
            ARV_AP52_CenCOSPremiumCal mainClassInstance = New ARV_AP52_CenCOSPremiumCal();
            mainClassInstance.getCensusMembers(inputMap,outMap,options);
            System.assert(con.Id!='null');
        }
 	}
}