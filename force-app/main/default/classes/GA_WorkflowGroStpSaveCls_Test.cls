/*****************************************************************************************
Class Name   : GA_WorkflowGroStpSaveCls_Test
Date Created : 10/05/2017
Created By   : IDC Offshore
Description  : 1. This is controller class to assign the GS ownership
******************************************************************************************/
@isTest
public class GA_WorkflowGroStpSaveCls_Test {
    /*******************************************************************************************************************************
@Description: excuteWFGSwithQueueOwner() method 
@Name : excuteWFGSwithQueueOwner
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
    private static testMethod void excuteWFGSwithQueueOwner() {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestSysAdm','testsysadm@bcbsm.com','System Administrator');
        
        insert usr;
        system.runAs(usr)
        {
            try{
                GA_WFT_workflow__c wfTemp = GA_OBJ_TD01_TestDataCreation.wrkFlwTmplt();
                database.insert(wfTemp);
                
                GA_WFT_Inventory_Step__c wfInvStp = GA_OBJ_TD01_TestDataCreation.wfInventoryStp();
                database.insert(wfInvStp);
                
                GA_WFT_Step__c wftStp = GA_OBJ_TD01_TestDataCreation.wrkTmpStp(wfTemp,wfInvStp);
                database.insert(wftStp);
                
                GA_WFT_Allowed_Next_Step__c wftNxtStp = GA_OBJ_TD01_TestDataCreation.wfAlwdNxtStp(wftStp);
                database.insert(wftNxtStp);
                
                Account testAccount = GA_OBJ_TD01_TestDataCreation.AccRec();
                database.insert(testAccount);
                
                case cas=GA_OBJ_TD01_TestDataCreation.CaseRec();
                cas.recordtypeid=Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('GA_Support_Issues').getRecordTypeId();
                //cas.recordtypeid=Schema.SObjectType.Case.getRecordTypeInfosByName().get('Support - Issues').getRecordTypeId();
                cas.AccountId = testAccount.id;
                cas.GA_IssuesCategory__c='Administration';
                database.insert(cas);
                
                GA_WF_Workflow__c wfRec = New GA_WF_Workflow__c();
                wfRec.GA_Account__c = testAccount.id;
                wfRec.GA_Support__c = cas.id;
                wfRec.GA_Carrier__c = wfTemp.GA_Carrier__c;
                wfRec.GA_Method__c = wfTemp.GA_Method__c;
                wfRec.Sub_Type__c = wfTemp.GA_Process_Subtype__c;
                wfRec.GA_Type__c=wfTemp.GA_Process_Type__c;
                wfRec.GA_Status__c = 'Open';
                wfRec.GA_Workflow_Template__c =wfTemp.id;
                database.insert(wfRec);
                
                Group testGroup = new Group(Name='GA Project Support Queue', Type='Queue');
                insert testGroup;
                
                QueuesObject testQueue = new QueueSObject(QueueID = testGroup.id, SObjectType = 'GA_WF_Group_Segment__c');
                insert testQueue;
                
                GA_WF_Step__c wfStepRec = New  GA_WF_Step__c();
                wfStepRec.GA_Status__c = 'Open';
                wfStepRec.GA_WF_Template_Step__c = wftStp.id;
                wfStepRec.GA_WF_Workflow_ID__c = wfRec.id;
                wfStepRec.GA_Notes__c = 'Test';
                
                GA_WF_Step__c wfStepRec1 = New  GA_WF_Step__c();
                wfStepRec1.GA_Status__c = 'Closed';
                wfStepRec1.GA_WF_Template_Step__c = wftStp.id;
                wfStepRec1.GA_WF_Workflow_ID__c = wfRec.id;
                wfStepRec1.GA_Notes__c = 'Test';
                
                database.insert(wfStepRec);  
                database.insert(wfStepRec1);
                
                GA_Group_Segment__c grpSgmntRec=GA_OBJ_TD01_TestDataCreation.grpSegmntRec(testAccount);
                database.insert(grpSgmntRec);
                
                GA_WF_Group_Segment__c wfgs = New GA_WF_Group_Segment__c();
                wfgs.GA_WF_Step_ID__c =   wfStepRec1.id;
                wfgs.GA_Workflow_ID__c = wfRec.id; 
                wfgs.GA_Workflow_Next_Step__c = wfStepRec.id;
                wfgs.GA_Group_Segment_ID__c = grpSgmntRec.id;
                wfgs.OwnerId = testQueue.queueid;
                wfgs.GA_Tracking_Status__c = 'IPQT';
                wfgs.GA_Problem_Identified_Values__c = '(2-G) Incorrect Template';
                database.insert(wfgs);
                
                List<Id> grpIdLst = New List<Id>();
                grpIdLst.add(wfgs.id);
                
                List<String> lstGroupSegments = New List<String>();
                lstGroupSegments.add(wfgs.GA_Group_Segment_ID__c);
                
                List<String> wfgsLst = New List<String>();
                wfgsLst.add(wfgs.id);
                
                Test.startTest();
                GA_WorkflowGroStpSaveCls.fetchwrkStpGSDetails(grpIdLst);
                GA_WorkflowGroStpSaveCls.updateWKGrpSgmnts(grpIdLst,wfgs);
                GA_WorkflowGroStpSaveCls.saveNextStep(wfStepRec.id,  wftStp.id, wftStp.id, lstGroupSegments, wfgsLst, wfgs,'',false,'Notes data');
                GA_WorkflowGroStpSaveCls.stepNameRec(wfStepRec.id);
                GA_WorkflowGroStpSaveCls.nextStepQueueInfoWFGS(wfStepRec.id, wftStp.id, wftStp.id, lstGroupSegments);
                GA_WorkflowGroStpSaveCls.notifyUseAssignedWFSTp('', wfRec.Id);
                GA_WorkflowGroStpSaveCls.chkLoggedInUsrprfle();
                GA_WorkflowGroStpSaveCls.fieldVisibilty();
                GA_WorkflowGroStpSaveCls.errMsgShow(wfStepRec.Id,lstGroupSegments);
                Test.stopTest();
            }
            catch(exception e)
            {
                return;
            }
        }					
    }
    /*******************************************************************************************************************************
@Description: fetchwrkStpGSDetailsExcepCvr() method 
@Name : fetchwrkStpGSDetailsExcepCvr
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
    private static testmethod void fetchwrkStpGSDetailsExcepCvr()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('Testexcep','testsalesrepmail2@bcbsm.com','Support');
        database.insert(usr);
        system.runAs(usr)
        {
            
            try {
                List<Id> grpIdLst = null;
                
                test.startTest();
                GA_WorkflowGroStpSaveCls.fetchwrkStpGSDetails(grpIdLst);
                
                
                test.stopTest();
                
            } 
            catch (exception e) {
                system.assert(e <> null);
                return;
            }
        }
    }
    /*******************************************************************************************************************************
@Description: fetchwrkStpGSDetailsExcep2Cvr() method 
@Name : fetchwrkStpGSDetailsExcep2Cvr
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
    private static testmethod void fetchwrkStpGSDetailsExcep2Cvr()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('Testexcep','testsalesrepmail2@bcbsm.com','Support');
        database.insert(usr);
        system.runAs(usr)
        {
            
            try {
                Id currentWorkflowStepId = null; 
                Id selectedWorkFlowTemplateStepId = null;
                string selectedWorkFlowStepName = '';
                List<String> lstGroupSegments = null;
                list<String> wfGrpIdsTmpLst = null;
                GA_WF_Group_Segment__c grpData = null;
                
                test.startTest();
                GA_WorkflowGroStpSaveCls.saveNextStep(currentWorkflowStepId,selectedWorkFlowTemplateStepId, selectedWorkFlowStepName, lstGroupSegments,wfGrpIdsTmpLst,grpData,'',false,'Notes data');
                
                test.stopTest();
            } 
            catch (exception e) {
                system.assert(e <> null);
                return;
            }
        }
    }
    /*******************************************************************************************************************************
@Description: fetchwrkStpGSDetailsExcep3Cvr() method 
@Name : fetchwrkStpGSDetailsExcep3Cvr
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
    private static testmethod void fetchwrkStpGSDetailsExcep3Cvr()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('Testexcep','testsalesrepmail2@bcbsm.com','Support');
        database.insert(usr);
        system.runAs(usr)
        {
            
            try {
                list<Id> wfGrpIdsTmpLst = null;
                GA_WF_Group_Segment__c grpData = null;
                
                test.startTest();
                GA_WorkflowGroStpSaveCls.updateWKGrpSgmnts(wfGrpIdsTmpLst, grpData);
                test.stopTest();
            } 
            catch (exception e) {
                system.assert(e <> null);
                return;
            }
        }
    }
    /*******************************************************************************************************************************
@Description: excuteWFGSwithCmpltStp() method 
@Name : excuteWFGSwithCmpltStp
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
    private static testMethod void excuteWFGSwithCmpltStp() {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestSysAdm','testsysadm@bcbsm.com','System Administrator');
        insert usr;
        system.runAs(usr)
        {
            try{
                GA_WFT_workflow__c wfTemp = GA_OBJ_TD01_TestDataCreation.wrkFlwTmplt();
                database.insert(wfTemp);
                
                GA_WFT_Inventory_Step__c wfInvStp = GA_OBJ_TD01_TestDataCreation.wfInventoryStp();
                database.insert(wfInvStp);
                
                GA_WFT_Step__c wftStp = GA_OBJ_TD01_TestDataCreation.wrkTmpStp(wfTemp,wfInvStp);
                database.insert(wftStp);
                
                GA_WFT_Allowed_Next_Step__c wftNxtStp = GA_OBJ_TD01_TestDataCreation.wfAlwdNxtStp(wftStp);
                database.insert(wftNxtStp);
                
                Account testAccount = GA_OBJ_TD01_TestDataCreation.AccRec();
                database.insert(testAccount);
                
                case cas=GA_OBJ_TD01_TestDataCreation.CaseRec();
                cas.recordtypeid=Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('GA_Support_Issues').getRecordTypeId();
                //cas.recordtypeid=Schema.SObjectType.Case.getRecordTypeInfosByName().get('Support - Issues').getRecordTypeId();
                cas.AccountId = testAccount.id;
                cas.GA_IssuesCategory__c='Administration';
                database.insert(cas);
                
                GA_WF_Workflow__c wfRec = New GA_WF_Workflow__c();
                wfRec.GA_Account__c = testAccount.id;
                wfRec.GA_Support__c = cas.id;
                wfRec.GA_Carrier__c = wfTemp.GA_Carrier__c;
                wfRec.GA_Method__c = wfTemp.GA_Method__c;
                wfRec.Sub_Type__c = wfTemp.GA_Process_Subtype__c;
                wfRec.GA_Type__c=wfTemp.GA_Process_Type__c;
                wfRec.GA_Status__c = 'Open';
                wfRec.GA_Workflow_Template__c =wfTemp.id;
                database.insert(wfRec);
                
                Group testGroup = new Group(Name='GA Project Support Queue', Type='Queue');
                insert testGroup;
                
                QueuesObject testQueue = new QueueSObject(QueueID = testGroup.id, SObjectType = 'GA_WF_Group_Segment__c');
                insert testQueue;
                
                GA_WF_Step__c wfStepRec = New  GA_WF_Step__c();
                wfStepRec.GA_Status__c = 'Closed';
                wfStepRec.GA_WF_Template_Step__c = wftStp.id;
                wfStepRec.GA_WF_Workflow_ID__c = wfRec.id;
                wfStepRec.GA_Notes__c = 'Test';
                
                GA_WF_Step__c wfStepRec1 = New  GA_WF_Step__c();
                wfStepRec1.GA_Status__c = 'Open';
                wfStepRec1.GA_WF_Template_Step__c = wftStp.id;
                wfStepRec1.GA_WF_Workflow_ID__c = wfRec.id;
                wfStepRec1.GA_Notes__c = 'Test';
                
                database.insert(wfStepRec);  
                database.insert(wfStepRec1);
                
                GA_Group_Segment__c grpSgmntRec=GA_OBJ_TD01_TestDataCreation.grpSegmntRec(testAccount);
                database.insert(grpSgmntRec);
                
                GA_WF_Group_Segment__c wfgs = New GA_WF_Group_Segment__c();
                wfgs.GA_WF_Step_ID__c =   wfStepRec1.id;
                wfgs.GA_Workflow_ID__c = wfRec.id; 
                wfgs.GA_Workflow_Next_Step__c = wfStepRec.id;
                wfgs.GA_Group_Segment_ID__c = grpSgmntRec.id;
                wfgs.OwnerId = testQueue.queueid;
                wfgs.GA_Tracking_Status__c = null;
                wfgs.GA_Problem_Identified_Values__c = null;
                wfgs.GA_Work_Type__c = 'Attestation';
                database.insert(wfgs);
                
                system.debug('Nxtstp...'+wfgs.GA_Workflow_Next_Step__c);
                
                List<Id> grpIdLst = New List<Id>();
                grpIdLst.add(wfgs.id);
                
                List<String> lstGroupSegments = New List<String>();
                lstGroupSegments.add(wfgs.GA_Group_Segment_ID__c);
                
                List<String> wfgsLst = New List<String>();
                wfgsLst.add(wfgs.id);
                
                Test.startTest();
                GA_WorkflowGroStpSaveCls.fetchwrkStpGSDetails(grpIdLst);
                GA_WorkflowGroStpSaveCls.updateWKGrpSgmnts(grpIdLst,wfgs);
                GA_WorkflowGroStpSaveCls.saveNextStep(wfStepRec.id,  wftStp.id, wftStp.id, lstGroupSegments, wfgsLst, wfgs,'',false,'Notes data');
                GA_WorkflowGroStpSaveCls.stepNameRec(wfStepRec.id);
                Test.stopTest();
            }
            catch(exception e)
            {
                return;
            }
        }          
    }    
    /*******************************************************************************************************************************
@Description: excuteWFGSCmpStpwithQueueOwner() method 
@Name : excuteWFGSCmpStpwithQueueOwner
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
    private static testMethod void excuteWFGSCmpStpwithQueueOwner() {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestSysAdm','testsysadm@bcbsm.com','System Administrator');
        
        insert usr;
        system.runAs(usr)
        {
            try{
                GA_WFT_workflow__c wfTemp = GA_OBJ_TD01_TestDataCreation.wrkFlwTmplt();
                database.insert(wfTemp);
                
                GA_WFT_Inventory_Step__c wfInvStp = GA_OBJ_TD01_TestDataCreation.wfInventoryStp();
                wfInvStp.Name='Completed';
                database.insert(wfInvStp);
                
                GA_WFT_Step__c wftStp = GA_OBJ_TD01_TestDataCreation.wrkTmpStp(wfTemp,wfInvStp);
                database.insert(wftStp);
                
                GA_WFT_Allowed_Next_Step__c wftNxtStp = GA_OBJ_TD01_TestDataCreation.wfAlwdNxtStp(wftStp);
                database.insert(wftNxtStp);
                
                Account testAccount = GA_OBJ_TD01_TestDataCreation.AccRec();
                database.insert(testAccount);
                
                case cas=GA_OBJ_TD01_TestDataCreation.CaseRec();
                cas.recordtypeid=Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('GA_Support_Issues').getRecordTypeId();
                //cas.recordtypeid=Schema.SObjectType.Case.getRecordTypeInfosByName().get('Support - Issues').getRecordTypeId();
                cas.AccountId = testAccount.id;
                cas.GA_IssuesCategory__c='Administration';
                database.insert(cas);
                
                GA_WF_Workflow__c wfRec = New GA_WF_Workflow__c();
                wfRec.GA_Account__c = testAccount.id;
                wfRec.GA_Support__c = cas.id;
                wfRec.GA_Carrier__c = wfTemp.GA_Carrier__c;
                wfRec.GA_Method__c = wfTemp.GA_Method__c;
                wfRec.Sub_Type__c = wfTemp.GA_Process_Subtype__c;
                wfRec.GA_Type__c=wfTemp.GA_Process_Type__c;
                wfRec.GA_Status__c = 'Open';
                wfRec.GA_Workflow_Template__c =wfTemp.id;
                database.insert(wfRec);
                
                Group testGroup = new Group(Name='GA Project Support Queue', Type='Queue');
                insert testGroup;
                
                QueuesObject testQueue = new QueueSObject(QueueID = testGroup.id, SObjectType = 'GA_WF_Group_Segment__c');
                insert testQueue;
                
                GA_WF_Step__c wfStepRec = New  GA_WF_Step__c();
                wfStepRec.GA_Status__c = 'Open';
                wfStepRec.GA_WF_Template_Step__c = wftStp.id;
                wfStepRec.GA_WF_Workflow_ID__c = wfRec.id;
                wfStepRec.GA_Notes__c = 'Test';
                
                GA_WF_Step__c wfStepRec1 = New  GA_WF_Step__c();
                wfStepRec1.GA_Status__c = 'Closed';
                wfStepRec1.GA_WF_Template_Step__c = wftStp.id;
                wfStepRec1.GA_WF_Workflow_ID__c = wfRec.id;
                wfStepRec1.GA_Notes__c = 'Test';
                
                database.insert(wfStepRec);  
                database.insert(wfStepRec1);
                
                GA_Group_Segment__c grpSgmntRec=GA_OBJ_TD01_TestDataCreation.grpSegmntRec(testAccount);
                database.insert(grpSgmntRec);
                
                GA_WF_Group_Segment__c wfgs = New GA_WF_Group_Segment__c();
                wfgs.GA_WF_Step_ID__c =   wfStepRec1.id;
                wfgs.GA_Workflow_ID__c = wfRec.id; 
                wfgs.GA_Workflow_Next_Step__c = wfStepRec.id;
                wfgs.GA_Group_Segment_ID__c = grpSgmntRec.id;
                wfgs.OwnerId = testQueue.queueid;
                wfgs.GA_Tracking_Status__c = 'IPQT';
                wfgs.GA_Problem_Identified_Values__c = '(2-G) Incorrect Template';
                database.insert(wfgs);
                
                List<Id> grpIdLst = New List<Id>();
                grpIdLst.add(wfgs.id);
                
                List<String> lstGroupSegments = New List<String>();
                lstGroupSegments.add(wfgs.GA_Group_Segment_ID__c);
                
                List<String> wfgsLst = New List<String>();
                wfgsLst.add(wfgs.id);
                
                Test.startTest();
                GA_WorkflowGroStpSaveCls.fetchwrkStpGSDetails(grpIdLst);
                GA_WorkflowGroStpSaveCls.updateWKGrpSgmnts(grpIdLst,wfgs);
                GA_WorkflowGroStpSaveCls.saveNextStep(wfStepRec.id,  wftStp.id, wftStp.id, lstGroupSegments, wfgsLst, wfgs,'',false,'Notes data');
                GA_WorkflowGroStpSaveCls.stepNameRec(wfStepRec.id);
                GA_WorkflowGroStpSaveCls.nextStepQueueInfoWFGS(wfStepRec.id, wftStp.id, wftStp.id, lstGroupSegments);
                GA_WorkflowGroStpSaveCls.notifyUseAssignedWFSTp('', wfRec.Id);
                GA_WorkflowGroStpSaveCls.chkLoggedInUsrprfle();
                GA_WorkflowGroStpSaveCls.fieldVisibilty();
                GA_WorkflowGroStpSaveCls.errMsgShow(wfStepRec.Id,lstGroupSegments);
                Test.stopTest();
            }
            catch(exception e)
            {
                return;
            }
        }					
    } 
    /*******************************************************************************************************************************
@Description: wrkflwGSnxtStpQueExcp() method 
@Name : wrkflwGSnxtStpQueExcp
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
    private static testmethod void wrkflwGSnxtStpQueExcp()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestSysAdm','testsysadm@bcbsm.com','System Administrator');
        
        insert usr;
        system.runAs(usr)
        {
            try
            {
                GA_WorkflowGroStpSaveCls.nextStepQueueInfoWFGS(null, null, null, null);
                
            }
            catch(exception ex)
            {
                return;
            }
        }
    }
    /*******************************************************************************************************************************
@Description: wrkflwGSnotifyuserExcp() method 
@Name : wrkflwGSnotifyuserExcp
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
    private static testmethod void wrkflwGSnotifyuserExcp()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestSysAdm','testsysadm@bcbsm.com','System Administrator');
        
        insert usr;
        system.runAs(usr)
        {
            try
            {
                
                GA_WorkflowGroStpSaveCls.notifyUseAssignedWFSTp(null, null);   
            }
            catch(exception ex)
            {
                return;
            }
        }
    }
    /*******************************************************************************************************************************
@Description: errMsgShowExcp() method 
@Name : errMsgShowExcp
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
    private static testmethod void errMsgShowExcp()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestSysAdm','testsysadm@bcbsm.com','System Administrator');
        
        insert usr;
        system.runAs(usr)
        {
            try
            {
                
                GA_WorkflowGroStpSaveCls.errMsgShow(null, null);   
            }
            catch(exception ex)
            {
                return;
            }
        }
    }
    /*******************************************************************************************************************************
@Description: stpNameExcp() method 
@Name : stpNameExcp
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
    private static testmethod void stpNameExcp()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestSysAdm','testsysadm@bcbsm.com','System Administrator');
        
        insert usr;
        system.runAs(usr)
        {
            try
            {
                
                GA_WorkflowGroStpSaveCls.stepNameRec(null);   
            }
            catch(exception ex)
            {
                return;
            }
        }
    }
    
}