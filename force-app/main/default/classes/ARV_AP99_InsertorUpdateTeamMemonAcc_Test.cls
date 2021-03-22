/*****************************************************************************************
Class Name   : ARV_AP99_InsertorUpdateTeamMemonAcc_Test
Date Created : 15-june-2020
Created By   : IDC Offshore
Description  : This test class is used to cover ARV_AP99_InsertorUpdateTeamMemonAcc
******************************************************************************************/
@isTest(SeeAllData=false)
public without sharing class ARV_AP99_InsertorUpdateTeamMemonAcc_Test {
    private static final string PROFILENAME1='System Administrator';
    private static final string PROFILENAME='BCBSM Agent';
    private static final string NAME1='Agentuser1';
    private static final string FISTNAME='Firstname';
    private static final string LASTNAME='Lastname';
    private static final string USERNAME='bcbsm1@bcbsm.com';
    private static final string USERNAME1='bcbsm2@bcbsm.com';
/*****************************************************************************************
Method Name  : testDataSetup1 
Created By   : IDC Offshore
Description  : this is test data setup method for user,account teammember creation.
******************************************************************************************/
     @testSetup static void testDataSetup1() { 
        Id RecordTypeIdAcc = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Agency').getRecordTypeId();
        Account agntACC=ARV_AP05_TestDataCreation.PortalAccRec('Agntacc','Account_Agency');
			agntACC.recordtypeid=RecordTypeIdAcc;
        database.insert(agntACC);
        Contact con = new Contact();
			con.LastName=LASTNAME;
			con.FirstName=FISTNAME;
			con.AccountID = agntACC.id;
        database.insert(con);
        Contact con1 = new Contact();
			con1.LastName=LASTNAME;
			con1.FirstName=FISTNAME;
			con1.AccountID = agntACC.id;
        database.insert(con1);
         user usr = ARV_AP05_TestDataCreation.PortalUserRecord(con);
        	usr.LastName = NAME1;
        database.insert(usr,true);
        user usr_MA = ARV_AP05_TestDataCreation.PortalUserRecord(con1);
         Id maProfileId= [Select id from Profile where name='Managing Agent Community User'].id;
         usr_MA.profileId=maProfileId;
        	usr_MA.LastName = 'MAUSERtest_MAcom';
			usr_MA.Username = 'MAUSERtest_MAcom@bcbtest.com';
			usr_MA.CommunityNickname='MACom_Macom';
			usr_MA.Email='MAUSERtest_MAcom@testmail.com';
        database.insert(usr_MA,true);
		User usr1 =ARV_AP05_TestDataCreation.UsrRec('System Administrator');
			usr1.lastname='testAdmin';
        database.insert(usr1);
        Account acc = ARV_AP05_TestDataCreation.accRec();
			Id RecordTypeIdAcc1 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Prospect').getRecordTypeId();
			acc.RecordTypeid=RecordTypeIdAcc1;
			acc.Name='TestAgentowner';
           database.insert(acc); 
         Account accMA = ARV_AP05_TestDataCreation.accRec();
			Id RecordTypeIdAccMA = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Prospect').getRecordTypeId();
			accMA.RecordTypeid=RecordTypeIdAccMA;
			accMA.Name='TestMAAgentowner';
        database.insert(accMA);
        AccountTeamMember acctmem=new AccountTeamMember();
			acctmem.AccountId=acc.id;
			acctmem.TeamMemberRole='Agent';
			acctmem.UserId =usr.Id;
			acctmem.AccountAccessLevel = 'Read';
        database.insert(acctmem);
         AccountTeamMember acctmem1=new AccountTeamMember();
             acctmem1.AccountId=accMA.id;
             acctmem1.TeamMemberRole='Agent';
             acctmem1.UserId =usr_MA.Id;
             acctmem1.AccountAccessLevel = 'Read';
         database.insert(acctmem1);
   } 
/*****************************************************************************************
Method Name  : testAccountTeamMember 
Created By   : IDC Offshore
Description  : this covers the teammember access updates the read to write.
******************************************************************************************/
    private static testMethod void testAccountTeamMember() {
       
        user us=[select id from user where lastname ='Agentuser1' limit 1];
        user usad=[select id from user where lastname ='testAdmin'];
  
        Account acc2=[select id,ownerid  From account  where name ='TestAgentowner'];
        system.runAs(us){
            test.startTest();
            acc2.ownerid=usad.id;
            database.update(acc2);
            test.stopTest();
            system.assertNotEquals(1,[select count() from AccountTeamMember  where accountid=:acc2.id and AccountAccessLevel='Edit']);
        }
     }
/*****************************************************************************************
Method Name  : testAccountTeamMember_MA 
Created By   : IDC Offshore
Description  : this covers the teammember access updates the read to write.
******************************************************************************************/
	private static testMethod void testAccountTeamMember_MA() {
       
        user us=[select id from user where lastname ='MAUSERtest_MAcom' limit 1];
        user usad=[select id from user where lastname ='testAdmin'];
  
        Account acc2=[select id,ownerid  From account  where name ='TestMAAgentowner'];
        system.runAs(us){
            ARV_AP99_InsertorUpdateTeamMemonAcc accown=new ARV_AP99_InsertorUpdateTeamMemonAcc();
            test.startTest();
            acc2.ownerid=usad.id;
            database.update(acc2);
            test.stopTest();
           system.assertNotEquals(1,[select count() from AccountTeamMember  where accountid=:acc2.id and AccountAccessLevel='Edit']); 
        }
     }
    private static testMethod void testAccountTeamMember_MA1() {
       
        user us=[select id from user where lastname ='MAUSERtest_MAcom' limit 1];
        user usad=[select id from user where lastname ='testAdmin'];
  
        Account acc2=[select id,ownerid  From account  where name ='TestMAAgentowner'];
        system.runAs(us){
            map<id,account> acold=new map<id,account>();
            map<id,account> acnew=new map<id,account>();
            acold.put(acc2.id, acc2);
             //accown=new ARV_AP99_InsertorUpdateTeamMemonAcc();
            test.startTest();
            acc2.ownerid=usad.id;
            database.update(acc2);
            acnew.put(acc2.id, acc2);
            ARV_AP99_InsertorUpdateTeamMemonAcc.updateAccountTeamAccess(acold,acnew);
            test.stopTest();
           system.assertNotEquals(1,[select count() from AccountTeamMember  where accountid=:acc2.id and AccountAccessLevel='Edit']); 
        }
     }
}