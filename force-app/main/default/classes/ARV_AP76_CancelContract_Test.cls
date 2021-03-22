/*****************************************************************************************
Class Name   : ARV_AP76_CancelContractTestRC_Test
Date Created : 17-Jan-2020
Created By   : IDC Onshore
Description  :This is the class to fetch the contract with status In progress
******************************************************************************************/
@isTest
public without sharing class ARV_AP76_CancelContract_Test{

private static final string PROFILENAME='System Administrator';
 private static final string NAME='AP61LastName';
    Private static final String TEST_VAL='Test';
    Private static final String CID='23';
    private static final string USERNAME='bcbsm1@bcbsm.com';
    private static final String INPROGRESS='In Progress';
    private static final String CANCELLED='Cancelled';
    /************************************************* 
Method name : testDataSetup1
Params     : NA
Return Type : testmethod
Description :  testDataSetup1() method 
**************************************************/  
    @testSetup static void testDataSetup1() { 
        Account acc = new Account(name=TEST_VAL);
        acc.CID__c=CID;
        database.insert(acc);
        Contract con = ARV_AP05_TestDataCreation.createContractRec(acc.Id);
        con.Status=INPROGRESS;
        database.insert(con);
        user usr = ARV_AP05_TestDataCreation.UsrRec(PROFILENAME);
        usr.LastName = NAME;
        usr.Username=USERNAME;
        database.insert(usr,true);
  }
  /*****************************************************************************************
Method Name   : getContractrecord
Date Created : 17-Jan-2020
Created By   : IDC Onshore
Description  :This is the class to fetch the contract with status In progress
******************************************************************************************/
  public static testmethod void getContractrecord()
    {
       Contract  cont=[select id,Status from contract where Status=:INPROGRESS limit 1];
       
        user usr1  = [SELECT Id from User where LastName =: NAME limit 1];
        system.runAs(usr1){  
            test.startTest(); 
        //CancelContractTestRC.saveContract(cont.id);
        ARV_AP76_CancelContract.getContract(cont.id);
            test.stopTest();
              System.assertNotEquals(null,cont.id);   

        }
        }
  /*****************************************************************************************
Method Name   : getContractrecord2
Date Created : 17-Jan-2020
Created By   : IDC Onshore
Description  :This is the class to fetch the contract with status In progress
******************************************************************************************/        
        public static testmethod void getContractrecord2()
    {
       Contract  cont1=[select id,Status from contract where Status=:CANCELLED limit 1];
       insert cont1;
        user usr1  = [SELECT Id from User where LastName =: NAME limit 1];
        system.runAs(usr1){  
            test.startTest(); 
        ARV_AP76_CancelContract.saveContract(cont1.id);
        //CancelContractTestRC.getContract(cont.id);
            test.stopTest();
           System.assertNotEquals(null,cont1.id);   

        }
        }
        }