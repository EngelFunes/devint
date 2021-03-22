/*******************************************************************************************************************************
@Author : Dilip Junapala
@Name: GA_AP_ShowGrpSgmntWFCls_Test
@CreatedDate: 28 - May 2018 
@Description: GA_AP_ShowGrpSgmntWFCls_Test is test class for GA_AP_ShowGrpSgmntWFCls...
@version : 1.0  
********************************************************************************************************************************/
@isTest
public class GA_AP_ShowGrpSgmntWFCls_Test {
    
    /*******************************************************************************************************************************
@Description: fetchWFNameCvr() method 
@Name : fetchWFNameCvr
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
    private static testMethod void fetchWFNameCvr() {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestSysAdm','testsysadm@bcbsm.com','System Administrator');
        insert usr;
        system.runAs(usr){
            
            try{
                Account acc = GA_OBJ_TD01_TestDataCreation.AccRec();
                database.insert(acc);
                Case cas=GA_OBJ_TD01_TestDataCreation.CaseRec();
                cas.AccountId = acc.id;
                database.insert(cas);
                GA_WFT_workflow__c wfTmp = GA_OBJ_TD01_TestDataCreation.wrkFlwTmplt();
                database.insert(wfTmp);
                
                GA_WF_Workflow__c wrkFlw = GA_OBJ_TD01_TestDataCreation.createWrkFlw(acc,cas,wfTmp,usr);
                wrkFlw.GA_Account__c = acc.id;
                wrkFlw.GA_Support__c = cas.id;
                wrkFlw.GA_Workflow_Template__c = wfTmp.id;
                database.insert(wrkFlw);
                
                Test.startTest();
                GA_AP_ShowGrpSgmntWFCls.fetchWFName(wrkFlw.id);
                Test.stopTest();
                
            }
            catch(exception e)
            {
                return;
            }
        }  
    }
    /*******************************************************************************************************************************
@Description: grmplistCover() method 
@Name : grmplistCover
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
    private static testmethod void grmplistCover()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('Testlckrec','testsysadminmail@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {
            try
            {
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
               system.debug('jetpogi' + [select id, Name,GA_Group_Segment_ID__c,GA_Group_Segment_ID__r.Name,GA_Workflow_ID__r.Name,GA_Workflow_ID__c,GA_Workflow_ID__r.GA_Date_Closed__c,GA_Workflow_ID__r.GA_Date_Opened__c,GA_Workflow_ID__r.GA_Status__c,GA_Account__c,GA_Support_Request__c,GA_Workflow_ID__r.GA_Support__r.CaseNumber,GA_Sub_Type__c,GA_Type__c from GA_WF_Group_Segment__c where GA_IsfirstStep__c = true and GA_Group_Segment_ID__c =:  grpSgmntRec.Id]);
                    GA_AP_ShowGrpSgmntWFCls.fetchWFlst(String.valueof(grpSgmntRec.id));
                Test.stopTest(); 
                
            }
            catch(exception e)
            {
                return;
            }
        }
    }
      /*******************************************************************************************************************************
@Description: nameException() method 
@Name : nameException
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
        private static testmethod void nameException()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('Testexcep','testsalesrepmail2@bcbsm.com','Support');
        database.insert(usr);
        system.runAs(usr)
        {
            
            try {
                
                test.startTest();
                GA_WF_Workflow__c wf = GA_AP_ShowGrpSgmntWFCls.fetchWFName('');
                test.stopTest();
                
            } 
            catch (exception e) {
                system.assert(e <> null);
                return;
            }
        }
    }
}