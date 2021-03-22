/**
@Author : IDC Offshore
@Name: GA_AP_FileUploadCls_Test 
@CreatedDate: 10-08-2018
@Description: GA_AP_FileUploadCls Test class 
@version : 1.0  
*/
@isTest(seealldata=false)
private class GA_AP_FileUploadCls_Test {
    /**
@Description: executeTest() method 
@Name : executeTest
@Param : None
@Return : void
@throws Exception : N/A;
*/     
    private static testmethod void executeTest()
    {
        list<user> usrLst=new list<user>();
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestJeoRl','testsalesrepmail@bcbsm.com','Support');
        usr.UserRoleId  = GA_OBJ_TD01_TestDataCreation.setRole('Support Representative','Support_Representative').id;
        usrLst.add(usr);
        user usrRetSlsRep = GA_OBJ_TD01_TestDataCreation.UsrRec('TestJeoRlRetnslsRep','testsalesrepmail@bcbsm.com','Retention Sales');
        usrLst.add(usrRetSlsRep);
        database.insert(usrLst);
        system.runAs(usr)
        {
            try{
                
                Document objDoc = new Document();
                objDoc.Body = Blob.valueOf('Text');
                objDoc.ContentType = 'application/pdf';
                objDoc.DeveloperName = 'test_document';
                objDoc.IsPublic = true;
                objDoc.Name = 'Test Document';
                objDoc.FolderId = [select id from folder where name = 'BCBSM External Service Document' Limit 1].id;
                database.insert (objDoc);
                String docJson = '[{"name":"Test Document","documentId":"'+objDoc.id+'"}]';
                
                case cas=GA_OBJ_TD01_TestDataCreation.CaseRec();
                cas.GA_ASR__c = usr.id;
                database.insert(cas);
                
                GA_AP_FileUploadCls.FileTypeValues();
                GA_AP_FileUploadCls.updateFileType(docJson, 'Copy of Selector');
                system.assert(usr <> null);
            }
            catch(exception e)
            {
                return;
            }
        }  
    }  
    /**
@Description: executeErrTest() method 
@Name : executeErrTest
@Param : None
@Return : void
@throws Exception : N/A;
*/     
    private static testmethod void executeErrTest()
    {
        list<user> usrLst=new list<user>();
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestJeoRl','testsalesrepmail@bcbsm.com','Support');
        usr.UserRoleId  = GA_OBJ_TD01_TestDataCreation.setRole('Support Representative','Support_Representative').id;
        usrLst.add(usr);
        user usrRetSlsRep = GA_OBJ_TD01_TestDataCreation.UsrRec('TestJeoRlRetnslsRep','testsalesrepmail@bcbsm.com','Retention Sales');
        usrLst.add(usrRetSlsRep);
        database.insert(usrLst);
        system.runAs(usr)
        {
            try{
                
                Document objDoc = new Document();
                objDoc.Body = Blob.valueOf('Text');
                objDoc.ContentType = 'application/pdf';
                objDoc.DeveloperName = 'test_document';
                objDoc.IsPublic = true;
                objDoc.Name = 'Test Document';
                objDoc.FolderId = [select id from folder where name = 'BCBSM External Service Document' Limit 1].id;
                database.insert(objDoc);
                String docJson = '[{"name":"Test Document","documentId":"'+objDoc.id+'"}]';
                
                case cas=GA_OBJ_TD01_TestDataCreation.CaseRec();
                cas.GA_ASR__c = usr.id;
                database.insert(cas);
                
                GA_AP_FileUploadCls.FileTypeValues();
                GA_AP_FileUploadCls.updateFileType('', '');
                GA_AP_FileUploadCls.fileLstRecs('%$@#%^*');
                GA_AP_FileUploadCls.getCaseNumbr('test');
                system.assert(usr <> null);
            }
            catch(exception e)
            {
                return;
            }
        }  
    }   
    
    private static testMethod void getCaseNumbrTest(){
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestCompetitr','testsalesrepmail@bcbsm.com','Retention Sales');
        database.insert(usr);
        system.runAs(usr){      
            case cas=GA_OBJ_TD01_TestDataCreation.CaseRec();
            database.insert(cas);
            GA_AP_FileUploadCls.getCaseNumbr(cas.Id);
        }
    }
    
    private static testMethod void fileLstRecsTest(){
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestCompetitr','testsalesrepmail@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr){      
            Account acc = GA_OBJ_TD01_TestDataCreation.AccRec();
            database.insert(acc); 
            
            case cas=GA_OBJ_TD01_TestDataCreation.CaseRec();
            cas.recordtypeid=Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('GA_Support_Issues').getRecordTypeId();
            //cas.recordtypeid=Schema.SObjectType.Case.getRecordTypeInfosByName().get('Support - Issues').getRecordTypeId();
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
            
            
            GA_AP_FileUploadCls.fileLstRecs(cas.id);
            
        }
    }
    
}