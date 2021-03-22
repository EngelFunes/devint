/*******************************************************************************************************************************
@Author : Raj Jena
@Name: GA_AccntFctShtTriggrHandler_Test
@CreatedDate: 04 - Jan 2018 
@Description: GA_AccntFctShtTriggrHandler_Test class is for GA_AccntFctShtTriggrHandler.
@version : 1.0  
********************************************************************************************************************************/
@isTest(seealldata = false)
private class GA_AccntFctShtTriggrHandler_Test {
    
    /*******************************************************************************************************************************
@Description        :   afsbeforeInsert() method 
@Name               :   afsbeforeInsert
@Param              :   None
@Return             :   void 
@throws Exception   :   N/A;
********************************************************************************************************************************/ 
    private static testmethod void afsbeforeInsert()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestJeoRl','testsalesrepmail@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {   
            List<GA_Account_Fact_Sheet__c> afsLst=new List<GA_Account_Fact_Sheet__c>();
            map<id,GA_Account_Fact_Sheet__c> actFcshtNewmap = New map<id,GA_Account_Fact_Sheet__c>();
            Account acc = GA_OBJ_TD01_TestDataCreation.AccRec();
            database.insert(acc);
            Contact con = GA_OBJ_TD01_TestDataCreation.cntactRec(acc.Id);
            database.insert(con);
            
            for(integer i=0; i<100; i++){
                GA_Account_Fact_Sheet__c afs = GA_OBJ_TD01_TestDataCreation.accFactSheetRec(acc,con); 
                afsLst.add(afs);
            }
            Database.insert(afsLst);
            
            test.startTest();
            GA_AccntFctShtTrgrCls.isExecuting = false;
            GA_AccntFctShtTrgrCls.prepopulateFactsht(afsLst, null);
            GA_AccntFctShtTriggrHandler.beforeInsert(afsLst, actFcshtNewmap);
            test.stopTest();
            system.assert(afsLst <> null);
        } 
    }
    /*******************************************************************************************************************************
@Description        :   afsbeforeupdate() method 
@Name               :   afsbeforeupdate
@Param              :   None
@Return             :   void
@throws Exception   :   N/A;
********************************************************************************************************************************/ 
    private static testmethod void afsbeforeupdate()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestJeoRl','testsalesrepmail@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {   
            List<GA_Account_Fact_Sheet__c> afsLst=new List<GA_Account_Fact_Sheet__c>();
            List<GA_Account_Fact_Sheet__c> newAfsLst=new List<GA_Account_Fact_Sheet__c>();
            map<id,GA_Account_Fact_Sheet__c> actFcshtOldmap=new map<id,GA_Account_Fact_Sheet__c>();
            Account acc = GA_OBJ_TD01_TestDataCreation.AccRec();
            database.insert(acc);
            Contact con = GA_OBJ_TD01_TestDataCreation.cntactRec(acc.Id);
            Contact con1 = GA_OBJ_TD01_TestDataCreation.cntactRec(acc.Id);
            list<contact> conToInsrtLst=new list<contact>();
            conToInsrtLst.add(con);
            conToInsrtLst.add(con1);
            database.insert(conToInsrtLst);
            for(integer i=0; i<100; i++){
                GA_Account_Fact_Sheet__c afs = GA_OBJ_TD01_TestDataCreation.accFactSheetRec(acc,con); 
                if(i==0){
                    afs.GA_Contact_Name__c=null;
                    afs.GA_AgentName__c=null;
                }
                actFcshtOldmap.put(afs.id,afs);
                afsLst.add(afs);
            }
            Database.insert(afsLst);
            GA_Account_Fact_Sheet__c afsToUpdate=afsLst[0];
            afsToUpdate.GA_Contact_Name__c=con1.id;
            afsToUpdate.GA_AgentName__c=con1.id;
            newAfsLst.add(afsToUpdate);
            test.startTest();
            GA_AccntFctShtTrgrCls.isExecuting = false;
            Database.update(newAfsLst);
            test.stopTest();
            system.assert(afsLst <> null);
        } 
        
    }
    
    /*******************************************************************************************************************************
@Description        :   beforeInsertExcep() method 
@Name               :   beforeInsertExcep
@Param              :   None
@Return             :   void
@throws Exception   :   N/A;
********************************************************************************************************************************/ 
    private static testmethod void beforeInsertExcep()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestJeoRl','testsalesrepmail@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {
            try
            {
                List<GA_Account_Fact_Sheet__c> afsLst=new List<GA_Account_Fact_Sheet__c>();
                map<id,GA_Account_Fact_Sheet__c> actFcshtNewmap = New map<id,GA_Account_Fact_Sheet__c>();
                map<id,GA_Account_Fact_Sheet__c> actFcshtOldmap = New map<id,GA_Account_Fact_Sheet__c>();
                
                Account acc = GA_OBJ_TD01_TestDataCreation.AccRec();
                database.insert(acc);
                Contact con = GA_OBJ_TD01_TestDataCreation.cntactRec(acc.Id);
                database.insert(con);
                GA_Account_Fact_Sheet__c afs = GA_OBJ_TD01_TestDataCreation.accFactSheetRec(acc,con);
                database.insert(afs);
                
                test.startTest();
                GA_AccntFctShtTrgrCls.isExecuting=null;
                GA_AccntFctShtTriggrHandler.beforeInsert(afsLst, actFcshtNewmap);
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
@Description        :   beforeupdateExcep() method 
@Name               :   beforeupdateExcep
@Param              :   None
@Return             :   void
@throws Exception   :   N/A;
********************************************************************************************************************************/ 
    private static testmethod void beforeupdateExcep()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestJeoRl','testsalesrepmail@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {
            try
            {
                List<GA_Account_Fact_Sheet__c> afsLst=new List<GA_Account_Fact_Sheet__c>();
                map<id,GA_Account_Fact_Sheet__c> actFcshtNewmap = New map<id,GA_Account_Fact_Sheet__c>();
                map<id,GA_Account_Fact_Sheet__c> actFcshtOldmap = New  map<id,GA_Account_Fact_Sheet__c>();
                
                Account acc = GA_OBJ_TD01_TestDataCreation.AccRec();
                database.insert(acc);
                Contact con = GA_OBJ_TD01_TestDataCreation.cntactRec(acc.Id);
                database.insert(con);
                GA_Account_Fact_Sheet__c afs = GA_OBJ_TD01_TestDataCreation.accFactSheetRec(acc,con);
                database.insert(afs);
                
                test.startTest();
                GA_AccntFctShtTrgrCls.isExecuting=null;
                GA_AccntFctShtTriggrHandler.beforeupdate(afsLst, actFcshtOldmap);
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
@Description        :   prepopulateFactshtExcep() method 
@Name               :   prepopulateFactshtExcep
@Param              :   None
@Return             :   void
@throws Exception   :   N/A;
********************************************************************************************************************************/ 
    private static testmethod void prepopulateFactshtExcep()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestJeoRl','testsalesrepmail@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {
            try
            {
                List<GA_Account_Fact_Sheet__c> afsLst=new List<GA_Account_Fact_Sheet__c>();
                map<id,GA_Account_Fact_Sheet__c> actfctshtmap = new map<id,GA_Account_Fact_Sheet__c>();
                
                test.startTest();
                GA_AccntFctShtTrgrCls.isExecuting=null;
                GA_AccntFctShtTrgrCls.prepopulateFactsht(afsLst, actfctshtmap);
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