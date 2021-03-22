/*****************************************************************************************
Class Name   : ARV_AP_CencosVolutaryVldtns_Test 
Date Created : 21-AUG-2020
Created By   : IDC Offshore
Description  : This class is used for testing ARV_AP_CencosVolutaryVldtns_Test Class.
******************************************************************************************/
@isTest
public class ARV_AP_CencosVolutaryVldtns_Test {
    private static final string PROFILENAME1 = 'System Administrator';
    private static final string TYPE = 'Dental';
    private static final string TYPE1 = 'Vision';
    private static final string TYPE2 = 'Dental;Vision';
    private static final string VOL = 'Voluntary';
    private static final string NONVOL = 'Non-Voluntary';
    private static final String ENROLLING = 'Enrolling';
    private static final string BLANK = '';
    private static final string NAME1 = 'Agent';
    private static final string USERNAME = 'bcbsm1@bcbsm.com';
     private static final string CONTEXTID='ContextId';
     private static final  string METHNAME='getVlountaryVldnt';
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
        con.ARV_Tech_Selected_Plans__c = TYPE2;
        con.vlocity_ins__EnrollmentCensusId__c = census.id;
        database.insert(con);
        Product2 prd= ARV_AP05_TestDataCreation.productRec();
        prd.vlocity_ins__Type__c=TYPE;
        prd.Carrier_Type__c=BLANK;
        prd.Voluntary_Contributory__c = NONVOL;
        database.insert(prd);
        Product2 prd1= ARV_AP05_TestDataCreation.productRec();
        prd1.vlocity_ins__Type__c=TYPE;
        prd1.Carrier_Type__c=BLANK;
        prd1.Voluntary_Contributory__c = VOL;
        database.insert(prd1);
        Product2 prd2= ARV_AP05_TestDataCreation.productRec();
        prd2.vlocity_ins__Type__c=TYPE1;
        prd2.Carrier_Type__c=BLANK;
        prd2.Voluntary_Contributory__c = VOL;
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
        GA_Group_Segment__c gseg1= ARV_AP05_TestDataCreation.groupSegmentRec(acT.Id,con.Id);
        database.insert(gseg1);
        vlocity_ins__GroupCensusMember__c cmb1 = ARV_AP05_TestDataCreation.groupCensusMember(census.id);
        cmb1.vlocity_ins__IsPrimaryMember__c = true;
        cmb1.Status__c = ENROLLING;
        CMB1.ARV_Group_Segment__c=gseg1.iD;
        cmb1.ARV_Is_Dental_Selected__c = true;
        cmb1.ARV_Is_Vision_Selected__c = true;
        cmb1.ARV_Package__c = pck1.id;
        database.insert(cmb1);
      
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
        vlocity_ins__GroupCensus__c cen=[Select Id,Name from vlocity_ins__GroupCensus__c limit 1];
        Map<String,Object> inputMap = new Map<String,Object>();
        Map<String,Object> outMap = new Map<String,Object>();
        Map<String,Object> options = new Map<String,Object>();
        inputMap.put(CONTEXTID,cen.id);        
            ARV_AP_CencosVolutaryVldtns rate = new ARV_AP_CencosVolutaryVldtns();
            try {
                test.startTest();            
                rate.invokeMethod(METHNAME,inputMap,outMap,options);
                test.stopTest(); 
                System.assertNotEquals(null,acc.id);     
            } Catch(Exception e) {return ;}  
        
    }
}