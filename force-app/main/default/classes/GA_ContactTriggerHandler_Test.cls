/*******************************************************************************************************************************
@Author : Eswararao Rajana
@Name: GA_ContactTriggerHandler_Test 
@CreatedDate: 19 - Apr 2019 
@Description: GA_ContactTriggerHandler Test class 
@version : 1.0  
********************************************************************************************************************************/
@isTest(seealldata = false)
private class GA_ContactTriggerHandler_Test { 
    
 /*******************************************************************************************************************************
@Description: dalegateAgentSharingtest() method
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
 
   private static testmethod void dalegateAgentSharingtest()
    {
         UserRole userrole = [Select Id, DeveloperName From UserRole Where DeveloperName = 'System_Administrator' Limit 1];
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('System Administrator','testsysadm@bcbsm.com','System Administrator');
        usr.UserRoleId  = userrole.id;
        database.insert(usr);
        system.runAs(usr){
            
            List<contact> contlist = New List<Contact>();
            Account AORSRacc = GA_OBJ_TD01_TestDataCreation.AccRec();
            AORSRacc.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Customer').getRecordTypeId();
            database.insert(AORSRacc);
            
            Account AORSRacc1 = GA_OBJ_TD01_TestDataCreation.AccRec();
            AORSRacc1.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Customer').getRecordTypeId();
            database.insert(AORSRacc1);
            
            Contact conta =  GA_OBJ_TD01_TestDataCreation.cntactRec(AORSRacc.id);
            conta.recordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact - Agent').getRecordTypeId();
            conta.Active__c = True;
            database.insert(conta); 
            contlist.add(conta);
            
            Contact conta1 =  GA_OBJ_TD01_TestDataCreation.cntactRec(AORSRacc.id);
            conta1.recordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact - Agent').getRecordTypeId();
            conta1.Active__c = True;
            database.insert(conta1);
            contlist.add(conta1);
              List<GA_Aor__C> GAAOCLIST = New List<GA_Aor__C>();
            GA_Aor__C agentacctRelation = GA_OBJ_TD01_TestDataCreation.createAOR(AORSRacc,conta);
            agentacctRelation.GA_Service_Start_Date__c =  Date.newInstance(2020, 1, 1);
            agentacctRelation.GA_Service_End_Date__c = Date.newInstance(2021, 2, 1);
            agentacctRelation.GA_Account_Id__c = AORSRacc.id;
            agentacctRelation.GA_Contact_Id__c = conta.id;
            database.insert(agentacctRelation); 
            
            GA_Aor__C agentacctRelation1 = GA_OBJ_TD01_TestDataCreation.createAOR(AORSRacc1,conta1);
            agentacctRelation1.GA_Service_Start_Date__c =  Date.newInstance(2020, 2, 1);
            agentacctRelation1.GA_Service_End_Date__c = Date.newInstance(2022, 2, 1);
            agentacctRelation1.GA_Account_Id__c = AORSRacc1.id;
            agentacctRelation1.GA_Contact_Id__c = conta1.id;
            database.insert(agentacctRelation1); 
            
            GAAOCLIST.add(agentacctRelation);
            GAAOCLIST.add(agentacctRelation1);
            
            list<user> usrLst=new list<user>();
            user hisusr = GA_OBJ_TD01_TestDataCreation.UsrRec('BCBSMTest Partner User','testsalesrepmail@bcbsm.com','BCBSM Both');
            hisusr.ContactId = conta1.id;
            hisusr.IsActive = True;
            usrLst.add(hisusr);
            insert usrLst;
           
                       
              /**  test.startTest();
                GA_ContactTriggerHandler.checkExistingContactsForDuplicate(contlist);
                test.stopTest();
             system.assert(contlist <> null);**/
                
       }
    }
    /*******************************************************************************************************************************
@Description: cntcthndlrBfreUpdateExcep() method 
@Name : cntcthndlrBfreUpdateExcep
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
    private static testmethod void beforeInsertupdatetest()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('Testlckrec','testsysadminmail@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {
           List<contact> contlist = New List<Contact>();
             map<id,Contact> cntoldMap = new map<id,Contact>();
            Account AORSRacc = GA_OBJ_TD01_TestDataCreation.AccRec();
            database.insert(AORSRacc);
            
            Account AORSRacc1 = GA_OBJ_TD01_TestDataCreation.AccRec();
            database.insert(AORSRacc1);
            
            Contact conta =  GA_OBJ_TD01_TestDataCreation.cntactRec(AORSRacc.id);
            conta.Active__c = True;
            database.insert(conta); 
            contlist.add(conta);
            cntoldMap.put(conta.id, conta);
            
            Contact conta1 =  GA_OBJ_TD01_TestDataCreation.cntactRec(AORSRacc.id);
            conta1.recordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact - Delegate').getRecordTypeId();
            conta1.Active__c = True;
            conta1.Delegate_Contact__c = True;
            conta1.vlocity_ins__Type__c = 'Delegate Agent';
            database.insert(conta1);
            contlist.add(conta1);
            cntoldMap.put(conta1.id, conta1);
           
                test.startTest();
                GA_ContactTriggerHandler.beforeInsert(contlist);
                GA_ContactTriggerHandler.beforeUpdate(contlist, cntoldMap);
                test.stopTest();
          
        }
    }
    
     private static testmethod void afterinsertupdatetest()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('Testlckrec','testsysadminmail@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {
            List<contact> contlist = New List<Contact>();
             map<id,Contact> cntoldMap = new map<id,Contact>();
             map<id,Contact> Newmap = new map<id,Contact>();
            Account AORSRacc = GA_OBJ_TD01_TestDataCreation.AccRec();
            database.insert(AORSRacc);
            
            Account AORSRacc1 = GA_OBJ_TD01_TestDataCreation.AccRec();
            database.insert(AORSRacc1);
            
            Contact conta =  GA_OBJ_TD01_TestDataCreation.cntactRec(AORSRacc.id);
            conta.Active__c = True;
            conta.vlocity_ins__Type__c = 'Agent';
            database.insert(conta); 
            contlist.add(conta);
            cntoldMap.put(conta.id, conta);
            
            Contact conta1 =  GA_OBJ_TD01_TestDataCreation.cntactRec(AORSRacc.id);
            conta1.recordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact - Delegate').getRecordTypeId();
            conta1.Active__c = True;
            conta1.Delegate_Contact__c = True;
            conta1.vlocity_ins__Type__c = 'Delegate Agent';
            database.insert(conta1);
            contlist.add(conta1);
            cntoldMap.put(conta1.id, conta1);
           
            conta.vlocity_ins__Type__c = 'Delegate Agent';
            update conta;
            Newmap.put(conta.id, conta);
             conta1.vlocity_ins__Type__c = 'Agent';
            update conta1;
            Newmap.put(conta1.id, conta1);

                test.startTest();
                GA_ContactTriggerHandler.afterUpdate(contlist,Newmap,cntoldMap);
                GA_ContactTriggerHandler.afterinsert(contlist,Newmap);
                test.stopTest();
                system.assert(contlist <> null);
                system.assert(Newmap <> null);
       
            }          
        }
    }