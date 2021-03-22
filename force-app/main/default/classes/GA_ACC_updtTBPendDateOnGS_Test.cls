/*******************************************************************************************************************************
@Author : IDC offshore
@Name: GA_ACC_updtTBPendDateOnGS_Test
@CreatedDate: 20 - Aug 2019 
@Description: GA_ACC_updtTBPendDateOnGS_Test class is for GA_ACC_updtTBPendDateOnGS.
@version : 1.0  
********************************************************************************************************************************/
@isTest(seealldata = false)
private class GA_ACC_updtTBPendDateOnGS_Test {
    /*******************************************************************************************************************************
@Description: gsRecdTst() method 
@Name : gsRecdTst
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
    private static testmethod void gsRecdTst(){
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('Testwfstp','testsystemadminstrator@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {
            try{
                Map<Id,Account> accOldMp = new Map<Id,Account> ();
                
               	Account testAccount = GA_OBJ_TD01_TestDataCreation.AccRec();
                testAccount.Name = 'test cust Acc';
                testAccount.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Customer').getRecordTypeId();
                database.insert(testAccount);
                
                Account tpbAcc = GA_OBJ_TD01_TestDataCreation.AccRec();
                tpbAcc.Name = 'Test tpb Acc';
                tpbAcc.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Third Party Biller').getRecordTypeId();
                database.insert(tpbAcc);
                
                Account testAssocAccount = GA_OBJ_TD01_TestDataCreation.AccRec();
                testAssocAccount.Name = 'test assoc Acc';
                testAssocAccount.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Association').getRecordTypeId();
                database.insert(testAssocAccount);
                
                Account testAssocAccount2 = new Account();
                testAssocAccount2.id= testAssocAccount.id;
                testAssocAccount2.GA_Third_Party_Biller_Account_Id__c = tpbAcc.id;
                database.upsert(testAssocAccount2);
                
                GA_Group_Segment__c grpSgmntRec=GA_OBJ_TD01_TestDataCreation.grpSegmntRec(testAccount);
                database.insert(grpSgmntRec);
               
                GA_Group_Association__c grpAssoctn=GA_OBJ_TD01_TestDataCreation.grpAssociation(grpSgmntRec, testAssocAccount2);
                grpAssoctn.GA_Group_Segment__c = grpSgmntRec.id;
                grpAssoctn.GA_Account__c = testAssocAccount2.Id;
                grpAssoctn.GA_Start_Date__c = system.today().AddDays(-1);
                grpAssoctn.GA_End_Date__c =system.today().AddDays(6);
                database.insert(grpAssoctn);
              
                GA_Third_Party_Biller_History__c tpbh = GA_OBJ_TD01_TestDataCreation.thirdPartyBiller(grpSgmntRec,tpbAcc);
                tpbh.GA_Third_Party_Biller_Account__c = tpbAcc.Id;
                tpbh.GA_Group_Segment_Id__c = grpSgmntRec.Id;
                database.insert(tpbh);
                
                grpSgmntRec.GA_Group_Association_id__c = grpAssoctn.Id;
                grpSgmntRec.GA_Association_Id__c = testAssocAccount.Id;
                grpSgmntRec.GA_Third_Party_Biller_History__c = tpbh.id;
                grpSgmntRec.GA_Third_Party_Biller_Account__c = tpbAcc.id;
                grpSgmntRec.GA_Is_Mass_Updating__c =true;
                GA_GS_AP02_Update_Address.isExecuting=true;
                GA_GS_UpdateRatingType.isExecuting = true;
                GA_GroupSegmentTriggerHandler.beforeUpdateExecuting = true;
                GA_GroupSegmentTriggerHandler.isExecuting = true;
                GA_GS_AP04_UpdtStatus.isCnclGSChkd = true;
                GA_GS_AP04_UpdtStatus.isExecuting = true;
                GA_GS_AP04_UpdtStatus.isInvoked = true;
                GA_GS_UpdatWrappingFileTPA.isExecuting = true;
                GA_GroupSegAccUpdateCls.isExecuting = true;
                GA_ExternalAppealSrvcCls_MOS.isExecuting = true;
                //GA_GS_Insert_ThrdPartyBillerRecs.isExecuting = true;
                //GA_GS_Insert_ThrdPartyBillerRecs.isInvoked = true;
                //GA_GS_Insert_ThrdPartyBillerRecs.isInvoking = true;
                GA_ExternalAppealRecdCrtnUpdt.isExecuting = true;
                database.update(grpSgmntRec);
                
               accOldMp.put(testAssocAccount2.id,testAssocAccount2);
                
                testAssocAccount.GA_Third_Party_Biller_Account_Id__c = null;
                
                list<Account> accLst = new list<Account> ();
                accLst.add(testAssocAccount);
                
                Test.startTest();
                GA_ACC_updtTBPendDateOnGS.updtLinkedTPBEndDate(accLst,accOldMp);
                Test.stopTest();
                
                System.assert(usr <> null);
            }
            catch(exception e)
            {
                return;
            }
        }
    }   
 /*******************************************************************************************************************************
@Description: gsRecdTstExcptn() method 
@Name : gsRecdTstExcptn
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
    private static testmethod void gsRecdTstExcptn(){
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('Testwfstp','testsystemadminstrator@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {
            try{
                Map<Id,Account> accOldMp = new Map<Id,Account> ();
                
               	Account testAccount = GA_OBJ_TD01_TestDataCreation.AccRec();
                testAccount.Name = 'test cust Acc';
                testAccount.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Customer').getRecordTypeId();
                database.insert(testAccount);
                
                Account tpbAcc = GA_OBJ_TD01_TestDataCreation.AccRec();
                tpbAcc.Name = 'Test tpb Acc';
                tpbAcc.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Third Party Biller').getRecordTypeId();
                database.insert(tpbAcc);
                
                Account testAssocAccount = GA_OBJ_TD01_TestDataCreation.AccRec();
                testAssocAccount.Name = 'test assoc Acc';
                testAssocAccount.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Association').getRecordTypeId();
                testAssocAccount.GA_Third_Party_Biller_Account_Id__c = tpbAcc.id;
                database.insert(testAssocAccount);
                
                GA_Group_Segment__c grpSgmntRec=GA_OBJ_TD01_TestDataCreation.grpSegmntRec(testAccount);
                database.insert(grpSgmntRec);
               
                GA_Group_Association__c assocHistory=GA_OBJ_TD01_TestDataCreation.grpAssociation(grpSgmntRec, testAssocAccount);
                assocHistory.GA_Group_Segment__c = grpSgmntRec.id;
                assocHistory.GA_Account__c = testAssocAccount.Id;
                database.insert(assocHistory);
                

                testAssocAccount.GA_Third_Party_Biller_Account_Id__c = null;
              
                list<Account> accLst = new list<Account> ();
                accLst.add(testAssocAccount);
                
                Test.startTest();
                GA_ACC_updtTBPendDateOnGS.updtLinkedTPBEndDate(accLst,accOldMp);
                Test.stopTest();
                
                System.assert(usr <> null);
            }
            catch(exception e)
            {
                return;
            }
        }
    }    
}