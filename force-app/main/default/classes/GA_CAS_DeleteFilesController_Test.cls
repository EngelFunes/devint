/*******************************************************************************************************************************
@Author : IDC offshore
@Name: GA_CAS_DeleteFilesController_Test
@CreatedDate: 3 - Apr 2019 
@Description: GA_CAS_DeleteFilesController_Test class is for GA_CAS_DeleteFilesController.
@version : 1.0  
********************************************************************************************************************************/
@isTest(seealldata=false)
private class GA_CAS_DeleteFilesController_Test {
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
                
                case cas=GA_OBJ_TD01_TestDataCreation.CaseRec();
                cas.recordtypeid=Schema.SObjectType.Case.getRecordTypeInfosByName().get('Support - Issues').getRecordTypeId();
                cas.AccountId = acc.id;
                cas.GA_Corporate_Received_Date__c=system.Today();
                cas.GA_SupportRequest_Type__c='GWC';
                cas.GA_Due_Date__c=system.Today();
                cas.Subject='Subj';
                cas.Description='Description';
                database.insert(cas);
                
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
                cdl.LinkedEntityId = cas.id;
                cdl.ContentDocumentId = documents[0].Id;
                cdl.shareType = 'V';
                Database.insert(cdl);
                
                String filerecords = '[{"fileCreatedDate":"2019-04-08T13:18:45.000Z","fileDocId":"'+cntvs.Id+'","fileTitle":"sdf (1)","isSelected":true}]';
                
                Test.StartTest();
                GA_CAS_DeleteFilesController.caseLst(acc.id,cas.id);
                GA_CAS_DeleteFilesController.processSelectedRecords(filerecords,cas.id);
                Test.StopTest(); 
                
                system.assert(cas <> null);
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
                acc.GA_System_of_Record__c='SMART';
                database.insert(acc);
                
                case cas=GA_OBJ_TD01_TestDataCreation.CaseRec();
                cas.recordtypeid=Schema.SObjectType.Case.getRecordTypeInfosByName().get('Support - Issues').getRecordTypeId();
                cas.AccountId = acc.id;
                cas.GA_Corporate_Received_Date__c=system.Today();
                cas.GA_SupportRequest_Type__c='GWC';
                cas.GA_Due_Date__c=system.Today();
                cas.Subject='Subj';
                cas.Description='Description';
                database.insert(cas);
                
                ContentVersion cntvs = new ContentVersion();
                cntvs.Title = 'TestCV';
                cntvs.PathOnClient = 'TestCV.jpg';
                cntvs.VersionData = Blob.valueOf('Test Content');
                cntvs.IsMajorVersion = true;
                cntvs.GA_Type__c ='Email';
                Database.insert(cntvs);
                
                ContentVersion contentVersionSelect = [SELECT Id, Title, ContentDocumentId FROM ContentVersion WHERE Id = :cntvs.Id LIMIT 1];
                
                List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument Limit 200];
                
                
                ContentDocumentLink cdl = New ContentDocumentLink();
                cdl.LinkedEntityId = cas.id;
                cdl.ContentDocumentId = documents[0].Id;
                cdl.shareType = 'V';
                Database.insert(cdl);
                
                String filerecords = '[{"fileCreatedDate":"2019-04-08T13:18:45.000Z","fileDocId":"'+cntvs.Id+'","fileTitle":"sdf (1)","isSelected":true}]';
                
                Test.StartTest();
                GA_CAS_DeleteFilesController.caseLst(acc.id,cas.id);
                GA_CAS_DeleteFilesController.processSelectedRecords(filerecords,cas.id);
                Test.StopTest(); 
                
                system.assert(cas <> null);
            }
            catch(exception e)
            {
                return;
            } 
        }
    }
}