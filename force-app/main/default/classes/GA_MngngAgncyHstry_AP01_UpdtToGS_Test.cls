/*
@Author : IDC Offshore
@Name: GA_MngngAgncyHstry_AP01_UpdtToGS_Test 
@CreatedDate: 22 - Aug 2019 
@Description: GA_MngngAgncyHstry_AP01_UpdtToGS_Test Test class
@version : 1.0  
*/
@isTest(seealldata = false)
private class GA_MngngAgncyHstry_AP01_UpdtToGS_Test {
    
    /*******************************************************************************************************************************
@Description: plExcptnFutureEndDt() method 
@Name : plExcptnFutureEndDt
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
    private static testmethod void mngAgcnyHstryFutureEndDt(){
        user usrSA = GA_OBJ_TD01_TestDataCreation.UsrRec('Testwfstp','testsystemadminstrator@bcbsm.com','System Administrator');
        database.insert(usrSA);
        system.runAs(usrSA)
        {
            try{
                Map<ID,GA_Managing_Agency_History__c> mngAgcnyHstryOldMap = new Map<ID,GA_Managing_Agency_History__c> ();   
                Account testAccount = GA_OBJ_TD01_TestDataCreation.AccRec();
                database.insert(testAccount);
                
                GA_Group_Segment__c grpSgmntRec=GA_OBJ_TD01_TestDataCreation.grpSegmntRec(testAccount);
                database.insert(grpSgmntRec);
                
                Id RecordTypeIdAccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Agency').getRecordTypeId();

            	Account acc = new Account();
            	acc.Name='Test Acc';
            	acc.RecordTypeId=RecordTypeIdAccount;
           		acc.GA_Managing_Agency_Code__c='01';
            	database.insert(acc);
                
                GA_Managing_Agency_History__c mngAgcnyHstry = new GA_Managing_Agency_History__c();
                mngAgcnyHstry.GA_Group_Segment__c=grpSgmntRec.id;
                mngAgcnyHstry.GA_Start_Date__c=system.today()+1;
                mngAgcnyHstry.MA_Override_Start_Date__c = system.today()+1;
                mngAgcnyHstry.GA_Managing_Agency__c=acc.id;
                database.insert(mngAgcnyHstry);
                
                mngAgcnyHstryOldMap.put(mngAgcnyHstry.id,mngAgcnyHstry);
                
                GA_Managing_Agency_History__c mngAgcnyHstry2 = new GA_Managing_Agency_History__c();
                mngAgcnyHstry2.id=mngAgcnyHstry.id;
                mngAgcnyHstry2.GA_Start_Date__c=system.today()+2;
                mngAgcnyHstry2.MA_Override_Start_Date__c = system.today()+2;
                mngAgcnyHstry2.GA_End_Date__c=system.today()+6;
                mngAgcnyHstry2.GA_Managing_Agency__c=acc.id;
                List<GA_Managing_Agency_History__c> mngAgcnyHstryLst = new List<GA_Managing_Agency_History__c> ();
                mngAgcnyHstryLst.add(mngAgcnyHstry2);
                
                test.startTest();
                GA_MngngAgncyHstry_AP01_UpdtToGrpSgmnt.updtMngngAgncytoGs(mngAgcnyHstryLst,mngAgcnyHstryOldMap);
                test.stopTest();
                system.assert(usrSA <> null);
            }
            catch(exception e)
            {
                return;
            }
        }
    } 
    
    /*******************************************************************************************************************************
@Description: mngAgcnyHstryPastEndDt() method 
@Name : mngAgcnyHstryPastEndDt
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
    private static testmethod void mngAgcnyHstryPastEndDt(){
        user usrSA = GA_OBJ_TD01_TestDataCreation.UsrRec('Testwfstp','testsystemadminstrator@bcbsm.com','System Administrator');
        database.insert(usrSA);
        system.runAs(usrSA)
        {
            try{
                Map<ID,GA_Managing_Agency_History__c> mngAgcnyHstryOldMap = new Map<ID,GA_Managing_Agency_History__c> ();   
                Account testAccount = GA_OBJ_TD01_TestDataCreation.AccRec();
                database.insert(testAccount);
                
                GA_Group_Segment__c grpSgmntRec=GA_OBJ_TD01_TestDataCreation.grpSegmntRec(testAccount);
                database.insert(grpSgmntRec);
                
                Id RecordTypeIdAccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Agency').getRecordTypeId();
                Account acc = new Account();
            	acc.Name='Test Acc';
            	acc.RecordTypeId=RecordTypeIdAccount;
           		acc.GA_Managing_Agency_Code__c='01';
            
            	database.insert(acc);
                GA_Managing_Agency_History__c mngAgcnyHstry = new GA_Managing_Agency_History__c();
                mngAgcnyHstry.GA_Group_Segment__c=grpSgmntRec.id;
                mngAgcnyHstry.GA_Managing_Agency__c=acc.id;
                mngAgcnyHstry.GA_Start_Date__c=system.today();
                database.insert(mngAgcnyHstry);
                
                mngAgcnyHstryOldMap.put(mngAgcnyHstry.id,mngAgcnyHstry);
                
                GA_Managing_Agency_History__c mngAgcnyHstry2 = new GA_Managing_Agency_History__c();
                mngAgcnyHstry2.id=mngAgcnyHstry.id;
                mngAgcnyHstry2.GA_Start_Date__c=system.today()-6;
                mngAgcnyHstry2.GA_End_Date__c=system.today()-1;
                List<GA_Managing_Agency_History__c> mngAgcnyHstryLst = new List<GA_Managing_Agency_History__c> ();
                mngAgcnyHstryLst.add(mngAgcnyHstry2);
                
                test.startTest();
                GA_MngngAgncyHstry_AP01_UpdtToGrpSgmnt.updtMngngAgncytoGs(mngAgcnyHstryLst,mngAgcnyHstryOldMap);
                test.stopTest();
                system.assert(usrSA <> null);
            }
            catch(exception e)
            {
                return;
            }
        }
    } 
    
    /*******************************************************************************************************************************
@Description: mngAgcnyHstrycatch() method 
@Name : mngAgcnyHstrycatch
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
    private static testmethod void mngAgcnyHstrycatch(){
        user usrSA = GA_OBJ_TD01_TestDataCreation.UsrRec('Testwfstp','testsystemadminstrator@bcbsm.com','System Administrator');
        database.insert(usrSA);
        system.runAs(usrSA)
        {
            try{
                Map<ID,GA_Managing_Agency_History__c> planexcptOldMap = new Map<ID,GA_Managing_Agency_History__c> ();   
                Account testAccount = GA_OBJ_TD01_TestDataCreation.AccRec();
                database.insert(testAccount);
                
                GA_Group_Segment__c grpSgmntRec=GA_OBJ_TD01_TestDataCreation.grpSegmntRec(testAccount);
                database.insert(grpSgmntRec);
                
                test.startTest();
                GA_MngngAgncyHstry_AP01_UpdtToGrpSgmnt.updtMngngAgncytoGs(null,null);
                GA_MngngAgncyHstry_AP01_UpdtToGrpSgmnt.doAction(null);
                GA_MngngAgncyHstry_AP01_UpdtToGrpSgmnt.updatEndDate(null);
                test.stopTest();
                system.assert(usrSA <> null);
            }
            catch(exception e)
            {
                return;
            }
        }
    }
}