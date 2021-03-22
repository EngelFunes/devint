/*****************************************************************************************
Class Name   : ARV_AP107_GWCTTTriggerHandler_Test. 
Date Created : 3-MARCH-2021
Created By   : IDC Offshore
Description  :This class is to test ARV_AP107_GWCTransacTableTriggerHandler class.
******************************************************************************************/

@isTest(seealldata = false)
public class ARV_AP107_GWCTTTriggerHandler_Test {
	   
    public static testmethod void test1(){
		Id recordTypeIdAccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Customer').getRecordTypeId();
        Profile profileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
        String APPROVED = 'Approval Process - Approved';
        String REVIEW = 'Under Review';
        Id recordTypeIdGWCTT = Schema.SObjectType.ARV_GWC_Transaction_Table__c.getRecordTypeInfosByName().get('Maintenance Change').getRecordTypeId();
        Integer a;
        
        User usr = new User(LastName = 'LIVESTON',
                           FirstName='ss',
                           Alias = 'ss',
                           Email = 'ss@ss224.com',
                           Username = 'ss@ss123.com',
                           ProfileId = profileId.id,
                           TimeZoneSidKey = 'GMT',
                           LanguageLocaleKey = 'en_US',
                           EmailEncodingKey = 'UTF-8',
                           LocaleSidKey = 'en_US'
                           );
        
        insert usr;    
        
        system.runAs(usr){
            a=1;
            
         	Account acc = ARV_AP05_TestDataCreation.accRec();
            acc.RecordTypeId = recordTypeIdAccount;
            database.insert(acc);
            
            Contract con = ARV_AP05_TestDataCreation.createContractRec(acc.Id);
            database.insert(con);
            
            GA_Group_Segment__c gs1=ARV_AP05_TestDataCreation.groupSegmentRec2(acc.Id, con.Id);  
            database.insert(gs1);
            
            ARV_GWC_Transaction_Table__c gwcTT = new ARV_GWC_Transaction_Table__c();
            gwcTT.RecordTypeId = recordTypeIdGWCTT;
            gwcTT.Account_ID__c = acc.Id;
            gwcTT.Group_Name__c = gs1.Id;
            gwcTT.ARV_Tech_Segment_Name__c = 'test';
            gwcTT.ARV_Tech_Federal_Tax_ID__c = '19028358297';
            gwcTT.Status__c = REVIEW;
            database.insert(gwcTT);
            
            gwcTT.Status__c = APPROVED;
            database.update(gwcTT);
            
            system.assertEquals(a,1);
        }
    }
}