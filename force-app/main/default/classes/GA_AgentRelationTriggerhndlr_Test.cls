/**
@Author : PadmaHaarika Jayana
@Name: GA_AgentRelationTriggerhndlr_Test 
@CreatedDate: 31 - Jul 2017 
@Description: GA_AgentRelationTriggerhndlr Test class 
@version : 1.0  
*/
@isTest(seealldata = false)
private class GA_AgentRelationTriggerhndlr_Test {
    /**
@Description: insertPlatStatus() method 
@Name : insertPlatStatus
@Param : None
@Return : void
@throws Exception : N/A;
*/ 
    private static testmethod void insertPlatStatus()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestJeoRl','testsalesrepmail@bcbsm.com','Integration user');
        database.insert(usr);
        system.runAs(usr)
        {
            list<account> accLst=new list<account>();
            
            Account accnt=GA_OBJ_TD01_TestDataCreation.AccRec(); 
            accnt.Name = 'customeracct';
            accnt.Phone = '1236890980';
            accnt.Website = 'testcust.com';
            accLst.add(accnt);
            Account agncy=GA_OBJ_TD01_TestDataCreation.AccRec();
            agncy.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Agency').getRecordTypeId();
            agncy.GA_Platinum__c = true;
            accLst.add(agncy);
            database.insert(accLst);
            GA_AgencyRelationship__c agncyRlnshp=GA_OBJ_TD01_TestDataCreation.agncyRelationshipRec(agncy.id, accnt.id);
            agncyRlnshp.GA_Account__c = accLst[0].id;
            agncyRlnshp.GA_Agency__c = accLst[1].id;
            agncyRlnshp.GA_StartDate__c=system.today()-10;
            agncyRlnshp.GA_EndDate__c = system.today()+30;
            database.insert(agncyRlnshp);
            list<GA_AgencyRelationship__c> agncyRelpLstToUpdt=new list<GA_AgencyRelationship__c>();
            GA_AR_AP01_UpdatePlatinumStatusOnAccount.isExecuting = false;
            agncyRlnshp = [SELECT Id, GA_StartDate__c FROM GA_AgencyRelationship__c WHERE Id = :agncyRlnshp.Id Limit 1];
            agncyRlnshp.GA_StartDate__c=system.today()+10;
            agncyRelpLstToUpdt.add(agncyRlnshp);
            database.update(agncyRelpLstToUpdt);
            agncy.GA_Platinum__c = false;
            GA_ACC_AP01_CheckPlatinumStatusOnAgency.isExecuting = false;
            database.update(agncy);
            
            System.assert(usr <> null);
        } 
    }
    
    /**
@Description: ga_AgencyRelationshipExcep() method 
@Name : ga_AgencyRelationshipExcep
@Param : None
@Return : void
@throws Exception : N/A;
*/ 
    private static testmethod void ga_AgencyRelationshipExcep()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestJeoRl','testsalesrepmail@bcbsm.com','Support');
        database.insert(usr);
        system.runAs(usr)
        {
            try{
                list<GA_AgencyRelationship__c> arList = new list<GA_AgencyRelationship__c>();
                map<id,GA_AgencyRelationship__c> arNewMap = new map<id,GA_AgencyRelationship__c> ();
                GA_AgentRelationTriggerhndlr.afterinsert(arList, arNewMap);
                GA_AgentRelationTriggerhndlr.afterupdate(arList, arNewMap,arNewMap);  
                
                System.assert(usr <> null);
            }
            catch(exception e)
            {
                return;
            }
            
        } 
        
    }
    
    /**
@Description: ga_AgencyRelationshipUpdateExcep() method 
@Name : ga_AgencyRelationshipExcep
@Param : None
@Return : void
@throws Exception : N/A;
*/ 
    private static testmethod void ga_AgencyRelationshipUpdateExcep()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestJeoRl','testsalesrepmail@bcbsm.com','Support');
        database.insert(usr);
        system.runAs(usr)
        {
            try{
                list<GA_AgencyRelationship__c> arList = new list<GA_AgencyRelationship__c>();
                map<id,GA_AgencyRelationship__c> arNewMap = new map<id,GA_AgencyRelationship__c>();
                
                GA_AgentRelationTriggerhndlr.afterupdate(arList, arNewMap,arNewMap);   
                
                System.assert(usr <> null);
            }
            catch(exception e)
            {
                return;
            }
            
        } 
    }
    
    /**
@Description: createAgencyRelAftDel() method 
@Name : createAgencyRelAftDel
@Param : None
@Return : void
@throws Exception : N/A;
*/ 
    private static testmethod void createAgencyRelAftDel()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestJeoRl','testsalesrepmail@bcbsm.com','Integration user');
        database.insert(usr);
        system.runAs(usr)
        {
            list<account> accLst=new list<account>();
            
            Account accnt=GA_OBJ_TD01_TestDataCreation.AccRec(); 
            accnt.Name = 'customeracct';
            accnt.Phone = '1236890980';
            accnt.Website = 'testcust.com';
            accLst.add(accnt);
            Account agncy=GA_OBJ_TD01_TestDataCreation.AccRec();
            agncy.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Agency').getRecordTypeId();
            agncy.GA_Platinum__c = true;
            accLst.add(agncy);
            database.insert(accLst);
            GA_AgencyRelationship__c agncyRlnshp=GA_OBJ_TD01_TestDataCreation.agncyRelationshipRec(agncy.id, accnt.id);
            agncyRlnshp.GA_Account__c = accLst[0].id;
            agncyRlnshp.GA_Agency__c = accLst[1].id;
            agncyRlnshp.GA_StartDate__c=system.today()-10;
            agncyRlnshp.GA_EndDate__c = system.today()+30;
            database.insert(agncyRlnshp);
            GA_AR_AP01_UpdatePlatinumStatusOnAccount.isExecuting = false;
            agncyRlnshp = [SELECT Id, GA_StartDate__c,GA_Account__c, GA_Agency__c FROM GA_AgencyRelationship__c WHERE Id = :agncyRlnshp.Id Limit 1];
            
            database.delete(agncyRlnshp);
            
            System.assert(usr <> null);
        } 
    }
    
    /**
@Description: createAgencyRelAftDelBatch() method 
@Name : createAgencyRelAftDelBatch
@Param : None
@Return : void
@throws Exception : N/A;
*/ 
    private static testmethod void createAgencyRelAftDelBatch()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestJeoRl','testsalesrepmail@bcbsm.com','Integration user');
        database.insert(usr);
        system.runAs(usr)
        {
            list<account> accLst=new list<account>();
            
            Account accnt=GA_OBJ_TD01_TestDataCreation.AccRec(); 
            accnt.Name = 'customeracct';
            accnt.Phone = '1236890980';
            accnt.Website = 'testcust.com';
            accLst.add(accnt);
            Account agncy=GA_OBJ_TD01_TestDataCreation.AccRec();
            agncy.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Agency').getRecordTypeId();
            agncy.GA_Platinum__c = true;
            accLst.add(agncy);
            database.insert(accLst);
            List<GA_AgencyRelationship__c> agList = new List<GA_AgencyRelationship__c>();
            for(integer i=0; i<120; i++){
                GA_AgencyRelationship__c agncyRlnshp=GA_OBJ_TD01_TestDataCreation.agncyRelationshipRec(agncy.id, accnt.id);
                agncyRlnshp.GA_Account__c = accLst[0].id;
                agncyRlnshp.GA_Agency__c = accLst[1].id;
                agncyRlnshp.GA_StartDate__c=system.today()-10;
                agncyRlnshp.GA_EndDate__c = system.today()+30;
                agList.add(agncyRlnshp);
            }
            database.insert(agList);
            GA_AR_AP01_UpdatePlatinumStatusOnAccount.isExecuting = false;
            
            database.delete(agList);
            
            System.assert(usr <> null);
        } 
    }
    
    /**
@Description: createAgencyAfterUpdate() method 
@Name : createAgencyAfterUpdate
@Param : None
@Return : void
@throws Exception : N/A;
*/ 
    private static testmethod void createAgencyAfterUpdate()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestJeoRl','testsalesrepmail@bcbsm.com','Integration user');
        database.insert(usr);
        system.runAs(usr)
        {
            list<account> accLst=new list<account>();
            
            Account accnt=GA_OBJ_TD01_TestDataCreation.AccRec(); 
            accnt.Name = 'customeracct';
            accnt.Phone = '1236890980';
            accnt.Website = 'testcust.com';
            accLst.add(accnt);
            Account agncy=GA_OBJ_TD01_TestDataCreation.AccRec();
            agncy.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Agency').getRecordTypeId();
            agncy.GA_Platinum__c = true;
            accLst.add(agncy);
            database.insert(accLst);
            GA_AgencyRelationship__c agncyRlnshp=GA_OBJ_TD01_TestDataCreation.agncyRelationshipRec(agncy.id, accnt.id);
            agncyRlnshp.GA_Account__c = accLst[0].id;
            agncyRlnshp.GA_Agency__c = accLst[1].id;
            agncyRlnshp.GA_Is_Active__c=true;
            agncyRlnshp.GA_StartDate__c=system.today()-10;
            agncyRlnshp.GA_EndDate__c = system.today()+30;
            database.insert(agncyRlnshp);
            GA_AR_AP01_UpdatePlatinumStatusOnAccount.isExecuting = false;
            agncyRlnshp = [SELECT Id, GA_StartDate__c,GA_Account__c, GA_Agency__c FROM GA_AgencyRelationship__c WHERE Id = :agncyRlnshp.Id Limit 1];
            
            agncyRlnshp.GA_Is_Active__c=false; 
            database.update(agncyRlnshp);
            
            System.assert(usr <> null);
        } 
    }
}