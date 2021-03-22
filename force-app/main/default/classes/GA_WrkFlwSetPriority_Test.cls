/*
@Author : IDC Offshore
@Name: GA_WrkFlwSetPriority_Test 
@CreatedDate: 9 - Oct 2018 
@Description: GA_WrkFlwSetPriority Test class
@version : 1.0  
*/
@isTest
private class GA_WrkFlwSetPriority_Test 
{
/**
@Description: SetPrtySupport() method 
@Name : SetPrtySupport
@Param : N/A   
@Return : void
@throws Exception : N/A;
*/        
    private static testmethod void SetPrtySupport()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('Support Manager','testSupMngr@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {
            try {
                Account acc=GA_OBJ_TD01_TestDataCreation.AccRec();
                database.insert(acc);
                GA_Group_Segment__c gsRec = GA_OBJ_TD01_TestDataCreation.grpSegmntRec(acc);
                database.insert(gsRec);
                gsRec.GA_Quote_ID__c='12';
                gsRec.Status__c='Active';
                database.update(gsRec);
                Case cse = GA_OBJ_TD01_TestDataCreation.CaseRec();
                database.insert(cse); 
                GA_WFT_workflow__c wftmpltRec = GA_OBJ_TD01_TestDataCreation.wrkFlwTmplt();
                database.insert(wftmpltRec);
                GA_WF_Workflow__c wfRec = GA_OBJ_TD01_TestDataCreation.createWrkFlw(acc, cse, wftmpltRec, usr);
                database.insert(wfRec);
                GA_WF_Step__c wfstpRec = GA_OBJ_TD01_TestDataCreation.wrkFlwStp(WfRec);
                database.insert(wfstpRec); 
                GA_WF_Group_Segment__c wfpRec = GA_OBJ_TD01_TestDataCreation.wrkFlwGs(gsRec, wfstpRec);
                database.insert(wfpRec);
                wfstpRec.GA_Notes__c= 'done';
                database.update(wfstpRec); 
                test.startTest();
                system.debug('test'+UserInfo.getOrganizationId());
                insert new GA_Workflow_Priority__c(SetupOwnerId=UserInfo.getOrganizationId(), 	GA_Priority__c=true);
                boolean setPriorityCheck = GA_WrkFlwSetPriority.setPriority();
                test.stopTest();
            }
            
            catch(exception e)
            {
                return;
            }
        }
    }
/**
@Description: SetPrtySupNoAccess() method 
@Name : SetPrtySupNoAccess
@Param : N/A   
@Return : void
@throws Exception : N/A;
*/  
    private static testmethod void SetPrtySupNoAccess()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('SupportManager','testSupMngr@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {
            try {
                Account acc=GA_OBJ_TD01_TestDataCreation.AccRec();
                database.insert(acc);
                GA_Group_Segment__c gsRec = GA_OBJ_TD01_TestDataCreation.grpSegmntRec(acc);
                database.insert(gsRec);
                gsRec.GA_Quote_ID__c='12';
                gsRec.Status__c='Active';
                database.update(gsRec);
                Case cse = GA_OBJ_TD01_TestDataCreation.CaseRec();
                database.insert(cse); 
                GA_WFT_workflow__c wftmpltRec = GA_OBJ_TD01_TestDataCreation.wrkFlwTmplt();
                database.insert(wftmpltRec);
                GA_WF_Workflow__c wfRec = GA_OBJ_TD01_TestDataCreation.createWrkFlw(acc, cse, wftmpltRec, usr);
                database.insert(wfRec);
                GA_WF_Step__c wfstpRec = GA_OBJ_TD01_TestDataCreation.wrkFlwStp(WfRec);
                database.insert(wfstpRec); 
                GA_WF_Group_Segment__c wfpRec = GA_OBJ_TD01_TestDataCreation.wrkFlwGs(gsRec, wfstpRec);
                database.insert(wfpRec);
                wfstpRec.GA_Notes__c= 'done';
                database.update(wfstpRec); 
                GA_Workflow_Priority__c wfpcs =new GA_Workflow_Priority__c();
                wfpcs.GA_Priority__c = False;
                wfpcs.SetupOwnerId=usr.ProfileId;
                insert wfpcs;
                test.startTest();
                boolean setPriorityCheck = GA_WrkFlwSetPriority.setPriority();
                test.stopTest();
            }
            catch(exception e)
            {
                return;
            }
        }
    }
 /**
@Description: SetPrtyCatch() method 
@Name : SetPrtyCatch
@Param : N/A   
@Return : void
@throws Exception : N/A;
*/  
    private static testmethod void SetPrtyCatch()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('BCNUnderwriter','testSupMngr@bcbsm.com','BCBSM Read Only');
        database.insert(usr);
        system.runAs(usr)
        {
            try {
            
                 GA_WrkFlwSetPriority.wrkFlwPrity = null;
                test.startTest();
                boolean setPriorityCheck = GA_WrkFlwSetPriority.setPriority();
                test.stopTest();
           }
            catch(exception e)
            {
                return;
            }
        }
    }   
}