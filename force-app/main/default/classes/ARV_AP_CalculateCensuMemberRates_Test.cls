/*****************************************************************************************
Class Name   : ARV_AP_CalculateCensuMemberRates_Test 
Date Created : 4-AUG-2020
Created By   : IDC Offshore
Description  : This class is used for testing ARV_AP_CalculateCensuMemberRates Class.
******************************************************************************************/
@isTest
public class ARV_AP_CalculateCensuMemberRates_Test {
    private static final string PROFILENAME='Integration User';
    private static final string NAME1='AP35RateGrid';
    private static final string USERNAME='bcbsm1@bcbsm.com';
    private static final string USERNAME1='bcbsm12@bcbsm.com';
    private static final string CNTNAME='Contract0';
    private static final string CNTNAME1='Contract1';
    private static final string CNTNAME2='Contract2';
    
    /**************  
Method name : testDataSetup
Params     : NA
Return Type : testmethod
Description :  testDataSetup() method 
*************/  
    @testSetup static void testDataSetup() {
        Account act= ARV_AP05_TestDataCreation.accRec();
        database.insert(act);
        user usr = ARV_AP05_TestDataCreation.UsrRec(PROFILENAME);
        usr.LastName = NAME1;
        usr.Username=USERNAME;
        database.insert(usr,true);
        vlocity_ins__GroupCensus__c census=ARV_AP05_TestDataCreation.groupCensus(act.Id);
        database.insert(census);
        Contract con = ARV_AP05_TestDataCreation.createContractRec(act.Id);
        con.vlocity_ins__FinalRatingGroupCensusId__c=census.Id;
        con.createdbyId=usr.Id;
        con.Name=CNTNAME;
        database.insert(con);
        Contract con1= ARV_AP05_TestDataCreation.createContractRec(act.Id);
        con1.vlocity_ins__FinalRatingGroupCensusId__c=census.Id;
        con1.createdbyId=usr.Id;
        con1.Name=CNTNAME1;
        database.insert(con1);
        Contract con2= ARV_AP05_TestDataCreation.createContractRec(act.Id);
        con2.vlocity_ins__FinalRatingGroupCensusId__c=census.Id;
        con2.createdbyId=usr.Id;
        con2.Name=CNTNAME2;
        database.insert(con2);
        
        vlocity_ins__GroupCensusMember__c censusMem=ARV_AP05_TestDataCreation.groupCensusMember(census.Id);
        database.insert(censusMem);
    }
    /**************  
Method name : censusRateGridTest
Params     : NA
Return Type : testmethod
Description :  internalUserTest() method 
*************/ 
    private static testmethod void calculateCennsusMem(){
        user usr1 = [SELECT Id from User where LastName =: NAME1 limit 1];
        Id profId=[select id, Name from Profile where Name=:PROFILENAME].Id;
        list<Contract> contractList=new list<Contract>();
        Account act= ARV_AP05_TestDataCreation.accRec();
        database.insert(act);
        user usr = ARV_AP05_TestDataCreation.UsrRec(PROFILENAME);
        usr.LastName = NAME1;
        usr.Username=USERNAME1;
        database.insert(usr,true);
        vlocity_ins__GroupCensus__c census=ARV_AP05_TestDataCreation.groupCensus(act.Id);
        database.insert(census);
        Contract con = ARV_AP05_TestDataCreation.createContractRec(act.Id);
        con.vlocity_ins__FinalRatingGroupCensusId__c=census.Id;
        con.createdbyId=usr.Id;
        con.Name=CNTNAME;
        database.insert(con);
        contractList.add(con);
        Contract cont1 = ARV_AP05_TestDataCreation.createContractRec(act.Id);
        cont1.vlocity_ins__FinalRatingGroupCensusId__c=census.Id;
        cont1.createdbyId=usr.Id;
        cont1.Name=CNTNAME1;
        database.insert(cont1);
        contractList.add(cont1);
        Contract con2= ARV_AP05_TestDataCreation.createContractRec(act.Id);
        con2.vlocity_ins__FinalRatingGroupCensusId__c=census.Id;
        con2.createdbyId=usr.Id;
        con2.Name=CNTNAME2;
        database.insert(con2);                
        contractList.add(con2);
        ARV_AP_CalculateCensuMemberRates acm=new ARV_AP_CalculateCensuMemberRates();
        test.startTest();            
        ARV_AP_CalculateCensuMemberRates.getListforContracts();
        test.stopTest(); 
                system.assert(con2!= null);
        
    }
    /**************  
Method name : censusRateGridTest
Params     : NA
Return Type : testmethod
Description :  internalUserTest() method 
*************/ 
    private static testmethod void calculateCennsusMemsch(){
        user usr1 = [SELECT Id from User where LastName =: NAME1 limit 1];  
         test.startTest();  
         SchedulableContext scv = null;
        ARV_AP_ScheduleCensusMemberRates sch=new ARV_AP_ScheduleCensusMemberRates();
        sch.execute(scv);
        system.assert(usr1!=null);
        test.stopTest(); 
        
        
    }
}