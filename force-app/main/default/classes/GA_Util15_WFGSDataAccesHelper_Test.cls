/*******************************************************************************************************************************
@Author : IDC offshore
@Name: GA_Util15_WFGSDataAccesHelper_Test
@CreatedDate: 20 - Aug 2019 
@Description: GA_Util15_WFGSDataAccesHelper_Test class is for GA_Util15_WFGSDataAccesHelper.
@version : 1.0  
********************************************************************************************************************************/
@isTest(seealldata = false)
private class GA_Util15_WFGSDataAccesHelper_Test {
    /*******************************************************************************************************************************
@Description: wfgsDataAccssHlprTst() method 
@Name : wfgsDataAccssHlprTst
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
    private static testMethod void wfgsDataAccssHlprTst() {
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
@Description: wfgsDataAccssHlprExcptn() method 
@Name : wfgsDataAccssHlprExcptn
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
    private static testMethod void wfgsDataAccssHlprExcptn() {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestSysAdm','testsysadm@bcbsm.com','System Administrator');
        
        insert usr;
        system.runAs(usr)
        {
            try{
                GA_Util15_WFGSDataAccesHelper.fetchwrkflwGrpSgmMap('','','','');
                GA_Util15_WFGSDataAccesHelper.dmlOnWFGS(null,null);
                }
            catch(exception e)
            {
                return;
            }
        }					
    }
}