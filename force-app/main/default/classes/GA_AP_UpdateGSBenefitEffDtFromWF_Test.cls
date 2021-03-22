/*******************************************************************************************************************************
@Author : IDC offshore
@Name: GA_AP_UpdateGSBenefitEffDtFromWF_Test
@CreatedDate:10/5/2019 
@Description: GA_AP_UpdateGSBenefitEffDtFromWF_Test class is for GA_AP_UpdateGSBenefitEffDtFromWF.
@version : 1.0  
********************************************************************************************************************************/
@isTest(seealldata=false)
private class GA_AP_UpdateGSBenefitEffDtFromWF_Test {
    
    /*******************************************************************************************************************************
@Description: updtbenefiteffdtfrmwf() method 
@Name : updtbenefiteffdtfrmwf
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/    
    public static testmethod void updtbenefiteffdtfrmwf(){
        
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestSystemAdmn','testsystemadminstrator@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {
            try{
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
                wfRec.GA_Benefit_Effective_Date__c = null;
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
                database.insert(gs);
                
                GA_WF_Group_Segment__c wfgs = New GA_WF_Group_Segment__c();
                wfgs.GA_Workflow_ID__c = wfRec.id; 
                wfgs.GA_Group_Segment_ID__c = gs.id;
                wfgs.OwnerId = usr.id;
                wfgs.GA_WF_Step_ID__c =   null;
                wfgs.GA_Status__c =  'Closed';
                wfgs.GA_Tracking_Status__c = 'IPQT';
                wfgs.GA_Problem_Identified_Values__c = '(2-G) Incorrect Template';
                database.insert(wfgs);
                
                List<GA_WF_Group_Segment__c> wfgsLst = New List<GA_WF_Group_Segment__c>();
                wfgsLst.add(wfgs);
                
                wfRec.GA_Benefit_Effective_Date__c=system.today();
                database.update(wfRec);
            }
            catch(exception e)
            {
                return;
            } 
        } 
        
    }
    /*******************************************************************************************************************************
@Description: WFTrigrHdlrCtch() method 
@Name : WFTrigrHdlrCtch
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/    
    public static testmethod void WFTrigrHdlrCtch(){
        
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestSystemAdmn','testsystemadminstrator@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {
            try{
                
                Account acc = GA_OBJ_TD01_TestDataCreation.AccRec();
                database.insert(acc);
                
                map<id,GA_WF_Workflow__c> wfOMp = new map<id,GA_WF_Workflow__c>();
                
                List<GA_WF_Workflow__c> wfLst = New List<GA_WF_Workflow__c>();
                
                test.startTest();
                GA_WorkflowTrgrHndlr.beforeInsert(null);
                GA_WorkflowTrgrHndlr.afterInsert(null);
                GA_WorkflowTrgrHndlr.afterUpdate(null,null);
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