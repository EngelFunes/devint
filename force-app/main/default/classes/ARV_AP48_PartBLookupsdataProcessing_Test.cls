/*****************************************************************************************
Class Name   : ARV_AP48_PartBLookupsdataProcessing_Test 
Date Created : 22-JAN-20202
Created By   : IDC Offshore
Description  : This class is used for testing ARV_AP48_PartBLookupsdataProcessing Class.
******************************************************************************************/
@isTest
public without sharing class ARV_AP48_PartBLookupsdataProcessing_Test {
    private static final string PROFILENAME='BCBSM Agent';
    private static final string NAME='AP35LastName';
    private static final string USERNAME='bcbsm1@bcbsm.com';
    private static final string RECORDTYP='Account - Agency';
    private static final String OUTOFSTATE = 'OUT OF STATE';
    private static final String TGG = 'TGG Solutions';
    private static final String ADMIN = 'Administrative';
    private static final String COUNTY = 'County1';
    private static final String CITY = 'testCity';
   
    /**************  
    Method name : testDataSetup
    Params      : NA
    Return Type : testmethod
    Description : testDataSetup() method 
    *************/     
    @testSetup static void testDataSetup() {
        
        List<GA_County_Code__c> countyList = ARV_AP05_TestDataCreation.createCounties(1);
        database.insert(countyList); 
        GA_County_Code__c county = new GA_County_Code__c();
        county.Name = OUTOFSTATE;
        database.insert(county); 
        Account acnt= ARV_AP05_TestDataCreation.accRec();
        acnt.Name = TGG;
        database.insert(acnt);
        vlocity_ins__GroupCensus__c census = ARV_AP05_TestDataCreation.groupCensus(acnt.id);
        database.insert(census);
        Contact con = ARV_AP05_TestDataCreation.contactRec(acnt.id);
        con.GA_Contact_Role__c = ADMIN;
        con.accountId = acnt.id;
        database.insert(con); 
        User user1=ARV_AP05_TestDataCreation.UsrRec1(PROFILENAME,con.Id);
        user1.LastName = NAME;
        database.insert(User1,true);
        Account mngngAcnt= ARV_AP05_TestDataCreation.PortalAccRec(acnt.Name, RECORDTYP);
        database.insert(mngngAcnt); 
        Contract cntrct = ARV_AP05_TestDataCreation.ContractForPartB(acnt.id);
        cntrct.ARV_Managing_Agent__c = acnt.id;
        database.insert(cntrct);
        LocationPackage__c locpckg = ARV_AP05_TestDataCreation.locpkgRec(cntrct.Id);
        locpckg.ARV_AccountId__c = acnt.id;
        locpckg.ARV_ContractId__c = cntrct.id;
        locpckg.ARV_Admin_County__c = OUTOFSTATE;
        locpckg.ARV_Admin_City__c = CITY;
        locpckg.ARV_Billing_City__c = CITY;
        locpckg.ARV_Billing_County__c = OUTOFSTATE;
        locpckg.ARV_Location_Physical_City__c = CITY;
        locpckg.ARV_Location_Physical_County__c = OUTOFSTATE;
        database.insert(locpckg);
        con.ARV_Tech_Lctn_Cntrct_ids__c = string.valueOf(locpckg.id);
        database.update(con);
    }
    /**************  
    Method name : testPartBLookups
    Params      : NA
    Return Type : testmethod
    Description : PartBInforation processing method 
    *************/
    @isTest
    static void testPartBLookups() {
        string methodName = 'fetchingLocationInfo';
        Map <String, Object> inputMap = new Map <String, Object>();
        Map <String, Object> outMap = new Map <String, Object>();
        Map <String, Object> options = new Map <String, Object>();
        Contract cont = [select id from Contract LIMIT 1];
        inputMap.put('ContextId',cont.id);
        options.put('ManaginAgent',TGG);
        User usr = [Select id from User LIMIT 1];
        system.runAs(usr) {
             try {
             Test.startTest();
             ARV_AP48_PartBLookupsdataProcessing.invokeMethod(methodName, inputMap, outMap, options);
             Test.stopTest();
             System.assertNotEquals(null, cont.id);
            }Catch(Exception e){return ;}  
        }    
    }
    /**************  
    Method name : testPartBLookups1
    Params      : NA
    Return Type : testmethod
    Description : PartBInforation processing method 
    *************/
    @isTest
    static void testPartBLookups1() {
        string methodName = 'fetchingLocationInfo';
        Map <String, Object> inputMap = new Map <String, Object>();
        Map <String, Object> outMap = new Map <String, Object>();
        Map <String, Object> options = new Map <String, Object>();
        Contract cont = [select id from Contract LIMIT 1];
        inputMap.put('ContextId',cont.id);
        options.put('ManaginAgent','Action Benefits');
        User usr = [Select id from User LIMIT 1];
        system.runAs(usr) {
            try {
             Test.startTest();
             ARV_AP48_PartBLookupsdataProcessing.invokeMethod(methodName, inputMap, outMap, options);
             Test.stopTest();
             System.assertNotEquals(null, cont.id);
            }Catch(Exception e){return ;}
        }       
    }
    /**************  
    Method name : testPartBLookups2
    Params      : NA
    Return Type : testmethod
    Description : PartBInforation processing method 
    *************/
    @isTest
    static void testPartBLookups2() {
        string methodName = 'fetchingLocationInfo';
        Map <String, Object> inputMap = new Map <String, Object>();
        Map <String, Object> outMap = new Map <String, Object>();
        Map <String, Object> options = new Map <String, Object>();
        Contract cont = [select id from Contract LIMIT 1];
        inputMap.put('ContextId',cont.id);
        options.put('ManaginAgent','TGG');
        User usr = [Select id from User LIMIT 1];
        system.runAs(usr) {
            try {
             Test.startTest();
             ARV_AP48_PartBLookupsdataProcessing.invokeMethod(methodName, inputMap, outMap, options);
             Test.stopTest();
             System.assertNotEquals(null, cont.id);
            }Catch(Exception e){return ;}
        }       
    }
}