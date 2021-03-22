/********************************************************************************************
Class Name   : ARV_AP_getGroupSegments  
Date Created : 21-Oct-2020
Created By   : IDC Offshore
Description  : This is ARV_LTNG_displayGroupSegments Controller.
************************************************************************************************************/

public without sharing class ARV_AP_getGroupSegments {
    /**************  
Method name : getGWCContracts
Params     : Id
Return Type : List
Description :  getGWCContracts() method
*************/

    @AuraEnabled
    public static List<GA_Group_Segment__c> getGroupSegments(Id conId){
    
        List<GA_Group_Segment__c> GSList = new List<GA_Group_Segment__c>();
        ID accID;
        List<Contract> conList = [select id, AccountId from Contract where id=:conId limit 1];
        System.debug('conList++'+conList);
        if(!conList.isEmpty()){
            for(Contract con: conList){
                accID = con.AccountID;
                break;
            }
        }
        GSList = [select Id, Name, ARV_ContractID__c, LastModifiedDate, ARV_GWC_Type__c, CreatedDate, LastModifiedBy.Name from GA_Group_Segment__c where (GA_Account__c=:accID OR ARV_Pending_ContractId__c=:conId OR ARV_ContractID__c=:conId) AND (Status__c = 'Active' OR Status__c='Pending') Order By CreatedDate desc];
        System.debug('printing GSList++>>'+GSList);
        return GSList;
    }
}