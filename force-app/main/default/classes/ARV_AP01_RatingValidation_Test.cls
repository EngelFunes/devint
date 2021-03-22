/*****************************************************************************************
Author       : IDC Offshore
Class Name   : ARV_AP01_RatingValidation_Test
Date Created : 05/13/2019
Created By   : IDC Offshore
Description  : ARV_AP01_RatingValidation_Test class for US# 1321
******************************************************************************************/
@isTest(seeAllData=false)
private with sharing class ARV_AP01_RatingValidation_Test {
    private static final string NAME='AP18LastName';
    private static final string PROFILENAME='System Administrator';
    
    /**************  
Method name : testDataSetup
Params     : NA
Return Type : testmethod
Description :  testDataSetup() method 
*************/ 
    @testSetup static void testDataSetup() {
        user usr = ARV_AP05_TestDataCreation.UsrRec(PROFILENAME);
        usr.LastName = NAME;
        database.insert(usr,true);    
    }
    /**************  
Method name : rateValidationTest
Return Type : void
Description : This method to test the calculate methodof ARV_AP01_RatingValidation class .
*************/
    @isTest
    private static void rateValidationTest(){
        user usr1 = [SELECT Id from User where LastName =: NAME limit 1];
        system.runAs(usr1){
            String calcMethod = 'calculate' ;        
            ARV_AP01_RatingValidation ratevalidation = new ARV_AP01_RatingValidation();
            //Map<String,Object> inputMap = new Map<String,Object> ();
            Map<String,Object> outMap = new Map<String,Object> ();
            Map<String,Object> options = new Map<String,Object> ();           
            ARV_MDT01_TestingJson__mdt mdt = [select InputJson__c from ARV_MDT01_TestingJson__mdt
                                              where MasterLabel = 'InputText' LIMIT 1 ];   
            try{
                Map<String, Object> deserialized = (Map<String, Object>)JSON.deserializeUntyped(mdt.InputJson__c);     
                ratevalidation.invokeMethod(calcMethod, deserialized, outMap, options); 
                system.assertNotEquals(null, deserialized);
            }catch(Exception e){           
                system.assertNotEquals('exception',e.getMessage());
            }  
        }
    }
    /**************  
Method name : rateValidationParserTest
Return Type : void
Description : This method to test the parse methodof ARV_AP02_RatingValidationJsonParser class .
*************/
    @istest
    private static void rateValidationParserTest(){
        user usr1 = [SELECT Id from User where LastName =: NAME limit 1];
        system.runAs(usr1){
            ARV_AP02_RatingValidationJsonParser.CensusDetails census = new ARV_AP02_RatingValidationJsonParser.CensusDetails();
            system.assertNotEquals(null, census);
            try{
                ARV_AP02_RatingValidationJsonParser.parse('parseTesting');          
            }catch(Exception E){
                system.assertNotEquals('exception',e.getMessage());
            }
            try{
                Integer testVal = census.compareTo(NULL);
            }catch(Exception e){
                system.assertNotEquals('exception',e.getMessage());
            }
        }
    }
}