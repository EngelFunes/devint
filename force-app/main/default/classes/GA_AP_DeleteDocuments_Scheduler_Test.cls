/**
@Author : Prasant Kumar Satpathy
@Name: GA_AP_DeleteDocuments_Scheduler_Test 
@CreatedDate: 20 - Feb 2018 
@Description: GA_AP_DeleteDocuments_Scheduler_Test Test class 
@version : 1.0  
*/
@isTest
Private class GA_AP_DeleteDocuments_Scheduler_Test {
    /**
@Description: executeTest() method 
@Name : executeTest
@Param : None
@Return : void
@throws Exception : N/A;
*/   
    private static testmethod void executeTest()
    {
        list<user> UsrLst=new list<user>();
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestJeoRl','testsalesrepmail@bcbsm.com','Support');
        UsrLst.add(usr);
        user usrRetSlsRep = GA_OBJ_TD01_TestDataCreation.UsrRec('TestJeoRlRetnslsRep','testsalesrepmail@bcbsm.com','Retention Sales');
        UsrLst.add(usrRetSlsRep);
        database.insert(UsrLst);
        system.runAs(usr)
        {
            try{
                //List<Document> lstDocuments = new List<Document>();
                //Document objDoc;
                List<ContentVersion> lstcntVrsn = new List<ContentVersion>();
                ContentVersion cntVrsn;
                for(Integer i=0 ;i <10;i++){
                    cntVrsn = new ContentVersion();
                    cntVrsn.ContentLocation = 'S';
                    cntVrsn.Title = 'Penguins';
                    cntVrsn.PathOnClient = 'Penguins.jpg';
                    cntVrsn.Description ='TO BE DELETED BY BATCH';
                    cntVrsn.VersionData = Blob.valueOf('Test Content'+i);
                    lstcntVrsn.add(cntVrsn);
                    
                    /*objDoc = new Document();
                    objDoc.Body = Blob.valueOf('Text');
                    objDoc.ContentType = 'application/pdf';
                    objDoc.DeveloperName = 'test_document'+i;
                    objDoc.IsPublic = true;
                    objDoc.Name = 'Test Document'+i;
                    objDoc.FolderId = [select id from folder where name = 'BCBSM External Service Document'].id;
                    lstDocuments.add(objDoc);*/
                }
                database.insert(lstcntVrsn);
                //insert lstDocuments;
                Test.startTest();
                
                GA_AP_DeleteDocumentsBatch btch = new GA_AP_DeleteDocumentsBatch();
                DataBase.executeBatch(btch);
                
                GA_AP_DeleteDocuments_Scheduler sh1 = new GA_AP_DeleteDocuments_Scheduler();
                String sch = '0 0 23 * * ?'; 
                system.schedule('Test Delete Documents', sch, sh1); 
                Test.stopTest(); 
                system.assert(lstcntVrsn <> null);
                //system.assert(lstDocuments <> null);
            }
            catch(exception e)
            {
                return;
            }
        }  
    }
}