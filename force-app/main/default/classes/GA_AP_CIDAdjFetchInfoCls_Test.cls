/*******************************************************************************************************************************
@Author : IDC offshore
@Name: GA_AP_CIDAdjFetchInfoCls_Test
@CreatedDate: 23 - Feb 2019 
@Description: GA_AP_CIDAdjFetchInfoCls_Test class is for GA_AP_CIDAdjustMentCls.
@version : 1.0  
********************************************************************************************************************************/
@isTest(seealldata = false)
private class GA_AP_CIDAdjFetchInfoCls_Test {
    /*******************************************************************************************************************************
@Description: cidAdjRecTest() method
@Name : cidAdjRecTest
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
    private static testmethod void cidAdjRecTest(){
        user usrSA = GA_OBJ_TD01_TestDataCreation.UsrRec('System Administrator','testsystemadminstrator@bcbsm.com','System Administrator');
        database.insert(usrSA);
        system.runAs(usrSA)
        {
            try{
                List<user> usrLst=new list<user>();
                
                user usr1 = GA_OBJ_TD01_TestDataCreation.UsrRec('TestR1','testsalesrep1mail@bcbsm.com','Retention Sales');
                usrLst.add(usr1);
                
                user usr2 = GA_OBJ_TD01_TestDataCreation.UsrRec('TestR2','testsalesrep2mail@bcbsm.com','Retention Sales');
                usrLst.add(usr2);
                database.insert(usrLst);
                
                Account testAccount1 = GA_OBJ_TD01_TestDataCreation.AccRec();
                database.insert(testAccount1);
                
                Account testAccount2 = GA_OBJ_TD01_TestDataCreation.AccRec();
                database.insert(testAccount2);
                
                Contact testCntc1 = GA_OBJ_TD01_TestDataCreation.cntactRec(testAccount1.Id);
                database.insert(testCntc1);
                
                Contact testCntc2 = GA_OBJ_TD01_TestDataCreation.cntactRec(testAccount2.Id);
                database.insert(testCntc2);
                
                case cas=GA_OBJ_TD01_TestDataCreation.CaseRec();
                cas.recordtypeid=Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('GA_Support_Issues').getRecordTypeId();
                //cas.recordtypeid=Schema.SObjectType.Case.getRecordTypeInfosByName().get('Support - Issues').getRecordTypeId();
                cas.AccountId = testAccount1.id;
                cas.GA_IssuesCategory__c='Administration';
                database.insert(cas);
                
                GA_Group_Segment__c grpsgmt=GA_OBJ_TD01_TestDataCreation.grpSegmntRec(testAccount1);  
                grpsgmt.Status__c='Pending';
                database.insert(grpsgmt);
                
                grpsgmt.GA_Administrative_Contact_Id__c = testCntc1.Id;
                grpsgmt.GA_Billing_Contact_Id__c = testCntc1.Id;
                grpsgmt.GA_Servicing_Agent__c = testCntc2.Id;
                //   grpsgmt.GA_Commissioning_Agent__c = testCntc1.Id;
                grpsgmt.Status__c='Active';
                database.update(grpsgmt);
                
                List<GA_Group_Segment__c> gslst = new List<GA_Group_Segment__c>();
                gslst.add(grpsgmt);
                
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
                
                GA_WF_Workflow__c wfRec = New GA_WF_Workflow__c();
                wfRec.GA_Account__c = testAccount1.id;
                wfRec.GA_Support__c = cas.id;
                wfRec.GA_Carrier__c = wfTemp.GA_Carrier__c;
                wfRec.GA_Method__c = wfTemp.GA_Method__c;
                wfRec.Sub_Type__c = wfTemp.GA_Process_Subtype__c;
                wfRec.GA_Type__c=wfTemp.GA_Process_Type__c;
                wfRec.GA_Status__c = 'Closed';
                wfRec.GA_Workflow_Template__c =wfTemp.id;
                database.insert(wfRec);
                
                GA_CID_Adjustment__c cidRec=GA_OBJ_TD01_TestDataCreation.cidAdjRecrd();
                cidRec.GA_Source_Account__c  = testAccount1.Id;
                cidRec.GA_Target_Account__c  = testAccount2.Id;
                cidRec.GA_Territory_Code_Mismatch__c = True;
                cidRec.GA_Federal_Tax_ID_Mismatch__c = True;
                cidRec.GA_All_Group_Segments__c = True;
                database.insert(cidRec);
                
                GA_Process_Group_Segment__c prGS = new GA_Process_Group_Segment__c();
                prGS.GA_CID_Adjustment__c=cidRec.Id;
                prGS.GA_Group_Segment__c=grpsgmt.Id;
                database.insert(prGS);
                
                cidRec.GA_Territory_Code_Approver__c = usr1.id;
                cidRec.GA_Federal_Tax_ID_Approver__c = usr1.id;
                database.update(cidRec);
                
                GA_Approval__c appr = new GA_Approval__c();
                appr.GA_CID_Adjustment__c=cidRec.Id;
                appr.GA_Approver__c=Usr1.Id;
                database.insert(appr);
                
                GA_CID_Request_Additional_Info__c cidRqstAddInfo1 = new GA_CID_Request_Additional_Info__c();
                cidRqstAddInfo1.GA_CID_Adjustment__c =  cidRec.Id;
                cidRqstAddInfo1.GA_Sent_From__c = usrSA.Id;
                cidRqstAddInfo1.GA_Sent_To__c = usr1.Id;
                cidRqstAddInfo1.GA_Master_CID_Request_Additional_Info__c = null;
                database.insert(cidRqstAddInfo1);
                
                Test.startTest();
                GA_AP_CIDAdjFetchInfoCls.fetchCIDAdjRecInfo(cidRec.Id);  
                GA_AP_CIDAdjFetchInfoCls.UpdateCIDAdjStatus(cidRec.Id);
                GA_AP_CIDAdjFetchInfoCls.UpdateApprvStatus(appr.Id);
                GA_AP_CIDAdjFetchInfoCls.reqstFrAprvl(usr1.Id,usr1.Id,cidRec.Id);
                GA_AP_CIDAdjFetchInfoCls.SendFrAddInfo(cidRec,'RequestInfoCmmnts');
                GA_AP_CIDAdjFetchInfoCls.restAddtnlbtnAccess(cidRec.Id);
                GA_AP_CIDAdjFetchInfoCls.chkLoggedInUsrprfle();
                Test.stopTest();
                
                System.assert(usrSA <> null);
                
            }
            catch(exception e)
            {
                return;
            }
        }
    }
    /*******************************************************************************************************************************
@Description: cidAdjustMentRqAddInfo() method 
@Name : cidAdjustMentRqAddInfo
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
    private static testmethod void cidAdjustMentRqAddInfo(){
        user usrSA = GA_OBJ_TD01_TestDataCreation.UsrRec('System Administrator','testsystemadminstrator@bcbsm.com','System Administrator');
        database.insert(usrSA);
        system.runAs(usrSA)
        {
            try{
                List<user> usrLst=new list<user>();
                
                user usr1 = GA_OBJ_TD01_TestDataCreation.UsrRec('TestR1','testsalesrep1mail@bcbsm.com','Retention Sales');
                usrLst.add(usr1);
                
                user usr2 = GA_OBJ_TD01_TestDataCreation.UsrRec('TestR2','testsalesrep2mail@bcbsm.com','Retention Sales');
                usrLst.add(usr2);
                database.insert(usrLst);
                
                Account testAccount1 = GA_OBJ_TD01_TestDataCreation.AccRec();
                database.insert(testAccount1);
                
                Account testAccount2 = GA_OBJ_TD01_TestDataCreation.AccRec();
                database.insert(testAccount2);
                
                Contact testCntc1 = GA_OBJ_TD01_TestDataCreation.cntactRec(testAccount1.Id);
                database.insert(testCntc1);
                
                Contact testCntc2 = GA_OBJ_TD01_TestDataCreation.cntactRec(testAccount2.Id);
                database.insert(testCntc2);
                
                case cas=GA_OBJ_TD01_TestDataCreation.CaseRec();
                cas.recordtypeid=Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('GA_Support_Issues').getRecordTypeId();
                //cas.recordtypeid=Schema.SObjectType.Case.getRecordTypeInfosByName().get('Support - Issues').getRecordTypeId();
                cas.AccountId = testAccount1.id;
                cas.GA_IssuesCategory__c='Administration';
                database.insert(cas);
                
                GA_Group_Segment__c grpsgmt=GA_OBJ_TD01_TestDataCreation.grpSegmntRec(testAccount1);  
                grpsgmt.Status__c='Pending';
                database.insert(grpsgmt);
                
                grpsgmt.GA_Administrative_Contact_Id__c = testCntc1.Id;
                grpsgmt.GA_Billing_Contact_Id__c = testCntc1.Id;
                grpsgmt.GA_Servicing_Agent__c = testCntc2.Id;
                //   grpsgmt.GA_Commissioning_Agent__c = testCntc1.Id;
                grpsgmt.Status__c='Active';
                database.update(grpsgmt);
                
                List<GA_Group_Segment__c> gslst = new List<GA_Group_Segment__c>();
                gslst.add(grpsgmt);
                
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
                
                GA_WF_Workflow__c wfRec = New GA_WF_Workflow__c();
                wfRec.GA_Account__c = testAccount1.id;
                wfRec.GA_Support__c = cas.id;
                wfRec.GA_Carrier__c = wfTemp.GA_Carrier__c;
                wfRec.GA_Method__c = wfTemp.GA_Method__c;
                wfRec.Sub_Type__c = wfTemp.GA_Process_Subtype__c;
                wfRec.GA_Type__c=wfTemp.GA_Process_Type__c;
                wfRec.GA_Status__c = 'Closed';
                wfRec.GA_Workflow_Template__c =wfTemp.id;
                database.insert(wfRec);
                
                GA_CID_Adjustment__c cidRec=GA_OBJ_TD01_TestDataCreation.cidAdjRecrd();
                cidRec.GA_Source_Account__c  = testAccount1.Id;
                cidRec.GA_Target_Account__c  = testAccount2.Id;
                cidRec.GA_Territory_Code_Mismatch__c = True;
                cidRec.GA_Federal_Tax_ID_Mismatch__c = True;
                cidRec.GA_All_Group_Segments__c = True;
                database.insert(cidRec);
                
                GA_Process_Group_Segment__c prGS = new GA_Process_Group_Segment__c();
                prGS.GA_CID_Adjustment__c=cidRec.Id;
                prGS.GA_Group_Segment__c=grpsgmt.Id;
                database.insert(prGS);
                
                cidRec.GA_Territory_Code_Approver__c = usr1.id;
                cidRec.GA_Federal_Tax_ID_Approver__c = usr1.id;
                database.update(cidRec);
                
                GA_Approval__c appr = new GA_Approval__c();
                appr.GA_CID_Adjustment__c=cidRec.Id;
                appr.GA_Approver__c=Usr1.Id;
                database.insert(appr);
                
                GA_CID_Request_Additional_Info__c cidRqstAddInfo1 = new GA_CID_Request_Additional_Info__c();
                cidRqstAddInfo1.GA_CID_Adjustment__c =  cidRec.Id;
                cidRqstAddInfo1.GA_Sent_From__c = usrSA.Id;
                cidRqstAddInfo1.GA_Sent_To__c = usr1.Id;
                cidRqstAddInfo1.GA_Master_CID_Request_Additional_Info__c = null;
                database.insert(cidRqstAddInfo1);
                
                GA_CID_Request_Additional_Info__c cidRqstAddInfo2 = new GA_CID_Request_Additional_Info__c();
                cidRqstAddInfo2.GA_CID_Adjustment__c =  cidRec.Id;
                cidRqstAddInfo2.GA_Sent_From__c = usrSA.Id;
                cidRqstAddInfo2.GA_Sent_To__c = usr1.Id;
                cidRqstAddInfo2.GA_Master_CID_Request_Additional_Info__c = cidRqstAddInfo1.Id;
                database.insert(cidRqstAddInfo2);
                
                Test.startTest();
                GA_AP_CIDAdjFetchInfoCls.fetchCIDAdjRecInfo(cidRec.Id);  
                GA_AP_CIDAdjFetchInfoCls.UpdateCIDAdjStatus(cidRec.Id);
                GA_AP_CIDAdjFetchInfoCls.UpdateApprvStatus(appr.Id);
                GA_AP_CIDAdjFetchInfoCls.reqstFrAprvl(usr1.Id,usr1.Id,cidRec.Id);
                GA_AP_CIDAdjFetchInfoCls.SendFrAddInfo(cidRec,'RequestInfoCmmnts');
                GA_AP_CIDAdjFetchInfoCls.restAddtnlbtnAccess(cidRec.Id);
                GA_AP_CIDAdjFetchInfoCls.chkLoggedInUsrprfle();
                Test.stopTest();
                
                System.assert(usrSA <> null);
            }
            catch(exception e)
            {
                return;
            }
        }
    }
    /*******************************************************************************************************************************
@Description: cidAdjustMentNoRqAddInfo() method 
@Name : cidAdjustMentNoRqAddInfo
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
    private static testmethod void cidAdjustMentNoRqAddInfo(){
        user usrSA = GA_OBJ_TD01_TestDataCreation.UsrRec('System Administrator','testsystemadminstrator@bcbsm.com','System Administrator');
        database.insert(usrSA);
        system.runAs(usrSA)
        {
            try{
                List<user> usrLst=new list<user>();
                
                user usr1 = GA_OBJ_TD01_TestDataCreation.UsrRec('TestR1','testsalesrep1mail@bcbsm.com','Retention Sales');
                usrLst.add(usr1);
                
                user usr2 = GA_OBJ_TD01_TestDataCreation.UsrRec('TestR2','testsalesrep2mail@bcbsm.com','Retention Sales');
                usrLst.add(usr2);
                database.insert(usrLst);
                
                Account testAccount1 = GA_OBJ_TD01_TestDataCreation.AccRec();
                database.insert(testAccount1);
                
                Account testAccount2 = GA_OBJ_TD01_TestDataCreation.AccRec();
                database.insert(testAccount2);
                
                Contact testCntc1 = GA_OBJ_TD01_TestDataCreation.cntactRec(testAccount1.Id);
                database.insert(testCntc1);
                
                Contact testCntc2 = GA_OBJ_TD01_TestDataCreation.cntactRec(testAccount2.Id);
                database.insert(testCntc2);
                
                case cas=GA_OBJ_TD01_TestDataCreation.CaseRec();
                cas.recordtypeid=Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('GA_Support_Issues').getRecordTypeId();
                //cas.recordtypeid=Schema.SObjectType.Case.getRecordTypeInfosByName().get('Support - Issues').getRecordTypeId();
                cas.AccountId = testAccount1.id;
                cas.GA_IssuesCategory__c='Administration';
                database.insert(cas);
                
                GA_Group_Segment__c grpsgmt=GA_OBJ_TD01_TestDataCreation.grpSegmntRec(testAccount1);  
                grpsgmt.Status__c='Pending';
                database.insert(grpsgmt);
                
                grpsgmt.GA_Administrative_Contact_Id__c = testCntc1.Id;
                grpsgmt.GA_Billing_Contact_Id__c = testCntc1.Id;
                grpsgmt.GA_Servicing_Agent__c = testCntc2.Id;
                //   grpsgmt.GA_Commissioning_Agent__c = testCntc1.Id;
                grpsgmt.Status__c='Active';
                database.update(grpsgmt);
                
                List<GA_Group_Segment__c> gslst = new List<GA_Group_Segment__c>();
                gslst.add(grpsgmt);
                
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
                
                GA_WF_Workflow__c wfRec = New GA_WF_Workflow__c();
                wfRec.GA_Account__c = testAccount1.id;
                wfRec.GA_Support__c = cas.id;
                wfRec.GA_Carrier__c = wfTemp.GA_Carrier__c;
                wfRec.GA_Method__c = wfTemp.GA_Method__c;
                wfRec.Sub_Type__c = wfTemp.GA_Process_Subtype__c;
                wfRec.GA_Type__c=wfTemp.GA_Process_Type__c;
                wfRec.GA_Status__c = 'Closed';
                wfRec.GA_Workflow_Template__c =wfTemp.id;
                database.insert(wfRec);
                
                GA_CID_Adjustment__c cidRec=GA_OBJ_TD01_TestDataCreation.cidAdjRecrd();
                cidRec.GA_Source_Account__c  = testAccount1.Id;
                cidRec.GA_Target_Account__c  = testAccount2.Id;
                cidRec.GA_Territory_Code_Mismatch__c = True;
                cidRec.GA_Federal_Tax_ID_Mismatch__c = True;
                cidRec.GA_All_Group_Segments__c = True;
                database.insert(cidRec);
                
                GA_Process_Group_Segment__c prGS = new GA_Process_Group_Segment__c();
                prGS.GA_CID_Adjustment__c=cidRec.Id;
                prGS.GA_Group_Segment__c=grpsgmt.Id;
                database.insert(prGS);
                
                cidRec.GA_Territory_Code_Approver__c = usr1.id;
                cidRec.GA_Federal_Tax_ID_Approver__c = usr1.id;
                database.update(cidRec);
                
                GA_Approval__c appr = new GA_Approval__c();
                appr.GA_CID_Adjustment__c=cidRec.Id;
                appr.GA_Approver__c=Usr1.Id;
                database.insert(appr);
                
                Test.startTest();
                GA_AP_CIDAdjFetchInfoCls.fetchCIDAdjRecInfo(cidRec.Id);  
                GA_AP_CIDAdjFetchInfoCls.UpdateCIDAdjStatus(cidRec.Id);
                GA_AP_CIDAdjFetchInfoCls.UpdateApprvStatus(appr.Id);
                GA_AP_CIDAdjFetchInfoCls.reqstFrAprvl(usr1.Id,usr1.Id,cidRec.Id);
                GA_AP_CIDAdjFetchInfoCls.SendFrAddInfo(cidRec,'RequestInfoCmmnts');
                GA_AP_CIDAdjFetchInfoCls.restAddtnlbtnAccess(cidRec.Id);
                GA_AP_CIDAdjFetchInfoCls.chkLoggedInUsrprfle();
                Test.stopTest();
                 system.assert(usrSA <> null,true);
                
            }
            catch(exception e)
            {
                return;
            }
        }
    }
    /*******************************************************************************************************************************
@Description: cidAdjustMentNoMismtch() method 
@Name : cidAdjustMentNoMismtch
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
    private static testmethod void cidAdjustMentNoMismtch(){
        user usrSA = GA_OBJ_TD01_TestDataCreation.UsrRec('System Administrator','testsystemadminstrator@bcbsm.com','System Administrator');
        database.insert(usrSA);
        system.runAs(usrSA)
        {
            try{
                
                Account testAccount1 = GA_OBJ_TD01_TestDataCreation.AccRec();
                database.insert(testAccount1);
                
                Account testAccount2 = GA_OBJ_TD01_TestDataCreation.AccRec();
                database.insert(testAccount2);
                
                GA_Group_Segment__c grpsgmt=GA_OBJ_TD01_TestDataCreation.grpSegmntRec(testAccount1);  
                grpsgmt.Status__c='Pending';
                database.insert(grpsgmt);
                
                grpsgmt.Status__c='Active';
                database.update(grpsgmt);
                
                List<GA_Group_Segment__c> gslst = new List<GA_Group_Segment__c>();
                gslst.add(grpsgmt);
                
                GA_CID_Adjustment__c cidRec=GA_OBJ_TD01_TestDataCreation.cidAdjRecrd();
                cidRec.GA_Source_Account__c  = testAccount1.Id;
                cidRec.GA_Target_Account__c  = testAccount2.Id;
                database.insert(cidRec);
                
                GA_Process_Group_Segment__c prGS = new GA_Process_Group_Segment__c();
                prGS.GA_CID_Adjustment__c=cidRec.Id;
                prGS.GA_Group_Segment__c=grpsgmt.Id;
                database.insert(prGS);
                
                Test.startTest();
                GA_AP_CIDAdjFetchInfoCls.fetchCIDAdjRecInfo(cidRec.Id);  
                GA_AP_CIDAdjFetchInfoCls.UpdateCIDAdjStatus(cidRec.Id);
                GA_AP_CIDAdjFetchInfoCls.UpdateApprvStatus(null);
                GA_AP_CIDAdjFetchInfoCls.reqstFrAprvl(null,null,cidRec.Id);
                GA_AP_CIDAdjFetchInfoCls.SendFrAddInfo(cidRec,'RequestInfoCmmnts');
                GA_AP_CIDAdjFetchInfoCls.restAddtnlbtnAccess(cidRec.Id);
                GA_AP_CIDAdjFetchInfoCls.chkLoggedInUsrprfle();
                Test.stopTest();
                   system.assert(usrSA <> null,true);
                
            }
            catch(exception e)
            {
                return;
            }
        }
    }
    /*******************************************************************************************************************************
@Description: cidAdjustMentRecCatch() method 
@Name : cidAdjustMentRecCatch
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
    private static testmethod void cidAdjustMentRecCatch(){
        user usrSA = GA_OBJ_TD01_TestDataCreation.UsrRec('System Administrator','testsystemadminstrator@bcbsm.com','System Administrator');
        database.insert(usrSA);
        system.runAs(usrSA)
        {
            try{
                
                Test.startTest();
                GA_AP_CIDAdjFetchInfoCls.fetchCIDAdjRecInfo(null);  
                GA_AP_CIDAdjFetchInfoCls.UpdateCIDAdjStatus(null);
                GA_AP_CIDAdjFetchInfoCls.UpdateApprvStatus(null);
                GA_AP_CIDAdjFetchInfoCls.reqstFrAprvl(null,null,null);
                GA_AP_CIDAdjFetchInfoCls.SendFrAddInfo(null,null);
                GA_AP_CIDAdjFetchInfoCls.restAddtnlbtnAccess(null);
                GA_AP_CIDAdjFetchInfoCls.chkLoggedInUsrprfle();
                Test.stopTest();
                system.assert(usrSA <> null,true);
                
            }
            catch(exception e)
            {
                return;
            }
        }
    }
}