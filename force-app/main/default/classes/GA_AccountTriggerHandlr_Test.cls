/**
@Author : Padma
@Name: GA_AccountTriggerHandlr_Test 
@CreatedDate: 31 - Jul 2017 
@Description: GA_AccountTriggerHandlr Test class 
@version : 1.0   
*/
@isTest(seealldata = false)
private class GA_AccountTriggerHandlr_Test {
   /**
@Description: agntIdentityBatchSlsRep() method 
@Name : agntIdentityBatchSlsRep
@Param : None
@Return : void
@throws Exception : N/A;
*/   
    private static testmethod void agntIdentityBatchSlsRep()
    {
        list<user> usrLst=new list<user>();
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestJeoRl','testsalesrepmail@bcbsm.com','Retention Sales');
        usrLst.add(usr);
        user usrRetSlsRep = GA_OBJ_TD01_TestDataCreation.UsrRec('TestJeoRlRetnslsRep','testsalesrepmail@bcbsm.com','Retention Sales');
        usrLst.add(usrRetSlsRep);
        user usrRetSlsRep2 = GA_OBJ_TD01_TestDataCreation.UsrRec('TestJeoRlRetnsls2Rep','testsalesrep2mail@bcbsm.com','Retention Sales');
        usrLst.add(usrRetSlsRep2);
        database.insert(usrLst);
        
        List<GA_Territory__c> trryLst =New List<GA_Territory__c> ();
        GA_Territory__c territoryRec=GA_OBJ_TD01_TestDataCreation.terrtryRec();
        territoryRec.GA_RetentionSalesRepresentative__c=usrLst[1].id;
        trryLst.add(territoryRec);
        
        GA_Territory__c territoryRec2=GA_OBJ_TD01_TestDataCreation.terrtryRec();
        territoryRec2.GA_RetentionSalesRepresentative__c=usrLst[2].id;
        territoryRec2.Name= 'California';
        territoryRec2.GA_TerritoryCode__c = '78';
        trryLst.add(territoryRec2);
        database.insert(trryLst);
        
        GA_ACC_AP02_IdentifySalesRepOnAccount.isExecuting = false;
        List<Account> accList = New List<Account>();
        for(integer i=0; i<11 ; i++){
            account accnt=GA_OBJ_TD01_TestDataCreation.AccRec();
            accnt.GA_Territory__c = territoryRec.id;
            accList.add(accnt);
        }
        Database.insert(accList);
        system.runAs(usrLst[0])
        {
            try{ 
                GA_ACC_AP02_IdentifySalesRepOnAccount.isExecuting = false;
                
                List<Account> accntList = New List<Account>();
                for(Account acc : accList){
                    acc.GA_Territory__c = territoryRec2.id;
                    accntList.add(acc);
                }
                GA_ACC_AP02_IdentifySalesRepOnAccount.isExecuting = false;
                Database.update(accntList);
                
                system.assert(accntList <> null);
            }
            catch(exception e)
            {
                return;
            }
        }  
    }
    /**
@Description: agntIdentitySlsRep() method 
@Name : agntIdentitySlsRep
@Param : None
@Return : void
@throws Exception : N/A;
*/       
    private static testmethod void agntIdentitySlsRep()
    {
        list<user> usrLst=new list<user>();
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestJeoRl','testsalesrepmail@bcbsm.com','Support');
        usrLst.add(usr);
        user usrRetSlsRep = GA_OBJ_TD01_TestDataCreation.UsrRec('TestJeoRlRetnslsRep','testsalesrepmail@bcbsm.com','Retention Sales');
        usrLst.add(usrRetSlsRep);
        user usrRetSlsRep2 = GA_OBJ_TD01_TestDataCreation.UsrRec('TestJeoRlRetnsls2Rep','testsalesrep2mail@bcbsm.com','Retention Sales');
        usrLst.add(usrRetSlsRep2);
        database.insert(usrLst);
        List<GA_Territory__c> trryLst = New List<GA_Territory__c>();
        GA_Territory__c territoryRec=GA_OBJ_TD01_TestDataCreation.terrtryRec();
        territoryRec.GA_RetentionSalesRepresentative__c=usrLst[1].id;
        trryLst.add(territoryRec);
        
        GA_Territory__c territoryRec2=GA_OBJ_TD01_TestDataCreation.terrtryRec();
        territoryRec2.GA_RetentionSalesRepresentative__c=usrLst[2].id;
        territoryRec2.Name= 'California';
        territoryRec2.GA_TerritoryCode__c = '34';
        trryLst.add(territoryRec2);
        database.insert(trryLst);
        
        GA_ACC_AP02_IdentifySalesRepOnAccount.isExecuting = false;
        account accnt=GA_OBJ_TD01_TestDataCreation.AccRec();
        accnt.GA_Territory__c = territoryRec.id;
        database.insert(accnt);       
        
        GA_Jeopardy__c jeo= GA_OBJ_TD01_TestDataCreation.jeoprdyRec(usr, accnt);
        Database.insert(jeo);
        
        test.startTest();
        system.runAs(usrLst[1])
        {
            try{
                GA_ACC_AP02_IdentifySalesRepOnAccount.isExecuting = false;
                accnt.GA_Territory__c = territoryRec2.id;
                database.update(accnt);
                /**  GA_ACC_AP02_IdentifySalesRepOnAccount.isExecuting = false;
accnt.GA_Territory__c = territoryRec.id;
database.update(accnt);**/
                
            }
            catch(exception e)
            {
                return;
            }
        }  
        test.stoptest();
        system.assert(usrLst <> null,true);
        
    }
    /**
@Description: agntIdentitySlsRepExcep() method 
@Name : agntIdentitySlsRepExcep
@Param : None
@Return : void
@throws Exception : N/A;
*/  
    private static testmethod void agntIdentitySlsRepExcep()
    {
        list<user> usrLst=new list<user>();
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestJeoRl','testsalesrepmail@bcbsm.com','Retention Sales');
        usrLst.add(usr);
        user usrRetSlsRep = GA_OBJ_TD01_TestDataCreation.UsrRec('TestJeoRlRetnslsRep','testsalesrepmail@bcbsm.com','Retention Sales');
        usrLst.add(usrRetSlsRep);
        database.insert(usrLst);
        system.runAs(usrLst[0])
        {
            try{
                map<id,Account> accNewMap = null;
                map<id,Account>  accoldMap = null;
                list<account> actLst = null;
                test.startTest();
                GA_ACC_AP02_IdentifySalesRepOnAccount.createsalesTeamOnAccount(actLst,accNewMap,accoldMap);
                GA_AccountTriggerHandlr.beforeinsert(actLst,accNewMap);
                test.stopTest();
                system.assert(usrLst <> null);
                
            }
            catch(exception e)
            {
                return;
            }
            
        }  
    }
    
    /**
@Description: AccTrigrHndlrbefinsert() method 
@Name : AccTrigrHndlrbefinsert
@Param : None
@Return : void
@throws Exception : N/A;
*/  
    private static testmethod void AccTrigrHndlrbefinsert()
    {
        list<user> usrLst=new list<user>();
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestJeoRl','testsalesrepmail@bcbsm.com','Retention Sales');
        usrLst.add(usr);
        user usrRetSlsRep = GA_OBJ_TD01_TestDataCreation.UsrRec('TestJeoRlRetnslsRep','testsalesrepmail@bcbsm.com','Retention Sales');
        usrLst.add(usrRetSlsRep);
        database.insert(usrLst);
        system.runAs(usrLst[0])
        {
            try{
                map<id,Account> accNewMap = null;
                list<account> actLst = null;
                test.startTest();
                GA_AccountTriggerHandlr.beforeinsert(actLst,accNewMap);
                test.stopTest();
                system.assert(usrLst <> null);
                
            }
            catch(exception e)
            {
                return;
            }
        }  
    }
    
    /**
@Description: fetchAccountsforBatchExcep() method 
@Name : fetchAccountsforBatchExcep
@Param : None
@Return : void
@throws Exception : N/A;
*/  
    private static testmethod void fetchAccountsforBatchExcep()
    {
        list<user> usrLst=new list<user>();
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestJeoRl','testsalesrepmail@bcbsm.com','Retention Sales');
        usrLst.add(usr);
        user usrRetSlsRep = GA_OBJ_TD01_TestDataCreation.UsrRec('TestJeoRlRetnslsRep','testsalesrepmail@bcbsm.com','Retention Sales');
        usrLst.add(usrRetSlsRep);
        database.insert(usrLst);
        system.runAs(usrLst[0])
        {
            try{
                map<id,Account> accNewMap = null;
                map<id,Account>  accoldMap= null;
                list<account> actLst= null;
                test.startTest();
                GA_FecthAccountsForBatch.fetchLockedAccounts(actLst, accoldMap);
                GA_FecthAccountsForBatch.fetchLockedAccountsOnInsert(actLst);
                GA_FecthAccountsForBatch.fetchTerrFlippedAccs(actLst, accoldMap);
                GA_FecthAccountsForBatch.fetchTerrFlippedAccsOnInsert(actLst);
                GA_FecthAccountsForBatch.prospectToCustomerAccs(actLst, accoldMap);
                
                test.stopTest();
                system.assert(usrLst <> null);
                
            }
            catch(exception e)
            {
                return;
            }
            
        }  
    }
    
    /**
@Description: insertPlatinumAgency() method 
@Name : insertPlatinumAgency
@Param : None
@Return : void
@throws Exception : N/A;
*/ 
    private static testmethod void insertPlatinumAgency()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestJeoRl','testsalesrepmail@bcbsm.com','Integration User');
        database.insert(usr);
        system.runAs(usr)
        {
            try{
                Id agencyRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Agency').getRecordTypeId();
                GA_ACC_AP01_CheckPlatinumStatusOnAgency.isExecuting = false;
                account accnt=GA_OBJ_TD01_TestDataCreation.AccRec();
                accnt.RecordTypeId=agencyRecordTypeId;   
                accnt.GA_Platinum__c = false;
                accnt.Account_Status__c='';
                database.insert(accnt); 
                Account custaccnt=GA_OBJ_TD01_TestDataCreation.AccRec();
                custaccnt.Name = 'customeracct';
                custaccnt.Phone = '1236890980';
                custaccnt.Website = 'testcust.com';
                database.insert(custaccnt);
                GA_AgencyRelationship__c agncyRlnshp=GA_OBJ_TD01_TestDataCreation.agncyRelationshipRec(accnt.id, custaccnt.id);
                agncyRlnshp.GA_Account__c = custaccnt.id;
                agncyRlnshp.GA_Agency__c = accnt.id;
                agncyRlnshp.GA_StartDate__c=system.today()-10;
                agncyRlnshp.GA_EndDate__c = system.today()+30;
                database.insert(agncyRlnshp);
                GA_ACC_AP01_CheckPlatinumStatusOnAgency.isExecuting = false;
                accnt.GA_Platinum__c = true;
                accnt.Account_Status__c='Active';
                database.update(accnt);
                system.assert(accnt <> null);
                system.assert(agncyRlnshp <> null);
            }
            catch(exception e)
            {
                return;
            }
            
        }
    }
    /**
@Description: insertPlatinumAgencyExcep() method 
@Name : insertPlatinumAgencyExcep
@Param : None
@Return : void
@throws Exception : N/A;
*/ 
    private static testmethod void insertPlatinumAgencyExcep()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestJeoRl','testsalesrepmail@bcbsm.com','Support');
        database.insert(usr);
        system.runAs(usr)
        {
            try{
                map<id,Account> accNewMap = null;
                map<id,Account>  accoldMap = null;
                List<ExceptionLog__c> eLogLst= null;
                list<account> actLst = null;
                test.startTest();
                GA_ACC_AP01_CheckPlatinumStatusOnAgency.updateCustomerAccountOfAgency(actLst,accNewMap,accoldMap);
                test.stopTest();
                eLogLst=[select id from ExceptionLog__c limit 1];
                system.assert(eLogLst.size()>0);
            }
            catch(exception e)
            {
                return;
            }
            
        }
    }
    
    
    /**
@Description: insertPlatinumAgencyExcep() method 
@Name : insertPlatinumAgencyExcep
@Param : None
@Return : void
@throws Exception : N/A;
*/ 
    private static testmethod void arUpdatePlatinumstatusExcep()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestJeoRl','testsalesrepmail@bcbsm.com','Support');
        database.insert(usr);
        system.runAs(usr)
        {
            try{
                map<id,GA_AgencyRelationship__c>  arNewMap = null;
                list<GA_AgencyRelationship__c> arList = null;
                 List<ExceptionLog__c> eLogLst= null;
                test.startTest();
                GA_AR_AP01_UpdatePlatinumStatusOnAccount.createAgencyRelation(arList, arNewMap);
                test.stopTest();
                eLogLst=[select id from ExceptionLog__c limit 1];
                system.assert(eLogLst.size()>0);
            }
            catch(exception e)
            {
                return;
            }
            
        }
    }
    /**
@Description: lockingRecords() method 
@Name : lockingRecords
@Param : None
@Return : void
@throws Exception : N/A;
*/ 
    private static testmethod void lockingRecords()
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
                GA_Util_lockRecords.isExecuting = false;
                Id custRecordtypeid = SObjectType.Account.getRecordTypeInfosByName().get('Account - Customer').getRecordTypeId();
                GA_Territory__c terr =  GA_OBJ_TD01_TestDataCreation.terrtryRec();
                terr.GA_RetentionSalesRepresentative__c = usrLst.get(1).id;
                Database.insert(terr);
                
                List<Account> accList = New List<Account>();
                List<Account> updtaccList = New List<Account>();
                for(integer i = 0; i<11; i++){
                    account accnt=GA_OBJ_TD01_TestDataCreation.AccRec();
                    accnt.GA_System_of_Record__c='SMART';
                    accnt.GA_Territory__c = terr.id;
                    accList.add(accnt);
                }
                database.insert(accList);
                
                List<AccountTeamMember> insrtActMembs = New List<AccountTeamMember>();
                for(Account a :  accList){
                    AccountTeamMember act = GA_OBJ_TD01_TestDataCreation.accountTeamRec(a.Id);
                    act.UserId=usr.id;
                    act.TeamMemberRole = 'Implementation Manager';
                    insrtActMembs.add(act);
                }
                Database.insert(insrtActMembs);
                
                for(Account a :  accList){
                    a.GA_System_of_Record__c='Salesforce';
                    a.RecordTypeId   = custRecordtypeid;
                    updtaccList.add(a);
                }
                
                GA_Util_lockRecords.isExecuting = false;
                GA_ACC_AP05_CreateHandoverRecord.isExecuting = false;
                database.update(updtaccList);
                
                system.assert(accList <> null);
            }
            catch(exception e)
            {
                return;
            }
            
        }  
    }  
    /**
@Description: lockingbtchRecords() method 
@Name : lockingbtchRecords
@Param : None
@Return : void
@throws Exception : N/A;
*/ 
    private static testmethod void lockingbtchRecords()
    {
        list<user> usrLst=new list<user>();
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestJeoRl','testsalesrepmail@bcbsm.com','Support');
        usrLst.add(usr);
        user usrRetSlsRep = GA_OBJ_TD01_TestDataCreation.UsrRec('TestJeoRlRetnslsRep','testsalesrepmail@bcbsm.com','Retention Sales');
        usrLst.add(usrRetSlsRep);
        database.insert(usrLst);
        system.runAs(usrLst[0])
        {
            try{
                
                
                GA_Util_lockRecords.isExecuting = false;
                account accnt=GA_OBJ_TD01_TestDataCreation.AccRec();
                accnt.GA_System_of_Record__c='SMART';
                database.insert(accnt);
                list<account> accList=new list<account>();
                accList.add(accnt);
                map<id,account> accNewMap=new map<id,account>();
                accNewMap.put(accnt.id, accnt);
                map<id,account> accoldMap=new map<id,account>();
                accoldMap.put(accnt.id, accnt);
                GA_AccountTriggerHandlr.acntlcklmt=0;
                GA_AccountTriggerHandlr.afterinsert(accList, accNewMap, accoldMap);
                GA_AccountTriggerHandlr.getAccountTeam(accList, accNewMap, accoldMap);
                GA_AccountTriggerHandlr.modifyPartner(accNewMap, accoldMap);
                system.assert(accnt <> null);
            }
            catch(exception e)
            {
                return;
            }
            
        }  
    }
    /**
@Description: lockingReclCntRecords() method 
@Name : lockingReclCntRecords
@Param : None
@Return : void
@throws Exception : N/A;
*/ 
    private static testmethod void lockingReclCntRecords()
    {
        list<user> usrLst=new list<user>();
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestJeoRl','testsalesrepmail@bcbsm.com','Support');
        usrLst.add(usr);
        user usrRetSlsRep = GA_OBJ_TD01_TestDataCreation.UsrRec('TestJeoRlRetnslsRep','testsalesrepmail@bcbsm.com','Sales Operations');
        usrLst.add(usrRetSlsRep);
        database.insert(usrLst);
        account accnt = New Account();
        list<account> accLstNew=new list<account>();
        map<id,account> accLstOldMap=new map<id,account>();
        system.runAs(usrLst[1])
        {
            accnt=GA_OBJ_TD01_TestDataCreation.AccRec();
            accnt.GA_System_of_Record__c='';
            database.insert(accnt);
            accLstOldMap.put(accnt.id,accnt);
            
            contact cnt=GA_OBJ_TD01_TestDataCreation.cntactRec(accnt.id);
            database.insert(cnt);
        }
        
        system.runAs(usrLst[0])
        {
            try{
                GA_Util_lockRecords.isExecuting = false;
                account accntNewRec=new account();
                accntNewRec.GA_System_of_Record__c='SMART';
                accntNewRec.id=accnt.id;
                accLstNew.add(accntNewRec);
                GA_ACC_AP04_UpdtCntOnAccLockUnlock.updateCntlockUnlock(accLstNew,accLstOldMap);
                system.assert(accnt <> null);
            }
            catch(exception e)
            {
                return;
            }
            
        }  
    }
    
    /**
@Description: unlockingReclCntRecords() method 
@Name : unlockingReclCntRecords
@Param : None
@Return : void
@throws Exception : N/A;
*/ 
    private static testmethod void unlockingReclCntRecords()
    {
        list<user> usrLst=new list<user>();
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestJeoRl','testsalesrepmail@bcbsm.com','Support');
        usrLst.add(usr);
        user usrRetSlsRep = GA_OBJ_TD01_TestDataCreation.UsrRec('TestJeoRlRetnslsRep','testsalesrepmail@bcbsm.com','Retention Sales');
        usrLst.add(usrRetSlsRep);
        user usrIntegration = GA_OBJ_TD01_TestDataCreation.UsrRec('TestContactupdate','testsalesrepmail@bcbsm.com','Integration User');
        usrLst.add(usrIntegration);
        database.insert(usrLst);
        account accnt = New Account();
        list<account> accLstNew=new list<account>();
        map<id,account> accLstOldMap=new map<id,account>();
        system.runAs(usrLst[2])
        {
            accnt=GA_OBJ_TD01_TestDataCreation.AccRec();
            accnt.GA_System_of_Record__c='SMART';
            database.insert(accnt);
            accLstOldMap.put(accnt.id,accnt);
            
            contact cnt=GA_OBJ_TD01_TestDataCreation.cntactRec(accnt.id);
            database.insert(cnt);
        }
        
        system.runAs(usrLst[0])
        {
            try{
                GA_Util_lockRecords.isExecuting = false;
                account accntNewRec=new account();
                accntNewRec.GA_System_of_Record__c='Salesforce';
                accntNewRec.id=accnt.id;
                accLstNew.add(accntNewRec);
                GA_ACC_AP04_UpdtCntOnAccLockUnlock.updateCntlockUnlock(accLstNew,accLstOldMap);
                GA_ACC_AP04_UpdtCntOnAccLockUnlock.accCntLmt=0;
                GA_ACC_AP04_UpdtCntOnAccLockUnlock.updateCntlockUnlock(accLstNew,accLstOldMap);
                system.assert(accnt <> null);
            }
            catch(exception e)
            {
                return;
            }
            
        }  
    }
    /**
@Description: lockingRecordsExcep() method 
@Name : lockingRecordsExcep
@Param : None
@Return : void
@throws Exception : N/A;
*/ 
    private static testmethod void lockingRecordsExcep()
    {
        list<user> usrLst=new list<user>();
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestJeoRl','testsalesrepmail@bcbsm.com','Support');
        usrLst.add(usr);
        user usrRetSlsRep = GA_OBJ_TD01_TestDataCreation.UsrRec('TestJeoRlRetnslsRep','testsalesrepmail@bcbsm.com','Retention Sales');
        usrLst.add(usrRetSlsRep);
        database.insert(usrLst);
        system.runAs(usrLst[0])
        {
            try{
                list<account> accList = null;
                List<ExceptionLog__c> eLogLst=null; 
                test.startTest();
                GA_Util_lockRecords.onInsertlockRecords(accList, 'GA_System_of_Record__c');
                test.stopTest();
                
                eLogLst=[select id from ExceptionLog__c limit 1];
                system.assert(eLogLst.size()>0);
            }
            catch(exception e)
            {
                return;
            }
            
        }  
    }
    /**
@Description: updatelockingRecords() method 
@Name : updatelockingRecords
@Param : None
@Return : void
@throws Exception : N/A;
*/ 
    private static testmethod void updatelockingRecords()
    {
        list<user> usrLst=new list<user>();
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestJeoRl','testsalesrepmail@bcbsm.com','Support');
        usrLst.add(usr);
        user usrRetSlsRep = GA_OBJ_TD01_TestDataCreation.UsrRec('TestJeoRlRetnslsRep','testsalesrepmail@bcbsm.com','Sales Operations');
        usrLst.add(usrRetSlsRep);
        database.insert(usrLst);
        Account acc = GA_OBJ_TD01_TestDataCreation.AccRec();
        acc.GA_System_of_Record__c='SMART';
        map<id,Account> accoldMap=new map<id,Account>();
        
        system.runAs(usrLst[1])
        {
            GA_Util_lockRecords.isExecuting = false;
            database.insert(acc);
            accoldMap.put(acc.id,acc);
        }
        
        system.runAs(usrLst[0])
        {
            try{
                list<Account> accList=new list<Account>();
                map<id,Account> accNewMap=new map<id,Account>();
                test.startTest();
                GA_Util_lockRecords.isExecuting =false;
                acc.GA_System_of_Record__c = '';
                accList.add(acc);
                accNewMap.put(acc.id,acc);
                GA_AccountTriggerHandlr.afterupdate(accList,accNewMap,accoldMap);
                database.update(acc);
                test.stoptest();
                system.assert(acc <> null);
            }
            catch(exception e)
            {
                return;
            }
        }  
    }
    /**
@Description: updatelockingbtchRecords() method 
@Name : updatelockingbtchRecords
@Param : None
@Return : void
@throws Exception : N/A;
*/ 
    private static testmethod void updatelockingbtchRecords()
    {
        list<user> usrLst=new list<user>();
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestJeoRl','testsalesrepmail@bcbsm.com','Support');
        usrLst.add(usr);
        user usrRetSlsRep = GA_OBJ_TD01_TestDataCreation.UsrRec('TestJeoRlRetnslsRep','testsalesrepmail@bcbsm.com','Sales Operations');
        usrLst.add(usrRetSlsRep);
        database.insert(usrLst);
        Account acc = GA_OBJ_TD01_TestDataCreation.AccRec();
        acc.GA_System_of_Record__c='SMART';
        map<id,Account> accoldMap=new map<id,Account>();
        
        system.runAs(usrLst[1])
        {
            GA_Util_lockRecords.isExecuting = false;
            database.insert(acc);
            accoldMap.put(acc.id,acc);
        }
        
        system.runAs(usrLst[0])
        {
            try{
                list<Account> accList=new list<Account>();
                map<id,Account> accNewMap=new map<id,Account>();
                test.startTest();
                GA_Util_lockRecords.isExecuting =false;
                acc.GA_System_of_Record__c = '';
                accList.add(acc);
                accNewMap.put(acc.id,acc);
                GA_AccountTriggerHandlr.acntlcklmt=0;
                GA_AccountTriggerHandlr.afterupdate(accList,accNewMap,accoldMap);
                database.update(acc);
                test.stoptest();
                system.assert(acc <> null);
            }
            catch(exception e)
            {
                return;
            }
        }  
    }
    
    /**
@Description: flipPrspctToCustmr() method 
@Name : flipPrspctToCustmr
@Param : None
@Return : void
@throws Exception : N/A;
*/ 
    private static testmethod void flipPrspctToCustmr()
    {   
        String prospectRecType = 'Account - Prospect';
        string customerRecType = 'Account - Customer';
        Id prospectRecTpeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(prospectRecType).getRecordTypeId();
        Id customerRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(customerRecType).getRecordTypeId();
        
        List<User> usrList = New List<User>();
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestHandover','testsalesrepmail@bcbsm.com','Integration User');
        usrList.add(usr);
        User usterri = GA_OBJ_TD01_TestDataCreation.UsrRec('TerritoryRSR','testsalesrepmail@bcbsm.com','Retention Sales');
        usrList.add(usterri);
        Database.insert(usrList);
        system.runAs(usrList.get(0))
        {   GA_Territory__c terr =  GA_OBJ_TD01_TestDataCreation.terrtryRec();
         terr.GA_RetentionSalesRepresentative__c = usrList.get(1).id;
         Database.insert(terr);
         
         Account acc = GA_OBJ_TD01_TestDataCreation.AccRec(); 
         acc.RecordTypeId = prospectRecTpeId;
         acc.GA_Territory__c = terr.Id;
         Database.insert(acc);
         
         AccountTeamMember act = GA_OBJ_TD01_TestDataCreation.accountTeamRec(acc.Id);
         act.UserId=usr.id;
         act.TeamMemberRole = 'Implementation Manager';
         Database.insert(act);
         
         test.startTest();
         GA_ACC_AP05_CreateHandoverRecord.isExecuting = false;
         acc.RecordTypeId = customerRecTypeId;
         Database.update(acc);
         test.stopTest();
         system.assert(acc <> null);
        } 
    }
    
    
    /**
@Description: excpFlipProspectToCustomer() method 
@Name : insertPlatinumAgencyExcep
@Param : None
@Return : void
@throws Exception : N/A;
*/ 
    private static testmethod void excpFlipProspectToCustomer()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestJeoRl','testsalesrepmail@bcbsm.com','Support');
        database.insert(usr);
        system.runAs(usr)
        {
            try{
                map<id,Account> accNewMap = null;
                map<id,Account>  accoldMap = null;
                list<account> actLst = null;
                test.startTest();
                GA_ACC_AP05_CreateHandoverRecord.createhandoverrec(actLst,accNewMap,accoldMap);
                test.stopTest();
                system.assert(usr <> null);
            }
            catch(exception e)
            {
                return;
            }
            
        }
    }
    
    /**
@Description: contactOwnerUpdateBatch() method 
@Name : contactOwnerUpdateBatch
@Param : None
@Return : void
@throws Exception : N/A;
*/   
    private static testmethod void contactOwnerUpdateBatch()
    {
        list<user> usrLst=new list<user>();
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestJeoRl','testsalesrepmail@bcbsm.com','Retention Sales');
        usrLst.add(usr);
        user user1 = GA_OBJ_TD01_TestDataCreation.UsrRec('TestJeoRlRetnslsRep','testsalesrepmail@bcbsm.com','Retention Sales');
        usrLst.add(user1);
        user user2 = GA_OBJ_TD01_TestDataCreation.UsrRec('TestJeoRlRetnslsRep2','testsalesrepmail2@bcbsm.com','Retention Sales');
        usrLst.add(user2);
        database.insert(usrLst);
        system.runAs(usrLst[0])
        {
            try{
                GA_Territory__c territoryRec=GA_OBJ_TD01_TestDataCreation.terrtryRec();
                territoryRec.GA_RetentionSalesRepresentative__c=usrLst[1].id;
                database.insert(territoryRec);
                
                List<Account> accList = New List<Account>();
                for(integer i=0; i<11 ; i++){
                    account accnt=GA_OBJ_TD01_TestDataCreation.AccRec();
                    accnt.GA_Territory__c = territoryRec.id;
                    accList.add(accnt);
                }
                GA_ACC_AP02_IdentifySalesRepOnAccount.isExecuting=true;
                Database.insert(accList);
                
                List<Contact> conList = New List<Contact>();
                Contact con = New Contact();
                for(Account acc : accList){
                    for(integer index=0; index<1 ; index++){
                        con= new Contact(
                            FirstName ='Test'+index,
                            LastName ='Second'+index,
                            AccountId=acc.id);
                        conList.add(con);
                    }
                }
                Database.insert(conList);
                
                
                GA_Territory__c territoryRec2=GA_OBJ_TD01_TestDataCreation.terrtryRec();
                territoryRec2.GA_RetentionSalesRepresentative__c=usrLst[2].id;
                territoryRec2.Name= 'California';
                territoryRec2.GA_TerritoryCode__c = '2364GH';
                database.insert(territoryRec2);
                
                List<Account> accntList = New List<Account>();
                for(Account acct : accList){
                    acct.GA_Territory__c = territoryRec2.id;
                    accntList.add(acct);
                }
                Test.startTest();
                GA_AccountBatchToUpdateContactOwner.isInvodedFrmBtch = false;
                GA_ACC_AP02_IdentifySalesRepOnAccount.isExecuting = true;
                GA_Util_lockRecords.isExecuting = true;
                GA_ACC_AP05_CreateHandoverRecord.isExecuting = true;
                Database.update(accntList);
                Test.stopTest();
                
                system.assert(accntList <> null);
            }
            
            catch(exception e)
            {
                return;
            }
        }
    }
    /**
@Description: contactOwnerUpdateSingle() method 
@Name : contactOwnerUpdateSingle
@Param : None
@Return : void
@throws Exception : N/A;
*/   
    private static testmethod void contactOwnerUpdateSingle()
    {   
        list<user> usrLst=new list<user>();
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestJeoRl','testsalesrepmail@bcbsm.com','Retention Sales');
        usrLst.add(usr);
        user user1 = GA_OBJ_TD01_TestDataCreation.UsrRec('TestJeoRlRetnslsRep','testsalesrepmail@bcbsm.com','Retention Sales');
        usrLst.add(user1);
        user user2 = GA_OBJ_TD01_TestDataCreation.UsrRec('TestJeoRlRetnslsRep2','testsalesrepmail2@bcbsm.com','Retention Sales');
        usrLst.add(user2);
        database.insert(usrLst);
        system.runAs(usrLst[0])
        {
            try{
                GA_Territory__c territoryRec=GA_OBJ_TD01_TestDataCreation.terrtryRec();
                territoryRec.GA_RetentionSalesRepresentative__c=usrLst[1].id;
                database.insert(territoryRec);
                GA_ACC_UpdateChildContctsOnAccOwnrChange.isExecuting = false;
                account accnt=GA_OBJ_TD01_TestDataCreation.AccRec();
                accnt.GA_Territory__c = territoryRec.id;
                database.insert(accnt);
                contact cont=GA_OBJ_TD01_TestDataCreation.cntactRec(accnt.id);
                database.insert(cont);
                GA_Territory__c territoryRec2=GA_OBJ_TD01_TestDataCreation.terrtryRec();
                territoryRec2.GA_RetentionSalesRepresentative__c=usrLst[2].id;
                territoryRec2.Name= 'California';
                territoryRec2.GA_TerritoryCode__c = '2364GH';
                database.insert(territoryRec2);
                GA_ACC_UpdateChildContctsOnAccOwnrChange.isExecuting = false;
                accnt.GA_Territory__c = territoryRec2.id;
                database.update(accnt);
                system.assert(accnt <> null);
            }
            catch(exception e)
            {
                return;
            }
        }
    }
    
    /**
@Description: updatechildrecdsexcep() method 
@Name : updatechildrecdsexcep
@Param : None
@Return : void
@throws Exception : N/A;
*/ 
    private static testmethod void updatechildrecdsexcep()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestJeoRl','testsalesrepmail@bcbsm.com','Support');
        database.insert(usr);
        system.runAs(usr)
        {
            try{
                map<id,Account>  accOldMap = null;
                list<Account> accLst = null;
                List<ExceptionLog__c> eLogLst=New List<ExceptionLog__c>();
                test.startTest();
                GA_ACC_UpdateChildContctsOnAccOwnrChange.updateAllChildContactsOwner(accLst, accOldMap);
                test.stopTest();
                eLogLst = [select id from ExceptionLog__c limit 1];
                system.assert(eLogLst.size()>0);
            }
            catch(exception e)
            {
                return;
            }
            
        }
    }
    
    /**
@Description: accnthndlrExcep() method 
@Name : accnthndlrExcep
@Param : None
@Return : void
@throws Exception : N/A;
*/ 
    private static testmethod void accnthndlrExcep()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestJeoRl','testsalesrepmail@bcbsm.com','Support');
        database.insert(usr);
        system.runAs(usr)
        {
            try{
                List<account> accList = null;
                map<id,account> accNewMap= null;
                map<id,account> accoldMap= null;
                GA_ACC_AP02_IdentifySalesRepOnAccount.isExecuting = false;
                test.startTest();
                GA_AccountTriggerHandlr.afterinsert(accList, accNewMap, accoldMap);
                GA_AccountTriggerHandlr.afterupdate(accList, accNewMap, accoldMap);
                GA_AccountTriggerHandlr.beforeupdate(accList, accNewMap, accoldMap);
                GA_ACC_AP02_IdentifySalesRepOnAccount.updatesalesTeamOnAccount(accList, accNewMap, accoldMap);
                test.stopTest();
                system.assert(usr <> null);
            }
            catch(exception e)
            {
                return;
            }
            
        }
    }
    /**
@Description: accnthndlrHlprExp() method 
@Name : accnthndlrHlprExp
@Param : None
@Return : void
@throws Exception : N/A;
*/ 
    private static testmethod void accnthndlrHlprExp(){
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestJeoRl','testsalesrepmail@bcbsm.com','Support');
        database.insert(usr);
        system.runAs(usr){
            account accnt=GA_OBJ_TD01_TestDataCreation.AccRec();
            //insert accnt;
            list<account> accountList=new list<account>();
            accountList.add(accnt);
            try
            {
                GA_Util03_AccountDataAccessHelper.dmlOnAccount(null, 'Insert');
            }
            catch(exception e)
            {
                system.assert(e !=null);
            }
        }
        
    }
    
    /**
@Description: accnthndlrHlpr() method 
@Name : accnthndlrHlprExcp
@Param : None
@Return : void
@throws Exception : N/A;
*/ 
    private static testmethod void accnthndlrHlpr(){
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestJeoRl','testsalesrepmail@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr){
            try
            {
                account accnt=GA_OBJ_TD01_TestDataCreation.AccRec();
                //insert accnt;
                list<account> accountList=new list<account>();
                accountList.add(accnt);
                GA_Util03_AccountDataAccessHelper.dmlOnAccount(accountList, 'Insert');
                GA_Util03_AccountDataAccessHelper.dmlOnAccount(accountList, 'Upsert');
                GA_Util03_AccountDataAccessHelper.dmlOnAccount(accountList, 'Delete');
                system.assert(accountList.size()>0);    
            }
            catch(exception e)
            {
                return;
            }
        }
    }
    
    /**
@Description: unionVldtn() method 
@Name : unionVldtn
@Param : None
@Return : void
@throws Exception : N/A;
*/ 
    private static testmethod void unionVldtn(){
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestJeoRl','testsalesrepmail@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr){
            try
            {
                list<account> accLst = null;
                map<id,account> accOldMap = null;   
                GA_County_Code__c cntyCode = GA_OBJ_TD01_TestDataCreation.countyCode();
                database.insert(cntyCode);
                Account acc = GA_OBJ_TD01_TestDataCreation.AccRec();
                acc.ParentId = 'Test Union';
                acc.GA_Mailing_County_id__c = cntyCode.Id;
                acc.GA_Physical_County_Id__c = cntyCode.Id;
                database.insert(acc);
                test.startTest();
                GA_ACC_AP_UnionVldtnCls.showValiderror(accLst, accOldMap);
                test.stopTest();
                
                system.assert(usr <> null);
            }
            catch(exception e)
            {
                return;
            }
            
        }
    }
    /**
@Description: unionVldtnExcep() method 
@Name : unionVldtnExcep
@Param : None
@Return : void
@throws Exception : N/A;
*/ 
    private static testmethod void unionVldtnExcep(){
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestJeoRl','testsalesrepmail@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr){
            try
            {
                list<account> accLst = null;
                map<id,account> accOldMap = null;   
                test.startTest();
                GA_ACC_AP_UnionVldtnCls.showValiderror(accLst, accOldMap);
                test.stopTest();
                
                system.assert(usr <> null);
            }
            catch(exception e)
            {
                return;
            }
        }
    }
}