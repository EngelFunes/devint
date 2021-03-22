/*
@Author : Raj Jena
@Name: GA_AP_ABRRelatLst_Test
@CreatedDate: 4 - Oct 2018 
@Description: GA_AP_ABRRelatLst Test class
@version : 1.0  
*/
@isTest(seealldata = false)
private class GA_AP_ABRRelatLst_Test 
{
    /**
@Description: abrRelatLst() method 
@Name : abrRelatLst
@Param : N/A   
@Return : void
@throws Exception : N/A;
*/    
    private static testmethod void abrRelatLst()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestABR','testABRSpecialist@bcbsm.com','System Administrator');//prev ABR Specialist
        database.insert(usr);
        Account acc=GA_OBJ_TD01_TestDataCreation.AccRec();
        database.insert(acc);
        system.runAs(usr)
        {
            
            GA_Account_Benefit_Review__c benRvw=GA_OBJ_TD01_TestDataCreation.accBenfitRvw(acc);
            database.insert(benRvw);
            List<GA_Account_Benefit_Review__c> benRvwlst = new List<GA_Account_Benefit_Review__c> ();
            Account accRec = new Account ();
            boolean creAccCheck = false;
            boolean delAccCheck = false;
            Integer gsSize = 0;
            
            test.startTest();
            benRvwlst=GA_AP_ABRRelatLst.abrLstRecs(acc.Id);
            accRec=GA_AP_ABRRelatLst.actRec(acc.id);
            creAccCheck = GA_AP_ABRRelatLst.createAccss(acc.Id);
            delAccCheck = GA_AP_ABRRelatLst.deleteAccss(benRvw.Id);
            GA_AP_ABRRelatLst.deleteData(benRvw.id); 
            gsSize = GA_AP_ABRRelatLst.loadGroupSegmentsSize(acc.Id);
            test.stopTest();
            
            system.assert(acc <> null);
        }
    }
    /**
@Description: abrRelatLstAccess() method 
@Name : abrRelatLstAccess
@Param : N/A   
@Return : void
@throws Exception : N/A;
*/    
    private static testmethod void abrRelatLstAccess()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestABR','testABRSpecialist@bcbsm.com','Retention Sales');
        database.insert(usr);
        system.runAs(usr)
        {
            Account acc=GA_OBJ_TD01_TestDataCreation.AccRec();
            database.insert(acc);
            GA_Account_Benefit_Review__c benRvw=GA_OBJ_TD01_TestDataCreation.accBenfitRvw(acc);
            database.insert(benRvw);
            
            List<GA_Account_Benefit_Review__c> benRvwlst = new List<GA_Account_Benefit_Review__c> ();
            Account accRec = new Account ();
            boolean creAccCheck = false;
            boolean delAccCheck = false;
            Integer gsSize = 0;
            
            test.startTest();
            benRvwlst=GA_AP_ABRRelatLst.abrLstRecs(acc.Id);
            accRec=GA_AP_ABRRelatLst.actRec(acc.id);
            creAccCheck = GA_AP_ABRRelatLst.createAccss(acc.Id);
            delAccCheck = GA_AP_ABRRelatLst.deleteAccss(benRvw.Id);
            GA_AP_ABRRelatLst.deleteData(benRvw.id); 
            gsSize = GA_AP_ABRRelatLst.loadGroupSegmentsSize(acc.Id);
            test.stopTest();
            
            system.assert(acc <> null);
        }
    }
    /**
@Description: abrRelatLstSizeExp() method 
@Name : abrRelatLstSizeExp
@Param : N/A   
@Return : void
@throws Exception : N/A;
*/    
    private static testmethod void abrRelatLstSizeExp()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('Testusr','testuser@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {
            Account acc=GA_OBJ_TD01_TestDataCreation.AccRec();
            acc.GA_System_of_Record__c='SMART';
            database.insert(acc);
            
            GA_Account_Benefit_Review__c benRvw=GA_OBJ_TD01_TestDataCreation.accBenfitRvw(acc);
            database.insert(benRvw);
            
            GA_WFT_workflow__c wfTemp = GA_OBJ_TD01_TestDataCreation.wrkFlwTmplt();
            database.insert(wfTemp);
            List<GA_WFT_Inventory_Step__c> wfInvStpLst = New  List<GA_WFT_Inventory_Step__c>();
            GA_WFT_Inventory_Step__c wfInvStp = GA_OBJ_TD01_TestDataCreation.wfInventoryStp();
            wfInvStp.Name='Benefit Administration Review';
            wfInvStpLst.add(wfInvStp);
            
            GA_WFT_Inventory_Step__c wfInvStp1 = GA_OBJ_TD01_TestDataCreation.wfInventoryStp();
            wfInvStpLst.add(wfInvStp1);
            database.insert(wfInvStp1);
            
            GA_WFT_Step__c wftStp = GA_OBJ_TD01_TestDataCreation.wrkTmpStp(wfTemp,wfInvStp);
            database.insert(wftStp);
            
            GA_WFT_Allowed_Next_Step__c wftNxtStp = GA_OBJ_TD01_TestDataCreation.wfAlwdNxtStp(wftStp);
            database.insert(wftNxtStp);
            
            case cas=GA_OBJ_TD01_TestDataCreation.CaseRec();
            cas.recordtypeid=Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('GA_Support_Issues').getRecordTypeId();
            //cas.recordtypeid=Schema.SObjectType.Case.getRecordTypeInfosByName().get('Support - Issues').getRecordTypeId();
            cas.AccountId = acc.id;
            cas.GA_IssuesCategory__c='Administration';
            database.insert(cas);
            
            GA_WF_Workflow__c wfRec = New GA_WF_Workflow__c();
            wfRec.GA_Account__c = acc.id;
            wfRec.GA_Account_Benefit_Review__c=benRvw.Id;
            wfRec.GA_Carrier__c = wfTemp.GA_Carrier__c;
            wfRec.GA_Method__c = wfTemp.GA_Method__c;
            wfRec.Sub_Type__c = wfTemp.GA_Process_Subtype__c;
            wfRec.GA_Type__c=wfTemp.GA_Process_Type__c;
            wfRec.GA_Status__c = 'Closed';
            wfRec.GA_Workflow_Template__c =wfTemp.id;
            database.insert(wfRec);
            
            Group testGroup = new Group(Name='GA Project Support Queue', Type='Queue');
            database.insert(testGroup);
            
            QueuesObject testQueue = new QueueSObject(QueueID = testGroup.id, SObjectType = 'GA_WF_Group_Segment__c');
            database.insert(testQueue);
            List<GA_WF_Step__c> wfStpLst = New List<GA_WF_Step__c>();
            
            GA_WF_Step__c wfStepRec = New  GA_WF_Step__c();
            wfStepRec.Name = wfInvStp.Name;
            wfStepRec.GA_Status__c = 'Open';
            wfStepRec.GA_WF_Template_Step__c = wftStp.id;
            wfStepRec.GA_WF_Workflow_ID__c = wfRec.id;
            wfStepRec.GA_Notes__c = 'Test';
            wfStepRec.OwnerId = usr.id;
            
            wfStpLst.add(wfStepRec);  
            
            GA_WF_Step__c wfStepRec1 = New  GA_WF_Step__c();
            wfStepRec1.Name = 'Canceled';
            wfStepRec1.GA_Status__c = 'Canceled';
            wfStepRec1.GA_WF_Template_Step__c = wftStp.id;
            wfStepRec1.GA_WF_Workflow_ID__c = wfRec.id;
            wfStepRec1.GA_Notes__c = 'Test';
            wfStepRec1.OwnerId = usr.id;
            
            wfStpLst.add(wfStepRec1); 
            
            database.insert(wfStpLst); 
            
            GA_Group_Segment__c grpsgmt = GA_OBJ_TD01_TestDataCreation.grpSegmntRec(acc);
            database.insert(grpsgmt);
            grpsgmt.Name='Test';
            grpsgmt.GA_Post_Transaction__c=True;
            grpsgmt.Status__c='Pending';
            grpsgmt.GA_Transaction_Posted__c=True;
            grpsgmt.GA_PostGrpNots__c='Notes';
            grpsgmt.GA_SourceASG__c=True;
            database.update(grpsgmt);
            
            GA_WF_Group_Segment__c wfgs = New GA_WF_Group_Segment__c();
            wfgs.GA_WF_Step_ID__c =   wfStepRec.id;
            wfgs.GA_Workflow_ID__c = wfRec.id;  
            wfgs.GA_Group_Segment_ID__c = grpsgmt.id;
            wfgs.OwnerId = usr.id;
            wfgs.GA_Workflow_Next_Step__c = wfStepRec1.id;
            wfgs.GA_Status__c='Open';
            database.insert(wfgs);
            
            List<GA_Account_Benefit_Review__c> benRvwlst = new List<GA_Account_Benefit_Review__c> ();
            Account accRec = new Account ();
            boolean creAccCheck = false;
            boolean delAccCheck = false;
            Integer gsSize = 0;
            
            test.startTest();
            benRvwlst=GA_AP_ABRRelatLst.abrLstRecs(acc.Id);
            accRec=GA_AP_ABRRelatLst.actRec(acc.id);
            creAccCheck = GA_AP_ABRRelatLst.createAccss(acc.Id);
            delAccCheck = GA_AP_ABRRelatLst.deleteAccss(benRvw.Id);
            GA_AP_ABRRelatLst.deleteData(benRvw.id); 
            gsSize = GA_AP_ABRRelatLst.loadGroupSegmentsSize(acc.Id);
            test.stopTest();
            
            system.assert(acc <> null);
        }
    }
    /**
@Description: abrRelatLstExcptn() method 
@Name : abrRelatLstExcptn
@Param : N/A   
@Return : void
@throws Exception : N/A;
*/    
    private static testmethod void abrRelatLstExcptn()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestABR','testABRSpecialist@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {
            Account acc = New Account();
            GA_Account_Benefit_Review__c benftReview = New GA_Account_Benefit_Review__c();
            
            test.startTest();
            //GA_AP_ABRRelatLst.abrLstRecs(acc.id);
            //  GA_AP_ABRRelatLst.actRec(acc.id);
            //  GA_AP_ABRRelatLst.createAccss(benftReview.id);
            GA_AP_ABRRelatLst.deleteAccss(benftReview.id);
            //  GA_AP_ABRRelatLst.deleteData(benftReview.ID); 
            //  GA_AP_ABRRelatLst.loadGroupSegmentsSize(acc.id);
            test.stopTest();
            
            system.assert(usr <> null);
        }
    }
}