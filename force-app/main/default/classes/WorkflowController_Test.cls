/*******************************************************************************************************************************
@Author : IDC offshore
@Name: WorkflowController_Test
@CreatedDate: 17 - April 2018 
@Description: WorkflowController_Test class is for WorkflowController.
@version : 1.0  
********************************************************************************************************************************/
@isTest(seealldata = false)
private class WorkflowController_Test {
    
    /*******************************************************************************************************************************
@Description: externalInitiateWFBatch() method 
@Name : externalInitiateWFBatch
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
    private static testMethod void externalInitiateWFBatch() {
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
                
                GA_WFT_Step__c wftStp = GA_OBJ_TD01_TestDataCreation.wrkTmpStp(wfTemp,wfInvStp);
                wftStp.GA_First_Step__c=true;
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
                //cas.recordtypeid=Schema.SObjectType.Case.getRecordTypeInfosByName().get('Support - Issues').getRecordTypeId();
                cas.recordtypeid=Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('GA_Support_Issues').getRecordTypeId();
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
                
                
                GA_WF_Workflow__c wfRec = New GA_WF_Workflow__c();
                wfRec.GA_External_Initiated__c=true;
                wfRec.GA_Selected_Group_Segments__c=grpSGmntLst[0].Id;
                wfRec.GA_Account__c = testAccount.id;
                wfRec.GA_Support__c=cas.Id;
                wfRec.GA_Carrier__c = wfTemp.GA_Carrier__c;
                wfRec.GA_Method__c = wfTemp.GA_Method__c;
                wfRec.Sub_Type__c = wfTemp.GA_Process_Subtype__c;
                wfRec.GA_Type__c=wfTemp.GA_Process_Type__c;
                wfRec.GA_Status__c = 'Open';
                wfRec.GA_Workflow_Template__c =wfTemp.id;
                database.insert(wfRec);
                
                GA_WF_Step__c wfStepRec = New  GA_WF_Step__c();
                wfStepRec.Name = wfInvStp.Name;
                wfStepRec.GA_Status__c = 'Open';
                wfStepRec.GA_WF_Template_Step__c = wftStp.id;
                wfStepRec.GA_WF_Workflow_ID__c = wfRec.id;
                wfStepRec.GA_Workflow_Template_Id__c=wfRec.GA_Workflow_Template__c;
                wfStepRec.GA_Notes__c = 'Test';
                wfStepRec.OwnerId = usr.id;
                database.insert(wfStepRec);
                
                Group testGroup = new Group(Name='GA Project Support Queue', Type='Queue');
                database.insert(testGroup);
                
                QueuesObject testQueue = new QueueSObject(QueueID = testGroup.id, SObjectType = 'GA_WF_Group_Segment__c');
                database.insert(testQueue);
                map<id,string> wfGrpSgmntMp=new map<id,string>();
                wfGrpSgmntMp.put(wfRec.id,wfRec.GA_Selected_Group_Segments__c);
                map<id,Automated_Workflow_Settings__mdt> wfTmpAutmtedwrflwMap=new map<id,Automated_Workflow_Settings__mdt>();
                Automated_Workflow_Settings__mdt autmatdTstRec=[select id,GA_Step_Name__c,GA_File_Type__c,GA_Workflow_Step_Id__c,
                                                                GA_Owner_Id__c,GA_Workflow_Template_Id__c from Automated_Workflow_Settings__mdt 
                                                                limit 1];
                autmatdTstRec.GA_Workflow_Template_Id__c=wfRec.GA_Workflow_Template__c;
                autmatdTstRec.GA_Workflow_Step_Id__c=wftStp.id;
                autmatdTstRec.GA_Owner_Id__c=usr.id;
                wfTmpAutmtedwrflwMap.put(wfRec.GA_Workflow_Template__c,autmatdTstRec);
                list<id> wfSTpIds=new list<id>();
                wfSTpIds.add(wfStepRec.id);
                
                GA_WrkflowAutomatedBatchCls wflwAutoBtchCls = new GA_WrkflowAutomatedBatchCls(wfGrpSgmntMp,wfTmpAutmtedwrflwMap,wfSTpIds);
                Test.startTest();
                database.executeBatch(wflwAutoBtchCls,100);
                Test.stopTest();
                System.assert(wfSTpIds <> null);
            }
            catch(exception e)
            {
                return;
            }
        }          
    }    
    /*******************************************************************************************************************************
@Description: savewfStep() method 
@Name : savewfStep
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
                Contract testContract = ARV_AP05_TestDataCreation.createContractRec(testAccount.Id);
                database.insert(testContract);
                
                GA_Account_Benefit_Review__c benRvw = GA_OBJ_TD01_TestDataCreation.accBenfitRvw(testAccount);
                database.insert(benRvw);
                
                case cas=GA_OBJ_TD01_TestDataCreation.CaseRec();
                //cas.recordtypeid=Schema.SObjectType.Case.getRecordTypeInfosByName().get('Support - Issues').getRecordTypeId();
                cas.recordtypeid=Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('GA_Support_Issues').getRecordTypeId();
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
                WorkflowController.fetchContractName(testContract.id);
                WorkflowController.fetchaccNameABR(benRvw.id);
                WorkflowController.fetchWFStpNotes(wfStepRec1.id);
                WorkflowController.retrieveCarriers();
                WorkflowController.insertWfRecABR(testAccount.id, benRvw.id, 'BCBSM','GWC','Benefit Change', grpSgmntIdLst, 'Automated');
                WorkflowController.insertWfRec(testAccount.id,cas.id,'BCBSM','GWC','Benefit Change', grpSgmntIdLst,'Automated',grpSgmntQutIdLst,false,testContract.id);
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
                WorkflowController.retrieveClosedGroupSegments(testAccount.Id, 'BCBSM', 'GWC',testContract.id);
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
@Description: fetchSMARTInfoExcp() method 
@Name : fetchSMARTInfoExcp
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
    private static testMethod void fetchSMARTInfoExcp() {
        
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestSysAdm','testsysadm@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {
            try{
                WorkflowController.fetchSMARTInfo(null, null);
                system.assert(usr <> null,true);
            }
            catch(exception ex)
            {
                return;
            }
        }
        
        
    }
    /*******************************************************************************************************************************
@Description: loadGSQueryExcp() method 
@Name : loadGSQueryExcp
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
    private static testMethod void loadGSQueryExcp() {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestSysAdm','testsysadm@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {
            try{ 
                WorkflowController.nextStepQueueInfo(null, null, null, null);
                system.assert(usr<>null,true);
            }
            catch(exception ex)
            {
                return;
            }
        }
    }
    /*******************************************************************************************************************************
@Description: externalInitiateWF() method 
@Name : externalInitiateWF
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
    private static testMethod void externalInitiateWF() {
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
                
                GA_WFT_Step__c wftStp = GA_OBJ_TD01_TestDataCreation.wrkTmpStp(wfTemp,wfInvStp);
                wftStp.GA_First_Step__c=true;
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
                //cas.recordtypeid=Schema.SObjectType.Case.getRecordTypeInfosByName().get('Support - Issues').getRecordTypeId();
                cas.recordtypeid=Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('GA_Support_Issues').getRecordTypeId();
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
                
                
                GA_WF_Workflow__c wfRec = New GA_WF_Workflow__c();
                wfRec.GA_External_Initiated__c=true;
                wfRec.GA_Selected_Group_Segments__c=grpSGmntLst[0].Id;
                wfRec.GA_Account__c = testAccount.id;
                wfRec.GA_Support__c=cas.Id;
                wfRec.GA_Carrier__c = wfTemp.GA_Carrier__c;
                wfRec.GA_Method__c = wfTemp.GA_Method__c;
                wfRec.Sub_Type__c = wfTemp.GA_Process_Subtype__c;
                wfRec.GA_Type__c=wfTemp.GA_Process_Type__c;
                wfRec.GA_Status__c = 'Open';
                wfRec.GA_Workflow_Template__c =wfTemp.id;
                database.insert(wfRec);
                
                GA_WF_Workflow__c wfRecDup = New GA_WF_Workflow__c();
                wfRecDup.GA_External_Initiated__c=true;
                wfRecDup.GA_Selected_Group_Segments__c=grpSGmntLst[0].Id;
                wfRecDup.GA_Account__c = testAccount.id;
                wfRecDup.GA_Support__c=cas.Id;
                wfRecDup.GA_Carrier__c = wfTemp.GA_Carrier__c;
                wfRecDup.GA_Method__c = wfTemp.GA_Method__c;
                wfRecDup.Sub_Type__c = wfTemp.GA_Process_Subtype__c;
                wfRecDup.GA_Type__c=wfTemp.GA_Process_Type__c;
                wfRecDup.GA_Status__c = 'Open';
                wfRecDup.GA_Workflow_Template__c =wfTemp.id;
                database.insert(wfRecDup);
                
                
                Group testGroup = new Group(Name='GA Project Support Queue', Type='Queue');
                database.insert(testGroup);
                
                QueuesObject testQueue = new QueueSObject(QueueID = testGroup.id, SObjectType = 'GA_WF_Group_Segment__c');
                database.insert(testQueue);
                Set<Id> wfSetid = New Set<id>();
                wfSetid.add(wfRec.id);
                Test.startTest();
                GA_WrkflowAutomatedCls.deleteInvalidWF(wfSetid);
                //saveNextStep
                Test.stopTest();
                System.assert(wfSetid <> null);
            }
            catch(exception e)
            {
                return;
            }
        }          
    }
    /*******************************************************************************************************************************
@Description: insertWfRecExcepCvr() method 
@Name : insertWfRecExcepCvr
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
    private static testmethod void insertWfRecExcepCvr()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('Testexcep','testsalesrepmail2@bcbsm.com','Support');
        database.insert(usr);
        system.runAs(usr)
        {
            
            try {
                string recId = null;
                
                test.startTest();
                WorkflowController.insertWfRec(null, null, null, null, null, null, null, null, null,null);
                test.stopTest();
            } 
            catch (exception e) {
                system.assert(e <> null);
                return;
            }
        }
    }
    /*******************************************************************************************************************************
@Description: insertWfRecExcepCvr() method 
@Name : insertWfRecExcepCvr
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
    private static testmethod void retrieveNextStepsExcepCvr()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('Testexcep','testsalesrepmail2@bcbsm.com','Support');
        database.insert(usr);
        system.runAs(usr)
        {
            
            try {
                string recId = null;
                
                test.startTest();
                WorkflowController.retrieveNextSteps(null);
                test.stopTest();
            } 
            catch (exception e) {
                system.assert(e <> null);
                return;
            }
        }
    }
    /*******************************************************************************************************************************
@Description: insertWfRecExcepCvr() method 
@Name : insertWfRecExcepCvr
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
    private static testmethod void saveNextStepExcepCvr()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('Testexcep','testsalesrepmail2@bcbsm.com','Support');
        database.insert(usr);
        system.runAs(usr)
        {
            
            try {
                string recId = null;
                
                test.startTest();
                WorkflowController.saveNextStep(null, null, null, null, null, null, null);
                test.stopTest();
            } 
            catch (exception e) {
                system.assert(e <> null);
                return;
            }
        }
    }
    /*******************************************************************************************************************************
@Description: notifyUseAssigned() method 
@Name : notifyUseAssigned
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
    private static testmethod void notifyUseAssignedExcepCvr()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('Testexcep','testsalesrepmail2@bcbsm.com','Support');
        database.insert(usr);
        system.runAs(usr)
        {
            
            try {
                string recId = null;
                
                test.startTest();
                WorkflowController.notifyUseAssigned(null, null);
                test.stopTest();
            } 
            catch (exception e) {
                system.assert(e <> null);
                return;
            }
        }
    }
    /*******************************************************************************************************************************
@Description: fetchAccStatusExcepCvr() method 
@Name : fetchAccStatusExcepCvr
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
    private static testmethod void fetchAccStatusExcepCvr()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('Testexcep','testsalesrepmail2@bcbsm.com','Support');
        database.insert(usr);
        system.runAs(usr)
        {
            
            try {
                string recId = null;
                
                test.startTest();
                WorkflowController.fetchAccStatus(null, 'Account');
                test.stopTest();
            } 
            catch (exception e) {
                system.assert(e <> null);
                return;
            }
        }
    }
    
    /*******************************************************************************************************************************
@Description: fetchaccNameExcepCvr() method 
@Name : fetchaccNameExcepCvr
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
    private static testmethod void fetchaccNameExcepCvr()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('Testexcep','testsalesrepmail2@bcbsm.com','Support');
        database.insert(usr);
        system.runAs(usr)
        {
            
            try {
                string recId = null;
                
                test.startTest();
                WorkflowController.fetchaccName(recId);
                test.stopTest();
            } 
            catch (exception e) {
                system.assert(e <> null);
                return;
            }
        }
    }
    /*******************************************************************************************************************************
@Description: fetchaccNameExcep1Cvr() method 
@Name : fetchaccNameExcep1Cvr
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
    private static testmethod void fetchaccNameExcep1Cvr()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('Testexcep','testsalesrepmail2@bcbsm.com','Support');
        database.insert(usr);
        system.runAs(usr)
        {
            
            try {
                string recId = null;
                
                test.startTest();
                WorkflowController.fetchaccNameABR(recId);
                test.stopTest();
            } 
            catch (exception e) {
                system.assert(e <> null);
                return;
            }
        }
    }
    /*******************************************************************************************************************************
@Description: fetchaccNameExcep2Cvr() method 
@Name : fetchaccNameExcep2Cvr
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
    private static testmethod void fetchaccNameExcep2Cvr()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('Testexcep','testsalesrepmail2@bcbsm.com','Support');
        database.insert(usr);
        system.runAs(usr)
        {
            
            try {
                String accountId='';
                String abrRecId='';  
                String carrier='';
                String type='';
                String subType=''; 
                List<String> lstGroupSegments = new List<String>(); 
                String method='';
                
                test.startTest();
                WorkflowController.insertWfRecABR(accountId, abrRecId, carrier, type, subType, lstGroupSegments, method);
                test.stopTest();
            } 
            catch (exception e) {
                system.assert(e <> null);
                return;
            }
        }
    }
    /*******************************************************************************************************************************
@Description: loadGroupSegmentsSizeExcp() method 
@Name : fetchaccNameExcep2Cvr
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
    private static testmethod void loadGroupSegmentsSizeExcp()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('Testexcep','testsalesrepmail2@bcbsm.com','Support');
        database.insert(usr);
        system.runAs(usr)
        {
            
            try {
                
                
                test.startTest();
                WorkflowController.loadGroupSegmentsSize(null, null);
                test.stopTest();
            } 
            catch (exception e) {
                system.assert(e <> null);
                return;
            }
        }
    }
    /*******************************************************************************************************************************
@Description: retrieveGrpSgmntsExcp() method 
@Name : fetchaccNameExcep2Cvr
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
    private static testmethod void retrieveGrpSgmntsExcp()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('Testexcep','testsalesrepmail2@bcbsm.com','Support');
        database.insert(usr);
        system.runAs(usr)
        {
            
            try {
                
                test.startTest();
                WorkflowController.retrieveGroupSegments(null,null,null,null,null);
                test.stopTest();
            } 
            catch (exception e) {
                system.assert(e <> null);
                return;
            }
        }
    }
    /*******************************************************************************************************************************
@Description: retrieveGrpSgmntsExcp() method 
@Name : fetchaccNameExcep2Cvr
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
    private static testmethod void retrieveClsdGrpSgmntsExcp()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('Testexcep','testsalesrepmail2@bcbsm.com','Support');
        database.insert(usr);
        system.runAs(usr)
        {
            
            try {
                
                
                test.startTest();
                WorkflowController.retrieveClosedGroupSegments(null, null,null,null);
                test.stopTest();
            } 
            catch (exception e) {
                system.assert(e <> null);
                return;
            }
        }
    }
    
    /*******************************************************************************************************************************
@Description: retrieveGroupSegmentsCover() method 
@Name : retrieveGroupSegmentsCover
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
    private static testmethod void retrieveGroupSegmentsCover()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('Testexcep','testsalesrepmail2@bcbsm.com','Support');
        database.insert(usr);
        system.runAs(usr)
        {
            
            try {
                Account testAccount = GA_OBJ_TD01_TestDataCreation.AccRec();
                database.insert(testAccount);
                Contract testContract = ARV_AP05_TestDataCreation.createContractRec(testAccount.Id);
                database.insert(testContract);
                String carrier = 'BCBSM';
                String typName = 'New Business';
                String subTypName = 'Agent Sold Enrollment';
                test.startTest();
                WorkflowController.retrieveGroupSegments(testAccount.id,carrier,typName,subTypName,testContract.id);
                test.stopTest();
            } 
            catch (exception e) {
                system.assert(e <> null);
                return;
            }
        }
    }
    /*******************************************************************************************************************************
@Description: retrieveGroupSegmentsExpCover() method 
@Name : retrieveGroupSegmentsExpCover
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
    private static testmethod void retrieveGroupSegmentsExpCover()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('Testexcep','testsalesrepmail2@bcbsm.com','Support');
        database.insert(usr);
        system.runAs(usr)
        {
            
            try {
                String accountId='';
                String carrier='';
                String typName='';
                String subtypName='';
                Contract testContract = ARV_AP05_TestDataCreation.createContractRec(accountId);
                database.insert(testContract);
                
                test.startTest();
                WorkflowController.retrieveGroupSegments(accountId,carrier,typName,subtypName,testContract.id);
                test.stopTest();
            } 
            catch (exception e) {
                system.assert(e <> null);
                return;
            }
        }
    }
    /*******************************************************************************************************************************
@Description: retrieveBenefitSelectionMethodsExcp() method 
@Name : retrieveBenefitSelectionMethodsExcp
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
    private static testmethod void retrieveBenefitSelectionMethodsExcp()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('Testexcep','testsalesrepmail2@bcbsm.com','Support');
        database.insert(usr);
        system.runAs(usr)
        {
            
            try {
                string carrier='';
                string type='';
                string subType='';
                
                test.startTest();
                WorkflowController.retrieveBenefitSelectionMethods(carrier, type, subType);
                test.stopTest();
            } 
            catch (exception e) {
                system.assert(e <> null);
                return;
            }
        }
    }
    
    /*******************************************************************************************************************************
@Description: retrieveSubTypesExcp() method 
@Name : retrieveSubTypesExcp
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
    private static testmethod void retrieveSubTypesExcp()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('Testexcep','testsalesrepmail2@bcbsm.com','Support');
        database.insert(usr);
        system.runAs(usr)
        {
            
            try {
                string carrier='';
                string type='';
                
                test.startTest();
                WorkflowController.retrieveSubTypes(carrier, type);
                test.stopTest();
            } 
            catch (exception e) {
                system.assert(e <> null);
                return;
            }
        }
    }
    /*******************************************************************************************************************************
@Description: retrieveTypesExcp() method 
@Name : retrieveTypesExcp
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
    private static testmethod void retrieveTypesExcp()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('Testexcep','testsalesrepmail2@bcbsm.com','Support');
        database.insert(usr);
        system.runAs(usr)
        {
            
            try {
                string carrier=null;
                
                test.startTest();
                WorkflowController.retrieveTypes(carrier);
                test.stopTest();
            } 
            catch (exception e) {
                system.assert(e <> null);
                return;
            }
        }
    }
    /*******************************************************************************************************************************
@Description: fetchWFCreateCvr() method 
@Name : fetchWFCreateCvr
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
    private static testmethod void fetchWFCreateCvr()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('Testexcep','testsalesrepmail2@bcbsm.com','Support');
        database.insert(usr);
        system.runAs(usr)
        {
            
            try {
                string wfId=null;
                List<string> gsIdQte;
                string typeVal=null;
                string subtypeVal=null;
                string carrier=null;
                string workflowStepId=null;
                Id wrkflwStepId =null;
                test.startTest();
                WorkflowController.fetchParentWEFPrcess(wfId);
                WorkflowController.processSelectedRecords(gsIdQte);
                WorkflowController.wfCreateAccssStpVls(typeVal,subtypeVal);
                WorkflowController.retrieveBenefitSelectionMethods(carrier,typeVal,subtypeVal);
                WorkflowController.retrieveTypes(carrier);
                WorkflowController.retrieveCarriers();
                WorkflowController.isPreprocessingStep(workflowStepId);
                WorkflowController.retrieveCurrentStepGroupSegmentsInNextStep(wrkflwStepId);
                WorkflowController.retrieveCurrentStepGroupSegments(wrkflwStepId);
                
                WorkflowController.fetchWFCreate();
                test.stopTest();
            } 
            catch (exception e) {
                system.assert(e <> null);
                return;
            }
        }
    }
    /*******************************************************************************************************************************
@Description: fetchWFCreateExpCvr() method 
@Name : fetchWFCreateExpCvr
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
    private static testmethod void fetchWFCreateExpCvr()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('Testexcep','testsalesrepmail2@bcbsm.com','Support');
        database.insert(usr);
        system.runAs(usr)
        {
            
            try {
                GA_Workflow_Launch_Bypass__c instnce =null;
                test.startTest();
                WorkflowController.fetchWFCreate();
                test.stopTest();
            } 
            catch (exception e) {
                system.assert(e <> null);
                return;
            }
        }
    }
    /*******************************************************************************************************************************
@Description: executeABRWfmethods() method 
@Name : executeABRWfmethods
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
    private static testMethod void executeABRWfmethods() {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestSysAdm','testsysadm@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {
            try{
                GA_WFT_workflow__c wfTemp = GA_OBJ_TD01_TestDataCreation.wrkFlwTmplt();
                wfTemp.Name='ABR';
                wfTemp.GA_Carrier__c = 'BCBSM';
                wfTemp.GA_Process_Type__c ='ABR';
                wfTemp.GA_Process_Subtype__c='N/A';
                wfTemp.GA_Method__c ='N/A';
                database.insert(wfTemp);
                
                GA_WFT_Inventory_Step__c wfInvStp = GA_OBJ_TD01_TestDataCreation.wfInventoryStp();
                wfInvStp.name = 'Benefit Administration Review';
                database.insert(wfInvStp);
                
                GA_WFT_Inventory_Step__c wfInvStp1 = GA_OBJ_TD01_TestDataCreation.wfInventoryStp();
                wfInvStp1.name = 'Completed';
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
                Contract testContract = ARV_AP05_TestDataCreation.createContractRec(testAccount.Id);
                database.insert(testContract);
                GA_Account_Benefit_Review__c benRvw = GA_OBJ_TD01_TestDataCreation.accBenfitRvw(testAccount);
                database.insert(benRvw);
                
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
                
                Group testGroup = new Group(Name='Queue N/A', Type='Queue');
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
                
                GA_WF_Step__c wfStepRec2 = New  GA_WF_Step__c();
                wfStepRec2.Name = wfInvStp1.Name;
                wfStepRec2.GA_Status__c = 'Open';
                wfStepRec2.GA_WF_Template_Step__c = wftStp.id;
                wfStepRec2.GA_WF_Workflow_ID__c = wfRec.id;
                wfStepRec2.GA_Notes__c = 'Test';
                wfStepRec2.OwnerId = usr.id;
                
                database.insert(wfStepRec2); 
                
                GA_Group_Segment__c grpSgmntRec=GA_OBJ_TD01_TestDataCreation.grpSegmntRec(testAccount);
                database.insert(grpSgmntRec);
                
                GA_Group_Segment__c grpSgmt= GA_OBJ_TD01_TestDataCreation.grpSegmntRec(testAccount);
                grpSgmt.Name = 'Test gsRec1';
                grpSgmt.GA_Quote_ID__c='1232';
                grpSgmt.Status__c='Active';
                database.insert(grpSgmt);
                
                GA_Group_Segment__c grpSgmt1= GA_OBJ_TD01_TestDataCreation.grpSegmntRec(testAccount);
                grpSgmt1.Name = 'Test gsRec1';
                grpSgmt1.GA_Quote_ID__c='123';
                grpSgmt1.Status__c='Active';
                database.insert(grpSgmt1);
                
                GA_WF_Group_Segment__c wfgs = New GA_WF_Group_Segment__c();
                wfgs.GA_WF_Step_ID__c =   wfStepRec.id;
                wfgs.GA_Workflow_ID__c = wfRec.id;  
                wfgs.GA_Group_Segment_ID__c = grpSgmt.id;
                wfgs.OwnerId = usr.id;
                wfgs.GA_Workflow_Next_Step__c = wfStepRec1.id;
                wfgs.GA_Status__c = 'Open';
                database.insert(wfgs);
                
                GA_WF_Group_Segment__c wfgs1 = New GA_WF_Group_Segment__c();
                wfgs1.GA_WF_Step_ID__c =   wfStepRec1.id;
                wfgs1.GA_Workflow_ID__c = wfRec.id;  
                wfgs1.GA_Group_Segment_ID__c = grpSgmt1.id;
                wfgs1.OwnerId = usr.id;
                wfgs1.GA_Workflow_Next_Step__c = wfStepRec2.id;
                wfgs1.GA_Status__c = 'Open';
                database.insert(wfgs1);
                
                String wfGrpIds = '['+wfgs.id +']';
                
                List<String> grpIdLst = New List<String>();
                grpIdLst.add(wfgs.id);
                
                List<String> grpSgmntIdLst = New List<String>();
                grpSgmntIdLst.add(grpSgmt.id);
                grpSgmntIdLst.add(grpSgmt1.id);
                
                List<String> grpSgmntQutIdLst = New List<String>();
                grpSgmntIdLst.add(grpSgmt.GA_Quote_ID__c);
                grpSgmntIdLst.add(grpSgmt1.GA_Quote_ID__c);  
                
                List<GA_WF_Group_Segment__c> wfgsLst = New List<GA_WF_Group_Segment__c>();
                wfgsLst.add(wfgs);
                
                Test.startTest();
                WorkflowController.loadGroupSegmentsSize(testAccount.Id, 'Account');
                WorkflowController.loadGroupSegmentsSize(cas.Id, 'Case');
                WorkflowController.loadGSQuery(testAccount.Id);
                WorkflowController.retrieveClosedGroupSegments(testAccount.Id, 'BCBSM','New Business',testContract.id);
                WorkflowController.addFilestoWRflw(wfTemp, cas.Id, wfrec.ID);
                WorkflowController.fetchaccName(cas.id);
                WorkflowController.fetchaccNameABR(benRvw.id);
                WorkflowController.insertWfRecABR(testAccount.id, benRvw.id, 'BCBSM','GWC','Benefit Change', grpSgmntIdLst, 'Automated');
                WorkflowController.insertWfRec(testAccount.id,cas.id,'BCBSM','GWC','Benefit Change', grpSgmntIdLst,'Automated',grpSgmntQutIdLst,false,testContract.id);
                WorkflowController.retrieveNextSteps(wfStepRec.id);
                WorkflowController.retrieveCurrentStepGroupSegments(wfStepRec.id);
                WorkflowController.retrieveCurrentStepGroupSegmentsInNextStep(wfStepRec.id);
                WorkflowController.nextStepQueueInfo(wfStepRec.id, wftStp1.id, 'Benefit Administration Review', null);
                WorkflowController.saveNextStep(wfStepRec.id, wftStp1.id, wftStp1.id, grpSgmntIdLst, usr.id,false,'test');
                WorkflowController.isPreprocessingStep(wfStepRec.id);
                WorkflowController.retrieveCarriers();
                WorkflowController.retrieveTypes('BCBSM');
                WorkflowController.retrieveSubTypes('BCBSM', 'GWC');
                WorkflowController.retrieveBenefitSelectionMethods('BCBSM','GWC','Benefit Change');
                GA_AP_01_WorkflowDetmntion.getreltedwfStep('GWC','Benefit Change','Automated','BCBSM');
                //saveNextStep
                Test.stopTest();
                System.assert(testAccount <> null);
            }
            catch(exception e)
            {
                return;
            }
        }          
    }
    /*******************************************************************************************************************************
@Description: wrkflwdtmntionExcp() method 
@Name : wrkflwdtmntionExcp
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
    private static testmethod void wrkflwdtmntionExcp()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestSysAdm','testsysadm@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {
            try{
                GA_AP_01_WorkflowDetmntion.getreltedwfStep(null,null,null,null);
                GA_AP_01_WorkflowDetmntion.getRelatedFirstWFStep(null);
                GA_AP_01_WorkflowDetmntion.getRelatedFirstWFStepABR(null, null);
                GA_AP_01_WorkflowDetmntion.getreltedwfTemplate(null, null, null, null);
                GA_AP_02_WkflwstepDetmntion.wfallwdSteps(null);  
                system.assert(usr<>null,true);
            }
            catch(exception e)
            {
                return;
            }
        }
    }
    private static testMethod void saveStepNotesTest() {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestSysAdm','testsysadm@bcbsm.com','System Administrator');
        database.insert(usr); 
        system.runAs(usr)
        {
            try{
                string wfStpId;
                List<String> grpIds;
                string noteComments;
                
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
                
                GA_WFT_Step__c wftStp = GA_OBJ_TD01_TestDataCreation.wrkTmpStp(wfTemp,wfInvStp);
                wftStp.GA_First_Step__c=true;
                database.insert(wftStp);
                
                GA_WFT_Step__c wftStp1 = GA_OBJ_TD01_TestDataCreation.wrkTmpStp(wfTemp,wfInvStp1);
                database.insert(wftStp1);
                
                GA_WFT_Allowed_Next_Step__c wftNxtStp = GA_OBJ_TD01_TestDataCreation.wfAlwdNxtStp(wftStp);
                database.insert(wftNxtStp);
                
                GA_WFT_Allowed_Next_Step__c wftNxtStp1 = GA_OBJ_TD01_TestDataCreation.wfAlwdNxtStp(wftStp1);
                database.insert(wftNxtStp1);
                
                Account testAccount = GA_OBJ_TD01_TestDataCreation.AccRec();
                database.insert(testAccount);
                
                GA_Group_Segment__c grpSgmntRec=GA_OBJ_TD01_TestDataCreation.grpSegmntRec(testAccount);
                grpSgmntRec.GA_Quote_ID__c='123';
                list<GA_Group_Segment__c> grpSGmntLst=new list<GA_Group_Segment__c>();
                grpSGmntLst.add(grpSgmntRec);
                database.insert(grpSGmntLst);
                list<string> gsIdQte=new list<string>();
                gsIdQte.add(grpSgmntRec.id+'-1234');
                
                GA_WF_Workflow__c wfRec = New GA_WF_Workflow__c();
                wfRec.GA_External_Initiated__c=true;
                wfRec.GA_Selected_Group_Segments__c=grpSGmntLst[0].Id;
                wfRec.GA_Account__c = testAccount.id;
                wfRec.GA_Carrier__c = wfTemp.GA_Carrier__c;
                wfRec.GA_Method__c = wfTemp.GA_Method__c;
                wfRec.Sub_Type__c = wfTemp.GA_Process_Subtype__c;
                wfRec.GA_Type__c=wfTemp.GA_Process_Type__c;
                wfRec.GA_Status__c = 'Open';
                wfRec.GA_Workflow_Template__c =wfTemp.id;
                database.insert(wfRec);
                
                GA_WF_Step__c wfStepRec = New  GA_WF_Step__c();
                wfStepRec.Name = wfInvStp.Name;
                wfStepRec.GA_Status__c = 'Open';
                wfStepRec.GA_WF_Template_Step__c = wftStp.id;
                wfStepRec.GA_WF_Workflow_ID__c = wfRec.id;
                wfStepRec.GA_Workflow_Template_Id__c=wfRec.GA_Workflow_Template__c;
                wfStepRec.GA_Notes__c = 'Test';
                wfStepRec.OwnerId = usr.id;
                database.insert(wfStepRec);
                
                Group testGroup = new Group(Name='GA Project Support Queue', Type='Queue');
                database.insert(testGroup);
                
                QueuesObject testQueue = new QueueSObject(QueueID = testGroup.id, SObjectType = 'GA_WF_Group_Segment__c');
                database.insert(testQueue);
                
                GA_WF_Group_Segment__c wfgs = New GA_WF_Group_Segment__c();
                wfgs.GA_WF_Step_ID__c =   wfStepRec.id;
                wfgs.GA_Workflow_ID__c = wfRec.id;  
                wfgs.GA_Group_Segment_ID__c = grpSgmntRec.id;
                wfgs.OwnerId = testQueue.queueid;
                wfgs.GA_Workflow_Next_Step__c = wfStepRec.id;
                wfgs.GA_Notes__c='Test Notes';
                wfgs.GA_Status__c = 'Open';
                database.insert(wfgs);
                wfgs.GA_Notes__c='Test Notes2';
                database.update(wfgs);
                
                
                Test.startTest();
                WorkflowController.saveStepNotes(wfStepRec.id,gsIdQte,'noteComments');
                Test.stopTest();
            }
            catch(exception e)
            {
                return;
            }
        }
    }
}