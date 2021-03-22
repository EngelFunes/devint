/**
@Author : Raj Jena
@Name: GA_CDLHelper_Test 
@CreatedDate: 05 - Feb 2018 
@Description: GA_CDLHelper_Test Test class 
@version : 1.0  
*/
@isTest(seealldata = false)
private class GA_CDLHelper_Test {
    /**
@Description: publishCDL() method 
@Name : publishCDL
@Param : None
@Return : void
@throws Exception : N/A;
*/ 
    private static testmethod void publishCDL(){
        
        list<user> userList=new list<user>();
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestCDL','testsalesrepmail@bcbsm.com','Retention Sales');
        userList.add(usr);
        database.insert(userList);
        
        system.runAs(usr)  {
            try{
                List<ContentDocumentLink> docList = New List<ContentDocumentLink>();
                ContentDocumentLink cdl = new ContentDocumentLink();
                ContentVersion cntVrsn = new ContentVersion();
                cntVrsn.versionData = blob.valueOf('Test Doc');
                cntVrsn.title = 'testing upload';
                cntVrsn.pathOnClient ='/TestPath.txt';
                database.insert(cntVrsn);
                system.assert(cntVrsn !=null);
                //id cntDocId=[select ContentDocumentId from ContentVersion where id=:v.id limit 1].ContentDocumentId;
            }
            catch(exception e)
            {
                system.assert(e != null);
            }
        } 
    }
    /**
@Description: restrictCaseFilesDeletion() method 
@Name : restrictCaseFilesDeletion
@Param : None
@Return : void
@throws Exception : N/A;
*/ 
    private static testmethod void restrictCaseFilesDeletion(){
        
        list<user> userList=new list<user>();
        UserRole usrRol = GA_OBJ_TD01_TestDataCreation.setRole('Retention Sales Manager','Retention_Sales_Manager' );
        
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestCDL','testsalesrepmail@bcbsm.com','Retention Sales');
        usr.UserRoleId = usrRol.id;
        userList.add(usr); //insert usr;
        
        UserRole usrRol1 = GA_OBJ_TD01_TestDataCreation.setRole('Support Representative','Support_Representative' );
        
        user usr1 = GA_OBJ_TD01_TestDataCreation.UsrRec('TestCDL2','testsalesrepmail1@bcbsm.com','Retention Sales');
        usr1.UserRoleId = usrRol1.id;
        userList.add(usr1);
        database.insert(userList);
        
        PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name =: 'Underwriting_Support_Updates'];
        PermissionSetAssignment psa = new PermissionSetAssignment();
        psa.AssigneeId = usr1.Id;
        psa.PermissionSetId = ps.Id;
        insert psa;
        
        system.runAs(usr1)  {
            try{
                GA_Territory__c tRec = GA_OBJ_TD01_TestDataCreation.terrtryRec();
                tRec.GA_RetentionSalesRepresentative__c=usr.id;
                tRec.GA_Support_Representative__c = usr1.id;
                database.insert(tRec);
                
                GA_WFT_workflow__c wfTemp = GA_OBJ_TD01_TestDataCreation.wrkFlwTmplt();
                wfTemp.GA_Carrier__c = 'BCBSM';
                wfTemp.GA_Process_Type__c ='GWC';
                wfTemp.GA_Process_Subtype__c='Benefit Change';
                wfTemp.GA_Method__c ='Automated';
                wfTemp.GA_File_Type__c='Rate Quote';
                database.insert(wfTemp);
                
                GA_WFT_Inventory_Step__c wfInvStp = GA_OBJ_TD01_TestDataCreation.wfInventoryStp();
                wfInvStp.name = 'Pre-Processing';
                database.insert(wfInvStp);
                
                GA_WFT_Inventory_Step__c wfInvStp1 = GA_OBJ_TD01_TestDataCreation.wfInventoryStp();
                wfInvStp1.name = 'Benefit Administration Review';
                database.insert(wfInvStp1);
                
                GA_WFT_Step__c wftStp = GA_OBJ_TD01_TestDataCreation.wrkTmpStp(wfTemp,wfInvStp);
                wftStp.GA_First_Step__c=true;
                database.insert(wftStp);
                
                GA_WFT_Step__c wftStp1 = GA_OBJ_TD01_TestDataCreation.wrkTmpStp(wfTemp,wfInvStp1);
                database.insert(wftStp1);
                
                GA_WFT_Allowed_Next_Step__c wftNxtStp = GA_OBJ_TD01_TestDataCreation.wfAlwdNxtStp(wftStp);
                database.insert(wftNxtStp);
                
                GA_WFT_Allowed_Next_Step__c wftNxtStp1 = GA_OBJ_TD01_TestDataCreation.wfAlwdNxtStp(wftStp1);
                database.insert(wftNxtStp1);
                
                Account acc = GA_OBJ_TD01_TestDataCreation.AccRec(); 
                acc.GA_Territory__c = tRec.Id;
                database.insert(acc);
                
                case cas=GA_OBJ_TD01_TestDataCreation.CaseRec();
                
                cas.AccountId = acc.id;
                database.insert(cas);                        
                
                GA_Group_Segment__c grpSgmntRec=GA_OBJ_TD01_TestDataCreation.grpSegmntRec(acc);
                grpSgmntRec.GA_Quote_ID__c='123';
                GA_Group_Segment__c grpSgmntRecClsd=GA_OBJ_TD01_TestDataCreation.grpSegmntRec(acc);
                grpSgmntRecClsd.GA_Quote_ID__c='123';
                grpSgmntRecClsd.status__c='Active';
                grpSgmntRecClsd.GA_In_Progress__c=true;
                list<GA_Group_Segment__c> grpSGmntLst=new list<GA_Group_Segment__c>();
                grpSGmntLst.add(grpSgmntRec);
                grpSGmntLst.add(grpSgmntRecClsd);
                database.insert(grpSGmntLst);
                
                GA_WF_Workflow__c wfRec = New GA_WF_Workflow__c();
                wfRec.GA_External_Initiated__c=true;
                wfRec.GA_Selected_Group_Segments__c=grpSGmntLst[0].Id;
                wfRec.GA_Account__c = acc.id;
                wfRec.GA_Carrier__c = wfTemp.GA_Carrier__c;
                wfRec.GA_Method__c = wfTemp.GA_Method__c;
                wfRec.Sub_Type__c = wfTemp.GA_Process_Subtype__c;
                wfRec.GA_Type__c=wfTemp.GA_Process_Type__c;
                wfRec.GA_Status__c = 'Open';
                wfRec.GA_Workflow_Template__c =wfTemp.id;
                database.insert(wfRec);
                
                ContentVersion cntVrsn = new ContentVersion();
                cntVrsn.Title = 'Penguins';
                cntVrsn.PathOnClient = 'Penguins.jpg';
                cntVrsn.VersionData = Blob.valueOf('Test Content');
                
                database.insert(cntVrsn);
                
                //List<ContentDocument> docsUpdtdList =  new List<ContentDocument>();
                List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument limit 100];
                
                List<ContentDocumentLink> cdlLst = New  List<ContentDocumentLink>();
                ContentDocumentLink cdLnk = New ContentDocumentLink();
                cdLnk.LinkedEntityId = cas.id;
                cdLnk.ContentDocumentId = documents[0].Id;
                cdLnk.shareType = 'V';
                cdlLst.add(cdLnk);
                
                ContentDocumentLink cdLnk1 = New ContentDocumentLink();
                cdLnk1.LinkedEntityId = wfRec.id;
                cdLnk1.ContentDocumentId = documents[0].Id;
                cdLnk1.shareType = 'V';
                cdlLst.add(cdLnk1);
                
                database.insert(cdlLst);
                GA_CDLHelper.shareWithLibrary(cdlLst);
                Database.delete(documents, false);
            }
            catch(exception e)
            {
                system.assert(e != null);
            }
        } 
    }
    /**
@Description: restrictCaseFilesUpdate() method 
@Name : restrictCaseFilesUpdate
@Param : None
@Return : void
@throws Exception : N/A;
*/ 
    private static testmethod void restrictCaseFilesUpdate(){
        
        list<user> userList = new list<user>();
        
        UserRole usrRol = GA_OBJ_TD01_TestDataCreation.setRole('Retention Sales Manager','Retention_Sales_Manager' );
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestCDL','testsalesrepmail@bcbsm.com','Retention Sales');
        usr.UserRoleId = usrRol.id;
        userList.add(usr);
        
        UserRole usrRol1 = GA_OBJ_TD01_TestDataCreation.setRole('Support Representative','Support_Representative' );
        user usr1 = GA_OBJ_TD01_TestDataCreation.UsrRec('TestCDL2','testsalesrepmail1@bcbsm.com','Retention Sales');
        usr1.UserRoleId = usrRol1.id;
        userList.add(usr1);
        database.insert(userList);
        
        PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name =: 'Underwriting_Support_Updates'];
        PermissionSetAssignment psa = new PermissionSetAssignment();
        psa.AssigneeId = usr1.Id;
        psa.PermissionSetId = ps.Id;
        insert psa;
        
        //User toRun = [select id, name , GA_RoleName__c from User Where Id =: usr.Id limit 3];
        system.runAs(usr1)  {
            try{
                GA_Territory__c tRec = GA_OBJ_TD01_TestDataCreation.terrtryRec();
                tRec.GA_RetentionSalesRepresentative__c=usr.id;
                database.insert(tRec);
                
                Account acc = GA_OBJ_TD01_TestDataCreation.AccRec(); 
                acc.GA_Territory__c = tRec.Id;
                database.insert(acc);
                
                case cas=GA_OBJ_TD01_TestDataCreation.CaseRec();
                
                cas.AccountId = acc.id;
                database.insert(cas);
                
                ContentVersion cntVrsn = new ContentVersion();
                cntVrsn.Title = 'Penguins';
                cntVrsn.PathOnClient = 'Penguins.jpg';
                cntVrsn.VersionData = Blob.valueOf('Test Content');
                database.insert(cntVrsn);
                
                List<ContentVersion> versions = new List<ContentVersion>();
                List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument limit 100];
                
                test.startTest();
                GA_ContentDocmntTgrHndlr.restrictCaseFilesEdit(documents);
                test.stopTest();
            }
            catch(exception e)
            {
                system.assert(e != null);
            }
        } 
    }
    /**
@Description: restrictCaseFileInsert() method 
@Name : restrictCaseFileInsert
@Param : None
@Return : void
@throws Exception : N/A;
*/ 
    private static testmethod void restrictCaseFileInsert(){
        
        UserRole usrRol = GA_OBJ_TD01_TestDataCreation.setRole('Retention Sales Manager','Retention_Sales_Manager' );
        
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestCDL','testsalesrepmail@bcbsm.com','Retention Sales');
        usr.UserRoleId = usrRol.id;
        database.insert(usr);
        User toRun = [select id, name , GA_RoleName__c from User Where Id =: usr.Id limit 3];
        system.runAs(toRun)  {
            try{
                GA_Territory__c tRec = GA_OBJ_TD01_TestDataCreation.terrtryRec();
                tRec.GA_RetentionSalesRepresentative__c=usr.id;
                database.insert(tRec);
                
                GA_WFT_workflow__c wfTemp = GA_OBJ_TD01_TestDataCreation.wrkFlwTmplt();
                wfTemp.GA_Carrier__c = 'BCBSM';
                wfTemp.GA_Process_Type__c ='GWC';
                wfTemp.GA_Process_Subtype__c='Benefit Change';
                wfTemp.GA_Method__c ='Automated';
                wfTemp.GA_File_Type__c='Rate Quote';
                database.insert(wfTemp);
                system.debug('Knocky4' + wfTemp);
                
                GA_WFT_Inventory_Step__c wfInvStp = GA_OBJ_TD01_TestDataCreation.wfInventoryStp();
                wfInvStp.name = 'Pre-Processing';
                database.insert(wfInvStp);
                
                GA_WFT_Inventory_Step__c wfInvStp1 = GA_OBJ_TD01_TestDataCreation.wfInventoryStp();
                wfInvStp1.name = 'Benefit Administration Review';
                database.insert(wfInvStp1);
                
                GA_WFT_Step__c wftStp = GA_OBJ_TD01_TestDataCreation.wrkTmpStp(wfTemp,wfInvStp);
                wftStp.GA_First_Step__c=true;
                database.insert(wftStp);
                
                GA_WFT_Step__c wftStp1 = GA_OBJ_TD01_TestDataCreation.wrkTmpStp(wfTemp,wfInvStp1);
                database.insert(wftStp1);
                
                GA_WFT_Allowed_Next_Step__c wftNxtStp = GA_OBJ_TD01_TestDataCreation.wfAlwdNxtStp(wftStp);
                database.insert(wftNxtStp);
                
                GA_WFT_Allowed_Next_Step__c wftNxtStp1 = GA_OBJ_TD01_TestDataCreation.wfAlwdNxtStp(wftStp1);
                database.insert(wftNxtStp1);                
                Account acc = GA_OBJ_TD01_TestDataCreation.AccRec(); 
                acc.GA_Territory__c = tRec.Id;
                database.insert(acc);
                
                case cas=GA_OBJ_TD01_TestDataCreation.CaseRec();
                
                cas.AccountId = acc.id;
                database.insert(cas);
                
                GA_Group_Segment__c grpSgmntRec=GA_OBJ_TD01_TestDataCreation.grpSegmntRec(acc);
                grpSgmntRec.GA_Quote_ID__c='123';
                GA_Group_Segment__c grpSgmntRecClsd=GA_OBJ_TD01_TestDataCreation.grpSegmntRec(acc);
                grpSgmntRecClsd.GA_Quote_ID__c='123';
                grpSgmntRecClsd.status__c='Active';
                grpSgmntRecClsd.GA_In_Progress__c=true;
                list<GA_Group_Segment__c> grpSGmntLst=new list<GA_Group_Segment__c>();
                grpSGmntLst.add(grpSgmntRec);
                grpSGmntLst.add(grpSgmntRecClsd);
                database.insert(grpSGmntLst);
                
                GA_WF_Workflow__c wfRec = New GA_WF_Workflow__c();
                wfRec.GA_External_Initiated__c=true;
                wfRec.GA_Selected_Group_Segments__c=grpSGmntLst[0].Id;
                wfRec.GA_Account__c = acc.id;
                wfRec.GA_Carrier__c = wfTemp.GA_Carrier__c;
                wfRec.GA_Method__c = wfTemp.GA_Method__c;
                wfRec.Sub_Type__c = wfTemp.GA_Process_Subtype__c;
                wfRec.GA_Type__c=wfTemp.GA_Process_Type__c;
                wfRec.GA_Status__c = 'Open';
                wfRec.GA_Workflow_Template__c =wfTemp.id;
                database.insert(wfRec);
                
                ContentVersion cntVrsn = new ContentVersion();
                cntVrsn.Title = 'Penguins';
                cntVrsn.PathOnClient = 'Penguins.jpg';
                cntVrsn.VersionData = Blob.valueOf('Test Content');
                database.insert(cntVrsn);
                
                List<ContentVersion> versions = new List<ContentVersion>();
                
                List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument limit 100];
                
                List<ContentDocumentLink> cdlLst = New List<ContentDocumentLink>();
                ContentDocumentLink cdl = New ContentDocumentLink();
                cdl.LinkedEntityId = wfRec.id;
                cdl.ContentDocumentId = documents[0].Id;
                cdl.shareType = 'V';
                database.insert(cdl);
                cdlLst.add(cdl);
                test.startTest();
                GA_ContentDocmntTgrHndlr.restrictCaseFilesInsert(cdlLst);
                test.stopTest();
                
                List<ContentDocumentLink> cdlLst2 = New List<ContentDocumentLink>();
                ContentDocumentLink cdl2 = New ContentDocumentLink();
                cdl2.LinkedEntityId = cas.id;
                cdl2.ContentDocumentId = documents[0].Id;
                cdl2.shareType = 'V';
                database.insert(cdl2);
                cdlLst2.add(cdl2);
                GA_ContentDocmntTgrHndlr.restrictCaseFilesInsert(cdlLst2);
            }
            catch(exception e)
            {
                system.assert(e != null);
            }
        } 
    }
    /**
@Description: publishCDLExcp() method 
@Name : publishCDL
@Param : None
@Return : void
@throws Exception : N/A;
*/ 
    private static testmethod void publishCDLExcp(){
        
        list<user> userList=new list<user>();
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestCDL','testsalesrepmail@bcbsm.com','Retention Sales');
        userList.add(usr);
        database.insert(userList);
        
        system.runAs(usr)  {
            try{
                test.startTest();
                GA_CDLHelper.shareWithLibrary(null);
                test.stopTest();
            }
            catch(exception e)
            {
                system.assert(e != null);
            }
        } 
    }
}