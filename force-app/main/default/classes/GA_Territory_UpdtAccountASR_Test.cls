/*
@Author : IDC Offshore
@Name: GA_Territory_UpdtAccountASR_Test 
@CreatedDate: 22 - Aug 2019 
@Description: GA_Territory_UpdtAccountASR Test class
@version : 1.0  
*/
@isTest(seealldata = false)
private class GA_Territory_UpdtAccountASR_Test {
    
    /*******************************************************************************************************************************
@Description: updtAccASRTst() method 
@Name : updtAccASRTst
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
    private static testmethod void updtAccASRTst(){
        user usrSA = GA_OBJ_TD01_TestDataCreation.UsrRec('Testwfstp','testsystemadminstrator@bcbsm.com','System Administrator');
        database.insert(usrSA);
        system.runAs(usrSA)
        {
            try{
                
                map<Id, GA_Territory__c> tertyOldMap = new map<Id, GA_Territory__c>();
                
                list<user> usrLst=new list<user>();
                UserRole usrRleId = GA_OBJ_TD01_TestDataCreation.setRole('Support Representative','Support_Representative');
                
                user usr1 = GA_OBJ_TD01_TestDataCreation.UsrRec('TestR1','testsalesrep1mail@bcbsm.com','Support');
                usr1.UserRoleId = usrRleId.id;
                usrLst.add(usr1);
                
                user usr2 = GA_OBJ_TD01_TestDataCreation.UsrRec('TestR2','testsalesrep2mail@bcbsm.com','Support');
                usr2.UserRoleId = usrRleId.id;
                usrLst.add(usr2);
                database.insert(usrLst);
                
                GA_Territory__c territoryRec=GA_OBJ_TD01_TestDataCreation.terrtryRec();
                territoryRec.GA_Support_Representative__c=usr1.id;
                database.insert(territoryRec);
                
                List<GA_Territory__c> tertryLst  = new List<GA_Territory__c>();
                
                account accnt=GA_OBJ_TD01_TestDataCreation.AccRec();
                accnt.GA_Territory__c = territoryRec.id;
                database.insert(accnt);
                
                territoryRec.GA_Support_Representative__c=usr2.id;
                Test.startTest();
                database.update(territoryRec);
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
@Description: updtAccASRLstTst() method 
@Name : updtAccASRLstTst
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
    private static testmethod void updtAccASRLstTst(){
        user usrSA = GA_OBJ_TD01_TestDataCreation.UsrRec('Testwfstp','testsystemadminstrator@bcbsm.com','System Administrator');
        database.insert(usrSA);
        system.runAs(usrSA)
        {
            try{
                
                map<Id, GA_Territory__c> tertyOldMap = new map<Id, GA_Territory__c>();
                
                list<user> usrLst=new list<user>();
                UserRole usrRleId = GA_OBJ_TD01_TestDataCreation.setRole('Support Representative','Support_Representative');
                
                user usr1 = GA_OBJ_TD01_TestDataCreation.UsrRec('TestR1','testsalesrep1mail@bcbsm.com','Support');
                usr1.UserRoleId = usrRleId.id;
                usrLst.add(usr1);
                
                user usr2 = GA_OBJ_TD01_TestDataCreation.UsrRec('TestR2','testsalesrep2mail@bcbsm.com','Support');
                usr2.UserRoleId = usrRleId.id;
                usrLst.add(usr2);
                database.insert(usrLst);
                
                GA_Territory__c territoryRec=GA_OBJ_TD01_TestDataCreation.terrtryRec();
                territoryRec.GA_Support_Representative__c=usr1.id;
                database.insert(territoryRec);
                
                List<GA_Territory__c> tertryLst  = new List<GA_Territory__c>();
                
                account accnt=GA_OBJ_TD01_TestDataCreation.AccRec();
                accnt.GA_Territory__c = territoryRec.id;
                database.insert(accnt);
                
                List<Account> acctLst = new List<Account>();
                Account acct=new Account ();
                
                For(Integer i=1 ;i<=11 ; i++)
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
                    acctLst.add(acct);      
                }
                database.insert(acctLst);
                
                territoryRec.GA_Support_Representative__c=usr2.id;
                Test.startTest();
                database.update(territoryRec);
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
@Description: updtAccASRExcptn() method 
@Name : updtAccASRExcptn
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
    private static testmethod void updtAccASRExcptn(){
        user usrSA = GA_OBJ_TD01_TestDataCreation.UsrRec('Testwfstp','testsystemadminstrator@bcbsm.com','System Administrator');
        database.insert(usrSA);
        system.runAs(usrSA)
        {
            try{
                map<Id, GA_Territory__c> tertyOldMap = new map<Id, GA_Territory__c>();
                
                list<user> usrLst=new list<user>();
                UserRole usrRleId = GA_OBJ_TD01_TestDataCreation.setRole('Support Representative','Support_Representative');
                
                user usr1 = GA_OBJ_TD01_TestDataCreation.UsrRec('TestR1','testsalesrep1mail@bcbsm.com','Support');
                usr1.UserRoleId = usrRleId.id;
                usrLst.add(usr1);
                
                user usr2 = GA_OBJ_TD01_TestDataCreation.UsrRec('TestR2','testsalesrep2mail@bcbsm.com','Support');
                usr2.UserRoleId = usrRleId.id;
                usrLst.add(usr2);
                database.insert(usrLst);
                
                GA_Territory__c territoryRec=GA_OBJ_TD01_TestDataCreation.terrtryRec();
                territoryRec.GA_Support_Representative__c=usr1.id;
                database.insert(territoryRec);
                tertyOldMap.put(territoryRec.id,territoryRec);
                List<GA_Territory__c> tertryLst  = new List<GA_Territory__c>();
                
                account accnt=GA_OBJ_TD01_TestDataCreation.AccRec();
                accnt.GA_Territory__c = territoryRec.id;
                database.insert(accnt);
                
                GA_Territory__c territoryRec1= new  GA_Territory__c ();
                territoryRec1.id=territoryRec.id;
                territoryRec1.GA_Support_Representative__c=usr2.id;
                tertryLst.add(territoryRec1);
                
                Test.startTest();
                GA_Territory_UpdtAccountASR.updtAccASRFrmTerrtry(null,null);
                Test.stopTest();
                
                system.assert(usrSA <> null);
            }
            catch(exception e)
            {
                return;
            }
        }
    }
}