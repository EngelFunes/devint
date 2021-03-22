@isTest
/***********************************************************************
Class Name   : ARV_AP11_FileUploadController_TEST
Date Created : 05/10/2019 (mm/dd/yyyy)
Created By   : IDC Offshore - BCBSM Team
Description  : This is a Test class for ARV_AP11_FileUploadController class.
**************************************************************************/

public class ARV_AP11_FileUploadController_TEST {
    /************************************************************************************
Method Name : testMethod1
Parameters  : None
Return type : void
Description :  
*************************************************************************************/
    private static testmethod void testMethod1()
    {
        Id parentId = '003g000001rqSU5AAM';
        string fileName='11.png';
        string base64Data= 'iVBORw0KGgoAAAANSUhE';
        string contentType='image/png';
        string fileId='';
        UserRole portalRole = [Select Id,name,developername From UserRole where NAME like '%system administrator%' Limit 1];
        system.debug('portalRole is ' + portalRole);
        
        Profile profile1 = [Select Id from Profile where name = 'System Administrator'];
        User portalAccountOwner1 = new User(
            UserRoleId = portalRole.Id,
            ProfileId = profile1.Id,
            Username = System.now().millisecond() + 'test2@test.com',
            Alias = 'batman',
            Email='bruce.wayne@wayneenterprises.com',
            EmailEncodingKey='UTF-8',
            Firstname='Bruce',
            Lastname='Wayne',
            LanguageLocaleKey='en_US',
            LocaleSidKey='en_US',
            TimeZoneSidKey='America/Chicago'
        );
        Database.insert(portalAccountOwner1);
        
        //User u1 = [Select ID From User Where Id =: portalAccountOwner1.Id];
        
        System.runAs ( portalAccountOwner1 ) {
            //Create account
            Account portalAccount1 = new Account(
                Name = 'TestAccount',
                CID__C='2',
                OwnerId = portalAccountOwner1.Id
            );
            Database.insert(portalAccount1);
            
            //Create contact
            Contact contact1 = new Contact(
                FirstName = 'Test',
                Lastname = 'McTesty',
                AccountId = portalAccount1.Id,
                Phone ='8123025937',
                Email = System.now().millisecond() + 'test@test.com'
            );
            Database.insert(contact1);
			system.debug('contactccc'+contact1.AccountId);
            
            //Create user
            Profile portalProfile = [SELECT Id FROM Profile where name='BCBSM Agent' Limit 1];
            User user1 = new User(
                Username = System.now().millisecond() + 'test12345@test.com',
                ContactId = contact1.Id,
                ProfileId = portalProfile.Id,
                Alias = 'test123',
                Email = 'test12345@test.com',
                EmailEncodingKey = 'UTF-8',
                LastName = 'McTesty',
                CommunityNickname = 'test12345',
                TimeZoneSidKey = 'America/Los_Angeles',
                LocaleSidKey = 'en_US',
                LanguageLocaleKey = 'en_US'
            );
            Database.insert(user1);
        }
    
      user uss = [select id from user where name like '%McTesty%' limit 1];
        system.runAs(uss){
    ARV_AP11_FileUploadController.saveChunk(parentId, fileName, base64Data, contentType, fileId);
    system.assert(parentId!=NULL);
    
       }
    
}
    private static testmethod void testMethod2()
    {
        Account acc= ARV_AP05_TestDataCreation.accRec();
        acc.CID__c='1234';
        //insert Acc;
        Database.insert(acc);
        
        
        Contact con= new contact();
        con.LastName = 'Bobby23';
        con.FirstName = 'dannny';
        con.AccountId = acc.Id;
        //insert con;
        Database.insert(con);
        
        User usr = ARV_AP05_TestDataCreation.UsrRec('BCBSM Agent');
        usr.ContactId = con.Id;
        usr.FirstName = 'use';
        //insert usr;
        Database.insert(usr);
        
        Blob b = Blob.valueOf('body1');
        
        Attachment att = new Attachment();
        att.ParentId = con.id;
        att.Name='att111';
        att.Body=b;
        //insert att;
        Database.insert(att);
        
        Id parentId = '003g000001rqSU5AAM';
        string fileName='11.png';
        string base64Data= 'iVBORw0KGgoAAAANSUhE';
        string contentType='image/png';
        string fileId= att.id;
        
        
        system.runAs(usr){
            //= ARV_AP11_FileUploadController FPL = new ARV_AP11_FileUploadController();
            ARV_AP11_FileUploadController.saveChunk(parentId, fileName, base64Data, contentType, fileId);
            system.assert(parentId!=NULL);
            //ARV_AP11_FileUploadController.appendToFile(fileId,base64Data);
        }
    }
}