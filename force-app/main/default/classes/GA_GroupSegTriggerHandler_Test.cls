@isTest
private class GA_GroupSegTriggerHandler_Test {
    
    @testsetup static void AddressUpdatePTBoth(){
        Account acc1 = GA_OBJ_TD01_TestDataCreation.AccRec();
        database.insert(acc1);       
        
        
        GA_Group_Segment__c gsmt = GA_OBJ_TD01_TestDataCreation.grpSegmntRec(acc1);
        gsmt.Name = '00003_002';
        gsmt.GA_Account__c = acc1.id;
        gsmt.GA_Physical_Address_1__c= 'test address';
        gsmt.GA_Physical_City_Other__c = 'HDC3';
        gsmt.GA_Physical_State__c ='telangana';
        gsmt.Status__c ='Active';
        
        gsmt.GA_Physical_Zip__c ='243243';            
        gsmt.GA_Copy_Address_From__c ='Physical to Mailing';  
        database.insert(gsmt);           
    }
    
    @isTest static void updateTrigger(){
        Account acc1 = GA_OBJ_TD01_TestDataCreation.AccRec();
        database.insert(acc1);
        
        Contact con = GA_OBJ_TD01_TestDataCreation.cntactRec(acc1.Id);
        database.insert(con);
        
        GA_Group_Segment__c gsmt = [SELECT id from GA_Group_Segment__c];
        gsmt.GA_Carrier__c = 'BCN';
        gsmt.Network__c = 'BCN';
        gsmt.GA_Billing_Contact_Id__c = con.Id; 
        
        update gsmt;
    }
}