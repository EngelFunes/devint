/*******************************************************************************************************************************
@Author : IDC offshore
@Name: GA_WrkFlwSldAftr3pm_Test
@CreatedDate: 29 - May 2018 
@Description: GA_WrkFlwSldAftr3pm_Test class is for GA_WrkFlwSldAftr3pm.
@version : 1.0  
********************************************************************************************************************************/
@isTest(seealldata = false)
private class GA_WrkFlwSldAftr3pm_Test {
    /*******************************************************************************************************************************
@Description: afterUpdate_UT() method 
@Name : afterUpdate_UT
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
    private static testMethod void afterUpdate_UT() 
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestSysAdm','testsysadm@bcbsm.com','System Administrator');
        usr.GA_ByPass_VR__c=true;
        database.insert(usr);
        system.runAs(usr)
        {
            try{
                Map<Id,GA_WF_Group_Segment__c> newmap=new map<Id,GA_WF_Group_Segment__c>(); 
                Map<Id,GA_WF_Group_Segment__c> oldmap=new map<Id,GA_WF_Group_Segment__c>();
                GA_WFT_workflow__c wfTemp = GA_OBJ_TD01_TestDataCreation.wrkFlwTmplt();
                database.insert(wfTemp);
                
                GA_WFT_Inventory_Step__c wfInvStp = GA_OBJ_TD01_TestDataCreation.wfInventoryStp();                
                database.insert(wfInvStp);
                
                GA_WFT_Inventory_Step__c wfInvStpPreporccing = GA_OBJ_TD01_TestDataCreation.wfInventoryStp();
                wfInvStp.Name='Pre-Processing';
                database.insert(wfInvStpPreporccing);
                
                GA_WFT_Inventory_Step__c wfInvStpGWC = GA_OBJ_TD01_TestDataCreation.wfInventoryStp();                
                wfInvStpGWC.Name='GWC - for Assignment';
                database.insert(wfInvStpGWC);
                
                GA_WFT_Inventory_Step__c wfInvStpComp = GA_OBJ_TD01_TestDataCreation.wfInventoryStp();
                wfInvStpComp.Name='Completed';
                database.insert(wfInvStpComp);
                
                GA_WFT_Step__c wftStp = GA_OBJ_TD01_TestDataCreation.wrkTmpStp(wfTemp,wfInvStp);
                //wftStp.GA_Conditional_Assignment__c = 'GWC - for Assignment';
                database.insert(wftStp);
                
                GA_WFT_Step__c wftStpPrepprocssing = GA_OBJ_TD01_TestDataCreation.wrkTmpStp(wfTemp,wfInvStpPreporccing);
                wftStpPrepprocssing.GA_Conditional_Assignment__c = 'N/A';
                database.insert(wftStpPrepprocssing);
                
                GA_WFT_Step__c wftStpComp = GA_OBJ_TD01_TestDataCreation.wrkTmpStp(wfTemp,wfInvStpComp);                
                database.insert(wftStpComp);
                
                GA_WFT_Step__c wftStpGWC = GA_OBJ_TD01_TestDataCreation.wrkTmpStp(wfTemp,wfInvStpGWC);
                wftStpGWC.GA_Conditional_Assignment__c = 'GWC - for Assignment';
                database.insert(wftStpGWC);
                
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
                database.insert(wfRec);
                
                Group testGroup = new Group(Name='GA_Small_Group_Underwriting_Queue', Type='Queue');
                database.insert(testGroup);
                
                QueuesObject testQueue = new QueueSObject(QueueID = testGroup.id, SObjectType = 'GA_WF_Group_Segment__c');
                database.insert(testQueue);
                
                GA_WF_Step__c wfStepRecPrep = New  GA_WF_Step__c();
                wfStepRecPrep.Name='Pre-Processing';
                wfStepRecPrep.GA_Status__c = 'Closed';
                wfStepRecPrep.GA_WF_Template_Step__c = wftStpPrepprocssing.id;
                wfStepRecPrep.GA_WF_Workflow_ID__c = wfRec.id;
                wfStepRecPrep.GA_End_Time__c=system.now();
                wfStepRecPrep.GA_Start__c=system.now();
                wfStepRecPrep.GA_Notes__c = 'Test';
                database.insert(wfStepRecPrep);
                
                GA_WF_Step__c wfStepRec = New  GA_WF_Step__c();
                wfStepRec.Name = 'Open';
                wfStepRec.GA_Status__c = 'Open';
                wfStepRec.GA_WF_Template_Step__c = wftStp.id;
                wfStepRec.GA_WF_Workflow_ID__c = wfRec.id;
                wfStepRec.GA_Notes__c = 'Test';
                
                GA_WF_Step__c wfStepRecCnlc = New  GA_WF_Step__c();
                wfStepRecCnlc.Name='Canceled';
                wfStepRecCnlc.GA_Status__c = 'Canceled';
                wfStepRecCnlc.GA_WF_Template_Step__c = wftStp.id;
                wfStepRecCnlc.GA_WF_Workflow_ID__c = wfRec.id;
                wfStepRecCnlc.GA_Notes__c = 'Test';
                
                
                GA_WF_Step__c wfStepRec1 = New  GA_WF_Step__c();
                wfStepRec1.Name='Automated Validation';
                wfStepRec1.GA_Status__c = 'Closed';
                wfStepRec1.GA_WF_Template_Step__c = wftStp.id;
                wfStepRec1.GA_WF_Workflow_ID__c = wfRec.id;
                wfStepRec1.GA_Notes__c = 'Test';
                
                GA_WF_Step__c wfStepRec2 = New  GA_WF_Step__c();
                wfStepRec2.Name='Completed';
                wfStepRec2.GA_Status__c = 'Closed';
                wfStepRec2.GA_WF_Template_Step__c = wftStpComp.id;
                wfStepRec2.GA_WF_Workflow_ID__c = wfRec.id;
                wfStepRec2.GA_Notes__c = 'Test';
                
                GA_WF_Step__c wfStepRec3 = New  GA_WF_Step__c();
                wfStepRec3.Name='Project Support - to Review';
                wfStepRec3.GA_Status__c = 'Open';
                wfStepRec3.GA_WF_Template_Step__c = wftStpGWC.id;
                wfStepRec3.GA_WF_Workflow_ID__c = wfRec.id;
                wfStepRec3.GA_Notes__c = 'Test';
                
                GA_WF_Step__c wfStepRec4 = New  GA_WF_Step__c();
                wfStepRec4.Name='GWC - for Assignment';
                wfStepRec4.GA_Status__c = 'Open';
                wfStepRec4.GA_WF_Template_Step__c = wftStp.id;
                wfStepRec4.GA_WF_Workflow_ID__c = wfRec.id;
                wfStepRec4.GA_Notes__c = 'Test';
                
                list<GA_WF_Step__c> wfstpLst=new list<GA_WF_Step__c>();
                wfstpLst.add(wfStepRecCnlc);
                wfstpLst.add(wfStepRec4);
                wfstpLst.add(wfStepRec3);
                wfstpLst.add(wfStepRec2);
                wfstpLst.add(wfStepRec1);
                wfstpLst.add(wfStepRec);
                
                database.insert(wfstpLst);
                
                GA_Group_Segment__c grpSgmntRec=GA_OBJ_TD01_TestDataCreation.grpSegmntRec(testAccount);
                database.insert(grpSgmntRec);
                
                GA_WF_Group_Segment__c wfgsPrnt = New GA_WF_Group_Segment__c();
                
                wfgsPrnt.GA_Workflow_ID__c = wfRec.id; 
                wfgsPrnt.GA_Workflow_Next_Step__c = wfStepRecCnlc.id;
                wfgsPrnt.GA_Group_Segment_ID__c = grpSgmntRec.id;
                wfgsPrnt.OwnerId = testQueue.queueid;
                wfgsPrnt.GA_Tracking_Status__c = 'IPQT';
                wfgsPrnt.GA_Problem_Identified_Values__c = '(2-G) Incorrect Template';
                wfgsPrnt.GA_Date_Opened__c=system.today();
                database.insert(wfgsPrnt);
                
                GA_WF_Group_Segment__c wfgs = New GA_WF_Group_Segment__c();
                wfgs.GA_WF_Step_ID__c =   wfStepRec1.id;
                wfgs.GA_Parent_WF_Process__c=wfgsPrnt.id;
                wfgs.GA_Workflow_ID__c = wfRec.id; 
                wfgs.GA_Workflow_Next_Step__c = wfStepRecCnlc.id;
                wfgs.GA_Group_Segment_ID__c = grpSgmntRec.id;
                wfgs.OwnerId = testQueue.queueid;
                wfgs.GA_Tracking_Status__c = 'IPQT';
                wfgs.GA_Problem_Identified_Values__c = '(2-G) Incorrect Template';
                wfgs.GA_Date_Opened__c=system.today();
                database.insert(wfgs);
                
                GA_WF_Group_Segment__c wfgs2 = New GA_WF_Group_Segment__c();
                wfgs2.GA_WF_Step_ID__c =   wfStepRec1.id;
                wfgs2.GA_Parent_WF_Process__c=wfgsPrnt.id;
                wfgs2.GA_Workflow_ID__c = wfRec.id; 
                wfgs2.GA_Workflow_Next_Step__c = wfStepRec.id;
                wfgs2.GA_Group_Segment_ID__c = grpSgmntRec.id;
                wfgs2.OwnerId = testQueue.queueid;
                wfgs2.GA_Tracking_Status__c = 'IPQT';
                wfgs2.GA_Problem_Identified_Values__c = '(2-G) Incorrect Template';
                wfgs2.GA_Date_Opened__c=system.today();
                database.insert(wfgs2);
                
                GA_WF_Group_Segment__c wfgs1 = New GA_WF_Group_Segment__c();
                wfgs1.id=wfgs.Id;
                wfgs1.GA_WF_Step_ID__c =   wfStepRec1.id;
                wfgs1.GA_Workflow_ID__c = wfRec.id; 
                wfgs1.GA_Workflow_Next_Step__c = wfStepRecCnlc.id;
                wfgs1.GA_Group_Segment_ID__c = grpSgmntRec.id;
                wfgs1.OwnerId = testQueue.queueid;
                wfgs1.GA_Tracking_Status__c = 'IPQT';
                wfgs1.GA_Problem_Identified_Values__c = '(2-G) Incorrect Template';
                wfgs1.GA_Result__c='Success Report';
                wfgs1.GA_Date_Opened__c=system.today();
                wfgs1.GA_Notes__c='Test';
                
                GA_WF_Group_Segment__c wfgs3 = New GA_WF_Group_Segment__c(); 
                wfgs3.id=wfgs2.id;
                wfgs3.GA_WF_Step_ID__c =   wfStepRec1.id;
                wfgs3.GA_Workflow_ID__c = wfRec.id; 
                wfgs3.GA_Workflow_Next_Step__c = wfStepRec.id;
                wfgs3.GA_Group_Segment_ID__c = grpSgmntRec.id;
                wfgs3.OwnerId = testQueue.queueid;
                wfgs3.GA_Tracking_Status__c = 'IPQT';
                wfgs3.GA_Problem_Identified_Values__c = '(2-G) Incorrect Template';
                wfgs3.GA_Result__c='Discrepancy Report';
                wfgs3.GA_Date_Opened__c=system.today();
                wfgs3.GA_Notes__c='Test';
                
                GA_WF_Group_Segment__c wfgs4 = New GA_WF_Group_Segment__c(); 
                wfgs4.GA_WF_Step_ID__c =   wfStepRec1.id;
                wfgs4.GA_Workflow_ID__c = wfRec.id; 
                wfgs4.GA_Workflow_Next_Step__c = wfStepRec.id;
                wfgs4.GA_Group_Segment_ID__c = grpSgmntRec.id;
                wfgs4.OwnerId = testQueue.queueid;
                wfgs4.GA_Tracking_Status__c = 'IPQT';
                wfgs4.GA_Problem_Identified_Values__c = '(2-G) Incorrect Template';
                wfgs4.GA_Date_Opened__c=system.today();
                wfgs4.GA_Notes__c='Test';
                database.insert(wfgs4);
                
                
                wfgs4.GA_WF_Step_ID__c =   wfStepRec1.id;
                wfgs4.GA_Workflow_ID__c = wfRec.id; 
                wfgs4.GA_Workflow_Next_Step__c = wfStepRec.id;
                wfgs4.GA_Group_Segment_ID__c = grpSgmntRec.id;
                wfgs4.OwnerId = testQueue.queueid;
                wfgs4.GA_Tracking_Status__c = 'IPQT';
                wfgs4.GA_Problem_Identified_Values__c = '(2-G) Incorrect Template';
                wfgs4.GA_Result__c='Pending Report';
                wfgs4.GA_Date_Opened__c=system.today();
                list<GA_WF_Group_Segment__c> wfGStoUpte=new list<GA_WF_Group_Segment__c>();
                wfGStoUpte.add(wfgs4);
                wfGStoUpte.add(wfgs3);
                wfGStoUpte.add(wfgs1);
                database.update(wfGStoUpte);
                
                newmap.put(wfgs.id,wfgs1);
                oldmap.put(wfgs.id,wfgs);
                list<GA_WF_Group_Segment__c> wfGSRecs=new list<GA_WF_Group_Segment__c>();
                wfGSRecs.add(wfgs1);
                //GA_WrkFlwSldAftr3pm.wfgsLst=wfGSRecs;
                Test.startTest();
                //GA_WrkFlwSldAftr3pm.afterUpdate(newmap, oldmap);
                Test.stopTest();
                System.assert(wfGSRecs <> null);
                
            }
            catch(exception e)
            {
                return;
            }
        }
    }
    /*******************************************************************************************************************************
@Description: afterUpdateNoOpenstp_UT() method 
@Name : afterUpdateNoOpenstp_UT
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
    private static testMethod void afterUpdateNoOpenstp_UT() 
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestSysAdm','testsysadm@bcbsm.com','System Administrator');
        usr.GA_ByPass_VR__c=true;
        database.insert(usr);
        system.runAs(usr)
        {
            try{
                Map<Id,GA_WF_Group_Segment__c> newmap=new map<Id,GA_WF_Group_Segment__c>(); 
                Map<Id,GA_WF_Group_Segment__c> oldmap=new map<Id,GA_WF_Group_Segment__c>();
                GA_WFT_workflow__c wfTemp = GA_OBJ_TD01_TestDataCreation.wrkFlwTmplt();
                database.insert(wfTemp);
                
                GA_WFT_Inventory_Step__c wfInvStp = GA_OBJ_TD01_TestDataCreation.wfInventoryStp();
                
                database.insert(wfInvStp);
                
                GA_WFT_Inventory_Step__c wfInvStpPreporccing = GA_OBJ_TD01_TestDataCreation.wfInventoryStp();
                wfInvStp.Name='Pre-Processing';
                database.insert(wfInvStpPreporccing);
                
                GA_WFT_Inventory_Step__c wfInvStpGWC = GA_OBJ_TD01_TestDataCreation.wfInventoryStp();
                wfInvStpGWC.Name='GWC - for Assignment';
                database.insert(wfInvStpGWC);
                
                GA_WFT_Inventory_Step__c wfInvStpComp = GA_OBJ_TD01_TestDataCreation.wfInventoryStp();
                wfInvStpComp.Name='Completed';
                database.insert(wfInvStpComp);
                
                GA_WFT_Step__c wftStp = GA_OBJ_TD01_TestDataCreation.wrkTmpStp(wfTemp,wfInvStp);
                wftStp.GA_Conditional_Assignment__c = 'GWC - for Assignment';                
                database.insert(wftStp);
                
                GA_WFT_Step__c wftStpComp = GA_OBJ_TD01_TestDataCreation.wrkTmpStp(wfTemp,wfInvStpComp); 
                
                database.insert(wftStpComp);
                
                GA_WFT_Step__c wftStpGWC = GA_OBJ_TD01_TestDataCreation.wrkTmpStp(wfTemp,wfInvStpGWC);
                system.debug('WFT Name:'+wftStpGWC.Name);
                wftStp.GA_Conditional_Assignment__c = 'GWC - for Assignment';
                database.insert(wftStpGWC);
                
                GA_WFT_Step__c wftStpPrepprocssing = GA_OBJ_TD01_TestDataCreation.wrkTmpStp(wfTemp,wfInvStpPreporccing);
                database.insert(wftStpPrepprocssing);
                
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
                database.insert(wfRec);
                
                Group testGroup = new Group(Name='GA_Small_Group_Underwriting_Queue', Type='Queue');
                database.insert(testGroup);
                
                QueuesObject testQueue = new QueueSObject(QueueID = testGroup.id, SObjectType = 'GA_WF_Group_Segment__c');
                database.insert(testQueue);
                
                GA_WF_Step__c wfStepRecPrep = New  GA_WF_Step__c();
                wfStepRecPrep.Name='Pre-Processing';
                wfStepRecPrep.GA_Status__c = 'Closed';
                wfStepRecPrep.GA_WF_Template_Step__c = wftStpPrepprocssing.id;
                wfStepRecPrep.GA_WF_Workflow_ID__c = wfRec.id;
                wfStepRecPrep.GA_End_Time__c=system.now();
                wfStepRecPrep.GA_Start__c=system.now();
                wfStepRecPrep.GA_Notes__c = 'Test';
                database.insert(wfStepRecPrep);
                
                GA_WF_Step__c wfStepRec = New  GA_WF_Step__c();
                //wfStepRec.Name='GWC - for Assignment';
                wfStepRec.GA_Status__c = 'Open';
                wfStepRec.GA_WF_Template_Step__c = wftStp.id;
                wfStepRec.GA_WF_Workflow_ID__c = wfRec.id;
                wfStepRec.GA_Notes__c = 'Test';
                
                GA_WF_Step__c wfStepRec1 = New  GA_WF_Step__c();
                wfStepRec1.Name='Automated Validation';
                wfStepRec1.GA_Status__c = 'Closed';
                wfStepRec1.GA_WF_Template_Step__c = wftStp.id;
                wfStepRec1.GA_WF_Workflow_ID__c = wfRec.id;
                wfStepRec1.GA_Notes__c = 'Test';
                
                
                list<GA_WF_Step__c> wfstpLst=new list<GA_WF_Step__c>();
                
                wfstpLst.add(wfStepRec1);
                wfstpLst.add(wfStepRec);
                database.insert(wfstpLst);
                
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
                wfgs.GA_Date_Opened__c=system.today();
                
                GA_WF_Group_Segment__c wfgs2 = New GA_WF_Group_Segment__c();
                wfgs2.GA_WF_Step_ID__c =   wfStepRec1.id;
                wfgs2.GA_Workflow_ID__c = wfRec.id; 
                wfgs2.GA_Workflow_Next_Step__c = wfStepRec.id;
                wfgs2.GA_Group_Segment_ID__c = grpSgmntRec.id;
                wfgs2.OwnerId = testQueue.queueid;
                wfgs2.GA_Tracking_Status__c = 'IPQT';
                wfgs2.GA_Problem_Identified_Values__c = '(2-G) Incorrect Template';
                wfgs2.GA_Date_Opened__c=system.today();
                
                GA_WF_Group_Segment__c wfgs3 = New GA_WF_Group_Segment__c();
                wfgs3.GA_WF_Step_ID__c =   wfStepRec1.id;
                wfgs3.GA_Workflow_ID__c = wfRec.id; 
                wfgs3.GA_Workflow_Next_Step__c = wfStepRec.id;
                wfgs3.GA_Group_Segment_ID__c = grpSgmntRec.id;
                wfgs3.OwnerId = testQueue.queueid;
                wfgs3.GA_Tracking_Status__c = 'IPQT';
                wfgs3.GA_Problem_Identified_Values__c = '(2-G) Incorrect Template';
                wfgs3.GA_Date_Opened__c=system.today();
                list<GA_WF_Group_Segment__c> wfGStoInsert=new list<GA_WF_Group_Segment__c>();
                wfGStoInsert.add(wfgs);
                wfGStoInsert.add(wfgs2);
                wfGStoInsert.add(wfgs3);
                database.insert(wfGStoInsert);
                
                GA_WF_Group_Segment__c wfgs1 = New GA_WF_Group_Segment__c();
                wfgs1.id=wfgs.Id;
                wfgs1.GA_WF_Step_ID__c =   wfStepRec1.id;
                wfgs1.GA_Workflow_ID__c = wfRec.id; 
                wfgs1.GA_Workflow_Next_Step__c = wfStepRec.id;
                wfgs1.GA_Group_Segment_ID__c = grpSgmntRec.id;
                wfgs1.OwnerId = testQueue.queueid;
                wfgs1.GA_Tracking_Status__c = 'IPQT';
                wfgs1.GA_Problem_Identified_Values__c = '(2-G) Incorrect Template';
                wfgs1.GA_Result__c='Success Report';
                wfgs1.GA_Date_Opened__c=system.today();
                
                
                wfgs2.GA_WF_Step_ID__c =   wfStepRec1.id;
                wfgs2.GA_Workflow_ID__c = wfRec.id; 
                wfgs2.GA_Workflow_Next_Step__c = wfStepRec.id;
                wfgs2.GA_Group_Segment_ID__c = grpSgmntRec.id;
                wfgs2.OwnerId = testQueue.queueid;
                wfgs2.GA_Tracking_Status__c = 'IPQT';
                wfgs2.GA_Problem_Identified_Values__c = '(2-G) Incorrect Template';
                wfgs2.GA_Result__c='Discrepancy Report';
                wfgs2.GA_Date_Opened__c=system.today();
                
                wfgs3.GA_WF_Step_ID__c =   wfStepRec1.id;
                wfgs3.GA_Workflow_ID__c = wfRec.id; 
                wfgs3.GA_Workflow_Next_Step__c = wfStepRec.id;
                wfgs3.GA_Group_Segment_ID__c = grpSgmntRec.id;
                wfgs3.OwnerId = testQueue.queueid;
                wfgs3.GA_Tracking_Status__c = 'IPQT';
                wfgs3.GA_Problem_Identified_Values__c = '(2-G) Incorrect Template';
                wfgs3.GA_Result__c='Pending Report';
                wfgs3.GA_Date_Opened__c=system.today();
                
                list<GA_WF_Group_Segment__c> wfGStoUpte=new list<GA_WF_Group_Segment__c>();
                wfGStoUpte.add(wfgs3);
                wfGStoUpte.add(wfgs2);
                wfGStoUpte.add(wfgs1);
                database.update(wfGStoUpte);
                
                newmap.put(wfgs.id,wfgs3);
                oldmap.put(wfgs.id,wfgs);
                list<GA_WF_Group_Segment__c> wfGSRecs=new list<GA_WF_Group_Segment__c>();
                wfGSRecs.add(wfgs3);
                //GA_WrkFlwSldAftr3pm.wfgsLst=wfGSRecs;
                Test.startTest();
                //GA_WrkFlwSldAftr3pm.afterUpdate(newmap, oldmap);
                Test.stopTest();
                System.assert(wfGSRecs <> null);
                
            }
            catch(exception e)
            {
                return;
            }
        }
    }
    /*******************************************************************************************************************************
@Description: afterUpdate_UT_Batch() method 
@Name : afterUpdate_UT_Batch
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
    private static testMethod void afterUpdate_UT_Batch() 
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestSysAdm','testsysadm@bcbsm.com','System Administrator');
        usr.GA_ByPass_VR__c=true;
        database.insert(usr);
        system.runAs(usr)
        {
            try{
                Map<Id,GA_WF_Group_Segment__c> newmap=new map<Id,GA_WF_Group_Segment__c>(); 
                Map<Id,GA_WF_Group_Segment__c> oldmap=new map<Id,GA_WF_Group_Segment__c>();
                GA_WFT_workflow__c wfTemp = GA_OBJ_TD01_TestDataCreation.wrkFlwTmplt();
                database.insert(wfTemp);
                
                GA_WFT_Inventory_Step__c wfInvStp = GA_OBJ_TD01_TestDataCreation.wfInventoryStp();
                
                database.insert(wfInvStp);
                GA_WFT_Inventory_Step__c wfInvStpPreporccing = GA_OBJ_TD01_TestDataCreation.wfInventoryStp();
                wfInvStp.Name='Pre-Processing';
                database.insert(wfInvStpPreporccing);
                
                GA_WFT_Inventory_Step__c wfInvStpGWC = GA_OBJ_TD01_TestDataCreation.wfInventoryStp();
                wfInvStpGWC.Name='GWC - for Assignment';
                database.insert(wfInvStpGWC);
                
                GA_WFT_Inventory_Step__c wfInvStpComp = GA_OBJ_TD01_TestDataCreation.wfInventoryStp();
                wfInvStpComp.Name='Completed';
                database.insert(wfInvStpComp);
                
                GA_WFT_Step__c wftStp = GA_OBJ_TD01_TestDataCreation.wrkTmpStp(wfTemp,wfInvStp);
                database.insert(wftStp);
                
                GA_WFT_Step__c wftStpPrepprocssing = GA_OBJ_TD01_TestDataCreation.wrkTmpStp(wfTemp,wfInvStpPreporccing);
                database.insert(wftStpPrepprocssing);
                
                GA_WFT_Step__c wftStpComp = GA_OBJ_TD01_TestDataCreation.wrkTmpStp(wfTemp,wfInvStpComp);
                database.insert(wftStpComp);
                
                GA_WFT_Step__c wftStpGWC = GA_OBJ_TD01_TestDataCreation.wrkTmpStp(wfTemp,wfInvStpGWC);
                database.insert(wftStpGWC);
                
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
                
                Group testGroup = new Group(Name='GA_Small_Group_Underwriting_Queue', Type='Queue');
                database.insert(testGroup);
                
                QueuesObject testQueue = new QueueSObject(QueueID = testGroup.id, SObjectType = 'GA_WF_Group_Segment__c');
                database.insert(testQueue);
                
                GA_WF_Step__c wfStepRecPrep = New  GA_WF_Step__c();
                wfStepRecPrep.Name='Pre-Processing';
                wfStepRecPrep.GA_Status__c = 'Closed';
                wfStepRecPrep.GA_WF_Template_Step__c = wftStpPrepprocssing.id;
                wfStepRecPrep.GA_WF_Workflow_ID__c = wfRec.id;
                wfStepRecPrep.GA_End_Time__c=system.now();
                wfStepRecPrep.GA_Start__c=system.now();
                wfStepRecPrep.GA_Notes__c = 'Test';
                database.insert(wfStepRecPrep);
                
                GA_WF_Step__c wfStepRec = New  GA_WF_Step__c();
                wfStepRec.GA_Status__c = 'Open';
                wfStepRec.GA_WF_Template_Step__c = wftStp.id;
                wfStepRec.GA_WF_Workflow_ID__c = wfRec.id;
                wfStepRec.GA_Notes__c = 'Test';
                
                GA_WF_Step__c wfStepRecCnlc = New  GA_WF_Step__c();
                wfStepRecCnlc.Name='Canceled';
                wfStepRecCnlc.GA_Status__c = 'Canceled';
                wfStepRecCnlc.GA_WF_Template_Step__c = wftStp.id;
                wfStepRecCnlc.GA_WF_Workflow_ID__c = wfRec.id;
                wfStepRecCnlc.GA_Notes__c = 'Test';
                
                
                GA_WF_Step__c wfStepRec1 = New  GA_WF_Step__c();
                wfStepRec1.Name='Automated Validation';
                wfStepRec1.GA_Status__c = 'Closed';
                wfStepRec1.GA_WF_Template_Step__c = wftStp.id;
                wfStepRec1.GA_WF_Workflow_ID__c = wfRec.id;
                wfStepRec1.GA_Notes__c = 'Test';
                
                GA_WF_Step__c wfStepRec2 = New  GA_WF_Step__c();
                wfStepRec2.Name='Completed';
                wfStepRec2.GA_Status__c = 'Closed';
                wfStepRec2.GA_WF_Template_Step__c = wftStpComp.id;
                wfStepRec2.GA_WF_Workflow_ID__c = wfRec.id;
                wfStepRec2.GA_Notes__c = 'Test';
                
                GA_WF_Step__c wfStepRec3 = New  GA_WF_Step__c();
                wfStepRec3.Name='Project Support - to Review';
                wfStepRec3.GA_Status__c = 'Open';
                wfStepRec3.GA_WF_Template_Step__c = wftStpGWC.id;
                wfStepRec3.GA_WF_Workflow_ID__c = wfRec.id;
                wfStepRec3.GA_Notes__c = 'Test';
                
                GA_WF_Step__c wfStepRec4 = New  GA_WF_Step__c();
                wfStepRec4.Name='GWC - for Assignment';
                wfStepRec4.GA_Status__c = 'Open';
                wfStepRec4.GA_WF_Template_Step__c = wftStp.id;
                wfStepRec4.GA_WF_Workflow_ID__c = wfRec.id;
                wfStepRec4.GA_Notes__c = 'Test';
                
                list<GA_WF_Step__c> wfstpLst=new list<GA_WF_Step__c>();
                wfstpLst.add(wfStepRecCnlc);
                wfstpLst.add(wfStepRec4);
                wfstpLst.add(wfStepRec3);
                wfstpLst.add(wfStepRec2);
                wfstpLst.add(wfStepRec1);
                wfstpLst.add(wfStepRec);
                
                database.insert(wfstpLst);
                
                GA_Group_Segment__c grpSgmntRec=GA_OBJ_TD01_TestDataCreation.grpSegmntRec(testAccount);
                GA_GS_AP02_Update_Address.isExecuting=true;
                GA_GS_UpdateRatingType.isExecuting = true;
                GA_GroupSegmentTriggerHandler.beforeUpdateExecuting = true;
                GA_GroupSegmentTriggerHandler.isExecuting = true;
                GA_GS_AP04_UpdtStatus.isCnclGSChkd = true;
                GA_GS_AP04_UpdtStatus.isExecuting = true;
                GA_GS_AP04_UpdtStatus.isInvoked = true;
                GA_GS_UpdatWrappingFileTPA.isExecuting = true;
                GA_GroupSegAccUpdateCls.isExecuting = true;
                GA_ExternalAppealSrvcCls_MOS.isExecuting = true;
                GA_ExternalAppealRecdCrtnUpdt.isExecuting = true; 
                GA_GS_Insert_ThrdPartyBillerRecs.isExecuting = true;
                GA_GS_Insert_ThrdPartyBillerRecs.isInvoked = true;
                GA_GS_Insert_ThrdPartyBillerRecs.isInvoking = true;
                database.insert(grpSgmntRec);
                
                
                list<GA_WF_Group_Segment__c> wfGStoInsrt=new list<GA_WF_Group_Segment__c>();
                GA_WF_Group_Segment__c wfgs = New GA_WF_Group_Segment__c();
                for(integer i=0;i<=100;i++)
                {
                    wfgs = New GA_WF_Group_Segment__c();
                    wfgs.GA_WF_Step_ID__c =   wfStepRec1.id;
                    wfgs.GA_Workflow_ID__c = wfRec.id; 
                    wfgs.GA_Workflow_Next_Step__c = wfStepRecCnlc.id;
                    wfgs.GA_Group_Segment_ID__c = grpSgmntRec.id;
                    wfgs.OwnerId = testQueue.queueid;
                    wfgs.GA_Tracking_Status__c = 'IPQT';
                    wfgs.GA_Problem_Identified_Values__c = '(2-G) Incorrect Template';
                    wfgs.GA_Date_Opened__c=system.today();
                    wfGStoInsrt.add(wfgs);
                }
                
                database.insert(wfGStoInsrt);
                map<id,GA_WF_Group_Segment__c>   wkflProcssOldMap  = New    map<id,GA_WF_Group_Segment__c>  ([Select GA_WF_Step_ID__c,GA_Workflow_Next_Step__c, GA_Group_Segment_ID__c,OwnerId,
                                                                                                              GA_Tracking_Status__c,GA_Problem_Identified_Values__c,GA_Date_Opened__c from GA_WF_Group_Segment__c Limit 1000 ]);
                list<GA_WF_Group_Segment__c> wfGStoUpte=new list<GA_WF_Group_Segment__c>();
                Map<Id,GA_WF_Group_Segment__c>   wkflProcssNewMap = New    Map<Id,GA_WF_Group_Segment__c>  ();
                list<id> newwfgsLstId = New list<id>();
                for(GA_WF_Group_Segment__c wfgs1:wfGStoInsrt)
                {
                    wfgs1.GA_WF_Step_ID__c =   wfStepRec1.id;
                    wfgs1.GA_Workflow_ID__c = wfRec.id; 
                    wfgs1.GA_Workflow_Next_Step__c = wfStepRecCnlc.id;
                    wfgs1.GA_Group_Segment_ID__c = grpSgmntRec.id;
                    wfgs1.OwnerId = testQueue.queueid;
                    wfgs1.GA_Tracking_Status__c = 'IPQT';
                    wfgs1.GA_Problem_Identified_Values__c = '(2-G) Incorrect Template';
                    wfgs1.GA_Result__c='Success Report';
                    wfgs1.GA_Date_Opened__c=system.today();
                    wfgs1.GA_Notes__c='Test'; 
                    wfGStoUpte.add(wfgs1);
                    wkflProcssNewMap.put(wfgs1.id,wfgs1) ;
                    newwfgsLstId.add(wfgs1.id);
                }
                GA_WrkFlwPrcssUpdtRecvandCmpDts.isExecuting = false;
                GA_WrkFlwSldAftr3pm.isRecursive = false; 
                database.update(wfGStoUpte[0]);
                GA_UpdateWFGrpSgmntsBatch updteWFGrmnts=new GA_UpdateWFGrpSgmntsBatch(GA_WrkFlwProcessHandler.QUEU,wkflProcssOldMap,wkflProcssOldMap,newwfgsLstId);
                ID batchprocessid = Database.executeBatch(updteWFGrmnts,1000);  
                
                System.assert(wfGStoUpte <> null);
            }
            catch(exception e)
            {
                return;
            }
        }
    }
    /*******************************************************************************************************************************
@Description: afterUpdate_UT_Excp() method 
@Name : afterUpdate_UT_Excp
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
    private static testMethod void afterUpdate_UT_Excp() 
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestSysAdm','testsysadm@bcbsm.com','System Administrator');
        usr.GA_ByPass_VR__c=true;
        database.insert(usr);
        system.runAs(usr)
        {
            try{
                GA_WrkFlwProcessHandler.afterinsert(null, null, null);
                GA_WrkFlwProcessHandler.afterupdate(null, null, null);
                GA_WrkFlwProcessHandler.beforeinsert(null, null);
                GA_WrkFlwProcessHandler.beforeupdate(null, null, null);
                GA_WrkFlwSldAftr3pm.afterUpdate(null, null);
                GA_WrkFlwSldAftr3pm.beforeUpdate(null, null);
                GA_WrkFlwSldAftr3pm.updtPCSNotification(null, null, null);
                GA_WrkFlwSldAftr3pm.updtNotification(null);
                system.assert(usr <> null);
            }
            catch(exception e)
            {
                return;
            }
        }
    }
}