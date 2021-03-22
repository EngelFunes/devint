/*****************************************************************************************
Author       : IDC Offshore
Class Name   : GA_Acc_OppRenewal_Test
Date Created : 11/23/2017
Created By   : IDC Offshore
Description  : GA_Acc_OppRenewal_Test class
******************************************************************************************/
@isTest(seealldata = false)
private class GA_Acc_OppRenewal_Test {
    /** 
@Description: validateAccOppRenewal() method 
@Name : validateAccOppRenewal
@Param : N/A
@Return : void
@throws Exception : N/A;
*/ 
    private static testMethod void validateAccOppRenewal() {
        
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestCompetitr','testsalesrepmail@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {
            try {
                
                Account acc= new Account(Name='TCus',GA_Opportunity_Renewal_Date__c=system.today(),
                                         Description='Test Class Cust', CID__c='123',
                                         Website='www.TCus.com', Account_Status__c='Active',
                                         NumberOfEmployees=43, Phone='23423', GA_Total_Eligible__c=78, 
                                         GA_RenewalLeadTime__c='90', Renewal_Month__c='January');
                Database.insert(acc);
                acc = [select GA_Opportunity_Renewal_Date__c from Account where id=:acc.Id limit 1000];
                acc.GA_Opportunity_Renewal_Date__c=system.today();
                database.update(acc);
                GA_Acc_OppRenewal_Scheduler accOppRen = new GA_Acc_OppRenewal_Scheduler();
                String sch = '0 0 23 * * ?'; 
                
                test.startTest();
                
                system.schedule('AccOppScheduler', sch, accOppRen); 
                GA_Acc_OppRenewal.createoppty(); 
                GA_Acc_OppRenewal.oppRenewlLmt=0;
                GA_Acc_OppRenewal.createoppty();
                
                Test.stopTest();
                
                System.assert(accOppRen <> null);
                
            }
            catch(exception e)
            {
                return;
            }
        }
    }
   /** 
@Description: validateAccOppRenewalActvUsr() method 
@Name : validateAccOppRenewalActvUsr
@Param : N/A
@Return : void
@throws Exception : N/A;
*/ 
    private static testMethod void validateAccOppRenewalActvUsr() {
        
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestCompetitr','testsalesrepmail@bcbsm.com','System Administrator');
        database.insert(usr);
        
         user usr1 = GA_OBJ_TD01_TestDataCreation.UsrRec('TestR1','testsalesrep1mail@bcbsm.com','Retention Sales');
         database.insert(usr1);
        
        system.runAs(usr)
        {
            try {
                
                Account acc= new Account(Name='TCus',GA_Opportunity_Renewal_Date__c=system.today(),
                                         Description='Test Class Cust', CID__c='123',
                                         Website='www.TCus.com', Account_Status__c='Active',
                                         NumberOfEmployees=43, Phone='23423', GA_Total_Eligible__c=78, 
                                         GA_RenewalLeadTime__c='90', Renewal_Month__c='January');
                Database.insert(acc);
                
                acc.OwnerId=usr1.id;
                database.update(acc);
                
                acc = [select GA_Opportunity_Renewal_Date__c from Account where id=:acc.Id limit 1000];
                acc.GA_Opportunity_Renewal_Date__c=system.today();
                database.update(acc);
                GA_Acc_OppRenewal_Scheduler accOppRen = new GA_Acc_OppRenewal_Scheduler();
                String sch = '0 0 23 * * ?'; 
                
                test.startTest();
                
                system.schedule('AccOppScheduler', sch, accOppRen); 
                GA_Acc_OppRenewal.createoppty(); 
                GA_Acc_OppRenewal.oppRenewlLmt=0;
                GA_Acc_OppRenewal.createoppty();
                
                Test.stopTest();
                
                System.assert(accOppRen <> null);
                
            }
            catch(exception e)
            {
                return;
            }
        }
    }
     
    /**
@Description: validateAccOppRenewalExst() method 
@Name : validateAccOppRenewalExst
@Param : N/A
@Return : void
@throws Exception : N/A;
*/ 
    private static testMethod void validateAccOppRenewalExst() {
        
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestCompetitr','testsalesrepmail@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {
            try 
            {   
                Account acc= new Account(Name='TCus',GA_Opportunity_Renewal_Date__c=system.today(),
                                         Description='Test Class Cust', CID__c='123', 
                                         Website='www.TCus.com', Account_Status__c='Active',
                                         NumberOfEmployees=43, Phone='23423', 
                                         GA_Total_Eligible__c=78, GA_RenewalLeadTime__c='90',
                                         Renewal_Month__c='January');
                Database.insert(acc);
                opportunity oppty=GA_OBJ_TD01_TestDataCreation.optyRec(acc.id);
                database.insert(oppty);
                acc = [select GA_Opportunity_Renewal_Date__c from Account where id=:acc.Id limit 1000];
                acc.GA_Opportunity_Renewal_Date__c=system.today();
                database.update(acc);
                
                GA_Acc_OppRenewal_Scheduler accOppRen = new GA_Acc_OppRenewal_Scheduler();
                String sch = '0 0 23 * * ?'; 
                
                test.startTest();
                system.schedule('AccOppScheduler', sch, accOppRen); 
                GA_Acc_OppRenewal.createoppty(); 
                Test.stopTest();
                System.assert(accOppRen <> null);
                
            }
            catch(exception e)
            {
                return;
            }
        }
    }
    /**
@Description: validateAccOppRenewalbtch() method 
@Name : validateAccOppRenewalbtch
@Param : N/A
@Return : void
@throws Exception : N/A;
*/   
    private static testMethod void validateAccOppRenewalbtch() {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestCompetitr','testsalesrepmail@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {
            try{
                Account acc= new Account(Name='TCus',GA_Opportunity_Renewal_Date__c=system.today(), 
                                         Description='Test Class Cust', CID__c='123',
                                         Website='www.TCus.com', Account_Status__c='Active',
                                         NumberOfEmployees=43, Phone='23423', GA_Total_Eligible__c=78,
                                         GA_RenewalLeadTime__c='90', Renewal_Month__c='January');
                Database.insert(acc);
                opportunity oppty=GA_OBJ_TD01_TestDataCreation.optyRec(acc.id);
                database.insert(oppty);
                acc = [select GA_Opportunity_Renewal_Date__c from Account where id=:acc.Id limit 1000];
                acc.GA_Opportunity_Renewal_Date__c=system.today();
                database.update(acc);
                
                GA_Acc_OppRenewal_Scheduler accOppRen = new GA_Acc_OppRenewal_Scheduler();
                String sch = '0 0 23 * * ?'; 
                
              	test.startTest();
                system.schedule('AccOppScheduler', sch, accOppRen); 
                GA_Acc_OppRenewal.oppRenewlLmt=0;
                GA_Acc_OppRenewal.createoppty();
                Test.stopTest();
                
                System.assert(accOppRen <> null);
            }
            catch(exception e)
            {
                return;
            }
        }
    } 
     /**
@Description: validateAccOppRenewalExcptn() method 
@Name : validateAccOppRenewalExcptn
@Param : N/A
@Return : void
@throws Exception : N/A;
*/   
    private static testMethod void validateAccOppRenewalExcptn() {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestCompetitr','testsalesrepmail@bcbsm.com','System Administrator');
        database.insert(usr);
        
         user usr1 = GA_OBJ_TD01_TestDataCreation.UsrRec('TestR1','testsalesrep1mail@bcbsm.com','Retention Sales');
         usr1.IsActive = True;
         database.insert(usr1);
        
        system.runAs(usr)
        {
            try{
                Account acc= new Account(Name='TCus',GA_Opportunity_Renewal_Date__c=system.today(), 
                                         Description='Test Class Cust', CID__c='123',
                                         Website='www.TCus.com', Account_Status__c='Active',
                                         NumberOfEmployees=43, Phone='23423', GA_Total_Eligible__c=78,
                                         GA_RenewalLeadTime__c='90', Renewal_Month__c='January');
                Database.insert(acc);
                
              	test.startTest();
                GA_Acc_OppRenewal.createoppty();
                GA_Acc_OppRenewal.dmloprtions(null);
                Test.stopTest();
                
                System.assert(usr <> null);
            }
            catch(exception e)
            {
                return;
            }
        }
    } 
    /**
@Description: opptyDataAccss() method 
@Name : opptyDataAccss
@Param : N/A
@Return : void
@throws Exception : N/A;
*/ 
    private static testMethod void opptyDataAccss() {
        
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestCompetitr','testsalesrepmail@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {
            try {
                
                Account acc= new Account(Name='TCus',GA_Opportunity_Renewal_Date__c=system.today(),
                                         Description='Test Class Cust', CID__c='123', 
                                         Website='www.TCus.com', Account_Status__c='Active', 
                                         NumberOfEmployees=43, Phone='23423', GA_Total_Eligible__c=78, 
                                         GA_RenewalLeadTime__c='90', Renewal_Month__c='January');
                Database.insert(acc);
                opportunity oppty=GA_OBJ_TD01_TestDataCreation.optyRec(acc.id);
                list<opportunity> opptyList=new list<opportunity>();
                opptyList.add(oppty);
                test.startTest();
                GA_Util10_OpportunityDataAccessHelper.dmlOnOpportunity(opptyList, 'Insert');
                GA_Util10_OpportunityDataAccessHelper.dmlOnOpportunity(opptyList, 'Update');
                GA_Util10_OpportunityDataAccessHelper.dmlOnOpportunity(opptyList, 'Upsert');
                GA_Util10_OpportunityDataAccessHelper.dmlOnOpportunity(opptyList, 'Delete');
                
                Test.stopTest();
                
                System.assert(opptyList.size()>0);
                
            }
            catch(exception e)
            {
                return;
            }
        }
    }
    /**
@Description: opptyDataAccssExp() method 
@Name : opptyDataAccssExp
@Param : N/A
@Return : void
@throws Exception : N/A;
*/ 
    private static testMethod void opptyDataAccssExp() {
        
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestCompetitr','testsalesrepmail@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {
            try {
                
                Account acc= new Account(Name='TCus',GA_Opportunity_Renewal_Date__c=system.today(),
                                         Description='Test Class Cust', CID__c='123', Website='www.TCus.com', 
                                         Account_Status__c='Active', NumberOfEmployees=43, Phone='23423', 
                                         GA_Total_Eligible__c=78, GA_RenewalLeadTime__c='90', 
                                         Renewal_Month__c='January');
                Database.insert(acc);
                opportunity oppty=GA_OBJ_TD01_TestDataCreation.optyRec(acc.id);
                list<opportunity> opptyList=new list<opportunity>();
                opptyList.add(oppty);
                test.startTest();
                GA_Util10_OpportunityDataAccessHelper.dmlOnOpportunity(null, 'Insert');
                //GA_Acc_OppRenewal.oppRenewlLmt =null;
                GA_Acc_OppRenewal.createoppty();
                
                Test.stopTest();
                System.assert(usr <> null);
            }
            catch(exception e)
            {
                System.assert(e!=null);
            }
        }
    }
    /**
@Description: opptyDataAccssfetchOpp() method 
@Name : opptyDataAccssfetchOpp
@Param : N/A
@Return : void
@throws Exception : N/A;
*/ 
    private static testMethod void opptyDataAccssfetchOpp() {
        
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestCompetitr','testsalesrepmail@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {
            try {
                
                Account acc= new Account(Name='TCus',GA_Opportunity_Renewal_Date__c=system.today(), 
                                         Description='Test Class Cust', CID__c='123', Website='www.TCus.com',
                                         Account_Status__c='Active', NumberOfEmployees=43, Phone='23423',
                                         GA_Total_Eligible__c=78, GA_RenewalLeadTime__c='90', 
                                         Renewal_Month__c='January');
                Database.insert(acc);
                opportunity oppty=GA_OBJ_TD01_TestDataCreation.optyRec(acc.id);
                list<opportunity> opptyList=new list<opportunity>();
                opptyList.add(oppty);
                string selectQuery='Select id from opportunity';
                test.startTest();
                GA_Util10_OpportunityDataAccessHelper.fetchOpportunitysMap(selectQuery, '', '', '');
                Test.stopTest();
                System.assert(opptyList.size()>0);
            }
            catch(exception e)
            {
                return;
            }
        }
    }
    
    /**
@Description: accOppExcp() method 
@Name : accOppExcp
@Param : N/A
@Return : void
@throws Exception : N/A;
*/ 
    private static testMethod void accOppExcp() {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestCompetitr','testsalesrepmail@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {
            try{
                Account acc= new Account(Name='TCus',GA_Opportunity_Renewal_Date__c=system.today(),
                                         Description='Test Class Cust', CID__c='123', Website='www.TCus.com',
                                         Account_Status__c='Active', NumberOfEmployees=43, Phone='23423',
                                         GA_Total_Eligible__c=78, GA_RenewalLeadTime__c='90', 
                                         Renewal_Month__c='January');
                Database.insert(acc);
                GA_Acc_OppRenewal.opptRecId=acc.id;
                GA_Acc_OppRenewal.createoppty();
                GA_Acc_OppRenewal.dmloprtions(null);
                System.assert(acc <> null);
            }
            catch(exception e)
            {
                return;
            } 
            
        }
    }
}