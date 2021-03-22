/*****************************************************************************************
Class Name   : ARV_AP42_ProductPackageValidation_test 
Date Created : 26-JULY-2019
Created By   : IDC Offshore
Description  : This class is used for testing ARV_AP42_ProductPackageValidation Class.
******************************************************************************************/
@isTest
public without sharing class ARV_AP42_ProductPackageValidation_test {
     // Initializing variables and constants.
     private static final string PROFILENAME='BCBSM Agent';
     private static final string PROFILENAME1='Retention Sales';
     private static final string NAME='AP33LastName';
     private static final string NAME1='AP33RateGrid';
     private static final string USERNAME='bcbsm1@bcbsm.com';
     private static final String HEALTHYACHIEVE  = 'Healthy Blue Achieve';
     private static final string MULTIEMPLOYEE='MultiEmployee';
     private static final string MULTILOCATION='MultiLocation';
     private static final string COMMONCONTROL='CommonControl';
     private static final string YES='Yes';  
     private static final string STRINGNO='No';
     private static final string GROUPINFORMATION='GroupInformation';
     private static final string TYPE='Dental';
     private static final string TYPE1='Vision';
     private static final string BLANK='';
     private static final string CHECK='Yes';
     private static final string VOLUNTARY  = 'Voluntary';
     private static final string PEDIATRICPLAN  = 'Pediatric Plan';
     private static final string BCNHMO='BCN HMO';
     private static final string HEALTHYLIVING='Healthy Blue Living';
     private static final string SIMPLYBLUE='Simply Blue';
     private static final string SIMPLYBLUEHSA='Simply Blue HSA';
   
        
    /**************  
    Method name : testDataSetup
    Params     : NA
    Return Type : testmethod
    Description :  testDataSetup() method 
    *************/   
	 @testSetup static void testDataSetup() {  
    
     List<GA_County_Code__c> countyLst = ARV_AP05_TestDataCreation.createCounties(1);
     database.insert(countyLst);     
     Account acnt= ARV_AP05_TestDataCreation.accRec();
     acnt.GA_Mailing_County_id__c = countyLst[0].id;     
     database.insert(acnt);        
     pricebook2 pbook = ARV_AP05_TestDataCreation.priceBookRec();
     database.insert(pbook);     
     Contract cntrct = ARV_AP05_TestDataCreation.createContractRec(acnt.id);               
     database.insert(cntrct);     
     GA_Common_Control__c cmnc = ARV_AP05_TestDataCreation.commonControlRec(acnt.id);
     database.insert(cmnc); 
         
     Product2 sisProd= ARV_AP05_TestDataCreation.productRec();
     sisProd.Carrier_Type__c=ARV_AP41_StringLiteralUtils.BCBSTYPE;
     sisProd.Family=SIMPLYBLUE;     
	 database.insert(sisProd,true);
	 Product2 prod= ARV_AP05_TestDataCreation.productRec();
     prod.Carrier_Type__c=ARV_AP41_StringLiteralUtils.BCBSTYPE;
     prod.Family=SIMPLYBLUE;
     prod.ARV_PCPFocus_SisterPlan__c = sisProd.id; 
	 database.insert(prod,true);                
     Product2 prod1= ARV_AP05_TestDataCreation.productRec();
     prod1.Carrier_Type__c=ARV_AP41_StringLiteralUtils.BCNTYPE; 
     prod1.Family=BCNHMO;
     prod1.PCP_Focus__c = true;
	 database.insert(prod1,true);          
     Product2 prod2= ARV_AP05_TestDataCreation.productRec();
     prod2.Carrier_Type__c=ARV_AP41_StringLiteralUtils.BCNTYPE; 
     prod2.Family=HEALTHYLIVING;     
	 database.insert(prod2,true);         
     Product2 prod3= ARV_AP05_TestDataCreation.productRec();
     prod3.Carrier_Type__c=ARV_AP41_StringLiteralUtils.BCBSTYPE; 
     prod3.Family=HEALTHYACHIEVE;
     prod3.PCP_Focus__c = true;
     prod3.ARV_PCPFocus_SisterPlan__c = sisProd.id;
     database.insert(prod3,true);         
     Product2 prod4= ARV_AP05_TestDataCreation.productRec();
     prod3.Carrier_Type__c=ARV_AP41_StringLiteralUtils.BCBSTYPE;
     prod4.Family=SIMPLYBLUEHSA;
     prod4.PCP_Focus__c = true;
     prod4.ARV_PCPFocus_SisterPlan__c = sisProd.id;
     database.insert(prod4,true);         
     vlocity_ins__ContractLineItem__c  plan= ARV_AP05_TestDataCreation.planRec(prod.id,cntrct.id);
     database.insert(plan); 
     user usr = ARV_AP05_TestDataCreation.UsrRec(PROFILENAME1);
     usr.LastName = NAME1;
     usr.Username=USERNAME;
     database.insert(usr,true);     
 }
    
    /**************  
    Method name : testProductPackage
    Params     : NA
    Return Type : testmethod
    Description :  internalUserTest() method 
    *************/     
    @isTest    
    static void testProductPackage() {        
        Map<String,Object> inputMap = new Map<String,Object>();
        Map<String,Object> outMap = new Map<String,Object>();
        Map<String,Object> options = new Map<String,Object>();
        Map<String,Object> packageProd1 = new Map<String,Object>();
        Map<String,Object> packageProduct2 = new Map<String,Object>();
        //Map<String,Object> packageProduct3 = new Map<String,Object>();
        Map<String,Object> packageLctnStep = new Map<String,Object>(); 
        Map<String,Object> groupInfo = new Map<String,Object>();
        //Map<String,Object> packageSelection = new Map<String,Object>();                        
        Account acc=[select id, name, MailingCountyFormula__c, BillingPostalCode from Account limit 1];
        Map<String,Product2> prodMap = new Map<String,Product2>();
        for(Product2 prod : [select id,vlocity_ins__Type__c,carrier_type__c,Family from product2 limit 10]){
                prodMap.put(prod.Family,prod);
        }
        List<Object> countyLst = new List<Object>();
        countyLst.add('MACOMB'); 
        countyLst.add('ST. CLAIR');
        groupInfo.put('MultiEmployee','Yes'); 
        groupInfo.put('MultiLocation','Yes');
        groupInfo.put('CommonControl','No'); 
        groupInfo.put('SelectEmployeeSegments','Hourly/Salary');
        Map<String,Object> headquarters = new Map<String,Object>();
        headquarters.put('ALCounty','HQ: MACOMB');
        headquarters.put('ALZipCode',48005);
        headquarters.put('LocationName','HQ');
        headquarters.put('lKey','HQ-HQ: MACOMB-48005');        
        Map<String,Object> additionalLocs = new Map<String,Object>();
        additionalLocs.put('ALCounty','LAPEER');
        additionalLocs.put('ALZipCode',48003);
        additionalLocs.put('LocationName','test');
        additionalLocs.put('aLOutsideCounty',null);                 
        groupInfo.put('Headquarters',headquarters);
        groupInfo.put('AdditionalLocations',additionalLocs);                        
        packageProd1.put('MedicalProductidFormula1',prodMap.get(SIMPLYBLUE).id );
        packageProd1.put('MedicalPackLookup1',prodMap.get(SIMPLYBLUE).id+'-'+prodMap.get(SIMPLYBLUE).carrier_type__c);                        
        packageProduct2.put('MedicalProductidFormula2',prodMap.get(HEALTHYACHIEVE).id);
        packageProduct2.put('MedicalPackLookup2',prodMap.get(HEALTHYACHIEVE).id+'-'+
                            prodMap.get(HEALTHYACHIEVE).Carrier_Type__c+'-'+'PCP');        
        packageLctnStep.put('PackageProduct1',packageProd1); 
        packageLctnStep.put('PackageProduct2',packageProduct2);        
        packageLctnStep.put('NoOfPackages',2);                        
        Map<String,Object> pckgSlctnStep = new Map<String,Object>();
        pckgSlctnStep.put('Hourly-HQ-48005-HQ: MACOMB','Package1');
        pckgSlctnStep.put('Hourly-test-48003-LAPEER','Package1;Package2'); 
        inputMap.put('PackageLocation',packageLctnStep);
        inputMap.put('GroupInformation',groupInfo);
        inputMap.put('PackageSelection',pckgSlctnStep);
        inputMap.put('countyList',countyLst);
        
        user usr1  = [SELECT Id from User where LastName =: NAME1 limit 1];
        system.runAs(usr1){        	         	            
        ARV_AP42_ProductPackageValidation arvProd = new ARV_AP42_ProductPackageValidation();            
        try{          	
                        test.startTest();
                        arvProd.invokemethod('enrollMedicalValidation',inputMap,outMap,options); 
                        test.stoptest();
                    	System.assertNotEquals(null,acc.id);
                 }Catch(Exception e){return ;}
        }
    }
    /**************  
    Method name : testProductPackage1
    Params     : NA
    Return Type : testmethod
    Description :  internalUserTest() method 
    *************/   
    @isTest    
    static void testProductPackage1() {
        
        Map<String,Object> inputMap = new Map<String,Object>();
        Map<String,Object> outMap = new Map<String,Object>();
        Map<String,Object> options = new Map<String,Object>();
        Map<String,Object> packageProd1 = new Map<String,Object>();
        Map<String,Object> packageProduct2 = new Map<String,Object>();
        Map<String,Object> packageProduct3 = new Map<String,Object>();
        Map<String,Object> packageLctnStep = new Map<String,Object>(); 
        Map<String,Object> groupInfo = new Map<String,Object>();
        Map<String,Object> packageSelection = new Map<String,Object>();
        List<Object> countyLst = new List<Object>();
        countyLst.add('ST. CLAIR'); 
        countyLst.add('MACOMB');
        Account acc=[select id, name, MailingCountyFormula__c, BillingPostalCode from Account limit 1];
        Map<String,Product2> prodMap = new Map<String,Product2>();
        for(Product2 prod : [select id,vlocity_ins__Type__c,carrier_type__c,Family from product2 limit 10]){
                prodMap.put(prod.Family,prod);
        }
        Map<String,Object> headquarters = new Map<String,Object>();
        headquarters.put('ALCounty','HQ: ST. CLAIR');
        headquarters.put('ALZipCode',48006);
        headquarters.put('LocationName','HQ');
        headquarters.put('lKey','HQ-HQ: ST. CLAIR-48006');        
        Map<String,Object> additionalLocs = new Map<String,Object>();
        additionalLocs.put('ALCounty','LAPEER');
        additionalLocs.put('ALZipCode',48003);
        additionalLocs.put('LocationName','gdg');
        additionalLocs.put('ALOutsideCounty','');
        additionalLocs.put('CompanyNameLOC','');
        additionalLocs.put('CommonControlTaxID','');
        groupInfo.put('MultiEmployee','No'); 
        groupInfo.put('MultiLocation','Yes');
        groupInfo.put('CommonControl','No'); 
        groupInfo.put('SelectEmployeeSegments',null); 
        groupInfo.put('Headquarters',headquarters);
        groupInfo.put('AdditionalLocations',additionalLocs);      
        packageProd1.put('MedicalProductidFormula1',prodMap.get(BCNHMO).id);
        packageProduct2.put('MedicalProductidFormula2',prodMap.get(HEALTHYLIVING).id);
        packageProduct3.put('MedicalProductidFormula3',prodMap.get(HEALTHYACHIEVE).id);  
        packageProd1.put('MedicalPackLookup1',prodMap.get(BCNHMO).id+'-'+prodMap.get(BCNHMO).carrier_type__c);
        packageProduct2.put('MedicalPackLookup2',prodMap.get(HEALTHYLIVING).id+'-'+prodMap.get(HEALTHYLIVING).carrier_type__c);
        packageProduct3.put('MedicalPackLookup3',prodMap.get(HEALTHYACHIEVE).id+'-'+
                            prodMap.get(HEALTHYACHIEVE).carrier_type__c+'-'+'PCP');         
        packageLctnStep.put('PackageProduct1',packageProd1); 
        packageLctnStep.put('PackageProduct2',packageProduct2);
        packageLctnStep.put('PackageProduct3',packageProduct3);
        packageLctnStep.put('Plans','Medical;Dental;Vision');
        packageLctnStep.put('NoOfPackages',3);                
        Map<String,Object> pckgSlctnStep = new Map<String,Object>();
        pckgSlctnStep.put('-HQ-48006-HQ: ST. CLAIR','Package1;Package2');
        pckgSlctnStep.put('-gdg-48003-LAPEER','Package2;Package3'); 
        inputMap.put('PackageLocation',packageLctnStep);
        inputMap.put('GroupInformation',groupInfo);
        inputMap.put('PackageSelection',pckgSlctnStep);
        inputMap.put('countyList',countyLst);
        
        user usr1  = [SELECT Id from User where LastName =: NAME1 limit 1];
        system.runAs(usr1){        	         	            
                ARV_AP42_ProductPackageValidation arvProd = new ARV_AP42_ProductPackageValidation();            
                try{
                        test.startTest();
                        arvProd.invokemethod('enrollMedicalValidation',inputMap,outMap,options);                    
                        test.stoptest();
                    System.assertNotEquals(null,acc.id);
                 }Catch(Exception e){return ;}
        }
    }
    /**************  
    Method name : testProductPackage2
    Params     : NA
    Return Type : testmethod
    Description :  internalUserTest() method 
    *************/     
    @isTest    
    static void testProductPackage2() {
        
        Map<String,Object> inputMap = new Map<String,Object>();
        Map<String,Object> outMap = new Map<String,Object>();
        Map<String,Object> options = new Map<String,Object>();
        Map<String,Object> packageProd1 = new Map<String,Object>();
        Map<String,Object> packageProduct2 = new Map<String,Object>();
        Map<String,Object> packageProduct3 = new Map<String,Object>();
        Map<String,Object> packageLctnStep = new Map<String,Object>(); 
        Map<String,Object> groupInfo = new Map<String,Object>();
        //Map<String,Object> packageSelection = new Map<String,Object>();
        List<Object> countyLst = new List<Object>();
        countyLst.add('MACOMB');        
        Account acc=[select id, name, MailingCountyFormula__c, BillingPostalCode from Account limit 1];
        Map<String,Product2> prodMap = new Map<String,Product2>();
        for(Product2 prod : [select id,vlocity_ins__Type__c,carrier_type__c,Family from product2 limit 10]){
                prodMap.put(prod.Family,prod);
        }
        Map<String,Object> headquarters = new Map<String,Object>();
        headquarters.put('ALCounty','ST. CLAIR');
        headquarters.put('ALZipCode',48006);
        //headquarters.put('LocationName','HQ');
        //headquarters.put('lKey','HQ-HQ: St. Clair-48006'); 
        Map<String,Object> additionalLocs = new Map<String,Object>();
        additionalLocs.put('ALCounty','LAPEER');
        additionalLocs.put('ALZipCode',48003);
        additionalLocs.put('LocationName','gdg');
        additionalLocs.put('ALOutsideCounty','');
        additionalLocs.put('CompanyNameLOC','');
        additionalLocs.put('CommonControlTaxID','');
        groupInfo.put('MultiEmployee','No'); 
        groupInfo.put('MultiLocation','Yes');
        groupInfo.put('CommonControl','Yes'); 
        groupInfo.put('SelectEmployeeSegments','Hourly/Salary'); 
        groupInfo.put('Headquarters',headquarters);
        groupInfo.put('AdditionalLocations',additionalLocs);
                      
        packageProd1.put('MedicalProductidFormula1',prodMap.get(BCNHMO).id);
        packageProduct2.put('MedicalProductidFormula2',prodMap.get(HEALTHYLIVING).id);
        packageProduct3.put('MedicalProductidFormula3',prodMap.get(HEALTHYACHIEVE).id);  
        packageProd1.put('MedicalPackLookup1',prodMap.get(BCNHMO).id+'-'+prodMap.get(BCNHMO).carrier_type__c+'-'+'PCP');
        packageProduct2.put('MedicalPackLookup2',prodMap.get(HEALTHYLIVING).id+'-'+prodMap.get(HEALTHYLIVING).carrier_type__c);
        packageProduct3.put('MedicalPackLookup3',prodMap.get(HEALTHYACHIEVE).id+'-'+
                            prodMap.get(HEALTHYACHIEVE).carrier_type__c);        
        packageLctnStep.put('PackageProduct1',packageProd1); 
        packageLctnStep.put('PackageProduct2',packageProduct2);
        packageLctnStep.put('PackageProduct3',packageProduct3);
        packageLctnStep.put('Plans','Medical;Dental;Vision');
        packageLctnStep.put('NoOfPackages',3);                
        inputMap.put('PackageLocation',packageLctnStep);
        inputMap.put('GroupInformation',groupInfo);        
        inputMap.put('countyList',countyLst);
        
        user usr1  = [SELECT Id from User where LastName =: NAME1 limit 1];
        system.runAs(usr1){        	         	            
                ARV_AP42_ProductPackageValidation arvProd = new ARV_AP42_ProductPackageValidation();            
                try{
                        test.startTest();
                        arvProd.invokemethod('enrollMedicalValidation',inputMap,outMap,options);                    
                        test.stoptest();
                    System.assertNotEquals(null,acc.id);
                 }Catch(Exception e){return ;}
        }
    }
    /**************  
    Method name : testProductPackage3
    Params     : NA
    Return Type : testmethod
    Description :  internalUserTest() method 
    *************/     
    @isTest    
    static void testProductPackage3() {
        
        Map<String,Object> inputMap = new Map<String,Object>();
        Map<String,Object> outMap = new Map<String,Object>();
        Map<String,Object> options = new Map<String,Object>();
        Map<String,Object> packageProd1 = new Map<String,Object>();
        Map<String,Object> packageProduct2 = new Map<String,Object>();
        Map<String,Object> packageProduct3 = new Map<String,Object>();
        Map<String,Object> packageLctnStep = new Map<String,Object>(); 
        Map<String,Object> groupInfo = new Map<String,Object>();
        //Map<String,Object> packageSelection = new Map<String,Object>();
        List<Object> countyLst = new List<Object>();
        countyLst.add('MACOMB');
        Account acc=[select id, name, MailingCountyFormula__c, BillingPostalCode from Account limit 1];
        Map<String,Product2> prodMap = new Map<String,Product2>();
        for(Product2 prod : [select id,vlocity_ins__Type__c,carrier_type__c,Family from product2 limit 10]){
                prodMap.put(prod.Family,prod);
        }
        Map<String,Object> headquarters = new Map<String,Object>();
        headquarters.put('ALCounty','MACOMB');
        headquarters.put('ALZipCode',48006);        
        Map<String,Object> additionalLocs = new Map<String,Object>();
        additionalLocs.put('ALCounty','HQ: ST. CLAIR');
        additionalLocs.put('ALZipCode',48006);
        additionalLocs.put('LocationName','gdg');
        additionalLocs.put('ALOutsideCounty','');
        additionalLocs.put('CompanyNameLOC','');
        additionalLocs.put('CommonControlTaxID','');
        groupInfo.put('MultiEmployee','No'); 
        groupInfo.put('MultiLocation','No');
        groupInfo.put('CommonControl','Yes'); 
        groupInfo.put('SelectEmployeeSegments','Hourly/Salary'); 
        groupInfo.put('Headquarters',headquarters);
        groupInfo.put('AdditionalLocations',additionalLocs);      
        packageProd1.put('MedicalProductidFormula1',prodMap.get(SIMPLYBLUEHSA).id);
        packageProduct2.put('MedicalProductidFormula2',prodMap.get(HEALTHYLIVING).id);
        packageProduct3.put('MedicalProductidFormula3',prodMap.get(HEALTHYACHIEVE).id);  
        packageProd1.put('MedicalPackLookup1',prodMap.get(SIMPLYBLUEHSA).id+'-'+
                         prodMap.get(SIMPLYBLUEHSA).carrier_type__c+'-'+'PCP');
        packageProduct2.put('MedicalPackLookup2',prodMap.get(HEALTHYLIVING).id+'-'+prodMap.get(HEALTHYLIVING).carrier_type__c);
        packageProduct3.put('MedicalPackLookup3',prodMap.get(HEALTHYACHIEVE).id+'-'+prodMap.get(HEALTHYACHIEVE).carrier_type__c);        
        packageLctnStep.put('PackageProduct1',packageProd1); 
        packageLctnStep.put('PackageProduct2',packageProduct2);
        packageLctnStep.put('PackageProduct3',packageProduct3);
        packageLctnStep.put('Plans','Medical;Dental;Vision');
        packageLctnStep.put('NoOfPackages',3);                
        inputMap.put('PackageLocation',packageLctnStep);
        inputMap.put('GroupInformation',groupInfo);        
        inputMap.put('countyList',countyLst);
        
        user usr1  = [SELECT Id from User where LastName =: NAME1 limit 1];
        system.runAs(usr1){        	         	            
                ARV_AP42_ProductPackageValidation arvProd = new ARV_AP42_ProductPackageValidation();            
                try{
                        test.startTest();
                        arvProd.invokemethod('enrollMedicalValidation',inputMap,outMap,options);                    
                        test.stoptest();
                    System.assertNotEquals(null,acc.id);
                 }Catch(Exception e){return ;}
        }
    }
		
}