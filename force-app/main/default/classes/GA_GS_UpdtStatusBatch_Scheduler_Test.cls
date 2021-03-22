/*******************************************************************************************************************************
@Author : IDC offshore
@Name: GA_GS_UpdtStatusBatch_Scheduler_Test
@CreatedDate: 25 - Feb 2019 
@Description: GA_GS_UpdtStatusBatch_Scheduler_Test class is for Group Segment status update.
@version : 1.0  
********************************************************************************************************************************/
@isTest(seealldata = false)
private class GA_GS_UpdtStatusBatch_Scheduler_Test {
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
                
                List<GA_Group_Segment__c> grpLst = New List<GA_Group_Segment__c>();
                
                GA_Group_Segment__c grpSgmntRec=GA_OBJ_TD01_TestDataCreation.grpSegmntRec(testAccount);
                grpSgmntRec.GA_Group_Effective_Date__c = system.today()-10;
                grpSgmntRec.GA_Cancellation_Date__c = system.today()+10;
                grpSgmntRec.Status__c = 'Pending';
                grpSgmntRec.GA_Transaction_Posted__c=true;
                grpSgmntRec.GA_Post_Transaction__c=true;
                grpSgmntRec.GA_Is_Processed__c=false;
                grpSgmntRec.Network__c = 'BCN';
                
                grpLst.add(grpSgmntRec);
                // database.insert(grpSgmntRec);
                
                
                GA_Group_Segment__c grpSgmntRec2=GA_OBJ_TD01_TestDataCreation.grpSegmntRec(testAccount);
                grpSgmntRec2.GA_Group_Effective_Date__c = system.today()-10;
                grpSgmntRec2.GA_Cancellation_Date__c = system.today()+10;
                grpSgmntRec2.Status__c = 'Pending';
                grpSgmntRec2.GA_Transaction_Posted__c=true;
                grpSgmntRec2.GA_Post_Transaction__c=true;
                grpSgmntRec2.GA_Is_Processed__c=false;           
                grpLst.add(grpSgmntRec2);
                
                
                GA_Group_Segment__c grpSgmntRec1=GA_OBJ_TD01_TestDataCreation.grpSegmntRec(testAccount);
                grpSgmntRec1.GA_Group_Effective_Date__c = system.today()-10;
                grpSgmntRec1.GA_Cancellation_Date__c = system.today();
                grpSgmntRec1.Status__c = 'Active';
                grpSgmntRec1.GA_Transaction_Posted__c=true;
                grpSgmntRec1.GA_Post_Transaction__c=true;
                GA_GS_AP02_Update_Address.isExecuting=true;
                GA_GroupSegmentTriggerHandler.beforeUpdateExecuting = true;
                GA_GroupSegmentTriggerHandler.isExecuting = true;
                GA_GS_AP04_UpdtStatus.isCnclGSChkd = true;
                GA_GS_AP04_UpdtStatus.isExecuting = true;
                GA_GS_AP04_UpdtStatus.isInvoked = true;
                GA_GS_UpdatWrappingFileTPA.isExecuting = true;
                grpLst.add(grpSgmntRec1);
                database.insert(grpLst);   
                
                
                
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
                wfRec.GA_Account__c = testAccount.id;
                // wfRec.GA_Support__c = cas.id;
                wfRec.GA_Carrier__c = wfTemp.GA_Carrier__c;
                wfRec.GA_Method__c = wfTemp.GA_Method__c;
                wfRec.Sub_Type__c = wfTemp.GA_Process_Subtype__c;
                wfRec.GA_Type__c=wfTemp.GA_Process_Type__c;
                wfRec.GA_Status__c = 'Closed';
                wfRec.GA_Workflow_Template__c =wfTemp.id;
                database.insert(wfRec);
                
                GA_WF_Step__c wfStepRec1 = New  GA_WF_Step__c();
                wfStepRec1.Name='Automated Validation';
                wfStepRec1.GA_Status__c = 'Closed';
                wfStepRec1.GA_WF_Template_Step__c = wftStp.id;
                wfStepRec1.GA_WF_Workflow_ID__c = wfRec.id;
                wfStepRec1.GA_Notes__c = 'Test';
                database.insert(wfStepRec1);
                
                
                
                Group testGroup = new Group(Name='GA_Small_Group_Underwriting_Queue', Type='Queue');
                insert testGroup;
                
                QueuesObject testQueue = new QueueSObject(QueueID = testGroup.id, SObjectType = 'GA_WF_Group_Segment__c');
                insert testQueue;
                
                grpSgmntRec1.GA_Is_Mass_Updating__c=true;
                GA_GS_AP02_Update_Address.isExecuting=true;
                GA_GroupSegmentTriggerHandler.beforeUpdateExecuting = true;
                GA_GroupSegmentTriggerHandler.isExecuting = true;
                GA_GS_AP04_UpdtStatus.isCnclGSChkd = true;
                GA_GS_AP04_UpdtStatus.isExecuting = true;
                GA_GS_AP04_UpdtStatus.isInvoked = true;
                GA_GS_UpdatWrappingFileTPA.isExecuting = true;
                database.update(grpSgmntRec1);
                
                List<GA_WF_Group_Segment__c> wfgsLst = New List<GA_WF_Group_Segment__c>();
                GA_WF_Group_Segment__c wfgs = New GA_WF_Group_Segment__c();
                for(GA_Group_Segment__c gs : grpLst){
                    wfgs = New GA_WF_Group_Segment__c();
                    wfgs.GA_WF_Step_ID__c =   wfStepRec1.id;
                    wfgs.GA_Workflow_ID__c = wfRec.id; 
                    // wfgs.GA_Workflow_Next_Step__c = wfStepRec.id;
                    wfgs.GA_Group_Segment_ID__c =  gs.id;
                    wfgs.OwnerId = testQueue.queueid;
                    wfgs.GA_Tracking_Status__c = 'IPQT';
                    wfgs.GA_Problem_Identified_Values__c = '(2-G) Incorrect Template';
                    wfgs.GA_Date_Opened__c=system.today();
                    wfgs.GA_Status__c = 'Closed';
                    wfgsLst.add(wfgs);
                }
                database.insert(wfgsLst);
                
                
                string curdte=string.valueof(system.today()).split(' ')[0];
                String   gsQry='select id,Name,GA_Account__c,GA_Transaction_Posted__c,GA_Post_Transaction__c,(select id from GA_WF_Group_Segment__r where GA_Status__c=\'Closed\' and GA_Workflow_Next_Step__c=null and GA_WF_Step_ID__c !=null),GA_Account_Record_Type__c,GA_Account_Status__c,Status__c,GA_Group_Effective_Date__c,'+
                    'GA_Cancellation_Date__c,GA_Third_Party_Biller_History__c from GA_Group_Segment__c where (GA_Is_Processed__c=false and Status__c=\'Pending\' and ((GA_Cancellation_Date__c=null or GA_Cancellation_Date__c >'+curdte+') and GA_Group_Effective_Date__c<='+curdte+')) or (Status__c=\'Active\' and GA_Cancellation_Date__c<='+curdte+')';
                
                List<GA_Group_Segment__c> gsList = Database.query(gsQry);
                
                Test.startTest();
                GA_GS_UpdtStatusBatch_Scheduler  sh1 = new GA_GS_UpdtStatusBatch_Scheduler ();      
                String sch = '0  00 1 3 * ?';
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
@Description: updateStatusBatchTest() method 
@Name : updateStatusBatchTest
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
    private static testmethod void updateStatusBatchIntgusrTest(){
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestSysAdm','testsysadm@bcbsm.com','Integration User');
        database.insert(usr);
        system.runAs(usr){
            try{
                Account testAccount = GA_OBJ_TD01_TestDataCreation.AccRec();
                testAccount.Name = 'Test Customer Acc';
                testAccount.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Customer').getRecordTypeId();
                database.insert(testAccount);
                
                List<GA_Group_Segment__c> grpLst = New List<GA_Group_Segment__c>();
                
                GA_Group_Segment__c grpSgmntRec=GA_OBJ_TD01_TestDataCreation.grpSegmntRec(testAccount);
                grpSgmntRec.GA_Group_Effective_Date__c = system.today()-10;
                grpSgmntRec.GA_Cancellation_Date__c = system.today()+10;
                grpSgmntRec.Status__c = 'Pending';
                grpSgmntRec.GA_Transaction_Posted__c=true;
                grpSgmntRec.GA_Post_Transaction__c=true;
                grpSgmntRec.GA_Is_Processed__c=false;
                grpSgmntRec.Network__c = 'BCN';
                
                grpLst.add(grpSgmntRec);
                // database.insert(grpSgmntRec);
                
                
                GA_Group_Segment__c grpSgmntRec2=GA_OBJ_TD01_TestDataCreation.grpSegmntRec(testAccount);
                grpSgmntRec2.GA_Group_Effective_Date__c = system.today()-10;
                grpSgmntRec2.GA_Cancellation_Date__c = system.today()+10;
                grpSgmntRec2.Status__c = 'Pending';
                grpSgmntRec2.GA_Transaction_Posted__c=true;
                grpSgmntRec2.GA_Post_Transaction__c=true;
                grpSgmntRec2.GA_Is_Processed__c=false;           
                grpLst.add(grpSgmntRec2);
                
                
                GA_Group_Segment__c grpSgmntRec1=GA_OBJ_TD01_TestDataCreation.grpSegmntRec(testAccount);
                grpSgmntRec1.GA_Group_Effective_Date__c = system.today()-10;
                grpSgmntRec1.GA_Cancellation_Date__c = system.today();
                grpSgmntRec1.Status__c = 'Canceled';
                grpSgmntRec1.GA_Transaction_Posted__c=true;
                grpSgmntRec1.GA_Post_Transaction__c=true;
                GA_GS_AP02_Update_Address.isExecuting=true;
                GA_GroupSegmentTriggerHandler.beforeUpdateExecuting = true;
                GA_GroupSegmentTriggerHandler.isExecuting = true;
                GA_GS_AP04_UpdtStatus.isCnclGSChkd = true;
                GA_GS_AP04_UpdtStatus.isExecuting = true;
                GA_GS_AP04_UpdtStatus.isInvoked = true;
                GA_GS_UpdatWrappingFileTPA.isExecuting = true;
                grpLst.add(grpSgmntRec1);
                database.insert(grpLst);   
                
                
                
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
                wfRec.GA_Account__c = testAccount.id;
                // wfRec.GA_Support__c = cas.id;
                wfRec.GA_Carrier__c = wfTemp.GA_Carrier__c;
                wfRec.GA_Method__c = wfTemp.GA_Method__c;
                wfRec.Sub_Type__c = wfTemp.GA_Process_Subtype__c;
                wfRec.GA_Type__c=wfTemp.GA_Process_Type__c;
                wfRec.GA_Status__c = 'Closed';
                wfRec.GA_Workflow_Template__c =wfTemp.id;
                database.insert(wfRec);
                
                GA_WF_Step__c wfStepRec1 = New  GA_WF_Step__c();
                wfStepRec1.Name='Automated Validation';
                wfStepRec1.GA_Status__c = 'Closed';
                wfStepRec1.GA_WF_Template_Step__c = wftStp.id;
                wfStepRec1.GA_WF_Workflow_ID__c = wfRec.id;
                wfStepRec1.GA_Notes__c = 'Test';
                database.insert(wfStepRec1);
                
                
                
                Group testGroup = new Group(Name='GA_Small_Group_Underwriting_Queue', Type='Queue');
                insert testGroup;
                
                QueuesObject testQueue = new QueueSObject(QueueID = testGroup.id, SObjectType = 'GA_WF_Group_Segment__c');
                insert testQueue;
                
                grpSgmntRec1.GA_Is_Mass_Updating__c=true;
                GA_GS_AP02_Update_Address.isExecuting=true;
                GA_GroupSegmentTriggerHandler.beforeUpdateExecuting = true;
                GA_GroupSegmentTriggerHandler.isExecuting = true;
                GA_GS_AP04_UpdtStatus.isCnclGSChkd = true;
                GA_GS_AP04_UpdtStatus.isExecuting = true;
                GA_GS_AP04_UpdtStatus.isInvoked = true;
                GA_GS_UpdatWrappingFileTPA.isExecuting = true;
                database.update(grpSgmntRec1);
                
                List<GA_WF_Group_Segment__c> wfgsLst = New List<GA_WF_Group_Segment__c>();
                GA_WF_Group_Segment__c wfgs = New GA_WF_Group_Segment__c();
                for(GA_Group_Segment__c gs : grpLst){
                    wfgs = New GA_WF_Group_Segment__c(); 
                    wfgs.GA_WF_Step_ID__c =   wfStepRec1.id;
                    wfgs.GA_Workflow_ID__c = wfRec.id; 
                    // wfgs.GA_Workflow_Next_Step__c = wfStepRec.id;
                    wfgs.GA_Group_Segment_ID__c =  gs.id;
                    wfgs.OwnerId = testQueue.queueid;
                    wfgs.GA_Tracking_Status__c = 'IPQT';
                    wfgs.GA_Problem_Identified_Values__c = '(2-G) Incorrect Template';
                    wfgs.GA_Date_Opened__c=system.today();
                    wfgs.GA_Status__c = 'Closed';
                    wfgsLst.add(wfgs);
                }
                database.insert(wfgsLst);
                
                
                string curdte=string.valueof(system.today()).split(' ')[0];
                String   gsQry='select id,Name,GA_Account__c,GA_Transaction_Posted__c,GA_Post_Transaction__c,(select id from GA_WF_Group_Segment__r where GA_Status__c=\'Closed\' and GA_Workflow_Next_Step__c=null and GA_WF_Step_ID__c !=null),GA_Account_Record_Type__c,GA_Account_Status__c,Status__c,GA_Group_Effective_Date__c,'+
                    'GA_Cancellation_Date__c,GA_Third_Party_Biller_History__c from GA_Group_Segment__c where (GA_Is_Processed__c=false and Status__c=\'Pending\' and ((GA_Cancellation_Date__c=null or GA_Cancellation_Date__c >'+curdte+') and GA_Group_Effective_Date__c<='+curdte+')) or (Status__c=\'Active\' and GA_Cancellation_Date__c<='+curdte+')';
                
                List<GA_Group_Segment__c> gsList = Database.query(gsQry);
                
                Test.startTest();
                GA_GS_UpdtStatusBatch_Scheduler  sh1 = new GA_GS_UpdtStatusBatch_Scheduler ();      
                String sch = '0  00 1 3 * ?';
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