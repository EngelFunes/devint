/*****************************************************************************************
Class Name   : ARV_AP_GroupWideChanges_Test 
Date Created : 30-September-2019
Created By   : IDC Offshore
Description  : This class is used for testing ARV_AP_GroupWideChange
******************************************************************************************/
@isTest
public class ARV_AP_GroupWideChanges_Test {
    public static ID AccountTypeid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Agency').getRecordTypeId(); 
    public static  final string ACCNAME='Test Account';
    public static  final string ISACTIVE='Active';
    public static  final string TDD='TDD Solutions';
    public static  final strinG TAA='TA';
    /**************  
Method name : ARV_AP_GroupWideChangesTestMethod
Params     : NA
Return Type : NA
Description :  ARV_AP_GroupWideChangesTestMethod() method
*************/
    public static testmethod void ARV_AP_GroupWideChangesTestMethod(){
        Account acc = new Account();
        acc.RecordTypeID = AccountTypeid;
        acc.Name = ACCNAME;
        acc.Account_Status__c = ISACTIVE;
        acc.Managing_Agent__c = TDD;
        acc.GA_Agency_Code__c = TAA;
        insert acc;
        Test.startTest();
        List<Contract> newTableOne = new List<Contract>();
        newTableOne = ARV_AP_GroupWideChanges.getGWCContracts(acc.Id);
        List<ARV_Gwc_Transaction_Table__c> newTableTwo = new List<ARV_Gwc_Transaction_Table__c>();
        newTableTwo = ARV_AP_GroupWideChanges.getMaintananceChanges(acc.Id);
        system.assert(acc.Id!=null);
        Test.stopTest();
    }
}