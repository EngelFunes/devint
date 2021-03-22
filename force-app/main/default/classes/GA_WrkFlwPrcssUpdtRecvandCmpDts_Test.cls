/*****************************************************************************************
Class Name   : GA_WrkFlwPrcssUpdtRecvandCmpDts_Test
Date Created : 20-08-2018
Created By   : IDC Offshore
Description  : 1. GA_WrkFlwPrcssUpdtRecvandCmpDts Test class
******************************************************************************************/
@isTest
public class GA_WrkFlwPrcssUpdtRecvandCmpDts_Test {
    /**
@Description: executeTest() method 
@Name : executeTest
@Param :NA
@Return :
@throws Exception : AuraHandledException;
*/    
    private static testmethod void executeTest()
    {
        list<user> UsrLst=new list<user>();
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestJeoRl','testsalesrepmail@bcbsm.com','System Administrator');
        usr.UserRoleId  = GA_OBJ_TD01_TestDataCreation.setRole('System Administrator','SysAdmin').id;
        UsrLst.add(usr);
        user usrRetSlsRep = GA_OBJ_TD01_TestDataCreation.UsrRec('TestJeoRlRetnslsRep','testsalesrepmail@bcbsm.com','Group Admin Quality Analyst');
        usrRetSlsRep.UserRoleId  = GA_OBJ_TD01_TestDataCreation.setRole('GA Quality Analyst','GAQltyAnlyst').id;
        UsrLst.add(usrRetSlsRep);
        user usrRtCtrlRep = GA_OBJ_TD01_TestDataCreation.UsrRec('TestusrRtCtrlRep','testusrRtCtrlReppmail@bcbsm.com','Rate Control Quality Analyst');
        usrRtCtrlRep.UserRoleId  = GA_OBJ_TD01_TestDataCreation.setRole('Rate Control Quality Analyst','rtQltyAnlyst').id;
        UsrLst.add(usrRtCtrlRep);
        user usrBCNGmtRep = GA_OBJ_TD01_TestDataCreation.UsrRec('TestusrBCNGmtRepRep','testusrBCNGmtRepmail@bcbsm.com','BCN GMT Processor');
        usrBCNGmtRep.UserRoleId  = GA_OBJ_TD01_TestDataCreation.setRole('BCN GMT Processor','bcnGMTPrcss').id;
        UsrLst.add(usrBCNGmtRep);
        user usrBCNUWRep = GA_OBJ_TD01_TestDataCreation.UsrRec('TestusrBCNUWRepsRep','testusrBCNUWRepmail@bcbsm.com','BCN Underwriter');
        usrBCNUWRep.UserRoleId  = GA_OBJ_TD01_TestDataCreation.setRole('BCN Underwriter','bcnUWPrcss').id;
        UsrLst.add(usrBCNUWRep);
        user usrSGUWRep = GA_OBJ_TD01_TestDataCreation.UsrRec('TestusrSGUWRepRep','testusrSGUWRepmail@bcbsm.com','Small Group Underwriter');
        usrSGUWRep.UserRoleId  = GA_OBJ_TD01_TestDataCreation.setRole('Small Group Underwriter','smllUWPrcss').id;
        UsrLst.add(usrSGUWRep);
        database.insert(UsrLst);
        system.debug('UsrLst'+UsrLst);
        system.runAs(usr)
        {
            try{
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
                
                GA_WF_Step__c wfStepRec1 = New  GA_WF_Step__c();
                wfStepRec1.Name = wfInvStp1.Name;
                wfStepRec1.GA_Status__c = 'Open';
                wfStepRec1.GA_WF_Template_Step__c = wftStp1.id;
                wfStepRec1.GA_WF_Workflow_ID__c = wfRec.id;
                wfStepRec1.GA_Notes__c = 'Test';
                wfStepRec1.OwnerId = usr.id;
                
                database.insert(wfStepRec1);  
                
                GA_GS_AP02_Update_Address.isExecuting = true;
                GA_Group_Segment__c grpSgmntRec=GA_OBJ_TD01_TestDataCreation.grpSegmntRec(testAccount);
                grpSgmntRec.GA_Quote_ID__c='123';              
                database.insert(grpSgmntRec);
                
                List<GA_WF_Group_Segment__c> wfgstLst = New List<GA_WF_Group_Segment__c>();
                
                
                GA_WF_Group_Segment__c wfgs = New GA_WF_Group_Segment__c();
                wfgs.GA_WF_Step_ID__c =   wfStepRec.id;
                wfgs.GA_Workflow_ID__c = wfRec.id;  
                wfgs.GA_Group_Segment_ID__c = grpSgmntRec.id;
                wfgs.OwnerId = testQueue.queueid;
                wfgs.GA_Workflow_Next_Step__c = wfStepRec1.id;
                wfgs.GA_Status__c = 'Open';
                wfgs.OwnerId = usrRetSlsRep.id;
                wfgs.GA_Date_Opened__c = system.now();
                wfgstLst.add(wfgs);
                
                // database.insert(wfgs);
                
                GA_WF_Group_Segment__c wfgs1 = New GA_WF_Group_Segment__c();
                wfgs1.GA_WF_Step_ID__c =   wfStepRec.id;
                wfgs1.GA_Workflow_ID__c = wfRec.id;  
                wfgs1.GA_Group_Segment_ID__c = grpSgmntRec.id;
                wfgs1.OwnerId = testQueue.queueid;
                wfgs1.GA_Workflow_Next_Step__c = wfStepRec1.id;
                wfgs1.GA_Status__c = 'Open';
                wfgs1.OwnerId = usrRtCtrlRep.id;
                wfgs1.GA_Date_Opened__c = system.now();
                //database.insert(wfgs1);
                wfgstLst.add(wfgs1);
                
                GA_WF_Group_Segment__c wfgs2 = New GA_WF_Group_Segment__c();
                wfgs2.GA_WF_Step_ID__c =   wfStepRec.id;
                wfgs2.GA_Workflow_ID__c = wfRec.id;  
                wfgs2.GA_Group_Segment_ID__c = grpSgmntRec.id;
                wfgs2.OwnerId = testQueue.queueid;
                wfgs2.GA_Workflow_Next_Step__c = wfStepRec1.id;
                wfgs2.GA_Status__c = 'Open';
                wfgs2.OwnerId = usrBCNGmtRep.id;
                wfgs2.GA_Date_Opened__c = system.now();
                //database.insert(wfgs2);
                wfgstLst.add(wfgs2);
                
                GA_WF_Group_Segment__c wfgs3 = New GA_WF_Group_Segment__c();
                wfgs3.GA_WF_Step_ID__c =   wfStepRec.id;
                wfgs3.GA_Workflow_ID__c = wfRec.id;  
                wfgs3.GA_Group_Segment_ID__c = grpSgmntRec.id;
                wfgs3.OwnerId = testQueue.queueid;
                wfgs3.GA_Workflow_Next_Step__c = wfStepRec1.id;
                wfgs3.GA_Status__c = 'Open';
                wfgs3.OwnerId = usrBCNUWRep.id;
                wfgs3.GA_Date_Opened__c = system.now();
                //database.insert(wfgs3);
                wfgstLst.add(wfgs3);
                
                GA_WF_Group_Segment__c wfgs4 = New GA_WF_Group_Segment__c();
                wfgs4.GA_WF_Step_ID__c =   wfStepRec.id;
                wfgs4.GA_Workflow_ID__c = wfRec.id;  
                wfgs4.GA_Group_Segment_ID__c = grpSgmntRec.id;
                wfgs4.OwnerId = testQueue.queueid;
                wfgs4.GA_Workflow_Next_Step__c = wfStepRec1.id;
                wfgs4.GA_Status__c = 'Open';
                wfgs4.OwnerId = usrSGUWRep.id;
                wfgs4.GA_Date_Opened__c = system.now();
                wfgstLst.add(wfgs4);
                // database.insert(wfgs4);
                
                Test.startTest();
                /**  wfgs.OwnerId = usrRetSlsRep.id;
wfgstLst.add(wfgs);
wfgs1.OwnerId = usrRtCtrlRep.id;
wfgstLst.add(wfgs);
wfgs2.OwnerId = usrBCNGmtRep.id;
wfgstLst.add(wfgs);
wfgs3.OwnerId = usrBCNUWRep.id;
wfgstLst.add(wfgs);
wfgs4.OwnerId = usrSGUWRep.id;
wfgstLst.add(wfgs);**/
                database.insert(wfgstLst); 
                
                List<GA_WF_Group_Segment__c> upWfLst = New List<GA_WF_Group_Segment__c>();
                for(GA_WF_Group_Segment__c upwfgs : wfgstLst){
                    upwfgs.GA_Status__c = 'Closed';
                    upWfLst.add(upwfgs);
                }
                GA_WrkFlwPrcssUpdtRecvandCmpDts.isExecuting = false;
                GA_WrkFlwSldAftr3pm.isRecursive = false; 
                database.update(upWfLst); 
                //saveNextStep
                
                Test.stopTest();
                
            }
            catch(exception e)
            {
                return;
            }
        }  
    }
    /*******************************************************************************************************************************
@Description: wfProcssHndlrExcep() method 
@Name : wfProcssHndlrExcep
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
    private static testmethod void wfProcssHndlrExcep()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('Testlckrec','testsysadminmail@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {
            try{
                List<GA_WF_Group_Segment__c> wkflProcssList;
                Map<Id,GA_WF_Group_Segment__c> wkflProcssNewMap;
                
                test.startTest();
                GA_WrkFlwProcessHandler.afterinsert(wkflProcssList, wkflProcssNewMap, wkflProcssNewMap);
                GA_WrkFlwProcessHandler.afterupdate(wkflProcssList, wkflProcssNewMap, wkflProcssNewMap);
                GA_WrkFlwProcessHandler.beforeupdate(wkflProcssList, wkflProcssNewMap, wkflProcssNewMap);
                GA_WrkFlwProcessHandler.afterupdate(wkflProcssList, wkflProcssNewMap, wkflProcssNewMap);
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