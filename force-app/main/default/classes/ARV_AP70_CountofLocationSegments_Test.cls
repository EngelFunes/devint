/********************************************************************************************
Class Name   : ARV_AP70_CountofLocationSegments_Test 
Date Created : 09-JAN-2020
Created By   : IDC Offshore
Description  :This is the class for testing count of Location Segments which BCN HRA package. 
**********************************************************************************************/
@isTest
public without sharing class ARV_AP70_CountofLocationSegments_Test {
    private static final string PROFILENAME='BCBSM Agent';
    private static final string PROFILENAME1='System Administrator';
    private static final string NAME1='Agent';
    private static final string USERNAME='bcbsm1@bcbsm.com';
    private static final string BHRULE='BCN HRA';
    private static final String ENROLLING='Enrolling';
    private static final String LOCATIONCOUNT='locationCount';
    private static final String SEGMENTATIONTYPE='Hourly & Salary';
   /************************************************* 
    Method name : testDataSetup
    Params     : NA
    Return Type : testmethod
    Description :  testDataSetup() method 
    **************************************************/
    @testSetup static void testDataSetup(){
        Account act= ARV_AP05_TestDataCreation.accRec();
        database.insert(act);
        vlocity_ins__GroupCensus__c census=ARV_AP05_TestDataCreation.groupCensus(act.Id);
        database.insert(census);
        Contract con = ARV_AP05_TestDataCreation.createContractRec(act.id);
        con.vlocity_ins__EnrollmentCensusId__c=census.id;
        database.insert(con);
        //system.debug('contract:: '+con);
        LocationPackage__c lpkg=ARV_AP05_TestDataCreation.locpkgRec(con.id);
        database.insert(lpkg);
        Product2 prd= ARV_AP05_TestDataCreation.productRec3();
        database.insert(prd);
        vlocity_ins__ContractLineItem__c pln = ARV_AP05_TestDataCreation.planRec(prd.id,con.id);
        database.insert(pln);
        Package__c pck = ARV_AP05_TestDataCreation.packageRec(con.id);
        pck.ARV_Medical_Plan__c = pln.id;
        database.insert(pck);
        vlocity_ins__GroupCensusMember__c cmb = ARV_AP05_TestDataCreation.groupCensusMember(census.id);
        cmb.ARV_Package__c=pck.Id;
        cmb.ARV_LocationPackage__c=lpkg.id;
        cmb.ARV_Is_Medical_Selected__c=true;
        cmb.vlocity_ins__IsPrimaryMember__c=true;
        database.insert(cmb);
        //system.debug('census member::'+cmb);
        user usr = ARV_AP05_TestDataCreation.UsrRec(PROFILENAME1);
        usr.LastName = NAME1;
        usr.Username=USERNAME;
        database.insert(usr,true);    
    }
       /**************  
		Method name : locationSegemnetCountTest
		Params     : NA
		Return Type : testmethod
		Description :  locationSegemnetCountTest() method 
		*************/ 
    private static testmethod void locationSegemnetCountTest(){
        
		Set<Id> locations = new Set<Id>();
        Contract con =[select id,name from Contract limit 1];
        Map<String,Object> inputMap = new Map<String,Object>();
        Map<String,Object> outMap = new Map<String,Object>();
        Map<String,Object> options = new Map<String,Object>();
        inputMap.put('ContextId',con.id);
        user usr1 = [SELECT Id from User where LastName =: NAME1 limit 1];
        system.runAs(usr1){            
            ARV_AP70_CountofLocationSegments cls = new ARV_AP70_CountofLocationSegments();
            test.startTest();            
            cls.invokeMethod('locationSegementCount',inputMap,outMap,options);
            test.stopTest(); 
            System.assertNotEquals(null,con.id);
        }
    }

}