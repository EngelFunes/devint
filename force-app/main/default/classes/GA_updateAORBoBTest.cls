@isTest
Private class GA_updateAORBoBTest {
    
    private static testmethod void TestGA_updateAORBoB() {
            UserRole userrole = [Select Id, DeveloperName From UserRole Where DeveloperName = 'System_Administrator' Limit 1];
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('System Administrator','testsysadm@bcbsm.com','System Administrator');
        usr.UserRoleId  = userrole.id;
        database.insert(usr);
        system.runAs(usr){
            
            map<Id,GA_AOR__c> aorOldMap = New map<Id,GA_AOR__c>();
            Map<Id, List<Id>> mapAccountContacts = new Map<Id, List<Id>>();
            Map<Id, List<Id>> mapAccountUsers = new Map<Id, List<Id>>();
             List<Id> contactsList = new List<Id>();
            List<Id> contactsList1 = new List<Id>();
             List<contact> contlist = New List<contact>();
            Set<id> agencyAccount=new Set<id>();
            Map<Id, Set<Id>> mapAccountAgency = new Map<Id, Set<Id>>();
            
            Account AORSRacc = GA_OBJ_TD01_TestDataCreation.AccRec();
            AORSRacc.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Customer').getRecordTypeId();
            database.insert(AORSRacc);
            agencyAccount.add(AORSRacc.id);
            
            Account AORSRacc1 = GA_OBJ_TD01_TestDataCreation.AccRec();
            AORSRacc1.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Customer').getRecordTypeId();
            database.insert(AORSRacc1);
            agencyAccount.add(AORSRacc1.id);
            
            Contact conta =  GA_OBJ_TD01_TestDataCreation.cntactRec(AORSRacc.id);
            conta.recordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact - Delegate').getRecordTypeId();
            conta.Active__c = True;
            database.insert(conta); 
            contactsList1.add(conta.id);
            
            Contact conta1 =  GA_OBJ_TD01_TestDataCreation.cntactRec(AORSRacc1.id);
            conta1.recordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact - Delegate').getRecordTypeId();
            conta1.Active__c = True;
            database.insert(conta1);
            contactsList1.add(conta1.id); 
            
            
            Contact conta2 =  GA_OBJ_TD01_TestDataCreation.cntactRec(AORSRacc.id);
            conta2.recordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact - Agent').getRecordTypeId();
            conta2.Active__c = True;
            database.insert(conta2);
            
            Contact conta3 =  GA_OBJ_TD01_TestDataCreation.cntactRec(AORSRacc1.id);
            conta3.recordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact - Agent').getRecordTypeId();
            conta3.Active__c = True;
            database.insert(conta3);
            
            List<GA_Aor__C> GAAOCLIST = New List<GA_Aor__C>();
            List<Id> GAAOCLISTID = New List<Id>();
            List<Id> DummyGAAOCLISTID = New List<Id>();
            GA_Aor__C agentacctRelation = GA_OBJ_TD01_TestDataCreation.createAOR(AORSRacc,conta2);
            agentacctRelation.GA_Service_Start_Date__c =  date.today()-10;
            agentacctRelation.GA_Service_End_Date__c = date.today()+10;
            agentacctRelation.GA_Account_Id__c = AORSRacc.id;
            agentacctRelation.GA_Contact_Id__c = conta2.id;
            database.insert(agentacctRelation); 
            GAAOCLISTID.add(agentacctRelation.id);
            mapAccountAgency.Put(agentacctRelation.GA_Account_Id__c,agencyAccount );
                        
            GA_Aor__C agentacctRelation1 = GA_OBJ_TD01_TestDataCreation.createAOR(AORSRacc1,conta3);
            agentacctRelation1.GA_Service_Start_Date__c =  date.today()-10;
            agentacctRelation1.GA_Service_End_Date__c = date.today()+10;
            agentacctRelation1.GA_Account_Id__c = AORSRacc1.id;
            agentacctRelation1.GA_Contact_Id__c = conta3.id;
            database.insert(agentacctRelation1); 
            GAAOCLISTID.add(agentacctRelation1.id);
            mapAccountAgency.Put(agentacctRelation1.GA_Account_Id__c,agencyAccount );
            
            List<Case> caselist = New List<Case>();
            Case Aorcase = GA_OBJ_TD01_TestDataCreation.CaseRec();
            Aorcase.Accountid= AORSRacc.id;
            caselist.add(Aorcase);
            
            Case Aorcase1 = GA_OBJ_TD01_TestDataCreation.CaseRec();
            Aorcase1.Accountid= AORSRacc1.id;
            caselist.add(Aorcase1);
            
            database.insert(caselist);

            mapAccountContacts.Put(AORSRacc.id,contactsList);
            mapAccountContacts.Put(AORSRacc1.id,contactsList);
            
            
            GAAOCLIST.add(agentacctRelation);
            GAAOCLIST.add(agentacctRelation1); 
            for(GA_Aor__C Ga :GAAOCLIST){
                aorOldMap.Put(Ga.id,Ga);
                contactsList.add(Ga.GA_Contact_Id__c);
            }
            
            UserRole ur1 = new UserRole(Name = 'MDA INS and FINANCIAL GROUP Partner User');
            insert ur1;
            
            List<User> userList = New List<User>();
            user usr1 = GA_OBJ_TD01_TestDataCreation.UsrRec('TestSysAdm','testsysadm@bcbsm.com','BCBSM Agent');
            usr1.ContactId = conta2.id;
            usr1.UserRole = ur1;
            database.insert(usr1);
            userList.add(usr1);

            
            boolean isinsert = false;
            
            Test.startTest();
            GA_updateAORBoB.accountShareUpdateBoB(GAAOCLIST,aorOldMap);
            GA_updateAORBoB.accountSharing(GAAOCLISTID);
            GA_updateAORBoB.sharingSupportRequestRecordsBOB(GAAOCLIST,aorOldMap,isinsert);
            GA_updateAORBoB.sharingSupportRequestRecordsBatch(GAAOCLISTID);
           // GA_updateAORBoB.sharingSupportRequestRecordsBatch(DummyGAAOCLISTID);
            GA_updateAORBoB.sharingSupportRequestRecords(GAAOCLISTID);
          //  GA_updateAORBoB.sharingSupportRequestRecords(DummyGAAOCLISTID);
            GA_updateAORBoB.sharingSupportRequestRecordsAOR(GAAOCLISTID);
            GA_updateAORBoB.supportRequestShareBatchUpdateBoB(GAAOCLIST);
            Test.stopTest();
            
            system.assert(GAAOCLIST <> null);
            system.assert(aorOldMap <> null);
            system.assert(isinsert <> null);
        }
    }   
    
        private static testmethod void TestGA_updateAORBoB1() {
            UserRole userrole = [Select Id, DeveloperName From UserRole Where DeveloperName = 'System_Administrator' Limit 1];
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('System Administrator','testsysadm@bcbsm.com','System Administrator');
        usr.UserRoleId  = userrole.id;
        database.insert(usr);
        system.runAs(usr){
            
            map<Id,GA_AOR__c> aorOldMap = New map<Id,GA_AOR__c>();
            Map<Id, List<Id>> mapAccountContacts = new Map<Id, List<Id>>();
            Map<Id, List<Id>> mapAccountUsers = new Map<Id, List<Id>>();
             List<Id> contactsList = new List<Id>();
            List<Id> contactsList1 = new List<Id>();
             List<contact> contlist = New List<contact>();
            Set<id> agencyAccount=new Set<id>();
            Map<Id, Set<Id>> mapAccountAgency = new Map<Id, Set<Id>>();
            
            Account AORSRacc = GA_OBJ_TD01_TestDataCreation.AccRec();
            AORSRacc.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Customer').getRecordTypeId();
            database.insert(AORSRacc);
            agencyAccount.add(AORSRacc.id);
            
            Account AORSRacc1 = GA_OBJ_TD01_TestDataCreation.AccRec();
            AORSRacc1.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Customer').getRecordTypeId();
            database.insert(AORSRacc1);
            agencyAccount.add(AORSRacc1.id);
            
            
            Contact conta =  GA_OBJ_TD01_TestDataCreation.cntactRec(AORSRacc.id);
            conta.recordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact - Delegate').getRecordTypeId();
            conta.Active__c = True;
            conta.vlocity_ins__Type__c = 'Agent and Delegate';
            database.insert(conta); 
            contactsList1.add(conta.id);
            
            Contact conta1 =  GA_OBJ_TD01_TestDataCreation.cntactRec(AORSRacc1.id);
            conta1.recordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact - Delegate').getRecordTypeId();
            conta1.Active__c = True;
            conta.vlocity_ins__Type__c = 'Agent and Delegate';
            database.insert(conta1);
            contactsList1.add(conta1.id); 
          
            Contact conta2 =  GA_OBJ_TD01_TestDataCreation.cntactRec(AORSRacc.id);
            conta2.recordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact - Agent').getRecordTypeId();
            conta2.Active__c = True;
            database.insert(conta2);
            contactsList1.add(conta2.id);
                  
            Contact conta3 =  GA_OBJ_TD01_TestDataCreation.cntactRec(AORSRacc1.id);
            conta3.recordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact - Agent').getRecordTypeId();
            conta3.Active__c = True;
            database.insert(conta3);
            contactsList1.add(conta3.id);
            
            List<GA_Aor__C> GAAOCLIST = New List<GA_Aor__C>();
            List<Id> GAAOCLISTID = New List<Id>();
            GA_Aor__C agentacctRelation = GA_OBJ_TD01_TestDataCreation.createAOR(AORSRacc,conta2);
            agentacctRelation.GA_Service_Start_Date__c =  date.today()-14;
            agentacctRelation.GA_Service_End_Date__c = date.today()+11;
            agentacctRelation.GA_Account_Id__c = AORSRacc.id;
            agentacctRelation.GA_Contact_Id__c = conta2.id;
            agentacctRelation.GA_Is_Mass_Updating__c = true;
            database.insert(agentacctRelation); 
            GAAOCLISTID.add(agentacctRelation.id);
            mapAccountAgency.Put(agentacctRelation.GA_Account_Id__c,agencyAccount );
             aorOldMap.Put(agentacctRelation.id,agentacctRelation);
                contactsList.add(agentacctRelation.GA_Contact_Id__c);
            
              agentacctRelation.GA_Service_Start_Date__c =  date.today()-10;
              agentacctRelation.GA_Service_End_Date__c = date.today()-16;
              update agentacctRelation;
              GAAOCLIST.add(agentacctRelation);
                                   
            GA_Aor__C agentacctRelation1 = GA_OBJ_TD01_TestDataCreation.createAOR(AORSRacc1,conta3);
            agentacctRelation1.GA_Service_Start_Date__c =  date.today()-13;
            agentacctRelation1.GA_Service_End_Date__c = date.today()+12;
            agentacctRelation1.GA_Account_Id__c = AORSRacc1.id;
            agentacctRelation1.GA_Contact_Id__c = conta3.id;
            agentacctRelation1.GA_Is_Mass_Updating__c = true;
            database.insert(agentacctRelation1); 
            GAAOCLISTID.add(agentacctRelation1.id);
            mapAccountAgency.Put(agentacctRelation1.GA_Account_Id__c,agencyAccount );
             aorOldMap.Put(agentacctRelation1.id,agentacctRelation1);
                contactsList.add(agentacctRelation1.GA_Contact_Id__c);
            
             agentacctRelation1.GA_Service_Start_Date__c =  date.today()-17;
             agentacctRelation1.GA_Service_End_Date__c = date.today()-18;
            update agentacctRelation1;
             GAAOCLIST.add(agentacctRelation1); 

            
            List<Case> caselist = New List<Case>();
            Case Aorcase = GA_OBJ_TD01_TestDataCreation.CaseRec();
            Aorcase.Accountid= AORSRacc.id;
            caselist.add(Aorcase);
            
            Case Aorcase1 = GA_OBJ_TD01_TestDataCreation.CaseRec();
            Aorcase1.Accountid= AORSRacc1.id;
            caselist.add(Aorcase1);
            database.insert(caselist);
            
            mapAccountContacts.Put(AORSRacc.id,contactsList);
            mapAccountContacts.Put(AORSRacc1.id,contactsList);            
          
          
            UserRole ur1 = new UserRole(Name = 'MDA INS and FINANCIAL GROUP Partner User');
            insert ur1;
            
            List<User> userList = New List<User>();
            user usr1 = GA_OBJ_TD01_TestDataCreation.UsrRec('TestSysAdm','testsysadm@bcbsm.com','BCBSM Agent');
            usr1.ContactId = conta2.id;
            usr1.UserRole = ur1;
            database.insert(usr1);
            userList.add(usr1);

            
            boolean isinsert = false;
            
            Test.startTest();
            GA_updateAORBoB.accountShareUpdateBoBDelete(GAAOCLIST,aorOldMap);
            GA_updateAORBoB.getMapAccountUsersforBOB(mapAccountContacts,agencyAccount,contactsList1,mapAccountAgency);
            Test.stopTest();
            
             system.assert(GAAOCLIST <> null);
             system.assert(aorOldMap <> null);
            system.assert(mapAccountContacts <> null);
        }
    }   
    
    
}