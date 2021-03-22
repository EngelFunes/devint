/*****************************************************************************************
Class Name   : ARV_AP47_DocusignContractScreen_Test 
Date Created : 2-jan-2020
Created By   : IDC Offshore
Description  : This class is used for DocusignContractScreen
******************************************************************************************/
@isTest(seeAllData=false)
public class ARV_AP47_DocusignContractScreen_Test {
    private static final string PROFILENAME='system administrator';
    private static final string CONTEXTID='ContextId';
        private static final string METHODNAME='getContactDetails';

    /**************  
Method name : docuSignScreen
Params     : NA
Return Type : NA
Description :  docuSignScreen() method
*************/ 
    private static testmethod void docuSignScreen()
    {
        user usr = ARV_AP05_TestDataCreation.UsrRec(PROFILENAME);
        database.insert(usr);
        system.runAs(usr)
        {   
            try{ 
                Account acc=ARV_AP05_TestDataCreation.accRec();
                database.insert(acc);
                contract contr=ARV_AP05_TestDataCreation.createContractRec(acc.Id);
                database.insert(contr);
                contact cont=ARV_AP05_TestDataCreation.contactRec1(acc.Id,contr.Id);
                database.insert(cont);
                Map<String,Object> input=new Map<String,Object>();
                input.put(CONTEXTID,contr.Id);
                input.put('AccountId',acc.Id);
                
                Map<String,Object> output=new Map<String,Object>();
                Map<String,Object> options=new Map<String,Object>();
                ARV_AP47_DocusignContractScreen docuSign=new ARV_AP47_DocusignContractScreen();
                docuSign.invokeMethod(METHODNAME,input,output,options);
                docuSign.invokeMethod('getGWCEsignContactDetails',input,output,options);
            }  
            catch(Exception e) {   return;  }
        }
    }
}