/**
* Created by jay on 5/2/2020.
*/

@IsTest
private class FSA_SupportRequestTest {
    /* @IsTest
static void testBehavior() {
}*/
    /* @testSetup static void testDataCreation() {

Contact agentContact;
User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
System.runAs ( thisUser ) {
agentContact = TestDataFactory.agentContactRecord(System.label.Contact_Record_Type_Agency);
insert agentContact;
}


Case cc = TestDataFactory.supportRequestRecord('In Progress');
cc.GA_AgentName__c = agentContact.Id;
Update cc;
system.debug('-->cc'+cc);


}*/
    public static testmethod void agentSupportTst() {
        
        Account AORSRacc = GA_OBJ_TD01_TestDataCreation.AccRec();
        AORSRacc.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Customer').getRecordTypeId();
        database.insert(AORSRacc);
        
        Account AORSRacc1 = GA_OBJ_TD01_TestDataCreation.AccRec();
        AORSRacc1.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Customer').getRecordTypeId();
        database.insert(AORSRacc1);
        
        Account AORSRacc2 = GA_OBJ_TD01_TestDataCreation.AccRec();
        AORSRacc2.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Prospect').getRecordTypeId();
        database.insert(AORSRacc2);
        
        Contact conta =  GA_OBJ_TD01_TestDataCreation.cntactRec(AORSRacc.id);
        conta.recordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact - Delegate').getRecordTypeId();
        conta.Active__c = True;
        conta.vlocity_ins__Type__c = 'Agent and Delegate';
        database.insert(conta); 
        
        Contact conta1 =  GA_OBJ_TD01_TestDataCreation.cntactRec(AORSRacc.id);
        conta1.recordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact - Delegate').getRecordTypeId();
        conta1.Active__c = True;
        conta1.Delegate_Contact__c = True;
        conta1.vlocity_ins__Type__c = 'Delegate Agent';
        database.insert(conta1);
        
        Contact conta2 =  GA_OBJ_TD01_TestDataCreation.cntactRec(AORSRacc.id);
        conta2.recordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact - Agent').getRecordTypeId();
        conta2.Active__c = True;
        database.insert(conta2);
        
        
        RecordType contactRecordType = [SELECT Id 
                                        FROM RecordType 
                                        WHERE DeveloperName ='Contact_Agent'];
        Contact agent = new Contact(FirstName = 'Agent', LastName = 'Test', AccountId = AORSRacc.id,
                                    Email = 'testcontact@test.com.bcbsm',Delegate_Contact__c = true, RecordTypeId = contactRecordType.Id);
        insert agent;
        
        
        List<GA_Aor__C> GAAOCLIST = New List<GA_Aor__C>();
        GA_Aor__C agentacctRelation = GA_OBJ_TD01_TestDataCreation.createAOR(AORSRacc,conta);
        agentacctRelation.GA_Service_Start_Date__c =  Date.newInstance(2020, 1, 1);
        agentacctRelation.GA_Service_End_Date__c = Date.newInstance(2021, 2, 1);
        agentacctRelation.GA_Account_Id__c = AORSRacc.id;
        agentacctRelation.GA_Contact_Id__c = conta2.id;
        database.insert(agentacctRelation); 
        
        GA_Aor__C agentacctRelation1 = GA_OBJ_TD01_TestDataCreation.createAOR(AORSRacc1,conta1);
        agentacctRelation1.GA_Service_Start_Date__c =  Date.newInstance(2020, 2, 1);
        agentacctRelation1.GA_Service_End_Date__c = Date.newInstance(2022, 2, 1);
        agentacctRelation1.GA_Account_Id__c = AORSRacc1.id;
        agentacctRelation1.GA_Contact_Id__c = conta2.id;
        database.insert(agentacctRelation1); 
        
        GAAOCLIST.add(agentacctRelation);
        GAAOCLIST.add(agentacctRelation1);
        
        List<case> caseLst = New List<case>();
        case cases =GA_OBJ_TD01_TestDataCreation.CaseRec();
        cases.AccountId = AORSRacc.id;
        Database.insert(cases);
        
        
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        if(documents.size() > 0) {
            ContentDocumentLink contentlink=new ContentDocumentLink();
            contentlink.LinkedEntityId=conta1.id;
            contentlink.ShareType= 'C';
            contentlink.LinkedEntityId = conta1.Id; 
            contentlink.ContentDocumentId=documents[1].Id;
            contentlink.Visibility = 'AllUsers'; 
            insert contentlink;
            
            List <Report> reportList1 = [SELECT Id, DeveloperName FROM Report where DeveloperName = 'my_Report_API_Name'];
            
        }
     //   system.assert(accntList <> null);
        Test.startTest();
        FSA_SupportRequest.getCase(cases.Id);
        FSA_SupportRequest.getCaseDto(cases.Id);
        FSA_SupportRequest.delCase(cases.Id);
        FSA_SupportRequest.isCurrentUserManagingAgent();
        FSA_SupportRequest.isCurrentUserDelegate();
        FSA_SupportRequest.editSupportRequest(cases.Id);
        FSA_SupportRequest.isCurrentAgentDelegate();
        FSA_SupportRequest.getReportList('maCommunity');
        FSA_SupportRequest.Agent ag = new  FSA_SupportRequest.Agent(cases.Id, '1234','name');
        FSA_SupportRequest.ReportDto rd = new FSA_SupportRequest.ReportDto('reportName', 'reportDescription','reportLink');
        FSA_SupportRequest.OptionWrapper op = new FSA_SupportRequest.OptionWrapper('lable', 'name');
        FSA_SupportRequest.getAgents(cases.AccountId);
        Test.stopTest();
        FSA_SupportRequest.getAgents(AORSRacc2.id);
        system.assert(cases.Id <> null);
    }
    
    
    
    public static testmethod void agentSupportTst1() {
        
        
        
        Account AORSRac = GA_OBJ_TD01_TestDataCreation.AccRec();
        AORSRac.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Customer').getRecordTypeId();
        database.insert(AORSRac);
        Contact con =  GA_OBJ_TD01_TestDataCreation.cntactRec(AORSRac.id);
        con.recordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact - Agent').getRecordTypeId();
        con.Active__c = True;
        //con.Delegate_Contact__c = True;
        // con.vlocity_ins__Type__c = 'Delegate Agent';
        database.insert(con);
        
        
        RecordType contactRecordType = [SELECT Id 
                                        FROM RecordType 
                                        WHERE DeveloperName ='Contact_Agent'];
        Contact agent = new Contact(FirstName = 'Agent', LastName = 'Test', AccountId = AORSRac.id,
                                    Email = 'testcontact@test.com.bcbsm',Delegate_Contact__c = true, RecordTypeId = contactRecordType.Id);
        insert agent;
        
        // user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('System Administrator','testsysadm@bcbsm.com','System Administrator'); 
        user hisusr = GA_OBJ_TD01_TestDataCreation.UsrRec('BCBSMTest Partner User','testsalesrepmail@bcbsm.com','BCBSM Both');
        hisusr.IsActive = True;
        hisusr.ContactId = con.id;
        hisusr.GA_ByPass_VR__c = true;
        database.insert(hisusr);
        system.runAs(hisusr){
            
            Account AORSRacc = GA_OBJ_TD01_TestDataCreation.AccRec();
            AORSRacc.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Customer').getRecordTypeId();
            database.insert(AORSRacc);
            
            
            Account AORSRacc1 = GA_OBJ_TD01_TestDataCreation.AccRec();
            AORSRacc1.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Customer').getRecordTypeId();
            database.insert(AORSRacc1);
            
            Contact conta1 =  GA_OBJ_TD01_TestDataCreation.cntactRec(AORSRacc.id);
            conta1.recordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact - Agent').getRecordTypeId();
            conta1.Active__c = True;
            //conta1.Delegate_Contact__c = True;
            //conta1.vlocity_ins__Type__c = 'Delegate Agent';
            // database.insert(conta1);
            
            case cases =GA_OBJ_TD01_TestDataCreation.CaseRec();
            //cases.GA_IsRecTypeChanged__c = True;
            
            cases.AccountId = AORSRacc.id;
            Database.insert(cases);
            case cases1 =GA_OBJ_TD01_TestDataCreation.CaseRec();
            cases1.AccountId = AORSRacc.id;
            cases1.GA_AgentName__c = con.id;
            Database.insert(cases1);
            
            List<GA_Aor__C> GAAOCLIST = New List<GA_Aor__C>();
            GA_Aor__C agentacctRelation = GA_OBJ_TD01_TestDataCreation.createAOR(AORSRacc,con);
            agentacctRelation.GA_Service_Start_Date__c =  Date.newInstance(2020, 1, 1);
            agentacctRelation.GA_Service_End_Date__c = Date.newInstance(2021, 2, 1);
            agentacctRelation.GA_Account_Id__c = AORSRacc.id;
            agentacctRelation.GA_Contact_Id__c = con.id;
            agentacctRelation.GA_Commission_Start_Date__c =  Date.newInstance(1990, 1, 1);
            agentacctRelation.GA_Commission_End_Date__c= Date.newInstance(2200, 1, 1);
            database.insert(agentacctRelation); 
            
            GA_Aor__C agentacctRelation1 = GA_OBJ_TD01_TestDataCreation.createAOR(AORSRacc1,conta1);
            agentacctRelation1.GA_Service_Start_Date__c =  Date.newInstance(2020, 2, 1);
            agentacctRelation1.GA_Service_End_Date__c = Date.newInstance(2022, 2, 1);
            agentacctRelation1.GA_Account_Id__c = AORSRacc1.id;
            agentacctRelation1.GA_Contact_Id__c = con.id;
            agentacctRelation1.GA_Commission_Start_Date__c =  Date.newInstance(1990, 1, 1);
            agentacctRelation1.GA_Commission_End_Date__c= Date.newInstance(2200, 1, 1);
            database.insert(agentacctRelation1); 
            
            GAAOCLIST.add(agentacctRelation);
            GAAOCLIST.add(agentacctRelation1);
          
            GA_Group_Segment__c gsmt = GA_OBJ_TD01_TestDataCreation.grpSegmntRec(AORSRacc1);
            gsmt.Name = '00003_002';
            database.insert(gsmt);
            
            List<string> groupSegment = new List<string>();
            groupSegment.add(gsmt.Name);
            String JSONString = JSON.serialize(groupSegment);
            
            Test.startTest();
            
            FSA_SupportRequest.createCase('Submitted',AORSRacc.id,agent.Id,'Supply Request','Subject','Description','007044293',cases);
            FSA_SupportRequest.isCurrentUserDelegate();
            FSA_SupportRequest.submitNewRequest('Submitted',AORSRacc.id,agent.Id,'Support - Request','Subject','Description',null);
            FSA_SupportRequest.submitNewRequest('Submitted',AORSRacc.id,agent.Id,'Support - Request','Subject','Description',JSONString);
            FSA_SupportRequest.updateSubmitRequest(cases.id,'Submitted',AORSRacc.id,agent.Id,'Support - Request','Subject','Description',JSONString);
            FSA_SupportRequest.changeCaseStatus(cases.id,'Submitted');
            
            Test.stopTest();
             
            FSA_SupportRequest.agentContactUserId(cases1.id);
            FSA_SupportRequest.agentDelegateDetails(cases.id);
            FSA_SupportRequest.isAORActive(cases.id);
            FSA_SupportRequest.agentContactUser(cases.id);
           // FSA_SupportRequest.isDuplicates();
            
             system.assert(cases.Id <> null);
             system.assert(AORSRacc.id <> null);
             system.assert(agent.Id <> null);
        }
    }
    
}