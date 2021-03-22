/*******************************************************************************************************************************
@Author : IDC offshore
@Name: GA_WorkflowStpSaveCls_Test
@CreatedDate: 17 - April 2018 
@Description: GA_WorkflowStpSaveCls_Test class is for GA_WorkflowStpSaveCls.
@version : 1.0  
********************************************************************************************************************************/
@isTest
public class GA_WorkflowStpSaveCls_Test {
    /*******************************************************************************************************************************
@Description: savewfStep() method 
@Name : savewfStep
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
    private static testMethod void savewfStep() {
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
                WfRec.GA_Corporate_Received_Date__c=system.Today();
                WfRec.GA_Benefit_Effective_Date__c  = system.Today()+2;
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
                
                string corpDt = '11/01/2020';
                Date corpRcvDate  = Date.parse(corpDt); 
                
                string benEffDt = '12/01/2020';
                Date benEffDate  = Date.parse(benEffDt);
                
                string cnclEffDt = '12/01/2021';
                Date cnclEffDate  = Date.parse(benEffDt);
                
                String stepid= String.valueOf(wfStepRec.id);
                //String nts,String wfstpId,String trackingStatus,String problemIdentified,String workType,String otherPID,boolean soldafter3PM,String cancelReason,Date cancelDate    
                Test.startTest();
                GA_WorkflowStpSaveCls.fetchwrkStpDetails(wfStepRec.id);
                GA_WorkflowStpSaveCls.validationChk(wfStepRec.id);
                GA_WorkflowStpSaveCls.updateWFStep('Test', wfStepRec.id);
                GA_WorkflowStpSaveCls.completeCurrentStep('Test', stepid, 'SOLD', '(3-A) Invalid PID','QM','5-Z Rating Issue Other', false,'NA',cnclEffDate);
                //String nts,String wfstpId,String trackingStatus,String problemIdentified,String workType,String otherPID,boolean soldafter3PM,String cancelReason,Date cancelDate
                GA_WorkflowStpSaveCls.closeWorkflow(wfStepRec.id);
                GA_WorkflowStpSaveCls.fetchWfId(stepid, 'Test', false, 'SOLD', '(3-A) Invalid PID','QM','5-Z Rating Issue Other',false,'NA',corpRcvDate);
                //String wfstpId,String nts,Boolean chckCnl,String trackingStatus,String problemIdentified,String workType,String otherPID,boolean soldafter3PM,String cancelReason,Date cancelDate
                GA_WorkflowStpSaveCls.fieldVisibilty();
                Test.stopTest();
            }
            catch(exception e)
            {
                return;
            }
        }                   
    } 
        /*******************************************************************************************************************************
@Description: dataAccessUpdateCover() method 
@Name : dataAccessUpdateCover
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
    private static testMethod void dataAccessUpdateCover() {
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

                
                Account testAccount = GA_OBJ_TD01_TestDataCreation.AccRec();
                database.insert(testAccount);
                
                case cas=GA_OBJ_TD01_TestDataCreation.CaseRec();
                cas.recordtypeid=Schema.SObjectType.Case.getRecordTypeInfosByName().get('Support - Issues').getRecordTypeId();
                cas.AccountId = testAccount.id;
                cas.GA_IssuesCategory__c='Administration';
                database.insert(cas);
                List<GA_WF_Workflow__c> WfList = New List<GA_WF_Workflow__c>();
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
                wfRec.GA_Notes__c='Notes Test';
                WfList.add(wfRec);
                //database.insert(WfList);
                    
                Test.startTest();
                GA_Util03_WrkflwDataAccessHelper.dmlOnwrkflw(WfList, GA_Util03_WrkflwDataAccessHelper.UPDATE_OPERATION);
                Test.stopTest();
            }
            catch(exception e)
            {
                return;
            }
        }                   
    } 
private static testmethod void fetchwrkStpExcp()
{
    user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestSysAdm','testsysadm@bcbsm.com','System Administrator');
    insert usr;
    system.runAs(usr)
    {
        try
        {
            Test.startTest();
            GA_WorkflowStpSaveCls.fetchwrkStpDetails(null);
            
            Test.stopTest();
        }
        catch(exception e)
        {
            return;
        }
    }
}
    private static testmethod void validationChkExcp()
{
    user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestSysAdm','testsysadm@bcbsm.com','System Administrator');
    insert usr;
    system.runAs(usr)
    {
        try
        {
            Test.startTest();

            GA_WorkflowStpSaveCls.validationChk(null);
            
            Test.stopTest();
        }
        catch(exception e)
        {
            return;
        }
    }
}
    private static testmethod void updateWFStepExcp()
{
    user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestSysAdm','testsysadm@bcbsm.com','System Administrator');
    insert usr;
    system.runAs(usr)
    {
        try
        {
            Test.startTest();

            GA_WorkflowStpSaveCls.updateWFStep(null, null);
            
            Test.stopTest();
        }
        catch(exception e)
        {
            return;
        }
    }
}
    private static testmethod void completeCurrentStepExcp()
{
    user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestSysAdm','testsysadm@bcbsm.com','System Administrator');
    insert usr;
    system.runAs(usr)
    {
        try
        {
            Test.startTest();
            
            GA_WorkflowStpSaveCls.completeCurrentStep(null, null, null, null,null,null,false,null,null);
            
            Test.stopTest();
        }
        catch(exception e)
        {
            return;
        }
    }
}
    private static testmethod void clsWrkflwExcp()
{
    user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestSysAdm','testsysadm@bcbsm.com','System Administrator');
    insert usr;
    system.runAs(usr)
    {
        try
        {
            Test.startTest();
           
            GA_WorkflowStpSaveCls.closeWorkflow(null);

            Test.stopTest();
        }
        catch(exception e)
        {
            return;
        }
    }
}
    private static testmethod void fetchWfExcp()
{
    user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestSysAdm','testsysadm@bcbsm.com','System Administrator');
    insert usr;
    system.runAs(usr)
    {
        try
        {
            Test.startTest();

            GA_WorkflowStpSaveCls.fetchWfId(null, null, null, null, null,null,null,false,null,null);
            Test.stopTest();
        }
        catch(exception e)
        {
            return;
        }
    }
}
}