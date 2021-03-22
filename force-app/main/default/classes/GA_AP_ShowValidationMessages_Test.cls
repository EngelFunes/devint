/*****************************************************************************************
Class Name   : GA_AP_ShowValidationMessages_Test
Date Created : 5/21/2018
Created By   : IDC Offshore
Description  : 1. This is test class is for GA_AP_ShowValidationMessages_Test
******************************************************************************************/
@isTest
public class GA_AP_ShowValidationMessages_Test {
    /*******************************************************************************************************************************
@Description: excutevalidations() method 
@Name : excutevalidations
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/ 
    private static testmethod void excutevalidations()
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
                //cas.recordtypeid=Schema.SObjectType.Case.getRecordTypeInfosByName().get('Support - Issues').getRecordTypeId();
                cas.recordtypeid=Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('GA_Support_Issues').getRecordTypeId();
                cas.AccountId = acc.id;
                cas.GA_IssuesCategory__c='Administration';
                database.insert(cas);
                
                GA_WFT_Validation__c wfTempValGS = GA_OBJ_TD01_TestDataCreation.templateValidation(wfTemp);
                database.insert(wfTempValGS);
                
                GA_WFT_Validation__c wfTempValWF = GA_OBJ_TD01_TestDataCreation.templateValidation(wfTemp);
                wfTempValWF.GA_Object_Name__c = 'GA_WF_Workflow__c';
                wfTempValWF.GA_Field_Name__c = 'GA_Status__c';
                wfTempValWF.GA_Validation_Type__c = 'CONTAINS';
                wfTempValWF.GA_Validation_Value__c = '';
                database.insert(wfTempValWF); 
                
                GA_WFT_Validation__c wfTempValAcc = GA_OBJ_TD01_TestDataCreation.templateValidation(wfTemp);
                wfTempValAcc.GA_Object_Name__c = 'GA_Account__r';
                wfTempValAcc.GA_Field_Name__c = 'Account_Status__c';
                wfTempValAcc.GA_Validation_Type__c = 'CONTAINS';
                wfTempValAcc.GA_Validation_Value__c = 'Inactive';
                database.insert(wfTempValAcc);
                
                GA_WFT_Validation__c wfTempValCase = GA_OBJ_TD01_TestDataCreation.templateValidation(wfTemp);
                wfTempValCase.GA_Object_Name__c = 'GA_Support__r';
                wfTempValCase.GA_Field_Name__c = 'GA_Corporate_Received_Date__c';
                wfTempValCase.GA_Validation_Type__c = 'IS NULL';
                wfTempValCase.GA_Validation_Value__c = '';
                database.insert(wfTempValCase);
                
                GA_WFT_Validation__c wfTempVal2= GA_OBJ_TD01_TestDataCreation.templateValidation(wfTemp);
                wfTempVal2.GA_Validation_Type__c = 'IS NOT NULL';
                database.insert(wfTempVal2);
                
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
                gs.GA_Quote_ID__c='12';
                database.insert(gs);
                
                GA_WF_Group_Segment__c wfgs = New GA_WF_Group_Segment__c();
                wfgs.GA_WF_Step_ID__c = wfStepRec.id;
                wfgs.GA_Workflow_ID__c = wfRec.id; 
                wfgs.GA_Group_Segment_ID__c = gs.id;
                wfgs.OwnerId = usr.id;
                wfgs.GA_Tracking_Status__c = 'IPQT';
                wfgs.GA_Problem_Identified_Values__c = '(2-G) Incorrect Template';
                database.insert(wfgs);
                
                List<GA_WF_Group_Segment__c> wfgsLst = New List<GA_WF_Group_Segment__c>();
                wfgsLst.add(wfgs);
                
                Id wfstpID = wfStepRec.Id;
                
                Id gsId = gs.id;
                
                List<id> gsIdLst = New List<id>();
                gsIdLst.add(gs.id);
                
                Test.startTest();
                GA_AP_ShowValidationMessages.stepNameRec(wfStepRec.Id);
                GA_AP_ShowValidationMessages.wrktStepValidate(wfStepRec.Id);
                GA_AP_ShowValidationMessages.wrktStepValidatePrepocessing(wfStepRec.Id);
                GA_AP_ShowValidationMessages.wrktStepValidateGrpSgmnts(wfgs.Id);
                GA_AP_ShowValidationMessages.fetchmessages(null);
                GA_AP_ShowValidationMessages.errMsgShow(wfstpID,gsIdLst);
                Test.stopTest();
            }
            catch(exception e)
            {
                return;
            }
        }
    }
    /*******************************************************************************************************************************
@Description: CatchstepNameRec() method 
@Name : CatchstepNameRec
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/ 
    private static testmethod void CatchstepNameRec()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('Testwfstp','testsystemadminstrator@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {
            try 
            {
                Test.startTest();
                GA_AP_ShowValidationMessages.stepNameRec(null);
                Test.stopTest();
            }
            catch(exception e)
            {
                return;
            }
        }
    }
    /*******************************************************************************************************************************
@Description: CatchwrktStepValidate() method 
@Name : CatchwrktStepValidate
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/ 
    private static testmethod void CatchwrktStepValidate()
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
                GA_AP_ShowValidationMessages.stepNameRec(wfStepRec.Id);
                GA_AP_ShowValidationMessages.wrktStepValidate(null);
                Test.stopTest();
            }
            catch(exception e)
            {
                return;
            }
        }
    }
    
    /*******************************************************************************************************************************
@Description: catchwrktStepValidatePrepocessing() method 
@Name : catchwrktStepValidatePrepocessing
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/ 
    private static testmethod void catchwrktStepValidatePrepocessing()
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
                GA_AP_ShowValidationMessages.stepNameRec(wfStepRec.Id);
                GA_AP_ShowValidationMessages.wrktStepValidate(wfStepRec.Id);
                GA_AP_ShowValidationMessages.wrktStepValidatePrepocessing(null);
                Test.stopTest();
            }
            catch(exception e)
            {
                return;
            }
        }
    }
    
    /*******************************************************************************************************************************
@Description: NoerrInPrePrccStp() method 
@Name : NoerrInPrePrccStp
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/ 
    private static testmethod void NoerrInPrePrccStp()
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
                
                GA_WFT_Validation__c wfTempValGS = GA_OBJ_TD01_TestDataCreation.templateValidation(wfTemp);
                database.insert(wfTempValGS);
                
                GA_WFT_Validation__c wfTempValWF = GA_OBJ_TD01_TestDataCreation.templateValidation(wfTemp);
                wfTempValWF.GA_Object_Name__c = 'GA_WF_Workflow__c';
                wfTempValWF.GA_Field_Name__c = 'GA_Status__c';
                wfTempValWF.GA_Validation_Type__c = 'DOES NOT CONTAIN';
                wfTempValWF.GA_Validation_Value__c = '';
                database.insert(wfTempValWF); 
                
                GA_WFT_Validation__c wfTempValAcc = GA_OBJ_TD01_TestDataCreation.templateValidation(wfTemp);
                wfTempValAcc.GA_Object_Name__c = 'GA_Account__r';
                wfTempValAcc.GA_Field_Name__c = 'Account_Status__c';
                wfTempValAcc.GA_Validation_Type__c = 'CONTAINS';
                wfTempValAcc.GA_Validation_Value__c = 'Inactive';
                database.insert(wfTempValAcc);
                
                GA_WFT_Validation__c wfTempValCase = GA_OBJ_TD01_TestDataCreation.templateValidation(wfTemp);
                wfTempValCase.GA_Object_Name__c = 'GA_Support__r';
                wfTempValCase.GA_Field_Name__c = 'GA_Corporate_Received_Date__c';
                wfTempValCase.GA_Validation_Type__c = 'IS NULL';
                wfTempValCase.GA_Validation_Value__c = '';
                database.insert(wfTempValCase);
                
                GA_WFT_Validation__c wfTempVal2= GA_OBJ_TD01_TestDataCreation.templateValidation(wfTemp);
                wfTempVal2.GA_Object_Name__c = 'GA_WF_Workflow__c';
                wfTempVal2.GA_Field_Name__c = 'GA_Quote_ID__c';
                wfTempVal2.GA_Validation_Type__c = 'IS NOT NULL';
                wfTempVal2.GA_Validation_Value__c = '123';
                database.insert(wfTempVal2);
                
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
                
                
                Id wfstpID = wfStepRec.Id;
                
                Id GSID = GS.id;
                
                List<id> gsIdLst = New List<id>();
                gsIdLst.add(gs.id);
                
                Test.startTest();
                GA_AP_ShowValidationMessages.stepNameRec(wfStepRec.Id);
                GA_AP_ShowValidationMessages.wrktStepValidate(wfStepRec.Id);
                GA_AP_ShowValidationMessages.wrktStepValidatePrepocessing(wfStepRec.Id);
                GA_AP_ShowValidationMessages.wrktStepValidateGrpSgmnts(wfgs.Id);
                GA_AP_ShowValidationMessages.fetchmessages(null);
                GA_AP_ShowValidationMessages.errMsgShow(wfstpID,gsIdLst);
                Test.stopTest();
            }
            catch(exception e)
            {
                return;
            }
        }
    }
    
    /*******************************************************************************************************************************
@Description: NotPreProcessingStp() method 
@Name : NotPreProcessingStp
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/ 
    private static testmethod void NotPreProcessingStp()
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
                wfStepRec.Name = 'Front-End Check';
                wfStepRec.GA_Status__c = 'Open';
                wfStepRec.GA_WF_Template_Step__c = wftStp.id;
                wfStepRec.GA_WF_Workflow_ID__c = wfRec.id;
                wfStepRec.GA_Notes__c = 'Test';
                wfStepRec.OwnerId = usr.id;
                database.insert(wfStepRec);  
                
                GA_Group_Segment__c gs=GA_OBJ_TD01_TestDataCreation.grpSegmntRec(acc);
                database.insert(gs);
                
                GA_WF_Group_Segment__c wfgs = New GA_WF_Group_Segment__c();
                wfgs.GA_WF_Step_ID__c = wfStepRec.id;
                wfgs.GA_Workflow_ID__c = wfRec.id; 
                wfgs.GA_Group_Segment_ID__c = gs.id;
                wfgs.OwnerId = usr.id;
                wfgs.GA_Tracking_Status__c = 'IPQT';
                wfgs.GA_Problem_Identified_Values__c = '(2-G) Incorrect Template';
                database.insert(wfgs);
                
                List<GA_WF_Group_Segment__c> wfgsLst = New List<GA_WF_Group_Segment__c>();
                wfgsLst.add(wfgs);
                
                Id wfstpID = wfStepRec.Id;
                
                Id GSID = GS.id;
                
                List<id> gsIdLst = New List<id>();
                gsIdLst.add(gs.id);
                
                Test.startTest();
                GA_AP_ShowValidationMessages.stepNameRec(wfStepRec.Id);
                GA_AP_ShowValidationMessages.wrktStepValidate(wfStepRec.Id);
                GA_AP_ShowValidationMessages.wrktStepValidatePrepocessing(wfStepRec.Id);
                GA_AP_ShowValidationMessages.wrktStepValidateGrpSgmnts(wfgs.Id);
                GA_AP_ShowValidationMessages.fetchmessages(null);
                GA_AP_ShowValidationMessages.errMsgShow(wfstpID,gsIdLst);
                Test.stopTest();
            }
            catch(exception e)
            {
                return;
            }
        }
    }
}