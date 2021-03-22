/*****************************************************************************************
Class Name   : ARV_AP50_BA_UpdateRateGridwithSM_Test 
Date Created : 9-sep-2019
Created By   : IDC Offshore
Description  : This class is used to test ARV_AP50_BA_UpdateRateGridwithSM
******************************************************************************************/
@isTest(seealldata=false)
public class ARV_AP50_BA_UpdateRateGridwithSM_Test {
    private static final string NAME='AP18LastNames';
    private static final string PROFILENAME='System Administrator';
        /**************  
    Method name : testDataSetup
    Params     : NA
    Return Type : testmethod
    Description :  getBAAGDoc() method 
    *************/ 
    @testSetup static void testDataSetup() {
        user usr = ARV_AP05_TestDataCreation.UsrRec(PROFILENAME);
        usr.LastName = NAME;
        database.insert(usr,true); 
        ARV_CO02_RateGridStaticData__c prod=ARV_AP05_TestDataCreation.RateGridStaticData();
        database.insert(prod);
    }
     /**************  
    Method name : UpdateRateGridwithSM
    Params     : NA
    Return Type : testmethod
    Description :  UpdateRateGridwithSM() method 
    *************/ 
    private static testmethod void updateRateGridWithSM(){
        user usr1 = [SELECT Id from User where LastName =: NAME limit 1];
        system.runAs(usr1){
            ARV_AP50_BA_UpdateRateGridwithSM obj=new ARV_AP50_BA_UpdateRateGridwithSM();
            Test.startTest();
            DataBase.executeBatch(obj);
            Test.stopTest();
            System.assertNotEquals(null,obj);
         }
    }
}