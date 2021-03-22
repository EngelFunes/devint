/*******************************************************************************************************************************
@Author : IDC offshore
@Name: GA_AP05_UpdateStpDtsOnWFGS_Test
@CreatedDate: 17 - April 2018 
@Description: GA_AP05_UpdateStpDtsOnWFGS_Test class is for GA_AP05_UpdateStpDtsOnWFGS.
@version : 1.0  
********************************************************************************************************************************/
@isTest
public class GA_AP05_UpdateStpDtsOnWFGS_Test {
    /*******************************************************************************************************************************
@Description: excuteWFhistory() method 
@Name : excuteWFhistory
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
    private static testMethod void updateWFGShistory() {
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
                wfStepRec.Name = wfInvStp.Name;
                wfStepRec.GA_Status__c = 'Open';
                wfStepRec.GA_WF_Template_Step__c = wftStp.id;
                wfStepRec.GA_WF_Workflow_ID__c = wfRec.id;
                wfStepRec.GA_Notes__c = 'Test';
                wfStepRec.OwnerId = usr.id;
                
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
                
                List<GA_WF_Group_Segment__c> wfgsLst = New List<GA_WF_Group_Segment__c>();
                wfgsLst.add(wfgs);
                
                Test.startTest();
                GA_AP05_UpdateStpDtsOnWFGS.updateWFGSdtls(wfStepRec);
                GA_AP05_UpdateStpDtsOnWFGS.checkGrpSgmtsOpen(wfStepRec.id);
                Test.stopTest();
            }
            catch(exception e)
            {
                return;
            }
        }					
    } 
    /*******************************************************************************************************************************
@Description: updateWFGShistoryExcption() method 
@Name : updateWFGShistoryExcption
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
    private static testMethod void updateWFGShistoryExcption() {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestSysAdm','testsysadm@bcbsm.com','System Administrator');
        insert usr;
        system.runAs(usr)
        {
            try{
                
                List<GA_WF_Group_Segment__c> wfgsList = New  List<GA_WF_Group_Segment__c>();
                GA_WF_Group_Segment__c wfgs;
                wfgsList.add(wfgs);
                
                Test.startTest();
                GA_AP05_UpdateStpDtsOnWFGS.updateWFGSdtls(null);
                GA_AP05_UpdateStpDtsOnWFGS.checkGrpSgmtsOpen(null);
                GA_Util15_WFGSDataAccesHelper.dmlOnWFGS(null, null);
                GA_Util15_WFGSDataAccesHelper.fetchwrkflwGrpSgmMap('', '', '', '');
                GA_WF_Group_Segment__c wfgs1 = New GA_WF_Group_Segment__c();
                insert wfgs1;
                List<GA_WF_Group_Segment__c> wfgsList1 = New  List<GA_WF_Group_Segment__c>();
                wfgsList1.add(wfgs1);
                GA_Util15_WFGSDataAccesHelper.dmlOnWFGS(wfgsList1, 'INSERT');
                GA_Util15_WFGSDataAccesHelper.dmlOnWFGS(wfgsList1, 'DELETE'); 
                GA_Util15_WFGSDataAccesHelper.dmlOnWFGS(wfgsList1, 'UPSERT');  
                
                
                Test.stopTest();
            }
            catch(exception e)
            {
                return;
            }
        }					
    }
}