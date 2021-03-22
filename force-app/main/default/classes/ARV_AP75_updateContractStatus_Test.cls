/*
@Author : IDC Offshore
@Name: ARV_AP75_updateContractStatus_Test 
@CreatedDate: 3 - Feb 2020 
@Description: ARV_AP75_updateContractStatus_Test Test class
@version : 1.0  
*/ 
@isTest (seealldata = false)
private class ARV_AP75_updateContractStatus_Test {
    /*******************************************************************************************************************************
@Description: updtStatusTest() method 
@Name : updtStatusTest
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
    private static testmethod void updtStatusTest()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestUnderwriter','TestUnderwriter@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {
            try{
                Account testAccount3 = GA_OBJ_TD01_TestDataCreation.AccRec();
                testAccount3.Name = 'Test Cust Acc';
                testAccount3.Account_Status__c='Active';
                testAccount3.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Prospect').getRecordTypeId();
                database.insert(testAccount3);
                
                Contract con1 = ARV_AP05_TestDataCreation.createContractRec(testAccount3.Id);
                database.insert(con1);
                
                case cas=GA_OBJ_TD01_TestDataCreation.CaseRec();
                cas.recordtypeid=Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('GA_Support_Issues').getRecordTypeId();
                //cas.recordtypeid=Schema.SObjectType.Case.getRecordTypeInfosByName().get('Support - Issues').getRecordTypeId();
                cas.AccountId = testAccount3.id;
                cas.GA_IssuesCategory__c='Administration';
                database.insert(cas);
                
                List<GA_WF_Workflow__c> wfList = new List<GA_WF_Workflow__c>();
                
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
                wfRec.ARV_Enrollment_Contract__c=Con1.Id;
                
                wfList.add(wfRec);
                database.insert(wfList);
                
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
                
                Con1.Status = 'Approved - Validate Prospect Data/Generate Group Segments';
                Con1.ARV_Is_Mass_Updating__c = True;
                database.update(Con1);
                
                set<id> contrctIds=new set<id>();
                for(GA_WF_Workflow__c objWF : wfList){
                    objWF.GA_Status__c='Closed';
                    contrctIds.add(objWF.ARV_Enrollment_Contract__c); 
                }
                
                Con1.Status = 'Manual Enrollment Setup - Complete';
                Con1.ARV_Is_Mass_Updating__c = True;
                database.update(Con1);
                
                Test.startTest();
                ARV_AP75_updateContractStatus.updtCntrctStatus(wfList);
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
@Description: updtStatusTest2() method 
@Name : updtStatusTest2
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
    private static testmethod void updtStatusTest2()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestUnderwriter','TestUnderwriter@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {
            try{
                Account testAccount3 = GA_OBJ_TD01_TestDataCreation.AccRec();
                testAccount3.Name = 'Test Cust Acc';
                testAccount3.Account_Status__c='Active';
                testAccount3.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Prospect').getRecordTypeId();
                database.insert(testAccount3);
                
                Contract con1 = ARV_AP05_TestDataCreation.createContractRec(testAccount3.Id);
                database.insert(con1);
                
                case cas=GA_OBJ_TD01_TestDataCreation.CaseRec();
                cas.recordtypeid=Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('GA_Support_Issues').getRecordTypeId();
                //cas.recordtypeid=Schema.SObjectType.Case.getRecordTypeInfosByName().get('Support - Issues').getRecordTypeId();
                cas.AccountId = testAccount3.id;
                cas.GA_IssuesCategory__c='Administration';
                database.insert(cas);
                
                List<GA_WF_Workflow__c> wfList = new List<GA_WF_Workflow__c>();
                
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
                wfRec.GA_Status__c = 'Closed';
                wfRec.GA_Workflow_Template__c =wfTemp.id;
                wfRec.ARV_Enrollment_Contract__c=Con1.Id;
                
                wfList.add(wfRec);
                database.insert(wfList);
                
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
                
                Con1.Status = 'Approved - Validate Prospect Data/Generate Group Segments';
                Con1.ARV_Is_Mass_Updating__c = True;
                database.update(Con1);
                
                set<id> contrctIds=new set<id>();
                for(GA_WF_Workflow__c objWF : wfList){
                    objWF.GA_Status__c='Closed';
                    contrctIds.add(objWF.ARV_Enrollment_Contract__c); 
                }
                
                Con1.Status = 'Manual Enrollment Setup - Complete';
                Con1.ARV_Is_Mass_Updating__c = True;
                database.update(Con1);
                
                Test.startTest();
                ARV_AP75_updateContractStatus.updtCntrctStatus(wfList);
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
@Description: updatContrctStatusExcp() method 
@Name : updatContrctStatusExcp
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
    private static testmethod void updatContrctStatusExcp(){
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestSysAdm','testsysadm@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr){
            try{
                Test.startTest();
                ARV_AP75_updateContractStatus.updtCntrctStatus(null);
                GA_WorkflowTrgrHndlr.afterUpdate(null,null);
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