/*****************************************************************************************
Class Name   : ARV_AP54_EnrollmentServiceGetRated_Test
Date Created : 18-Nov-2019
Created By   : IDC Offshore
Description  : --
******************************************************************************************/
@isTest
public without sharing class ARV_AP54_EnrollmentServiceGetRated_Test {
    private static final string USERNAME='bcbsm1@bcbsm.com';
    private static final string NAME='AP61LastName';
    private static final String CID='23';
    private static final String TEST_VAL='Test';
    private static final string BHRULE='BCN HRA';
    private static final string PROFILENAME='System Administrator';
    private static final string YES_VAL='Yes';
    private static final string NO_VAL='No';
    private static final string ENROLLING = 'Enrolling';
    private static final string MACOMB = 'Macomb';
    
    /************************************************* 
    Method name : testDataSetup1
    Params     : NA
    Return Type : testmethod
    Description :  testDataSetup1() method 
    **************************************************/   
    @testsetup static void testDataSetup1() { 
        GA_County_Code__c county= new GA_County_Code__c();
        county.name = MACOMB;
        database.insert(county);
        Account acc = new Account(name=TEST_VAL);
        acc.CID__c=CID;
        acc.GA_Mailing_County_id__c=county.id;
        database.insert(acc);
        vlocity_ins__GroupCensus__c  census =ARV_AP05_TestDataCreation.groupCensus(acc.id);
        database.insert(census);
        Contract con = ARV_AP05_TestDataCreation.createContractRec(acc.Id);
        con.vlocity_ins__EnrollmentCensusId__c=census.Id;
        con.ARV_Requested_Effective_Date__c=date.newInstance(2019,04,01);
        database.insert(con);
        LocationPackage__c locPkg=new LocationPackage__c();
        locPkg.ARV_ContractId__c=con.Id;
        database.insert(locPkg);
        Package__c pckg1= ARV_AP05_TestDataCreation.packageRec(con.Id);
        pckg1.ARV_Contract_Id__c=con.Id;
        database.insert(pckg1);
        Package_Location_Segment_Rel__c plsr= new Package_Location_Segment_Rel__c();
        plsr.Location_Segment__c=locPkg.Id;
        plsr.Package__c=pckg1.Id;
        plsr.Contract__c=con.Id;
        database.insert(plsr);
        Product2 prd1= ARV_AP05_TestDataCreation.productRec();
        prd1.Family=BHRULE;
        database.insert(prd1);
        vlocity_ins__ContractLineItem__c  plan= ARV_AP05_TestDataCreation.planRec(prd1.id,con.Id);
        database.insert(plan);
        vlocity_ins__GroupCensusMember__c cenmem=ARV_AP05_TestDataCreation.groupCensusMember(census.Id);
        cenmem.Status__c = ENROLLING;
        cenmem.ARV_Census_Member_Selected_Package__c = plsr.id;
        database.insert(cenmem);
        vlocity_ins__GroupCensusMember__c cenmem1=ARV_AP05_TestDataCreation.groupCensusMember(census.Id);
        cenmem1.Status__c = ENROLLING;
        database.insert(cenmem1);
        vlocity_ins__GroupCensusMemberPlan__c censmemplan = new vlocity_ins__GroupCensusMemberPlan__c();
        censmemplan.vlocity_ins__GroupCensusMemberId__c=cenmem.Id;
        censmemplan.vlocity_ins__ContractLineId__c=plan.Id;
        database.insert(censmemplan);
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
    public static testmethod  void getContractDetails1(){
        Map<String,Object> inputMap = new Map<String,Object>();
        Map<String,Object> outMap = new Map<String,Object>();
        Map<String,Object> options = new Map<String,Object>();
        Map<String,Product2> prodMap = new Map<String,Product2>();
        for(Product2 prod : [select id,vlocity_ins__Type__c,carrier_type__c from product2 limit 3]){
            prodMap.put(prod.vlocity_ins__Type__c,prod);
        }
        Account acc=[select id,MailingCountyFormula__c,BillingPostalCode, name from Account where name=:TEST_VAL limit 1];
        Contract con =[select id,name,ARV_Is_Common_Control__c,ARV_Offices_Branches_OtherLocations__c,
                       ARV_TECH_Account_Merge__c,ARV_Segmentation_Type__c,ARV_System_Check_1_Status__c,ARV_Date_Submitted__c
                       from Contract limit 1];
        //vlocity_ins__GroupCensusMember__c enrlcens=[select id from vlocity_ins__GroupCensusMember__c  limit 1];
        User usr = [select id from User LIMIT 1];
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
        system.runAs(usr) {
            try {
                //ARV_AP54_EnrollmentServiceGetRated obj2= new ARV_AP54_EnrollmentServiceGetRated();
                ARV_AP54_EnrollmentServiceGetRated.invokeMethod('deleteGCMP',inputMap,outMap,options);
            }
            Catch(Exception e) {throw new AuraHandledException(e.getMessage()+e.getlinenumber());}
        }  
        system.assertNotEquals(null, con.id);
    }   
    /*****************************************************************************************
Method Name   : getcontractdetails1 . 
Date Created : 27-DEC-2019
Created By   : IDC Offshore
Description  :This is the class for contract record updation after  submitting. 
*/
    public static testmethod  void getContractDetails2(){
        Map<String,Object> inputMap = new Map<String,Object>();
        Map<String,Object> outMap = new Map<String,Object>();
        Map<String,Object> options = new Map<String,Object>();
        inputMap.put('contractId',NULL);
        User usr = [select id from User LIMIT 1];
        system.runAs(usr) {
            //ARV_AP54_EnrollmentServiceGetRated obj1= new ARV_AP54_EnrollmentServiceGetRated();
            try{
                ARV_AP54_EnrollmentServiceGetRated.invokeMethod('deleteGCMP',null,outMap,options);
            }
            catch(exception e) { return;  }
        }
        system.assertEquals(null, null);
    }
    /*****************************************************************************************
Method Name   : getcontractdetails1 . 
Date Created : 27-DEC-2019
Created By   : IDC Offshore
Description  :This is the class for contract record updation after  submitting. 
*/
    public static testmethod  void getContractDetails3(){
        Map<String,Object> inputMap = new Map<String,Object>();
        Map<String,Object> outMap = new Map<String,Object>();
        Map<String,Object> options = new Map<String,Object>();
        inputMap.put('contractId',NULL);
        User usr = [select id from User LIMIT 1];
        system.runAs(usr) {
            //ARV_AP54_EnrollmentServiceGetRated obj1= new ARV_AP54_EnrollmentServiceGetRated();
            try {
                ARV_AP54_EnrollmentServiceGetRated.invokeMethod('getPids',null,outMap,options);
            } 
            catch(exception e) { return; }
        }
        system.assertEquals(null, null);
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
        Map<String,Product2> prodMap = new Map<String,Product2>();
        User usr = [select id from User LIMIT 1];        
        for(Product2 prod : [select id,vlocity_ins__Type__c,carrier_type__c from product2 limit 3]){
            prodMap.put(prod.vlocity_ins__Type__c,prod);
        }
        Account acc=[select id,MailingCountyFormula__c,BillingPostalCode, name from Account where name=:TEST_VAL limit 1];
        Contract con =[select id,name,ARV_Is_Common_Control__c,ARV_Offices_Branches_OtherLocations__c,
                       ARV_TECH_Account_Merge__c,ARV_Segmentation_Type__c,ARV_System_Check_1_Status__c,ARV_Date_Submitted__c,vlocity_ins__EnrollmentCensusId__c  
                       from Contract limit 1];
        vlocity_ins__GroupCensusMember__c enrlcens=[select id from vlocity_ins__GroupCensusMember__c limit 1];
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
        //inputMap.put('PackageLocation',packageLocationStep);
        inputMap.put('pediatricDental',pdtrcDentalStep);
        inputMap.put('pediatricVision',pdtrcVisionStep);
        inputMap.put('PackageSelection',pckgSlctnStep); 
        inputMap.put('ContractId',con.id);
        inputMap.put('enrollmentCensusId',con.vlocity_ins__EnrollmentCensusId__c);
        Map<String, Object> ipOutput1 = new Map<String, Object>();
        //Map<String, Object> ipOutput2 = new Map<String, Object>();
        Map<String, Object> ipOutputGRP1 = new Map<String, Object>();
        string json1 = '{"SG-Census-RF.SG_CM_Calculate":"true","SG-Census-RF.SG_CM_Age":25,"SG-Census-RF.Id":"'+enrlcens.id+'","SG-Census-RF.SG_CM_County":"Macomb","SG-Census-RF.SG_CM_Zip":"48005"}';
        object obb = json.deserializeUntyped(json1);
        String json2 = '{"RawPriceData":[{"aggregationResults":{},"calculationResults":[{"ID":"0","Id":"'+enrlcens.id+'","ProductNumber":"98185MI0250007"}]}],"totalSize":279}';
        object obb2 = json.deserializeUntyped(json2);
        list<object> lsob = new list<object>();
        lsob.add(obb2);
        ipOutput1.put('userInputs',obb);
        ipOutputGRP1.put('records',lsob);
        ARV_AP54_EnrollmentServiceGetRated.ipOutput = ipOutput1;
        ARV_AP54_EnrollmentServiceGetRated.ipOutputGRP = ipOutputGRP1;
        //ARV_AP54_EnrollmentServiceGetRated obj1= new ARV_AP54_EnrollmentServiceGetRated();
        system.runAs(usr) {   
            //obj1.invokeMethod('getPids',inputMap,outMap,options);
            try {
                ARV_AP54_EnrollmentServiceGetRated.invokeMethod('getPids',inputMap,outMap,options);
            } 
            catch(exception e) {throw new AuraHandledException(e.getMessage()+e.getlinenumber());}
        }
        system.assertNotEquals(null, con.id);
    }
}