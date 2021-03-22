/*****************************************************************************************
Class Name   : ARV_SystemCheckReasons_Test 
Date Created : 13-FEB-2020
Created By   : IDC Offshore
Description  : This class is used for testing ARV_SystemCheckReasons Class.
******************************************************************************************/
@isTest
public class ARV_SystemCheckReasons_Test {
    
    private static final string STATUS = 'test';
    private static final string PROFILENAME = 'system administrator';
    /**************  
    Method name : testDataSetup
    Params      : NA
    Return Type : void
    Description : testDataSetup() method 
    *************/
    @testSetup static void testDataSetup() {
        
        Account acnt= ARV_AP05_TestDataCreation.accRec();
        database.insert(acnt);
        Contract cntrct = ARV_AP05_TestDataCreation.createContractRec(acnt.id);
        cntrct.ARV_System_Check_1_Status__c = STATUS;
        cntrct.ARV_GWC_System_Check_1_Status__c='Retro,GWC';
        database.insert(cntrct); 
        User usr = ARV_AP05_TestDataCreation.UsrRec(PROFILENAME);
        database.insert(usr);
    }
    
    /**************  
    Method name : checkReasons
    Params      : NA
    Return Type : void
    Description : testDataSetup() method 
    *************/
    static testMethod void checkReasons() {
        
        User usr1 = [Select id from User LIMIT 1];
        system.runAs(usr1) {
            Contract cont = [select id from Contract LIMIT 1];
            Test.startTest();
            ARV_SystemCheckReasons.getCheckValues(cont.id); 
            ARV_SystemCheckReasons.getGWCCheckValues(cont.id);
            Test.stopTest();
            system.assertEquals(STATUS, STATUS);
        }  
    }
}