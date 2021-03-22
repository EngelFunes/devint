/*******************************************************************************************************************************
@Author : IDC offshore
@Name: GA_GS_AP04_UpdtStatus_Test
@CreatedDate: 25 - Feb 2019 
@Description: GA_GS_AP04_UpdtStatus_Test class is for Group Segment status update.
@version : 1.0  
********************************************************************************************************************************/
@isTest(seealldata = false)
private class GA_GS_AP04_UpdtStatus_Test {
    /*******************************************************************************************************************************
@Description: updtActivStatusGSTest() method 
@Name : updtActivStatusGSTest
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
    private static testmethod void updtActivStatusGSTest(){
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestSysAdm','testsysadm@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr){
            try{
                Account testAccount3 = GA_OBJ_TD01_TestDataCreation.AccRec();
                testAccount3.Name = 'Test Cust Acc';
                testAccount3.Account_Status__c='Active';
                testAccount3.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Customer').getRecordTypeId();
                database.insert(testAccount3);
                
                case cas=GA_OBJ_TD01_TestDataCreation.CaseRec();
                cas.recordtypeid=Schema.SObjectType.Case.getRecordTypeInfosByName().get('Group Service Issues').getRecordTypeId();
                cas.AccountId = testAccount3.id;
                cas.GA_IssuesCategory__c='Administration';
                database.insert(cas);
                
                List<GA_Group_Segment__c> gsList = new List<GA_Group_Segment__c>();
                List<GA_Group_Segment__c> gsList2 = new List<GA_Group_Segment__c>();
                GA_Group_Segment__c grpSgmntRec=GA_OBJ_TD01_TestDataCreation.grpSegmntRec(testAccount3);
                grpSgmntRec.GA_Group_Effective_Date__c = system.today()-10;
                grpSgmntRec.GA_Cancellation_Date__c = system.today()+10;
                grpSgmntRec.Status__c = 'Pending';
                grpSgmntRec.GA_Transaction_Posted__c=true;
                grpSgmntRec.GA_Post_Transaction__c=true;
                GA_GS_AP02_Update_Address.isExecuting=true;
                GA_ExternalAppealSrvcCls_MOS.isExecuting = true;
                GA_GS_Insert_ThrdPartyBillerRecs.isExecuting = true;
                GA_GS_Insert_ThrdPartyBillerRecs.isInvoked = true;
                GA_ExternalAppealRecdCrtnUpdt.isExecuting = true;
                GA_GS_Insert_ThrdPartyBillerRecs.isInvoking = true;
                database.insert(grpSgmntRec);
                
                GA_WFT_workflow__c wfTemp = GA_OBJ_TD01_TestDataCreation.wrkFlwTmplt();
                database.insert(wfTemp);
                
                GA_WFT_Inventory_Step__c wfInvStp = GA_OBJ_TD01_TestDataCreation.wfInventoryStp();
                wfInvStp.Name='Automated Validation';
                database.insert(wfInvStp);
                
                GA_WFT_Inventory_Step__c wfInvStpPreporccing = GA_OBJ_TD01_TestDataCreation.wfInventoryStp();
                wfInvStp.Name='Pre-Processing';
                database.insert(wfInvStpPreporccing);
                
                GA_WFT_Step__c wftStp = GA_OBJ_TD01_TestDataCreation.wrkTmpStp(wfTemp,wfInvStp);
                database.insert(wftStp);
                
                GA_WFT_Step__c wftStpPrepprocssing = GA_OBJ_TD01_TestDataCreation.wrkTmpStp(wfTemp,wfInvStpPreporccing);
                database.insert(wftStpPrepprocssing);
                
                GA_WFT_Allowed_Next_Step__c wftNxtStp = GA_OBJ_TD01_TestDataCreation.wfAlwdNxtStp(wftStp);
                database.insert(wftNxtStp);
                
                GA_WF_Workflow__c wfRec = New GA_WF_Workflow__c();
                wfRec.GA_Account__c = testAccount3.id;
                wfRec.GA_Support__c = cas.id;
                wfRec.GA_Carrier__c = wfTemp.GA_Carrier__c;
                wfRec.GA_Method__c = wfTemp.GA_Method__c;
                wfRec.Sub_Type__c = wfTemp.GA_Process_Subtype__c;
                wfRec.GA_Type__c=wfTemp.GA_Process_Type__c;
                wfRec.GA_Status__c = 'Open';
                wfRec.GA_Workflow_Template__c =wfTemp.id;
                database.insert(wfRec);
                
                GA_WF_Step__c wfStepRec1 = New  GA_WF_Step__c();
                wfStepRec1.Name='Automated Validation';
                wfStepRec1.GA_Status__c = 'Closed';
                wfStepRec1.GA_WF_Template_Step__c = wftStp.id;
                wfStepRec1.GA_WF_Workflow_ID__c = wfRec.id;
                wfStepRec1.GA_Notes__c = 'Test';
                database.insert(wfStepRec1);
                
                GA_WF_Step__c wfStepRec = New  GA_WF_Step__c();
                wfStepRec.GA_Status__c = 'Open';
                wfStepRec.GA_WF_Template_Step__c = wftStp.id;
                wfStepRec.GA_WF_Workflow_ID__c = wfRec.id;
                wfStepRec.GA_Notes__c = 'Test';
                database.insert(wfStepRec);
                
                Group testGroup = new Group(Name='GA_Small_Group_Underwriting_Queue', Type='Queue');
                database.insert(testGroup);
                
                QueuesObject testQueue = new QueueSObject(QueueID = testGroup.id, SObjectType = 'GA_WF_Group_Segment__c');
                database.insert(testQueue);
                
                GA_WF_Group_Segment__c wfgs = New GA_WF_Group_Segment__c();
                wfgs.GA_WF_Step_ID__c =   wfStepRec1.id;
                wfgs.GA_Workflow_ID__c = wfRec.id; 
                wfgs.GA_Workflow_Next_Step__c = wfStepRec.id;
                wfgs.GA_Group_Segment_ID__c = grpSgmntRec.id;
                wfgs.OwnerId = testQueue.queueid;
                wfgs.GA_Tracking_Status__c = 'IPQT';
                wfgs.GA_Problem_Identified_Values__c = '(2-G) Incorrect Template';
                wfgs.GA_Date_Opened__c=system.today();
                
                GA_WF_Group_Segment__c wfgs2 = New GA_WF_Group_Segment__c();
                wfgs2.GA_WF_Step_ID__c =   wfStepRec1.id;
                wfgs2.GA_Workflow_ID__c = wfRec.id; 
                wfgs2.GA_Status__c = 'Closed';
                wfgs2.GA_Group_Segment_ID__c = grpSgmntRec.id;
                wfgs2.OwnerId = testQueue.queueid;
                wfgs2.GA_Tracking_Status__c = 'IPQT';
                wfgs2.GA_Problem_Identified_Values__c = '(2-G) Incorrect Template';
                wfgs2.GA_Date_Opened__c=system.today();
                
                List<GA_WF_Group_Segment__c> wfGSList = new List<GA_WF_Group_Segment__c>();
                wfGSList.add(wfgs);
                wfGSList.add(wfgs2);
                database.insert(wfGSList);
                
                Map<id,GA_Group_Segment__c> grpsgOldmp = new Map<id,GA_Group_Segment__c>();
                grpsgOldmp.put(grpSgmntRec.Id, grpSgmntRec);
                //grpSgmntRec.Status__c ='Active';
                //database.update(grpSgmntRec);
                gsList.add(grpSgmntRec);
                Test.startTest();
                GA_GS_AP04_UpdtStatus.updtActivStatusGS(gsList);
                GA_GS_AP04_UpdtStatus.updtCnclStatusGSBfre(gsList,grpsgOldmp);
                GA_GS_AP04_UpdtStatus.updtCnclStatusGS(gsList,grpsgOldmp);
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
@Description: updtActivStsCnclDtNul() method 
@Name : updtActivStsCnclDtNul
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
    private static testmethod void updtActivStsCnclDtNul(){
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestSysAdm','testsysadm@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr){
            try{
                Account testAccount3 = GA_OBJ_TD01_TestDataCreation.AccRec();
                testAccount3.Name = 'Test Cust Acc';
                testAccount3.Account_Status__c='Active';
                testAccount3.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Customer').getRecordTypeId();
                database.insert(testAccount3);
                
                case cas=GA_OBJ_TD01_TestDataCreation.CaseRec();
                cas.recordtypeid=Schema.SObjectType.Case.getRecordTypeInfosByName().get('Group Service Issues').getRecordTypeId();
                cas.AccountId = testAccount3.id;
                cas.GA_IssuesCategory__c='Administration';
                database.insert(cas);
                
                List<GA_Group_Segment__c> gsList = new List<GA_Group_Segment__c>();
                GA_Group_Segment__c grpSgmntRec=GA_OBJ_TD01_TestDataCreation.grpSegmntRec(testAccount3);
                grpSgmntRec.GA_Group_Effective_Date__c = system.today()-10;
                grpSgmntRec.GA_Cancellation_Date__c = null;
                grpSgmntRec.Status__c = 'Pending';
                grpSgmntRec.GA_Transaction_Posted__c=true;
                grpSgmntRec.GA_Post_Transaction__c=true;
                GA_GS_AP02_Update_Address.isExecuting=true;
                database.insert(grpSgmntRec);
                
                GA_WFT_workflow__c wfTemp = GA_OBJ_TD01_TestDataCreation.wrkFlwTmplt();
                database.insert(wfTemp);
                
                GA_WFT_Inventory_Step__c wfInvStp = GA_OBJ_TD01_TestDataCreation.wfInventoryStp();
                wfInvStp.Name='Automated Validation';
                database.insert(wfInvStp);
                
                GA_WFT_Inventory_Step__c wfInvStpPreporccing = GA_OBJ_TD01_TestDataCreation.wfInventoryStp();
                wfInvStp.Name='Pre-Processing';
                database.insert(wfInvStpPreporccing);
                
                GA_WFT_Step__c wftStp = GA_OBJ_TD01_TestDataCreation.wrkTmpStp(wfTemp,wfInvStp);
                database.insert(wftStp);
                
                GA_WFT_Step__c wftStpPrepprocssing = GA_OBJ_TD01_TestDataCreation.wrkTmpStp(wfTemp,wfInvStpPreporccing);
                database.insert(wftStpPrepprocssing);
                
                GA_WFT_Allowed_Next_Step__c wftNxtStp = GA_OBJ_TD01_TestDataCreation.wfAlwdNxtStp(wftStp);
                database.insert(wftNxtStp);
                
                GA_WF_Workflow__c wfRec = New GA_WF_Workflow__c();
                wfRec.GA_Account__c = testAccount3.id;
                wfRec.GA_Support__c = cas.id;
                wfRec.GA_Carrier__c = wfTemp.GA_Carrier__c;
                wfRec.GA_Method__c = wfTemp.GA_Method__c;
                wfRec.Sub_Type__c = wfTemp.GA_Process_Subtype__c;
                wfRec.GA_Type__c=wfTemp.GA_Process_Type__c;
                wfRec.GA_Status__c = 'Open';
                wfRec.GA_Workflow_Template__c =wfTemp.id;
                database.insert(wfRec);
                
                GA_WF_Step__c wfStepRec1 = New  GA_WF_Step__c();
                wfStepRec1.Name='Automated Validation';
                wfStepRec1.GA_Status__c = 'Closed';
                wfStepRec1.GA_WF_Template_Step__c = wftStp.id;
                wfStepRec1.GA_WF_Workflow_ID__c = wfRec.id;
                wfStepRec1.GA_Notes__c = 'Test';
                database.insert(wfStepRec1);
                
                GA_WF_Step__c wfStepRec = New  GA_WF_Step__c();
                wfStepRec.GA_Status__c = 'Open';
                wfStepRec.GA_WF_Template_Step__c = wftStp.id;
                wfStepRec.GA_WF_Workflow_ID__c = wfRec.id;
                wfStepRec.GA_Notes__c = 'Test';
                database.insert(wfStepRec);
                
                Group testGroup = new Group(Name='GA_Small_Group_Underwriting_Queue', Type='Queue');
                database.insert(testGroup);
                
                QueuesObject testQueue = new QueueSObject(QueueID = testGroup.id, SObjectType = 'GA_WF_Group_Segment__c');
                database.insert(testQueue);
                
                GA_WF_Group_Segment__c wfgs = New GA_WF_Group_Segment__c();
                wfgs.GA_WF_Step_ID__c =   wfStepRec1.id;
                wfgs.GA_Workflow_ID__c = wfRec.id; 
                wfgs.GA_Workflow_Next_Step__c = wfStepRec.id;
                wfgs.GA_Group_Segment_ID__c = grpSgmntRec.id;
                wfgs.OwnerId = testQueue.queueid;
                wfgs.GA_Tracking_Status__c = 'IPQT';
                wfgs.GA_Problem_Identified_Values__c = '(2-G) Incorrect Template';
                wfgs.GA_Date_Opened__c=system.today();
                database.insert(wfgs);
                
                //grpSgmntRec.Status__c ='Active';
                //database.update(grpSgmntRec);
                gsList.add(grpSgmntRec);
                Test.startTest();
                GA_GS_AP04_UpdtStatus.updtActivStatusGS(gsList);
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
@Description: updtRecTypeAccTest() method 
@Name : updtRecTypeAccTest
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
    private static testmethod void updtRecTypeAccTest(){
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestSysAdm','testsysadm@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr){
            try{
                Account testAccount = GA_OBJ_TD01_TestDataCreation.AccRec();
                testAccount.Name = 'Test Prospect Acc';
                testAccount.Account_Status__c='Inactive';
                testAccount.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Prospect').getRecordTypeId();
                database.insert(testAccount);
                
                GA_Group_Segment__c grpSgmntRec=GA_OBJ_TD01_TestDataCreation.grpSegmntRec(testAccount);
                grpSgmntRec.GA_Group_Effective_Date__c = system.today()-10;
                grpSgmntRec.GA_Cancellation_Date__c = system.today()+10;
                grpSgmntRec.Status__c = 'Pending';
                grpSgmntRec.GA_Transaction_Posted__c=true;
                grpSgmntRec.GA_Post_Transaction__c=true;
                
                GA_Group_Segment__c grpSgmntRec1=GA_OBJ_TD01_TestDataCreation.grpSegmntRec(testAccount);
                grpSgmntRec1.GA_Group_Effective_Date__c = system.today()-10;
                grpSgmntRec1.GA_Cancellation_Date__c = system.today()+10;
                grpSgmntRec1.Status__c = 'Pending';
                grpSgmntRec1.GA_Transaction_Posted__c=true;
                grpSgmntRec1.GA_Post_Transaction__c=true;
                
                List<GA_Group_Segment__c> gsList = new List<GA_Group_Segment__c>();
                gsList.add(grpSgmntRec);
                gsList.add(grpSgmntRec1);
                GA_GS_AP02_Update_Address.isExecuting=true;
                GA_ExternalAppealSrvcCls_MOS.isExecuting = true;
                GA_GS_Insert_ThrdPartyBillerRecs.isExecuting = true;
                GA_GS_Insert_ThrdPartyBillerRecs.isInvoked = true;
                GA_ExternalAppealRecdCrtnUpdt.isExecuting = true;
                GA_GS_Insert_ThrdPartyBillerRecs.isInvoking = true;
                database.insert(gsList);
                set<id> accIds=new set<id>();
                for(GA_Group_Segment__c objGS : gsList){
                    objGS.Status__c='Active';
                    accIds.add(objGS.GA_Account__c); 
                }
                
                testAccount.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Customer').getRecordTypeId();
                testAccount.GA_Is_Mass_Updating__c=true; 
                database.update(testAccount);
                Test.startTest();
                GA_GS_AP04_UpdtStatus.updtRecTypeAcc(gsList);
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
@Description: updtRecTypeAccActiveTest() method 
@Name : updtRecTypeAccActiveTest
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
    private static testmethod void updtRecTypeAccActiveTest(){
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestSysAdm','testsysadm@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr){
            try{
                Account testAccount = GA_OBJ_TD01_TestDataCreation.AccRec();
                testAccount.Name = 'Test Prospect Acc';                
                testAccount.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Prospect').getRecordTypeId();
                database.insert(testAccount);
                
                GA_Group_Segment__c grpSgmntRec=GA_OBJ_TD01_TestDataCreation.grpSegmntRec(testAccount);
                grpSgmntRec.GA_Group_Effective_Date__c = system.today()-10;
                grpSgmntRec.GA_Cancellation_Date__c = system.today()+10;
                grpSgmntRec.Status__c = 'Active';
                grpSgmntRec.GA_Transaction_Posted__c=true;
                grpSgmntRec.GA_Post_Transaction__c=true;
                
                GA_Group_Segment__c grpSgmntRec1=GA_OBJ_TD01_TestDataCreation.grpSegmntRec(testAccount);
                grpSgmntRec1.GA_Group_Effective_Date__c = system.today()-10;
                grpSgmntRec1.GA_Cancellation_Date__c = system.today()+10;
                grpSgmntRec1.Status__c = 'Active';
                grpSgmntRec1.GA_Transaction_Posted__c=true;
                grpSgmntRec1.GA_Post_Transaction__c=true;
                
                List<GA_Group_Segment__c> gsList = new List<GA_Group_Segment__c>();
                gsList.add(grpSgmntRec);
                gsList.add(grpSgmntRec1);
                GA_GS_AP02_Update_Address.isExecuting=true;
                GA_ExternalAppealSrvcCls_MOS.isExecuting = true;
                GA_GS_Insert_ThrdPartyBillerRecs.isExecuting = true;
                GA_GS_Insert_ThrdPartyBillerRecs.isInvoked = true;
                GA_ExternalAppealRecdCrtnUpdt.isExecuting = true;
                GA_GS_Insert_ThrdPartyBillerRecs.isInvoking = true;
                database.insert(gsList);
                set<id> accIds=new set<id>();
                for(GA_Group_Segment__c objGS : gsList){
                    objGS.Status__c='Active';
                    accIds.add(objGS.GA_Account__c); 
                }
                
                testAccount.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Customer').getRecordTypeId();
                testAccount.GA_Is_Mass_Updating__c=true; 
                database.update(testAccount);
                Test.startTest();
                GA_GS_AP04_UpdtStatus.updtRecTypeAcc(gsList);
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
@Description: updtCnclStatusGSBfreTest() method 
@Name : updtCnclStatusGSBfreTest
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
    private static testmethod void updtCnclStatusGSBfreTest(){
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestSysAdm','testsysadm@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr){
            try{
                map<id,GA_Group_Segment__c> grpsgOldmp =new map<id,GA_Group_Segment__c>();
                list<GA_Group_Segment__c> gsList=new list<GA_Group_Segment__c>();
                
                Account testAccount = GA_OBJ_TD01_TestDataCreation.AccRec();
                testAccount.Name = 'Test Prospect Acc';
                testAccount.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Prospect').getRecordTypeId();
                database.insert(testAccount);
                
                GA_Group_Segment__c grpSgmntRec=GA_OBJ_TD01_TestDataCreation.grpSegmntRec(testAccount);
                grpSgmntRec.GA_Group_Effective_Date__c = system.today()-10;
                grpSgmntRec.GA_Cancellation_Date__c = system.today()+10;
                grpSgmntRec.Status__c = 'Pending';
                grpSgmntRec.GA_Transaction_Posted__c=true;
                grpSgmntRec.GA_Post_Transaction__c=true;
                GA_GS_AP02_Update_Address.isExecuting=true;
                database.insert(grpSgmntRec);
                grpsgOldmp.put(grpSgmntRec.id,grpSgmntRec); 
                grpSgmntRec.Status__c ='Canceled';
                grpSgmntRec.GA_Cancellation_Date__c=system.today();
                GA_GS_AP02_Update_Address.isExecuting=true;
                GA_ExternalAppealSrvcCls_MOS.isExecuting = true;
                GA_GS_Insert_ThrdPartyBillerRecs.isExecuting = true;
                GA_GS_Insert_ThrdPartyBillerRecs.isInvoked = true;
                GA_ExternalAppealRecdCrtnUpdt.isExecuting = true;
                GA_GS_Insert_ThrdPartyBillerRecs.isInvoking = true;
                database.update(grpSgmntRec);
                gsList.add(grpSgmntRec);
                Test.startTest();
                GA_GS_AP04_UpdtStatus.updtCnclStatusGSBfre(gsList,grpsgOldmp);       
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
@Description: updtCnclStatusGSTest() method 
@Name : updtCnclStatusGSTest
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
    private static testmethod void updtCnclStatusGSTest(){
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestSysAdm','testsysadm@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr){
            try{
                Account testAccount = GA_OBJ_TD01_TestDataCreation.AccRec();
                testAccount.Name = 'Test Customer Acc';
                testAccount.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Customer').getRecordTypeId();
                database.insert(testAccount);
                
                GA_Group_Segment__c grpSgmntRec=GA_OBJ_TD01_TestDataCreation.grpSegmntRec(testAccount);
                grpSgmntRec.GA_Group_Effective_Date__c = system.today()-10;
                grpSgmntRec.GA_Cancellation_Date__c = system.today();
                grpSgmntRec.Status__c = 'Pending';
                grpSgmntRec.GA_Transaction_Posted__c=true;
                grpSgmntRec.GA_Post_Transaction__c=true;
                
                GA_Group_Segment__c grpSgmntRec1=GA_OBJ_TD01_TestDataCreation.grpSegmntRec(testAccount);
                grpSgmntRec1.GA_Group_Effective_Date__c = system.today()-10;
                grpSgmntRec1.GA_Cancellation_Date__c = system.today();
                grpSgmntRec1.Status__c = 'Pending';
                grpSgmntRec1.GA_Transaction_Posted__c=true;
                grpSgmntRec1.GA_Post_Transaction__c=true;
                
                List<GA_Group_Segment__c> gsList = new List<GA_Group_Segment__c>();
                gsList.add(grpSgmntRec);
                gsList.add(grpSgmntRec1);
                GA_GS_AP02_Update_Address.isExecuting=true;
                GA_ExternalAppealSrvcCls_MOS.isExecuting = true;
                GA_GS_Insert_ThrdPartyBillerRecs.isExecuting = true;
                GA_GS_Insert_ThrdPartyBillerRecs.isInvoked = true;
                GA_ExternalAppealRecdCrtnUpdt.isExecuting = true;
                GA_GS_Insert_ThrdPartyBillerRecs.isInvoking = true;
                database.insert(gsList);
                set<id> accIds=new set<id>();
                for(GA_Group_Segment__c objGS : gsList){
                    objGS.Status__c='Canceled';
                    accIds.add(objGS.GA_Account__c); 
                }
                
                testAccount.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Prospect').getRecordTypeId();
                testAccount.GA_Is_Mass_Updating__c=true; 
                database.update(testAccount);
                
                Test.startTest();
                GA_GS_AP04_UpdtStatus.updtCnclStatusGS(gsList,null);
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
@Description: nullifyTPBtoGSTest() method 
@Name : nullifyTPBtoGSTest
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
    private static testmethod void nullifyTPBtoGSTest(){
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestSysAdm','testsysadm@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr){
            try{
                Account testAccount = GA_OBJ_TD01_TestDataCreation.AccRec();
                testAccount.Name = 'Test Customer Acc';
                testAccount.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Customer').getRecordTypeId();
                database.insert(testAccount);
                Account testAccount1 = GA_OBJ_TD01_TestDataCreation.AccRec();
                testAccount1.Name = 'Test TPB Acc';
                testAccount1.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Third Party Biller').getRecordTypeId();
                database.insert(testAccount1);
                Account testAccount2 = GA_OBJ_TD01_TestDataCreation.AccRec();
                testAccount2.Name = 'Test TPB Acc';
                testAccount2.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Association').getRecordTypeId();
                database.insert(testAccount2);
                GA_County_Code__c cnty=new GA_County_Code__c ();
                cnty.Name='Test Cnt Code';
                database.insert(cnty);
                List<GA_Group_Segment__c> gsList = new List<GA_Group_Segment__c>();
                GA_Group_Segment__c grpSgmntRec=GA_OBJ_TD01_TestDataCreation.grpSegmntRec(testAccount);
                grpSgmntRec.GA_Group_Effective_Date__c = system.today()-10;
                grpSgmntRec.GA_Cancellation_Date__c = system.today()+10;
                grpSgmntRec.Status__c = 'Pending';
                grpSgmntRec.GA_Transaction_Posted__c=true;
                grpSgmntRec.GA_Post_Transaction__c=true;
                grpSgmntRec.GA_Third_Party_Biller_Account__c = null;
                grpSgmntRec.GA_Third_Party_Biller_History__c = null;
                GA_GS_AP02_Update_Address.isExecuting=true;
                database.insert(grpSgmntRec);
                
                GA_Third_Party_Biller_History__c tpbh = GA_OBJ_TD01_TestDataCreation.thirdPartyBiller(grpSgmntRec,testAccount1);
                tpbh.GA_Third_Party_Biller_Account__c = testAccount1.Id;
                tpbh.GA_TPB_Start_Date__c=System.today()-10;
                database.insert(tpbh);
                GA_Group_Association__c gsAsstn=GA_OBJ_TD01_TestDataCreation.grpAssociation(grpSgmntRec,testAccount2);
                gsAsstn.GA_Start_Date__c = System.today()-5;
                gsAsstn.GA_End_Date__c = System.today()+10;
                database.insert(gsAsstn);    
                grpSgmntRec.GA_Third_Party_Biller_Account__c = testAccount1.Id;
                grpSgmntRec.GA_Third_Party_Biller_History__c = tpbh.Id;
                grpSgmntRec.GA_Group_Association_id__c=gsAsstn.Id;
                GA_GS_AP02_Update_Address.isExecuting=true;
                database.update(grpSgmntRec);
                
                GA_Third_Party_Biller_History__c tpbh1 = GA_OBJ_TD01_TestDataCreation.thirdPartyBiller(grpSgmntRec,testAccount1);
                tpbh1.GA_Third_Party_Biller_Account__c = testAccount1.Id;
                database.insert(tpbh1);
                
                grpSgmntRec.GA_Third_Party_Biller_Account__c = null;
                grpSgmntRec.GA_Third_Party_Biller_History__c = null;
                GA_GS_AP02_Update_Address.isExecuting=true;
                database.update(grpSgmntRec);
                GA_Group_Segment__c grpSgmnt=[select id,GA_GSA_Start_Date__c,GA_Group_Effective_Date__c,GA_Cancellation_Date__c,GA_TPB_Start_Date__c,GA_Group_Association_id__c,
                                              Status__c,GA_Transaction_Posted__c,GA_Post_Transaction__c,GA_Third_Party_Biller_Account__c,GA_Third_Party_Biller_History__c
                                              from GA_Group_Segment__c 
                                              where id=:grpSgmntRec.Id Limit 1];
                
                gsList.add(grpSgmnt);
                Test.startTest();
                // GA_GS_AP04_UpdtStatus.nullifyTPBtoGS(gsList);
                //  GA_GS_AP04_UpdtStatus.updtTPBtoGS();
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
@Description: updtTPBtoGSTest() method 
@Name : updtTPBtoGSTest
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
    private static testmethod void updtTPBtoGSTest(){
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestSysAdm','testsysadm@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr){
            try{
                Account testAccount = GA_OBJ_TD01_TestDataCreation.AccRec();
                testAccount.Name = 'Test Customer Acc';
                testAccount.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Customer').getRecordTypeId();
                database.insert(testAccount);
                
                Account testAccount1 = GA_OBJ_TD01_TestDataCreation.AccRec();
                testAccount1.Name = 'Test TPB Acc';
                testAccount1.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Third Party Biller').getRecordTypeId();
                database.insert(testAccount1);
                
                List<GA_Group_Segment__c> gsList = new List<GA_Group_Segment__c>();
                map<id,GA_Group_Segment__c> grpsgOldmp = new map<id,GA_Group_Segment__c>();
                GA_Group_Segment__c grpSgmntRec=GA_OBJ_TD01_TestDataCreation.grpSegmntRec(testAccount);
                grpSgmntRec.GA_Group_Effective_Date__c = system.today()-10;
                grpSgmntRec.GA_Cancellation_Date__c = system.today()+10;
                grpSgmntRec.Status__c = 'Pending';
                grpSgmntRec.GA_Transaction_Posted__c=true;
                grpSgmntRec.GA_Post_Transaction__c=true;
                grpSgmntRec.GA_Third_Party_Biller_Account__c = null;
                grpSgmntRec.GA_Third_Party_Biller_History__c = null;
                database.insert(grpSgmntRec);
                
                GA_Third_Party_Biller_History__c tpbh = GA_OBJ_TD01_TestDataCreation.thirdPartyBiller(grpSgmntRec,testAccount1);
                tpbh.GA_Third_Party_Biller_Account__c = testAccount1.Id;
                database.insert(tpbh);
                
                //tpbh.GA_TPB_End_Date__c = system.today()-1;
                //database.update(tpbh);                
                
                Test.startTest();
                //  GA_GS_AP04_UpdtStatus.updtTPBtoGS();
                GA_GS_AP04_UpdtStatus.updateEndDateTPB(gsList,grpsgOldmp);
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
@Description: updateStatusValdtExcp() method 
@Name : updateStatusValdtExcp
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
    private static testmethod void updateStatusValdtExcp(){
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestSysAdm','testsysadm@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr){
            try{
                List<GA_Group_Segment__c> gsList = new List<GA_Group_Segment__c>();
                map<id,GA_Group_Segment__c> grpsgOldmp = new map<id,GA_Group_Segment__c>();
                
                Test.startTest();
                GA_GS_AP04_UpdtStatus.updtActivStatusGS(null);
                GA_GS_AP04_UpdtStatus.updtRecTypeAcc(null);
                GA_GS_AP04_UpdtStatus.updtCnclStatusGSBfre(null,null);
                GA_GS_AP04_UpdtStatus.updtCnclStatusGS(null,null);
                //  GA_GS_AP04_UpdtStatus.nullifyTPBtoGS(null);
                //   GA_GS_AP04_UpdtStatus.updtTPBtoGS();
                GA_GS_AP04_UpdtStatus.updateEndDateTPB(null,null);
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
@Description: updateStatusBatchTest() method 
@Name : updateStatusBatchTest
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
    private static testmethod void updateStatusBatchTest(){
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestSysAdm','testsysadm@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr){
            try{
                Account testAccount = GA_OBJ_TD01_TestDataCreation.AccRec();
                testAccount.Name = 'Test Customer Acc';
                testAccount.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Customer').getRecordTypeId();
                database.insert(testAccount);
                
                GA_Group_Segment__c grpSgmntRec=GA_OBJ_TD01_TestDataCreation.grpSegmntRec(testAccount);
                grpSgmntRec.GA_Group_Effective_Date__c = system.today()-10;
                grpSgmntRec.GA_Cancellation_Date__c = system.today()+10;
                grpSgmntRec.Status__c = 'Pending';
                grpSgmntRec.GA_Transaction_Posted__c=true;
                grpSgmntRec.GA_Post_Transaction__c=true;
                database.insert(grpSgmntRec);
                
                grpSgmntRec.GA_Is_Mass_Updating__c=true;
                grpSgmntRec.GA_Is_Processed__c=false;
                grpSgmntRec.Status__c='Active';
                database.update(grpSgmntRec);
                
                GA_Group_Segment__c grpSgmntRec1=GA_OBJ_TD01_TestDataCreation.grpSegmntRec(testAccount);
                grpSgmntRec1.GA_Group_Effective_Date__c = system.today()-10;
                grpSgmntRec1.GA_Cancellation_Date__c = system.today()+10;
                grpSgmntRec1.Status__c = 'Pending';
                grpSgmntRec1.GA_Transaction_Posted__c=true;
                grpSgmntRec1.GA_Post_Transaction__c=true;
                database.insert(grpSgmntRec1);
                
                grpSgmntRec1.Status__c='Canceled';
                grpSgmntRec1.GA_Is_Mass_Updating__c=true;
                GA_ExternalAppealSrvcCls_MOS.isExecuting = true;
                GA_GS_Insert_ThrdPartyBillerRecs.isExecuting = true;
                GA_GS_Insert_ThrdPartyBillerRecs.isInvoked = true;
                GA_ExternalAppealRecdCrtnUpdt.isExecuting = true;
                GA_GS_Insert_ThrdPartyBillerRecs.isInvoking = true;
                database.update(grpSgmntRec1);
                                
                GA_GS_UpdtStatusBatch_Scheduler  sh1 = new GA_GS_UpdtStatusBatch_Scheduler ();      
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
}