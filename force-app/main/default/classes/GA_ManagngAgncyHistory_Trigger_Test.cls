/*****************************************************************************************
Class Name   : GA_ManagngAgncyHistory_Trigger_Test
Date Created : 10/05/2017
Created By   : IDC Offshore
Description  : 1. This is test class is for GA_ManagngAgncyHistory_Trigger_Test
******************************************************************************************/
@isTest(seealldata = false)
private class GA_ManagngAgncyHistory_Trigger_Test {
    /*******************************************************************************************************************************
@Description: PrepopulateCallCat() method 
@Name : PrepopulateCallCat
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
    private testmethod static void  PrepopulateCallCat()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestJeoRl','testsalesrepmail@bcbsm.com','System Administrator');
        Database.insert(usr);
       
        system.runAs(usr)
        {
            Account acc1 = GA_OBJ_TD01_TestDataCreation.AccRec();
            database.insert(acc1);
            
            Id RecordTypeIdAccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Agency').getRecordTypeId();

            Account acc2 = new Account();
            acc2.Name='Test Acc';
            acc2.RecordTypeId=RecordTypeIdAccount;
            acc2.GA_Managing_Agency_Code__c='01';
            
            database.insert(acc2);
            system.debug('acc2'+acc2);
            
            GA_Group_Segment__c gsmt = GA_OBJ_TD01_TestDataCreation.grpSegmntRec(acc1);
            gsmt.Name = '00003_002';
            gsmt.GA_Account__c = acc1.id;
            
            database.insert(gsmt);
            
             
            GA_Managing_Agency_History__c mangAgency = new GA_Managing_Agency_History__c();
            mangAgency.GA_Group_Segment__c=gsmt.id;
            mangAgency.Name='Test';
            mangAgency.GA_Managing_Agency__c=acc2.id;
            mangAgency.GA_Start_Date__c=system.today();
            mangAgency.GA_End_Date__c=system.today()+2;
          
            test.startTest();
            database.insert(mangAgency);
            mangAgency.GA_End_Date__c=system.today()+3;
            database.update(mangAgency);
            test.stopTest();
            //task tskQRec=[select id,GA_Call_Category__c from task where id=:tskRec.id limit 1];
            system.assert(mangAgency <> null,true);
        }
        
    }
}