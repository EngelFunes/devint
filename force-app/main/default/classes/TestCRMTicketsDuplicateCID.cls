@isTest 
public class TestCRMTicketsDuplicateCID {
    static testMethod void testRestrictDuplicateCIDInsert() {

       String testcid = '000000';
       String userid = [select id from user limit 1].id;

       // create a new records for CRM ticket
       CRM_Tickets__c crm   = new CRM_Tickets__c();
       crm.Ticket_Subject__c = 'Test Ticket 1';
       crm.Ticket_Description__c  = 'Test Description 1';
       crm.Ticket_Type__c  = 'CID';
       crm.Priority__c = '3 - Medium';
       crm.Status__c = 'New';
       crm.Created_By_Id__c = userid;
       crm.CID__c = testcid;
       insert crm;
       
       // create a duplicate record for CRM ticket
       CRM_Tickets__c dupecrm = new CRM_Tickets__c();
       dupecrm.Ticket_Subject__c = 'Test Ticket 2';
       dupecrm.Ticket_Description__c  = 'Test Description 2';
       dupecrm.Ticket_Type__c  = 'CID';
       dupecrm.Priority__c = '3 - Medium';
       dupecrm.Status__c = 'New';
       dupecrm.Created_By_Id__c = userid;
       dupecrm.CID__c = testcid;
       
       // access what happen
       try {
           insert dupecrm;
       } catch (Exception e) { 
           System.debug('An error happened, as predicted!');
       }
       
       // count total records for CRM ticket for testcid
       List<CRM_Tickets__c> dupes = [SELECT Id FROM CRM_Tickets__c WHERE CID__c = :testcid];
       System.assertEquals(1, dupes.size());
      
       //delete the new records for CRM ticket testcid
       delete [select id FROM CRM_Tickets__c WHERE CID__c = :testcid];
    }
    
    static testMethod void testAllowDuplicateCIDInsertWhenStatusContainsClosed() {

       String testcid = '000000';
       String userid = [select id from user limit 1].id;

       // create a new records for CRM ticket
       CRM_Tickets__c crm   = new CRM_Tickets__c();
       crm.Ticket_Subject__c = 'Test Ticket 1';
       crm.Ticket_Description__c  = 'Test Description 1';
       crm.Ticket_Type__c  = 'CID';
       crm.Priority__c = '3 - Medium';
       crm.Status__c = 'Closed - Resolved';
       crm.Created_By_Id__c = userid;
       crm.CID__c = testcid;
       insert crm;
       
       // create a duplicate record for CRM ticket
       CRM_Tickets__c dupecrm = new CRM_Tickets__c();
       dupecrm.Ticket_Subject__c = 'Test Ticket 2';
       dupecrm.Ticket_Description__c  = 'Test Description 2';
       dupecrm.Ticket_Type__c  = 'CID';
       dupecrm.Priority__c = '3 - Medium';
       dupecrm.Status__c = 'New';
       dupecrm.Created_By_Id__c = userid;
       dupecrm.CID__c = testcid;
       
       // access what happen
       try {
           insert dupecrm;
       } catch (Exception e) { 
           System.debug('An error happened, record should be inserted!');
       }
       
       // count total records for CRM ticket for testcid
       List<CRM_Tickets__c> dupes = [SELECT Id FROM CRM_Tickets__c WHERE CID__c = :testcid];
       System.assertEquals(2, dupes.size());
      
       //delete the new records for CRM ticket testcid
       delete [select id FROM CRM_Tickets__c WHERE CID__c = :testcid];
    }
    
    static testMethod void testAllowMultipleCIDUpdate() {

       String testcid = '000000';
       String userid = [select id from user limit 1].id;

       // create a new records for CRM ticket
       CRM_Tickets__c crm   = new CRM_Tickets__c();
       crm.Ticket_Subject__c = 'Test Ticket 1';
       crm.Ticket_Description__c  = 'Test Description 1';
       crm.Ticket_Type__c  = 'CID';
       crm.Priority__c = '3 - Medium';
       crm.Status__c = 'New';
       crm.Created_By_Id__c = userid;
       crm.CID__c = testcid;
       insert crm;
       
       //create a duplicate record for CRM ticket
       CRM_Tickets__c updatecrm = [select id FROM CRM_Tickets__c WHERE CID__c = :testcid];
       updatecrm.Ticket_Subject__c = 'Test Ticket 2';
       updatecrm.Ticket_Description__c  = 'Test Description 2';
       updatecrm.Ticket_Type__c  = 'CID';
       updatecrm.Priority__c = '3 - Medium';
       updatecrm.Status__c = 'New';
       updatecrm.Created_By_Id__c = userid;
       updatecrm.CID__c = testcid;
       
       // access what happen
       try {
           update updatecrm;
       } catch (Exception e) { 
           System.debug('An error happened, record should be updated!');
       }
       
       // count total records for CRM ticket for testcid
       List<CRM_Tickets__c> dupes = [SELECT Id FROM CRM_Tickets__c WHERE CID__c = :testcid];
       System.assertEquals(1, dupes.size());
      
       //delete the new records for CRM ticket testcid
       delete [select id FROM CRM_Tickets__c WHERE CID__c = :testcid];
    }
}