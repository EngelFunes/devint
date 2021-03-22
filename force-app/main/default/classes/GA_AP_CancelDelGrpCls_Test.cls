/*
@Author : IDC offshore
@Name: GA_AP_CancelDelGrpCls_Test 
@CreatedDate: 22 - Nov 2018 
@Description: GA_AP_CancelDelGrpCls_Test Test class
@version : 1.0  
*/
@isTest(seealldata = false)
private class GA_AP_CancelDelGrpCls_Test {
    /**
@Description: asepGrpSgmtCnclDelete() method 
@Name : asepGrpSgmtCnclDelete
@Param : N/A   
@Return : void
@throws Exception : N/A;
*/   
    private static testmethod void asepGrpSgmtCnclDelete()
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
                
                GA_Group_Segment__c grpsgmt = GA_OBJ_TD01_TestDataCreation.grpSegmntRec(acc);
                database.insert(grpsgmt);
                
                grpsgmt.Name='Test';
                grpsgmt.GA_Post_Transaction__c=True;
                grpsgmt.Status__c='Pending';
                grpsgmt.GA_Transaction_Posted__c=True;
                grpsgmt.GA_PostGrpNots__c='Notes';
                grpsgmt.GA_SourceASG__c=True;
                database.update(grpsgmt);
                
                GA_WF_Group_Segment__c wfgs = New GA_WF_Group_Segment__c();
                wfgs.GA_WF_Step_ID__c =   wfStepRec.id;
                wfgs.GA_Workflow_ID__c = wfRec.id;  
                wfgs.GA_Group_Segment_ID__c = grpsgmt.id;
                wfgs.OwnerId = usr.id;
                wfgs.GA_Workflow_Next_Step__c = wfStepRec1.id;
                wfgs.GA_Status__c='Closed';
                database.insert(wfgs);
                
                GA_Trigger_Functionality_By_Pass__c tcs =new GA_Trigger_Functionality_By_Pass__c();
                tcs.GA_Delete_Group_Segment__c = True;
                tcs.SetupOwnerId=usr.ProfileId;
                database.insert(tcs);
                
                test.startTest();
                GA_AP_CancelDelGrpCls.delGrpSgmnts(grpsgmt.Id);
                GA_AP_CancelDelGrpCls.archiveGSRecs(grpsgmt.Id);
                GA_AP_CancelDelGrpCls.deleteGSRelatedWFData(wfgs.Id);
                test.stopTest();
                
                system.assert(usr <> null);
            }
            catch(exception e)
            {
                return;
            }
        }
        
    }
    /**
@Description: nonASEPGrpSgmtCnclDelete() method 
@Name : nonASEPGrpSgmtCnclDelete
@Param : N/A   
@Return : void
@throws Exception : N/A;
*/   
    private static testmethod void nonASEPGrpSgmtCnclDelete()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestGrpSgmtrelatLst','testsystemadminstrator@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {
            try {
                Account acc=GA_OBJ_TD01_TestDataCreation.AccRec();
                database.insert(acc);
                
                acc.GA_System_of_Record__c='Salesforce';
                database.update(acc);
                GA_Group_Segment__c grpsgmt = GA_OBJ_TD01_TestDataCreation.grpSegmntRec(acc);
                database.insert(grpsgmt);
                
                grpsgmt.Name='Test';
                grpsgmt.GA_Post_Transaction__c=True;
                grpsgmt.Status__c='Active';
                grpsgmt.GA_Transaction_Posted__c=True;
                grpsgmt.GA_PostGrpNots__c='Notes';
                grpsgmt.GA_SourceASG__c=False;
                database.update(grpsgmt);
                
                GA_Trigger_Functionality_By_Pass__c tcs =new GA_Trigger_Functionality_By_Pass__c();
                tcs.GA_Delete_Group_Segment__c = True;
                tcs.SetupOwnerId=usr.ProfileId;
                database.insert(tcs);
                
                test.startTest();
                GA_AP_CancelDelGrpCls.delGrpSgmnts(grpsgmt.Id);
                GA_AP_CancelDelGrpCls.archiveGSRecs(grpsgmt.Id);
                GA_AP_CancelDelGrpCls.deleteGSRelatedWFData(grpsgmt.Id);
                test.stopTest();
                
                system.assert(usr <> null);
            }
            catch(exception e)
            {
                return;
            }
        }
    }
    /**
@Description: smartASEPGrpSgmtCnclDelete() method 
@Name : smartASEPGrpSgmtCnclDelete
@Param : N/A   
@Return : void
@throws Exception : N/A;
*/   
    private static testmethod void smartASEPGrpSgmtCnclDelete()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestGrpSgmtrelatLst','testsystemadminstrator@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {
            try {
                Account acc=GA_OBJ_TD01_TestDataCreation.AccRec();
                database.insert(acc);
                
                acc.GA_System_of_Record__c='SMART';
                database.update(acc);
                GA_Group_Segment__c grpsgmt = GA_OBJ_TD01_TestDataCreation.grpSegmntRec(acc);
                database.insert(grpsgmt);
                
                grpsgmt.Name='Test';
                grpsgmt.GA_Post_Transaction__c=True;
                grpsgmt.Status__c='Active';
                grpsgmt.GA_Transaction_Posted__c=True;
                grpsgmt.GA_PostGrpNots__c='Notes';
                grpsgmt.GA_SourceASG__c=False;
                database.update(grpsgmt);
                
                GA_Trigger_Functionality_By_Pass__c tcs =new GA_Trigger_Functionality_By_Pass__c();
                tcs.GA_Delete_Group_Segment__c = True;
                tcs.SetupOwnerId=usr.ProfileId;
                database.insert(tcs);
                
                test.startTest();
                GA_AP_CancelDelGrpCls.delGrpSgmnts(grpsgmt.Id);
                GA_AP_CancelDelGrpCls.archiveGSRecs(grpsgmt.Id);
                GA_AP_CancelDelGrpCls.deleteGSRelatedWFData(grpsgmt.Id);
                test.stopTest();
                
                system.assert(usr <> null);
            }
            catch(exception e)
            {
                return;
            }
        }
    }
    /**
@Description: insufPrvGrpSgmtCnclDelete() method 
@Name : insufPrvGrpSgmtCnclDelete
@Param : N/A   
@Return : void
@throws Exception : N/A;
*/   
    private static testmethod void insufPrvGrpSgmtCnclDelete()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestGrpSgmtrelatLst','testsystemadminstrator@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {
            try {
                Account acc=GA_OBJ_TD01_TestDataCreation.AccRec();
                database.insert(acc);
                
                acc.GA_System_of_Record__c='Salesforce';
                database.update(acc);
                GA_Group_Segment__c grpsgmt = GA_OBJ_TD01_TestDataCreation.grpSegmntRec(acc);
                database.insert(grpsgmt);
                
                grpsgmt.Name='Test';
                grpsgmt.GA_Post_Transaction__c=True;
                grpsgmt.Status__c='Pending';
                grpsgmt.GA_Transaction_Posted__c=True;
                grpsgmt.GA_PostGrpNots__c='Notes';
                grpsgmt.GA_SourceASG__c=True;
                database.update(grpsgmt);
                
                test.startTest();
                GA_AP_CancelDelGrpCls.delGrpSgmnts(grpsgmt.Id);
                GA_AP_CancelDelGrpCls.archiveGSRecs(grpsgmt.Id);
                GA_AP_CancelDelGrpCls.deleteGSRelatedWFData(grpsgmt.Id);
                test.stopTest();
                
                system.assert(usr <> null);
            }
            catch(exception e)
            {
                return;
            }
        }
    }
}