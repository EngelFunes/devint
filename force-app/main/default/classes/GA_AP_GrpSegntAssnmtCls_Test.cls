/*******************************************************************************************************************************
@Author : IDC offshore
@Name: GA_AP_GrpSegntAssnmtCls_Test
@CreatedDate: 17 - April 2018 
@Description: GA_AP_GrpSegntAssnmtCls_Test class is for GA_AP_GrpSegntAssnmtCls.
@version : 1.0  
********************************************************************************************************************************/
@isTest
private class GA_AP_GrpSegntAssnmtCls_Test {
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
                
                database.insert(wfStepRec);  
                
                GA_Group_Segment__c grpSgmntRec=GA_OBJ_TD01_TestDataCreation.grpSegmntRec(testAccount);
                database.insert(grpSgmntRec);
                
                GA_WF_Group_Segment__c wfgs = New GA_WF_Group_Segment__c();
                wfgs.GA_WF_Step_ID__c =   wfStepRec.id;
                wfgs.GA_Workflow_ID__c = wfRec.id;  
                wfgs.GA_Group_Segment_ID__c = grpSgmntRec.id;
                wfgs.OwnerId = testQueue.queueid;
                database.insert(wfgs);
                
                String wfGrpIds = '['+wfgs.id +']';
                
                system.debug('***wfGrpIds***'+wfGrpIds);
                
                List<String> grpIdLst = New List<String>();
                grpIdLst.add(wfgs.id);
                
                Test.startTest();
                GA_AP_GrpSegntAssnmtCls.FectWKGrpSgmntSteps(wfGrpIds, null);
                GA_AP_GrpSegntAssnmtCls.updateWKGrpSgmnts(wfGrpIds, wfgs);
                GA_AP_GrpSegntAssnmtCls.checkQueueInfo(wfGrpIds, wfgs);
                GA_AP_GrpSegntAssnmtCls.checkQueueType(wfGrpIds, wfgs,true);
                GA_AP_GrpSegntAssnmtCls.assignOwnerWFGS(wfGrpIds, wfgs, userinfo.getUserId());
                //GA_AP_GrpSegntAssnmtCls.saveNextStep(wfStepRec.id, wftStp.id,wfInvStp.Name , grpIdLst, wfGrpIds);
                Test.stopTest();
            }
            catch(exception e)
            {
                return;
            }
        }					
    } 
    /*******************************************************************************************************************************
@Description: excuteWFGSwithUserOwner() method 
@Name : excuteWFGSwithUserOwner
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
    private static testMethod void excuteWFGSwithUserOwner() {
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
                
                database.insert(wfStepRec);  
                
                GA_Group_Segment__c grpSgmntRec=GA_OBJ_TD01_TestDataCreation.grpSegmntRec(testAccount);
                database.insert(grpSgmntRec);
                
                GA_WF_Group_Segment__c wfgs = New GA_WF_Group_Segment__c();
                wfgs.GA_WF_Step_ID__c =   wfStepRec.id;
                wfgs.GA_Workflow_ID__c = wfRec.id;  
                wfgs.GA_Group_Segment_ID__c = grpSgmntRec.id;
                wfgs.OwnerId = userinfo.getUserId();
                database.insert(wfgs);
                
                String wfGrpIds = '['+wfgs.id +']';
                
                system.debug('***wfGrpIds***'+wfGrpIds);
                
                List<String> grpIdLst = New List<String>();
                grpIdLst.add(wfgs.id);
                
                Test.startTest();
                GA_AP_GrpSegntAssnmtCls.FectWKGrpSgmntSteps(wfGrpIds, null);
                GA_AP_GrpSegntAssnmtCls.updateWKGrpSgmnts(wfGrpIds, wfgs);
                GA_AP_GrpSegntAssnmtCls.checkQueueInfo(wfGrpIds, wfgs);
                GA_AP_GrpSegntAssnmtCls.checkQueueType(wfGrpIds, wfgs,false);
                GA_AP_GrpSegntAssnmtCls.assignOwnerWFGS(wfGrpIds, wfgs, userinfo.getUserId());
                //GA_AP_GrpSegntAssnmtCls.saveNextStep(wfStepRec.id, wftStp.id,wfInvStp.Name , grpIdLst, wfGrpIds);
                Test.stopTest();
            }
            catch(exception e)
            {
                return;
            }
        }					
    } 
    
    private static testmethod void grpAssmntFectWKExcp()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestSysAdm','testsysadm@bcbsm.com','System Administrator');
        insert usr;
        system.runAs(usr)
        {
            try{
                Test.startTest();
                GA_AP_GrpSegntAssnmtCls.FectWKGrpSgmntSteps(null, null);
                GA_AP_GrpSegntAssnmtCls.updateWKGrpSgmnts(null, null);
                GA_AP_GrpSegntAssnmtCls.checkQueueInfo(null, null);
                GA_AP_GrpSegntAssnmtCls.checkQueueType(null, null,null);
                GA_AP_GrpSegntAssnmtCls.assignOwnerWFGS(null, null, null);
                
                Test.stopTest();
            }
            catch(exception e)
            {
                return;   
            }
        }
    }
    private static testmethod void grpAssmntUpdtWKExcp()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestSysAdm','testsysadm@bcbsm.com','System Administrator');
        insert usr;
        system.runAs(usr)
        {
            try{
                Test.startTest();
                GA_AP_GrpSegntAssnmtCls.updateWKGrpSgmnts(null, null);
                Test.stopTest();
            }
            catch(exception e)
            {
                return;   
            }
        }
    }
    private static testmethod void grpAssmntChkQueInfExcp()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestSysAdm','testsysadm@bcbsm.com','System Administrator');
        insert usr;
        system.runAs(usr)
        {
            try{
                Test.startTest();
                GA_AP_GrpSegntAssnmtCls.checkQueueInfo(null, null);
                Test.stopTest();
            }
            catch(exception e)
            {
                return;   
            }
        }
    }
    private static testmethod void grpAssmntChkQueExcp()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestSysAdm','testsysadm@bcbsm.com','System Administrator');
        insert usr;
        system.runAs(usr)
        {
            try{
                Test.startTest();
                GA_AP_GrpSegntAssnmtCls.checkQueueType(null, null,null);
                Test.stopTest();
            }
            catch(exception e)
            {
                return;   
            }
        }
    }
    private static testmethod void grpAssmntassgnOwnrExcp()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestSysAdm','testsysadm@bcbsm.com','System Administrator');
        insert usr;
        system.runAs(usr)
        {
            try{
                Test.startTest();
                
                GA_AP_GrpSegntAssnmtCls.assignOwnerWFGS(null, null, null);
                
                Test.stopTest();
            }
            catch(exception e)
            {
                return;   
            }
        }
    }
}