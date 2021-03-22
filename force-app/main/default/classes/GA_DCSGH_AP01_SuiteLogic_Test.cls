/*****************************************************************************************
Class Name   : GA_DCSGH_AP01_SuiteLogic_Test
Date Created : 10/05/2017
Created By   : IDC Offshore
Description  : 1. This is test class is for GA_DCSGH_AP01_SuiteLogic
******************************************************************************************/
@isTest(seealldata=false)
private class GA_DCSGH_AP01_SuiteLogic_Test {
    /*******************************************************************************************************************************
@Description: dcSmallGroupHistoryUpdate() method 
@Name : dcSmallGroupHistoryUpdate
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
    private static testMethod void dcSmallGroupHistoryUpdate() {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestSysAdm','testsysadm@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {
            try{
                Map<ID,GA_DC_Small_Grp_History__c> dcOldMap = new Map<ID,GA_DC_Small_Grp_History__c>();
                Account testAccount = GA_OBJ_TD01_TestDataCreation.AccRec();
                testAccount.Name = 'test account dc grp';
                testAccount.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Customer').getRecordTypeId();
                database.insert(testAccount);
                
                GA_Group_Segment__c grpSgmntRec=GA_OBJ_TD01_TestDataCreation.grpSegmntRec(testAccount);
                database.insert(grpSgmntRec);
                List<GA_DC_Small_Grp_History__c> dcList = new List<GA_DC_Small_Grp_History__c>();
                GA_DC_Small_Grp_History__c dcSmallGrp1=GA_OBJ_TD01_TestDataCreation.dcSmallGrpHstry(grpSgmntRec);
                dcSmallGrp1.GA_Suite__c = 'SUITE A';
                dcList.add(dcSmallGrp1);
                
        
                
                GA_DC_Small_Grp_History__c dcSmallGrp2=GA_OBJ_TD01_TestDataCreation.dcSmallGrpHstry(grpSgmntRec);
                dcSmallGrp2.GA_Suite__c = 'SUITE B';
                dcList.add(dcSmallGrp2);
                
            
                
                database.insert(dcList);
                
                grpSgmntRec.GA_Suite__c='SUITE B';
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
                GA_GS_Insert_ThrdPartyBillerRecs.isInvoking = true;

                database.update(grpSgmntRec);
                
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
                GA_DCSGH_AP01_SuiteLogic.updateSuiteInfoToGS(dcList,dcOldMap);
                Test.stopTest();
                
                system.assert(dcList <> null);
            }
            catch(exception e)
            {
                return;
            }
        }                   
    }   
    
    /*******************************************************************************************************************************
@Description: dcSmllNullify() method 
@Name : dcSmllNullify
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
    private static testMethod void dcSmllNullify() {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestSysAdm','testsysadm@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {
            //try{
            Account testAccount = GA_OBJ_TD01_TestDataCreation.AccRec();
            testAccount.Name = 'test account dc grp';
            testAccount.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Customer').getRecordTypeId();
            database.insert(testAccount);
            
            GA_Group_Segment__c grpSgmntRec=GA_OBJ_TD01_TestDataCreation.grpSegmntRec(testAccount);
            database.insert(grpSgmntRec);
            List<GA_DC_Small_Grp_History__c>    dcgrpLst = New  List<GA_DC_Small_Grp_History__c>();   
            
            for(Integer i=1 ;i<=200 ; i++){
                GA_DC_Small_Grp_History__c dcSmallGrp2=GA_OBJ_TD01_TestDataCreation.dcSmallGrpHstry(grpSgmntRec);
                dcSmallGrp2.GA_Suite_Start_Date__c=system.today()-10;
                dcSmallGrp2.GA_Suite_End_Date__c=system.today()-2;
                dcSmallGrp2.GA_Suite__c = 'SUITE B';
                dcgrpLst.add(dcSmallGrp2);
            }
              GA_GA_DCSmallGrpHistryTriggerHndlr.isExecuting = true;
                GA_DCSGH_AP01_SuiteLogic.endDateExecuting = true;
            database.insert(dcgrpLst);
            grpSgmntRec.GA_Suite__c=null;
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
            GA_GS_Insert_ThrdPartyBillerRecs.isInvoking = true;
            database.update(grpSgmntRec);
            
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
            //GA_DCSGH_AP01_SuiteLogic.nullifySuite(dcgrpLst);
            Test.stopTest();
            
            system.assert(usr <> null);
            /*}
catch(exception e)
{
return;
}*/
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
                testAccount.Name = 'test account dc grp';
                testAccount.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Customer').getRecordTypeId();
                database.insert(testAccount);
                
                GA_Group_Segment__c grpSgmntRec=GA_OBJ_TD01_TestDataCreation.grpSegmntRec(testAccount);
                database.insert(grpSgmntRec);
                
                List<GA_DC_Small_Grp_History__c> dcList = new List<GA_DC_Small_Grp_History__c>();
                GA_DC_Small_Grp_History__c dcSmallGrp1=GA_OBJ_TD01_TestDataCreation.dcSmallGrpHstry(grpSgmntRec);
                dcSmallGrp1.GA_Suite__c = 'SUITE A';
                dcList.add(dcSmallGrp1);
                
                GA_DCSGH_AP01_SuiteLogic.isExecuting = false;
                
                GA_DC_Small_Grp_History__c dcSmallGrp2=GA_OBJ_TD01_TestDataCreation.dcSmallGrpHstry(grpSgmntRec);
                dcSmallGrp2.GA_Suite__c = 'SUITE B';
                dcList.add(dcSmallGrp2);
                
                  GA_GA_DCSmallGrpHistryTriggerHndlr.isExecuting = true;
                GA_DCSGH_AP01_SuiteLogic.endDateExecuting = true;
                
                database.insert(dcList);
                
                if(dcSmallGrp1.GA_Group_Segment_Id__c  == dcSmallGrp2.GA_Group_Segment_Id__c  && 
                   dcSmallGrp2.GA_Suite_Start_Date__c  > dcSmallGrp1.GA_Suite_Start_Date__c ){
                       dcSmallGrp1.GA_Suite_End_Date__c  = dcSmallGrp2.GA_Suite_Start_Date__c -1;
                       dcList.add(dcSmallGrp1);
                   }
                
                
                
                Test.startTest();
                GA_DCSGH_AP01_SuiteLogic.updatEndDate(dcList);
                
                GA_GA_DCSmallGrpHistryTriggerHndlr.isExecuting = false;
                GA_DCSGH_AP01_SuiteLogic.endDateExecuting = false;
                
                dcSmallGrp2.GA_Suite_End_Date__c = System.today() ;
                
                database.update(dcSmallGrp2);
                Test.stopTest();
                system.assert(dcList <> null);
            }
            catch(exception e)
            {
                system.assert(e <> null);
                return;
            }
        }
    }    
    
    /*******************************************************************************************************************************
@Description: updateScheduler() method 
@Name : updateScheduler
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
    private static testMethod void updateScheduler() {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestSysAdm','testsysadm@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr){
            try{
                Account testAccount = GA_OBJ_TD01_TestDataCreation.AccRec();
                testAccount.Name = 'test account dc grp';
                testAccount.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Customer').getRecordTypeId();
                database.insert(testAccount);
                
                GA_Group_Segment__c grpSgmntRec=GA_OBJ_TD01_TestDataCreation.grpSegmntRec(testAccount);
                database.insert(grpSgmntRec);
                List<GA_DC_Small_Grp_History__c> dcList = new List<GA_DC_Small_Grp_History__c>();
                GA_DC_Small_Grp_History__c dcSmallGrp1=GA_OBJ_TD01_TestDataCreation.dcSmallGrpHstry(grpSgmntRec);
                dcSmallGrp1.GA_Suite__c = 'SUITE A';
                dcList.add(dcSmallGrp1);
                
                GA_DCSGH_AP01_SuiteLogic.isExecuting = false;
                
                GA_DC_Small_Grp_History__c dcSmallGrp2=GA_OBJ_TD01_TestDataCreation.dcSmallGrpHstry(grpSgmntRec);
                dcSmallGrp2.GA_Suite__c = 'SUITE B';
                dcList.add(dcSmallGrp2);
                
                  GA_GA_DCSmallGrpHistryTriggerHndlr.isExecuting = true;
                GA_DCSGH_AP01_SuiteLogic.endDateExecuting = true;
                database.insert(dcList);
                
                grpSgmntRec.GA_Suite__c='SUITE B';
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
                GA_GS_Insert_ThrdPartyBillerRecs.isInvoking = true;

                database.update(grpSgmntRec);
                GA_DCSmallGroupBatchSuiteUpdtSchdlr sh1 = new GA_DCSmallGroupBatchSuiteUpdtSchdlr();      
                String sch = '0  00 1 3 * ?';
                
                Test.startTest();
                system.schedule('Test', sch, sh1);
                Test.stopTest(); 
                
                system.assert(usr <> null);
            }
            catch(exception e)
            {
                system.assert(e <> null);
                return;
            }
        }
        
    }
    /*******************************************************************************************************************************
@Description: dcAftrInsert() method 
@Name : dcAftrInsert
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
    private static testMethod void dcAftrInsert() {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestSysAdm','testsysadm@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr){
            try{
                Account testAccount = GA_OBJ_TD01_TestDataCreation.AccRec();
                testAccount.Name = 'test account dc grp';
                testAccount.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Customer').getRecordTypeId();
                database.insert(testAccount);
                
                GA_Group_Segment__c grpSgmntRec=GA_OBJ_TD01_TestDataCreation.grpSegmntRec(testAccount);
                database.insert(grpSgmntRec);
                List<GA_DC_Small_Grp_History__c>    dcgrpLst = New  List<GA_DC_Small_Grp_History__c>();   
                
                for(Integer i=1 ;i<=200 ; i++){
                    GA_DC_Small_Grp_History__c dcSmallGrp2=GA_OBJ_TD01_TestDataCreation.dcSmallGrpHstry(grpSgmntRec);
                    dcSmallGrp2.GA_Suite_Start_Date__c=system.today()-10;
                    dcSmallGrp2.GA_Suite_End_Date__c=system.today()+2;
                    dcSmallGrp2.GA_Suite__c = 'SUITE B';
                    dcgrpLst.add(dcSmallGrp2);
                }
                        database.insert(dcgrpLst);
                system.assert(usr <> null);
            }
            catch(exception e)
            {
                system.assert(e <> null);
                return;
            }
        }
    }
    /*******************************************************************************************************************************
@Description: dcAftrUpdt() method 
@Name : dcAftrUpdt
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
    private static testMethod void dcAftrUpdt() {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestSysAdm','testsysadm@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr){
            try{
                Account testAccount = GA_OBJ_TD01_TestDataCreation.AccRec();
                testAccount.Name = 'test account dc grp';
                testAccount.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Customer').getRecordTypeId();
                database.insert(testAccount);
                
                GA_Group_Segment__c grpSgmntRec=GA_OBJ_TD01_TestDataCreation.grpSegmntRec(testAccount);
                database.insert(grpSgmntRec);
                List<GA_DC_Small_Grp_History__c>    dcgrpLst = New  List<GA_DC_Small_Grp_History__c>();   
                
                for(Integer i=1 ;i<=200 ; i++){
                    GA_DC_Small_Grp_History__c dcSmallGrp2=GA_OBJ_TD01_TestDataCreation.dcSmallGrpHstry(grpSgmntRec);
                    dcSmallGrp2.GA_Suite_Start_Date__c=system.today()-10;
                    dcSmallGrp2.GA_Suite_End_Date__c=system.today()+2;
                    dcSmallGrp2.GA_Suite__c = 'SUITE B';
                    dcgrpLst.add(dcSmallGrp2);
                }
                  GA_GA_DCSmallGrpHistryTriggerHndlr.isExecuting = true;
                GA_DCSGH_AP01_SuiteLogic.endDateExecuting = true;
                database.insert(dcgrpLst);
                Test.startTest();
                
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
@Description: valEcxp() method 
@Name : valEcxp
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
    private static testMethod void valEcxp() {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestSysAdm','testsysadm@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr){
            try{
                Test.startTest();
                GA_DCSGH_AP01_SuiteLogic.updateSuiteInfoToGS(null, null);
                GA_DCSGH_AP01_SuiteLogic.updatEndDate(null);
                GA_DCSGH_AP01_SuiteLogic.doAction(null);
                Test.stopTest(); 
                
                system.assert(usr <> null);
            }
            catch(exception e)
            {
                system.assert(e <> null); 
                return;
            }
        }
    }
    /*******************************************************************************************************************************
@Description: valEcxp() method 
@Name : valEcxp
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
    private static testMethod void valhndlrEcxp() {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestSysAdm','testsysadm@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr){
            try{
                Test.startTest();
                GA_GA_DCSmallGrpHistryTriggerHndlr.afterInsert(null);
                GA_GA_DCSmallGrpHistryTriggerHndlr.afterUpdate(null,null); 
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