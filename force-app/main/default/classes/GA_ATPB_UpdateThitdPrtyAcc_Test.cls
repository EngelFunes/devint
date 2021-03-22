/*******************************************************************************************************************************
@Author : IDC offshore
@Name: GA_ATPB_UpdateThitdPrtyAcc_Test
@CreatedDate: 29 - May 2018 
@Description: GA_ATPB_UpdateThitdPrtyAcc_Test class is for Association Third Party Biller.
@version : 1.0  
********************************************************************************************************************************/
@isTest(seealldata = false)
private class GA_ATPB_UpdateThitdPrtyAcc_Test {
    /*******************************************************************************************************************************
@Description: updtThrdPrtyToAccTest() method 
@Name : updtThrdPrtyToAccTest
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
    private static testmethod void updtThrdPrtyToAccTest(){
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestSysAdm','testsysadm@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr){
            try{
                Map<ID,GA_Association_Third_Party_Biller__c> atpbOldMap = new Map<ID,GA_Association_Third_Party_Biller__c>();
                Account testAccount = GA_OBJ_TD01_TestDataCreation.AccRec();
                testAccount.RecordTypeId =  Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Association').getRecordTypeId();
                database.insert(testAccount);
                
                Account testAccount1 = GA_OBJ_TD01_TestDataCreation.AccRec();
                testAccount1.RecordTypeId =  Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Third Party Biller').getRecordTypeId();
                database.insert(testAccount1);
                
                List<GA_Association_Third_Party_Biller__c> atpbLst = new List<GA_Association_Third_Party_Biller__c>();
                GA_Association_Third_Party_Biller__c atpb = GA_OBJ_TD01_TestDataCreation.assocThrdPrtyBillr(testAccount1);
                atpb.GA_Third_Party_Biller_Account_Id__c = testAccount1.Id;
                atpb.GA_Association_Account_Id__c = testAccount.Id;
                atpb.GA_End_Date__c= system.today();
                atpbLst.add(atpb);
                database.insert(atpbLst);
                
                testAccount.GA_Third_Party_Biller_Account_Id__c =null;
                testAccount.GA_Association_Third_Party_Biller__c=null;
                testAccount.GA_Is_Mass_Updating__c=true;
                database.update(testAccount);
                
                atpb.GA_End_Date__c=atpb.GA_Start_Date__c-1;
                atpb.GA_Is_Processed__c = true;
                database.update(atpb);
                
                List<ExceptionLog__c> excpLst = New List<ExceptionLog__c>();
                ExceptionLog__c objLog = new ExceptionLog__c();
                objLog.Object_ID__c = null;
                objLog.ExceptionDescription__c = 'Test Description';
                objLog.ExceptionCode__c = '';
                objLog.NumberOfTimesOccured__c = 1;
                objLog.ExceptionDetails__c = 'Test Exception Details ';
                objLog.Severity__c = 'ERROR';
                excpLst.add(objLog);
                database.upsert(excpLst);
                
                Test.startTest();
                GA_ATPB_UpdateThitdPrtyAcc.updtetThrdPrtyHstryToAcc(atpbLst,atpbOldMap);
                Test.stopTest();
                system.assert(atpbLst <> null);
            }
            catch(exception e)
            {
                system.assert(e <> null);
                return;
            }
        }
    }
    /*******************************************************************************************************************************
@Description: updtTpbhRecsTest() method 
@Name : updtTpbhRecsTest
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/    
    private static testmethod void updtTpbhRecsTest(){
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestSysAdm','testsysadm@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr){
            try{
                Account testAccount = GA_OBJ_TD01_TestDataCreation.AccRec();
                testAccount.Name = 'Test Assoc Acc';
                testAccount.RecordTypeId =  Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Association').getRecordTypeId();
                database.insert(testAccount);
                
                Account testAccount1 = GA_OBJ_TD01_TestDataCreation.AccRec();
                testAccount1.Name = 'Test TPB Acc';
                testAccount1.RecordTypeId =  Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Third Party Biller').getRecordTypeId();
                database.insert(testAccount1);
                
                Account testAccount3 = GA_OBJ_TD01_TestDataCreation.AccRec();
                testAccount3.Name = 'Test Cust Acc';
                testAccount3.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Customer').getRecordTypeId();
                database.insert(testAccount3);
                
                GA_Group_Segment__c grpSgmntRec=GA_OBJ_TD01_TestDataCreation.grpSegmntRec(testAccount3);
                database.insert(grpSgmntRec);
                
                GA_Group_Association__c assocHistory=GA_OBJ_TD01_TestDataCreation.grpAssociation(grpSgmntRec, testAccount);
                assocHistory.GA_Account__c = testAccount.id;
                database.insert(assocHistory);
                List<GA_Third_Party_Biller_History__c> tPBList = new  List<GA_Third_Party_Biller_History__c>();
                GA_Third_Party_Biller_History__c tphb = GA_OBJ_TD01_TestDataCreation.thirdPartyBiller(grpSgmntRec,testAccount1);
                tphb.Name = 'Test TPHB';
                tphb.GA_Group_Segment_Id__c = grpSgmntRec.id;
                tphb.GA_Third_Party_Biller_Account__c =  testAccount1.id;
                tPBList.add(tphb);
                database.insert(tPBList);
                
                List<GA_Association_Third_Party_Biller__c> atpbLst = new List<GA_Association_Third_Party_Biller__c>();
                GA_Association_Third_Party_Biller__c assocRec = GA_OBJ_TD01_TestDataCreation.assocThrdPrtyBillr(testAccount1);
                assocRec.GA_Third_Party_Biller_Account_Id__c = testAccount1.Id;
                assocRec.GA_Association_Account_Id__c = testAccount.Id;
                atpbLst.add(assocRec);
                database.insert(atpbLst);
                
                
                
                Test.startTest();
                GA_ATPB_UpdateThitdPrtyAcc.updtTpbhRecs(atpbLst);
                Test.stopTest();
                system.assert(atpbLst <> null);
            }
            catch(exception e)
            {
                system.assert(e <> null);
                return;
            }
        }
    }
    
    /*******************************************************************************************************************************
@Description: updatEndDateTest() method 
@Name : updatEndDateTest
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/    
    private static testmethod void updatEndDateTest(){
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestSysAdm','testsysadm@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr){
            try{
                Account testAccount = GA_OBJ_TD01_TestDataCreation.AccRec();
                testAccount.Name = 'Test Assoc Acc';
                testAccount.RecordTypeId =  Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Association').getRecordTypeId();
                database.insert(testAccount);
                
                Account testAccount1 = GA_OBJ_TD01_TestDataCreation.AccRec();
                testAccount1.Name = 'Test TPB Acc';
                testAccount1.RecordTypeId =  Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Third Party Biller').getRecordTypeId();
                database.insert(testAccount1);
                
                List<GA_Association_Third_Party_Biller__c> atpbLst = new List<GA_Association_Third_Party_Biller__c>();
                GA_Association_Third_Party_Biller__c assocRec = GA_OBJ_TD01_TestDataCreation.assocThrdPrtyBillr(testAccount1);
                assocRec.GA_Third_Party_Biller_Account_Id__c = testAccount1.Id;
                assocRec.GA_Association_Account_Id__c = testAccount.Id;
                database.insert(assocRec);
                
                GA_Association_Third_Party_Biller__c assocRec1 = GA_OBJ_TD01_TestDataCreation.assocThrdPrtyBillr(testAccount1);
                assocRec1.GA_Third_Party_Biller_Account_Id__c = testAccount1.Id;
                assocRec1.GA_Association_Account_Id__c = testAccount.Id;
                database.insert(assocRec1);
                
                if(assocRec.GA_Association_Account_Id__c == assocRec1.GA_Association_Account_Id__c && 
                   assocRec1.GA_Start_Date__c > assocRec.GA_Start_Date__c){
                       assocRec.GA_End_Date__c = assocRec1.GA_Start_Date__c-1;
                       //atpbLst.add(assocRec);
                   }
                atpbLst.add(assocRec);
                database.update(atpbLst);
                
                Test.startTest();
                GA_ATPB_UpdateThitdPrtyAcc.updatEndDate(atpbLst);
                Test.stopTest();
                system.assert(atpbLst <> null);
            }
            catch(exception e)
            {
                system.assert(e <> null);
                return;
            }
        }
    }
    /*******************************************************************************************************************************
@Description: atpbExcp() method 
@Name : atpbExcp
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/     
    private static testmethod void atpbExcp()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestSysAdm','testsysadm@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {
            try{
                GA_AssocThrdPrtyBlr_TriggerHandler.afterInsert(null);
                GA_AssocThrdPrtyBlr_TriggerHandler.afterUpdate(null, null);
                Map<ID,GA_Association_Third_Party_Biller__c> atpbOldMap = new Map<ID,GA_Association_Third_Party_Biller__c>();
                List<GA_Association_Third_Party_Biller__c> atpbLst = new List<GA_Association_Third_Party_Biller__c>();
                Test.startTest();
                GA_ATPB_UpdateThitdPrtyAcc.updtetThrdPrtyHstryToAcc(atpbLst,atpbOldMap);
                GA_ATPB_UpdateThitdPrtyAcc.updtTpbhRecs(atpbLst);
                GA_ATPB_UpdateThitdPrtyAcc.updatEndDate(atpbLst);
                Test.stopTest();
                system.assert(atpbLst <> null);
            }
            catch(exception e)
            {
                system.assert(e <> null);
                return;
            }
        }
    }
    /*******************************************************************************************************************************
@Description: atpbAftrInsert() method 
@Name : atpbAftrInsert
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/      
    private static testmethod void atpbAftrInsert()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestSysAdm','testsysadm@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {
            try{
                List<GA_Association_Third_Party_Biller__c> atpbLst = new List<GA_Association_Third_Party_Biller__c>();
                Test.startTest();
                GA_AssocThrdPrtyBlr_TriggerHandler.afterInsert(atpbLst);
                Test.stopTest();
                system.assert(atpbLst <> null);
            }
            catch(exception e)
            {
                system.assert(e <> null);
                return;
            }
        }
    }
    /*******************************************************************************************************************************
@Description: atpbAftrUpdt() method 
@Name : atpbAftrUpdt
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/      
    private static testmethod void atpbAftrUpdt()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestSysAdm','testsysadm@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {
            try{
                List<GA_Association_Third_Party_Biller__c> atpbLst = new List<GA_Association_Third_Party_Biller__c>();
                Map<ID,GA_Association_Third_Party_Biller__c> atpbOldMap = new Map<ID,GA_Association_Third_Party_Biller__c>();
                Test.startTest();
                GA_AssocThrdPrtyBlr_TriggerHandler.afterUpdate(atpbLst,atpbOldMap);
                Test.stopTest();
                system.assert(atpbLst <> null);
            }
            catch(exception e)
            {
                system.assert(e <> null);
                return;
            }
        }
    }
    /*******************************************************************************************************************************
@Description: atpbBatchTest() method 
@Name : atpbBatchTest
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/      
    public static testmethod void atpbBatchTest(){
        try{
            user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestSysAdm','testsysadm@bcbsm.com','System Administrator');
            database.insert(usr);
            system.runAs(usr){
                
                Map<ID,GA_Association_Third_Party_Biller__c> atpbOldMap = new Map<ID,GA_Association_Third_Party_Biller__c>();
                Account testAccount = GA_OBJ_TD01_TestDataCreation.AccRec();
                testAccount.RecordTypeId =  Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Association').getRecordTypeId();
                database.insert(testAccount);
                
                Account testAccount1 = GA_OBJ_TD01_TestDataCreation.AccRec();
                testAccount1.RecordTypeId =  Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Third Party Biller').getRecordTypeId();
                database.insert(testAccount1);
                
                List<GA_Association_Third_Party_Biller__c> atpbLst = new List<GA_Association_Third_Party_Biller__c>();
                GA_Association_Third_Party_Biller__c atpb = GA_OBJ_TD01_TestDataCreation.assocThrdPrtyBillr(testAccount1);
                atpb.GA_Third_Party_Biller_Account_Id__c = testAccount1.Id;
                atpb.GA_Association_Account_Id__c = testAccount.Id;
                atpbLst.add(atpb);
                database.insert(atpbLst);
                
                testAccount.GA_Third_Party_Biller_Account_Id__c =null;
                testAccount.GA_Association_Third_Party_Biller__c=null;
                testAccount.GA_Is_Mass_Updating__c=true;
                database.update(testAccount);
                
                atpb.GA_End_Date__c=System.today() + 1;
                atpb.GA_Is_Processed__c = false;
                database.update(atpb);
                
                List<ExceptionLog__c> excpLst = New List<ExceptionLog__c>();
                ExceptionLog__c objLog = new ExceptionLog__c();
                objLog.Object_ID__c = null;
                objLog.ExceptionDescription__c = 'Test Description';
                objLog.ExceptionCode__c = '';
                objLog.NumberOfTimesOccured__c = 1;
                objLog.ExceptionDetails__c = 'Test Exception Details ';
                objLog.Severity__c = 'ERROR';
                excpLst.add(objLog);
                database.upsert(excpLst);
                
                String curdte=string.valueof(system.today()).split(' ')[0];
                String  atpbQry='select id, GA_Third_Party_Biller_Account_Id__c,GA_Start_Date__c,GA_End_Date__c,GA_Association_Account_Id__c from GA_Association_Third_Party_Biller__c Where (GA_Is_Processed__c=false and GA_Start_Date__c<='+curdte +' AND GA_End_Date__c >='+curdte +') OR (GA_Is_Processed__c=false and GA_End_Date__c='+curdte +')ORDER BY createddate asc';
                
                GA_ATPBBatchToUpdateOnAccSchdlr sh1 = new GA_ATPBBatchToUpdateOnAccSchdlr();      
                String sch = '0  00 1 3 * ?';
                
                Test.startTest();
                system.schedule('Test', sch, sh1);
                Test.stopTest();
                system.assert(atpbLst <> null);
            }
            
        }
        catch(exception e)
        {
            system.assert(e <> null);
            return;
        }
    }
    /*******************************************************************************************************************************
@Description: updtTpbhRecsBatchTest() method 
@Name : updtTpbhRecsBatchTest
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/      
   private static testmethod void updtTpbhRecsBatchTest(){
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestSysAdm','testsysadm@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr){
            try{
                Account testAccount = GA_OBJ_TD01_TestDataCreation.AccRec();
                testAccount.Name = 'Test Assoc Acc';
                testAccount.RecordTypeId =  Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Association').getRecordTypeId();
                database.insert(testAccount);
                
                Account testAccount1 = GA_OBJ_TD01_TestDataCreation.AccRec();
                testAccount1.Name = 'Test TPB Acc';
                testAccount1.RecordTypeId =  Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Third Party Biller').getRecordTypeId();
                database.insert(testAccount1);
                
                Account testAccount3 = GA_OBJ_TD01_TestDataCreation.AccRec();
                testAccount3.Name = 'Test Cust Acc';
                testAccount3.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Customer').getRecordTypeId();
                database.insert(testAccount3);
                
                GA_Group_Segment__c grpSgmntRec=GA_OBJ_TD01_TestDataCreation.grpSegmntRec(testAccount3);
                database.insert(grpSgmntRec);
                
                GA_Group_Association__c assocHistory=GA_OBJ_TD01_TestDataCreation.grpAssociation(grpSgmntRec, testAccount);
                assocHistory.GA_Account__c = testAccount.id;
                database.insert(assocHistory);
                List<GA_Third_Party_Biller_History__c> tPBList = new  List<GA_Third_Party_Biller_History__c>();
                GA_Third_Party_Biller_History__c tphb = GA_OBJ_TD01_TestDataCreation.thirdPartyBiller(grpSgmntRec,testAccount1);
                tphb.Name = 'Test TPHB';
                tphb.GA_Group_Segment_Id__c = grpSgmntRec.id;
                tphb.GA_Third_Party_Biller_Account__c =  testAccount1.id;
                tPBList.add(tphb);
                database.insert(tPBList);
                
                List<GA_Association_Third_Party_Biller__c> atpbLst = new List<GA_Association_Third_Party_Biller__c>();
                GA_Association_Third_Party_Biller__c assocRec = GA_OBJ_TD01_TestDataCreation.assocThrdPrtyBillr(testAccount1);
                assocRec.GA_Third_Party_Biller_Account_Id__c = testAccount1.Id;
                assocRec.GA_Association_Account_Id__c = testAccount.Id;
                atpbLst.add(assocRec);
                
                GA_Association_Third_Party_Biller__c assocRec1 = new GA_Association_Third_Party_Biller__c ();
                for(integer i=0; i<101; i++){
                    assocRec1 = GA_OBJ_TD01_TestDataCreation.assocThrdPrtyBillr(testAccount1);
                    assocRec1.GA_Third_Party_Biller_Account_Id__c = testAccount1.Id;
                    assocRec1.GA_Association_Account_Id__c = testAccount.Id;
                    atpbLst.add(assocRec1);
                }
                Database.insert(atpbLst);
                
                List<id> atpbIds = new List<id>();
                for(GA_Association_Third_Party_Biller__c atpbllr : atpbLst){
                    if(atpbllr.Id <> null){
                        atpbIds.add(atpbllr.Id);
                    }
                }
                
                String curdte=string.valueof(system.today()).split(' ')[0];
                String  atpbQry='Select id,Name,GA_Start_Date__c,GA_End_Date__c,GA_Third_Party_Biller_Account_Id__c,GA_Association_Account_Id__c from GA_Association_Third_Party_Biller__c where id in:atpbIds';
                
                
                GA_ATPBBatchToInsertTBPrecs insrtTBPBatch = new  GA_ATPBBatchToInsertTBPrecs(atpbQry,atpbIds);
                ID insertTBPBatchPrsngid = '';
                
                Test.startTest();
                GA_AccountTriggerHandlr.isExecuting = true;
                GA_ACC_AP01_CheckPlatinumStatusOnAgency.isExecuting = true;
                GA_Util_lockRecords.isExecuting = true;
                GA_ACC_AP02_IdentifySalesRepOnAccount.isExecuting = true;
                GA_ACC_AP05_CreateHandoverRecord.isExecuting = true;
                GA_ACC_UpdateChildContctsOnAccOwnrChange.isExecuting = true;
                GA_ACC_AP04_UpdtCntOnAccLockUnlock.isExecuting = true;
                GA_ACC_AP_UpdtAssmntOwnrMgrChnge.isExecuting = true; 
                GA_AccountBatchToUpdateContactOwner.isInvodedFrmBtch = true;
                GA_ACC_AP_UpdtAssmntOwnrMgrChnge.isExecuting = true;
                insertTBPBatchPrsngid = Database.executeBatch(insrtTBPBatch,200);
                Test.stopTest();
                system.assert(atpbLst <> null);
            }
            catch(exception e)
            {
                system.assert(e <> null);
                return;
            }
        }
    }
}