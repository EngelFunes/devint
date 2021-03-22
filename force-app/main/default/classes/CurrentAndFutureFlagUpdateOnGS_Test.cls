@isTest
public class CurrentAndFutureFlagUpdateOnGS_Test 
{
    private static testMethod void executeTest()
    {
       Account acc1 = GA_OBJ_TD01_TestDataCreation.AccRec();
        insert acc1;
        
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
        gsmt.GA_Future_Plan_Package_Chk__c = True;
        gsmt.GA_Current_Plan_Package__c = True;
        gsmt.Status__c = 'Active';
        insert gsmt;
        
       
        Test.startTest();
		SchedulableContext sc = null;
        Scheduler_CurrentAndFutureFlagUpdateOnGS tsc = new Scheduler_CurrentAndFutureFlagUpdateOnGS();
        tsc.execute(sc);
        Test.stopTest();
    }

}