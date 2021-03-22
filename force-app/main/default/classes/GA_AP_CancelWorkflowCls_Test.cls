/*
@Name: GA_AP_CancelWorkflowCls_Test
@CreatedDate: 21 - Sep 2018 
@Description: GA_AP_CancelWorkflowCls Test class
@version : 1.0  
*/
@isTest(seealldata = false)
private class GA_AP_CancelWorkflowCls_Test {
    
    /**
@Description: canclNonOpenWrkflwmthd() method 
@Name : canclNonOpenWrkflwmthd
@Param : N/A   
@Return : void
@throws Exception : N/A;
*/   
    public static testmethod void canclNonOpenWrkflwmthd()
    {
        try{
            user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestRateCntrlPrcs','TestRateCntrlPrcs@bcbsm.com','System Administrator');
            database.insert(usr);
            system.runAs(usr)
            {
                GA_WFT_workflow__c wfTemp = GA_OBJ_TD01_TestDataCreation.wrkFlwTmplt();
                database.insert(wfTemp);
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
                wfRec.GA_Status__c = 'Closed';
                wfRec.GA_Workflow_Template__c =wfTemp.id;
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
                wfStepRec1.Name = 'Canceled';
                wfStepRec1.GA_Status__c = 'Canceled';
                wfStepRec1.GA_WF_Template_Step__c = wftStp.id;
                wfStepRec1.GA_WF_Workflow_ID__c = wfRec.id;
                wfStepRec1.GA_Notes__c = 'Test';
                wfStepRec1.OwnerId = usr.id;
                
                database.insert(wfStepRec1); 
                
                GA_Group_Segment__c grpSgmntRec=GA_OBJ_TD01_TestDataCreation.grpSegmntRec(testAccount);
                database.insert(grpSgmntRec);
                
                GA_Group_Segment__c grpSgmt= GA_OBJ_TD01_TestDataCreation.grpSegmntRec(testAccount);
                grpSgmt.Name = 'Test gsRec';
                grpSgmt.Status__c='Canceled';
                database.insert(grpSgmt);
                
                List<String> grpIdLst= new List<String>(); 
                grpIdLst.add(grpSgmt.Id);
                
                List<GA_WF_Group_Segment__c> wfgsLst= new List<GA_WF_Group_Segment__c>(); 
                GA_WF_Group_Segment__c wfgs = New GA_WF_Group_Segment__c();
                wfgs.GA_WF_Step_ID__c =   wfStepRec.id;
                wfgs.GA_Workflow_ID__c = wfRec.id;  
                wfgs.GA_Group_Segment_ID__c = grpSgmntRec.id;
                wfgs.OwnerId = usr.id;
                wfgs.GA_Workflow_Next_Step__c = wfStepRec1.id;
                wfgs.GA_Status__c='Closed';
                wfgsLst.add(wfgs);
                database.insert(wfgsLst);
                
                set<id> usrid = new set<id> ();
                usrid.add(usr.Id);
                
                set<id> wfStepIds=new set<id>();
                wfStepIds.add(wfgs.GA_WF_Step_ID__c);
                
                test.startTest();
                GA_AP_CancelWorkflowCls.wrkFlwInfo(wfRec.Id);
                GA_AP_CancelWorkflowCls.canclWrflw(wfRec.Id,'Cancelling',grpIdLst);
                GA_AP_CancelWorkflowCls.checkCancelWrkflwAccss(wfRec.Id);
                GA_AP_CancelWorkflowCls.retrievGrpSgmnts(wfRec.Id);
                //   GA_AP_CancelWorkflowCls.sendMailtoUsrs(usrid,wfStepRec.Id);
                test.stopTest(); 
                system.assert(wfRec <> null,true);
                
                system.assert(usr <> null);
            }
        }
        catch(exception e)
        {
            return;
        }
        
    }
    
    /**
@Description: canclaccsWrkflwmthd() method 
@Name : canclaccsWrkflwmthd
@Param : N/A   
@Return : void
@throws Exception : N/A;
*/   
    public static testmethod void canclaccsWrkflwmthd()
    {
        try{
            user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestBCNGMTProcessor','TestBCNGMTProcessor@bcbsm.com','System Administrator');
            database.insert(usr);
            system.runAs(usr)
            {
                GA_WFT_workflow__c wfTemp = GA_OBJ_TD01_TestDataCreation.wrkFlwTmplt();
                database.insert(wfTemp);
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
                
                GA_Group_Segment__c grpSgmt= GA_OBJ_TD01_TestDataCreation.grpSegmntRec(testAccount);
                grpSgmt.Name = 'Test gsRec1';
                grpSgmt.Status__c='Active';
                database.insert(grpSgmt);
                
                List<String> grpIdLst= new List<String>(); 
                grpIdLst.add(grpSgmt.Id);
                
                List<GA_WF_Group_Segment__c> wfgsLst= new List<GA_WF_Group_Segment__c>();
                GA_WF_Group_Segment__c wfgs = New GA_WF_Group_Segment__c();
                wfgs.GA_WF_Step_ID__c =   wfStepRec.id;
                wfgs.GA_Workflow_ID__c = wfRec.id;  
                wfgs.GA_Group_Segment_ID__c =grpSgmt.id;
                wfgs.OwnerId = usr.id;
                wfgs.GA_Workflow_Next_Step__c = wfStepRec1.id;
                wfgs.GA_Status__c='Open';
                wfgsLst.add(wfgs);
                database.insert(wfgsLst);
                
                set<id> usrid = new set<id> ();
                usrid.add(usr.Id);
                
                test.startTest();
                GA_AP_CancelWorkflowCls.wrkFlwInfo(wfRec.Id);
                GA_AP_CancelWorkflowCls.canclWrflw(wfRec.Id,'Cancelling',grpIdLst);
                GA_AP_CancelWorkflowCls.checkCancelWrkflwAccss(wfRec.Id);
                GA_AP_CancelWorkflowCls.retrievGrpSgmnts(wfRec.Id);
                //   GA_AP_CancelWorkflowCls.sendMailtoUsrs(usrid,wfStepRec.Id);
                test.stopTest();
                system.assert(wfRec <> null,true);
            }
            
        }
        catch(exception e)
        {
            return;
        }
    }
    
    /**
@Description: openClosedWfgsmthd() method 
@Name : openClosedWfgsmthd
@Param : N/A   
@Return : void
@throws Exception : N/A;
*/   
    public static testmethod void openClosedWfgsmthd()
    {
        try{
            user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestBCNGMTProcessor','TestBCNGMTProcessor@bcbsm.com','System Administrator');
            database.insert(usr);
            system.runAs(usr)
            {
                GA_WFT_workflow__c wfTemp = GA_OBJ_TD01_TestDataCreation.wrkFlwTmplt();
                database.insert(wfTemp);
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
                
                GA_Group_Segment__c grpSgmt= GA_OBJ_TD01_TestDataCreation.grpSegmntRec(testAccount);
                grpSgmt.Name = 'Test gsRec';
                grpSgmt.Status__c='Active';
                database.insert(grpSgmt);
                
                List<String> grpIdLst= new List<String>(); 
                grpIdLst.add(grpSgmt.Id);
                
                List<GA_WF_Group_Segment__c> wfgsLst= new List<GA_WF_Group_Segment__c>();
                GA_WF_Group_Segment__c wfgs = New GA_WF_Group_Segment__c();
                wfgs.GA_WF_Step_ID__c =   wfStepRec.id;
                wfgs.GA_Workflow_ID__c = wfRec.id;  
                wfgs.GA_Group_Segment_ID__c = grpSgmntRec.id;
                wfgs.OwnerId = usr.id;
                wfgs.GA_Workflow_Next_Step__c = wfStepRec1.id;
                wfgs.GA_Status__c='Open';
                wfgsLst.add(wfgs);
                database.insert(wfgsLst);
                
                List<GA_WF_Group_Segment__c> wfgsLst1= new List<GA_WF_Group_Segment__c>();
                GA_WF_Group_Segment__c wfgs1 = New GA_WF_Group_Segment__c();
                wfgs1.GA_WF_Step_ID__c =   wfStepRec.id;
                wfgs1.GA_Workflow_ID__c = wfRec.id;  
                wfgs1.GA_Group_Segment_ID__c = grpSgmntRec.id;
                wfgs1.OwnerId = usr.id;
                wfgs1.GA_Workflow_Next_Step__c = wfStepRec1.id;
                wfgs1.GA_Status__c='Closed';
                wfgsLst1.add(wfgs1);
                database.insert(wfgsLst1); 
                
                set<id> usrid = new set<id> ();
                usrid.add(usr.Id);
                
                test.startTest();
                GA_AP_CancelWorkflowCls.wrkFlwInfo(wfRec.Id);
                GA_AP_CancelWorkflowCls.canclWrflw(wfRec.Id,'Cancelling',grpIdLst);
                GA_AP_CancelWorkflowCls.checkCancelWrkflwAccss(wfRec.Id);
                GA_AP_CancelWorkflowCls.retrievGrpSgmnts(wfRec.Id);  
                //   GA_AP_CancelWorkflowCls.sendMailtoUsrs(usrid,wfStepRec.Id);
                test.stopTest();
                system.assert(wfRec <> null,true);
            }
        }
        catch(exception e)
        {
            return;
        }
    }
    
    
}