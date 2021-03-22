/*****************************************************************************************
Trigger Name   : ARV_AP107_GWCTransacTableTriggerHandler 
Date Created : 02-MARCH-2021
Created By   : IDC Offshore
Description  :This class is for handling GWC Transaction Table trigger.
******************************************************************************************/

public without sharing class ARV_AP107_GWCTransacTableTriggerHandler {
	
    private static String APPROVED = 'Approval Process - Approved';
    private static String COMPLETED = 'Completed';
    
    //constructor
    public ARV_AP107_GWCTransacTableTriggerHandler(){}
    
    /**************  
    Method name : insertCommonControl
    Params     : list
    Return Type : null
    Description :insertCommonControl() method to create common control records upon approval of GWC Records
    *************/ 
    public static void insertCommonControl(Map<Id, ARV_GWC_Transaction_Table__c> mapOld, List<ARV_GWC_Transaction_Table__c> listNew){
        
        List<GA_Common_Control__c> ccToInsert = new List<GA_Common_Control__c>();
        
        String nameFormatter='';
        
        for(ARV_GWC_Transaction_Table__c gwcTT : listNew){
            if((mapOld.get(gwcTT.Id) != null) && (gwcTT.Status__c != mapOld.get(gwcTT.Id).Status__c) && (gwcTT.Status__c == COMPLETED || gwcTT.Status__c == APPROVED) && gwcTT.Is_common_control__c == true){
             	GA_Common_Control__c newCC = new GA_Common_Control__c();
                newCC.GA_AccountId__c = gwcTT.Account_ID__c;
                newCC.GA_Group_Name__c = gwcTT.ARV_Tech_Segment_Name__c;
                newCC.GA_Federal_Tax_ID_Number__c = gwcTT.ARV_Tech_Federal_Tax_ID__c; 
                newCC.GA_Approval_Link_Date__c = System.today();
                nameFormatter = gwcTT.Account_Name__c + '_' + gwcTT.ARV_Tech_Segment_Name__c;
                newCC.Name = nameFormatter;
                ccToInsert.add(newCC);
            }
        }
        
        database.insert(ccToInsert);
    }
}