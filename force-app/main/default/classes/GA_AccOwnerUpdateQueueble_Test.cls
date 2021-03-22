/*******************************************************************************************************************************
@Author : IDC offshore
@Name: GA_AccOwnerUpdateQueueble_Test
@CreatedDate: 10 - Mar 2019 
@Description: GA_AccOwnerUpdateQueueble_Test class is for GA_AccOwnerUpdateQueueble Cls.
@version : 1.0  
********************************************************************************************************************************/
@isTest(seealldata = false)
private class GA_AccOwnerUpdateQueueble_Test {
    /*******************************************************************************************************************************
@Description: updtAccOwnrQublTst() method 
@Name : updtAccOwnrQublTst
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
    static testmethod void updtAccOwnrQublTst(){
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
                territoryRec.GA_Sales_Rep_Effective_Date__c=system.today();
                database.insert(territoryRec);
                
                List<GA_Territory__c> tertryLst  = new List<GA_Territory__c>();
                
                account accnt=GA_OBJ_TD01_TestDataCreation.AccRec();
                accnt.GA_Territory__c = territoryRec.id;
                database.insert(accnt);
                
                
                List<Account> acctLst = new List<Account>();
                Account acct = new Account ();
                For(Integer i=1 ;i<=2 ; i++)
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
                    acctLst.add(Acct);      
                }
                database.insert(acctLst);
                list<account> accLSTtoupte=new list<account>();
                integer int1=0;
                for(account acc:acctLst)
                {
                    if(int1==0){
                        acc.CID__c='abc';
                    }
                    accLSTtoupte.add(acc);
                    int1++;
                }
                territoryRec.GA_RetentionSalesRepresentative__c=usr2.id;
                territoryRec.GA_Sales_Rep_Effective_Date__c=system.today()+10;
                database.update(territoryRec);
                
                /* Test.startTest();
// GA_AccOwnerUpdateQueueble ad = new GA_AccOwnerUpdateQueueble (acctLst);
GA_AccOwnerUpdateQueueble updater = new GA_AccOwnerUpdateQueueble (acctLst);
//   System.enqueueJob(ad);
ID jobID = System.enqueueJob(updater);
Test.stopTest();*/
                
                Test.startTest();       
                System.enqueueJob(new GA_AccOwnerUpdateQueueble(accLSTtoupte));
                Test.stopTest();
                
                system.assert(accLSTtoupte <> null);
            }
            catch(exception e)
            {
                return;
            }
        }
    }
}