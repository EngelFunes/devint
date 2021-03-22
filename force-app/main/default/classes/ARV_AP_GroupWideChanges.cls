/********************************************************************************************
Class Name   : ARV_AP_GroupWideChanges 
Date Created : 21-Sep-2020
Created By   : IDC Offshore
Description  : This is ARV_LTNG_GroupWideChanges Controller.
************************************************************************************************************/
public without sharing class ARV_AP_GroupWideChanges {
        private static final string TYPE='Small Group GWC';
        private static final string RECORDTYPE='Maintenance Change';
    	
     /**************  
Method name : getGWCContracts
Params     : Id
Return Type : List
Description :  getGWCContracts() method
*************/
        @AuraEnabled
    public static List<Contract> getGWCContracts(Id accId){
         return[select Id,ContractNumber,Account.ARV_Agent_Name__c,ARV_Agent_Name_frm__c,ARV_Requested_Effective_Date__c,ARV_Contract_Type__c,ARV_Enrollment_StatusFormula__c from Contract where AccountId=:accId and ARV_Contract_Type__c=:TYPE ]; 
    }
   
     /**************  
Method name : getMaintananceChanges
Params     : Id
Return Type : List
Description :  getMaintananceChanges() method
*************/
        @AuraEnabled
    public static List<ARV_Gwc_Transaction_Table__c> getMaintananceChanges(Id accId){
      return[select Id,Account_ID__r.ARV_Agent_Name__r.Name,Agent__c,Status__c,Approved_Date__c,Account_ID__r.Name,lastmodifieddate from ARV_Gwc_Transaction_Table__c where Account_ID__c=:accId and Recordtype.Name=:RECORDTYPE and (Status__c ='Submitted' or Status__c = 'Under Review' or Status__c = 'Completed')];
    }
    
}