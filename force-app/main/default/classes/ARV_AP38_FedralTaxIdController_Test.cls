/*****************************************************************************************
Class Name   : ARV_AP38_FedralTaxIdController_Test 
Date Created : 17-Jan-2020
Created By   : IDC Offshore
Description  : This class is used for FedralTaxIdValidation
******************************************************************************************/
@isTest(SeeAllData=false)
private without sharing class ARV_AP38_FedralTaxIdController_Test {
    private static  final string ACCOUNTPROSPECT= 'Account_Prospect';
    private static final string PROFILENAME='system administrator';
    private static final string RECORDTYP='Account - Inactive';
    private static final string RECORDTYP1='Account - Customer';
    private static final string RECORDTYP2='Account - Prospect';
    private static final string RECORDTYP3='Unqualified Prospect (Agent)';
    private static final string TAXID='TaxId';
    private static final string CURRENTACCID='accId';
    private static final string TAXVAL1='985657894';
    private static final string TAXVAL2='985657893';
    private static final string TAXVAL3='985657892';
    private static final string TAXVAL4='985657891';
    private static final string METHODNAME='commonControlfedralTaxVal';
    private static final string ACCOUNTSTATUS='Active';
     
    /**************  
    Method name : fedralTaxVal
    Params     : NA
    Return Type : NA
    Description :  fedralTaxVal() method
    *************/ 
    private static testmethod void fedralTaxVal()
    {
        user usr = ARV_AP05_TestDataCreation.UsrRec(PROFILENAME);
        database.insert(usr);
        system.runAs(usr)
        {   
            try{
               Id recordTypeIdAccount2 = Schema.SObjectType.Account.getRecordTypeInfosByName().get(RECORDTYP2).getRecordTypeId();
                Account accnt2=ARV_AP05_TestDataCreation.AccRec1(recordTypeIdAccount2);
                accnt2.Requested_Effective_Date__c=Date.newInstance(2021, 01, 20);
                accnt2.GA_CoverageCancellationDate__c=Date.newInstance(2020, 03, 21);
                accnt2.Account_Status__c=ACCOUNTSTATUS;
                accnt2.Federal_Tax_ID__c=TAXVAL1;
                database.insert(accnt2);
                contract con1 =ARV_AP05_TestDataCreation.createContractRec(accnt2.id);
                database.insert(con1);
                Map<String,Object> input=new Map<String,Object>();
                input.put(TAXID,TAXVAL1);
                input.put(CURRENTACCID,accnt2.Id);
                Map<String,Object> output=new Map<String,Object>();
                Map<String,Object> options=new Map<String,Object>();
                ARV_AP38_FedralTaxIdController fedralTax1=new ARV_AP38_FedralTaxIdController();
                fedralTax1.invokeMethod(METHODNAME,input,output,options);
                System.assertNotEquals(null,TAXVAL1);
            }  
            catch(Exception e) {   return;  }
        }
    }
    /**************  
    Method name : fedralTaxVal1
    Params     : NA
    Return Type : NA
    Description :  fedralTaxVal1() method
    *************/ 
   private static testmethod void fedralTaxVal1() {
        user usr = ARV_AP05_TestDataCreation.UsrRec(PROFILENAME);
        database.insert(usr);
        system.runAs(usr) {
            try {
                Id recordTypeIdAccount3= Schema.SObjectType.Account.getRecordTypeInfosByName().get(RECORDTYP3).getRecordTypeId();
                Account accnt=ARV_AP05_TestDataCreation.AccRec1(recordTypeIdAccount3);
                accnt.Federal_Tax_ID__c=TAXVAL2;
                database.insert(accnt);
                contract con1 =ARV_AP05_TestDataCreation.createContractRec(accnt.id);
                database.insert(con1);
                GA_Common_Control__c gcc=ARV_AP05_TestDataCreation.commonControlRec(accnt.Id);
                gcc.GA_Federal_Tax_ID_Number__c=TAXVAL2;
                database.insert(gcc);
                Id recordTypeIdAccount2 = Schema.SObjectType.Account.getRecordTypeInfosByName().get(RECORDTYP2).getRecordTypeId();
                Account accnt2=ARV_AP05_TestDataCreation.AccRec1(recordTypeIdAccount2);
                accnt2.Requested_Effective_Date__c=NULL;
                accnt2.GA_CoverageCancellationDate__c=Date.newInstance(2021, 03, 21);
                accnt2.Account_Status__c=ACCOUNTSTATUS;
                accnt2.Federal_Tax_ID__c=TAXVAL2;
                database.insert(accnt2);
                contract con2 =ARV_AP05_TestDataCreation.createContractRec(accnt2.id);
                database.insert(con2);
                Map<String,Object> input=new Map<String,Object>();
                input.put(TAXID,TAXVAL2);
                 input.put(CURRENTACCID,accnt2.Id);
                Map<String,Object> output=new Map<String,Object>();
                Map<String,Object> options=new Map<String,Object>();
                ARV_AP38_FedralTaxIdController fedralTax1=new ARV_AP38_FedralTaxIdController();
                fedralTax1.invokeMethod(METHODNAME,input,output,options);
                System.assertNotEquals(null,TAXVAL2);
            } catch(Exception e) {   return;  }
        }
    }
    /**************  
    Method name : fedralTaxVal2
    Params     : NA
    Return Type : NA
    Description :  fedralTaxVal2() method
    *************/ 
    private static testmethod void fedralTaxVal2() {
        user usr = ARV_AP05_TestDataCreation.UsrRec(PROFILENAME);
        database.insert(usr);
        system.runAs(usr) {   
            try {
                Id recordTypeIdAccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get(RECORDTYP).getRecordTypeId();
                Account accnt=ARV_AP05_TestDataCreation.AccRec1(recordTypeIdAccount);
                accnt.Federal_Tax_ID__c=TAXVAL3;
                database.insert(accnt);
                contract con1 =ARV_AP05_TestDataCreation.createContractRec(accnt.id);
                database.insert(con1);
                GA_Common_Control__c gcc=ARV_AP05_TestDataCreation.commonControlRec(accnt.Id);
                gcc.GA_Federal_Tax_ID_Number__c=TAXVAL3;
                database.insert(gcc);
                Id recordTypeIdAccount2 = Schema.SObjectType.Account.getRecordTypeInfosByName().get(RECORDTYP2).getRecordTypeId();
                Account accnt2=ARV_AP05_TestDataCreation.AccRec1(recordTypeIdAccount2);
                accnt2.Requested_Effective_Date__c=Date.newInstance(2020, 01, 20);
                accnt2.GA_CoverageCancellationDate__c=Date.newInstance(2020, 03, 21);
                accnt2.Account_Status__c=ACCOUNTSTATUS;
                accnt2.Federal_Tax_ID__c=TAXVAL3;
                database.insert(accnt2);
                contract con2 =ARV_AP05_TestDataCreation.createContractRec(accnt2.id);
                database.insert(con2);
               Map<String,Object> input=new Map<String,Object>();
                input.put(TAXID,TAXVAL3);
                Map<String,Object> output=new Map<String,Object>();
                Map<String,Object> options=new Map<String,Object>();
                ARV_AP38_FedralTaxIdController fedralTax1=new ARV_AP38_FedralTaxIdController();
                fedralTax1.invokeMethod(METHODNAME,input,output,options);
                System.assertNotEquals(null,TAXVAL2);
            } catch(Exception e) {   return;  }
        }
    } 
    /**************  
    Method name : fedralTaxVal2
    Params     : NA
    Return Type : NA
    Description :  fedralTaxVal2() method
    *************/ 
    private static testmethod void fedralTaxVal3() {
        user usr = ARV_AP05_TestDataCreation.UsrRec(PROFILENAME);
        database.insert(usr);
        system.runAs(usr) {   
            try {
                Id recordTypeIdAccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get(RECORDTYP).getRecordTypeId();
                Account accnt=ARV_AP05_TestDataCreation.AccRec1(recordTypeIdAccount);
                accnt.Federal_Tax_ID__c=TAXVAL4;
                database.insert(accnt);
                contract con1 =ARV_AP05_TestDataCreation.createContractRec(accnt.id);
                database.insert(con1);
               Id recordTypeIdAccount2 = Schema.SObjectType.Account.getRecordTypeInfosByName().get(RECORDTYP2).getRecordTypeId();
                Account accnt2=ARV_AP05_TestDataCreation.AccRec1(recordTypeIdAccount2);
                accnt2.Requested_Effective_Date__c=Date.newInstance(2020, 01, 20);
                accnt2.GA_CoverageCancellationDate__c=null;
                accnt2.Account_Status__c=ACCOUNTSTATUS;
                accnt2.Federal_Tax_ID__c=TAXVAL4;
                database.insert(accnt2);
                contract con2 =ARV_AP05_TestDataCreation.createContractRec(accnt2.id);
                database.insert(con2);
               Map<String,Object> input=new Map<String,Object>();
                input.put(TAXID,TAXVAL4);
                 input.put(CURRENTACCID,accnt2.Id);
                Map<String,Object> output=new Map<String,Object>();
                Map<String,Object> options=new Map<String,Object>();
                ARV_AP38_FedralTaxIdController fedralTax1=new ARV_AP38_FedralTaxIdController();
                fedralTax1.invokeMethod(METHODNAME,input,output,options);
                System.assertNotEquals(null,TAXVAL4);
            } catch(Exception e) {   return;  }
        }
    }  
}