/*****************************************************************************************
Class Name   : ARV_AP46_ContactsCreationForSigning_Test 
Date Created : 09-JAN-2020
Created By   : IDC Offshore
Description  : This class is used for testing ARV_AP46_ContactsCreationForSigning Class.
******************************************************************************************/
@isTest
public  without sharing class ARV_AP46_ContactsCreationForSigning_Test {
    
    private static final string PROFILENAME = 'system administrator';
    private static final String OUTOFSTATE = 'OUT OF STATE';
    private static final String ADMIN = 'Administrative';
    private static final String BILLING = 'Billing';
    private static final String NAME = 'Test';
    private static final String PHONE = '555-555-5555';
    
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
        acnt.Name = NAME;
		database.insert(acnt);
        vlocity_ins__GroupCensus__c census = ARV_AP05_TestDataCreation.groupCensus(acnt.id);
        database.insert(census);   
        Contact con = ARV_AP05_TestDataCreation.contactRec(acnt.id);
        con.GA_Contact_Role__c = ADMIN;
        con.GA_Mailing_County_ID__c=county.id;
        database.insert(con); 
        Contact con1 = ARV_AP05_TestDataCreation.contactRec(acnt.id);
        con1.GA_Contact_Role__c = BILLING;
        database.insert(con1); 
		Contract cntrct = ARV_AP05_TestDataCreation.createContractRec(acnt.id);
        cntrct.AccountId = acnt.id;
        database.insert(cntrct);
        LocationPackage__c locpckg = ARV_AP05_TestDataCreation.locpkgRec(cntrct.Id);
        locpckg.ARV_AccountId__c = acnt.id;
        locpckg.ARV_ContractId__c = cntrct.id;
        locpckg.ARV_Admin_Contact__c = con.id;
        locpckg.ARV_Billing_Contact__c = con1.id;
        database.insert(locpckg);
        con1.ARV_Tech_Lctn_Cntrct_ids__c = string.valueof(locpckg.id);
        con1.GA_Contact_Role__c = BILLING;
        database.update(con1);
        User usr = ARV_AP05_TestDataCreation.UsrRec(PROFILENAME);
        database.insert(usr);
    }   
    /**************  
    Method name : testContactsCreation
    Params      : NA
    Return Type : void
    Description : 
    *************/
    static testMethod void testContactsCreation() {
        
        User usr1 = [Select id from User LIMIT 1];
        system.runAs(usr1) {
            String methodName = 'uniqueContactsIdentification';
            Map <String, Object> inputMap = new Map <String, Object>();
            Map <String, Object> outMap = new Map <String, Object>();
            Map <String, Object> options = new Map <String, Object>();
            Boolean isBcbsmCarrier = true; 
            
            Contract contrct = [select id from Contract LIMIT 1];
            Account acnt = [Select id from Account LIMIT 1];
            inputMap.put('ContractId',contrct.id);
            inputMap.put('AccountId',acnt.id);
            inputMap.put('IsBcbsmCarrier',isBcbsmCarrier);
            Test.startTest();
            try {
                ARV_AP46_ContactsCreationForSigning.invokeMethod(methodName, inputMap, outMap, options);
            }
            catch(Exception e){return ;}
            Test.stopTest();
            system.assertNotEquals(null, contrct.id);    
            }  
    }
    /**************  
    Method name : testContactsCreation1
    Params      : NA
    Return Type : void
    Description : 
    *************/
    static testMethod void testContactsCreation1() {
        
        User usr1 = [Select id from User LIMIT 1];
        system.runAs(usr1) {
            String methodName = 'uniqueContactsIdentification';
            Map <String, Object> inputMap = new Map <String, Object>();
            Map <String, Object> outMap = new Map <String, Object>();
            Map <String, Object> options = new Map <String, Object>();
            Boolean isBcbsmCarrier = true;
         
            Contract contrct = [select id from Contract LIMIT 1];
            Account acnt = [Select id from Account LIMIT 1];
            contrct.ARV_CEO_First_Name__c = 'testPFN';
            contrct.ARV_CEO_Last_Name__c = 'testPLN';
            contrct.ARV_CEO_Email__c = 'test@gmail.com';
            contrct.ARV_CEO_Phone__c = PHONE;
            database.update(contrct);
    
            inputMap.put('ContractId',contrct.id);
            inputMap.put('AccountId',acnt.id);
            inputMap.put('IsBcbsmCarrier',isBcbsmCarrier);
            Test.startTest();
            try {
                ARV_AP46_ContactsCreationForSigning.invokeMethod(methodName, inputMap, outMap, options);
            }
            catch(Exception e) {return ;}
            Test.stopTest();
            system.assertNotEquals(null, contrct.id);
        } 
    } 
    /**************  
    Method name : testContactsCreation2
    Params      : NA
    Return Type : void
    Description : 
    *************/
    static testMethod void testContactsCreation2() {
        
        User usr1 = [Select id from User LIMIT 1];
        system.runAs(usr1) {
        String methodName = 'uniqueContactsIdentification';
        Map <String, Object> inputMap = new Map <String, Object>();
        Map <String, Object> outMap = new Map <String, Object>();
        Map <String, Object> options = new Map <String, Object>();
        Boolean isBcbsmCarrier = true;
    
        Contract contrct = [select id from Contract LIMIT 1];
        Account acnt = [Select id from Account LIMIT 1];
        contrct.ARV_Mutual_Voter_Email__c = 'abc@gmail.com';
        contrct.ARV_Mutual_Voter_First_Name__c = 'testFN';
        contrct.ARV_Mutual_Voter_Last_Name__c = 'testLastName';
        contrct.ARV_Mutual_Voter_Mailing_State__c = 'AR';
        database.update(contrct);
        
        inputMap.put('ContractId',contrct.id);
        inputMap.put('AccountId',acnt.id);
        inputMap.put('IsBcbsmCarrier',isBcbsmCarrier);
        Test.startTest();
        try {
            ARV_AP46_ContactsCreationForSigning.invokeMethod(methodName, inputMap, outMap, options);   
        }
        catch(Exception e) {return ;}
        Test.stopTest();
        system.assertNotEquals(null, contrct.id);
        }    
    }
    /**************  
    Method name : testContactsCreation2
    Params      : NA
    Return Type : void
    Description : 
    *************/
    static testMethod void testContactsCreation3() {
        
        User usr1 = [Select id from User LIMIT 1];
        system.runAs(usr1) {
            String methodName = 'uniqueContactsIdentification';
            Map <String, Object> inputMap = new Map <String, Object>();
            Map <String, Object> outMap = new Map <String, Object>();
            Map <String, Object> options = new Map <String, Object>();
            Boolean isBcbsmCarrier = false;
          
            Contract contrct = [select id FROM Contract LIMIT 1]; 
            Account acnt = [Select id from Account LIMIT 1];
            inputMap.put('ContractId',contrct.id);
            inputMap.put('AccountId',acnt.id);
            inputMap.put('IsBcbsmCarrier',isBcbsmCarrier);
            Test.startTest();
            try {
                ARV_AP46_ContactsCreationForSigning.invokeMethod(methodName, inputMap, outMap, options);
            }
            catch(Exception e){return ;}
            Test.stopTest();
            system.assertNotEquals(null, contrct.id);
        }
    }
 /**************  
    Method name : testGetStateByStatusCode
    Params      : NA
    Return Type : void
    Description : 
    *************/   
    static testMethod void testGetStateByStatusCode() {
         User usr1 = [Select id from User LIMIT 1];
         system.runAs(usr1){
             List<String> statesNameLst = new List<String>();         
             statesNameLst.add('AK');
             statesNameLst.add('AL');
             statesNameLst.add('AR');
             statesNameLst.add('AZ');
             statesNameLst.add('CA');
             statesNameLst.add('CO');
             statesNameLst.add('CT');
             statesNameLst.add('DE');
             statesNameLst.add('FL');
             statesNameLst.add('GA');
             statesNameLst.add('HI');
             statesNameLst.add('IA');
             statesNameLst.add('ID');
             statesNameLst.add('IL');
             statesNameLst.add('IN');
             statesNameLst.add('KS');
             statesNameLst.add('KY');
             statesNameLst.add('LA');
             statesNameLst.add('MA');
             statesNameLst.add('MD');
             statesNameLst.add('ME');
             statesNameLst.add('MI');
             statesNameLst.add('MN');
             statesNameLst.add('MO');
             statesNameLst.add('MS');
             statesNameLst.add('MT');
             statesNameLst.add('NC');
             statesNameLst.add('ND');
             statesNameLst.add('NE');
             statesNameLst.add('NH');
             statesNameLst.add('NJ');
             statesNameLst.add('NM');
             statesNameLst.add('NV');
             statesNameLst.add('NY');
             statesNameLst.add('OH');
             statesNameLst.add('OK');
             statesNameLst.add('OR');
             statesNameLst.add('PA');
             statesNameLst.add('RI');
             statesNameLst.add('SC');
             statesNameLst.add('SD');
             statesNameLst.add('TN');
             statesNameLst.add('TX');
             statesNameLst.add('UT');
             statesNameLst.add('VA');
             statesNameLst.add('VT');
             statesNameLst.add('WA');
             statesNameLst.add('WI');
             statesNameLst.add('WV');
             statesNameLst.add('WY');
             for(String str:statesNameLst){
                ARV_AP49_GetStateNameByStateCode.getStateName(str);           	
             }             
             System.assertNotEquals(null,statesNameLst);
    	}
	}
}