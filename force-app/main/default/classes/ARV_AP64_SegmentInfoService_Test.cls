/*****************************************************************************************
Class Name   : ARV_AP64_SegmentInfoService_Test 
Date Created : 27-Dec-2019
Created By   : IDC Offshore
Description  : This class is used for testing ARV_AP64_SegmentInfoService_Test Class.
******************************************************************************************/
@isTest
public with sharing class  ARV_AP64_SegmentInfoService_Test {
    private static final string NAME='AP18LastName';
    private static final string PROFILENAME='System Administrator';
    private static final string FORMATSEGMENTINFO='formatSegMentInfo';
    private static final String SEGMENTINPUT='SegmentInput';
    private static final string EXCEPTION1='exception1';
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
Method name : testsegmentInfo
Params     : NA
Return Type : testmethod
Description :  to test the testsegmentInfo() method 
*************/ 
   @isTest    
     static void testsegmentInfo(){
         user usr1 = [SELECT Id from User where LastName =: NAME limit 1];
         system.runAs(usr1){
             String formatSegMentInfo = FORMATSEGMENTINFO ;
             ARV_AP64_SegmentInfoService sis=new ARV_AP64_SegmentInfoService();
             Map<String,Object> outMap = new Map<String,Object> ();
             Map<String,Object> options = new Map<String,Object> ();    
             ARV_MDT01_TestingJson__mdt mdt = [select InputJson__c from ARV_MDT01_TestingJson__mdt
                                               where MasterLabel = :SEGMENTINPUT LIMIT 1 ];   
             try{
                 Map<String, Object> deserialized = (Map<String, Object>)JSON.deserializeUntyped(mdt.InputJson__c);     
                 sis.invokeMethod(formatSegMentInfo, deserialized, outMap, options); 
                 system.assertNotEquals(null, deserialized);
             }   catch(Exception e){           
                 system.assertNotEquals(EXCEPTION1,e.getMessage());
             }  
         }
    }
}