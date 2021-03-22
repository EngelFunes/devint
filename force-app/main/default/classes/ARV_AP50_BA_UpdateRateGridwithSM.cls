/*****************************************************************************************
Class Name   : ARV_AP50_BA_UpdateRateGridwithSM 
Date Created : 12-sep-2019
Created By   : IDC Offshore
Description  : This class is used for UpdateRateGridwithSM
******************************************************************************************/
global class ARV_AP50_BA_UpdateRateGridwithSM implements Database.Batchable<sObject>{ 

    private static final string  QUERYSTR = 'select productname__c from ARV_CO02_RateGridStaticData__c';        
   /************************************************************************************
        Method Name : start
        Description : This is method will return the RateGridStaticData.
        ************************************************************************************/
    global Database.QueryLocator start(Database.BatchableContext BC){      
      return Database.getQueryLocator(QUERYSTR);
    }
    /************************************************************************************
        Method Name : execute
        Description : This is method will run the update job to update SM mark.
        ************************************************************************************/
    global void execute(Database.BatchableContext BC, List<sObject> scope){
        ARV_AP51_QA_UpdateSM updateJob= new ARV_AP51_QA_UpdateSM(scope);
        Id jobID = System.enqueueJob(updateJob);       
    }
     /************************************************************************************
        Method Name : finish
        Description : This is method will run the update job to update SM mark.
        ************************************************************************************/
    global void finish(Database.BatchableContext BC){
        
    }
}