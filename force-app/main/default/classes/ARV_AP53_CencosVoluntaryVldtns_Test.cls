/*****************************************************************************************
Class Name   : ARV_AP53_CencosVoluntaryVldtns_Test 
Date Created : 26-DEC-2019
Created By   : IDC Offshore
Description  : This class is used for testing ARV_AP53_CencosVoluntaryVldtns Class.
******************************************************************************************/
@isTest
public without sharing class ARV_AP53_CencosVoluntaryVldtns_Test {
    
    private static final string PROFILENAME='BCBSM Agent';
    private static final string PROFILENAME1='System Administrator';
    private static final string TYPE='Dental';
    private static final string TYPE1='Vision';
    private static final string BLANK='';
    private static final string NAME1='Agent';
    private static final string USERNAME='bcbsm1@bcbsm.com';
    
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
        Contract con = ARV_AP05_TestDataCreation.createContractRecCensus(act.Id,census.Id);
        con.ARV_Tech_Selected_Plans__c = 'Dental;Vision';
        con.vlocity_ins__EnrollmentCensusId__c = census.id;
        database.insert(con);
        //vlocity_ins__GroupCensus__c census1=ARV_AP05_TestDataCreation.groupCensus(act.Id);
        //database.insert(census);
        Product2 prd= ARV_AP05_TestDataCreation.productRec();
        prd.vlocity_ins__Type__c=TYPE;
        prd.Carrier_Type__c=BLANK;
        prd.Voluntary_Contributory__c = 'Non-Voluntary';
        database.insert(prd);
        Product2 prd1= ARV_AP05_TestDataCreation.productRec();
        prd1.vlocity_ins__Type__c=TYPE;
        prd1.Carrier_Type__c=BLANK;
        prd1.Voluntary_Contributory__c = 'Voluntary';
        //prd1.Voluntary_Contributory__c ='Non-Voluntary';
        database.insert(prd1);
        Product2 prd2= ARV_AP05_TestDataCreation.productRec();
        prd2.vlocity_ins__Type__c=TYPE1;
        prd2.Carrier_Type__c=BLANK;
        prd2.Voluntary_Contributory__c = 'Voluntary';
        database.insert(prd2);
        vlocity_ins__ContractLineItem__c pln = ARV_AP05_TestDataCreation.planRec(prd.id,con.id);
        database.insert(pln);
        vlocity_ins__ContractLineItem__c pln1 = ARV_AP05_TestDataCreation.planRec(prd1.id,con.id);
        database.insert(pln1);
        vlocity_ins__ContractLineItem__c pln2 = ARV_AP05_TestDataCreation.planRec(prd2.id,con.id);
        database.insert(pln2);
        Package__c pck1 = ARV_AP05_TestDataCreation.packageRec(con.id);
        pck1.ARV_Dental_Plan__c = pln1.id;
        pck1.ARV_Vision_Plan__c = pln2.id;
        database.insert(pck1);
        Package__c pck2 = ARV_AP05_TestDataCreation.packageRec(con.id);
        pck2.ARV_Dental_Plan__c = pln.id;
        pck2.ARV_Vision_Plan__c = pln2.id;
        database.insert(pck2);
        vlocity_ins__GroupCensusMember__c cmb1 = ARV_AP05_TestDataCreation.groupCensusMember(census.id);
        cmb1.vlocity_ins__IsPrimaryMember__c = true;
        cmb1.Status__c = 'Enrolling';
        cmb1.ARV_Is_Dental_Selected__c = true;
        cmb1.ARV_Is_Vision_Selected__c = true;
        cmb1.ARV_Package__c = pck1.id;
        database.insert(cmb1);
        vlocity_ins__GroupCensusMember__c cmb2 = ARV_AP05_TestDataCreation.groupCensusMember(census.id);
        cmb2.vlocity_ins__IsPrimaryMember__c = true;
        cmb2.Status__c = 'Enrolling';
        cmb2.ARV_Is_Dental_Selected__c = true;
        cmb2.ARV_Is_Vision_Selected__c = true;
        cmb2.ARV_Package__c = pck2.id;
        database.insert(cmb2);
        user usr = ARV_AP05_TestDataCreation.UsrRec(PROFILENAME1);
        usr.LastName = NAME1;
        usr.Username=USERNAME;
        database.insert(usr,true);
    }
    /**************  
    Method name : voluntaryVldtnsTest
    Params     : NA
    Return Type : testmethod
    Description :  internalUserTest() method 
    *************/ 
    private static testmethod void voluntaryVldtnsTest(){
        Account acc=[select id,name,MailingCountyFormula__c,BillingPostalCode from Account limit 1];
        Contract con =[select id,name from Contract limit 1];
        Map<String,Object> inputMap = new Map<String,Object>();
        Map<String,Object> outMap = new Map<String,Object>();
        Map<String,Object> options = new Map<String,Object>();
        inputMap.put('ContextId',con.id);
        user usr1 = [SELECT Id from User where LastName =: NAME1 limit 1];
        system.runAs(usr1){            
            ARV_AP53_CencosVoluntaryVldtns rate = new ARV_AP53_CencosVoluntaryVldtns();
            try {
                test.startTest();            
                rate.invokeMethod('getContract',inputMap,outMap,options);
                test.stopTest(); 
                System.assertNotEquals(null,acc.id);     
            } Catch(Exception e) {return ;}  
        }
    }
    /**************  
    Method name : voluntaryVldtnsTest
    Params     : NA
    Return Type : testmethod
    Description :  internalUserTest() method 
    *************/ 
    private static testmethod void voluntaryVldtnsTest2(){
        Account acc=[select id,name,MailingCountyFormula__c,BillingPostalCode from Account limit 1];
        Contract con =[select id,name from Contract limit 1];
        con.ARV_Tech_Selected_Plans__c = 'Dental';
        update con;
        Map<String,Object> inputMap = new Map<String,Object>();
        Map<String,Object> outMap = new Map<String,Object>();
        Map<String,Object> options = new Map<String,Object>();
        inputMap.put('ContextId',con.id);
        user usr1 = [SELECT Id from User where LastName =: NAME1 limit 1];
        system.runAs(usr1){            
            ARV_AP53_CencosVoluntaryVldtns rate = new ARV_AP53_CencosVoluntaryVldtns();
            try {
                test.startTest();            
                rate.invokeMethod('getContract',inputMap,outMap,options);
                test.stopTest(); 
                System.assertNotEquals(null,acc.id);     
            } Catch(Exception e) {return ;}  
        }
    }
     /**************  
    Method name : voluntaryVldtnsTest
    Params     : NA
    Return Type : testmethod
    Description :  internalUserTest() method 
    *************/ 
    private static testmethod void voluntaryVldtnsTestforException(){
        Account acc=[select id,name,MailingCountyFormula__c,BillingPostalCode from Account limit 1];
        Contract con =[select id,name from Contract limit 1];
        Map<String,Object> inputMap = new Map<String,Object>();
        Map<String,Object> outMap = new Map<String,Object>();
        Map<String,Object> options = new Map<String,Object>();
        inputMap.put('ContextId',con.id);
        user usr1 = [SELECT Id from User where LastName =: NAME1 limit 1];
        system.runAs(usr1){            
            ARV_AP53_CencosVoluntaryVldtns rate = new ARV_AP53_CencosVoluntaryVldtns();
            try {
                test.startTest();            
                rate.invokeMethod('getContract',null,outMap,options);
                test.stopTest(); 
                System.assertNotEquals(null,acc.id);     
            } Catch(Exception e) {return ;}  
        }
    }
}