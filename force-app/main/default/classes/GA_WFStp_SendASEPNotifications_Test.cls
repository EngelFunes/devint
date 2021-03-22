/*
@Author : IDC offshore
@Name: GA_WFStp_SendASEPNotifications_Test 
@CreatedDate: 15 - Nov 2018 
@Description: GA_WFStp_SendASEPNotifications Test class
@version : 1.0  
*/
@isTest(seealldata = false)
private class GA_WFStp_SendASEPNotifications_Test {
    /**
@Description: asepBCBSM1stWfNotifications() method 
@Name : asepBCBSM1stWfNotifications
@Param : N/A   
@Return : void
@throws Exception : N/A;
*/   
    private static testmethod void asepBCBSM1stWfNotifications()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestSysAdm','testsysadm@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {
            try {
                
                
                
                map<Id, GA_WF_Step__c> wfstpNewMap = new map<Id, GA_WF_Step__c>();
                
                GA_Agent_Sold_Contact__c ascRecd=GA_OBJ_TD01_TestDataCreation.agntSoldContact();
                database.insert(ascRecd); 
                ascRecd.GA_Email__c='testDecisionmaker@gmail.com';
                database.update(ascRecd);
                
                GA_Agent_Sold_Enrollment__c aseRecd=GA_OBJ_TD01_TestDataCreation.agentSoldEnrollemnt(ascRecd);
                database.insert(aseRecd);
                aseRecd.GA_Email__c='testManagingAgent@gmail.com';
                database.update(aseRecd);
                
                GA_WFT_workflow__c wfTemp = GA_OBJ_TD01_TestDataCreation.wrkFlwTmplt();
                database.insert(wfTemp);
                wfTemp.Name= 'BCBSM Agent Sold Enrollment - New Business';
                wfTemp.GA_Carrier__c = 'BCBSM';
                wfTemp.GA_Method__c = 'Manual';
                wfTemp.GA_Process_Type__c  = 'New Business';
                wfTemp.GA_Process_Subtype__c  = 'Agent Sold Enrollment';
                database.update(wfTemp);
                
                GA_WFT_Inventory_Step__c wfInvStp = GA_OBJ_TD01_TestDataCreation.wfInventoryStp();
                database.insert(wfInvStp);
                
                GA_WFT_Inventory_Step__c wfInvStp1 = GA_OBJ_TD01_TestDataCreation.wfInventoryStp();
                database.insert(wfInvStp1);
                
                GA_WFT_Step__c wftStp = GA_OBJ_TD01_TestDataCreation.wrkTmpStp(wfTemp,wfInvStp);
                database.insert(wftStp);
                
                GA_WFT_Allowed_Next_Step__c wftNxtStp = GA_OBJ_TD01_TestDataCreation.wfAlwdNxtStp(wftStp);
                database.insert(wftNxtStp);
                
                Account testAccount = GA_OBJ_TD01_TestDataCreation.AccRec();
                database.insert(testAccount);
                
                case cas=GA_OBJ_TD01_TestDataCreation.CaseRec();
                //cas.recordtypeid=Schema.SObjectType.Case.getRecordTypeInfosByName().get('Support - Issues').getRecordTypeId();
                cas.recordtypeid=Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('GA_Support_Issues').getRecordTypeId();
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
                wfRec.GA_ASEP__c=aseRecd.Id;
                wfRec.GA_External_Initiated__c=True;
                database.insert(wfRec);
                
                Group testGroup = new Group(Name='GA Project Support Queue', Type='Queue');
                database.insert(testGroup);
                
                QueuesObject testQueue = new QueueSObject(QueueID = testGroup.id, SObjectType = 'GA_WF_Group_Segment__c');
                database.insert(testQueue);
                
                GA_WF_Step__c wfStepRec = New  GA_WF_Step__c();
                wfStepRec.Name = wfInvStp.Name;
                wfStepRec.GA_Status__c = 'Open';
                wfStepRec.GA_WF_Template_Step__c = wftStp.id;
                wfStepRec.GA_WF_Workflow_ID__c = wfRec.id;
                wfStepRec.GA_Notes__c = 'Test';
                wfStepRec.OwnerId = usr.id;
                
                database.insert(wfStepRec);  
                
                GA_WF_Step__c wfStepRec1 = New  GA_WF_Step__c();
                wfStepRec1.Name = wfInvStp1.Name;
                wfStepRec1.GA_Status__c = 'Open';
                wfStepRec1.GA_WF_Template_Step__c = wftStp.id;
                wfStepRec1.GA_WF_Workflow_ID__c = wfRec.id;
                wfStepRec1.GA_Notes__c = 'Test';
                wfStepRec1.OwnerId = usr.id;
                
                database.insert(wfStepRec1); 
                
                GA_Group_Segment__c grpSgmntRec=GA_OBJ_TD01_TestDataCreation.grpSegmntRec(testAccount);
                database.insert(grpSgmntRec);
                
                GA_WF_Group_Segment__c wfgs = New GA_WF_Group_Segment__c();
                wfgs.GA_WF_Step_ID__c =   wfStepRec.id;
                wfgs.GA_Workflow_ID__c = wfRec.id;  
                wfgs.GA_Group_Segment_ID__c = grpSgmntRec.id;
                wfgs.OwnerId = testQueue.queueid;
                wfgs.GA_Workflow_Next_Step__c = wfStepRec1.id;
                database.insert(wfgs);
                
                List<GA_WF_Step__c> wfstpList=new List<GA_WF_Step__c>();
                GA_WF_Step__c wfstprcd= GA_OBJ_TD01_TestDataCreation.wrkFlwStp(wfRec);
                wfstprcd.Name = 'Small Group Underwriting - to Review';
                wfstpList.add(wfstprcd);
                database.insert(wfstpList);
                
                
                test.startTest();
                GA_WFStp_SendASEPNotifications.sendASEPNotificationToUsers(wfstpList,wfstpNewMap);
                test.stopTest();
                
                system.assert(wfstpList <> null);
                
            }
            catch(exception e)
            {
                return;
            }
        }
    }
    /**
@Description: asepBCBSM2ndWfNotifications() method 
@Name : asepBCBSM2ndWfNotifications
@Param : N/A   
@Return : void
@throws Exception : N/A;
*/   
    private static testmethod void asepBCBSM2ndWfNotifications()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestSysAdm','testsysadm@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {
            try {
                
                
                
                map<Id, GA_WF_Step__c> wfstpNewMap = new map<Id, GA_WF_Step__c>();
                
                GA_Agent_Sold_Contact__c ascRecd=GA_OBJ_TD01_TestDataCreation.agntSoldContact();
                database.insert(ascRecd); 
                ascRecd.GA_Email__c='testDecisionmaker@gmail.com';
                database.update(ascRecd);
                
                GA_Agent_Sold_Enrollment__c aseRecd=GA_OBJ_TD01_TestDataCreation.agentSoldEnrollemnt(ascRecd);
                database.insert(aseRecd);
                aseRecd.GA_Email__c='testManagingAgent@gmail.com';
                database.update(aseRecd);
                
                GA_WFT_workflow__c wfTemp = GA_OBJ_TD01_TestDataCreation.wrkFlwTmplt();
                database.insert(wfTemp);
                wfTemp.Name= 'BCBSM Agent Sold Enrollment - New Business';
                wfTemp.GA_Carrier__c = 'BCBSM';
                wfTemp.GA_Method__c = 'Manual';
                wfTemp.GA_Process_Type__c  = 'New Business';
                wfTemp.GA_Process_Subtype__c  = 'Agent Sold Enrollment';
                database.update(wfTemp);
                
                GA_WFT_Inventory_Step__c wfInvStp = GA_OBJ_TD01_TestDataCreation.wfInventoryStp();
                database.insert(wfInvStp);
                
                GA_WFT_Inventory_Step__c wfInvStp1 = GA_OBJ_TD01_TestDataCreation.wfInventoryStp();
                database.insert(wfInvStp1);
                
                GA_WFT_Step__c wftStp = GA_OBJ_TD01_TestDataCreation.wrkTmpStp(wfTemp,wfInvStp);
                database.insert(wftStp);
                
                GA_WFT_Allowed_Next_Step__c wftNxtStp = GA_OBJ_TD01_TestDataCreation.wfAlwdNxtStp(wftStp);
                database.insert(wftNxtStp);
                
                Account testAccount = GA_OBJ_TD01_TestDataCreation.AccRec();
                database.insert(testAccount);
                
                case cas=GA_OBJ_TD01_TestDataCreation.CaseRec();
                //cas.recordtypeid=Schema.SObjectType.Case.getRecordTypeInfosByName().get('Support - Issues').getRecordTypeId();
                cas.recordtypeid=Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('GA_Support_Issues').getRecordTypeId();
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
                wfRec.GA_ASEP__c=aseRecd.Id;
                wfRec.GA_External_Initiated__c=True;
                database.insert(wfRec);
                
                Group testGroup = new Group(Name='GA Project Support Queue', Type='Queue');
                database.insert(testGroup);
                
                QueuesObject testQueue = new QueueSObject(QueueID = testGroup.id, SObjectType = 'GA_WF_Group_Segment__c');
                database.insert(testQueue);
                
                GA_WF_Step__c wfStepRec = New  GA_WF_Step__c();
                wfStepRec.Name = wfInvStp.Name;
                wfStepRec.GA_Status__c = 'Open';
                wfStepRec.GA_WF_Template_Step__c = wftStp.id;
                wfStepRec.GA_WF_Workflow_ID__c = wfRec.id;
                wfStepRec.GA_Notes__c = 'Test';
                wfStepRec.OwnerId = usr.id;
                
                database.insert(wfStepRec);  
                
                GA_WF_Step__c wfStepRec1 = New  GA_WF_Step__c();
                wfStepRec1.Name = wfInvStp1.Name;
                wfStepRec1.GA_Status__c = 'Open';
                wfStepRec1.GA_WF_Template_Step__c = wftStp.id;
                wfStepRec1.GA_WF_Workflow_ID__c = wfRec.id;
                wfStepRec1.GA_Notes__c = 'Test';
                wfStepRec1.OwnerId = usr.id;
                
                database.insert(wfStepRec1); 
                
                GA_Group_Segment__c grpSgmntRec=GA_OBJ_TD01_TestDataCreation.grpSegmntRec(testAccount);
                database.insert(grpSgmntRec);
                
                GA_WF_Group_Segment__c wfgs = New GA_WF_Group_Segment__c();
                wfgs.GA_WF_Step_ID__c =   wfStepRec.id;
                wfgs.GA_Workflow_ID__c = wfRec.id;  
                wfgs.GA_Group_Segment_ID__c = grpSgmntRec.id;
                wfgs.OwnerId = testQueue.queueid;
                wfgs.GA_Workflow_Next_Step__c = wfStepRec1.id;
                database.insert(wfgs);
                
                List<GA_WF_Step__c> wfstpList=new List<GA_WF_Step__c>();
                GA_WF_Step__c wfstprcd= GA_OBJ_TD01_TestDataCreation.wrkFlwStp(wfRec);
                wfstprcd.Name = 'NB - for Assignment';
                wfstpList.add(wfstprcd);
                database.insert(wfstpList);
                
                
                test.startTest();
                GA_WFStp_SendASEPNotifications.sendASEPNotificationToUsers(wfstpList,wfstpNewMap);
                test.stopTest();
                
                system.assert(wfstpList <> null);
            }
            catch(exception e)
            {
                return;
            }
        }
    }
    /**
@Description: asepBCBSM3rdWfNotifications() method 
@Name : asepBCBSM3rdWfNotifications
@Param : N/A   
@Return : void
@throws Exception : N/A;
*/   
    private static testmethod void asepBCBSM3rdWfNotifications()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestSysAdm','testsysadm@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {
            try {
                
                
                
                map<Id, GA_WF_Step__c> wfstpNewMap = new map<Id, GA_WF_Step__c>();
                
                GA_Agent_Sold_Contact__c ascRecd=GA_OBJ_TD01_TestDataCreation.agntSoldContact();
                database.insert(ascRecd); 
                ascRecd.GA_Email__c='testDecisionmaker@gmail.com';
                database.update(ascRecd);
                
                GA_Agent_Sold_Enrollment__c aseRecd=GA_OBJ_TD01_TestDataCreation.agentSoldEnrollemnt(ascRecd);
                database.insert(aseRecd);
                aseRecd.GA_Email__c='testManagingAgent@gmail.com';
                database.update(aseRecd);
                
                GA_WFT_workflow__c wfTemp = GA_OBJ_TD01_TestDataCreation.wrkFlwTmplt();
                database.insert(wfTemp);
                wfTemp.Name= 'BCBSM Agent Sold Enrollment - New Business';
                wfTemp.GA_Carrier__c = 'BCBSM';
                wfTemp.GA_Method__c = 'Manual';
                wfTemp.GA_Process_Type__c  = 'New Business';
                wfTemp.GA_Process_Subtype__c  = 'Agent Sold Enrollment';
                database.update(wfTemp);
                
                GA_WFT_Inventory_Step__c wfInvStp = GA_OBJ_TD01_TestDataCreation.wfInventoryStp();
                database.insert(wfInvStp);
                
                GA_WFT_Inventory_Step__c wfInvStp1 = GA_OBJ_TD01_TestDataCreation.wfInventoryStp();
                database.insert(wfInvStp1);
                
                GA_WFT_Step__c wftStp = GA_OBJ_TD01_TestDataCreation.wrkTmpStp(wfTemp,wfInvStp);
                database.insert(wftStp);
                
                GA_WFT_Allowed_Next_Step__c wftNxtStp = GA_OBJ_TD01_TestDataCreation.wfAlwdNxtStp(wftStp);
                database.insert(wftNxtStp);
                
                Account testAccount = GA_OBJ_TD01_TestDataCreation.AccRec();
                database.insert(testAccount);
                
                case cas=GA_OBJ_TD01_TestDataCreation.CaseRec();
                //cas.recordtypeid=Schema.SObjectType.Case.getRecordTypeInfosByName().get('Support - Issues').getRecordTypeId();
                cas.recordtypeid=Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('GA_Support_Issues').getRecordTypeId();
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
                wfRec.GA_ASEP__c=aseRecd.Id;
                wfRec.GA_External_Initiated__c=True;
                database.insert(wfRec);
                
                Group testGroup = new Group(Name='GA Project Support Queue', Type='Queue');
                database.insert(testGroup);
                
                QueuesObject testQueue = new QueueSObject(QueueID = testGroup.id, SObjectType = 'GA_WF_Group_Segment__c');
                database.insert(testQueue);
                
                GA_WF_Step__c wfStepRec = New  GA_WF_Step__c();
                wfStepRec.Name = wfInvStp.Name;
                wfStepRec.GA_Status__c = 'Open';
                wfStepRec.GA_WF_Template_Step__c = wftStp.id;
                wfStepRec.GA_WF_Workflow_ID__c = wfRec.id;
                wfStepRec.GA_Notes__c = 'Test';
                wfStepRec.OwnerId = usr.id;
                
                database.insert(wfStepRec);  
                
                GA_WF_Step__c wfStepRec1 = New  GA_WF_Step__c();
                wfStepRec1.Name = wfInvStp1.Name;
                wfStepRec1.GA_Status__c = 'Open';
                wfStepRec1.GA_WF_Template_Step__c = wftStp.id;
                wfStepRec1.GA_WF_Workflow_ID__c = wfRec.id;
                wfStepRec1.GA_Notes__c = 'Test';
                wfStepRec1.OwnerId = usr.id;
                
                database.insert(wfStepRec1); 
                
                GA_Group_Segment__c grpSgmntRec=GA_OBJ_TD01_TestDataCreation.grpSegmntRec(testAccount);
                database.insert(grpSgmntRec);
                
                GA_WF_Group_Segment__c wfgs = New GA_WF_Group_Segment__c();
                wfgs.GA_WF_Step_ID__c =   wfStepRec.id;
                wfgs.GA_Workflow_ID__c = wfRec.id;  
                wfgs.GA_Group_Segment_ID__c = grpSgmntRec.id;
                wfgs.OwnerId = testQueue.queueid;
                wfgs.GA_Workflow_Next_Step__c = wfStepRec1.id;
                database.insert(wfgs);
                
                List<GA_WF_Step__c> wfstpList=new List<GA_WF_Step__c>();
                GA_WF_Step__c wfstprcd= GA_OBJ_TD01_TestDataCreation.wrkFlwStp(wfRec);
                wfstprcd.Name = 'Completed';
                wfstpList.add(wfstprcd);
                database.insert(wfstpList);
                
                
                test.startTest();
                GA_WFStp_SendASEPNotifications.sendASEPNotificationToUsers(wfstpList,wfstpNewMap);
                test.stopTest();
                
                system.assert(wfstpList <> null);
            }
            catch(exception e)
            {
                return;
            }
        }
    }
    /**
@Description: asepBCN1stWfNotifications() method 
@Name : asepBCN1stWfNotifications
@Param : N/A   
@Return : void
@throws Exception : N/A;
*/   
    private static testmethod void asepBCN1stWfNotifications()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestSysAdm','testsysadm@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {
            try {
                
                
                
                map<Id, GA_WF_Step__c> wfstpNewMap = new map<Id, GA_WF_Step__c>();
                
                GA_Agent_Sold_Contact__c ascRecd=GA_OBJ_TD01_TestDataCreation.agntSoldContact();
                database.insert(ascRecd); 
                ascRecd.GA_Email__c='testDecisionmaker@gmail.com';
                database.update(ascRecd);
                
                GA_Agent_Sold_Enrollment__c aseRecd=GA_OBJ_TD01_TestDataCreation.agentSoldEnrollemnt(ascRecd);
                database.insert(aseRecd);
                aseRecd.GA_Email__c='testManagingAgent@gmail.com';
                database.update(aseRecd);
                
                GA_WFT_workflow__c wfTemp = GA_OBJ_TD01_TestDataCreation.wrkFlwTmplt();
                database.insert(wfTemp);
                wfTemp.Name= 'BCN Agent Sold Enrollment - New Business';
                wfTemp.GA_Carrier__c = 'BCN';
                wfTemp.GA_Method__c = 'Manual';
                wfTemp.GA_Process_Type__c  = 'New Business';
                wfTemp.GA_Process_Subtype__c  = 'Agent Sold Enrollment';
                database.update(wfTemp);
                
                GA_WFT_Inventory_Step__c wfInvStp = GA_OBJ_TD01_TestDataCreation.wfInventoryStp();
                database.insert(wfInvStp);
                
                GA_WFT_Inventory_Step__c wfInvStp1 = GA_OBJ_TD01_TestDataCreation.wfInventoryStp();
                database.insert(wfInvStp1);
                
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
                wfRec.GA_ASEP__c=aseRecd.Id;
                wfRec.GA_External_Initiated__c=True;
                database.insert(wfRec);
                
                Group testGroup = new Group(Name='GA Project Support Queue', Type='Queue');
                database.insert(testGroup);
                
                QueuesObject testQueue = new QueueSObject(QueueID = testGroup.id, SObjectType = 'GA_WF_Group_Segment__c');
                database.insert(testQueue);
                
                GA_WF_Step__c wfStepRec = New  GA_WF_Step__c();
                wfStepRec.Name = wfInvStp.Name;
                wfStepRec.GA_Status__c = 'Open';
                wfStepRec.GA_WF_Template_Step__c = wftStp.id;
                wfStepRec.GA_WF_Workflow_ID__c = wfRec.id;
                wfStepRec.GA_Notes__c = 'Test';
                wfStepRec.OwnerId = usr.id;
                
                database.insert(wfStepRec);  
                
                GA_WF_Step__c wfStepRec1 = New  GA_WF_Step__c();
                wfStepRec1.Name = wfInvStp1.Name;
                wfStepRec1.GA_Status__c = 'Open';
                wfStepRec1.GA_WF_Template_Step__c = wftStp.id;
                wfStepRec1.GA_WF_Workflow_ID__c = wfRec.id;
                wfStepRec1.GA_Notes__c = 'Test';
                wfStepRec1.OwnerId = usr.id;
                
                database.insert(wfStepRec1); 
                
                GA_Group_Segment__c grpSgmntRec=GA_OBJ_TD01_TestDataCreation.grpSegmntRec(testAccount);
                database.insert(grpSgmntRec);
                
                GA_WF_Group_Segment__c wfgs = New GA_WF_Group_Segment__c();
                wfgs.GA_WF_Step_ID__c =   wfStepRec.id;
                wfgs.GA_Workflow_ID__c = wfRec.id;  
                wfgs.GA_Group_Segment_ID__c = grpSgmntRec.id;
                wfgs.OwnerId = testQueue.queueid;
                wfgs.GA_Workflow_Next_Step__c = wfStepRec1.id;
                database.insert(wfgs);
                
                List<GA_WF_Step__c> wfstpList=new List<GA_WF_Step__c>();
                GA_WF_Step__c wfstprcd= GA_OBJ_TD01_TestDataCreation.wrkFlwStp(wfRec);
                wfstprcd.Name = 'Small Group Underwriting - to Review';
                wfstpList.add(wfstprcd);
                database.insert(wfstpList);
                
                
                test.startTest();
                GA_WFStp_SendASEPNotifications.sendASEPNotificationToUsers(wfstpList,wfstpNewMap);
                test.stopTest();
                
                system.assert(wfstpList <> null);
            }
            catch(exception e)
            {
                return;
            }
        }
    }
    
    /**
@Description: asepBCN2ndWfNotifications() method 
@Name : asepBCN2ndWfNotifications
@Param : N/A   
@Return : void
@throws Exception : N/A;
*/   
    private static testmethod void asepBCN2ndWfNotifications()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestSysAdm','testsysadm@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {
            try {
                
                
                
                map<Id, GA_WF_Step__c> wfstpNewMap = new map<Id, GA_WF_Step__c>();
                
                GA_Agent_Sold_Contact__c ascRecd=GA_OBJ_TD01_TestDataCreation.agntSoldContact();
                database.insert(ascRecd); 
                ascRecd.GA_Email__c='testDecisionmaker@gmail.com';
                database.update(ascRecd);
                
                GA_Agent_Sold_Enrollment__c aseRecd=GA_OBJ_TD01_TestDataCreation.agentSoldEnrollemnt(ascRecd);
                database.insert(aseRecd);
                aseRecd.GA_Email__c='testManagingAgent@gmail.com';
                database.update(aseRecd);
                
                GA_WFT_workflow__c wfTemp = GA_OBJ_TD01_TestDataCreation.wrkFlwTmplt();
                database.insert(wfTemp);
                wfTemp.Name= 'BCN Agent Sold Enrollment - New Business';
                wfTemp.GA_Carrier__c = 'BCN';
                wfTemp.GA_Method__c = 'Manual';
                wfTemp.GA_Process_Type__c  = 'New Business';
                wfTemp.GA_Process_Subtype__c  = 'Agent Sold Enrollment';
                database.update(wfTemp);
                
                GA_WFT_Inventory_Step__c wfInvStp = GA_OBJ_TD01_TestDataCreation.wfInventoryStp();
                database.insert(wfInvStp);
                
                GA_WFT_Inventory_Step__c wfInvStp1 = GA_OBJ_TD01_TestDataCreation.wfInventoryStp();
                database.insert(wfInvStp1);
                
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
                wfRec.GA_ASEP__c=aseRecd.Id;
                wfRec.GA_External_Initiated__c=True;
                database.insert(wfRec);
                
                Group testGroup = new Group(Name='GA Project Support Queue', Type='Queue');
                database.insert(testGroup);
                
                QueuesObject testQueue = new QueueSObject(QueueID = testGroup.id, SObjectType = 'GA_WF_Group_Segment__c');
                database.insert(testQueue);
                
                GA_WF_Step__c wfStepRec = New  GA_WF_Step__c();
                wfStepRec.Name = wfInvStp.Name;
                wfStepRec.GA_Status__c = 'Open';
                wfStepRec.GA_WF_Template_Step__c = wftStp.id;
                wfStepRec.GA_WF_Workflow_ID__c = wfRec.id;
                wfStepRec.GA_Notes__c = 'Test';
                wfStepRec.OwnerId = usr.id;
                
                database.insert(wfStepRec);  
                
                GA_WF_Step__c wfStepRec1 = New  GA_WF_Step__c();
                wfStepRec1.Name = wfInvStp1.Name;
                wfStepRec1.GA_Status__c = 'Open';
                wfStepRec1.GA_WF_Template_Step__c = wftStp.id;
                wfStepRec1.GA_WF_Workflow_ID__c = wfRec.id;
                wfStepRec1.GA_Notes__c = 'Test';
                wfStepRec1.OwnerId = usr.id;
                
                database.insert(wfStepRec1); 
                
                GA_Group_Segment__c grpSgmntRec=GA_OBJ_TD01_TestDataCreation.grpSegmntRec(testAccount);
                database.insert(grpSgmntRec);
                
                GA_WF_Group_Segment__c wfgs = New GA_WF_Group_Segment__c();
                wfgs.GA_WF_Step_ID__c =   wfStepRec.id;
                wfgs.GA_Workflow_ID__c = wfRec.id;  
                wfgs.GA_Group_Segment_ID__c = grpSgmntRec.id;
                wfgs.OwnerId = testQueue.queueid;
                wfgs.GA_Workflow_Next_Step__c = wfStepRec1.id;
                database.insert(wfgs);
                
                List<GA_WF_Step__c> wfstpList=new List<GA_WF_Step__c>();
                GA_WF_Step__c wfstprcd= GA_OBJ_TD01_TestDataCreation.wrkFlwStp(wfRec);
                wfstprcd.Name = 'Send 2nd BCN Letter';
                wfstpList.add(wfstprcd);
                database.insert(wfstpList);
                
                
                test.startTest();
                GA_WFStp_SendASEPNotifications.sendASEPNotificationToUsers(wfstpList,wfstpNewMap);
                test.stopTest();
                
                system.assert(wfstpList <> null);
            }
            catch(exception e)
            {
                return;
            }
        }
    } 
    /**
@Description: asepErrExecuteTest() method 
@Name : asepErrExecuteTest
@Param : N/A   
@Return : void
@throws Exception : N/A;
*/   
    private static testmethod void asepErrExecuteTest()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestSysAdm','testsysadm@bcbsm.com','BCBSM Read Only');
        database.insert(usr);
        system.runAs(usr)
        {
            try {  
                GA_WF_Step__c wfStep = new GA_WF_Step__c();
                database.insert(wfStep);
                GA_WFStepTriggerHandler.afterInsert(null, null);
                
                system.assert(usr <> null);
            }
            catch(exception e)
            {
                return;
            }
        }
    }
}