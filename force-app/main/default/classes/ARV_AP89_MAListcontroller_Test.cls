/**
@Name: ARV_AP89_MAlistcontroller_Test
@CreatedDate: 10-March-2020
@Description: ARV_AP89_MAlistcontroller_Test List views for testing DC & Non DC contracts....
@version : 1.0 
*/
@isTest
public without sharing class ARV_AP89_MAListcontroller_Test {
    
    private static final string PROFILENAME1='System Administrator';
    private static final string PROFILENAME='BCBSM Agent';
    private static final string MANAGINGAGENCYNAME='TGG Solutions';
    private static final string BCN='BCN';
    private static final string LOCAL='Local';
    private static final string NAME1='Agent';
    private static final string NAME='Test admin';
    private static final string USERNAME='bcbsm1@bcbsm.com';
    private static final String IS_VIEW = 'related';
    private static final String IN_PROGRESS='In Progress';
    private static final String RELEASED='Released';
    private static final String ACTIVATED='Activated'; 
    Private static final String CID='23';
    private static final String TEXT_SG='SG';
    private static final String ACTIVE = 'Active';
    private static String suite = 'SUITE A';
     /*********************************
    **Constructor to Initiate Variables
    
    ***********************************/
    public ARV_AP89_MAListcontroller_Test (){
        System.assertNotEquals(suite,'SUITE A');
        suite ='SUITE A';
    }
    /*********************************************************************************************************
@Description: testDataSetup1() method 
@Name : testDataSetup1
@Param : N/A
@Return : void
@throws Exception : N/A;
***********************************************************************************************************/
    @testSetup static void testDataSetup1() { 
        Account acc = ARV_AP05_TestDataCreation.accRec();
        acc.CID__c=CID;
        acc.Account_Status__c=ACTIVE;
        acc.GA_Managing_Agency__c=true;
        acc.GA_Managing_Agency_Id__c=acc.Id;
        acc.Managing_Agent__c=MANAGINGAGENCYNAME;
        acc.ARV_Renewal_Account_Type__c=TEXT_SG;
        acc.GA_Opportunity_Renewal_Date__c=system.today();
        if(Account.SObjectType.getDescribe().isAccessible()){database.insert(acc);}
        Contract con = ARV_AP05_TestDataCreation.createContractRec(acc.Id);
        if(Contract.SObjectType.getDescribe().isAccessible()){database.insert(con);}
        GA_Group_Segment__c gsp=ARV_AP05_TestDataCreation.groupSegmentRec(acc.Id,con.Id);
        gsp.GA_Carrier__c=BCN;
        gsp.Network__c=BCN;
        gsp.Name=NAME;
        gsp.status__c=ACTIVE;
        gsp.GA_Account_Type__c=LOCAL;
        gsp.GA_Suite__c=suite;
        if(GA_Group_Segment__c.SObjectType.getDescribe().isAccessible()){database.insert(gsp);}
        con.status=ACTIVATED;
        con.ARV_Renewal_Status__c=RELEASED;
        con.EndDate =system.today()-1;
        if(Contract.SObjectType.getDescribe().isAccessible()){database.update(con);}
        user usr = ARV_AP05_TestDataCreation.UsrRec(PROFILENAME1);
        usr.LastName = NAME;
        if(user.SObjectType.getDescribe().isAccessible()){database.insert(usr,true);}
        
    }
    /*********************************************************************************************************
@Description: testgetContractDetails() method 
@Name : testgetContractDetails()
@Param : N/A
@Return : void
@throws Exception : N/A;
***********************************************************************************************************/
    private static testMethod void testgetContractDetails() {
        user usr1  = [SELECT Id from User where LastName =: NAME limit 1];
        system.runAs(usr1){
            Account acc = ARV_AP05_TestDataCreation.accRec();
            Database.insert(acc);
            Contract cont = ARV_AP05_TestDataCreation.createContractRec(acc.Id);
            Database.insert(cont);
            ARV_AP89_MAlistcontroller.listViews();
            System.assertNotEquals(null,cont);
        }
    }
    /*********************************************************************************************************
@Description: testgetContractDetails1() method 
@Name : testgetContractDetails1()
@Param : N/A
@Return : void
@throws Exception : N/A;
***********************************************************************************************************/
    private static testMethod void testgetContractDetails1() {
        user usr1 = [SELECT Id from User where LastName =: NAME Limit 1];
        system.runAs(usr1){
            Account acc = ARV_AP05_TestDataCreation.accRec();
            acc.CID__c=CID;
            acc.Account_Status__c=ACTIVE;
            acc.GA_Managing_Agency__c=true;
            acc.GA_Managing_Agency_Id__c=acc.Id;
            acc.Managing_Agent__c=MANAGINGAGENCYNAME;
            acc.ARV_Renewal_Account_Type__c=TEXT_SG;
            acc.GA_Opportunity_Renewal_Date__c=system.today();
            database.insert(acc);
            Contract con = ARV_AP05_TestDataCreation.createContractRec(acc.Id);
            database.insert(con);
            GA_Group_Segment__c gsp=ARV_AP05_TestDataCreation.groupSegmentRec(acc.Id,con.Id);
            gsp.GA_Carrier__c=BCN;
            gsp.status__c=ACTIVE;
            gsp.Network__c=BCN;
            gsp.Name=NAME;
            gsp.GA_Account_Type__c=LOCAL;
            gsp.GA_Suite__c=suite;
            database.insert(gsp);
            con.status=ACTIVATED;
            con.ARV_Renewal_Status__c=RELEASED;
            database.update(con);
            contract cont1=[select id from contract limit 1];
            list<Contract> contractList1=new List<Contract>();
            contractList1.add(cont1);
            test.startTest();   
            ARV_AP89_MAlistcontroller.getMADCRenewalContracts(1,1);
            test.stopTest(); 
            System.assertNotEquals(null,con.id);
        }
    }
    /*********************************************************************************************************
@Description: testgetContractDetails2() method 
@Name : testgetContractDetails2()
@Param : N/A
@Return : void
@throws Exception : N/A;
***********************************************************************************************************/
    private static testMethod void testgetContractDetails2() {
        user usr1 = [SELECT Id from User where LastName =: NAME Limit 1];
        system.runAs(usr1){
            Account acc = ARV_AP05_TestDataCreation.accRec();
            acc.CID__c=CID;
            acc.Account_Status__c=ACTIVE;
            acc.GA_Managing_Agency__c=true;
            acc.GA_Managing_Agency_Id__c=acc.Id;
            acc.Managing_Agent__c=MANAGINGAGENCYNAME;
            acc.ARV_Renewal_Account_Type__c=TEXT_SG;
            acc.GA_Opportunity_Renewal_Date__c=system.today();
            database.insert(acc);
            Contract con = ARV_AP05_TestDataCreation.createContractRec(acc.Id);
            database.insert(con);
            GA_Group_Segment__c gsp=ARV_AP05_TestDataCreation.groupSegmentRec(acc.Id,con.Id);
            gsp.GA_Carrier__c=BCN;
            gsp.status__c=ACTIVE;
            gsp.Network__c=BCN;
            gsp.Name=NAME;
            gsp.GA_Account_Type__c=LOCAL;
            gsp.GA_Suite__c=suite;
            database.insert(gsp);
            con.status=ACTIVATED;
            con.ARV_Renewal_Status__c=RELEASED;
            database.update(con);
            contract cont1=[select id from contract limit 1];
            list<Contract> contractList1=new List<Contract>();
            contractList1.add(cont1);
            test.startTest();   
            ARV_AP89_MAlistcontroller.getMANONDCRenewalContracts(1,1);
            test.stopTest(); 
            System.assertNotEquals(null,cont1);
        }
    }

/*********************************************************************************************************
@Description: testgetContractDetails4() method 
@Name : testgetContractDetails4()
@Param : N/A
@Return : void
@throws Exception : N/A;
***********************************************************************************************************/
    private static testMethod void testgetContractDetails4() {
        user usr1  = [SELECT Id from User where LastName =: NAME limit 1];
        system.runAs(usr1){
            Account acc = ARV_AP05_TestDataCreation.accRec();
            Database.insert(acc);
            Contract cont = ARV_AP05_TestDataCreation.createContractRec(acc.Id);
            Database.insert(cont);
            ARV_AP89_MAlistcontroller.listValues();
            System.assertNotEquals(null,cont);
        }
    }
    /*********************************************************************************************************
@Description: testgetContractDetails5() method 
@Name : testgetContractDetails4()
@Param : N/A
@Return : void
@throws Exception : N/A;
***********************************************************************************************************/
    private static testMethod void testgetContractDetails5() {
        user usr1  = [SELECT Id from User where LastName =: NAME limit 1];
        list<id> acclist= new list<id>();
        system.runAs(usr1){
            Account acc = ARV_AP05_TestDataCreation.accRec();
            Database.insert(acc); 
            acclist.add(acc.id);
            Contract cont = ARV_AP05_TestDataCreation.createContractRec(acc.Id);
            Database.insert(cont); 
            test.startTest();   
            ARV_AP89_MAlistcontroller.getMADCRenewalContracts(1,1);
            ARV_AP89_MAlistcontroller.getAgentDCRenewalContracts(1,1);
            ARV_AP89_MAlistcontroller.getAgentNonDCRenewalContracts(1,1);
            ARV_AP89_MAlistcontroller.loadwrapAgentNonDCRenewalRecords('00000805',acclist,1);
            ARV_AP89_MAlistcontroller.loadwrapAgentContractRecords('00000805',acclist,1);
            ARV_AP89_MAlistcontroller.agentlistViews();
            test.stopTest(); 
            System.assertNotEquals(null,cont.id);
        }
    }    
}