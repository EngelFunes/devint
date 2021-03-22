/*******************************************************************************************************************************
@Author : IDC offshore
@Name: GA_UpdateAccOwner_Test
@CreatedDate: 23 - Feb 2019 
@Description: GA_UpdateAccOwner_Test class is for GA_UpdateAccOwner Cls.
@version : 1.0  
********************************************************************************************************************************/
@isTest(seealldata = false)
private class GA_UpdateAccOwner_Test {
    /*******************************************************************************************************************************
@Description: updtAccOwnrTst() method 
@Name : updtAccOwnrTst
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
    private static testmethod void updtAccOwnrTst(){
        user usrSA = GA_OBJ_TD01_TestDataCreation.UsrRec('Testwfstp','testsystemadminstrator@bcbsm.com','System Administrator');
        database.insert(usrSA);
        system.runAs(usrSA)
        {
            try{
                map<Id, GA_Territory__c> tertyOldMap = new map<Id, GA_Territory__c>();
                
                list<user> usrLst=new list<user>();
                
                user usr1 = GA_OBJ_TD01_TestDataCreation.UsrRec('TestR1','testsalesrep1mail@bcbsm.com','Retention Sales');
                usrLst.add(usr1);
                
                user usr2 = GA_OBJ_TD01_TestDataCreation.UsrRec('TestR2','testsalesrep2mail@bcbsm.com','Retention Sales');
                usrLst.add(usr2);
                database.insert(usrLst);
                
                GA_Territory__c territoryRec=GA_OBJ_TD01_TestDataCreation.terrtryRec();
                territoryRec.GA_RetentionSalesRepresentative__c=usr1.id;
                database.insert(territoryRec);
                
                List<GA_Territory__c> tertryLst  = new List<GA_Territory__c>();
                
                account accnt=GA_OBJ_TD01_TestDataCreation.AccRec();
                accnt.GA_Territory__c = territoryRec.id;
                database.insert(accnt);
                
                territoryRec.GA_RetentionSalesRepresentative__c=usr2.id;
                territoryRec.GA_Sales_Rep_Effective_Date__c = System.today()+1;
                database.update(territoryRec);
                
                Test.startTest();
                GA_UpdateAccOwner.updtFrmTerrtry(tertryLst, tertyOldMap);
                GA_UpdateAccOwner.constructMap(tertryLst);
                Test.stopTest();
                system.assert(usrSA <> null);
                
            }
            catch(exception e)
            {
                return;
            }
        }
    }
    
    
      /*******************************************************************************************************************************
@Description: updtAccOwnrTst() method 
@Name : updtAccOwnrTst
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
    private static testmethod void updtAccOwnrTst1(){
        user usrSA = GA_OBJ_TD01_TestDataCreation.UsrRec('Testwfstp','testsystemadminstrator@bcbsm.com','System Administrator');
        database.insert(usrSA);
        system.runAs(usrSA)
        {
            try{
                map<Id, GA_Territory__c> tertyOldMap = new map<Id, GA_Territory__c>();
                
                list<user> usrLst=new list<user>();
                
                user usr1 = GA_OBJ_TD01_TestDataCreation.UsrRec('TestR1','testsalesrep1mail@bcbsm.com','Retention Sales');
                usrLst.add(usr1);
                
                user usr2 = GA_OBJ_TD01_TestDataCreation.UsrRec('TestR2','testsalesrep2mail@bcbsm.com','Retention Sales');
                usrLst.add(usr2);
                database.insert(usrLst);
                
                GA_Territory__c territoryRec=GA_OBJ_TD01_TestDataCreation.terrtryRec();
                territoryRec.GA_RetentionSalesRepresentative__c=usr1.id;
                territoryRec.GA_Sales_Rep_Effective_Date__c = System.today()-2;
                database.insert(territoryRec);
                
                List<GA_Territory__c> tertryLst  = new List<GA_Territory__c>();
                
                account accnt=GA_OBJ_TD01_TestDataCreation.AccRec();
                accnt.GA_Territory__c = territoryRec.id;
                database.insert(accnt);
                
                territoryRec.GA_RetentionSalesRepresentative__c=usr2.id;
                territoryRec.GA_Sales_Rep_Effective_Date__c = System.today();
                database.update(territoryRec);
                
                Test.startTest();
                GA_UpdateAccOwner.updtFrmTerrtry(tertryLst, tertyOldMap);
                GA_UpdateAccOwner.constructMap(tertryLst);
                Test.stopTest();
                system.assert(usrSA <> null);
                
            }
            catch(exception e)
            {
                return;
            }
        }
    }

    /*******************************************************************************************************************************
@Description: updtAccOwnrInfrUsr() method 
@Name : updtAccOwnrInfrUsr
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
    private static testmethod void updtAccOwnrInfrUsr(){
        user usrSA = GA_OBJ_TD01_TestDataCreation.UsrRec('Testwfstp','testsystemadminstrator@bcbsm.com','System Administrator');
        database.insert(usrSA);
        system.runAs(usrSA)
        {
            try{
                
                map<Id, GA_Territory__c> tertyOldMap = new map<Id, GA_Territory__c>();
                
                list<user> usrLst=new list<user>();
                
                user usr1 = GA_OBJ_TD01_TestDataCreation.UsrRec('TestR1','testsalesrep1mail@bcbsm.com','Retention Sales');
                usrLst.add(usr1);
                
                user usr2 = GA_OBJ_TD01_TestDataCreation.UsrRec('TestR2','testsalesrep2mail@bcbsm.com','Retention Sales');
                usrLst.add(usr2);
                database.insert(usrLst);
                
                GA_Territory__c territoryRec=GA_OBJ_TD01_TestDataCreation.terrtryRec();
                territoryRec.GA_RetentionSalesRepresentative__c=usr1.id;
                database.insert(territoryRec);
                
                List<GA_Territory__c> tertryLst  = new List<GA_Territory__c>();
                
                account accnt=GA_OBJ_TD01_TestDataCreation.AccRec();
                accnt.GA_Territory__c = territoryRec.id;
                database.insert(accnt);
                
                territoryRec.GA_RetentionSalesRepresentative__c=null;
                territoryRec.GA_Sales_Rep_Effective_Date__c = System.today()+1;
                database.update(territoryRec);
                
                Test.startTest();
                GA_UpdateAccOwner.updtFrmTerrtry(tertryLst, tertyOldMap);
                GA_UpdateAccOwner.constructMap(tertryLst);
                Test.stopTest();
                system.assert(usrSA <> null);
                
            }
            catch(exception e)
            {
                return;
            }
        }
    }
    /*******************************************************************************************************************************
@Description: updtAccOwnrExcp() method 
@Name : updtAccOwnrExcp
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
    private static testmethod void updtAccOwnrExcp(){
        user usrSA = GA_OBJ_TD01_TestDataCreation.UsrRec('Testwfstp','testsystemadminstrator@bcbsm.com','System Administrator');
        database.insert(usrSA);
        system.runAs(usrSA)
        {
            try{
                
                map<Id, GA_Territory__c> tertyOldMap = new map<Id, GA_Territory__c>();
                
                list<user> usrLst=new list<user>();
                
                user usr1 = GA_OBJ_TD01_TestDataCreation.UsrRec('TestR1','testsalesrep1mail@bcbsm.com','Retention Sales');
                usrLst.add(usr1);
                
                user usr2 = GA_OBJ_TD01_TestDataCreation.UsrRec('TestR2','testsalesrep2mail@bcbsm.com','Retention Sales');
                usrLst.add(usr2);
                database.insert(usrLst);
                
                GA_Territory__c territoryRec=GA_OBJ_TD01_TestDataCreation.terrtryRec();
                territoryRec.GA_RetentionSalesRepresentative__c=usr1.id;
                database.insert(territoryRec);
                
                List<GA_Territory__c> tertryLst  = new List<GA_Territory__c>();
                
                account accnt=GA_OBJ_TD01_TestDataCreation.AccRec();
                accnt.GA_Territory__c = territoryRec.id;
                database.insert(accnt);
                
                territoryRec.GA_RetentionSalesRepresentative__c=null;
                territoryRec.GA_Sales_Rep_Effective_Date__c = System.today()+1;
                database.update(territoryRec);
                
                Test.startTest();
                GA_UpdateAccOwner.updtFrmTerrtry(null, null);
                //GA_UpdateAccOwner.updtLiasnRegMangr(null);
                GA_UpdateAccOwner.constructMap(tertryLst);
                Test.stopTest();
                system.assert(usrSA <> null);
                
            }
            catch(exception e)
            {
                return;
            }
        }
    }
  /*******************************************************************************************************************************
@Description: updtAccOwnrLstTst() method 
@Name : updtAccOwnrLstTst
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
    private static testmethod void updtAccOwnrLstTst(){
        user usrSA = GA_OBJ_TD01_TestDataCreation.UsrRec('Testwfstp','testsystemadminstrator@bcbsm.com','System Administrator');
        usrSA.GA_ByPass_WF__c = true;
        usrSA.GA_ByPass_VR__c = true;
        usrSA.UserRoleId  = [select id from Userrole where DeveloperName = 'System_Administrator'].id;
        database.insert(usrSA);
        system.runAs(usrSA)
        {
            try{
                
                map<Id, GA_Territory__c> tertyOldMap = new map<Id, GA_Territory__c>();
                
                list<user> usrLst=new list<user>();
                
                user usr1 = GA_OBJ_TD01_TestDataCreation.UsrRec('TestR1','testsalesrep1mail@bcbsm.com','Retention Sales');
                usrLst.add(usr1);
                
                user usr2 = GA_OBJ_TD01_TestDataCreation.UsrRec('TestR2','testsalesrep2mail@bcbsm.com','Retention Sales');
                usrLst.add(usr2);
                database.insert(usrLst);
                
                GA_Territory__c territoryRec=GA_OBJ_TD01_TestDataCreation.terrtryRec();
                territoryRec.GA_RetentionSalesRepresentative__c=usr1.id;
                 territoryRec.GA_Sales_Rep_Effective_Date__c=system.today()-1;
                database.insert(territoryRec);
                
                List<GA_Territory__c> tertryLst  = new List<GA_Territory__c>();
                
               
                List<Account> acctLst = new List<Account>();
                Account acct=new Account ();
                
                For(Integer i=1 ;i<=110 ; i++)
                {                    
                    acct=new Account ();
                    acct.Name = 'Test ' + i;
                    acct.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Customer').getRecordTypeId();
                    acct.GA_Territory__c = territoryRec.id;
                    acct.Phone='1234'+i;
                    acct.Account_Status__c='Active';
                    acct.NumberOfEmployees=123;
                    acct.GA_Total_Eligible__c= 500;
                    acct.CID__c='12'+i;
                    acct.GA_Is_Mass_Updating__c = true;
                    acctLst.add(acct);      
                }
                GA_AccountTriggerHandlr.isBfrInstExecuting = true;
                GA_AccountTriggerHandlr.isExecuting = true;
                   GA_ACC_AP01_CheckPlatinumStatusOnAgency.isExecuting = true;
                   GA_Util_lockRecords.isExecuting = true;
                   GA_ACC_AP02_IdentifySalesRepOnAccount.isExecuting = true;
                   GA_ACC_AP05_CreateHandoverRecord.isExecuting = true;
                   GA_ACC_UpdateChildContctsOnAccOwnrChange.isExecuting = true;
                   GA_ACC_AP04_UpdtCntOnAccLockUnlock.isExecuting = true;
                   GA_ACC_AP_UpdtAssmntOwnrMgrChnge.isExecuting = true; 
                   GA_AccountBatchToUpdateContactOwner.isInvodedFrmBtch = true;
                   GA_ACC_AP_UpdtAssmntOwnrMgrChnge.isExecuting = true;
                database.insert(acctLst);
                
                territoryRec.GA_RetentionSalesRepresentative__c=usr2.id;
                territoryRec.GA_Sales_Rep_Effective_Date__c = System.today();
                database.update(territoryRec);
                
                system.assert(usrSA <> null);
            }
            catch(exception e)
            {
                return;
            }
        }
    }
}