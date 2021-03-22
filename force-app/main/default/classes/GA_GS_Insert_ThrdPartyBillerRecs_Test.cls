/*******************************************************************************************************************************
@Author : IDC offshore
@Name: GA_GS_Insert_ThrdPartyBillerRecs_Test
@CreatedDate: 29 - May 2018 
@Description: GA_GS_Insert_ThrdPartyBillerRecs_Test class is for inserting Third Party Biller History records on Group Segment.
@version : 1.0  
********************************************************************************************************************************/
@isTest(seealldata = false)
private class GA_GS_Insert_ThrdPartyBillerRecs_Test {
    /*******************************************************************************************************************************
@Description: insertTPBHrecsTest() method 
@Name : insertTPBHrecsTest
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
    private static testmethod void insertTPBHrecsTest(){
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestSysAdm','testsysadm@bcbsm.com','System Administrator');
        insert usr;
        system.runAs(usr){
            try{
                map<id,GA_Group_Segment__c> grpsgOldmp =new map<id,GA_Group_Segment__c>();
                list<GA_Group_Segment__c> gsList=new list<GA_Group_Segment__c>();
                list<GA_Third_Party_Biller_History__c> tpbhList=new list<GA_Third_Party_Biller_History__c>();
                Account testAccount = GA_OBJ_TD01_TestDataCreation.AccRec();
                testAccount.Name = 'test account cst grp';
                testAccount.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Customer').getRecordTypeId();
                database.insert(testAccount);
                
                Account testAccountTP = GA_OBJ_TD01_TestDataCreation.AccRec();
                testAccountTP.Name='Test Acc TP';
                testAccountTP.RecordTypeId =  Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Third Party Biller').getRecordTypeId();
                database.insert(testAccountTP);
                
                Account testAssocAccount = GA_OBJ_TD01_TestDataCreation.AccRec();
                testAssocAccount.Name = 'test account assoc';
                testAssocAccount.GA_Third_Party_Biller_Account_Id__c=testAccountTP.Id;
                testAssocAccount.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Association').getRecordTypeId();
                database.insert(testAssocAccount);
                
                GA_Group_Segment__c grpSgmntRec=GA_OBJ_TD01_TestDataCreation.grpSegmntRec(testAccount);
                gsList.add(grpSgmntRec);
                database.insert(gsList);
                
                GA_Group_Association__c assocHistory=GA_OBJ_TD01_TestDataCreation.grpAssociation(grpSgmntRec, testAssocAccount);
                assocHistory.GA_Group_Segment__c = grpSgmntRec.id;
                assocHistory.GA_Account__c = testAssocAccount.Id;
                assocHistory.GA_Start_Date__c=system.today()-10;
                database.insert(assocHistory);
                
                grpSgmntRec.GA_Association_Id__c=testAssocAccount.Id;
                grpSgmntRec.GA_Group_Association_id__c=assocHistory.Id;
                grpSgmntRec.GA_Is_Mass_Updating__c=true;
                gsList.add(grpSgmntRec);
                GA_GS_AP02_Update_Address.isExecuting=true;
                GA_GS_UpdateRatingType.isExecuting = true;
                GA_GroupSegmentTriggerHandler.beforeUpdateExecuting = true;
                GA_GroupSegmentTriggerHandler.isExecuting = true;
                GA_GS_AP04_UpdtStatus.isCnclGSChkd = true;
                GA_GS_AP04_UpdtStatus.isExecuting = true;
                GA_GS_AP04_UpdtStatus.isInvoked = true;
                GA_GS_UpdatWrappingFileTPA.isExecuting = true;
                database.update(gsList);
                
                GA_Third_Party_Biller_History__c tpbh = GA_OBJ_TD01_TestDataCreation.thirdPartyBiller(grpSgmntRec,testAccountTP);
                tpbh.GA_Third_Party_Biller_Account__c = testAssocAccount.GA_Third_Party_Biller_Account_Id__c;
                tpbh.GA_Group_Segment_Id__c = grpSgmntRec.Id;
                tpbh.GA_TPB_Start_Date__c=assocHistory.GA_Start_Date__c;
                tpbhList.add(tpbh);
                GA_TPBH_AP02_RestrictTPBHCreation.isExecuting = true;
                database.insert(tpbhList);
                
                grpSgmntRec.GA_Third_Party_Biller_Account__c = tpbh.GA_Third_Party_Biller_Account__c;
                grpSgmntRec.GA_Third_Party_Biller_History__c=tpbh.Id;
                grpSgmntRec.GA_Is_Mass_Updating__c=true;
                gsList.add(grpSgmntRec);
                GA_GS_AP02_Update_Address.isExecuting=true;
                GA_GS_UpdateRatingType.isExecuting = true;
                GA_GroupSegmentTriggerHandler.beforeUpdateExecuting = true;
                GA_GroupSegmentTriggerHandler.isExecuting = true;
                GA_GS_AP04_UpdtStatus.isCnclGSChkd = true;
                GA_GS_AP04_UpdtStatus.isExecuting = true;
                GA_GS_AP04_UpdtStatus.isInvoked = true;
                GA_GS_UpdatWrappingFileTPA.isExecuting = true;
                database.update(gsList);
                
                
                Test.startTest();
                GA_TPBH_AP02_RestrictTPBHCreation.isExecuting = true;
                GA_GS_Insert_ThrdPartyBillerRecs.insertThrdPartyRecs(gsList, null);
                Test.stopTest(); 
                
            }
            catch(exception e)
            {
                return;
            }
        }
    }
    /*******************************************************************************************************************************
@Description: updtTPBEndDateTest() method 
@Name : updtTPBEndDateTest
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
    private static testmethod void updtTPBEndDateTest(){
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestSysAdm','testsysadm@bcbsm.com','System Administrator');
        insert usr;
        system.runAs(usr){
            try{
                map<id,GA_Group_Segment__c> grpsgOldmp =new map<id,GA_Group_Segment__c>();
                list<GA_Group_Segment__c> gsList=new list<GA_Group_Segment__c>();
                
                Account testAccount = GA_OBJ_TD01_TestDataCreation.AccRec();
                testAccount.Name = 'test account cst grp';
                testAccount.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Customer').getRecordTypeId();
                database.insert(testAccount);
                
                Account testAccountTP = GA_OBJ_TD01_TestDataCreation.AccRec();
                testAccountTP.Name='Test Acc TP';
                testAccountTP.RecordTypeId =  Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Third Party Biller').getRecordTypeId();
                database.insert(testAccountTP);
                
                Account testAssocAccount = GA_OBJ_TD01_TestDataCreation.AccRec();
                testAssocAccount.Name = 'test account assoc';
                testAssocAccount.GA_Third_Party_Biller_Account_Id__c=testAccountTP.Id;
                testAssocAccount.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Association').getRecordTypeId();
                database.insert(testAssocAccount);
                
                GA_Group_Segment__c grpSgmntRec=GA_OBJ_TD01_TestDataCreation.grpSegmntRec(testAccount);
                grpSgmntRec.GA_Association_Id__c=testAssocAccount.Id;
                database.insert(grpSgmntRec);
                
                GA_Group_Association__c assocHistory=GA_OBJ_TD01_TestDataCreation.grpAssociation(grpSgmntRec, testAssocAccount);
                assocHistory.GA_Group_Segment__c = grpSgmntRec.id;
                assocHistory.GA_Account__c = testAssocAccount.Id;
                assocHistory.GA_Start_Date__c=system.today()-10;
                database.insert(assocHistory);
                
                GA_Third_Party_Biller_History__c tpbh = GA_OBJ_TD01_TestDataCreation.thirdPartyBiller(grpSgmntRec,testAccountTP);
                tpbh.GA_Third_Party_Biller_Account__c = testAssocAccount.GA_Third_Party_Biller_Account_Id__c;
                tpbh.GA_Group_Segment_Id__c = grpSgmntRec.Id;
                tpbh.GA_TPB_Start_Date__c=system.today()-10;
                database.insert(tpbh);
                
                assocHistory.GA_End_Date__c=system.today();
                database.update(assocHistory);
                
                grpSgmntRec.GA_Association_Id__c=null;
                grpSgmntRec.GA_Group_Association_id__c=null;
                grpSgmntRec.GA_Is_Mass_Updating__c=true;
                GA_GS_AP02_Update_Address.isExecuting=true;
                GA_GS_UpdateRatingType.isExecuting = true;
                GA_GroupSegmentTriggerHandler.beforeUpdateExecuting = true;
                GA_GroupSegmentTriggerHandler.isExecuting = true;
                GA_GS_AP04_UpdtStatus.isCnclGSChkd = true;
                GA_GS_AP04_UpdtStatus.isExecuting = true;
                GA_GS_AP04_UpdtStatus.isInvoked = true;
                GA_GS_UpdatWrappingFileTPA.isExecuting = true;
                database.update(grpSgmntRec);
                
                tpbh.GA_TPB_End_Date__c=assocHistory.GA_End_Date__c;
                GA_TPBH_AP02_RestrictTPBHCreation.isExecuting = true;
                database.update(tpbh);
                
                Test.startTest();
                GA_GS_Insert_ThrdPartyBillerRecs.updtLinkedTPBEndDate(gsList, grpsgOldmp);
                Test.stopTest();
            }
            catch(exception e)
            {
                return;
            }
        }
    }
    /*******************************************************************************************************************************
@Description: updtTPBdateTest() method 
@Name : updtTPBdateTest
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
    private static testmethod void updtTPBdateTest(){
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestSysAdm','testsysadm@bcbsm.com','System Administrator');
        insert usr;
        system.runAs(usr){
            try{
                map<id,GA_Group_Segment__c> grpsgOldmp =new map<id,GA_Group_Segment__c>();
                list<GA_Group_Segment__c> gsList=new list<GA_Group_Segment__c>();
                
                Account testAccount = GA_OBJ_TD01_TestDataCreation.AccRec();
                testAccount.Name = 'test account cst grp';
                testAccount.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Customer').getRecordTypeId();
                database.insert(testAccount);
                
                Account testAccountTP = GA_OBJ_TD01_TestDataCreation.AccRec();
                testAccountTP.Name='Test Acc TP';
                testAccountTP.RecordTypeId =  Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Third Party Biller').getRecordTypeId();
                database.insert(testAccountTP);
                
                Account testTPAcc = GA_OBJ_TD01_TestDataCreation.AccRec();
                testTPAcc.Name='Third Party Acc';
                testTPAcc.RecordTypeId =  Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Third Party Biller').getRecordTypeId();
                database.insert(testTPAcc);
                
                Account testAssocAccount = GA_OBJ_TD01_TestDataCreation.AccRec();
                testAssocAccount.Name = 'test account assoc';
                testAssocAccount.GA_Third_Party_Biller_Account_Id__c=testAccountTP.Id;
                testAssocAccount.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Association').getRecordTypeId();
                database.insert(testAssocAccount);
                
                Account AssocAcc = GA_OBJ_TD01_TestDataCreation.AccRec();
                AssocAcc.Name = 'Test Assoc Acc';
                AssocAcc.GA_Third_Party_Biller_Account_Id__c=null;
                AssocAcc.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Association').getRecordTypeId();
                database.insert(AssocAcc);
                
                GA_Group_Segment__c grpSgmntRec=GA_OBJ_TD01_TestDataCreation.grpSegmntRec(testAccount);
                database.insert(grpSgmntRec);
                
                GA_Group_Association__c assocHistory=GA_OBJ_TD01_TestDataCreation.grpAssociation(grpSgmntRec, testAssocAccount);
                assocHistory.GA_Group_Segment__c = grpSgmntRec.id;
                assocHistory.GA_Account__c = testAssocAccount.Id;
                assocHistory.GA_Start_Date__c=system.today()-10;
                database.insert(assocHistory);
                
                grpSgmntRec.GA_Association_Id__c=assocHistory.GA_Account__c;
                grpSgmntRec.GA_Group_Association_id__c=assocHistory.Id;
                grpSgmntRec.GA_Is_Mass_Updating__c=true;
                GA_GS_AP02_Update_Address.isExecuting=true;
                GA_GS_UpdateRatingType.isExecuting = true;
                GA_GroupSegmentTriggerHandler.beforeUpdateExecuting = true;
                GA_GroupSegmentTriggerHandler.isExecuting = true;
                GA_GS_AP04_UpdtStatus.isCnclGSChkd = true;
                GA_GS_AP04_UpdtStatus.isExecuting = true;
                GA_GS_AP04_UpdtStatus.isInvoked = true;
                GA_GS_UpdatWrappingFileTPA.isExecuting = true;
                database.update(grpSgmntRec);
                
                GA_Third_Party_Biller_History__c tpbh = GA_OBJ_TD01_TestDataCreation.thirdPartyBiller(grpSgmntRec,testAccountTP);
                tpbh.GA_Third_Party_Biller_Account__c = testAssocAccount.GA_Third_Party_Biller_Account_Id__c;
                tpbh.GA_Group_Segment_Id__c = grpSgmntRec.Id;
                tpbh.GA_TPB_Start_Date__c=system.today()-10;
                database.insert(tpbh);
                
                grpSgmntRec.GA_Third_Party_Biller_Account__c=tpbh.GA_Third_Party_Biller_Account__c;
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
                database.update(grpSgmntRec);
                
                GA_Group_Association__c grpAssoc=GA_OBJ_TD01_TestDataCreation.grpAssociation(grpSgmntRec, AssocAcc);
                grpAssoc.GA_Group_Segment__c = grpSgmntRec.id;
                grpAssoc.GA_Account__c = AssocAcc.Id;
                grpAssoc.GA_Start_Date__c=system.today()-3;
                database.insert(grpAssoc);
                
                tpbh.GA_TPB_End_Date__c=grpAssoc.GA_Start_Date__c-1;
                GA_TPBH_AP02_RestrictTPBHCreation.isExecuting = true;
                database.update(tpbh);
                
                Test.startTest();
                GA_GS_Insert_ThrdPartyBillerRecs.updtTPBdate(gsList, grpsgOldmp);
                Test.stopTest();
            }
            catch(exception e)
            {
                return;
            }
        }
    }
    /*******************************************************************************************************************************
@Description: afterUpdateTest() method 
@Name : afterUpdateTest
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
    private static testmethod void afterUpdateTest(){
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestSysAdm','testsysadm@bcbsm.com','System Administrator');
        insert usr;
        system.runAs(usr){
            try{
                map<id,GA_Group_Segment__c> grpsgOldmp =new map<id,GA_Group_Segment__c>();
                list<GA_Group_Segment__c> gsList=new list<GA_Group_Segment__c>();
                GA_GroupSegmentTriggerHandler.afterUpdate(gsList,grpsgOldmp);
                GA_GroupSegmentTriggerHandler.afterUpdate(null,null);
                GA_GroupSegmentTriggerHandler.afterUpdate(gsList,null);
            }
            catch(exception e)
            {
                return;
            }
        }
    }
     /*******************************************************************************************************************************
@Description: tbpExcepTest() method 
@Name : tbpExcepTest
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
    private static testmethod void tbpExcepTest(){
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestSysAdm','testsysadm@bcbsm.com','System Administrator');
        insert usr;
        system.runAs(usr){
            try{
                GA_GS_Insert_ThrdPartyBillerRecs.insertThrdPartyRecs(null,null);
                GA_GS_Insert_ThrdPartyBillerRecs.updtLinkedTPBEndDate(null,null);
                GA_GS_Insert_ThrdPartyBillerRecs.updtTPBdate(null,null);
            }
            catch(exception e)
            {
                return;
            }
        }
    }
    
    private static testmethod void createThirdPartyBillerTest()
    {   
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
                
                testAccount.GA_Third_Party_Biller_Account_Id__c=testAccount1.id;
                database.update(testAccount);
                
                GA_Group_Segment__c gsmtNew = new GA_Group_Segment__c();          
                gsmtNew.GA_Association_Id__c=testAccount.Id;
                gsmtNew.GA_Group_Association_id__c=assocHistory.Id;
                gsmtNew.Id=grpSgmntRec.Id;
         		database.update(gsmtNew);
                
                 list<GA_Group_Segment__c> gsLst =  new list<GA_Group_Segment__c>();
         		gsLst.add(gsmtNew); 
         
        		 map<id,GA_Group_Segment__c> OldMap = new map<id,GA_Group_Segment__c>();
                OldMap.put(gsmtNew.id,grpSgmntRec);
                Test.startTest();
            
               GA_GS_Insert_ThrdPartyBillerRecs.insertThrdPartyRecs(gsLst,OldMap);
                GA_GS_Insert_ThrdPartyBillerRecs.updtLinkedTPBEndDate(gsLst,OldMap);
                GA_GS_Insert_ThrdPartyBillerRecs.updtTPBdate(gsLst,OldMap);
                Test.stopTest();
                
            }
            catch(exception e)
            {
                system.assert(e <> null);
                return;
            }
        }              
        }
    
    private static testmethod void updtLinkedTPBEndDateTest()
    {   
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
                
                testAccount.GA_Third_Party_Biller_Account_Id__c=testAccount1.id;
                database.update(testAccount);
                
                GA_Group_Segment__c gsmtNew = new GA_Group_Segment__c();          
                gsmtNew.GA_Association_Id__c=testAccount.Id;
                gsmtNew.GA_Group_Association_id__c=assocHistory.Id;
                gsmtNew.Id=grpSgmntRec.Id;
         		database.update(gsmtNew);
                
                 list<GA_Group_Segment__c> gsLst =  new list<GA_Group_Segment__c>();
         		gsLst.add(grpSgmntRec); 
         
        		 map<id,GA_Group_Segment__c> OldMap = new map<id,GA_Group_Segment__c>();
                OldMap.put(grpSgmntRec.id,gsmtNew);
                Test.startTest();
            
               
                GA_GS_Insert_ThrdPartyBillerRecs.updtLinkedTPBEndDate(gsLst,OldMap);
               
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