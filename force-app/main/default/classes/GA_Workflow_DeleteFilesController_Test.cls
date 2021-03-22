/*******************************************************************************************************************************
@Author : IDC offshore
@Name: GA_Workflow_DeleteFilesController_Test
@CreatedDate: 21 - Aug 2019 
@Description: GA_Workflow_DeleteFilesController_Test class is for GA_Workflow_DeleteFilesController.
@version : 1.0  
********************************************************************************************************************************/
@isTest(seealldata=false)
private class GA_Workflow_DeleteFilesController_Test {
    /*******************************************************************************************************************************
@Description: SupRqFileDeleteTst() method 
@Name : SupRqFileDeleteTst
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
    private static testmethod void SupRqFileDeleteTst(){
        user usrSA = GA_OBJ_TD01_TestDataCreation.UsrRec('System Administrator','testsystemadminstrator@bcbsm.com','System Administrator');
        database.insert(usrSA);
        system.runAs(usrSA)
        {
            try{
                Account acc = GA_OBJ_TD01_TestDataCreation.AccRec();
                database.insert(acc);
                
                GA_WFT_workflow__c wfTemp = GA_OBJ_TD01_TestDataCreation.wrkFlwTmplt();
                database.insert(wfTemp);
                
                GA_WF_Workflow__c wfRec = New GA_WF_Workflow__c();
                wfRec.GA_Account__c = acc.id;
                wfRec.GA_Carrier__c = wfTemp.GA_Carrier__c;
                wfRec.GA_Method__c = wfTemp.GA_Method__c;
                wfRec.Sub_Type__c = wfTemp.GA_Process_Subtype__c;
                wfRec.GA_Type__c=wfTemp.GA_Process_Type__c;
                wfRec.GA_Status__c = 'Closed';
                wfRec.GA_Workflow_Template__c =wfTemp.id;
                database.insert(wfRec);                
           
                ContentVersion cntvs = new ContentVersion();
                cntvs.Title = 'TestCV';
                cntvs.PathOnClient = 'TestCV.jpg';
                cntvs.VersionData = Blob.valueOf('Test Content');
                cntvs.IsMajorVersion = true;
                cntvs.GA_Type__c ='Email';
                Database.insert(cntvs) ;
                
                ContentVersion contentVersionSelect = [SELECT Id, Title, ContentDocumentId FROM ContentVersion WHERE Id = :cntvs.Id LIMIT 1];
                
                List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument Limit 200];
                
                
                ContentDocumentLink cdl = New ContentDocumentLink();
                cdl.LinkedEntityId = wfRec.id;
                cdl.ContentDocumentId = documents[0].Id;
                cdl.shareType = 'V';
                Database.insert(cdl);
                
                String filerecords = '[{"fileCreatedDate":"2019-04-08T13:18:45.000Z","fileDocId":"'+cntvs.Id+'","fileTitle":"sdf (1)","isSelected":true}]';
                
                Test.StartTest();
                GA_Workflow_DeleteFilesController.workFlowLst(wfRec.id);
                GA_Workflow_DeleteFilesController.processSelectedRecords(filerecords,wfRec.id);
                Test.StopTest(); 
                
                system.assert(wfRec <> null);
            }
            catch(exception e)
            {
                return;
            } 
        }
    }
    /*******************************************************************************************************************************
@Description: SMARTSupRqFile() method 
@Name : SupRqFileDeleteTst
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
    private static testmethod void SMARTSupRqFile(){
        user usrSA = GA_OBJ_TD01_TestDataCreation.UsrRec('System Administrator','testsystemadminstrator@bcbsm.com','System Administrator');
        database.insert(usrSA);
        system.runAs(usrSA)
        {
            try{
                Account acc = GA_OBJ_TD01_TestDataCreation.AccRec();
                database.insert(acc);
                
                GA_WFT_workflow__c wfTemp = GA_OBJ_TD01_TestDataCreation.wrkFlwTmplt();
                database.insert(wfTemp);
                
                GA_WF_Workflow__c wfRec = New GA_WF_Workflow__c();
                wfRec.GA_Account__c = acc.id;
                wfRec.GA_Carrier__c = wfTemp.GA_Carrier__c;
                wfRec.GA_Method__c = wfTemp.GA_Method__c;
                wfRec.Sub_Type__c = wfTemp.GA_Process_Subtype__c;
                wfRec.GA_Type__c=wfTemp.GA_Process_Type__c;
                wfRec.GA_Status__c = 'Canceled';
                wfRec.GA_Workflow_Template__c =wfTemp.id;
                database.insert(wfRec);                
           
                ContentVersion cntvs = new ContentVersion();
                cntvs.Title = 'TestCV';
                cntvs.PathOnClient = 'TestCV.jpg';
                cntvs.VersionData = Blob.valueOf('Test Content');
                cntvs.IsMajorVersion = true;
                cntvs.GA_Type__c ='Email';
                Database.insert(cntvs) ;
                
                ContentVersion contentVersionSelect = [SELECT Id, Title, ContentDocumentId FROM ContentVersion WHERE Id = :cntvs.Id LIMIT 1];
                
                List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument Limit 200];
                
                
                ContentDocumentLink cdl = New ContentDocumentLink();
                cdl.LinkedEntityId = wfRec.id;
                cdl.ContentDocumentId = documents[0].Id;
                cdl.shareType = 'V';
                Database.insert(cdl);
                
                String filerecords = '[{"fileCreatedDate":"2019-04-08T13:18:45.000Z","fileDocId":"'+cntvs.Id+'","fileTitle":"sdf (1)","isSelected":true}]';
                
                Test.StartTest();
                GA_Workflow_DeleteFilesController.workFlowLst(wfRec.id);
                GA_Workflow_DeleteFilesController.processSelectedRecords(filerecords,wfRec.id);
                Test.StopTest(); 
                
                system.assert(wfRec <> null);
            }
            catch(exception e)
            {
                return;
            } 
        }
    }
}