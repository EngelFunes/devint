/*
@Author : IDC offshore
@Name: GA_AP_PostUnpostCls_Test 
@CreatedDate: 25 Feb 2019
@Description: GA_AP_PostUnpostCls_Test Test class
@version : 1.0  
*/
@isTest
private  class GA_ACC_AccStatusWFVldtnCls_Test {
    /**
@Description: AccStatusVldtn() method 
@Name : AccStatusVldtn
@Param : N/A
@Return : void
@throws Exception : N/A;
*/  
    public static testmethod void AccStatusVldtn()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestGrpSgmtrelatLst','testsystemadminstrator@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {
            try {
                Map<id,Account> AccOldMp = new Map<id,Account>();
                
                Account acc=GA_OBJ_TD01_TestDataCreation.AccRec();
                acc.Account_Status__c = 'Active';
                database.insert(acc);
                
                AccOldMp.put(acc.id, acc);
                
                case cas=GA_OBJ_TD01_TestDataCreation.CaseRec();
                cas.recordtypeid=Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('GA_Support_Issues').getRecordTypeId();
                //cas.recordtypeid=Schema.SObjectType.Case.getRecordTypeInfosByName().get('Support - Issues').getRecordTypeId();
                cas.AccountId = acc.id;
                cas.GA_IssuesCategory__c='Administration';
                database.insert(cas);
                
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
                wfRec.GA_Account__c = acc.id;
                wfRec.GA_Support__c = cas.id;
                wfRec.GA_Carrier__c = wfTemp.GA_Carrier__c;
                wfRec.GA_Method__c = wfTemp.GA_Method__c;
                wfRec.Sub_Type__c = wfTemp.GA_Process_Subtype__c;
                wfRec.GA_Type__c=wfTemp.GA_Process_Type__c;
                wfRec.GA_Status__c = 'Open';
                wfRec.GA_Workflow_Template__c =wfTemp.id;
                database.insert(wfRec);
                
                acc.GA_Is_Mass_Updating__c = true; 
                GA_AccountTriggerHandlr.isExecuting = false;
                acc.Account_Status__c = 'Inactive';
                database.update(acc); 
                
                
            }
            catch(exception e)
            {
                return;
            }
        }
        
    }
    /**
@Description: AccStatusVldtnCatch() method 
@Name : AccStatusVldtnCatch
@Param : N/A
@Return : void
@throws Exception : N/A;
*/  
    public static testmethod void AccStatusVldtnCatch()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestGrpSgmtrelatLst','testsystemadminstrator@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {
            try {
                test.startTest();
                GA_ACC_AccStatusWFVldtnCls.valdteInctvStatus(null,null);
                test.stopTest();
            }
            catch(exception e)
            {
                return;
            }
        }
        
    }
}