/*
@Author : Rahul
@Name: ManagingAgencyTriggerHandler_Test
@CreatedDate: 03/04/2020
@Description: ManagingAgencyTriggerHandler_Test is test class for Managing agency trigger handler class
@version : 1.0  
*/

// This is implemented as part of US-1633
@isTest
public class ManagingAgencyTriggerHandler_Test 
{
    private static testMethod void testWithMA()
    {
    	Test.startTest();
        List<Account> lstAcc = new List<Account>();
        Account acc1 = GA_OBJ_TD01_TestDataCreation.AccRec();
        lstAcc.add(acc1);
        
        Account acc2 = GA_OBJ_TD01_TestDataCreation.AccRec();
        acc2.RecordTypeId =  Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Agency').getRecordTypeId();
        acc2.GA_Agency_Code__c = null;
        acc2.GA_Managing_Agency_Code__c = '12';
        lstAcc.add(acc2);        
        insert lstAcc;
        
        Managing_Agency__c objMA = new Managing_Agency__c();
        objMA.Name = 'Test_MA';
        objMA.Start_Date__c =  System.today();
        objMA.End_Date__c = System.today()+10;
        objMA.Account__c = acc1.Id;
        objMA.Mng_Agency_Acc_Filter__c = acc2.Id;        
        insert objMA;
        
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
        gsmt.GA_Physical_State__c ='telangana';
        gsmt.GA_Physical_County_Id__c=cnty.id;                             
        gsmt.GA_Physical_Zip__c ='24324';            
        gsmt.GA_Copy_Address_From__c ='Physical to Mailing'; 
        gsmt.GA_Rating_Type__c = 'Small Group';
        database.insert(gsmt); 
        
        GA_Managing_Agency_History__c objGAMAH = new GA_Managing_Agency_History__c();
        objGAMAH.GA_Group_Segment__c = gsmt.Id;
        objGAMAH.GA_Managing_Agency__c = acc2.Id;
        objGAMAH.GA_Start_Date__c = System.today();            
        insert objGAMAH;
            
        Managing_Agency_Group_Segment__c objMAGS = new Managing_Agency_Group_Segment__c();
        objMAGS.Group_Segment__c = gsmt.Id;
        objMAGS.Managing_Agency__c = objMA.Id;        
        insert objMAGS;
            
        objMA.End_Date__c = System.today()+15;       
        update objMA;
        
        System.assertEquals(objGAMAH.GA_Start_Date__c, System.today());
        System.assertNotEquals(objMA.End_Date__c, System.today()+5);
        
        Test.stopTest();        
    }
    
	private static testMethod void testWithOutMA()
    {
    	Test.startTest();
        List<Account> lstAcc = new List<Account>();
        Account acc1 = GA_OBJ_TD01_TestDataCreation.AccRec();
        lstAcc.add(acc1);
        
        Account acc2 = GA_OBJ_TD01_TestDataCreation.AccRec();
        acc2.RecordTypeId =  Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Agency').getRecordTypeId();
        acc2.GA_Agency_Code__c = null;
        acc2.GA_Managing_Agency_Code__c = '12';
        lstAcc.add(acc2);        
        insert lstAcc;
        
        Managing_Agency__c objMA = new Managing_Agency__c();
        objMA.Name = 'Test_MA';
        objMA.Start_Date__c =  System.today();
        objMA.End_Date__c = System.today()+10;
        objMA.Account__c = acc1.Id;
        objMA.Mng_Agency_Acc_Filter__c = acc2.Id;
        insert objMA;
        
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
        gsmt.GA_Physical_State__c ='telangana';
        gsmt.GA_Physical_County_Id__c=cnty.id;                             
        gsmt.GA_Physical_Zip__c ='24324';            
        gsmt.GA_Copy_Address_From__c ='Physical to Mailing'; 
        gsmt.GA_Rating_Type__c = 'Small Group';
        database.insert(gsmt);
        
        
        GA_Managing_Agency_History__c objGAMAH = new GA_Managing_Agency_History__c();
        objGAMAH.GA_Group_Segment__c = gsmt.Id;
        objGAMAH.GA_Managing_Agency__c = acc2.Id;
        objGAMAH.GA_Start_Date__c = System.today();
        objGAMAH.MA_Override_Start_Date__c = System.today();  //d1880
        insert objGAMAH;
        
        List<Managing_Agency_Group_Segment__c> lstMAGS = new List<Managing_Agency_Group_Segment__c>();
        Managing_Agency_Group_Segment__c objMAGS = new Managing_Agency_Group_Segment__c(Group_Segment__c = gsmt.Id, Managing_Agency__c = objMA.Id);
    	lstMAGS.add(objMAGS);
        
        Managing_Agency_Group_Segment__c objMAGS1 = new Managing_Agency_Group_Segment__c(Group_Segment__c = gsmt.Id,Managing_Agency__c = objMA.Id);
        lstMAGS.add(objMAGS1);
        insert lstMAGS;
            
        objMA.End_Date__c = System.today()+15;       
        update objMA;
        
        objMA.MA_Override_End_Date__c = System.today()+10;       //1880
        update objMA;
        
        System.assertEquals(objGAMAH.GA_Start_Date__c, System.today());
        System.assertEquals(objGAMAH.MA_Override_Start_Date__c, System.today()); //d1880
        System.assertNotEquals(objMA.End_Date__c, System.today()+5);
        System.assertNotEquals(objMA.MA_Override_End_Date__c, System.today()+5); //d1880
        
        Test.stopTest();        
    }
}