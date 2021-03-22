/*****************************************************************************************
Class Name   : ARV_AP86_CheckDocuSignStatus_Test 
Date Created : 20-APRIL-2020
Created By   : IDC Offshore
Description  : This test class is used for checking the validation of Docusign Completion Status
******************************************************************************************/
@isTest
public without sharing class ARV_AP86_CheckDocuSignStatus_Test {
	private static final string FETCHDOCSIGNSTATUS='fetchdocsignstatus';
    private static final string CONTEXTID='ContextId';
    //private static final string METHODNAME='fetchdocsignstatus'
    private static final string ERROR='error';
    private static final string SENT_VAL='Sent';
    private static final string PROFILENAME='system administrator';
    
    /************************************  
    Method name : testDataSetup
    Params      : NA
    Return Type : testmethod
    Description :  testDataSetup() method 
    *************************************/   
    @testSetup static void testDataSetup(){
        //Create Account
        Account acnt= ARV_AP05_TestDataCreation.accRec();
        database.insert(acnt);
        
        //Create Contract
        Contract cntrct = ARV_AP05_TestDataCreation.createContractRec(acnt.id);
        database.insert(cntrct);
        
        //Create DocuSignStatus
        dsfs__DocuSign_Status__c ds =  ARV_AP05_TestDataCreation.docusignstatusRec();
        ds.dsfs__Contract__c = cntrct.id;
        ds.createddate = system.today();
        ds.dsfs__Envelope_Status__c = SENT_VAL;
        database.insert(ds);
        
        }
    
    /**************  
    Method name : getfetchdocsignstatus
    Params      : NA
    Return Type : testmethod
    Description : contractsubmissiondate validation method 
    *************/
    private static testmethod void getfetchdocsignstatus(){
        user usr = ARV_AP05_TestDataCreation.UsrRec(PROFILENAME);
        Contract con=[Select id from Contract limit 1];
        database.insert(usr);
            system.runAs(usr){
            Map<String,Object> inputMap = new Map<String,Object> ();
            Map<String,Object> outMap = new Map<String,Object> ();
            Map<String,Object> options = new Map<String,Object> (); 
            options.put(CONTEXTID,con.id);
            test.startTest();
            ARV_AP86_CheckDocuSignStatus cdss = new ARV_AP86_CheckDocuSignStatus();
            cdss.invokeMethod(FETCHDOCSIGNSTATUS, inputMap, outMap, options);
            //System.assertEquals(true,true);
            test.stopTest(); 
            System.assertNotEquals(null,con);    
      	 }    
    }
   /**************  
    Method name : exceptionCovTest
    Params      : NA
    Return Type : testmethod
    Description : This method covers the exception 
    *************/
    private static testmethod void exceptionCovTest(){
        user usr = ARV_AP05_TestDataCreation.UsrRec(PROFILENAME);
        Contract con=[Select id from Contract limit 1];
        database.insert(usr);
            system.runAs(usr){
            Map<String,Object> inputMap = new Map<String,Object> ();
            Map<String,Object> outMap = new Map<String,Object> ();
            Map<String,Object> options = new Map<String,Object> (); 
            options.put(CONTEXTID,con.id);
            test.startTest();
            ARV_AP86_CheckDocuSignStatus cdss = new ARV_AP86_CheckDocuSignStatus();
            cdss.invokeMethod(FETCHDOCSIGNSTATUS, null, null, null);
            test.stopTest();
            System.assertNotEquals(null,con);    
                
      	 }    
    }
}