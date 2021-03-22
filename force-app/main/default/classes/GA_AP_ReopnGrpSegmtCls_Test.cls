/*******************************************************************************************************************************
@Author : IDC offshore
@Name: WorkflowController_Test
@CreatedDate: 17 - April 2018 
@Description: GA_AP_ReopnGrpSegmtCls_Test class is for GA_AP_ReopnGrpSegmtCls.
@version : 1.0  
********************************************************************************************************************************/
@isTest(seealldata=false)
private class GA_AP_ReopnGrpSegmtCls_Test {    
    /*******************************************************************************************************************************
@Description: addGrpSegmentToWf() method 
@Name : addGrpSegmentToWf
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
    private static testMethod void addGrpSegmentToWf() {
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
                
                List<GA_WFT_Inventory_Step__c> wfInvStpsLst = New List<GA_WFT_Inventory_Step__c>();
                GA_WFT_Inventory_Step__c wfInvStp = GA_OBJ_TD01_TestDataCreation.wfInventoryStp();
                wfInvStp.name = 'Small Group Underwriting - to Review';
                wfInvStpsLst.add(wfInvStp);
                
                GA_WFT_Inventory_Step__c comwfInvStp = GA_OBJ_TD01_TestDataCreation.wfInventoryStp();
                comwfInvStp.name = 'Completed';
                wfInvStpsLst.add(comwfInvStp);
                database.insert(wfInvStpsLst);
                
                List<GA_WFT_Step__c> wftSptsLst = New  List<GA_WFT_Step__c>(); 
                GA_WFT_Step__c wftStp = GA_OBJ_TD01_TestDataCreation.wrkTmpStp(wfTemp,wfInvStp);
                wftStp.GA_First_Step__c=true;
                wftSptsLst.add(wftStp); 
                GA_WFT_Step__c complwftStp = GA_OBJ_TD01_TestDataCreation.wrkTmpStp(wfTemp,comwfInvStp);
                wftSptsLst.add(complwftStp); 
                database.insert(wftSptsLst); 
                
                GA_WFT_Allowed_Next_Step__c wftNxtStp = GA_OBJ_TD01_TestDataCreation.wfAlwdNxtStp(wftStp);
                wftNxtStp.GA_Allowed_Next_Step__c = complwftStp.Id;
                database.insert(wftNxtStp);
                
                Account testAccount = GA_OBJ_TD01_TestDataCreation.AccRec();
                database.insert(testAccount);
                
                case cas=GA_OBJ_TD01_TestDataCreation.CaseRec();
                cas.recordtypeid=Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('GA_Support_Issues').getRecordTypeId();
                //cas.recordtypeid=Schema.SObjectType.Case.getRecordTypeInfosByName().get('Support - Issues').getRecordTypeId();
                cas.AccountId = testAccount.id;
                cas.GA_IssuesCategory__c='Administration';
                database.insert(cas);
                
                List<GA_Group_Segment__c> gsLst = new List<GA_Group_Segment__c>(); 
                GA_Group_Segment__c grpSgmntRec=GA_OBJ_TD01_TestDataCreation.grpSegmntRec(testAccount);
                grpSgmntRec.GA_Carrier__c = 'BCBSM';
                grpSgmntRec.GA_Quote_ID__c='123';
                gsLst.add(grpSgmntRec);
                GA_Group_Segment__c grpSgmntRec1=GA_OBJ_TD01_TestDataCreation.grpSegmntRec(testAccount);
                grpSgmntRec1.GA_In_Progress__c=true;
                 grpSgmntRec.GA_Carrier__c = 'BCBSM';
                gsLst.add(grpSgmntRec1);
                
                database.insert(gsLst);
                
                GA_WF_Workflow__c wfRec = New GA_WF_Workflow__c();
                wfRec.GA_Account__c = testAccount.id;
                wfRec.GA_Support__c=cas.Id;
                wfRec.GA_Carrier__c = wfTemp.GA_Carrier__c;
                wfRec.GA_Method__c = wfTemp.GA_Method__c;
                wfRec.Sub_Type__c = wfTemp.GA_Process_Subtype__c;
                wfRec.GA_Type__c=wfTemp.GA_Process_Type__c;
                wfRec.GA_Status__c = 'Open';
                wfRec.GA_Workflow_Template__c =wfTemp.id;
                database.insert(wfRec);
                
                List<GA_WF_Step__c> wfSStepsLst = New List<GA_WF_Step__c>();
                
                GA_WF_Step__c wfStepRec = New  GA_WF_Step__c();
                wfStepRec.Name = wfInvStp.Name;
                wfStepRec.GA_Status__c = 'Closed';
                wfStepRec.GA_WF_Template_Step__c = wftStp.id;
                wfStepRec.GA_WF_Workflow_ID__c = wfRec.id;
                wfStepRec.GA_Workflow_Template_Id__c=wfRec.GA_Workflow_Template__c;
                wfStepRec.GA_Notes__c = 'Test';
                wfStepRec.OwnerId = usr.id;
                wfSStepsLst.add(wfStepRec);
                
                GA_WF_Step__c ComplwfStepRec = New  GA_WF_Step__c();
                 ComplwfStepRec.Name = comwfInvStp.Name;
                ComplwfStepRec.GA_Status__c = 'Closed';
                ComplwfStepRec.GA_WF_Template_Step__c = complwftStp.id;
                ComplwfStepRec.GA_WF_Workflow_ID__c = wfRec.id;
                ComplwfStepRec.GA_Workflow_Template_Id__c=wfRec.GA_Workflow_Template__c;
                ComplwfStepRec.GA_Notes__c = 'Test';
                ComplwfStepRec.OwnerId = usr.id;
                wfSStepsLst.add(ComplwfStepRec);
                
                database.insert(wfSStepsLst);
                
                List<GA_WF_Group_Segment__c> wfGsLst = New  List<GA_WF_Group_Segment__c> ();
                 GA_WF_Group_Segment__c wfgs1 = New GA_WF_Group_Segment__c();
                wfgs1.GA_WF_Step_ID__c =   wfStepRec.id;
                wfgs1.GA_Workflow_ID__c = wfRec.id;  
                wfgs1.GA_Group_Segment_ID__c = grpSgmntRec.id;
                wfgs1.OwnerId = userinfo.getUserId();
                wfgs1.GA_Workflow_Next_Step__c = ComplwfStepRec.id;
                wfgs1.GA_Status__c = 'Closed';
                wfGsLst.add(wfgs1);
                
                GA_WF_Group_Segment__c wfgs2 = New GA_WF_Group_Segment__c();
                wfgs2.GA_WF_Step_ID__c =   ComplwfStepRec.id;
                wfgs2.GA_Workflow_ID__c = wfRec.id;  
                wfgs2.GA_Group_Segment_ID__c = grpSgmntRec.id;
                wfgs2.OwnerId = userinfo.getUserId();
           
                wfgs2.GA_Status__c = 'Closed';
                  wfGsLst.add(wfgs2);
                database.insert(wfGsLst);
                 system.debug(wfSStepsLst.size());
                system.debug(wfGsLst.size());
          
               GA_AP_ReopnGrpSegmtCls.wrkFlwInfo(wfRec.id);
               GA_AP_ReopnGrpSegmtCls.reopnWrkFlwGrps(wfRec.id,'reopen',New List<String>{grpSgmntRec.id});
              
                
                system.assert(wfRec <> null);
            }
            catch(exception e)
            {
                return;
            }
        }					
    } 
    
          
}