/*
@Author : IDC offshore
@Name: GA_AP_PostUnpostCls_Test 
@CreatedDate: 9/21/2018
@Description: GA_AP_PostUnpostCls_Test Test class
@version : 1.0  
*/
@isTest
private class GA_AP_PostUnpostCls_Test {
    /**
@Description: PostUnpostGSRec() method 
@Name : PostUnpostGSRec
@Param : GrpSgmntId
@Return : string
@throws Exception : N/A;
*/  
    public static testmethod void PostUnpostGSRec()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestGrpSgmtrelatLst','testsystemadminstrator@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {
            try {
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
                
                Account acc=GA_OBJ_TD01_TestDataCreation.AccRec();
                database.insert(acc);
                system.debug('acc debug'+acc);
                acc.GA_System_of_Record__c='Salesforce';
                database.update(acc);
                
                case cas=GA_OBJ_TD01_TestDataCreation.CaseRec();
                //cas.recordtypeid=Schema.SObjectType.Case.getRecordTypeInfosByName().get('Support - Issues').getRecordTypeId();
                cas.recordtypeid=Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('GA_Support_Issues').getRecordTypeId();	
                cas.AccountId = acc.id;
                cas.GA_IssuesCategory__c='Administration';
                database.insert(cas);
                
                GA_WF_Workflow__c wfRec = New GA_WF_Workflow__c();
                wfRec.GA_Account__c = acc.id;
                wfRec.GA_Support__c = cas.id;
                wfRec.GA_Carrier__c = wfTemp.GA_Carrier__c;
                wfRec.GA_Method__c = wfTemp.GA_Method__c;
                wfRec.Sub_Type__c = wfTemp.GA_Process_Subtype__c;
                wfRec.GA_Type__c=wfTemp.GA_Process_Type__c;
                wfRec.GA_Status__c = 'Closed';
                wfRec.GA_Workflow_Template__c =wfTemp.id;
                database.insert(wfRec);
                
                Group testGroup = new Group(Name='GA Project Support Queue', Type='Queue');
                insert testGroup;
                
                QueuesObject testQueue = new QueueSObject(QueueID = testGroup.id, SObjectType = 'GA_WF_Group_Segment__c');
                insert testQueue;
                
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
                
                GA_Group_Segment__c gs = GA_OBJ_TD01_TestDataCreation.grpSegmntRec(acc);
                database.insert(gs);
                system.debug('grp sgment debug'+gs);
                gs.Name='Test';
                gs.GA_Post_Transaction__c=False;
                gs.Status__c='Pending';
                gs.GA_Transaction_Posted__c=False;
                gs.GA_PostGrpNots__c='Notes';
                gs.GA_SourceASG__c=True;
                database.update(gs);
                
                GA_WF_Group_Segment__c wfgs = New GA_WF_Group_Segment__c();
                wfgs.GA_WF_Step_ID__c =   wfStepRec.id;
                wfgs.GA_Workflow_ID__c = wfRec.id;  
                wfgs.GA_Group_Segment_ID__c = gs.id;
                wfgs.OwnerId = usr.id;
                wfgs.GA_Workflow_Next_Step__c = wfStepRec1.id;
                wfgs.GA_Status__c='Closed';
                database.insert(wfgs);
                
                GA_Trigger_Functionality_By_Pass__c tcs =new GA_Trigger_Functionality_By_Pass__c();
                tcs.GA_Post_Unpost_Validation__c = True;
                tcs.SetupOwnerId=usr.ProfileId;
                insert tcs;
                
                test.startTest();
                GA_AP_PostUnpostCls.postUnpostSgmnts(gs.Id);
                GA_AP_PostUnpostCls.unpostGrpSgmnts(gs.Id);
                test.stopTest();
            }
            catch(exception e)
            {
                return;
            }
        }
        
    }
    /**
@Description: PostTrnstnTruGSRec() method 
@Name : PostTrnstnTruGSRec
@Param : GrpSgmntId
@Return : string
@throws Exception : N/A;
*/  
    public static testmethod void PostTrnstnTruGSRec()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestGrpSgmtrelatLst','testsystemadminstrator@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {
            try {
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
                
                Account acc=GA_OBJ_TD01_TestDataCreation.AccRec();
                database.insert(acc);
                system.debug('acc debug'+acc);
                acc.GA_System_of_Record__c='Salesforce';
                database.update(acc);
                
                case cas=GA_OBJ_TD01_TestDataCreation.CaseRec();
                //cas.recordtypeid=Schema.SObjectType.Case.getRecordTypeInfosByName().get('Support - Issues').getRecordTypeId();
                cas.recordtypeid=Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('GA_Support_Issues').getRecordTypeId();
                cas.AccountId = acc.id;
                cas.GA_IssuesCategory__c='Administration';
                database.insert(cas);
                
                GA_WF_Workflow__c wfRec = New GA_WF_Workflow__c();
                wfRec.GA_Account__c = acc.id;
                wfRec.GA_Support__c = cas.id;
                wfRec.GA_Carrier__c = wfTemp.GA_Carrier__c;
                wfRec.GA_Method__c = wfTemp.GA_Method__c;
                wfRec.Sub_Type__c = wfTemp.GA_Process_Subtype__c;
                wfRec.GA_Type__c=wfTemp.GA_Process_Type__c;
                wfRec.GA_Status__c = 'Closed';
                wfRec.GA_Workflow_Template__c =wfTemp.id;
                database.insert(wfRec);
                
                Group testGroup = new Group(Name='GA Project Support Queue', Type='Queue');
                insert testGroup;
                
                QueuesObject testQueue = new QueueSObject(QueueID = testGroup.id, SObjectType = 'GA_WF_Group_Segment__c');
                insert testQueue;
                
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
                
                GA_Group_Segment__c gs = GA_OBJ_TD01_TestDataCreation.grpSegmntRec(acc);
                database.insert(gs);
                system.debug('grp sgment debug'+gs);
                gs.Name='Test';
                gs.GA_Post_Transaction__c=True;
                gs.GA_Date_Posted__c=system.today();
                gs.Status__c='Pending';
                gs.GA_Transaction_Posted__c=False;
                gs.GA_PostGrpNots__c='Notes';
                gs.GA_SourceASG__c=True;
                database.update(gs);
                
                GA_WF_Group_Segment__c wfgs = New GA_WF_Group_Segment__c();
                wfgs.GA_WF_Step_ID__c =   wfStepRec.id;
                wfgs.GA_Workflow_ID__c = wfRec.id;  
                wfgs.GA_Group_Segment_ID__c = gs.id;
                wfgs.OwnerId = usr.id;
                wfgs.GA_Workflow_Next_Step__c = wfStepRec1.id;
                wfgs.GA_Status__c='Closed';
                database.insert(wfgs);
                
                GA_Trigger_Functionality_By_Pass__c tcs =new GA_Trigger_Functionality_By_Pass__c();
                tcs.GA_Post_Unpost_Validation__c = True;
                tcs.SetupOwnerId=usr.ProfileId;
                insert tcs;
                
                test.startTest();
                GA_AP_PostUnpostCls.postUnpostSgmnts(gs.Id);
                test.stopTest();
            }
            catch(exception e)
            {
                return;
            }
        }
        
    }
    /**
@Description: TrnsctnPostedTruGSRec() method 
@Name : TrnsctnPostedTruGSRec
@Param : GrpSgmntId
@Return : string
@throws Exception : N/A;
*/  
    public static testmethod void TrnsctnPostedTruGSRec()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestGrpSgmtrelatLst','testsystemadminstrator@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {
            try {
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
                
                Account acc=GA_OBJ_TD01_TestDataCreation.AccRec();
                database.insert(acc);
                system.debug('acc debug'+acc);
                acc.GA_System_of_Record__c='Salesforce';
                database.update(acc);
                
                case cas=GA_OBJ_TD01_TestDataCreation.CaseRec();
                cas.recordtypeid=Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('GA_Support_Issues').getRecordTypeId();
                //cas.recordtypeid=Schema.SObjectType.Case.getRecordTypeInfosByName().get('Support - Issues').getRecordTypeId();
                cas.AccountId = acc.id;
                cas.GA_IssuesCategory__c='Administration';
                database.insert(cas);
                
                GA_WF_Workflow__c wfRec = New GA_WF_Workflow__c();
                wfRec.GA_Account__c = acc.id;
                wfRec.GA_Support__c = cas.id;
                wfRec.GA_Carrier__c = wfTemp.GA_Carrier__c;
                wfRec.GA_Method__c = wfTemp.GA_Method__c;
                wfRec.Sub_Type__c = wfTemp.GA_Process_Subtype__c;
                wfRec.GA_Type__c=wfTemp.GA_Process_Type__c;
                wfRec.GA_Status__c = 'Closed';
                wfRec.GA_Workflow_Template__c =wfTemp.id;
                database.insert(wfRec);
                
                Group testGroup = new Group(Name='GA Project Support Queue', Type='Queue');
                insert testGroup;
                
                QueuesObject testQueue = new QueueSObject(QueueID = testGroup.id, SObjectType = 'GA_WF_Group_Segment__c');
                insert testQueue;
                
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
                
                GA_Group_Segment__c gs = GA_OBJ_TD01_TestDataCreation.grpSegmntRec(acc);
                database.insert(gs);
                system.debug('grp sgment debug'+gs);
                gs.Name='Test';
                gs.GA_Post_Transaction__c=True;
                gs.Status__c='Pending';
                gs.GA_Transaction_Posted__c=True;
                gs.GA_PostGrpNots__c='Notes';
                gs.GA_SourceASG__c=True;
                database.update(gs);
                
                GA_WF_Group_Segment__c wfgs = New GA_WF_Group_Segment__c();
                wfgs.GA_WF_Step_ID__c =   wfStepRec.id;
                wfgs.GA_Workflow_ID__c = wfRec.id;  
                wfgs.GA_Group_Segment_ID__c = gs.id;
                wfgs.OwnerId = usr.id;
                wfgs.GA_Workflow_Next_Step__c = wfStepRec1.id;
                wfgs.GA_Status__c='Closed';
                database.insert(wfgs);
                
                GA_Trigger_Functionality_By_Pass__c tcs =new GA_Trigger_Functionality_By_Pass__c();
                tcs.GA_Post_Unpost_Validation__c = True;
                tcs.SetupOwnerId=usr.ProfileId;
                insert tcs;
                
                test.startTest();
                GA_AP_PostUnpostCls.postUnpostSgmnts(gs.Id);
                test.stopTest();
            }
            catch(exception e)
            {
                return;
            }
        }
        
    }
    /**
@Description: NonASEPPostUnpostGSRec() method 
@Name : NonASEPPostUnpostGSRec
@Param : N/A   
@Return : void
@throws Exception : N/A;
*/   
    private static testmethod void NonASEPPostUnpostGSRec()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestGrpSgmtrelatLst','testsystemadminstrator@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {
            try {
                Account acc=GA_OBJ_TD01_TestDataCreation.AccRec();
                database.insert(acc);
                system.debug('acc debug'+acc);
                acc.GA_System_of_Record__c='Salesforce';
                database.update(acc);
                GA_Group_Segment__c gs = GA_OBJ_TD01_TestDataCreation.grpSegmntRec(acc);
                database.insert(gs);
                system.debug('grp sgment debug'+gs);
                gs.Name='Test';
                gs.GA_Post_Transaction__c=True;
                gs.Status__c='Active';
                gs.GA_Transaction_Posted__c=True;
                gs.GA_PostGrpNots__c='Notes';
                gs.GA_SourceASG__c=False;
                database.update(gs);
                
                GA_Trigger_Functionality_By_Pass__c tcs =new GA_Trigger_Functionality_By_Pass__c();
                tcs.GA_Post_Unpost_Validation__c = True;
                tcs.SetupOwnerId=usr.ProfileId;
                insert tcs;
                
                test.startTest();
                GA_AP_PostUnpostCls.postUnpostSgmnts(gs.Id);
                test.stopTest();
            }
            catch(exception e)
            {
                return;
            }
        }
    }
    /**
@Description: SMARTASEPPostUnpostGSRec() method 
@Name : SMARTASEPPostUnpostGSRec
@Param : N/A   
@Return : void
@throws Exception : N/A;
*/   
    private static testmethod void SMARTASEPPostUnpostGSRec()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestGrpSgmtrelatLst','testsystemadminstrator@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {
            try {
                Account acc=GA_OBJ_TD01_TestDataCreation.AccRec();
                database.insert(acc);
                system.debug('acc debug'+acc);
                acc.GA_System_of_Record__c='SMART';
                database.update(acc);
                GA_Group_Segment__c gs = GA_OBJ_TD01_TestDataCreation.grpSegmntRec(acc);
                database.insert(gs);
                system.debug('grp sgment debug'+gs);
                gs.Name='Test';
                gs.GA_Post_Transaction__c=True;
                gs.Status__c='Active';
                gs.GA_Transaction_Posted__c=True;
                gs.GA_PostGrpNots__c='Notes';
                gs.GA_SourceASG__c=False;
                database.update(gs);
                GA_Trigger_Functionality_By_Pass__c tcs =new GA_Trigger_Functionality_By_Pass__c();
                tcs.GA_Post_Unpost_Validation__c = True;
                tcs.SetupOwnerId=usr.ProfileId;
                insert tcs;
                test.startTest();
                GA_AP_PostUnpostCls.postUnpostSgmnts(gs.Id);
                test.stopTest();
            }
            catch(exception e)
            {
                return;
            }
        }
    }
    /**
@Description: InsufPrvPostUnpostGSRec() method 
@Name : InsufPrvPostUnpostGSRec
@Param : N/A   
@Return : void
@throws Exception : N/A;
*/   
    private static testmethod void InsufPrvPostUnpostGSRec()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestGrpSgmtrelatLst','testsystemadminstrator@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {
            try {
                Account acc=GA_OBJ_TD01_TestDataCreation.AccRec();
                database.insert(acc);
                system.debug('acc debug'+acc);
                acc.GA_System_of_Record__c='Salesforce';
                database.update(acc);
                GA_Group_Segment__c gs = GA_OBJ_TD01_TestDataCreation.grpSegmntRec(acc);
                database.insert(gs);
                system.debug('grp sgment debug'+gs);
                gs.Name='Test';
                gs.GA_Post_Transaction__c=True;
                gs.Status__c='Pending';
                gs.GA_Transaction_Posted__c=True;
                gs.GA_PostGrpNots__c='Notes';
                gs.GA_SourceASG__c=True;
                database.update(gs);
                
                test.startTest();
                GA_AP_PostUnpostCls.postUnpostSgmnts(gs.Id);
                test.stopTest();
            }
            catch(exception e)
            {
                return;
            }
        }
    }
    
}