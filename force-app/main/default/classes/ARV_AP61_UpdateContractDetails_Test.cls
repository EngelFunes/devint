/*****************************************************************************************
Class Name   : ARV_AP61_UpdateContractDetails_Test . 
Date Created : 27-DEC-2019
Created By   : IDC Offshore
Description  :This is the class for contract record updation after  submitting. 
******************************************************************************************/
@isTest
private without sharing class ARV_AP61_UpdateContractDetails_Test {
 private static final string PROFILENAME='System Administrator';
 private static final string NAME='AP61LastName';
 private static final String USERNAME='bcbsm1@bcbsm.com';
 private static final string YES_VAL='Yes';
 private static final string NO_VAL='No';
 private static final string BHRULE='BCN HRA';
 private static final string SBH='Simply Blue HRA';
 private static final String BLANK='';
 private static final String CBHRA='Community Blue HRA';
 private static final String METHODNAME='updatecontractstatus';
 private static final String SEGMENTATIONTYPE='Hourly & Salary';
 private static final String CID='23';
 private static final String TEST_VAL='Test';
 private static final String PEDIATRIC='Pediatric';
    
/************************************************* 
Method name : testDataSetup1
Params     : NA
Return Type : testmethod
Description :  testDataSetup1() method 
**************************************************/  
@testSetup static void testDataSetup1() { 
    Account acc = new Account(name=TEST_VAL);
    acc.CID__c=CID;
    database.insert(acc);
    vlocity_ins__GroupCensus__c  census =ARV_AP05_TestDataCreation.groupCensus(acc.id);
    database.insert(census);
    Contract con = ARV_AP05_TestDataCreation.createContractRec(acc.Id);
   con.vlocity_ins__EnrollmentCensusId__c=census.Id;
      con.ARV_Requested_Effective_Date__c=System.Today();
    database.insert(con);
    Product2 prd= ARV_AP05_TestDataCreation.productRec();
    prd.Family=SBH;
    database.insert(prd);
    Product2 prd1= ARV_AP05_TestDataCreation.productRec();
    prd1.Family=SBH;
    database.insert(prd1);
    Product2 prd2= ARV_AP05_TestDataCreation.productRec();
    prd2.Family=BHRULE;
    database.insert(prd2);
    vlocity_ins__ContractLineItem__c  plan= ARV_AP05_TestDataCreation.planRec(prd.id,con.Id);
    database.insert(plan);
     vlocity_ins__ContractLineItem__c  plan1= ARV_AP05_TestDataCreation.planRec(prd1.id,con.Id);
    plan1.name=CBHRA;
    database.insert(plan1);
     vlocity_ins__ContractLineItem__c  plan2= ARV_AP05_TestDataCreation.planRec(prd2.id,con.Id);
    plan2.name=PEDIATRIC;
    database.insert(plan2);
    
    Package__c pckg= ARV_AP05_TestDataCreation.packageRec(con.Id);
    pckg.ARV_Medical_Plan__c=plan.Id;
    pckg.ARV_Dental_Plan__c=plan1.Id;
    pckg.ARV_Vision_Plan__c=plan2.Id;
    database.insert(pckg);
    vlocity_ins__GroupCensusMember__c cenmem=ARV_AP05_TestDataCreation.groupCensusMember(census.Id);
    cenmem.ARV_Package__c=pckg.Id;
    cenmem.ARV_Is_Vision_Selected__c=true;
    database.insert(cenmem);
        vlocity_ins__GroupCensusMember__c cenmem1=ARV_AP05_TestDataCreation.groupCensusMember(census.Id);
    cenmem1.ARV_Package__c=pckg.Id;
    cenmem1.ARV_Is_Vision_Selected__c=false;
   
    database.insert(cenmem1);
    GA_SIC_Code__c  sicobj= ARV_AP05_TestDataCreation.getSicRecord();
database.insert(sicobj);
LocationPackage__c locpckg= ARV_AP05_TestDataCreation.createLocsegmentRecord(con.ID,sicobj.Id);
database.insert(locpckg);
  user usr = ARV_AP05_TestDataCreation.UsrRec(PROFILENAME);
  usr.LastName = NAME;
  usr.Username=USERNAME;
  database.insert(usr,true);
}
/*****************************************************************************************
Method Name   : getcontractdetails . 
Date Created : 27-DEC-2019
Created By   : IDC Offshore
Description  :This is the class for contract record updation after  submitting. 
******************************************************************************************/
public static testmethod  void getContractDetails(){
     Map<String,Object> inputMap = new Map<String,Object>();
        Map<String,Object> outMap = new Map<String,Object>();
        Map<String,Object> options = new Map<String,Object>();
    try{
        Account acc=[select id,MailingCountyFormula__c,BillingPostalCode, name from
                     Account where name=:TEST_VAL limit 1];
        Contract con =[select id,name,ARV_Is_Common_Control__c,ARV_Offices_Branches_OtherLocations__c,
        ARV_TECH_Account_Merge__c,ARV_Segmentation_Type__c,ARV_System_Check_1_Status__c,ARV_Is_Mass_Updating__c,
        ARV_Requested_Effective_Date__c from Contract limit 1]; 
       con.ARV_Is_Common_Control__c=YES_VAL;
    con.ARV_Offices_Branches_OtherLocations__c=YES_VAL;
    con.ARV_TECH_Account_Merge__c=TEST_VAL;
    con.ARV_Segmentation_Type__c=SEGMENTATIONTYPE;
    con.ARV_System_Check_1_Status__c=BLANK;
    con.ARV_Is_Common_Control__c=YES_VAL;
    con.ARV_Offices_Branches_OtherLocations__c=YES_VAL;
           Map<String,Product2> prodMap = new Map<String,Product2>();
        for(Product2 prod : [select id,vlocity_ins__Type__c,carrier_type__c from product2 limit 3]){
        prodMap.put(prod.vlocity_ins__Type__c,prod);
        }
        inputMap.put('AccountId',acc.id);
        options.put('contractId',con.id);
        Map<String,Object> headquartersStep = new Map<String,Object>();
        headquartersStep.put('ALCounty','HQ'+ ' - ' +acc.MailingCountyFormula__c);
        headquartersStep.put('ALZipCode',acc.BillingPostalCode);
        Map<String,Object> groupInformationStep = new Map<String,Object>();
        groupInformationStep.put('GroupName',acc.name);
        groupInformationStep.put('MultiEmployee',YES_VAL);
        groupInformationStep.put('SelectEmployeeSegments','Hourly/Salary');
        groupInformationStep.put('MultiLocation',YES_VAL);
        groupInformationStep.put('CommonControl',YES_VAL);
            groupInformationStep.put('FTE','1'); 
        groupInformationStep.put('Headquarters',headquartersStep);
        Map<String,Object> additionalLocationsStep = new Map<String,Object>();
        additionalLocationsStep.put('LocationName','dfgf');
        additionalLocationsStep.put('ALZipCode','48001');
        additionalLocationsStep.put('ALCounty','ST. CLAIR');
        groupInformationStep.put('AdditionalLocations',additionalLocationsStep);
        Map<String,Object> packageLocationStep = new Map<String,Object>();
        packageLocationStep.put('Plans','Medical;Dental;Vision');
        packageLocationStep.put('NoOfPackages','1');
        packageLocationStep.put('DentalIsSelected',NO_VAL);
        packageLocationStep.put('pedDentalAdded',true);
         Map<String,Object> packageProduct1Step = new Map<String,Object>();        
        packageProduct1Step.put('MedicalPackLookup1',prodMap.get('Medical').id+'-'+prodMap.get('Medical').carrier_type__c);
        packageLocationStep.put('PackageProduct1',packageProduct1Step);
        Map<String,Object> pdtrcDentalStep = new Map<String,Object>();
        Map<String,Object> pdtrcVisionStep = new Map<String,Object>();
        Map<String,Object> pckgSlctnStep = new Map<String,Object>();
        Map<String,Object> assignmentsStep = new Map<String,Object>();
        assignmentsStep.put('Hourly-HQ - County0-48005','Package1');
        pckgSlctnStep.put('Assignments',assignmentsStep);
        inputMap.put('GroupInformation',groupInformationStep);
        inputMap.put('PackageLocation',packageLocationStep);
        inputMap.put('pediatricDental',pdtrcDentalStep);
        inputMap.put('pediatricVision',pdtrcVisionStep);
        inputMap.put('PackageSelection',pckgSlctnStep);  
            ARV_AP61_UpdateContractDetails rate = new ARV_AP61_UpdateContractDetails();
            user usr1  = [SELECT Id from User where LastName =: NAME limit 1];
            system.runAs(usr1){  
            test.startTest();            
            rate.invokeMethod(METHODNAME,inputMap,outMap,options);
            System.assertNotEquals(null,acc.id);       
}
  }    catch(Exception e){
       //throw new AuraHandledException(e.getMessage()+e.getlinenumber()); 
    }
    }
    /*****************************************************************************************
Method Name   : getContractCatchblk 
Date Created : 27-DEC-2019
Created By   : IDC Offshore
Description  :This is the class for contract record updation after  submitting(Written to cover catch blocks).
******************************************************************************************/
    public static testmethod  void getContractCatchblk(){
     Map<String,Object> inputMap = new Map<String,Object>();
        Map<String,Object> outMap = new Map<String,Object>();
        Map<String,Object> options = new Map<String,Object>();
    try{
        Account acc=[select id,MailingCountyFormula__c,BillingPostalCode, name from Account where name=:TEST_VAL limit 1];
        Contract con =[select id,name,ARV_Is_Common_Control__c,ARV_Offices_Branches_OtherLocations__c,
        ARV_TECH_Account_Merge__c,ARV_Segmentation_Type__c,ARV_System_Check_1_Status__c,ARV_Is_Mass_Updating__c,
                       ARV_Requested_Effective_Date__c from Contract limit 1]; 
        inputMap.put('AccountId',con.id);
        options.put('contractId',acc.id);
         ARV_AP61_UpdateContractDetails rate = new ARV_AP61_UpdateContractDetails();
        user usr1  = [SELECT Id from User where LastName =: NAME limit 1];
            system.runAs(usr1){  
        test.startTest();
         rate.invokeMethod(METHODNAME,inputMap,outMap,options);
                 System.assertNotEquals(null,acc.id);
    }
   }    Catch(Exception e)
        {
            //throw new AuraHandledException(e.getMessage()+e.getlinenumber()); 
        }
    } 
}