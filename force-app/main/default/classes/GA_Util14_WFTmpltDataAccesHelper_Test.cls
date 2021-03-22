/*******************************************************************************************************************************
@Author : IDC offshore
@Name: GA_Util14_WFTmpltDataAccesHelper_Test
@CreatedDate: 17 - April 2018 
@Description: GA_Util14_WFTmpltDataAccesHelper_Test class is for GA_Util14_WFTmpltDataAccesHelper.
@version : 1.0  
********************************************************************************************************************************/
@isTest(seealldata = false)
private class GA_Util14_WFTmpltDataAccesHelper_Test {
    /*******************************************************************************************************************************
@Description: executeWfmethods() method 
@Name : executeWfmethods
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
    private static testMethod void executeWfmethods() {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestSysAdm','testsysadm@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {
            try{
                GA_WFT_workflow__c wfTemp = GA_OBJ_TD01_TestDataCreation.wrkFlwTmplt();
                wfTemp.GA_Carrier__c = 'BCBSM';
                wfTemp.GA_Process_Type__c ='GWC';
                wfTemp.GA_Process_Subtype__c='Benefit Change';
                wfTemp.GA_Method__c ='Automated';
                wfTemp.GA_File_Type__c='Rate Quote';
                database.insert(wfTemp);
                
                GA_WFT_Inventory_Step__c wfInvStp = GA_OBJ_TD01_TestDataCreation.wfInventoryStp();
                wfInvStp.name = 'Pre-Processing';
                database.insert(wfInvStp);
                
                GA_WFT_Inventory_Step__c wfInvStp1 = GA_OBJ_TD01_TestDataCreation.wfInventoryStp();
                wfInvStp1.name = 'Benefit Administration Review';
                database.insert(wfInvStp1);
                
                GA_WFT_Inventory_Step__c wfInvStp2 = GA_OBJ_TD01_TestDataCreation.wfInventoryStp();
                wfInvStp2.name = 'Completed';
                database.insert(wfInvStp2);
                
                GA_WFT_Step__c wftStp = GA_OBJ_TD01_TestDataCreation.wrkTmpStp(wfTemp,wfInvStp);
                wftStp.GA_First_Step__c=true;
                database.insert(wftStp);
                
                GA_WFT_Step__c wftStp1 = GA_OBJ_TD01_TestDataCreation.wrkTmpStp(wfTemp,wfInvStp1);
                database.insert(wftStp1);
                
                GA_WFT_Step__c wftStpCmp = GA_OBJ_TD01_TestDataCreation.wrkTmpStp(wfTemp,wfInvStp2);
                database.insert(wftStpCmp);
                
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
                
                ContentVersion contentVersion = new ContentVersion(
                    Title = 'TestCnt',
                    PathOnClient = 'fileTypeTest.jpg',
                    VersionData = Blob.valueOf('Test Content'),
                    GA_Type__c='Rate Quote',
                    IsMajorVersion = true
                );
                database.insert(contentVersion);    
                List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument Limit 100];
                
                //create ContentDocumentLink  record 
                ContentDocumentLink cdl = New ContentDocumentLink();
                cdl.LinkedEntityId = cas.id;
                cdl.ContentDocumentId = documents[0].Id;
                cdl.shareType = 'V';
                database.insert(cdl);
                
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
                wfStepRec1.GA_WF_Template_Step__c = wftStp1.id;
                wfStepRec1.GA_WF_Workflow_ID__c = wfRec.id;
                wfStepRec1.GA_Notes__c = 'Test';
                wfStepRec1.OwnerId = usr.id;
                
                database.insert(wfStepRec1);  
                
                GA_Group_Segment__c grpSgmntRec=GA_OBJ_TD01_TestDataCreation.grpSegmntRec(testAccount);
                grpSgmntRec.GA_Quote_ID__c='123';
                GA_Group_Segment__c grpSgmntRecClsd=GA_OBJ_TD01_TestDataCreation.grpSegmntRec(testAccount);
                grpSgmntRecClsd.GA_Quote_ID__c='123';
                grpSgmntRecClsd.status__c='Active';
                grpSgmntRecClsd.GA_In_Progress__c=true;
                
                list<GA_Group_Segment__c> grpSGmntLst=new list<GA_Group_Segment__c>();
                grpSGmntLst.add(grpSgmntRec);
                grpSGmntLst.add(grpSgmntRecClsd);
                database.insert(grpSGmntLst);
                
                GA_Plan_Package__c plnPkg=new GA_Plan_Package__c();
                plnPkg.Name='Test Pln';
                plnPkg.GA_Group_Segment__c=grpSGmntLst[0].Id;
                plnPkg.GA_ACTIVE_IND__c ='Active';
                database.insert(plnPkg);
                Asset sldPrd=new Asset();
                sldPrd.AccountId=testAccount.Id;
                sldPrd.GA_Plan_Package_Id__c=PlnPkg.Id;
                sldPrd.Name='Test Sld Prd';
                database.insert(sldPrd);
                GA_Certs_Riders__c crtRiders=new GA_Certs_Riders__c();
                crtRiders.Name='certRider Test';
                crtRiders.GA_AssetId__c=sldPrd.Id;
                database.insert(crtRiders);
                
                GA_WF_Group_Segment__c wfgs = New GA_WF_Group_Segment__c();
                wfgs.GA_WF_Step_ID__c =   wfStepRec.id;
                wfgs.GA_Workflow_ID__c = wfRec.id;  
                wfgs.GA_Group_Segment_ID__c = grpSgmntRec.id;
                wfgs.OwnerId = testQueue.queueid;
                wfgs.GA_Workflow_Next_Step__c = wfStepRec1.id;
                wfgs.GA_Status__c = 'Open';
                database.insert(wfgs);
                GA_WF_Group_Segment__c wfgs1 = New GA_WF_Group_Segment__c();
                wfgs1.GA_WF_Step_ID__c =   wfStepRec.id;
                wfgs1.GA_Workflow_ID__c = wfRec.id;  
                wfgs1.GA_Group_Segment_ID__c = grpSgmntRecClsd.id;
                wfgs1.OwnerId = testQueue.queueid;
                wfgs1.GA_Workflow_Next_Step__c = wfStepRec1.id;
                wfgs1.GA_Status__c = 'Open';
                database.insert(wfgs1);
                String wfGrpIds = '['+wfgs.id +']';
                
                List<String> grpIdLst = New List<String>();
                grpIdLst.add(wfgs.id);
                
                List<String> grpSgmntIdLst = New List<String>();
                List<String> grpSgmntIdLstClsd = New List<String>();
                grpSgmntIdLst.add(grpSgmntRec.id);
                grpSgmntIdLstClsd.add(grpSgmntRecClsd.Id);
                List<String> grpSgmntQutIdLst = New List<String>();
                grpSgmntQutIdLst.add(grpSgmntRec.GA_Quote_ID__c);
                
                List<GA_WF_Group_Segment__c> wfgsLst = New List<GA_WF_Group_Segment__c>();
                wfgsLst.add(wfgs);
                
                list<string> gsIdQte=new list<string>();
                gsIdQte.add(grpSgmntRec.id+'-1234');
                
                Test.startTest();
                WorkflowController.fetchSMARTInfo(testAccount.Id, 'Account');
                WorkflowController.fetchaccName(cas.id);
                WorkflowController.fetchaccNameABR(benRvw.id);
                WorkflowController.insertWfRecABR(testAccount.id, benRvw.id, 'BCBSM','GWC','Benefit Change', grpSgmntIdLst, 'Automated');
                //WorkflowController.insertWfRec(testAccount.id,cas.id,'BCBSM','GWC','Benefit Change', grpSgmntIdLst,'Automated',false,grpSgmntQutIdLst);
                WorkflowController.retrieveNextSteps(wfStepRec.id);
                WorkflowController.retrieveCurrentStepGroupSegments(wfStepRec.id);
                WorkflowController.retrieveCurrentStepGroupSegmentsInNextStep(wfStepRec.id);
                WorkflowController.nextStepQueueInfo(wfStepRec.id, wftStp1.id, 'Benefit Administration Review', null);
                WorkflowController.saveNextStep(wfStepRec.id, wftStp1.id, wftStp1.id, grpSgmntIdLst, usr.id,false,'test'); 
                WorkflowController.saveNextStep(wfStepRec.id, wftStpCmp.id, wftStpCmp.id, grpSgmntIdLst, usr.id,false,'test'); 
                WorkflowController.isPreprocessingStep(wfStepRec.id);
                
                WorkflowController.retrieveTypes('BCBSM');
                WorkflowController.retrieveSubTypes('BCBSM', 'GWC');
                WorkflowController.retrieveBenefitSelectionMethods('BCBSM','GWC','Benefit Change');
                GA_AP_01_WorkflowDetmntion.getreltedwfStep('GWC','Benefit Change','Automated','BCBSM');
                WorkflowController.fetchAccStatus(testAccount.Id, 'Account');
                WorkflowController.fetchAccStatus(cas.id, 'Case');
                WorkflowController.wfCreateAccssStpVls('New Business','Agent Sold Enrollment');
                //  WorkflowController.notifyUseAssigned(usr.Id,wfRec.Id);
                //WorkflowController.retrieveClosedGroupSegments(testAccount.Id, 'BCBSM', 'GWC');
                WorkflowController.processSelectedRecords(gsIdQte);
                
                //saveNextStep
                Test.stopTest();
                System.assert(gsIdQte <> null);
            }
            catch(exception e)
            {
                return;
            }
        }          
    }
    
    /*******************************************************************************************************************************
@Description: wfTmpltDataAcssHlprExcptn() method 
@Name : wfTmpltDataAcssHlprExcptn
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
    private static testMethod void wfTmpltDataAcssHlprExcptn() {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestSysAdm','testsysadm@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {
            try{
                Test.startTest();
                GA_Util14_WFTmpltDataAccesHelper.fetchwrkflowTmpsMap(null,null,null,null);
                Test.stopTest();
                System.assert(usr <> null);
            }
            catch(exception e)
            {
                return;
            }
        }          
    }
}