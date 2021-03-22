@isTest(seealldata=false)
/**
*Class Name   : ARV_AP19_EffectiveDatePreparation_Test
*Date Created : 26-JULY-2019
*Created By   : IDC Offshore
*Description  : This class is used for testing ARV_AP19_EffectiveDatePreparation.
**/
public without sharing class ARV_AP19_EffectiveDatePreparation_Test {
    private static final string PROFILENAME1='System Administrator';
    private static final string PROFILENAME='BCBSM Agent';
    private static final string NAME1='ARVAP19EffectiveDatePreparation';
    private static final string NAME='Bob Broker';
    private static final string USERNAME='bcbsm1@bcbsm.com';
    private static final string USERNAME1='bcbsm2@bcbsm.com';
    private static final string ENDDATE='2020-11-07';
    private static final string FISTNAME='Firstname';
    private static final string LASTNAME='Lastname';
    private static final string INVOKMETHOD='getRequestCoverageBrokerDates';
    private static final string INVOKMETHOD1='getRequestCoverageBrokerDatesGwc';
    private static final String OPTIONS_CONSTANT = 'options';
    private static final string LastDate='2021-11-07';
    
    private static final Date StatrtDate=system.today();
    private static final Date StatrtDate1=system.today();
/*************************************
*Method name : testDataSetup
*Params     : NA
*Return Type : testmethod
*Description :  testDataSetup() method 
**************************************/
    @testSetup static void testDataSetup() {
        Account acct = ARV_AP05_TestDataCreation.accRec();
        database.insert(acct);
        //creating BCBSM Agent
        Contact con = new Contact();
        con.LastName=LASTNAME;
        con.FirstName=FISTNAME;
        con.AccountID = acct.id;
        database.insert(con);
        user usr1 = ARV_AP05_TestDataCreation.PortalUserRecord(con);
        usr1.LastName = PROFILENAME;
        usr1.Username=USERNAME1;
        database.insert(usr1);
        // creating system admin 	
        user usr = ARV_AP05_TestDataCreation.UsrRec(PROFILENAME1);
        usr.LastName = NAME1;
        usr.Username=USERNAME;
        database.insert(usr,true);
        Requested_Eff_Date__mdt mdt = new Requested_Eff_Date__mdt();
        mdt.Start_Date__c =system.today();
        mdt.End_Date__c=system.today();
       Requested_Eff_Date__mdt mdt1 = new Requested_Eff_Date__mdt();
        mdt1.Start_Date__c = system.today();
        mdt1.End_Date__c = system.today()-280;
      
    }
    /**
*Method name : invokeMethodTest
*Params      : NA
*Return Type : testmethod
*Description : Method to call ARV_CS01_EffectiveDate__c
**/
    private testmethod static void invokeMethodTest(){
        user usr1 = [SELECT Id from User where LastName =: NAME1 limit 1];
        system.runAs(usr1){
            ARV_AP19_EffectiveDatePreparation datepreparation = new ARV_AP19_EffectiveDatePreparation();
            ARV_AP19_EffectiveDatePreparation Gwcdatapreparation = new ARV_AP19_EffectiveDatePreparation();
            Requested_Eff_Date__mdt mdt = new Requested_Eff_Date__mdt();
            Map<String,Object> inputMap = new Map<String,Object> ();
            Map<String,Object> outMap = new Map<String,Object> ();
            Map<String,Object> options = new Map<String,Object> ();  
            datepreparation.invokeMethod(INVOKMETHOD,inputMap,outMap,options);
            Gwcdatapreparation.invokeMethod(INVOKMETHOD1,inputMap,outMap,options);
            system.assertEquals(outMap.size()>0,outMap.size()>0 );
            List<Map<String, String>> datelist = new  List<Map<String, String>>();
            datelist= datepreparation.coverageBrokerDates(date.valueOf(ENDDATE));
            datelist= datepreparation.coverageBrokerDates(date.valueOf(StatrtDate1));
            ARV_AP19_EffectiveDatePreparation.getcustomMetadataId();
            datelist= Gwcdatapreparation.coverageBrokerDatesGwc(date.valueOf(LastDate));
            ARV_AP19_EffectiveDatePreparation.fetchUser(); 
        }
    }
    /**
*Method name : invokeMethodTest
*Params      : NA
*Return Type : testmethod
*Description : Method to call ARV_CS01_EffectiveDate__c
**/
    private testmethod static void invokeMethodTest1(){
        user usr1 = [SELECT Id from User where LastName =: PROFILENAME limit 1];
        system.runAs(usr1){
            ARV_AP19_EffectiveDatePreparation datepreparation = new ARV_AP19_EffectiveDatePreparation();
            Requested_Eff_Date__mdt mdt = new Requested_Eff_Date__mdt();
            ARV_AP19_EffectiveDatePreparation Gwcdatapreparation = new ARV_AP19_EffectiveDatePreparation();
            Map<String,Object> inputMap = new Map<String,Object> ();
            Map<String,Object> outMap = new Map<String,Object> ();
            Map<String,Object> options = new Map<String,Object> ();
            Map<String,String> tempMap = new Map<String,String> ();
            datepreparation.invokeMethod(INVOKMETHOD,inputMap,outMap,options);
            system.assertEquals(outMap.size()>0,outMap.size()>0 );
            List<Map<String, String>> datelist = new  List<Map<String, String>>();
            datelist= datepreparation.coverageBrokerDates(date.valueOf(ENDDATE));
            ARV_AP19_EffectiveDatePreparation.getcustomMetadataId();
            try{
            Gwcdatapreparation.invokeMethod(INVOKMETHOD1,inputMap,outMap,options);
            datelist= Gwcdatapreparation.coverageBrokerDatesGwc(date.valueOf(LastDate));
            }
            Catch(Exception e){
                return ;}
        }
    }
    
      /**
*Method name : invokeMethodTest2
*Params      : NA
*Return Type : testmethod
*Description : Method to call getRequestCoverageBrokerDatesGwc
**/
private testmethod static void invokeMethodTest2(){
        user usr2 = [SELECT Id from User where LastName =: PROFILENAME limit 1];
        system.runAs(usr2){
            Requested_Eff_Date__mdt mdt = new Requested_Eff_Date__mdt();
            ARV_AP19_EffectiveDatePreparation datepreparation = new ARV_AP19_EffectiveDatePreparation();
            ARV_AP19_EffectiveDatePreparation Gwcdatapreparation = new ARV_AP19_EffectiveDatePreparation();
            Map<String,Object> inputMap = new Map<String,Object> ();
            Map<String,Object> outMap = new Map<String,Object> ();
            Map<String,Object> options = new Map<String,Object> ();  
           datepreparation.invokeMethod(INVOKMETHOD,inputMap,outMap,options);
            system.assertEquals(outMap.size()>0,outMap.size()>0 );
            List<Map<String, String>> datelist = new  List<Map<String, String>>();
            try{
            Gwcdatapreparation.invokeMethod(INVOKMETHOD1,inputMap,outMap,options);
            datelist= Gwcdatapreparation.coverageBrokerDatesGwc(date.valueOf(ENDDATE));
            }
            Catch(Exception e){
                return ;}
        }
    }
    /**
*Method name : invokeMethodTest3
*Params      : NA
*Return Type : testmethod
*Description : Method to call getRequestCoverageBrokerDatesGwc
**/
    private testmethod static void invokeMethodTest3(){
    user usr2 = [SELECT Id from User where LastName =: PROFILENAME limit 1];
        system.runAs(usr2){
            Requested_Eff_Date__mdt mdt = new Requested_Eff_Date__mdt();
            mdt.Start_Date__c = system.today();
            mdt.End_Date__c=system.today().adddays(400);
             Map<String,Object> inputMap = new Map<String,Object> ();
            Map<String,Object> outMap = new Map<String,Object> ();
            Map<String,Object> options = new Map<String,Object> ();  
     ARV_AP19_EffectiveDatePreparation Gwcdatapreparation = new ARV_AP19_EffectiveDatePreparation();
             List<Map<String, String>> datelist = new  List<Map<String, String>>();
            
            Gwcdatapreparation.invokeMethod(INVOKMETHOD,inputMap,outMap,options);
            datelist= Gwcdatapreparation.coverageBrokerDates(date.valueOf(mdt.End_Date__c));
           
           
        }
    }
}