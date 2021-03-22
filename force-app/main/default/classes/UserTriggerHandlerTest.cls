@isTest
public class UserTriggerHandlerTest {
    @isTest
    public static void testUserHandler(){
        User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
        UserRole userrole = [Select Id, DeveloperName From UserRole Where DeveloperName = 'System_Administrator' Limit 1];
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('System Administrator','testsysadm@bcbsm.com','System Administrator');
        usr.UserRoleId  = userrole.id;
        database.insert(usr);
        system.runAs(usr){
            
            set<id> contactid = New set<id>();
            
            Account AORSRacc = GA_OBJ_TD01_TestDataCreation.AccRec();
            AORSRacc.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Customer').getRecordTypeId();
            database.insert(AORSRacc);
            
            Account AORSRacc1 = GA_OBJ_TD01_TestDataCreation.AccRec();
            AORSRacc1.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Customer').getRecordTypeId();
            database.insert(AORSRacc1);
            
          /**   Account AORSRacc3 = GA_OBJ_TD01_TestDataCreation.AccRec();
            AORSRacc3.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Agency').getRecordTypeId();
            database.insert(AORSRacc3);
            
            Contact cont =  GA_OBJ_TD01_TestDataCreation.cntactRec(AORSRacc3.id);
            cont.recordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact - Delegate').getRecordTypeId();
            cont.Active__c = True;
            cont.Delegate_Contact__c = True;
            cont.vlocity_ins__Type__c = 'Delegate Agent';
            database.insert(cont);
            contactid.add(cont.id);  **/
            
            Contact conta =  GA_OBJ_TD01_TestDataCreation.cntactRec(AORSRacc.id);
            conta.recordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact - Agent').getRecordTypeId();
            conta.Active__c = True;
          //  conta.vlocity_ins__Type__c = 'Delegate Agent';
            database.insert(conta);   
            contactid.add(conta.id);
            
            Contact conta1 =  GA_OBJ_TD01_TestDataCreation.cntactRec(AORSRacc1.id);
            conta1.recordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact - Agent').getRecordTypeId();
            conta1.Active__c = True;
          //  conta1.vlocity_ins__Type__c = 'Delegate Agent';
            database.insert(conta1); 
            contactid.add(conta1.id);
            
            list<user> usrLst=new list<user>();
            user hisusr = GA_OBJ_TD01_TestDataCreation.UsrRec('BCBSMTest Partner User','testsalesrepmail@bcbsm.com','BCBSM Both');
            hisusr.ContactId = conta.id;
            hisusr.IsActive = True;
            usrLst.add(hisusr);
            insert usrLst;
            
            map<id, user> userNewMap = New map<id, user>();
            
            List<GA_Aor__C> GAAOCLIST = New List<GA_Aor__C>();
            GA_Aor__C agentacctRelation = GA_OBJ_TD01_TestDataCreation.createAOR(AORSRacc,conta);
            agentacctRelation.GA_Service_Start_Date__c =  Date.newInstance(2020, 1, 1);
            agentacctRelation.GA_Service_End_Date__c = Date.newInstance(2021, 2, 1);
            agentacctRelation.GA_Account_Id__c = AORSRacc.id;
            agentacctRelation.GA_Contact_Id__c = conta.id;
            database.insert(agentacctRelation); 
            
            GA_Aor__C agentacctRelation1 = GA_OBJ_TD01_TestDataCreation.createAOR(AORSRacc,conta1);
            agentacctRelation1.GA_Service_Start_Date__c =  Date.newInstance(2020, 2, 1);
            agentacctRelation1.GA_Service_End_Date__c = Date.newInstance(2022, 2, 1);
            agentacctRelation1.GA_Account_Id__c = AORSRacc1.id;
            agentacctRelation1.GA_Contact_Id__c = conta1.id;
            database.insert(agentacctRelation1); 
            
            GAAOCLIST.add(agentacctRelation);
            GAAOCLIST.add(agentacctRelation1);
            
            test.startTest();
            UserTriggerHandler.afterInsert(usrLst,userNewMap);
            UserTriggerHandler.dalegateAgentSharing(contactid);
            test.stopTest();
            
            
        }
        
        
        
    }
}