/*****************************************************************************************
Class Name   : ARV_AP82_contractRelatedList
Date Created : 06-FEB-2020
Created By   : IDC Offshore
Description  : 
******************************************************************************************/
public without sharing class ARV_AP82_contractRelatedList {
   private static final string ENROLLMENTTYPE='Small Group Enrollment';
    private static final string RENEWALTYPE='Small Group Renewal';
    
    /**************  
    Method name : getRelatedContracts
    Params      : NA
    Return Type : void
    Description : This method is used to get related contracts  
    *************/
    @AuraEnabled
    public static List<Contract> getRelatedContracts(String conId){
        List<Contract> conList = [SELECT Id,AccountId,ARV_Requested_Effective_Date__c,ARV_Agent_Name_frm__c,ARV_Enrollment_StatusFormula__c,ContractNumber ,
                                  ARV_Contract_Type__c FROM Contract WHERE AccountId =:conId and (ARV_Contract_Type__c=:ENROLLMENTTYPE OR ARV_Contract_Type__c=:RENEWALTYPE)];
        return conList;
     } 
}