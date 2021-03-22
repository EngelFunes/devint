@IsTest
private class GA_AssignCaseOwner_Test { 
    private static testmethod void beforeCaseRecExcep() {

                List<Case> caseLst = new list<case>();
                map<id, Case> caseoldMap = new map<id, Case>();
                string Envelopeid = '000111000111';
                Account AORSRacc = GA_OBJ_TD01_TestDataCreation.AccRec();
                AORSRacc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Customer').getRecordTypeId();
                database.insert(AORSRacc);
                
                Account AORSRacc1 = GA_OBJ_TD01_TestDataCreation.AccRec();
                AORSRacc1.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Customer').getRecordTypeId();
                database.insert(AORSRacc1);
                
                case cas = GA_OBJ_TD01_TestDataCreation.CaseRec();
                cas.recordtypeid = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Agent Support Request').getRecordTypeId();
                cas.AccountId = AORSRacc.id;
                cas.GA_Envelope_Id__c = Envelopeid;
                cas.Origin = 'Email';
                database.insert(cas);
                caseLst.add(cas);
                caseoldMap.put(cas.id, cas);
                
                cas.AccountId = AORSRacc1.id;
                Update cas;                
                
                case cas1 = GA_OBJ_TD01_TestDataCreation.CaseRec();
                cas1.recordtypeid = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Agent Support Request').getRecordTypeId();
                caseLst.add(cas1);

                test.startTest();
                GA_AssignCaseOwnerCls.isExecuting = null;
                GA_AssignCaseOwnerCls.caseOwnerAssignBefore(caseLst, caseoldMap);
                GA_AssignCaseOwnerCls.caseOwnerAssignBefore(caseLst, null);
                test.stopTest();
        
                 System.assertEquals(2,caseLst.size());
                 System.assertEquals('Email',caseLst[0].Origin);
              //  System.assertEquals(null,caseoldMap);
    }
    
    
    public static testmethod void caseAccessSharetoSuperUserAfter_test()
    {

        List<Case> caseLst=new list<case>();
       
        Group testGroup = [select id from Group where Name='SR ASR Queue'];
 
        Account AORSRacc = GA_OBJ_TD01_TestDataCreation.AccRec();
        AORSRacc.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Customer').getRecordTypeId();
        database.insert(AORSRacc);
        
        Contact conta =  GA_OBJ_TD01_TestDataCreation.cntactRec(AORSRacc.id);
        conta.recordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact - Agent').getRecordTypeId();
        conta.Active__c = True;
        database.insert(conta);
        
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('BCBSMTest Partner User','testsalesrepmail@bcbsm.com','BCBSM Both');
        usr.contactid = conta.id;
        usr.IsActive = True;
        database.insert(usr);
        system.runAs(usr)
        {
            
            map<id,Case> caseoldMap=new map<id,Case>();
            map<id,Case> casenewMap=new map<id,Case>();
            
            case cas1=GA_OBJ_TD01_TestDataCreation.CaseRec();
            cas1.recordtypeid =  Schema.SObjectType.Case.getRecordTypeInfosByName().get('Agent Support Request').getRecordTypeId();
            cas1.Status='In Progress';   
            Database.insert(cas1); 
            caseoldMap.put(cas1.id, cas1);
            
            cas1.Status='Submitted';  
            cas1.OwnerId = testGroup.Id;
            cas1.GA_Is_Mass_Updating__c = True;
            update cas1;
            caseLst.add(cas1);
            
            test.startTest();
            GA_AssignCaseOwnerCls.caseAccessSharetoSuperUserAfter(caseLst, caseoldMap);
            GA_AssignCaseOwnerCls.caseAccessSharetoSuperUserAfter(caseLst, null);
            GA_AssignCaseOwnerCls.caseOwnerAssignAfter(caseLst);
            test.stopTest();
            
            system.assert(caseLst <> null);
            System.assertequals(System.label.Agent_ASR_Support_request_Queue_ID, caseLst[0].Ownerid);            
        }  
    } 
    
    public static testmethod void aSRAssignmentforAgnetCaseBefor_test() {
        
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('System Administrator', 'testsysadm@bcbsm.com', 'System Administrator');
        database.insert(usr);
        system.runAs(usr) {
            
            UserRole userrole = [Select Id, DeveloperName From UserRole Where DeveloperName = 'Account_Services_Representative' Limit 1];
            user usrASR = GA_OBJ_TD01_TestDataCreation.UsrRec('Support Representative', 'testsysadm@bcbsm.com', 'Support');
            usrASR.IsActive = True;
            usrASR.UserRoleId = userrole.id;
            database.insert(usrASR);
            GA_Territory__c terytory = new GA_Territory__c();
            terytory.Name = 'FY';
            terytory.GA_TerritoryType__c = 'Account Executives';
            terytory.GA_TerritoryCode__c = 'FY';
            terytory.GA_Sales_Rep_Effective_Date__c = System.today();
            insert terytory;
            
            Account AORSRacc = GA_OBJ_TD01_TestDataCreation.AccRec();
            AORSRacc.GA_Territory__c = terytory.id;
            AORSRacc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Customer').getRecordTypeId();
            database.insert(AORSRacc);
            system.debug('AORSRacc' + AORSRacc.GA_Territory__c);
            
            Account AORSRacc1 = GA_OBJ_TD01_TestDataCreation.AccRec();
            AORSRacc1.Account_Services_Representative__c = usrASR.id;
            AORSRacc1.GA_Territory__c = terytory.id;
            AORSRacc1.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Customer').getRecordTypeId();
            database.insert(AORSRacc1);
            
            System.assert(AORSRacc1.Account_Services_Representative__c <>null);
            
            Contact conta = GA_OBJ_TD01_TestDataCreation.cntactRec(AORSRacc.id);
            conta.recordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact - Agent').getRecordTypeId();
            conta.Active__c = True;
            database.insert(conta);
            
            
            List<Case> caseLst = new list<case>();
            map<id, Case> caseoldMap = new map<id, Case>();
            map<id, Case> casenewMap = new map<id, Case>();
            
            case cas = GA_OBJ_TD01_TestDataCreation.CaseRec();
            cas.recordtypeid = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Agent Support Request').getRecordTypeId();
            cas.AccountId = AORSRacc1.id; 
            cas.Status='In Progress';
            Database.insert(cas);
            caseoldMap.put(cas.id, cas);
            cas.Status = 'Submitted';
            update cas;
            caseLst.add(cas);
                       
            case cas2 = GA_OBJ_TD01_TestDataCreation.CaseRec();
            cas2.recordtypeid = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Agent Support Request').getRecordTypeId();
            cas2.AccountId = AORSRacc.id;
            cas2.Status='In Progress';
            Database.insert(cas2);
            caseoldMap.put(cas2.id, cas2);
            cas2.Status = 'Submitted';
            update cas2;
            caseLst.add(cas2);
            
            case cas1 = GA_OBJ_TD01_TestDataCreation.CaseRec();
            cas1.recordtypeid = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Agent Support Request').getRecordTypeId();
            cas1.AccountId = AORSRacc.id;
            Database.insert(cas1);
            caseLst.add(cas1);
            caseoldMap.put(cas1.id, cas1);
            
            Territory_ASR_Assignment_List__c tsa = new Territory_ASR_Assignment_List__c();
            tsa.RecordTypeId = Schema.SObjectType.Territory_ASR_Assignment_List__c.getRecordTypeInfosByName().get('Region Territory Map').getRecordTypeId();
            tsa.Territory__c = terytory.id;
            tsa.Active__c = true;
            tsa.ASR__c = usrASR.id;
            tsa.Territory_Region__c = 'West MI Group';
            insert tsa;
            
            System.assert(tsa.Territory__c <> null);
            
            Territory_ASR_Assignment_List__c tsa1 = new Territory_ASR_Assignment_List__c();
            tsa1.RecordTypeId = Schema.SObjectType.Territory_ASR_Assignment_List__c.getRecordTypeInfosByName().get('Region ASR Map').getRecordTypeId();
            tsa1.Territory__c = terytory.id;
            tsa1.Active__c = true;
            tsa1.ASR__c = usrASR.id;
            tsa1.Territory_Region__c = 'West MI Group';
            insert tsa1;


            casenewMap.put(cas.id, cas);
            test.startTest();
            GA_AssignCaseOwnerCls.aSRAssignmentforAgnetCaseBefore(caseLst, caseoldMap);
            GA_AssignCaseOwnerCls.aSRAssignmentforAgnetCaseBefore(caseLst, null);
            test.stopTest();
            
            System.assertEquals(3,caseoldMap.values().size());
            System.assert(tsa.Territory_Region__c <> null);
            
        }
    }
}