/*****************************************************************************************
Class Name   : ARV_AP51_QA_UpdateSM 
Date Created : 12-sep-2019
Created By   : IDC Offshore
Description  : This class is used for UpdateSM 
******************************************************************************************/
public with sharing class ARV_AP51_QA_UpdateSM implements Queueable {
    
    private ARV_CO02_RateGridStaticData__c[] sObjList;
    private static final string  SPCHAR1= '?';
    private static final string  SPCHAR2= '?℠';
    private static final string  SPCHAR3= '℠℠';
    private static final string  SPCHAR4= '℠';  
    private static final string  BLANK= '';
    
    
    /**************  
    Constructor name :ARV_AP51_QA_UpdateSM
    Params     : List<sObject>
    Return Type : NA
    Description :Constructor to initialize ARV_CO02_RateGridStaticData__c.
    *************/
    public ARV_AP51_QA_UpdateSM(List<sObject> sObjectList){
        this.sObjList = (List<ARV_CO02_RateGridStaticData__c>)sObjectList; 
    }
    /**************  
    Method name : execute method
    Params     : NA
    Return Type : NA
    Description :This method is used to updateWith sm in Products.
    *************/ 
    public void execute(QueueableContext context) {
        ARV_CO02_RateGridStaticData__c[] updateObj = new List<ARV_CO02_RateGridStaticData__c>();
        try{
            for(ARV_CO02_RateGridStaticData__c p:sObjList){
                if(p.ProductName__c != null || p.ProductName__c != BLANK){
                    string productname=p.ProductName__c;
                    if(productname.contains(SPCHAR1) || productname.contains(SPCHAR2) || productname.contains(SPCHAR3)){                
                        p.ProductName__c=productname.contains(SPCHAR2)?productname.replace(SPCHAR2,SPCHAR4):
                        (productname.contains(SPCHAR3)?productname.replace(SPCHAR3,SPCHAR4):(productname.contains(SPCHAR1)?
                        productname.replace(SPCHAR1,SPCHAR4):productname));                    
                        updateObj.add(p);
                    }
                }
            }
            if(!updateObj.isEmpty()){
                Database.update(updateObj);
            }
        }Catch(Exception e){
           throw new AuraHandledException(e.getMessage());    
        }
    }
}