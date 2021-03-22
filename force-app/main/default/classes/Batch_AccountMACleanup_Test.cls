@isTest(seeAllData = false)
public class Batch_AccountMACleanup_Test 
{
    static testMethod void accountCleanUp()
    {
        List<Account> lstAcc = new List<Account>();
        Account acc1 = GA_OBJ_TD01_TestDataCreation.AccRec();
        lstAcc.add(acc1);
        
        Account acc2 = GA_OBJ_TD01_TestDataCreation.AccRec();
        acc2.Name = 'Test MA';
        acc2.RecordTypeId =  Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Agency').getRecordTypeId();
        acc2.GA_Agency_Code__c = null;
        acc2.GA_Managing_Agency_Code__c = '12';
        lstAcc.add(acc2);        
        insert lstAcc;
        
        GA_City_Code__c cty = new GA_City_Code__c();
        cty.Name ='OTHER';
        insert cty;
        
        GA_County_Code__c cnty = new GA_County_Code__c();
        cnty.Name = 'Alger';
        insert cnty;
        
        GA_Group_Segment__c gsmt = GA_OBJ_TD01_TestDataCreation.grpSegmntRec(acc1);
        gsmt.Name = '00003_002';
        gsmt.GA_Account__c = acc1.id;
        gsmt.GA_Physical_Address_1__c= 'test address';
        gsmt.GA_Physical_City__c= cty.Id;
        gsmt.GA_Physical_City_Other__c = 'HDC3';
        gsmt.GA_Physical_State__c ='Michigan';
        gsmt.GA_Physical_County_Id__c=cnty.id;                             
        gsmt.GA_Physical_Zip__c ='24324';            
        gsmt.GA_Copy_Address_From__c ='Physical to Mailing'; 
        gsmt.GA_Rating_Type__c = 'Small Group';
        gsmt.Status__c = 'Active';
        insert gsmt; 
        
        acc1.Assigned_Managing_Agency__c = acc2.Name;
        update acc1;
        
        Account_Cleanup_Count__c setting = new Account_Cleanup_Count__c();
		setting.Name = 'AccountCount';
        setting.Run_Account_Update__c = True;
		insert setting;
        
        Test.startTest();
        Batch_AccountMACleanup cleanup = new Batch_AccountMACleanup();
        Database.executeBatch(cleanup);
        Test.stopTest();
      
    }
}