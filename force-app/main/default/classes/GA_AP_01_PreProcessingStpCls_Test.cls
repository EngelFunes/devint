/*******************************************************************************************************************************
@Author : IDC offshore
@Name: GA_AP_01_PreProcessingStpCls_Test
@CreatedDate:5/24/2018 
@Description: GA_AP_01_PreProcessingStpCls_Test class is for GA_AP_01_PreProcessingStpCls.
@version : 1.0  
********************************************************************************************************************************/
@isTest
private class GA_AP_01_PreProcessingStpCls_Test {
 /*******************************************************************************************************************************
@Description: TestwrkflowStp() method 
@Name : TestwrkflowStp
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/     
    private static testmethod void TestwrkflowStp()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('Testwfstp','testsystemadminstrator@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {
            try 
            {
                GA_WFT_workflow__c wfTemp = GA_OBJ_TD01_TestDataCreation.wrkFlwTmplt();
                database.insert(wfTemp);
                
                Account acc = GA_OBJ_TD01_TestDataCreation.AccRec();
                database.insert(acc);
                
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
                wfRec.GA_Status__c = 'Open';
                wfRec.GA_Workflow_Template__c =wfTemp.id;
                database.insert(wfRec); 
                
                GA_WFT_Step__c wftStp = new GA_WFT_Step__c ();
                wftStp.GA_WFT_Workflow_ID__c = wfTemp.Id;
                database.insert(wftStp);  
                
                GA_WF_Step__c wfStepRec = New  GA_WF_Step__c();
                wfStepRec.Name = 'Pre-Processing';
                wfStepRec.GA_Status__c = 'Open';
                wfStepRec.GA_WF_Template_Step__c = wftStp.id;
                wfStepRec.GA_WF_Workflow_ID__c = wfRec.id;
                wfStepRec.GA_Notes__c = 'Test';
                wfStepRec.OwnerId = usr.id;
                database.insert(wfStepRec);  
                
                GA_Group_Segment__c gs=GA_OBJ_TD01_TestDataCreation.grpSegmntRec(acc);
                gs.GA_Group_Effective_Date__c=system.Today();
                gs.GA_Rate_Renewal_Date__c=system.Today();
                gs.GA_Group_Factor_Cluster_Code__c='12';
                gs.GA_Quote_ID__c='43';
                database.insert(gs);
                
                GA_WF_Group_Segment__c wfgs = New GA_WF_Group_Segment__c();
                wfgs.GA_WF_Step_ID__c =   wfStepRec.id;
                wfgs.GA_Workflow_ID__c = wfRec.id; 
                wfgs.GA_Group_Segment_ID__c = gs.id;
                wfgs.OwnerId = usr.id;
                wfgs.GA_Tracking_Status__c = 'IPQT';
                wfgs.GA_Problem_Identified_Values__c = '(2-G) Incorrect Template';
                database.insert(wfgs);
                
                List<GA_WF_Group_Segment__c> wfgsLst = New List<GA_WF_Group_Segment__c>();
                wfgsLst.add(wfgs);
                
                Test.startTest();
                GA_AP_01_PreProcessingStpCls.wrkflowRecInfo(wfStepRec.Id);
                GA_AP_01_PreProcessingStpCls.validationChk(wfStepRec, wfgsLst);
                GA_AP_01_PreProcessingStpCls.SavewrkflowRec(wfStepRec, false, false);
                Test.stopTest();
            }
            catch(exception e)
            {
                return;
            }
        }
    }
 /*******************************************************************************************************************************
@Description: CatchwrkflowRecInfo() method 
@Name : CatchwrkflowRecInfo
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/     
    private static testmethod void CatchwrkflowRecInfo()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('Testwfstp','testsystemadminstrator@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {
            try 
            {
                Test.startTest();
                GA_AP_01_PreProcessingStpCls.wrkflowRecInfo(null);
                Test.stopTest();
            }
            catch(exception e)
            {
                return;
            }
        }
    }
 /*******************************************************************************************************************************
@Description: CatchvalidationChk() method 
@Name : CatchvalidationChk
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/    
     private static testmethod void CatchvalidationChk()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('Testwfstp','testsystemadminstrator@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {
            try 
            {
                GA_WFT_workflow__c wfTemp = GA_OBJ_TD01_TestDataCreation.wrkFlwTmplt();
                database.insert(wfTemp);
                
                Account acc = GA_OBJ_TD01_TestDataCreation.AccRec();
                database.insert(acc);
                
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
                wfRec.GA_Status__c = 'Open';
                wfRec.GA_Workflow_Template__c =wfTemp.id;
                database.insert(wfRec); 
                
                GA_WFT_Step__c wftStp = new GA_WFT_Step__c ();
                wftStp.GA_WFT_Workflow_ID__c = wfTemp.Id;
                database.insert(wftStp);  
                
                GA_WF_Step__c wfStepRec = New  GA_WF_Step__c();
                wfStepRec.Name = 'Pre-Processing';
                wfStepRec.GA_Status__c = 'Open';
                wfStepRec.GA_WF_Template_Step__c = wftStp.id;
                wfStepRec.GA_WF_Workflow_ID__c = wfRec.id;
                wfStepRec.GA_Notes__c = 'Test';
                wfStepRec.OwnerId = usr.id;
                database.insert(wfStepRec);  
                
                Test.startTest();
                GA_AP_01_PreProcessingStpCls.wrkflowRecInfo(wfStepRec.Id);
                GA_AP_01_PreProcessingStpCls.validationChk(wfStepRec, null);
                
                Test.stopTest();
            }
            catch(exception e)
            {
                return;
            }
        }
    }
   /*******************************************************************************************************************************
@Description: ErrorExstinPreprcsStp() method 
@Name : ErrorExstinPreprcsStp
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/  
      private static testmethod void ErrorExstinPreprcsStp()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('Testwfstp','testsystemadminstrator@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {
            try 
            {
                GA_WFT_workflow__c wfTemp = GA_OBJ_TD01_TestDataCreation.wrkFlwTmplt();
                database.insert(wfTemp);
                
                Account acc = GA_OBJ_TD01_TestDataCreation.AccRec();
                database.insert(acc);
                
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
                wfRec.GA_Status__c = 'Open';
                wfRec.GA_Workflow_Template__c =wfTemp.id;
                database.insert(wfRec); 
                
                GA_WFT_Step__c wftStp = new GA_WFT_Step__c ();
                wftStp.GA_WFT_Workflow_ID__c = wfTemp.Id;
                database.insert(wftStp);  
                
                GA_WF_Step__c wfStepRec = New  GA_WF_Step__c();
                wfStepRec.Name = 'Pre-Processing';
                wfStepRec.GA_Status__c = 'Open';
                wfStepRec.GA_WF_Template_Step__c = wftStp.id;
                wfStepRec.GA_WF_Workflow_ID__c = wfRec.id;
                wfStepRec.GA_Notes__c = 'Test';
                wfStepRec.OwnerId = usr.id;
                database.insert(wfStepRec);  
                
                GA_Group_Segment__c gs=GA_OBJ_TD01_TestDataCreation.grpSegmntRec(acc);
                gs.GA_Quote_ID__c='43';
                database.insert(gs);
                
                GA_WF_Group_Segment__c wfgs = New GA_WF_Group_Segment__c();
                wfgs.GA_WF_Step_ID__c =   wfStepRec.id;
                wfgs.GA_Workflow_ID__c = wfRec.id; 
                wfgs.GA_Group_Segment_ID__c = gs.id;
                wfgs.OwnerId = usr.id;
                wfgs.GA_Tracking_Status__c = 'IPQT';
                wfgs.GA_Problem_Identified_Values__c = '(2-G) Incorrect Template';
                database.insert(wfgs);
                
                List<GA_WF_Group_Segment__c> wfgsLst = New List<GA_WF_Group_Segment__c>();
                wfgsLst.add(wfgs);
                
                Test.startTest();
                GA_AP_01_PreProcessingStpCls.wrkflowRecInfo(wfStepRec.Id);
                GA_AP_01_PreProcessingStpCls.validationChk(wfStepRec, wfgsLst);
                GA_AP_01_PreProcessingStpCls.SavewrkflowRec(wfStepRec, false, false);
                Test.stopTest();
            }
            catch(exception e)
            {
                return;
            }
        }
    }
}