/*****************************************************************************************
Class Name   : ARV_AP82_contractRelatedList_Test 
Date Created : 14-FEB-2020
Created By   : IDC Offshore
Description  : This class is used for testing ARV_AP82_contractRelatedList Class.
******************************************************************************************/
@isTest
public class ARV_AP82_contractRelatedList_Test {
    
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
        database.insert(cntrct); 
        User usr = ARV_AP05_TestDataCreation.UsrRec(PROFILENAME);
        database.insert(usr);
    }
    /**************  
    Method name : testContractRL
    Params      : NA
    Return Type : void
    Description : testDataSetup() method 
    *************/
    static testMethod void testContractRL() {
        User usr1 = [Select id from User LIMIT 1];
        system.runAs(usr1) {
            Test.startTest();
            Contract con = [select Id from Contract LIMIT 1];
            ARV_AP82_contractRelatedList.getRelatedContracts(con.id);
            system.assertNotEquals(null, con.id);
            Test.stopTest();
        }  
    }
}