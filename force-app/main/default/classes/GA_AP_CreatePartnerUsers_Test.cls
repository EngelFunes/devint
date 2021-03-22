/*
Test Class Name: GA_AP_CreatePartnerUsers_Test
Author: Suguna Mitrowski
Description: This is a test class for GA_AP_CreatePartnerUsers_Test
*/
@isTest
/**Test class for GA_AP_CreatePartnerUsers to check the functionality of auto enabling the partner users*/
private class GA_AP_CreatePartnerUsers_Test {
    /**Test method to insert the Partner Account*/
    private static testMethod void afterInsert_UT() 
    {
      UserRole customrole = new UserRole(DeveloperName = 'MyCustomRole', Name = 'My Role');
      database.insert(customrole);
      user usr1 = GA_OBJ_TD01_TestDataCreation.UsrRec('TestSysAdm','testsysadm@bcbsm.com','System Administrator');
      usr1.GA_ByPass_VR__c=true;
      usr1.UserRoleId = customrole.id;
      database.insert(usr1);
    }
      static testMethod void insertPartnerUser(){
     {
           
           //static testMethod void insertPartnerUser(){
            List<Account> listOfaccs = new List<Account>();
            List<Contact> lisOfcntcts = new  List<Contact> ();
            //Inserting an account & making it as partner
            Account acc = new Account();
			acc = GA_OBJ_TD01_TestDataCreation.AccRec();
            acc.Name = 'test account Agency Partner'; 
            acc.GA_Agency_Code__c='89899';
            acc.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Agency').getRecordTypeId();          
            
            Account acc1 = new Account();
            acc1 = GA_OBJ_TD01_TestDataCreation.AccRec();
            acc1.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Agency').getRecordTypeId();         
            acc1.Name='TestAgency Partner Account';
            acc1.GA_Agency_Code__c='89810';
            listOfaccs.add(acc);
            listOfaccs.add(acc1);
            database.insert(listOfaccs);
          
            Contact con = new Contact();
            //con = GA_OBJ_TD01_TestDataCreation.insertContact();
            con.FirstName='TESTCONTACT';
            con.LastName='Test';
            con.AccountId = acc.id;
            con.MailingState = 'Michigan';
            con.Phone = '9942326789';
            con.Email='test1.test2@gmail.com'; 
            con.ARV_Agent_Portal_User_Id__c='15768'; 
            con.Agent_Code__c='65768';
            con.vlocity_ins__Type__c='Agent';
            con.Active__c=True;
            lisOfcntcts.add(con);
          
            Contact con1 = new Contact();
            //con1 = Util02_TestData.insertContact();
            con1.FirstName='TESTCONTACT';
            con1.LastName= 'Test Last Name';
            con1.AccountId = acc1.id;
            con1.MailingState = 'Michigan';
            con1.Email = 'test11.test12@gmail7.com'; 
            con1.Phone = '9942326788';
            con1.ARV_Agent_Portal_User_Id__c='123';
			con1.Agent_Code__c='65769';
            con1.vlocity_ins__Type__c='Delegate Agent'; 
            con1.Active__c=True;
            lisOfcntcts.add(con1);                    
            database.insert(lisOfcntcts); 
            
			
            con.email= 'test1.test21@gmail.com';
            database.update(con);
            
                        
            Profile txtProfile = [Select ID, Name from Profile Where Name = 'BCBSM FSA Login'];
            //UserRole urole = [Select ID, Name from UserRole Where Name = 'MyCustomRole'];
            User u = new User();
            u.ContactId=con.id;
            system.debug('conId:' +u.ContactId);
            //u.Phone=con.Phone;
            u.Email=con.Email; 
            //u.UserRoleId=urole.id;       
            u.state = con.MailingState;
            u.Country='United States';
            u.EmailEncodingKey='UTF-8';
            u.LastName= con.LastName;
            u.LanguageLocaleKey='en_US';
            u.LocaleSidKey='en_US';
            u.ProfileId = txtProfile.Id;
            u.TimeZoneSidKey='America/Los_Angeles';
            u.UserName= con.FirstName+'test1.test23@gmail.com';
            u.CommunityNickName=con.FirstName+'test';
            u.Alias=con.LastName;
            u.FederationIdentifier=con.Email;
            database.insert(u);
            system.debug('USER:'+u);
			
			acc.Phone='9999999991';
            acc.IsPartner = True;
            database.update(acc);
			
			acc1.Phone='9939999992';
            acc1.IsPartner = True;
            database.update(acc1);

            database.update(con);
            database.update(con1);
		  //}
      }    
   }
}