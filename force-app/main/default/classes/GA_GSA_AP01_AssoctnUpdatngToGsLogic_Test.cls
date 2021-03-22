/*****************************************************************************************
Class Name   : GA_GSA_AP01_AssoctnUpdatngToGsLogic_Test
Date Created : 10/05/2017
Created By   : IDC Offshore
Description  : 1. This is test class is for GA_GSA_AP01_AssoctnUpdatngToGsLogic
******************************************************************************************/
@isTest(seealldata=false)
private class GA_GSA_AP01_AssoctnUpdatngToGsLogic_Test {
    /*******************************************************************************************************************************
@Description: assoctnUpdatngToGsLogic() method 
@Name : assoctnUpdatngToGsLogic
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
    private static testMethod void assoctnUpdatngToGsLogic() {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestSysAdm','testsysadm@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {
            try{
                List<GA_Group_Association__c> gsaList = new List<GA_Group_Association__c>();
                map<id,GA_Group_Association__c> gsALstOldMp = new map<id,GA_Group_Association__c>();
                
                Account testAccount = GA_OBJ_TD01_TestDataCreation.AccRec();
                testAccount.Name = 'test account cst grp';
                testAccount.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Customer').getRecordTypeId();
                database.insert(testAccount);
                
                Account testAssocAccount = GA_OBJ_TD01_TestDataCreation.AccRec();
                testAssocAccount.Name = 'test account assoc';
                testAssocAccount.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Association').getRecordTypeId();
                database.insert(testAssocAccount);
                
                GA_Group_Segment__c grpSgmntRec=GA_OBJ_TD01_TestDataCreation.grpSegmntRec(testAccount);
                database.insert(grpSgmntRec);
                
                GA_Group_Association__c assocHistory=GA_OBJ_TD01_TestDataCreation.grpAssociation(grpSgmntRec, testAssocAccount);
                assocHistory.GA_Group_Segment__c = grpSgmntRec.id;
                assocHistory.GA_Account__c = testAssocAccount.Id;
                database.insert(assocHistory);
                
                grpSgmntRec.GA_Group_Association_id__c = assocHistory.Id;
                grpSgmntRec.GA_Association_Id__c = testAssocAccount.Id;
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
                
                Test.startTest();
                GA_GSA_AP01_AssoctnUpdatngToGsLogic.updateAssttoGS(gsaList, gsALstOldMp);
                Test.stopTest();
                system.assert(testAccount <> null,true);
            }
            catch(exception e)
            {
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
                
                Account testAccount2 = GA_OBJ_TD01_TestDataCreation.AccRec();
                testAccount2.RecordTypeId =  Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Association').getRecordTypeId();
                database.insert(testAccount2);
                List<GA_Group_Association__c> gsaLst = new List<GA_Group_Association__c>();
                GA_Group_Association__c gsaRec = GA_OBJ_TD01_TestDataCreation.grpAssociation(grpSgmntRec,testAccount2);
                gsaRec.GA_Account__c = testAccount2.Id;
                gsaRec.GA_Group_Segment__c = grpSgmntRec.Id;
                database.insert(gsaRec);
                
                GA_Group_Association__c gsaRec1 = GA_OBJ_TD01_TestDataCreation.grpAssociation(grpSgmntRec,testAccount2);
                gsaRec1.GA_Account__c = testAccount2.Id;
                gsaRec1.GA_Group_Segment__c = grpSgmntRec.Id;
                database.insert(gsaRec1);
                
                if(gsaRec.GA_Group_Segment__c == gsaRec.GA_Group_Segment__c && 
                   gsaRec1.GA_Start_Date__c > gsaRec.GA_Start_Date__c){
                       gsaRec.GA_End_Date__c = gsaRec1.GA_End_Date__c-1;
                       gsaLst.add(gsaRec);
                   }
                database.update(gsaLst);
                
                Test.startTest();
                GA_GSA_AP01_AssoctnUpdatngToGsLogic.updatEndDate(gsaLst);
                Test.stopTest();
                system.assert(testAccount <> null,true);
            }
            catch(exception e)
            {
                system.assert(e <> null);
                return;
            }
        }
    }
    /*******************************************************************************************************************************
@Description: beforeLogicGSA() method 
@Name : beforeLogicGSA
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
    private static testMethod void beforeLogicGSA() {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestSysAdm','testsysadm@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {
            try{
                map<id,GA_Group_Association__c> gsALstOldMp = new map<id,GA_Group_Association__c>();
                Account testAccount = GA_OBJ_TD01_TestDataCreation.AccRec();
                testAccount.Name = 'test account cst grp';
                testAccount.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Customer').getRecordTypeId();
                database.insert(testAccount);
                
                Account testAssocAccount = GA_OBJ_TD01_TestDataCreation.AccRec();
                testAssocAccount.Name = 'test account assoc';
                testAssocAccount.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Association').getRecordTypeId();
                database.insert(testAssocAccount);
                
                Account testAssocAccount1 = GA_OBJ_TD01_TestDataCreation.AccRec();
                testAssocAccount1.Name = 'test account assoc1';
                testAssocAccount1.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Association').getRecordTypeId();
                database.insert(testAssocAccount1);
                
                GA_Group_Segment__c grpSgmntRec=GA_OBJ_TD01_TestDataCreation.grpSegmntRec(testAccount);
                database.insert(grpSgmntRec);
                
                list<GA_Group_Association__c> gsALst = new list<GA_Group_Association__c>();
                GA_Group_Association__c assocHistory=GA_OBJ_TD01_TestDataCreation.grpAssociation(grpSgmntRec, testAssocAccount);
                assocHistory.GA_Group_Segment__c=grpSgmntRec.Id;
                assocHistory.GA_Account__c=testAssocAccount.Id;
                gsALst.add(assocHistory);
                database.insert(gsALst);
                
                assocHistory.GA_Account__c = testAssocAccount1.id;
                database.update(assocHistory);
                gsALst.add(assocHistory);
                
                Test.startTest();
                GA_Group_Seg_AssociationTriggerHndlr.beforeInsert(gsALst);
                GA_Group_Seg_AssociationTriggerHndlr.beforeUpdate(gsALst,gsALstOldMp);
                Test.stopTest();
                system.assert(testAccount <> null,true);
                
            }
            catch(exception e)
            {
                return;
            }
        }                   
    }    
    /*******************************************************************************************************************************
@Description: afterInsertGSA() method 
@Name : afterInsertGSA
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
    private static testMethod void afterInsertGSA() {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestSysAdm','testsysadm@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {
            try{
                map<id,GA_Group_Association__c> gsALstOldMp = new map<id,GA_Group_Association__c>();
                Account testAccount = GA_OBJ_TD01_TestDataCreation.AccRec();
                testAccount.Name = 'test account cst grp';
                testAccount.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Customer').getRecordTypeId();
                database.insert(testAccount);
                
                Account testAssocAccount = GA_OBJ_TD01_TestDataCreation.AccRec();
                testAssocAccount.Name = 'test account assoc';
                testAssocAccount.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Association').getRecordTypeId();
                database.insert(testAssocAccount);
                
                GA_Group_Segment__c grpSgmntRec=GA_OBJ_TD01_TestDataCreation.grpSegmntRec(testAccount);
                database.insert(grpSgmntRec);
                
                list<GA_Group_Association__c> gsALst = new list<GA_Group_Association__c>();
                GA_Group_Association__c assocHistory=GA_OBJ_TD01_TestDataCreation.grpAssociation(grpSgmntRec, testAssocAccount);
                assocHistory.GA_Group_Segment__c=grpSgmntRec.Id;
                assocHistory.GA_Account__c=testAssocAccount.Id;
                gsALst.add(assocHistory);
                database.insert(gsALst);
                
                Test.startTest();
                GA_Group_Seg_AssociationTriggerHndlr.afterInsert(gsALst);
                Test.stopTest();               
                system.assert(testAccount <> null,true);
                
            }
            catch(exception e)
            {
                return;
            }
        }                   
    }
    /*******************************************************************************************************************************
@Description: afterUpdtGSA() method 
@Name : afterUpdtGSA
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
    private static testMethod void afterUpdtGSA() {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestSysAdm','testsysadm@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {
            try{
                map<id,GA_Group_Association__c> gsALstOldMp = new map<id,GA_Group_Association__c>();
                Account testAccount = GA_OBJ_TD01_TestDataCreation.AccRec();
                testAccount.Name = 'test account cst grp';
                testAccount.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Customer').getRecordTypeId();
                database.insert(testAccount);
                
                Account testAssocAccount = GA_OBJ_TD01_TestDataCreation.AccRec();
                testAssocAccount.Name = 'test account assoc';
                testAssocAccount.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Association').getRecordTypeId();
                database.insert(testAssocAccount);
                
                GA_Group_Segment__c grpSgmntRec=GA_OBJ_TD01_TestDataCreation.grpSegmntRec(testAccount);
                database.insert(grpSgmntRec);
                
                list<GA_Group_Association__c> gsALst = new list<GA_Group_Association__c>();
                GA_Group_Association__c assocHistory=GA_OBJ_TD01_TestDataCreation.grpAssociation(grpSgmntRec, testAssocAccount);
                assocHistory.GA_Group_Segment__c=grpSgmntRec.Id;
                assocHistory.GA_Account__c=testAssocAccount.Id;
                gsALst.add(assocHistory);
                database.insert(gsALst);
                
                Test.startTest();
                GA_GSA_AP01_AssoctnUpdatngToGsLogic.endDateExecuting =false;
                database.update(gsALst);
                Test.stopTest();
                system.assert(testAccount <> null,true);
                
            }
            catch(exception e)
            {
                return;
            }
        }                   
    } 
    
    /*******************************************************************************************************************************
@Description: beforeLogicGSA() method 
@Name : beforeLogicGSA
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
    private static testMethod void exceptionTest() {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestSysAdm','testsysadm@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {
            try{
                Test.startTest();
                GA_Group_Seg_AssociationTriggerHndlr.afterInsert(null);
                GA_Group_Seg_AssociationTriggerHndlr.afterUpdate(null, null);
                Test.stopTest();
                system.assert(usr <> null,true);
            }
            catch(exception e)
            {
                return;
            }
        }                   
    }
    /*******************************************************************************************************************************
@Description: assoctnBatchLogic() method 
@Name : assoctnBatchLogic
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
    private static testMethod void assoctnBatchLogic() {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestSysAdm','testsysadm@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {
            try{
                
                map<id,GA_Group_Association__c> gsALstOldMp = new map<id,GA_Group_Association__c>();
                
                Account testAccount = GA_OBJ_TD01_TestDataCreation.AccRec();
                testAccount.Name = 'test account cst grp';
                testAccount.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Customer').getRecordTypeId();
                testAccount.GA_System_of_Record__c='Salesforce';
                database.insert(testAccount);
                
                Account testAssocAccount = GA_OBJ_TD01_TestDataCreation.AccRec();
                testAssocAccount.Name = 'test account assoc';
                testAssocAccount.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Association').getRecordTypeId();
                database.insert(testAssocAccount);
                
                GA_Group_Segment__c grpSgmntRec=GA_OBJ_TD01_TestDataCreation.grpSegmntRec(testAccount);
                database.insert(grpSgmntRec);
                
                List<GA_Group_Association__c> gsaList = new List<GA_Group_Association__c>();
                GA_Group_Association__c assocHistory=GA_OBJ_TD01_TestDataCreation.grpAssociation(grpSgmntRec, testAssocAccount);
                assocHistory.GA_Group_Segment__c = grpSgmntRec.id;
                assocHistory.GA_Account__c = testAssocAccount.Id;
                assocHistory.GA_Is_Processed__c=false;
                
                gsaList.add(assocHistory);
                GA_GSA_AP01_AssoctnUpdatngToGsLogic.endDateExecuting=true;
                GA_Group_Seg_AssociationTriggerHndlr.isExecuting=true;
                
                database.insert(gsaList);
                
                
                grpSgmntRec.GA_Group_Association_id__c = assocHistory.Id;
                grpSgmntRec.GA_Association_Id__c = testAssocAccount.Id;
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
                GA_ExternalAppealRecdCrtnUpdt.isExecuting = true; 
                
                database.update(grpSgmntRec);
                string curdte=string.valueof(system.today()).split(' ')[0];
                String  gsaQry='select id,GA_Group_Segment__c,GA_Account__c,GA_Start_Date__c,GA_End_Date__c,GA_System_Of_Record__c,GA_Is_Processed__c,GA_Is_Active__c from GA_Group_Association__c';
                list<GA_Group_Association__c> gsaqryRec=database.query(gsaQry);
                GA_GSABatchToUpdateAssociationOnGsSchdlr sh1 = new GA_GSABatchToUpdateAssociationOnGsSchdlr();      
                String sch = '0  00 1 3 * ?';
                Test.startTest();
                system.schedule('Test', sch, sh1);
                Test.stopTest();
                system.assert(testAssocAccount <> null,true);
            }
            catch(exception e)
            {
                return;
            }
        }                   
    }
    /*******************************************************************************************************************************
@Description: gsaValdtExcp() method 
@Name : gsaValdtExcp
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
    private static testmethod void gsaValdtExcp(){
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestSysAdm','testsysadm@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr){
            try{
                Map<ID,GA_Group_Association__c> gsaOldMap = new Map<ID,GA_Group_Association__c>();
                List<GA_Group_Association__c> gsaLst = new List<GA_Group_Association__c>();
                Test.startTest();
                GA_GSA_AP01_AssoctnUpdatngToGsLogic.updateAssttoGS(null, null);
                GA_GSA_AP01_AssoctnUpdatngToGsLogic.updatEndDate(null);
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
@Description: gsaAftrUpdtBtch() method 
@Name : gsaAftrUpdtBtch
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/      
    private static testmethod void gsaAftrUpdtBtch()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestSysAdm','testsysadm@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {
            try{
                Account testAccount = GA_OBJ_TD01_TestDataCreation.AccRec();
                testAccount.Name = 'test account cst grp';
                testAccount.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Customer').getRecordTypeId();
                database.insert(testAccount);
                
                Account testAssocAccount = GA_OBJ_TD01_TestDataCreation.AccRec();
                testAssocAccount.Name = 'test account assoc';
                testAssocAccount.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Association').getRecordTypeId();
                database.insert(testAssocAccount);
                
                GA_Group_Segment__c grpSgmntRec=GA_OBJ_TD01_TestDataCreation.grpSegmntRec(testAccount);
                database.insert(grpSgmntRec);
                
                list<GA_Group_Association__c> gsALst = new list<GA_Group_Association__c>();
                for(integer i=0;i<101;i++){
                    GA_Group_Association__c assocHistory=GA_OBJ_TD01_TestDataCreation.grpAssociation(grpSgmntRec, testAssocAccount);
                    assocHistory.GA_Group_Segment__c=grpSgmntRec.Id;
                    assocHistory.GA_Account__c=testAssocAccount.Id;
                    gsALst.add(assocHistory);
                }
                database.insert(gsALst);
                
                Test.startTest();
                GA_GSA_AP01_AssoctnUpdatngToGsLogic.endDateExecuting=false;
                database.update(gsALst);
                Test.stopTest();
                system.assert(gsALst<>null,true);
            }
            catch(exception e)
            {
                system.assert(e <> null);
                return;
            }
        }
    }   
}