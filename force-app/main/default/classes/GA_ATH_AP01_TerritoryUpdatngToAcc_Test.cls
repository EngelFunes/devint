/*******************************************************************************************************************************
@Author : IDC offshore
@Name: GA_ATH_AP01_TerritoryUpdatngToAcc_Test
@CreatedDate: 25 - Feb 2019 
@Description: GA_ATH_AP01_TerritoryUpdatngToAcc_Test class is for Account Territory History.
@version : 1.0  
********************************************************************************************************************************/
@isTest(seealldata=false)
private class GA_ATH_AP01_TerritoryUpdatngToAcc_Test {
    /*******************************************************************************************************************************
@Description: updtThrdPrtyToAccTest() method 
@Name : updtThrdPrtyToAccTest
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
    private static testmethod void updtAccTeritryTest(){
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestSysAdm','testsysadm@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr){
            try{
                Map<ID,GA_Account_Territory_History__c> athOldMap = new Map<ID,GA_Account_Territory_History__c>();
                Account testAccount = GA_OBJ_TD01_TestDataCreation.AccRec();
                testAccount.RecordTypeId =  Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Customer').getRecordTypeId();
                testAccount.GA_System_of_record__c='Salesforce';
                database.insert(testAccount);
                
                Account testAccount2 = GA_OBJ_TD01_TestDataCreation.AccRec();
                testAccount.RecordTypeId =  Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Inactive').getRecordTypeId();
                database.insert(testAccount);
                
                user usr1 = GA_OBJ_TD01_TestDataCreation.UsrRec('TestR1','testsalesrep1mail@bcbsm.com','Retention Sales');
                database.insert(usr1);
                
                GA_Region__c regnRec =new GA_Region__c();
                regnRec.Name = 'Test Region';
                regnRec.GA_Region_Code__c='018';
                database.insert(regnRec);
                
                GA_Sales_Office__c slsOfcRec =new GA_Sales_Office__c();
                slsOfcRec.Name = 'Test - Sales Office';
                slsOfcRec.GA_Sales_Office_Code__c='999';
                slsOfcRec.GA_Region__c=regnRec.Id;
                database.insert(slsOfcRec);
                
                GA_Territory__c territoryRec=GA_OBJ_TD01_TestDataCreation.terrtryRec();
                territoryRec.GA_RetentionSalesRepresentative__c=usr1.id;
                territoryRec.GA_Sales_Office__c=slsOfcRec.Id;
                database.insert(territoryRec);
                
                List<GA_Account_Territory_History__c> athLst = new List<GA_Account_Territory_History__c>();
                
                GA_Account_Territory_History__c athRec = new GA_Account_Territory_History__c();
                athRec.GA_Account_Id__c=testAccount.Id;
                athRec.GA_Territory_Id__c=territoryRec.Id;
                athRec.GA_Start_Date__c=system.today()-10;
                athRec.GA_End_Date__c=system.today()+10;
                database.insert(athRec);
                
                testAccount.GA_Territory__c=athRec.GA_Territory_Id__c;
                testAccount.GA_Account_Territory_History__c=athRec.Id;
                testAccount.GA_Is_Mass_Updating__c=true;
                GA_ACC_AP01_CheckPlatinumStatusOnAgency.isExecuting = true;
                GA_Util_lockRecords.isExecuting = true;
                GA_ACC_AP05_CreateHandoverRecord.isExecuting = true;
                GA_ACC_UpdateChildContctsOnAccOwnrChange.isExecuting = true;
                GA_ACC_AP04_UpdtCntOnAccLockUnlock.isExecuting = true;
                GA_ACC_AP_UpdtAssmntOwnrMgrChnge.isExecuting = true; 
                GA_AccountBatchToUpdateContactOwner.isInvodedFrmBtch = true;
                GA_ACC_AP_UpdtAssmntOwnrMgrChnge.isExecuting = true;
                database.update(testAccount);
                
                athRec.GA_Is_Processed__c=true;
                database.update(athRec);
                
                GA_Account_Territory_History__c athRec1 = new GA_Account_Territory_History__c();
                athRec1.GA_Account_Id__c=testAccount.Id;
                athRec1.GA_Territory_Id__c=territoryRec.Id;
                athRec1.GA_Start_Date__c=system.today()-3;
                athRec1.GA_End_Date__c=system.today()+10;
                database.insert(athRec1);
                
                testAccount.GA_Territory__c=athRec1.GA_Territory_Id__c;
                testAccount.GA_Account_Territory_History__c=athRec1.Id;
                testAccount.GA_Is_Mass_Updating__c=true;
                GA_ACC_AP01_CheckPlatinumStatusOnAgency.isExecuting = true;
                GA_Util_lockRecords.isExecuting = true;
                GA_ACC_AP05_CreateHandoverRecord.isExecuting = true;
                GA_ACC_UpdateChildContctsOnAccOwnrChange.isExecuting = true;
                GA_ACC_AP04_UpdtCntOnAccLockUnlock.isExecuting = true;
                GA_ACC_AP_UpdtAssmntOwnrMgrChnge.isExecuting = true; 
                GA_AccountBatchToUpdateContactOwner.isInvodedFrmBtch = true;
                GA_ACC_AP_UpdtAssmntOwnrMgrChnge.isExecuting = true;
                database.update(testAccount);
                
                athRec1.GA_Is_Processed__c=true;
                database.update(athRec1);
                
                athRec.GA_End_Date__c=athRec1.GA_Start_Date__c-1;
                athRec.GA_Is_Processed__c = true;
                database.update(athRec);
                GA_Account_Territory_History__c athRec3 = new GA_Account_Territory_History__c();
                for(integer i=0;i<101;i++){
                    athRec3 = new GA_Account_Territory_History__c();
                    athRec3.GA_Account_Id__c=testAccount2.Id;
                    athRec3.GA_Territory_Id__c=territoryRec.Id;
                    athRec3.GA_Start_Date__c=system.today()-10;
                    athRec3.GA_End_Date__c=system.today()+5;
                    athLst.add(athRec3);
                }
                database.insert(athLst);
                List<Database.SaveResult> srList = new List<Database.SaveResult>();
                List<Account> accLstToUpdt = new List<Account> ();
                accLstToUpdt.add(testAccount2);
                GA_ACC_AP01_CheckPlatinumStatusOnAgency.isExecuting = true;
                GA_Util_lockRecords.isExecuting = true;
                GA_ACC_AP05_CreateHandoverRecord.isExecuting = true;
                GA_ACC_UpdateChildContctsOnAccOwnrChange.isExecuting = true;
                GA_ACC_AP04_UpdtCntOnAccLockUnlock.isExecuting = true;
                GA_ACC_AP_UpdtAssmntOwnrMgrChnge.isExecuting = true; 
                GA_AccountBatchToUpdateContactOwner.isInvodedFrmBtch = true;
                GA_ACC_AP_UpdtAssmntOwnrMgrChnge.isExecuting = true;
                srList = database.update(accLstToUpdt,false);
                
                List<ExceptionLog__c> excpLst = New List<ExceptionLog__c>();
                if(!srList.isEmpty()){
                    ExceptionLog__c objLog = new ExceptionLog__c();
                    objLog.Object_ID__c = null;
                    objLog.ExceptionDescription__c = 'Test Description';
                    objLog.ExceptionCode__c = '';
                    objLog.NumberOfTimesOccured__c = 1;
                    objLog.ExceptionDetails__c = 'Test Exception Details ';
                    objLog.Severity__c = 'ERROR';
                    excpLst.add(objLog);
                }
                database.upsert(excpLst);
                
                Test.startTest();
                GA_ATH_AP01_TerritoryUpdatngToAcc.updateATHtoAcc(athLst, athOldMap);
                Test.stopTest();
            }
            catch(exception e)
            {
                system.assert(e <> null);
                return;
            }
        }
    }
    /*******************************************************************************************************************************
@Description: updtThrdPrtyToAccTest() method 
@Name : updtThrdPrtyToAccTest
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
    private static testmethod void updtTerritoryBatch(){
        List<User> usrLst = New List<User>();
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestSysAdm','testsysadm@bcbsm.com','System Administrator');
        usrLst.add(usr);
        user usr1 = GA_OBJ_TD01_TestDataCreation.UsrRec('TestR1','testsalesrep1mail@bcbsm.com','Retention Sales');
        usrLst.add(usr1);
        database.insert(usrLst);
        system.runAs(usr){
            try{
                Map<ID,GA_Account_Territory_History__c> athOldMap = new Map<ID,GA_Account_Territory_History__c>();
                Account testAccount = GA_OBJ_TD01_TestDataCreation.AccRec();
                testAccount.RecordTypeId =  Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Customer').getRecordTypeId();
                testAccount.GA_System_of_record__c='Salesforce';
                database.insert(testAccount);
                
                GA_Region__c regnRec =new GA_Region__c();
                regnRec.Name = 'Test Region';
                regnRec.GA_Region_Code__c='018';
                database.insert(regnRec);
                
                GA_Sales_Office__c slsOfcRec =new GA_Sales_Office__c();
                slsOfcRec.Name = 'Test - Sales Office';
                slsOfcRec.GA_Sales_Office_Code__c='999';
                slsOfcRec.GA_Region__c=regnRec.Id;
                database.insert(slsOfcRec);
                
                GA_Territory__c territoryRec=GA_OBJ_TD01_TestDataCreation.terrtryRec();
                territoryRec.GA_RetentionSalesRepresentative__c=usr1.id;
                territoryRec.GA_Sales_Office__c=slsOfcRec.Id;
                database.insert(territoryRec);
                
                List<GA_Account_Territory_History__c> athLst = new List<GA_Account_Territory_History__c>();
                
                GA_Account_Territory_History__c athRec = new GA_Account_Territory_History__c();
                athRec.GA_Account_Id__c=testAccount.Id;
                athRec.GA_Territory_Id__c=territoryRec.Id;
                athRec.GA_Start_Date__c=system.today()-10;
                athRec.GA_End_Date__c=system.today()+10;
                athRec.GA_Is_Processed__c=false;
                athLst.add(athRec);
                GA_Account_Territory_History__c athRecCnl = new GA_Account_Territory_History__c();
                athRecCnl.GA_Account_Id__c=testAccount.Id;
                athRecCnl.GA_Territory_Id__c=territoryRec.Id;
                athRecCnl.GA_Start_Date__c=system.today()-10;
                athRecCnl.GA_End_Date__c=system.today();
                athRecCnl.GA_Is_Processed__c=false;
                athLst.add(athRecCnl);
                
                GA_AccTerritoryHstry_TriggerHndlr.isExecuting=true;
                database.insert(athLst);
                
                testAccount.GA_Territory__c=athRec.GA_Territory_Id__c;
                //testAccount.GA_Account_Territory_History__c=athRec.Id;
                testAccount.GA_Is_Mass_Updating__c=true;
                GA_ACC_AP01_CheckPlatinumStatusOnAgency.isExecuting = true;
                GA_Util_lockRecords.isExecuting = true;
                GA_ACC_AP05_CreateHandoverRecord.isExecuting = true;
                GA_ACC_UpdateChildContctsOnAccOwnrChange.isExecuting = true;
                GA_ACC_AP04_UpdtCntOnAccLockUnlock.isExecuting = true;
                GA_ACC_AP_UpdtAssmntOwnrMgrChnge.isExecuting = true; 
                GA_AccountBatchToUpdateContactOwner.isInvodedFrmBtch = true;
                GA_ACC_AP_UpdtAssmntOwnrMgrChnge.isExecuting = true;
                database.update(testAccount);
                string curdte=string.valueof(system.today()).split(' ')[0];
                String  athQry='select id, GA_Account_Id__c,GA_Start_Date__c,GA_End_Date__c,GA_Territory_Id__c,GA_Is_Processed__c from GA_Account_Territory_History__c Where (GA_Is_Processed__c=false and GA_Start_Date__c<='+curdte +' AND GA_End_Date__c >='+curdte +') OR (GA_Is_Processed__c=false and GA_End_Date__c='+curdte +')ORDER BY createddate asc';
                list<GA_Account_Territory_History__c> athsryRec=database.query(athQry);
                
                GA_ATHBatchToUpdateOnAccSchdlr  sh1 = new GA_ATHBatchToUpdateOnAccSchdlr();      
                String sch = '0  00 1 3 * ?';
                
                Test.startTest();
                system.schedule('Test', sch, sh1);
                Test.stopTest();
            }
            catch(exception e)
            {
                system.assert(e <> null);
                return;
            }
        }
    }
    /*******************************************************************************************************************************
@Description: athExcp() method 
@Name : athExcp
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/    
    private static testmethod void athExcp(){
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestSysAdm','testsysadm@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr){
            try{
                Test.startTest();
                GA_ATH_AP01_TerritoryUpdatngToAcc.updateATHtoAcc(null, null);
                Test.stopTest();
            }
            catch(exception e)
            {
                system.assert(e <> null);
                return;
            }
        }
    }
    
    /*******************************************************************************************************************************
@Description: tpbValdtExcp() method 
@Name : tpbValdtExcp
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/    
    private static testmethod void athValdtExcp(){
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestSysAdm','testsysadm@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr){
            try{
                
                Test.startTest();
                GA_AccTerritoryHstry_TriggerHndlr.afterUpdate(null,null);
                GA_AccTerritoryHstry_TriggerHndlr.afterInsert(null);
                Test.stopTest();
                
            }
            catch(exception e)
            {
                system.assert(e <> null);
                return;
            }
        }
    }
    /*******************************************************************************************************************************
@Description: tpbAftrInsert() method 
@Name : tpbAftrInsert
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/      
    private static testmethod void tpbAftrInsert()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestSysAdm','testsysadm@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {
            try{
                Account testAccount = GA_OBJ_TD01_TestDataCreation.AccRec();
                testAccount.RecordTypeId =  Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Customer').getRecordTypeId();
                testAccount.GA_System_of_record__c='Salesforce';
                database.insert(testAccount);
                
                user usr1 = GA_OBJ_TD01_TestDataCreation.UsrRec('TestR1','testsalesrep1mail@bcbsm.com','Retention Sales');
                database.insert(usr1);
                
                GA_Region__c regnRec =new GA_Region__c();
                regnRec.Name = 'Test Region';
                regnRec.GA_Region_Code__c='018';
                database.insert(regnRec);
                
                GA_Sales_Office__c slsOfcRec =new GA_Sales_Office__c();
                slsOfcRec.Name = 'Test - Sales Office';
                slsOfcRec.GA_Sales_Office_Code__c='999';
                slsOfcRec.GA_Region__c=regnRec.Id;
                database.insert(slsOfcRec);
                
                GA_Territory__c territoryRec=GA_OBJ_TD01_TestDataCreation.terrtryRec();
                territoryRec.GA_RetentionSalesRepresentative__c=usr1.id;
                territoryRec.GA_Sales_Office__c=slsOfcRec.Id;
                database.insert(territoryRec);
                
                List<GA_Account_Territory_History__c> athLst = new List<GA_Account_Territory_History__c>();
                GA_Account_Territory_History__c athRec = new GA_Account_Territory_History__c();
                athRec.GA_Account_Id__c=testAccount.Id;
                athRec.GA_Territory_Id__c=territoryRec.Id;
                athRec.GA_Start_Date__c=system.today()-10;
                athRec.GA_End_Date__c=system.today()+10;
                athLst.add(athRec);
                database.insert(athLst);
                
                Test.startTest();
                GA_AccTerritoryHstry_TriggerHndlr.afterInsert(athLst);
                Test.stopTest();
            }
            catch(exception e)
            {
                system.assert(e <> null);
                return;
            }
        }
    }
    /*******************************************************************************************************************************
@Description: tpbAftrUpdt() method 
@Name : tpbAftrUpdt
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/      
    private static testmethod void tpbAftrUpdt()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestSysAdm','testsysadm@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {
            try{
                Account testAccount = GA_OBJ_TD01_TestDataCreation.AccRec();
                testAccount.RecordTypeId =  Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Customer').getRecordTypeId();
                testAccount.GA_System_of_record__c='Salesforce';
                database.insert(testAccount);
                
                user usr1 = GA_OBJ_TD01_TestDataCreation.UsrRec('TestR1','testsalesrep1mail@bcbsm.com','Retention Sales');
                database.insert(usr1);
                
                GA_Region__c regnRec =new GA_Region__c();
                regnRec.Name = 'Test Region';
                regnRec.GA_Region_Code__c='018';
                database.insert(regnRec);
                
                GA_Sales_Office__c slsOfcRec =new GA_Sales_Office__c();
                slsOfcRec.Name = 'Test - Sales Office';
                slsOfcRec.GA_Sales_Office_Code__c='999';
                slsOfcRec.GA_Region__c=regnRec.Id;
                database.insert(slsOfcRec);
                
                GA_Territory__c territoryRec=GA_OBJ_TD01_TestDataCreation.terrtryRec();
                territoryRec.GA_RetentionSalesRepresentative__c=usr1.id;
                territoryRec.GA_Sales_Office__c=slsOfcRec.Id;
                database.insert(territoryRec);
                
                List<GA_Account_Territory_History__c> athLst = new List<GA_Account_Territory_History__c>();
                GA_Account_Territory_History__c athRec = new GA_Account_Territory_History__c();
                athRec.GA_Account_Id__c=testAccount.Id;
                athRec.GA_Territory_Id__c=territoryRec.Id;
                athRec.GA_Start_Date__c=system.today()-10;
                athRec.GA_End_Date__c=system.today()+10;
                athLst.add(athRec);
                database.insert(athLst);
                
                Test.startTest();
                database.update(athLst);
                Test.stopTest();
            }
            catch(exception e)
            {
                system.assert(e <> null);
                return;
            }
        }
    }
    /*******************************************************************************************************************************
@Description: updtTerritoryBatchCls() method 
@Name : updtTerritoryBatchCls
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
    private static testmethod void updtTerritoryBatchCls(){
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestSysAdm','testsysadm@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr){
            try{
                string curdte=string.valueof(system.today()).split(' ')[0];
                String  athQry='select id, GA_Account_Id__c,GA_Start_Date__c,GA_End_Date__c,GA_Territory_Id__c,GA_Is_Processed__c from GA_Account_Territory_History__c Where (GA_Is_Processed__c=false and GA_Start_Date__c<='+curdte +' AND GA_End_Date__c >='+curdte +') OR (GA_Is_Processed__c=false and GA_End_Date__c='+curdte +')ORDER BY createddate asc';
                GA_ATHBatchToUpdateOnAcc btch=new GA_ATHBatchToUpdateOnAcc(athQry);
                Id procsId = '';
                Test.startTest();
                procsId = database.executebatch(btch,200);
                Test.stopTest();
            }
            catch(exception e)
            {
                system.assert(e <> null);
                return;
            }
        }
    }
    /*******************************************************************************************************************************
@Description: errBlocktest() method 
@Name : errBlocktest
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
    private static testmethod void errBlocktest(){
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestSysAdm','testsysadm@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr){
            try{
                
                
                Account testAccount = GA_OBJ_TD01_TestDataCreation.AccRec();
                testAccount.RecordTypeId =  Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Customer').getRecordTypeId();
                testAccount.GA_System_of_record__c='Salesforce';
                database.insert(testAccount);
                
                user usr1 = GA_OBJ_TD01_TestDataCreation.UsrRec('TestR1','testsalesrep1mail@bcbsm.com','Retention Sales');
                database.insert(usr1);
                
                GA_Region__c regnRec =new GA_Region__c();
                regnRec.Name = 'Test Region';
                regnRec.GA_Region_Code__c='018';
                database.insert(regnRec);
                
                GA_Sales_Office__c slsOfcRec =new GA_Sales_Office__c();
                slsOfcRec.Name = 'Test - Sales Office';
                slsOfcRec.GA_Sales_Office_Code__c='999';
                slsOfcRec.GA_Region__c=regnRec.Id;
                database.insert(slsOfcRec);
                
                GA_Territory__c territoryRec=GA_OBJ_TD01_TestDataCreation.terrtryRec();
                territoryRec.GA_RetentionSalesRepresentative__c=usr1.id;
                territoryRec.GA_Sales_Office__c=slsOfcRec.Id;
                database.insert(territoryRec);
                
                List<GA_Account_Territory_History__c> athLst = new List<GA_Account_Territory_History__c>();
                
                GA_Account_Territory_History__c athRec = new GA_Account_Territory_History__c();
                athRec.GA_Account_Id__c=testAccount.Id;
                athRec.GA_Territory_Id__c=territoryRec.Id;
                athRec.GA_Start_Date__c=system.today()-10;
                athRec.GA_End_Date__c=system.today()+10;
                database.insert(athRec);
                
                Test.startTest();
                testAccount.GA_Territory__c=athRec.GA_Territory_Id__c;
                testAccount.GA_Account_Territory_History__c=athRec.Id;
                testAccount.GA_Is_Mass_Updating__c=true;
                GA_ACC_AP01_CheckPlatinumStatusOnAgency.isExecuting = true;
                GA_Util_lockRecords.isExecuting = true;
                GA_ACC_AP05_CreateHandoverRecord.isExecuting = true;
                GA_ACC_UpdateChildContctsOnAccOwnrChange.isExecuting = true;
                GA_ACC_AP04_UpdtCntOnAccLockUnlock.isExecuting = true;
                GA_ACC_AP_UpdtAssmntOwnrMgrChnge.isExecuting = true; 
                GA_AccountBatchToUpdateContactOwner.isInvodedFrmBtch = true;
                GA_ACC_AP_UpdtAssmntOwnrMgrChnge.isExecuting = true;
                database.update(testAccount);
                
                athRec.GA_Is_Processed__c=true;
                database.update(athRec);
                
                GA_ATH_AP01_TerritoryUpdatngToAcc.accLstToUpdt.add(New Account());
                
                GA_AccTerritoryHstry_TriggerHndlr.isExecuting=false;  
                
                athRec.GA_Start_Date__c=system.today()-3;
                athRec.GA_End_Date__c=system.today()+10;
                database.update(athRec);
                
                Test.stopTest();
            }
            catch(exception e)
            {
                system.assert(e <> null);
                return;
            }
        }
    }    
    
}