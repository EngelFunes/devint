@isTest
public class AgentSupportRequestBOBTest {
    static testMethod void TestAgentSupportRequestBOB(){
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestAsgnOwnr','testsalesrepmail@bcbsm.com','Support');
        database.insert(usr);
        system.runAs(usr)
        {
            try{
                List<id> caseidlist = New List<id>();
                List<Case> caseLst=new list<case>();
                map<id,Case> caseoldMap=new map<id,Case>(); 
                
                Account acc = GA_OBJ_TD01_TestDataCreation.AccRec();
                //  acc.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account_Customer').getRecordTypeId();
                Database.insert(acc);
                case cas=GA_OBJ_TD01_TestDataCreation.CaseRec();
                cas.Status = 'Submitted';
                caseLst.add(cas);
                caseidlist.add(cas.id);
                
                case cas1=GA_OBJ_TD01_TestDataCreation.CaseRec();
                cas1.Status = 'Submitted';
                caseLst.add(cas1);
                caseidlist.add(cas1.id);
                
                Database.insert(caseLst);
                
                caseoldMap.put(cas.id, cas);
                
                test.startTest();
                AgentSupportRequestBOB.sharingAgentSupportRequestRecord(caseLst ,caseoldMap);
                test.stopTest();
                
                // system.assert(caseLst <> null);
            }
            catch(exception e)
            {
                return;
            }
        }  
    }
    
    static testMethod void TestAgentSupportRequestBOB2(){
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('System Administrator','testsysadm@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {
            try{
                List<id> caseidlist1 = New List<id>();
                List<Case> caseLst1 =new list<case>();
                
                Account AORSRacc = GA_OBJ_TD01_TestDataCreation.AccRec();
                AORSRacc.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Customer').getRecordTypeId();
                database.insert(AORSRacc);
                
                Account AORSRacc1 = GA_OBJ_TD01_TestDataCreation.AccRec();
                AORSRacc1.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Customer').getRecordTypeId();
                database.insert(AORSRacc1);
                
                Contact conta2 =  GA_OBJ_TD01_TestDataCreation.cntactRec(AORSRacc.id);
                conta2.recordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact - Agent').getRecordTypeId();
                conta2.Active__c = True;
                
                database.insert(conta2);
                
                Contact conta3 =  GA_OBJ_TD01_TestDataCreation.cntactRec(AORSRacc.id);
                conta3.recordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact - Agent').getRecordTypeId();
                conta3.Active__c = True;
                database.insert(conta3);
                
                List<GA_Aor__C> GAAOCLIST = New List<GA_Aor__C>();
                GA_Aor__C agentacctRelation = GA_OBJ_TD01_TestDataCreation.createAOR(AORSRacc,conta2);
                agentacctRelation.GA_Service_Start_Date__c =  Date.newInstance(2020, 1, 1);
                agentacctRelation.GA_Service_End_Date__c = Date.newInstance(2021, 2, 1);
                agentacctRelation.GA_Account_Id__c = AORSRacc.id;
                agentacctRelation.GA_Contact_Id__c = conta2.id;
                database.insert(agentacctRelation); 
                
                GA_Aor__C agentacctRelation1 = GA_OBJ_TD01_TestDataCreation.createAOR(AORSRacc1,conta3);
                agentacctRelation1.GA_Service_Start_Date__c =  Date.Today()-10;
                agentacctRelation1.GA_Service_End_Date__c = Date.Today()+10;
                agentacctRelation1.GA_Account_Id__c = AORSRacc1.id;
                agentacctRelation1.GA_Contact_Id__c = conta3.id;
                database.insert(agentacctRelation1); 
                
                
                
                GAAOCLIST.add(agentacctRelation);
                GAAOCLIST.add(agentacctRelation1);
                
                
                List<id> caseid = New List<id>();
                case cas=GA_OBJ_TD01_TestDataCreation.CaseRec();
                cas.AccountId = AORSRacc.id;
                cas.GA_SupportRequest_Type__c =  'General Account Maintenance';
                Database.insert(cas);
                caseid.add(cas.id);
                case cas1 =GA_OBJ_TD01_TestDataCreation.CaseRec();
                cas1.AccountId = AORSRacc1.id;
                cas.GA_SupportRequest_Type__c =  'General Account Maintenance';
                Database.insert(cas1);
                caseid.add(cas1.id);
                test.startTest();
                AgentSupportRequestBOB.sharingSupportRequestRecords(caseid);
                test.stopTest();
                
                //  system.assert(caseLst <> null);
            }
            catch(exception e)
            {
                return;
            }
        }  
    }
}