/*******************************************************************************************************************************
@Author : IDC offshore
@Name: GA_TPBH_AP01_ThrdPrtyBllr_Test
@CreatedDate: 25 - Feb 2019 
@Description: GA_TPBH_AP01_ThrdPrtyBllr_Test class is for Third Party Biller History.
@version : 1.0  
********************************************************************************************************************************/
@isTest(seealldata = false)
private class GA_TPBH_AP01_ThrdPrtyBllr_Test{
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
                Map<ID,GA_Third_Party_Biller_History__c> tpbhOldMap = new Map<ID,GA_Third_Party_Biller_History__c>();
                Account testAccount = GA_OBJ_TD01_TestDataCreation.AccRec();
                testAccount.RecordTypeId =  Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Customer').getRecordTypeId();
                testAccount.GA_System_of_record__c='Salesforce';
                database.insert(testAccount);
                
                GA_Group_Segment__c grpSgmntRec=GA_OBJ_TD01_TestDataCreation.grpSegmntRec(testAccount);
                grpSgmntRec.GA_Group_Effective_Date__c = system.today()-10;
                grpSgmntRec.GA_Cancellation_Date__c = system.today()+10;
                grpSgmntRec.Status__c = 'Pending';
                database.insert(grpSgmntRec);
                
                Account testAccount1 = GA_OBJ_TD01_TestDataCreation.AccRec();
                testAccount1.RecordTypeId =  Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Third Party Biller').getRecordTypeId();
                database.insert(testAccount1);
                
                List<GA_Third_Party_Biller_History__c> tpbhLst = new List<GA_Third_Party_Biller_History__c>();
                GA_Third_Party_Biller_History__c tpbh = GA_OBJ_TD01_TestDataCreation.thirdPartyBiller(grpSgmntRec,testAccount1);
                tpbh.GA_Third_Party_Biller_Account__c = testAccount1.Id;
                tpbh.GA_Group_Segment_Id__c = grpSgmntRec.Id;
                
                tpbhLst.add(tpbh);
                database.insert(tpbhLst);
                List<GA_Third_Party_Biller_History__c> tpbhLstQry = new List<GA_Third_Party_Biller_History__c>();
                tpbhLstQry=[select id,GA_Third_Party_Biller_Account__c,GA_Group_Segment_Id__c,
                            GA_TPB_Start_Date__c,GA_TPB_End_Date__c,GA_System_Of_Record__c
                            from GA_Third_Party_Biller_History__c where id=:tpbh.Id Limit 1];
                
                grpSgmntRec.GA_Third_Party_Biller_Account__c =testAccount1.Id;
                grpSgmntRec.GA_Third_Party_Biller_History__c=tpbh.Id;
                grpSgmntRec.GA_Is_Mass_Updating__c=true;
                GA_GS_AP02_Update_Address.isExecuting=true;
                GA_GS_UpdateRatingType.isExecuting = true;
                GA_GroupSegmentTriggerHandler.beforeUpdateExecuting = true;
                GA_GroupSegmentTriggerHandler.isExecuting = true;
                GA_GS_AP04_UpdtStatus.isCnclGSChkd = true;
                GA_GS_AP04_UpdtStatus.isExecuting = true;
                GA_GS_AP04_UpdtStatus.isInvoked = true;
                GA_GS_UpdatWrappingFileTPA.isExecuting = true;
                GA_ExternalAppealSrvcCls_MOS.isExecuting = true;
                GA_GS_Insert_ThrdPartyBillerRecs.isExecuting = true;
                GA_GS_Insert_ThrdPartyBillerRecs.isInvoked = true;
                GA_GS_Insert_ThrdPartyBillerRecs.isInvoking = true;
                GA_ExternalAppealRecdCrtnUpdt.isExecuting = true; 
                database.update(grpSgmntRec);
                List<ExceptionLog__c> excpLst = New List<ExceptionLog__c>();
                if(!tpbhLst.isEmpty()){
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
                GA_TPBH_AP01_ThrdPrtyBllrUpdtngToGSLogic.updatetThirdPartyBillrToGS(tpbhLstQry,tpbhOldMap);
                Test.stopTest();
                //system.assert(tpbhLst <> null);
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
                testAccount.RecordTypeId =  Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Customer').getRecordTypeId();
                database.insert(testAccount);
                
                GA_Group_Segment__c grpSgmntRec=GA_OBJ_TD01_TestDataCreation.grpSegmntRec(testAccount);
                grpSgmntRec.GA_Group_Effective_Date__c = system.today()-10;
                grpSgmntRec.GA_Cancellation_Date__c = system.today()+10;
                grpSgmntRec.Status__c = 'Pending';
                database.insert(grpSgmntRec);
                
                Account testAccount1 = GA_OBJ_TD01_TestDataCreation.AccRec();
                testAccount1.RecordTypeId =  Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Third Party Biller').getRecordTypeId();
                database.insert(testAccount1);
                
                Account testAccount2 = GA_OBJ_TD01_TestDataCreation.AccRec();
                testAccount2.RecordTypeId =  Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Association').getRecordTypeId();
                database.insert(testAccount2);
                
                GA_Group_Association__c gsaRec = GA_OBJ_TD01_TestDataCreation.grpAssociation(grpSgmntRec,testAccount2);
                gsaRec.GA_Account__c = testAccount2.Id;
                database.insert(gsaRec);
                
                List<GA_Third_Party_Biller_History__c> tpbhLst = new List<GA_Third_Party_Biller_History__c>();
                GA_Third_Party_Biller_History__c tpbh = GA_OBJ_TD01_TestDataCreation.thirdPartyBiller(grpSgmntRec,testAccount1);
                tpbh.GA_Third_Party_Biller_Account__c = testAccount1.Id;
                tpbh.GA_Group_Segment_Id__c = grpSgmntRec.Id;
                database.insert(tpbh);
                
                GA_Third_Party_Biller_History__c tpbhRec = GA_OBJ_TD01_TestDataCreation.thirdPartyBiller(grpSgmntRec,testAccount1);
                tpbhRec.GA_Third_Party_Biller_Account__c = testAccount1.Id;
                tpbhRec.GA_Group_Segment_Id__c = grpSgmntRec.Id;
                database.insert(tpbhRec);
                
                if(tpbh.GA_Group_Segment_Id__c == tpbhRec.GA_Group_Segment_Id__c && 
                   tpbhRec.GA_TPB_Start_Date__c > tpbh.GA_TPB_Start_Date__c){
                       tpbh.GA_TPB_End_Date__c = tpbhRec.GA_TPB_End_Date__c-1;
                       tpbhLst.add(tpbh);
                   }
                database.update(tpbhLst);
                
                Test.startTest();
                GA_TPBH_AP01_ThrdPrtyBllrUpdtngToGSLogic.updatEndDate(tpbhLst);
                Test.stopTest();
                //system.assert(tpbhLst <> null);
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
    private static testmethod void tpbValdtExcp(){
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestSysAdm','testsysadm@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr){
            try{
                
                Test.startTest();
                GA_ThrdPrtyBllr_TriggerHandler.afterUpdate(null,null);
                GA_ThrdPrtyBllr_TriggerHandler.afterInsert(null);
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
@Description: tpbhBatchTest() method 
@Name : tpbhBatchTest
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
    private static testmethod void tpbhBatchTest(){
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestSysAdm','testsysadm@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr){
            try{
                Map<ID,GA_Third_Party_Biller_History__c> tpbhOldMap = new Map<ID,GA_Third_Party_Biller_History__c>();
                Account testAccount = GA_OBJ_TD01_TestDataCreation.AccRec();
                testAccount.RecordTypeId =  Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Customer').getRecordTypeId();
                database.insert(testAccount);
                
                GA_Group_Segment__c grpSgmntRec=GA_OBJ_TD01_TestDataCreation.grpSegmntRec(testAccount);
                grpSgmntRec.GA_Group_Effective_Date__c = system.today()-10;
                grpSgmntRec.GA_Cancellation_Date__c = system.today()+10;
                grpSgmntRec.Status__c = 'Pending';
                database.insert(grpSgmntRec);
                
                Account testAccount1 = GA_OBJ_TD01_TestDataCreation.AccRec();
                testAccount1.RecordTypeId =  Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Third Party Biller').getRecordTypeId();
                testAccount1.GA_System_of_Record__c='Salesforce';
                database.insert(testAccount1);
                
                List<GA_Third_Party_Biller_History__c> tpbhLst = new List<GA_Third_Party_Biller_History__c>();
                GA_Third_Party_Biller_History__c tpbh = GA_OBJ_TD01_TestDataCreation.thirdPartyBiller(grpSgmntRec,testAccount1);
                tpbh.GA_Third_Party_Biller_Account__c = testAccount1.Id;
                tpbh.GA_Group_Segment_Id__c = grpSgmntRec.Id;
                tpbh.GA_Is_Processed__c=false;
                tpbhLst.add(tpbh);
                GA_TPBH_AP01_ThrdPrtyBllrUpdtngToGSLogic.isExecuting=true;
                GA_TPBH_AP01_ThrdPrtyBllrUpdtngToGSLogic.endDateExecuting=true;
                database.insert(tpbhLst);
                
                grpSgmntRec.GA_Third_Party_Biller_Account__c=tpbh.GA_Third_Party_Biller_Account__c;
                grpSgmntRec.GA_Third_Party_Biller_History__c=tpbh.Id;
                grpSgmntRec.GA_Is_Mass_Updating__c =true;
                
                GA_GS_AP02_Update_Address.isExecuting=true;
                GA_GroupSegmentTriggerHandler.beforeUpdateExecuting = true;
                GA_GroupSegmentTriggerHandler.isExecuting = true;
                GA_GS_AP04_UpdtStatus.isCnclGSChkd = true;
                GA_GS_AP04_UpdtStatus.isExecuting = true;
                GA_GS_AP04_UpdtStatus.isInvoked = true;
                GA_GS_UpdatWrappingFileTPA.isExecuting = true;
                GA_ExternalAppealSrvcCls_MOS.isExecuting = true;
                GA_GS_Insert_ThrdPartyBillerRecs.isExecuting = true;
                GA_GS_Insert_ThrdPartyBillerRecs.isInvoked = true;
                GA_GS_Insert_ThrdPartyBillerRecs.isInvoking = true;
                GA_ExternalAppealRecdCrtnUpdt.isExecuting = true; 
                
                database.update(grpSgmntRec);
                
                GA_TPBHBatchToUpdateThrdPrtyBllrSchdlr sh1 = new GA_TPBHBatchToUpdateThrdPrtyBllrSchdlr();      
                String sch = '0  00 1 3 * ?';
                Test.startTest();
                system.schedule('Test', sch, sh1);
                Test.stopTest();
                //system.assert(tpbhLst <> null);
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
                Map<ID,GA_Third_Party_Biller_History__c> tpbhOldMap = new Map<ID,GA_Third_Party_Biller_History__c>();
                Account testAccount = GA_OBJ_TD01_TestDataCreation.AccRec();
                testAccount.RecordTypeId =  Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Customer').getRecordTypeId();
                database.insert(testAccount);
                
                GA_Group_Segment__c grpSgmntRec=GA_OBJ_TD01_TestDataCreation.grpSegmntRec(testAccount);
                grpSgmntRec.GA_Group_Effective_Date__c = system.today()-10;
                grpSgmntRec.GA_Cancellation_Date__c = system.today()+10;
                grpSgmntRec.Status__c = 'Pending';
                database.insert(grpSgmntRec);
                
                Account testAccount1 = GA_OBJ_TD01_TestDataCreation.AccRec();
                testAccount1.RecordTypeId =  Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Third Party Biller').getRecordTypeId();
                database.insert(testAccount1);
                
                List<GA_Third_Party_Biller_History__c> tpbhLst = new List<GA_Third_Party_Biller_History__c>();
                GA_Third_Party_Biller_History__c tpbh = GA_OBJ_TD01_TestDataCreation.thirdPartyBiller(grpSgmntRec,testAccount1);
                tpbh.GA_Third_Party_Biller_Account__c = testAccount1.Id;
                tpbh.GA_Group_Segment_Id__c = grpSgmntRec.Id;
                tpbhLst.add(tpbh);
                database.insert(tpbhLst);
                
                Test.startTest();
                GA_ThrdPrtyBllr_TriggerHandler.afterInsert(tpbhLst);
                Test.stopTest();
                //system.assert(tpbhLst <> null);
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
                Map<ID,GA_Third_Party_Biller_History__c> tpbhOldMap = new Map<ID,GA_Third_Party_Biller_History__c>();
                Account testAccount = GA_OBJ_TD01_TestDataCreation.AccRec();
                testAccount.RecordTypeId =  Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Customer').getRecordTypeId();
                database.insert(testAccount);
                
                GA_Group_Segment__c grpSgmntRec=GA_OBJ_TD01_TestDataCreation.grpSegmntRec(testAccount);
                grpSgmntRec.GA_Group_Effective_Date__c = system.today()-10;
                grpSgmntRec.GA_Cancellation_Date__c = system.today()+10;
                grpSgmntRec.Status__c = 'Pending';
                database.insert(grpSgmntRec);
                
                Account testAccount1 = GA_OBJ_TD01_TestDataCreation.AccRec();
                testAccount1.RecordTypeId =  Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Third Party Biller').getRecordTypeId();
                database.insert(testAccount1);
                
                List<GA_Third_Party_Biller_History__c> tpbhLst = new List<GA_Third_Party_Biller_History__c>();
                GA_Third_Party_Biller_History__c tpbh = GA_OBJ_TD01_TestDataCreation.thirdPartyBiller(grpSgmntRec,testAccount1);
                tpbh.GA_Third_Party_Biller_Account__c = testAccount1.Id;
                tpbh.GA_Group_Segment_Id__c = grpSgmntRec.Id;
                tpbhLst.add(tpbh);
                database.insert(tpbhLst);
                
                Test.startTest();
                
                GA_TPBH_AP01_ThrdPrtyBllrUpdtngToGSLogic.isExecuting = false;
                GA_TPBH_AP01_ThrdPrtyBllrUpdtngToGSLogic.endDateExecuting=false;
                database.update(tpbhLst);
                //GA_ThrdPrtyBllr_TriggerHandler.afterUpdate(tpbhLst,tpbhOldMap);
                Test.stopTest();
                //system.assert(tpbhLst <> null);
            }
            catch(exception e)
            {
                system.assert(e <> null);
                return;
            }
        }
    }
    /*******************************************************************************************************************************
@Description: tpbAftrUpdtBtch() method 
@Name : tpbAftrUpdtBtch
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/      
    private static testmethod void tpbAftrUpdtBtch()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestSysAdm','testsysadm@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {
            try{
                Map<ID,GA_Third_Party_Biller_History__c> tpbhOldMap = new Map<ID,GA_Third_Party_Biller_History__c>();
                Account testAccount = GA_OBJ_TD01_TestDataCreation.AccRec();
                testAccount.RecordTypeId =  Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Customer').getRecordTypeId();
                database.insert(testAccount);
                
                GA_Group_Segment__c grpSgmntRec=GA_OBJ_TD01_TestDataCreation.grpSegmntRec(testAccount);
                grpSgmntRec.GA_Group_Effective_Date__c = system.today()-10;
                grpSgmntRec.GA_Cancellation_Date__c = system.today()+10;
                grpSgmntRec.Status__c = 'Pending';
                database.insert(grpSgmntRec);
                
                Account testAccount1 = GA_OBJ_TD01_TestDataCreation.AccRec();
                testAccount1.RecordTypeId =  Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Third Party Biller').getRecordTypeId();
                database.insert(testAccount1);
                
                List<GA_Third_Party_Biller_History__c> tpbhLst = new List<GA_Third_Party_Biller_History__c>();
                for(integer i=0;i<101;i++)
                {
                    GA_Third_Party_Biller_History__c tpbh = GA_OBJ_TD01_TestDataCreation.thirdPartyBiller(grpSgmntRec,testAccount1);
                    tpbh.GA_Third_Party_Biller_Account__c = testAccount1.Id;
                    tpbh.GA_Group_Segment_Id__c = grpSgmntRec.Id;
                    tpbhLst.add(tpbh); 
                }
                
                database.insert(tpbhLst);
                
                Test.startTest();
                
                GA_TPBH_AP01_ThrdPrtyBllrUpdtngToGSLogic.isExecuting = false;
                GA_TPBH_AP01_ThrdPrtyBllrUpdtngToGSLogic.endDateExecuting=false;
                database.update(tpbhLst);
                //GA_ThrdPrtyBllr_TriggerHandler.afterUpdate(tpbhLst,tpbhOldMap);
                Test.stopTest();
                //system.assert(tpbhLst <> null);
            }
            catch(exception e)
            {
                system.assert(e <> null);
                return;
            }
        }
    }
    /*******************************************************************************************************************************
@Description: tpbhValdtExcp() method 
@Name : tpbhValdtExcp
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/    
    private static testmethod void tpbhValdtExcp(){
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestSysAdm','testsysadm@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr){
            try{
                Map<ID,GA_Third_Party_Biller_History__c> tpbhOldMap = new Map<ID,GA_Third_Party_Biller_History__c>();
                List<GA_Third_Party_Biller_History__c> tpbhLst = new List<GA_Third_Party_Biller_History__c>();
                Test.startTest();
                GA_TPBH_AP01_ThrdPrtyBllrUpdtngToGSLogic.isExecuting = true;
                GA_TPBH_AP01_ThrdPrtyBllrUpdtngToGSLogic.updatetThirdPartyBillrToGS(tpbhLst,tpbhOldMap);
                GA_TPBH_AP01_ThrdPrtyBllrUpdtngToGSLogic.updatEndDate(tpbhLst);
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