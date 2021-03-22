/*
@Author : IDC offshore
@Name: ARV_AP_DeleteContract_Test 
@CreatedDate: 1 Dec 2020 
@Description: ARV_AP_DeleteContract_Test Test claSSSss
@version : 1.0  
*/
@isTest
public without sharing class ARV_AP_DeleteContract_Test {
     private static final string PROFILENAME='system administrator';
    private static final string METHODNAME='deletecontractoncancel';
/**************  
    Method name : testDataSetup
    Params     : NA
    Return Type : testmethod
    Description :  testDataSetup() method 
    *************/   
    @testSetup static void testDataSetup(){
        
       //Create County
      // List<GA_County_Code__c> countyList = ARV_AP05_TestDataCreation.createCounties(1);
       //database.insert(countyList);
       //System.debug('County is created '+countyList[0]);
        
        //Create Account
        Account acnt= ARV_AP05_TestDataCreation.accRec();
        //acnt.GA_Mailing_County_id__c = countyList[0].id;
        database.insert(acnt);
        //System.debug('Account is created '+acnt);
        //System.debug('R R D is '+acnt.ARV_Requested_Renewal_Date__c);
        
        
        //Create a Contract
       
        Contract cntrct = ARV_AP05_TestDataCreation.createContractRec(acnt.id);
       // cntrct.ARV_TECH_SubmissionDate__c=Date.newInstance(2020, 01, 21);
       // cntrct.ARV_Requested_Effective_Date__c = Date.newInstance(2020, 02, 1);//System.today().addMonths(1).toStartOfMonth();
        //System.debug('::Effective date::'+cntrct.ARV_Requested_Effective_Date__c);
        database.insert(cntrct);
        
    }   
        /**************  
    Method name : getContractSubmitDate
    Params     : NA
    Return Type : testmethod
    Description :  contractsubmissiondate validation method 
    *************/          
    private static testmethod void getContractSubmitDate(){
        user usr = ARV_AP05_TestDataCreation.UsrRec(PROFILENAME);
        database.insert(usr);
        system.runAs(usr){
        Map<String,Object> inputMap = new Map<String,Object> ();
        Map<String,Object> outMap = new Map<String,Object> ();
        Map<String,Object> options = new Map<String,Object> (); 
         
            list<contract> conlist=[select id from Contract LIMIT 1];
            inputMap.put('contractId',conlist[0].id);
            system.debug('inputmap::'+inputMap);
       // Contract con=cntrctlist[0];
        //string subdate=String.valueOf(con.ARV_TECH_SubmissionDate__c);
        //String submitDate =subdate!=null?subdate:String.valueOf(system.today()) ;
       // String effectiveDate = String.valueOf(con.ARV_Requested_Effective_Date__c);
       // inputMap.put('contractId',con.Id);
        ARV_AP_DeleteContract del = new ARV_AP_DeleteContract();
        del.invokeMethod(METHODNAME, inputMap, outMap, options);
        del.deletecontractoncancel(inputMap, outMap, options);
        //del.disableSubmission(submitDate,effectiveDate);
        //System.assertNotEquals(null,con.Id);
        	
       }
    }
            
}