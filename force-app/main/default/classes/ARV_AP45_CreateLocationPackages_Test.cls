/*****************************************************************************************
Class Name   : ARV_AP45_CreateLocationPackages_Test 
Date Created : 21-AUG-2019
Created By   : IDC Offshore
Description  : This class is used for testing CensusRateGridController Class.
******************************************************************************************/
@isTest
public without sharing class ARV_AP45_CreateLocationPackages_Test {
    private static final string PROFILENAME='BCBSM Agent';
    private static final string PROFILENAME1='System Administrator';
    private static final string IDS = 'id';
    private static final string NAME='AP45LastName';
    private static final string NAME1='AP45Pckgs';
    private static final string USERNAME='bcbsm1@bcbsm.com';
    private static final string TYPE='Dental';
    private static final string TYPE1='Vision';
    private static final string BLANK='';
    private static final string CHECK='Yes';
    private static final string VOLUNTARY  = 'Voluntary';
    private static final string PEDIATRICPLAN  = 'Pediatric Plan';
    private static final string HQCOUNTY  = 'HQ: MACOMB';
    
    /**************  
Method name : testDataSetup
Params     : NA
Return Type : testmethod
Description :  testDataSetup() method 
*************/     
    @testSetup static void testDataSetup() {
        List<GA_County_Code__c> countyList = ARV_AP05_TestDataCreation.createCounties(1);
        database.insert(countyList);        
        Account act= ARV_AP05_TestDataCreation.accRec();
        act.GA_Mailing_County_id__c = countyList[0].id;
        database.insert(act);
        vlocity_ins__GroupCensus__c census=ARV_AP05_TestDataCreation.groupCensus(act.Id);
        database.insert(census);
        Id standardPriceBookRecId=Test.getStandardPricebookId();
        pricebook2 pb2=ARV_AP05_TestDataCreation.priceBookRec();
        database.insert(pb2);
        Opportunity opp= ARV_AP05_TestDataCreation.opportunityRec(act.Id,standardPriceBookRecId);
        database.insert(opp); 
        Contract con = ARV_AP05_TestDataCreation.createContractRec(act.Id);
        database.insert(con);                 
        
        Product2 prd= ARV_AP05_TestDataCreation.productRec();
        prd.PCP_Focus__c = true;       
        database.insert(prd);
        vlocity_ins__ContractLineItem__c  plan= ARV_AP05_TestDataCreation.planRec(prd.id,con.id);
        database.insert(plan);
        Product2 prd1= ARV_AP05_TestDataCreation.productRec();
        prd1.vlocity_ins__Type__c=TYPE;
        prd1.Voluntary_Contributory__c=VOLUNTARY;
        prd1.Carrier_Type__c=BLANK;
        prd1.ARV_PCPFocus_SisterPlan__c=prd.id;
        database.insert(prd1);
        Product2 prd2= ARV_AP05_TestDataCreation.productRec();
        prd2.vlocity_ins__Type__c=TYPE1;
        prd2.Voluntary_Contributory__c=VOLUNTARY;
        prd2.Carrier_Type__c=BLANK;
        database.insert(prd2);
        Product2 prd3= ARV_AP05_TestDataCreation.productRec();
        prd3.vlocity_ins__Type__c=TYPE;
        prd3.Name=PEDIATRICPLAN;
        prd3.Carrier_Type__c=BLANK;
        database.insert(prd3);
        Product2 prd4= ARV_AP05_TestDataCreation.productRec();
        prd4.vlocity_ins__Type__c=TYPE1;
        prd4.Name=PEDIATRICPLAN;
        prd4.Carrier_Type__c=BLANK;
        database.insert(prd4);
        vlocity_ins__ContractLineItem__c plans= ARV_AP05_TestDataCreation.planRec(prd1.Id,con.Id);
        database.insert(plans);
        vlocity_ins__ContractLineItem__c plans1= ARV_AP05_TestDataCreation.planRec(prd2.Id,con.Id);
        database.insert(plans1);
        package__c pckg= ARV_AP05_TestDataCreation.packageRec(con.id);
        pckg.ARV_Medical_Plan__c=plan.id;
        pckg.ARV_Contract_Id__c =con.id;
        database.insert(pckg);
        LocationPackage__c locpkg1= ARV_AP05_TestDataCreation.locpkgRec(con.id);
        locpkg1.ARV_IsCommonControll__c=false;
		locpkg1.ARV_IsMI__c=true;
		locpkg1.ARV_Location_Physical_County__c =HQCOUNTY;
        database.insert(locpkg1);        
        LocationPackage__c locpkg= ARV_AP05_TestDataCreation.locpkgRec(con.id);
        locpkg.ARV_IsCommonControll__c=false;
		locpkg.ARV_IsMI__c=false;//changed from true
		locpkg.ARV_Location_Physical_County__c =HQCOUNTY;
        database.insert(locpkg);
        Package_Location_Segment_Rel__c  plsr =ARV_AP05_TestDataCreation.pkglocsgmrelRec(pckg.id,locpkg1.id);
		plsr.Contract__c=con.id;
        database.insert(plsr);
        Package_Location_Segment_Rel__c  plsr1 =ARV_AP05_TestDataCreation.pkglocsgmrelRec(pckg.id,locpkg.id);
		plsr.Contract__c=con.id;
        database.insert(plsr1);

        user usr = ARV_AP05_TestDataCreation.UsrRec(PROFILENAME1);
        usr.LastName = NAME1;
        usr.Username=USERNAME;
        database.insert(usr,true);
    }
    /**************  
Method name : censusRateGridTest
Params     : NA
Return Type : testmethod
Description :  internalUserTest() method 
*************/ 
    private static testmethod void censusRateGridTest(){
        Account acc=[select id,name,MailingCountyFormula__c,BillingPostalCode from Account limit 1];
        Contract con =[select id,name from Contract limit 1];        
        Map<String,Product2> prodMap = new Map<String,Product2>();
        for(Product2 prod : [select id,vlocity_ins__Type__c,carrier_type__c from product2 limit 3]){
                prodMap.put(prod.vlocity_ins__Type__c,prod);
        }
        Map<String,Object> inputMap = new Map<String,Object>();
        Map<String,Object> outMap = new Map<String,Object>();
        Map<String,Object> options = new Map<String,Object>();
        inputMap.put('AccountId',acc.id);
        options.put('contractId',con.id);
        Map<String,Object> headquartersStep = new Map<String,Object>();
        headquartersStep.put('ALCounty','HQ: MACOMB');
        headquartersStep.put('ALZipCode',acc.BillingPostalCode);
        headquartersStep.put('LocationName','HQ');
        //headquartersStep.put('LocationName','HQ');
        headquartersStep.put( 'lKey', 'HQ-HQ: MACOMB-48005');
        Map<String,Object> groupInformationStep = new Map<String,Object>();
        groupInformationStep.put('GroupName',acc.name);
        groupInformationStep.put('MultiEmployee','Yes');
        groupInformationStep.put('SelectEmployeeSegments','Hourly/Salary');
        groupInformationStep.put('MultiLocation','No');
        groupInformationStep.put('CommonControl','No');
        groupInformationStep.put('Headquarters',headquartersStep);
        Map<String,Object> packageLocationStep = new Map<String,Object>();
        packageLocationStep.put('Plans','Medical;Dental;Vision');
        packageLocationStep.put('NoOfPackages','3');
        packageLocationStep.put('DentalIsSelected','no');
        packageLocationStep.put('pedDentalAdded',true);
        Map<String,Object> packageProduct1Step = new Map<String,Object>();
        Map<String,Object> packageProduct2Step = new Map<String,Object>();
        Map<String,Object> packageProduct3Step = new Map<String,Object>();
        packageProduct1Step.put('MedicalPackLookup1',prodMap.get('Medical').id+'-'+prodMap.get('Medical').carrier_type__c+'-'+'PCP');
        packageProduct1Step.put('DentalPackLookup1',prodMap.get('Dental').id);
        packageProduct1Step.put('VisionPackLookup1',prodMap.get('Vision').id);
        packageProduct2Step.put('MedicalPackLookup2',prodMap.get('Medical').id+'-'+prodMap.get('Medical').carrier_type__c);
        packageProduct2Step.put('DentalPackLookup2',prodMap.get('Dental').id);
        packageProduct2Step.put('VisionPackLookup2',prodMap.get('Vision').id);
        packageProduct3Step.put('MedicalPackLookup3',prodMap.get('Medical').id+'-'+prodMap.get('Medical').carrier_type__c);
        packageProduct3Step.put('DentalPackLookup3',prodMap.get('Dental').id);
        packageProduct3Step.put('VisionPackLookup3',prodMap.get('Vision').id);
        packageLocationStep.put('PackageProduct1',packageProduct1Step);
        packageLocationStep.put('PackageProduct2',packageProduct2Step);
        packageLocationStep.put('PackageProduct3',packageProduct3Step);
        Map<String,Object> pdtrcDentalStep = new Map<String,Object>();
        pdtrcDentalStep.put('ProductId',prodMap.get('Dental').id);
        Map<String,Object> pdtrcVisionStep = new Map<String,Object>();
        pdtrcVisionStep.put('ProductId',prodMap.get('Vision').id);
        Map<String,Object> pckgSlctnStep = new Map<String,Object>();
        Map<String,Object> assignmentsStep = new Map<String,Object>();
        assignmentsStep.put('Hourly-HQ-48005-HQ: MACOMB','Package1');
        pckgSlctnStep.put('Assignments',assignmentsStep);
        user usr1 = [SELECT Id from User where LastName =: NAME1 limit 1];
        inputMap.put('GroupInformation',groupInformationStep);
        inputMap.put('PackageLocation',packageLocationStep);
        inputMap.put('pediatricDental',pdtrcDentalStep);
        inputMap.put('pediatricVision',pdtrcVisionStep);
        inputMap.put('PackageSelection',pckgSlctnStep);
         
        system.runAs(usr1){            
            ARV_AP45_CreateLocationPackages rate = new ARV_AP45_CreateLocationPackages();
            test.startTest();            
            rate.invokeMethod('createLocationPckg',inputMap,outMap,options);
            test.stopTest(); 
            System.assertNotEquals(null,acc.id);
        }
    }
    
        /**************  
Method name : censusRateGridTest1
Params     : NA
Return Type : testmethod
Description :  internalUserTest() method 
*************/ 
    private static testmethod void censusRateGridTest1(){
        Account acc=[select id,name,MailingCountyFormula__c,BillingPostalCode from Account limit 1];
        Contract con =[select id,name from Contract limit 1];        
        Map<String,Product2> prodMap = new Map<String,Product2>();
        for(Product2 prod : [select id,vlocity_ins__Type__c,carrier_type__c from product2 limit 3]){
                prodMap.put(prod.vlocity_ins__Type__c,prod);
        }
        Map<String,Object> inputMap = new Map<String,Object>();
        Map<String,Object> outMap = new Map<String,Object>();
        Map<String,Object> options = new Map<String,Object>();
        inputMap.put('AccountId',acc.id);
        options.put('contractId',con.id);
        Map<String,Object> headquartersStep = new Map<String,Object>();
        headquartersStep.put('ALCounty','HQ: MACOMB');
        headquartersStep.put('ALZipCode',acc.BillingPostalCode);
        headquartersStep.put('LocationName','HQ');
        Map<String,Object> groupInformationStep = new Map<String,Object>();        
        groupInformationStep.put('GroupName',acc.name);
        groupInformationStep.put('MultiEmployee','Yes');//changed from No to Yes        
        groupInformationStep.put('MultiLocation','Yes');
        groupInformationStep.put('CommonControl','No');
        groupInformationStep.put('Headquarters',headquartersStep);
        Map<String,Object> additionalLocationsStep = new Map<String,Object>();
        additionalLocationsStep.put('LocationName','dfgf');
        additionalLocationsStep.put('ALZipCode','48001');
        additionalLocationsStep.put('ALCounty','ST. CLAIR');
        groupInformationStep.put('AdditionalLocations',additionalLocationsStep);
        Map<String,Object> packageLocationStep = new Map<String,Object>();
        packageLocationStep.put('Plans','Medical;Dental;Vision');
        packageLocationStep.put('NoOfPackages','1');
        packageLocationStep.put('DentalIsSelected','no');
        packageLocationStep.put('pedDentalAdded',true);
        Map<String,Object> packageProduct1Step = new Map<String,Object>();        
        packageProduct1Step.put('MedicalPackLookup1',prodMap.get('Medical').id+'-'+prodMap.get('Medical').carrier_type__c+'-'+'PCP');
        packageProduct1Step.put('DentalPackLookup1',prodMap.get('Dental').id);
        packageProduct1Step.put('VisionPackLookup1',prodMap.get('Vision').id);
        packageLocationStep.put('PackageProduct1',packageProduct1Step);
        Map<String,Object> pdtrcDentalStep = new Map<String,Object>();
        pdtrcDentalStep.put('ProductId',prodMap.get('Dental').id);
        Map<String,Object> pdtrcVisionStep = new Map<String,Object>();
        pdtrcVisionStep.put('ProductId',prodMap.get('Vision').id);
        Map<String,Object> pckgSlctnStep = new Map<String,Object>();
        Map<String,Object> assignmentsStep = new Map<String,Object>();
        assignmentsStep.put('-HQ-48005-HQ: St. Clair','Package1');
        assignmentsStep.put('-dfgf-48001-ST. CLAIR','Package1');
        pckgSlctnStep.put('Assignments',assignmentsStep);        
        user usr1 = [SELECT Id from User where LastName =: NAME1 limit 1];
        map<String,Object> commonControlInformationStep= new map<String,object>();        
        commonControlInformationStep.put('AccountName','Common Account');
        commonControlInformationStep.put('FederalTaxID','951235786');
        commonControlInformationStep.put('PhysicalAddress','hdgfdj');
        commonControlInformationStep.put('CityCommonControl','jhgffh');
        commonControlInformationStep.put('StateCommonControl','MI');
        commonControlInformationStep.put('CountyCommonControl','St. Clair');
        commonControlInformationStep.put('CommonControlId',packageLocationStep);        
        commonControlInformationStep.put('cCZipCode','48007');
		commonControlInformationStep.put('cCCounty','Oakland');
		commonControlInformationStep.put('cCOutsideCounty',null);//commApprovalProcessUW
        commonControlInformationStep.put('CommApprovalProcessUW',true);
        commonControlInformationStep.put('approvalProcessUW',true);
        groupInformationStep.put('CommonControlInformation',commonControlInformationStep);
        groupInformationStep.put('SelectEmployeeSegments','Hourly/Salary');
        groupInformationStep.put('CommonControl','Yes');        
        inputMap.put('GroupInformation',groupInformationStep);
        inputMap.put('PackageLocation',packageLocationStep);
        inputMap.put('pediatricDental',pdtrcDentalStep);
        inputMap.put('pediatricVision',pdtrcVisionStep);
        inputMap.put('PackageSelection',pckgSlctnStep);
         
        system.runAs(usr1){            
            ARV_AP45_CreateLocationPackages rate = new ARV_AP45_CreateLocationPackages();
            test.startTest();            
            rate.invokeMethod('createLocationPckg',inputMap,outMap,options);
            test.stopTest(); 
            System.assertNotEquals(null,acc.id);
        }
    }
    /**************  
    Method name : censusRateGridTest2
    Params     : NA
    Return Type : testmethod
    Description :  internalUserTest() method 
    *************/
   private static testmethod void censusRateGridTest2(){
        Account acc=[select id,name,MailingCountyFormula__c,BillingPostalCode from Account limit 1];
        Contract con =[select id,name from Contract limit 1];        
        Map<String,Product2> prodMap = new Map<String,Product2>();
        for(Product2 prod : [select id,vlocity_ins__Type__c,carrier_type__c from product2 limit 3]){
                prodMap.put(prod.vlocity_ins__Type__c,prod);
        }
        Map<String,Object> inputMap = new Map<String,Object>();
        Map<String,Object> outMap = new Map<String,Object>();
        Map<String,Object> options = new Map<String,Object>();
        inputMap.put('AccountId',acc.id);
        options.put('contractId',con.id);
        Map<String,Object> headquartersStep = new Map<String,Object>();
        headquartersStep.put('ALCounty','HQ: MACOMB');
        headquartersStep.put('ALZipCode',acc.BillingPostalCode);
        headquartersStep.put('LocationName','HQ');
        Map<String,Object> groupInformationStep = new Map<String,Object>();        
        groupInformationStep.put('GroupName',acc.name);
        groupInformationStep.put('MultiEmployee','No');//changed from No to Yes        
        groupInformationStep.put('MultiLocation','Yes');
        groupInformationStep.put('CommonControl','No');
        groupInformationStep.put('Headquarters',headquartersStep);
        Map<String,Object> additionalLocationsStep = new Map<String,Object>();
        additionalLocationsStep.put('LocationName','dfgf');
        additionalLocationsStep.put('ALZipCode','48001');
        additionalLocationsStep.put('ALCounty','ST. CLAIR');
        groupInformationStep.put('AdditionalLocations',additionalLocationsStep);
        Map<String,Object> packageLocationStep = new Map<String,Object>();
        packageLocationStep.put('Plans','Medical;Dental;Vision');
        packageLocationStep.put('NoOfPackages','3');
        packageLocationStep.put('DentalIsSelected','no');
        packageLocationStep.put('pedDentalAdded',true);
        Map<String,Object> packageProduct1Step = new Map<String,Object>();  
 		Map<String,Object> packageProduct2Step = new Map<String,Object>(); 
        Map<String,Object> packageProduct3Step = new Map<String,Object>();        
        packageProduct1Step.put('MedicalPackLookup1',prodMap.get('Medical').id+'-'+
                                prodMap.get('Medical').carrier_type__c+'-'+'PCP');
        packageProduct1Step.put('DentalPackLookup1',prodMap.get('Dental').id);
        packageProduct1Step.put('VisionPackLookup1',prodMap.get('Vision').id);
        packageProduct2Step.put('MedicalPackLookup2',prodMap.get('Medical').id+'-'+
                                prodMap.get('Medical').carrier_type__c+'-'+'PCP');
        packageProduct2Step.put('DentalPackLookup2',prodMap.get('Dental').id);
        packageProduct2Step.put('DentalPackLookup2',prodMap.get('Vision').id);
        packageProduct3Step.put('MedicalPackLookup3',prodMap.get('Medical').id+'-'+
                                prodMap.get('Medical').carrier_type__c+'-'+'PCP');
        packageProduct3Step.put('DentalPackLookup3',prodMap.get('Dental').id);
        packageProduct3Step.put('DentalPackLookup3',prodMap.get('Vision').id);
        packageLocationStep.put('PackageProduct1',packageProduct1Step);
        packageLocationStep.put('PackageProduct2',packageProduct2Step);
        packageLocationStep.put('PackageProduct3',packageProduct3Step);
        Map<String,Object> pdtrcDentalStep = new Map<String,Object>();
        pdtrcDentalStep.put('ProductId',prodMap.get('Dental').id);
        Map<String,Object> pdtrcVisionStep = new Map<String,Object>();
        pdtrcVisionStep.put('ProductId',prodMap.get('Vision').id);
        Map<String,Object> pckgSlctnStep = new Map<String,Object>();
        Map<String,Object> assignmentsStep = new Map<String,Object>();
        assignmentsStep.put('-HQ-48005-HQ: St. Clair','Package1');
        assignmentsStep.put('-dfgf-48001-ST. CLAIR','Package1');
        pckgSlctnStep.put('Assignments',assignmentsStep);        
        user usr1 = [SELECT Id from User where LastName =: NAME1 limit 1];
                map<String,Object> commonControlInformationStep= new map<String,object>();        
        commonControlInformationStep.put('AccountName','Common Account');
        commonControlInformationStep.put('FederalTaxID','951235786');
        commonControlInformationStep.put('PhysicalAddress','hdgfdj');
        commonControlInformationStep.put('CityCommonControl','jhgffh');
        commonControlInformationStep.put('StateCommonControl','MI');
        commonControlInformationStep.put('CountyCommonControl','St. Clair');
        commonControlInformationStep.put('CommonControlId',packageLocationStep);        
        commonControlInformationStep.put('cCZipCode','48007');
		commonControlInformationStep.put('cCCounty','Oakland');
		commonControlInformationStep.put('cCOutsideCounty',null);//commApprovalProcessUW
        commonControlInformationStep.put('CommApprovalProcessUW',true);
        commonControlInformationStep.put('approvalProcessUW',true);
        groupInformationStep.put('CommonControlInformation',commonControlInformationStep);          
        groupInformationStep.put('CommonControl','Yes');        
        inputMap.put('GroupInformation',groupInformationStep);
        inputMap.put('PackageLocation',packageLocationStep);
        inputMap.put('pediatricDental',pdtrcDentalStep);
        inputMap.put('pediatricVision',pdtrcVisionStep);
        inputMap.put('PackageSelection',pckgSlctnStep);
         
        system.runAs(usr1){            
            ARV_AP45_CreateLocationPackages rate = new ARV_AP45_CreateLocationPackages();
            test.startTest();            
            rate.invokeMethod('createLocationPckg',inputMap,outMap,options);
            test.stopTest(); 
            System.assertNotEquals(null,acc.id);
        }
    }
     
}