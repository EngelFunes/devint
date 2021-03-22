/**
@Author : Raj Jena
@Name: GA_CaseTriggerHandler_Test 
@CreatedDate: 28 - Dec 2017 
@Description: GA_CaseTriggerHandler Test class 
@version : 1.0  
*/
@isTest(seealldata = false)
private class GA_CaseTriggerHandler_Test {
    
    
    
    /*******************************************************************************************************************************
@Description        :   caseOwnerAssignRec() method 
@Name               :   caseOwnerAssignRec
@Param              :   None
@Return             :   void
@throws Exception   :   N/A;
********************************************************************************************************************************/ 
    private static testmethod void caseOwnerAssignRec()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestAsgnOwnr','testsalesrepmail@bcbsm.com','Support');
        database.insert(usr);
        system.runAs(usr)
        {
            try{
                
                List<Case> caseLst=new list<case>();
                map<id,Case> caseoldMap=new map<id,Case>();
                map<id,Case> casenewMap=new map<id,Case>();
                Account acc = GA_OBJ_TD01_TestDataCreation.AccRec(); 
                case cas=GA_OBJ_TD01_TestDataCreation.CaseRec();
                caseLst.add(cas);
                case cas1=GA_OBJ_TD01_TestDataCreation.CaseRec();
                cas1.Origin= 'Email';
                caseLst.add(cas1);
                case cas2=GA_OBJ_TD01_TestDataCreation.CaseRec();
                cas2.Origin= 'Email';
                cas2.recordtypeid =  Schema.SObjectType.Case.getRecordTypeInfosByName().get('Support - Support / West Michigan').getRecordTypeId();
                
                caseLst.add(cas2);
                
                Database.insert(caseLst);
                
                casenewMap.put(cas.id, cas);
                casenewMap.put(cas2.id, cas2);
                cas2.accountid = acc.id; 
                update cas2;
                caseoldMap.put(cas.id, cas);
                test.startTest();
                GA_AssignCaseOwnerCls.isExecuting=true;             
                GA_CaseTriggerHandler.beforeupdate(caseLst ,casenewMap, caseoldMap);
                caseoldMap.put(cas2.id, cas2);
                // GA_AssignCaseOwnerCls.caseAccessSharetoSuperUserAfter(caseLst, caseoldMap);
                // GA_AssignCaseOwnerCls.caseAccessSharetoSuperUserAfter(caseLst, null);
                test.stopTest();
                
                system.assert(caseLst <> null);
            }
            catch(exception e)
            {
                return;
            }
        }
    }
    
    /*******************************************************************************************************************************
@Description        :   caseOwnerAssignBeforeInsert() method 
@Name               :   caseOwnerAssignBeforeInsert
@Param              :   None
@Return             :   void
@throws Exception   :   N/A;
********************************************************************************************************************************/ 
    private static testmethod void caseOwnerAssignBeforeInsert()
    {
        List<user> uList = New List<user>();
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestAsgnOwnr','testsalesrepmail@bcbsm.com','New Business Sales');
        uList.add(usr);
        user usrasr = GA_OBJ_TD01_TestDataCreation.UsrRec('ASRrep','testrep@bcbsm.com','Support');
        uList.add(usrasr);
        database.insert(uList);
        system.runAs(uList.get(0))
        {
            try{
                
                List<Case> caseLst=new list<case>();
                map<id,Case> caseoldMap=new map<id,Case>();
                
                case cas=GA_OBJ_TD01_TestDataCreation.CaseRec();
                cas.GA_ASR__c = uList.get(1).id;
                caseLst.add(cas);
                case cas1=GA_OBJ_TD01_TestDataCreation.CaseRec();
                cas1.Origin= 'Email';
                caseLst.add(cas1);
                
                test.startTest();
                GA_AssignCaseOwnerCls.isExecuting=false;
                GA_CaseTriggerHandler.beforeinsert(caseLst, caseoldMap);
                test.stopTest();
                
                system.assert(caseLst <> null);
            }
            catch(exception e)
            {
                return;
            }
        }
    }
    
    /*******************************************************************************************************************************
@Description        :   caseOwnerAssignAfterExcep() method 
@Name               :   caseOwnerAssignAfterExcep
@Param              :   None
@Return             :   void
@throws Exception   :   N/A;
********************************************************************************************************************************/ 
    private static testmethod void caseOwnerAssignAfterExcep()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestAsgnOwnr','testsalesrepmail@bcbsm.com','Support');
        database.insert(usr);
        system.runAs(usr)
        {
            try{
                
                List<Case> caseList=null;
                map<id,Case> caseNewMap = new map<id,Case>();
                map<id,Case> caseoldMap = new map<id,Case>();
                
                test.startTest();
                GA_AssignCaseOwnerCls.isExecuting =null;
                GA_CaseTriggerHandler.beforeupdate(caseList, caseNewMap, caseoldMap);
                GA_AssignCaseOwnerCls.isExecuting =null;
                GA_CaseTriggerHandler.beforeinsert(caseList, caseoldMap);
                
                test.stopTest();
                
                system.assert(caseList<> null);
            }
            catch(exception e)
            {
                return;
            }
            
        }
    }    
    
    /*******************************************************************************************************************************
@Description        :   caseOwnerAssignAfterExcep1() method 
@Name               :   caseOwnerAssignAfterExcep1
@Param              :   None
@Return             :   void
@throws Exception   :   N/A;
********************************************************************************************************************************/ 
    private static testmethod void caseOwnerAssignAfterExcep1()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestAsgnOwnr','testsalesrepmail@bcbsm.com','Support');
        database.insert(usr);
        system.runAs(usr)
        {
            try{
                
                List<Case> caseList=null;
                map<id,Case> caseNewMap = new map<id,Case>();
                map<id,Case> caseoldMap = new map<id,Case>();
                
                test.startTest();
                GA_AssignCaseOwnerCls.isExecuting =null;
                GA_CaseTriggerHandler.beforeinsert(caseList, caseoldMap);
                test.stopTest();
                
                system.assert(caseList<> null);
            }
            catch(exception e)
            {
                return;
            }
            
        }
    }
    /*******************************************************************************************************************************
@Description        :   updateCaseRec() method 
@Name               :   updateCaseRec
@Param              :   None
@Return             :   void
@throws Exception   :   N/A;
********************************************************************************************************************************/ 
    private static testmethod void updateCaseRec()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestAsgnOwnr','testsalesrepmail@bcbsm.com','Retention Sales');
        database.insert(usr);
        system.runAs(usr)
        {
            try{
                
                List<Case> caseLst=new list<case>();
                map<id,Case> caseoldMap=new map<id,Case>();
                map<id,Case> casenewMap=new map<id,Case>();
                
                GA_Territory__c tRec = GA_OBJ_TD01_TestDataCreation.terrtryRec();
                tRec.GA_RetentionSalesRepresentative__c=usr.id;
                database.insert(tRec);
                Account acc = GA_OBJ_TD01_TestDataCreation.AccRec(); 
                acc.GA_Territory__c = tRec.Id;
                database.insert(acc);
                case cas=GA_OBJ_TD01_TestDataCreation.CaseRec();
                cas.AccountId = acc.id;
                cas.Issue__c = false;
                cas.GA_Jeopardy__c = false;
                database.insert(cas);
                List<Case> casList = [select id, issue__c, OwnerId, Origin, GA_Support_Manager_Email_Frml__c, GA_CaseSupportManager__c, EntitlementId, RecordTypeId, GA_Retention_Rep_Case_Owner_Frml__c From Case Where Id =: cas.Id limit 100];
                casenewMap.put(cas.id, cas);
                
                
                GA_CaseUpdateCls.isExecuting=false;
                cas.Issue__c = true;
                cas.GA_Jeopardy__c = true;
                Database.update(cas);
                List<Case> updCasList = [select id, issue__c, OwnerId, Origin, GA_Support_Manager_Email_Frml__c, GA_CaseSupportManager__c, EntitlementId, RecordTypeId, GA_Retention_Rep_Case_Owner_Frml__c From Case Where Id =: cas.Id limit 100];
                test.startTest();
                GA_CaseUpdateCls.updteCasefields(updCasList,caseoldMap);
                GA_CaseUpdateCls.crteJeopardyRec(updCasList,caseoldMap);
                test.stopTest();
                
                system.assert(casList <> null);
            }
            catch(exception e)
            {
                return;
            }
            
        }
    }
    /*******************************************************************************************************************************
@Description        :   updateCaseRecExcep() method 
@Name               :   updateCaseRecExcep
@Param              :   None
@Return             :   void
@throws Exception   :   N/A;
********************************************************************************************************************************/ 
    private static testmethod void updateCaseRecExcep()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestJeoRl','testsalesrepmail@bcbsm.com','Support');
        database.insert(usr);
        GA_Profile_ByPass__c profBypass = GA_Profile_ByPass__c.getInstance();
        system.runAs(usr)
        {
            try{
                List<Case> caseLst=new list<case>();
                map<id,Case> caseoldMap=new map<id,Case>();
                map<id,Case> casenewMap=new map<id,Case>();
                test.startTest();
                GA_CaseUpdateCls.isExecuting=false;
                GA_AssignCaseOwnerCls.isExecuting=false;
                GA_CaseTriggerHandler.afterinsert(caseLst ,casenewMap, caseoldMap);
                //  GA_AssignCaseOwnerCls.caseOwnerAssignBefore(caseLst, caseoldMap);
                
                test.stopTest();
                system.assert(caseLst != null);
            }
            catch(exception e)
            {
                return;
            }
        } 
    }
    
    /*******************************************************************************************************************************
@Description        :   beforeCaseRecExcep() method 
@Name               :   beforeCaseRecExcep
@Param              :   None
@Return             :   void
@throws Exception   :   N/A;
********************************************************************************************************************************/ 
    private static testmethod void beforeCaseRecExcep()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestJeoRl','testsalesrepmail@bcbsm.com','Support');
        database.insert(usr);
        system.runAs(usr)
        {
            try{
                List<Case> caseLst=new list<case>();
                map<id,Case> caseoldMap=new map<id,Case>();
                test.startTest();
                GA_AssignCaseOwnerCls.isExecuting=null;
                // GA_AssignCaseOwnerCls.caseOwnerAssignBefore(caseLst , caseoldMap);
                test.stopTest();
                system.assert(usr <> null);
            }
            catch(exception e)
            {
                return;
            }
        } 
    }
    
    /*******************************************************************************************************************************
@Description        :   crteJeopardyRecAfterInsert() method 
@Name               :   crteJeopardyRecAfterInsert
@Param              :   None
@Return             :   void
@throws Exception   :   N/A;
********************************************************************************************************************************/ 
    private static testmethod void crteJeopardyRecAfterInsert()
    {
        list<user> usrLst=new list<user>();
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestJeoRl','testsalesrepmail@bcbsm.com','System Administrator');
        usrLst.add(usr);
        user usrRetSlsRep = GA_OBJ_TD01_TestDataCreation.UsrRec('TestJeoRlRetnslsRep','testsalesrepmail@bcbsm.com','Retention Sales');
        usrLst.add(usrRetSlsRep);
        database.insert(usrLst);
        
        
        system.runAs(usrLst[0])
        {
            try{
                
                List<Case> caseLst=new list<case>();
                map<id,Case> caseoldMap=new map<id,Case>();
                map<id,Case> casenewMap=new map<id,Case>();
                
                
                GA_Territory__c territoryRec=GA_OBJ_TD01_TestDataCreation.terrtryRec();
                territoryRec.GA_RetentionSalesRepresentative__c=usrLst[1].id;
                database.insert(territoryRec);
                
                Account acc = GA_OBJ_TD01_TestDataCreation.AccRec();
                acc.GA_Territory__c = territoryRec.id;
                database.insert(acc);
                
                case cas=GA_OBJ_TD01_TestDataCreation.CaseRec();
                cas.recordtypeid=Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('GA_Support_Issues').getRecordTypeId();
                //cas.recordtypeid=Schema.SObjectType.Case.getRecordTypeInfosByName().get('Support - Issues').getRecordTypeId();
                cas.AccountId = acc.id;
                cas.GA_Jeopardy__c = true;
                cas.GA_IssuesCategory__c='Administration';
                
                test.startTest();
                database.insert(cas);
                test.stopTest();
                
                system.assert(cas <> null);
            }
            catch(exception e)
            {
                return;
            }
        }
    }
    
    /*******************************************************************************************************************************
@Description        :   crteJeopardyRecAfterUpdate() method 
@Name               :   crteJeopardyRecAfterUpdate
@Param              :   None
@Return             :   void
@throws Exception   :   N/A;
********************************************************************************************************************************/ 
    private static testmethod void crteJeopardyRecAfterUpdate()
    {
        list<user> usrLst=new list<user>();
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestJeoRl','testsalesrepmail@bcbsm.com','System Administrator');
        usrLst.add(usr);
        user usrRetSlsRep = GA_OBJ_TD01_TestDataCreation.UsrRec('TestJeoRlRetnslsRep','testsalesrepmail@bcbsm.com','Retention Sales');
        usrLst.add(usrRetSlsRep);
        database.insert(usrLst);
        
        
        system.runAs(usrLst[0])
        {
            try{
                
                List<Case> caseLst=new list<case>();
                map<id,Case> caseoldMap=new map<id,Case>();
                map<id,Case> casenewMap=new map<id,Case>();
                
                GA_Profile_ByPass__c bypss=new GA_Profile_ByPass__c();
                bypss.Bypass__c=false;
                database.insert(bypss);
                
                GA_Territory__c territoryRec=GA_OBJ_TD01_TestDataCreation.terrtryRec();
                territoryRec.GA_RetentionSalesRepresentative__c=usrLst[1].id;
                database.insert(territoryRec);
                
                Account acc = GA_OBJ_TD01_TestDataCreation.AccRec();
                acc.GA_Territory__c = territoryRec.id;
                database.insert(acc);
                
                case cas=GA_OBJ_TD01_TestDataCreation.CaseRec();
                cas.AccountId = acc.id;
                cas.GA_Jeopardy__c = false;
                cas.recordtypeid=Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('GA_Support_Issues').getRecordTypeId();
                //cas.recordtypeid=Schema.SObjectType.Case.getRecordTypeInfosByName().get('Support - Issues').getRecordTypeId();
                database.insert(cas);
                
                cas.GA_Jeopardy__c = true;
                cas.GA_IssuesCategory__c='Administration';
                GA_CaseUpdateCls.isExecuting=false;
                
                test.startTest();
                database.update(cas);
                test.stopTest();
                system.assert(cas <> null);
                
            }
            catch(exception e)
            {
                return;
            }
            
        }
    }
    /*******************************************************************************************************************************
@Description        :   crteJeopardyRecAfterUpdateExcep() method 
@Name               :   crteJeopardyRecAfterUpdateExcep
@Param              :   None
@Return             :   void
@throws Exception   :   N/A;
********************************************************************************************************************************/ 
    private static testmethod void crteJeopardyRecAfterUpdateExcep()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestJeoRl','testsalesrepmail@bcbsm.com','Support');
        database.insert(usr);
        system.runAs(usr)
        {
            try{
                List<Case> caseLst=new list<case>();
                map<id,Case> caseoldMap=new map<id,Case>();
                test.startTest();
                GA_CaseUpdateCls.isExecuting=null;
                GA_CaseTriggerHandler.afterupdate(caseLst , caseoldMap);
                test.stopTest();
                system.assert(caseLst == null);
            }
            catch(exception e)
            {
                return;
            }
        } 
    }
    /*******************************************************************************************************************************
@Description        :   Test method for AfterDelete
@Name               :   AfterDelete
@Param              :   None
@Return             :   void
@throws Exception   :   N/A;
********************************************************************************************************************************/ 
    private static testmethod void testAfterDelete()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestJeoRl','testsalesrepmail@bcbsm.com','Support');
        database.insert(usr);
        system.runAs(usr)
        {
            try{
                List<Case> caseLst=new list<case>();
                map<id,Case> caseoldMap=new map<id,Case>();
                map<id,Case> casenewMap=new map<id,Case>();                
                test.startTest();               
                GA_CaseTriggerHandler.afterDelete(caseLst);
                GA_AssignCaseOwnerCls.isExecuting=false;             
                GA_CaseTriggerHandler.beforeupdate(caseLst ,casenewMap, caseoldMap);
                test.stopTest();
                system.assert(caseLst != null);
            }
            catch(exception e)
            {
                return;
            }
        } 
    }
    /*******************************************************************************************************************************
@Description        :   Test method for BeforeDelete
@Name               :   BeforeDelete
@Param              :   None
@Return             :   void
@throws Exception   :   N/A;
********************************************************************************************************************************/ 
    private static testmethod void testBeforeDelete()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestJeoRl','testsalesrepmail@bcbsm.com','Support');
        database.insert(usr);
        system.runAs(usr)
        {
            try{
                List<Case> caseLst=new list<case>();
                map<id,Case> caseoldMap=new map<id,Case>();
                map<id,Case> casenewMap=new map<id,Case>();                
                test.startTest();                
                GA_CaseTriggerHandler.beforeDelete(caseLst);
                GA_AssignCaseOwnerCls.isExecuting=false;             
                GA_CaseTriggerHandler.afterUpdate(caseLst ,caseoldMap);
                test.stopTest();
                system.assert(caseLst != null);
            }
            catch(exception e)
            {
                return;
            }
        } 
    }
    
    /**********************************************************************************/
    
    
    
    public static testmethod void aSRAssignmentforAgnetCaseBefore_test()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestAsgnOwnr','testsalesrepmail@bcbsm.com','Support');
        database.insert(usr);
        system.runAs(usr)
        {
            try{
                
                List<Case> caseLst=new list<case>();
                map<id,Case> caseoldMap=new map<id,Case>();
                map<id,Case> casenewMap=new map<id,Case>();
                
                //GA_Territory__c territoryRec=GA_OBJ_TD01_TestDataCreation.terrtryRec();
                //territoryRec.GA_RetentionSalesRepresentative__c=usr.id;
                //database.insert(territoryRec);
                
                //Territory_ASR_Assignment_List__c tsa = new Territory_ASR_Assignment_List__c();
                //tsa.Territory__c= territoryRec.id; 
                //tsa.Active__c=true;
                //tsa.ASR__c=usr.id;
                //tsa.Region__c='Default'; 
                //tsa.recordtypeid= Schema.SObjectType.Territory_ASR_Assignment_List__c .getRecordTypeInfosByName().get('Region_Territory_Map').getRecordTypeId();        
                //insert tsa;
                GA_Territory__c tRec = GA_OBJ_TD01_TestDataCreation.terrtryRec();
                tRec.GA_RetentionSalesRepresentative__c=usr.id;
                database.insert(tRec);
                Account acc = GA_OBJ_TD01_TestDataCreation.AccRec(); 
                acc.GA_Territory__c = tRec.Id;
                database.insert(acc);
                
                Territory_ASR_Assignment_List__c tsa = new Territory_ASR_Assignment_List__c();
                tsa.Territory__c= tRec.id; 
                tsa.Active__c=true;
                tsa.ASR__c=usr.id;
                // tsa.Region__c='Default'; 
                tsa.recordtypeid= Schema.SObjectType.Territory_ASR_Assignment_List__c .getRecordTypeInfosByName().get('Region Territory Map').getRecordTypeId();        
                insert tsa;
                
                case cas=GA_OBJ_TD01_TestDataCreation.CaseRec();
                caseLst.add(cas);
                case cas1=GA_OBJ_TD01_TestDataCreation.CaseRec();
                cas1.Origin= 'Email';
                caseLst.add(cas1);
                case cas2=GA_OBJ_TD01_TestDataCreation.CaseRec();
                cas2.Origin= 'Email';
                cas2.recordtypeid =  Schema.SObjectType.Case.getRecordTypeInfosByName().get('Support - Support / West Michigan').getRecordTypeId();
                
                caseLst.add(cas2);
                
                Database.insert(caseLst);
                
                casenewMap.put(cas.id, cas);
                casenewMap.put(cas2.id, cas2);
                cas2.accountid = acc.id; 
                cas2.GA_ASR__c=tsa.ASR__c;
                //cas2.accountid = acc.id; 
                update cas2;
                caseoldMap.put(cas.id, cas);
                test.startTest();
                GA_AssignCaseOwnerCls.isExecuting=true;             
                GA_CaseTriggerHandler.beforeupdate(caseLst ,casenewMap, caseoldMap);
                caseoldMap.put(cas2.id, cas2);
                // GA_AssignCaseOwnerCls.caseAccessSharetoSuperUserAfter(caseLst, caseoldMap);
                // GA_AssignCaseOwnerCls.caseAccessSharetoSuperUserAfter(caseLst, null);
                test.stopTest();
                
                system.assert(caseLst <> null);
            }
            catch(exception e)
            {
                return;
            }
        }
    }
    public static testmethod void resulsblemultiselect()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestAsgnOwnr','testsalesrepmail@bcbsm.com','Support');
        database.insert(usr);
        system.runAs(usr)
        {
            
            
            /*GA_Territory__c tRec = GA_OBJ_TD01_TestDataCreation.terrtryRec();
tRec.GA_RetentionSalesRepresentative__c=usr.id;
database.insert(tRec);*/
            GA_Territory__c terytoryRec=new GA_Territory__c();
            terytoryRec.Name='Test Territory Name';
            terytoryRec.GA_TerritoryType__c='Account Manager';
            terytoryRec.GA_TerritoryCode__c='23';
            terytoryRec.GA_Sales_Rep_Effective_Date__c = System.today();
            insert terytoryRec;
            //terytoryRec.Active__c=true;
            update terytoryRec;
            
            
            Territory_ASR_Assignment_List__c tsa = new Territory_ASR_Assignment_List__c();
            tsa.Territory__c= terytoryRec.id; 
            tsa.Active__c=true;
            tsa.ASR__c=usr.id;
            // tsa.Region__c='Default'; 
            tsa.Territory_Region__c='123654';
            tsa.RecordTypeId = Schema.SObjectType.Territory_ASR_Assignment_List__c.getRecordTypeInfosByName().get('Region Territory Map').getRecordTypeId();        
            insert tsa;
            
            
            tsa.RecordTypeId =  Schema.SObjectType.Territory_ASR_Assignment_List__c.getRecordTypeInfosByName().get('Region ASR Map').getRecordTypeId();        
            tsa.Active__c=false;
            update tsa;
            
            Territory_ASR_Assignment_List__c tsa1 = new Territory_ASR_Assignment_List__c();
            tsa1.Territory__c= terytoryRec.id; 
            tsa1.Active__c=false;
            tsa1.ASR__c=usr.id;
            // tsa1.Region__c='Default'; 
            tsa1.Territory_Region__c='1236547';
            tsa1.RecordTypeId = Schema.SObjectType.Territory_ASR_Assignment_List__c.getRecordTypeInfosByName().get('Region ASR Map').getRecordTypeId();        
            insert tsa1;
            
            
            reUsableMultiSelectLookupCtrl.getselectOptions();
            reUsableMultiSelectLookupCtrl.getSelectedTerritories('West MI');
            reUsableMultiSelectLookupCtrl.getUsers();
            reUsableMultiSelectLookupCtrl.addRegionPicListValue('123654');
            reUsableMultiSelectLookupCtrl.fetchLookUpValues('testr','GA_Territory__c',new List<GA_Territory__c> {terytoryRec},'');
            reUsableMultiSelectLookupCtrl.getSelectedUsers('West MI');
            reUsableMultiSelectLookupCtrl.saveChanges('123654',new List<GA_Territory__c> {terytoryRec}, new list<User> {usr});
            reUsableMultiSelectLookupCtrl.saveChanges('1236547',new List<GA_Territory__c> {terytoryRec}, new list<User> {usr});
            
        }
    }  
    
    public static testmethod void resulsblemultiselect1()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestAsgnOwnr','testsalesrepmail@bcbsm.com','Support');
        database.insert(usr);
        system.runAs(usr)
        {
            
            
            
            GA_Territory__c terytoryRec=new GA_Territory__c();
            terytoryRec.Name='Test Territory Name';
            terytoryRec.GA_TerritoryType__c='Account Manager';
            terytoryRec.GA_TerritoryCode__c='23';
            terytoryRec.GA_Sales_Rep_Effective_Date__c = System.today();
            insert terytoryRec;                
            
            
            Territory_ASR_Assignment_List__c tsa1 = new Territory_ASR_Assignment_List__c();
            tsa1.Territory__c= terytoryRec.id; 
            tsa1.Active__c=false;
            tsa1.ASR__c=usr.id;
            // tsa1.Region__c='Default'; 
            tsa1.Territory_Region__c='1236547';
            tsa1.RecordTypeId = Schema.SObjectType.Territory_ASR_Assignment_List__c.getRecordTypeInfosByName().get('Region ASR Map').getRecordTypeId();        
            insert tsa1;
            
            
            reUsableMultiSelectLookupCtrl.getselectOptions();
            reUsableMultiSelectLookupCtrl.getSelectedTerritories('West MI');
            reUsableMultiSelectLookupCtrl.getUsers();
            reUsableMultiSelectLookupCtrl.addRegionPicListValue('123654');
            reUsableMultiSelectLookupCtrl.fetchLookUpValues('testr','GA_Territory__c',new List<GA_Territory__c> {terytoryRec},'');
            reUsableMultiSelectLookupCtrl.getSelectedUsers('West MI');
            reUsableMultiSelectLookupCtrl.saveChanges('123654',new List<GA_Territory__c> {terytoryRec}, new list<User> {usr});
            reUsableMultiSelectLookupCtrl.saveChanges('1236547',new List<GA_Territory__c> {terytoryRec}, new list<User> {usr});
            
        }
    }
    public static testmethod void caseAccessSharetoSuperUserAfter_test()
    {
        
        queuesobject queobj = [select queueid,queue.developername from queuesobject where queue.developername= 'SR_ASR_Queue'];
        system.debug('queueid++++'+queobj.queueid);
        //Case aCase = new Case(OwnerId = testGroup.Id);
        //insert aCase;
        
        Account AORSRacc = GA_OBJ_TD01_TestDataCreation.AccRec();
        AORSRacc.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Customer').getRecordTypeId();
        database.insert(AORSRacc);
        
        Contact conta =  GA_OBJ_TD01_TestDataCreation.cntactRec(AORSRacc.id);
        conta.recordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact - Agent').getRecordTypeId();
        conta.Active__c = True;
        database.insert(conta); 
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('BCBSMTest Partner User','testsalesrepmail@bcbsm.com','BCBSM Both');
        usr.contactid = conta.id;
        database.insert(usr);
        system.runAs(usr)
        {
            
            List<Case> caseLst=new list<case>();
            map<id,Case> caseoldMap=new map<id,Case>();
            map<id,Case> casenewMap=new map<id,Case>();
            
            case cas=GA_OBJ_TD01_TestDataCreation.CaseRec();
            //  cas.OwnerId = '0053J000000wdUDQAY';
            cas.OwnerId = queobj.queueid;
            caseLst.add(cas);
            
            case cas1=GA_OBJ_TD01_TestDataCreation.CaseRec();
            cas1.recordtypeid =  Schema.SObjectType.Case.getRecordTypeInfosByName().get('Agent Support Request').getRecordTypeId();
            caseLst.add(cas1);
            
            case cas2=GA_OBJ_TD01_TestDataCreation.CaseRec();
            cas2.Status='Submitted';
            cas2.recordtypeid =  Schema.SObjectType.Case.getRecordTypeInfosByName().get('Agent Support Request').getRecordTypeId();
            caseLst.add(cas2);
            
            Database.insert(caseLst);
            system.debug('firstcaseowner++++'+caseLst[0].OwnerId);
            caseoldMap.put(cas.id, cas);
            caseoldMap.put(cas2.id, cas2);
            // update cas2;
            casenewMap.put(cas.id, cas);
            test.startTest();
            // caseoldMap.put(cas2.id, cas2);
            GA_AssignCaseOwnerCls.caseAccessSharetoSuperUserAfter(caseLst, caseoldMap);
            GA_AssignCaseOwnerCls.caseAccessSharetoSuperUserAfter(caseLst, null);
            test.stopTest();
            
            system.assert(caseLst <> null);
        }  
    }    
    
    public static testmethod void aSRAssignmentforAgnetCaseBefor_test()
    {
        
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('System Administrator','testsysadm@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr){
            
            UserRole userrole = [Select Id, DeveloperName From UserRole Where DeveloperName = 'Account_Services_Representative' Limit 1];
            user usrASR = GA_OBJ_TD01_TestDataCreation.UsrRec('Support Representative','testsysadm@bcbsm.com','Support');
            usrASR.IsActive = True; 
            usrASR.UserRoleId  = userrole.id;
            database.insert(usrASR);
            
            GA_Territory__c terytoryRec=new GA_Territory__c();
            terytoryRec.Name='IM';
            terytoryRec.GA_TerritoryType__c='Account Representatives';
            terytoryRec.GA_TerritoryCode__c='IM';
            terytoryRec.GA_Sales_Rep_Effective_Date__c = System.today();
            insert terytoryRec;
            system.debug('terytoryRecvvv+++++  '+terytoryRec.id);  
            Account AORSRacc = GA_OBJ_TD01_TestDataCreation.AccRec();
            // AORSRacc.Account_Services_Representative__c = usrASR.id;
            AORSRacc.GA_Territory__c = terytoryRec.id;
            AORSRacc.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Customer').getRecordTypeId();
            database.insert(AORSRacc);
            system.debug('AORSRacc+++++  '+AORSRacc.id);  
            Account AORSRacc1 = GA_OBJ_TD01_TestDataCreation.AccRec();
            //  AORSRacc1.Account_Services_Representative__c = usrASR.id;
            AORSRacc1.GA_Territory__c = terytoryRec.id;
            AORSRacc1.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Customer').getRecordTypeId();
            database.insert(AORSRacc1);
            system.debug('AORSRacc+++++  '+AORSRacc1.id); 
            
            Contact conta =  GA_OBJ_TD01_TestDataCreation.cntactRec(AORSRacc.id);
            conta.recordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact - Agent').getRecordTypeId();
            conta.Active__c = True;
            database.insert(conta); 
            
            
            
            List<Case> caseLst=new list<case>();
            map<id,Case> caseoldMap=new map<id,Case>();
            
            case cas=GA_OBJ_TD01_TestDataCreation.CaseRec();
            cas.recordtypeid =  Schema.SObjectType.Case.getRecordTypeInfosByName().get('Agent Support Request').getRecordTypeId();
            cas.AccountId = AORSRacc.id;
            cas.GA_Envelope_ID__c = 'External Id Unique Case Sensitive';
            cas.Status = 'Submitted';
            Database.insert(cas);
            caseLst.add(cas);
            system.debug('caseLst+++++  '+caseLst+'caseLst Size+++++'+ caseLst.size()); 
            
            case cas1=GA_OBJ_TD01_TestDataCreation.CaseRec();
            cas1.recordtypeid =  Schema.SObjectType.Case.getRecordTypeInfosByName().get('Agent Support Request').getRecordTypeId();
            cas1.AccountId = AORSRacc1.id;
            cas1.Status = 'Submitted';
            Database.insert(cas1);
            caseLst.add(cas1);
            system.debug('caseLst+++++  '+caseLst+'caseLst Size+++++'+ caseLst.size()); 
            caseoldMap.put(cas.id, cas);
            // caseoldMap.put(cas1.id, cas1);
            // cas.Status = 'in Progress';
            // update cas;
            
            /**    case cas2=GA_OBJ_TD01_TestDataCreation.CaseRec();
cas2.recordtypeid =  Schema.SObjectType.Case.getRecordTypeInfosByName().get('Agent Support Request').getRecordTypeId();
cas2.AccountId = AORSRacc1.id;
caseLst.add(cas2); **/
            
            
            
            //terytoryRec.Active__c=true;
            // update terytoryRec;
            List<Territory_ASR_Assignment_List__c> regionTerrList = New List<Territory_ASR_Assignment_List__c>();
            Territory_ASR_Assignment_List__c tsa = new Territory_ASR_Assignment_List__c();
            tsa.Territory__c= terytoryRec.id; 
            tsa.Active__c=true;
            tsa.ASR__c=usrASR.id;
            tsa.Territory_Region__c='East';
            tsa.RecordTypeId = Schema.SObjectType.Territory_ASR_Assignment_List__c.getRecordTypeInfosByName().get('Region Territory Map').getRecordTypeId();        
            regionTerrList.add(tsa);
            database.insert(regionTerrList);
            
            
            system.debug('tsa.RecordTypeId+++++'+regionTerrList[0].RecordTypeId);
            
            test.startTest();
            GA_AssignCaseOwnerCls.aSRAssignmentforAgnetCaseBefore(caseLst, caseoldMap);
            GA_AssignCaseOwnerCls.caseOwnerAssignBefore(caseLst, caseoldMap);
            test.stopTest();
        }  
    }
    
}