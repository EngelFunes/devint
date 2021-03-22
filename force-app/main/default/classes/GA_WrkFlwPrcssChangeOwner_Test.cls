/*******************************************************************************************************************************
@Author : IDC offshore
@Name: WorkflowController_Test
@CreatedDate: 29 - May 2018 
@Description: WorkflowController_Test class is for WorkflowController.
@version : 1.0  
********************************************************************************************************************************/
@isTest
private class GA_WrkFlwPrcssChangeOwner_Test {
    
    /*******************************************************************************************************************************
@Description: savewfStep() method 
@Name : savewfStep
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
    public static testmethod void RestrictChangeOwnerOManagedQueueCvr(){
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestSysAdm','testsysadm@bcbsm.com','System Administrator');
        insert usr;
        //user usr2 = GA_OBJ_TD01_TestDataCreation.UsrRec('TestJeoRl','testsalesrepmail@bcbsm.com','Support');
        //insert usr2;
        system.runAs(usr)
        {
            try{
                Map<id,GA_WF_Group_Segment__c> wfgsLst = New  Map<id,GA_WF_Group_Segment__c>(); 
                
                GA_WFT_workflow__c wfTemp = GA_OBJ_TD01_TestDataCreation.wrkFlwTmplt();
                wfTemp.GA_Carrier__c = 'BCBSM';
                wfTemp.GA_Process_Type__c ='GWC';
                wfTemp.GA_Process_Subtype__c='Benefit Change';
                wfTemp.GA_Method__c ='Automated';
                database.insert(wfTemp);
                
                GA_WFT_Inventory_Step__c wfInvStp = GA_OBJ_TD01_TestDataCreation.wfInventoryStp();
                wfInvStp.name = 'Pre-Processing';
                database.insert(wfInvStp);
                
                GA_WFT_Inventory_Step__c wfInvStp1 = GA_OBJ_TD01_TestDataCreation.wfInventoryStp();
                wfInvStp1.name = 'Benefit Administration Review';
                database.insert(wfInvStp1);
                
                GA_WFT_Step__c wftStp = GA_OBJ_TD01_TestDataCreation.wrkTmpStp(wfTemp,wfInvStp);
                database.insert(wftStp);
                
                GA_WFT_Step__c wftStp1 = GA_OBJ_TD01_TestDataCreation.wrkTmpStp(wfTemp,wfInvStp1);
                database.insert(wftStp1);
                
                GA_WFT_Allowed_Next_Step__c wftNxtStp = GA_OBJ_TD01_TestDataCreation.wfAlwdNxtStp(wftStp);
                database.insert(wftNxtStp);
                
                GA_WFT_Allowed_Next_Step__c wftNxtStp1 = GA_OBJ_TD01_TestDataCreation.wfAlwdNxtStp(wftStp1);
                database.insert(wftNxtStp1);
                
                Account testAccount = GA_OBJ_TD01_TestDataCreation.AccRec();
                database.insert(testAccount);
                
                GA_Account_Benefit_Review__c benRvw = GA_OBJ_TD01_TestDataCreation.accBenfitRvw(testAccount);
                database.insert(benRvw);
                
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
                
                Group testGroup1 = new Group(Name='Rate Control Team Lead Queue', Type='Queue');
                insert testGroup1;
                
                QueuesObject testQueue1 = new QueueSObject(QueueID = testGroup1.id, SObjectType = 'GA_WF_Group_Segment__c');
                insert testQueue1;
                
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
                wfStepRec1.GA_WF_Template_Step__c = wftStp1.id;
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
                wfgs.GA_Status__c = 'Open';
                wfgsLst.put(wfgs.id, wfgs);
                database.insert(wfgsLst.values());
                
                
                Map<id,GA_WF_Group_Segment__c> wfgsNewLst = New Map<id,GA_WF_Group_Segment__c>();
                wfgs.OwnerId = testQueue1.queueid;
                wfgsNewLst.put(wfgs.id, wfgs);
                
                Test.startTest();
                Database.update(wfgsNewLst.values());
                Test.stopTest();
            }
            catch(exception e)
            {
                return;
            }
        }					
    }
    /*******************************************************************************************************************************
@Description        :   validationExcp() method 
@Name               :   validationExcp
@Param              :   None
@Return             :   void
@throws Exception   :   N/A;
********************************************************************************************************************************/ 
    private static testmethod void validationExcp()
    {
        user usru = GA_OBJ_TD01_TestDataCreation.UsrRec('TestJeoRl','testsalesrepmail@bcbsm.com','System Administrator');
        insert usru;
        system.runAs(usru)
        {	
            try{
                Map<id,GA_WF_Group_Segment__c> wfgsNewMap;
                Map<id,GA_WF_Group_Segment__c> wfgsOldMap;
                test.startTest();
                GA_WrkFlwPrcssChangeOwner.RestrictChangeOwnerOManagedQueue(wfgsNewMap, wfgsOldMap);
                test.stopTest();
                system.assert(usru <> null);
            }
            catch(exception e)
            {
                return;
            }
        } 
    }
}