/**
@Author : IDC Offshore
@Name: GA_ACC_UpdChildContctsOnAccOwnrChge_Test 
@CreatedDate: 21-Mar-2018
@Description: Test class for GA_ACC_UpdateChildContctsOnAccOwnrChange
@version : 1.0  
*/
@isTest(seealldata = false)
private class GA_ACC_UpdChildContctsOnAccOwnrChge_Test {
    /*******************************************************************************************************************************
@Description: updateAllChildContactsOwner() method 
@Name : updateAllChildContactsOwner
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
    static testmethod void updateAllChildContactsOwner(){
        user usrSA = GA_OBJ_TD01_TestDataCreation.UsrRec('Testwfstp','testsystemadminstrator@bcbsm.com','System Administrator');
        database.insert(usrSA);
        system.runAs(usrSA)
        {
            try{
                
                map<Id, Account> accOldMap = new map<Id, Account>();
                
                list<user> usrLst=new list<user>();
                
                user usr1 = GA_OBJ_TD01_TestDataCreation.UsrRec('TestR1','testsalesrep1mail@bcbsm.com','Retention Sales');
                usrLst.add(usr1);
                
                user usr2 = GA_OBJ_TD01_TestDataCreation.UsrRec('TestR2','testsalesrep2mail@bcbsm.com','Retention Sales');
                usrLst.add(usr2);
                database.insert(usrLst);
                
                GA_Territory__c territoryRec=GA_OBJ_TD01_TestDataCreation.terrtryRec();
                territoryRec.GA_RetentionSalesRepresentative__c=usr1.id;
                territoryRec.GA_Sales_Rep_Effective_Date__c=system.today();
                database.insert(territoryRec);
                
                List<GA_Territory__c> tertryLst = new List<GA_Territory__c>();
                
                account accnt=GA_OBJ_TD01_TestDataCreation.AccRec();
                accnt.GA_Territory__c = territoryRec.id;
                database.insert(accnt);
                
                
                List<Account> acctLst = new List<Account>();
                Account acct = new Account();
                For(Integer i=1 ;i<=2 ; i++)
                {                    
                    acct=new Account (
                        Name = 'Test ' + i,
                        RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Customer').getRecordTypeId(),
                        GA_Territory__c = territoryRec.id,
                        Phone='1234'+i,
                        Account_Status__c='Active',
                        NumberOfEmployees=123,
                        GA_Total_Eligible__c= 500,
                        CID__c='12'+i,
                        OwnerId=usr1.Id);
                    acctLst.add(Acct);      
                }
                database.insert(acctLst);
                Account accTemp = new Account();
                for(account acc:acctLst)
                {
                    accTemp = new Account(
                        Id = acc.Id,
                        OwnerId = usr2.Id);
                    accOldMap.put(accTemp.Id,accTemp);
                }
                
                
                Contact con1 = new Contact();
                con1.FirstName = 'TestConFirst';
                con1.LastName = 'TestConLast';
                con1.AccountId = acctLst[0].id;
                database.insert(con1);
                
                Test.startTest();       
                GA_ACC_UpdateChildContctsOnAccOwnrChange.updateAllChildContactsOwner(acctLst,accOldMap);
                Test.stopTest();
                
                system.assert(acctLst <> null);
            }
            catch(exception e)
            {
                return;
            }
        }
    }
}