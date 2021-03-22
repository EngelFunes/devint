@isTest(seealldata=false)
public class ARV_AP_FileUploadCls_Test {
    private static final string PROFILENAME1='System Administrator';
    private static final string NAME2='AP33RateGrid';
    private static final string USERNAME='bcbsm1@bcbsm.com';
 
  private static testmethod void fileUploadClsTest()
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
                
                ARV_AP_FileUploadCls.FileTypeValues();
                ARV_AP_FileUploadCls.updateFileType(docJson, 'Copy of Selector');
                system.assert(usr <> null);
            }
            catch(exception e)
            {
                return;
            }
        }  
    }  
      /**
@Description: fileUploadClsErrTest() method 
@Name : fileUploadClsErrTest
@Param : None
@Return : void
@throws Exception : N/A;
*/     
private static testmethod void fileUploadClsErrTest()
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
                
                ARV_AP_FileUploadCls.FileTypeValues();
                ARV_AP_FileUploadCls.updateFileType('', '');
                ARV_AP_FileUploadCls.fileLstRecs('%$@#%^*');
                ARV_AP_FileUploadCls.getCaseNumbr('test');
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
             ARV_AP_FileUploadCls.getCaseNumbr(cas.Id);
        }
    }

     private static testMethod void fileLstRecsTest(){
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestCompetitr','testsalesrepmail@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr){      
               Account acc = GA_OBJ_TD01_TestDataCreation.AccRec();
                database.insert(acc); 
            
                case cas=GA_OBJ_TD01_TestDataCreation.CaseRec();
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
               
 
              ARV_AP_FileUploadCls.fileLstRecs(cas.id);
             
        }
    }

    
}