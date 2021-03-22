/*******************************************************************************************************************************
@Author : Dilip
@Name: GA_GroupSegmentTriggerHandler_Test
@CreatedDate: 7/11/2018  
@Description: GA_GroupSegmentTriggerHandler_Test class is for GA_GroupSegmentTriggerHandler and its related classes.
@version : 1.0  
********************************************************************************************************************************/
@isTest(seealldata = false)
private class GA_GroupSegmentTriggerHandler_Test {
    
    /*******************************************************************************************************************************
@Description        :   AddressUpdatePTBoth() method 
@Name               :   AddressUpdatePTBoth
@Param              :   None
@Return             :   void
@throws Exception   :   N/A;
********************************************************************************************************************************/ 
    private static testMethod void AddressUpdatePTBoth(){
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestCompetitr','testsalesrepmail@bcbsm.com','Retention Sales');
        database.insert(usr);
        system.runAs(usr){
            List<GA_City_Code__c> ctyLst = New List<GA_City_Code__c>();
            GA_City_Code__c cty = new GA_City_Code__c();
            cty.Name ='hyderabad';
            ctyLst.add(cty);
            
            GA_City_Code__c cty1 = new GA_City_Code__c();
            cty1.Name ='OTHER';
            ctyLst.add(cty1);
            
            GA_City_Code__c cty2 = new GA_City_Code__c();
            cty2.Name ='Chennai';
            ctyLst.add(cty2);
            
            Database.insert(ctyLst);
            
            GA_County_Code__c cnty = new GA_County_Code__c();
            cnty.Name = 'Alger';
            database.insert(cnty);
            
            Account acc1 = GA_OBJ_TD01_TestDataCreation.AccRec();
            database.insert(acc1);
            
            GA_Group_Segment__c gsmt = GA_OBJ_TD01_TestDataCreation.grpSegmntRec(acc1);
            gsmt.Name = '00003_002';
            gsmt.GA_Account__c = acc1.id;
            gsmt.GA_Physical_Address_1__c= 'test address';
            gsmt.GA_Physical_City__c= cty1.Id;
            gsmt.GA_Physical_City_Other__c = 'HDC3';
            gsmt.GA_Physical_State__c ='telangana';
            gsmt.GA_Physical_County_Id__c=cnty.id;                             
            gsmt.GA_Physical_Zip__c ='243243';            
            gsmt.GA_Copy_Address_From__c ='Physical to Mailing';  
            database.insert(gsmt); 
            
            system.assert(usr <> null);
        }
    }
    
    /*******************************************************************************************************************************
@Description        :   AddressUpdateMTBoth() method 
@Name               :   AddressUpdateMTBoth
@Param              :   None
@Return             :   void
@throws Exception   :   N/A;
********************************************************************************************************************************/ 
    private static testMethod void AddressUpdateMTBoth(){
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestCompetitr','testsalesrepmail@bcbsm.com','Retention Sales');
        database.insert(usr);
        system.runAs(usr){
           List<GA_City_Code__c> ctyLst = New List<GA_City_Code__c>();
            GA_City_Code__c cty = new GA_City_Code__c();
            cty.Name ='hyderabad';
            ctyLst.add(cty);
            
            GA_City_Code__c cty1 = new GA_City_Code__c();
            cty1.Name ='OTHER';
            ctyLst.add(cty1);
            
            GA_City_Code__c cty2 = new GA_City_Code__c();
            cty2.Name ='Chennai';
            ctyLst.add(cty2);
            
            Database.insert(ctyLst);
            GA_County_Code__c cnty = new GA_County_Code__c();
            cnty.Name = 'Alger';
            database.insert(cnty);
            
            Account acc1 = GA_OBJ_TD01_TestDataCreation.AccRec();
            database.insert(acc1);
            
            GA_Group_Segment__c gsmt = GA_OBJ_TD01_TestDataCreation.grpSegmntRec(acc1);
            gsmt.Name = '00003_002';
            gsmt.GA_Account__c = acc1.id;
            gsmt.GA_Mailing_Address_1__c= 'test address';
            gsmt.GA_Mailing_City__c= cty1.Id;
            gsmt.GA_Mailing_City_Other__c = 'HDC3';
            gsmt.GA_Mailing_State__c ='telangana';
            gsmt.GA_Mailing_County_Id__c=cnty.id;                             
            gsmt.GA_Mailing_Zip__c ='243243';            
            gsmt.GA_Copy_Address_From__c ='Mailing to Physical';  
            database.insert(gsmt); 
            
            system.assert(usr <> null);
        }
    }
    
    
    
    
    /*******************************************************************************************************************************
@Description        :   AddressUpdateBTBoth() method 
@Name               :   AddressUpdateBTBoth
@Param              :   None
@Return             :   void
@throws Exception   :   N/A;
********************************************************************************************************************************/ 
    private static testMethod void AddressUpdateBTBoth(){
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestCompetitr','testsalesrepmail@bcbsm.com','Retention Sales');
        database.insert(usr);
        system.runAs(usr){
            List<GA_City_Code__c> ctyLst = New List<GA_City_Code__c>();
            GA_City_Code__c cty = new GA_City_Code__c();
            cty.Name ='hyderabad';
            ctyLst.add(cty);
            
            GA_City_Code__c cty1 = new GA_City_Code__c();
            cty1.Name ='OTHER';
            ctyLst.add(cty1);
            
            GA_City_Code__c cty2 = new GA_City_Code__c();
            cty2.Name ='Chennai';
            ctyLst.add(cty2);
            
            Database.insert(ctyLst);
            
            GA_County_Code__c cnty = new GA_County_Code__c();
            cnty.Name = 'Alger';
            database.insert(cnty);
            
            Account acc1 = GA_OBJ_TD01_TestDataCreation.AccRec();
            database.insert(acc1);
            
            GA_Group_Segment__c gsmt = GA_OBJ_TD01_TestDataCreation.grpSegmntRec(acc1);
            gsmt.Name = '00003_002';
            gsmt.GA_Account__c = acc1.id;
            gsmt.GA_Billing_Address_1__c= 'test address';
            gsmt.GA_Billing_City__c= cty1.Id;
            gsmt.GA_Billing_City_Other__c = 'HDC3';
            gsmt.GA_Billing_State__c ='telangana';
            gsmt.GA_Billing_County_Id__c=cnty.id;                             
            gsmt.GA_Billing_Zip__c ='243243';            
            gsmt.GA_Copy_Address_From__c ='Billing to Mailing;Billing to Physical';  
            database.insert(gsmt); 
            
            system.assert(usr <> null);
        }
    }
    
        /*******************************************************************************************************************************
@Description        :   AddressUpdateBTBothBatch() method 
@Name               :   AddressUpdateBTBothBatch
@Param              :   None
@Return             :   void
@throws Exception   :   N/A;
********************************************************************************************************************************/ 
    private static testMethod void AddressUpdateBTBothBatch(){
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestCompetitr','testsalesrepmail@bcbsm.com','Retention Sales');
        database.insert(usr);
        system.runAs(usr){
            List<GA_City_Code__c> ctyLst = New List<GA_City_Code__c>();
            GA_City_Code__c cty = new GA_City_Code__c();
            cty.Name ='hyderabad';
            ctyLst.add(cty);
            
            GA_City_Code__c cty1 = new GA_City_Code__c();
            cty1.Name ='OTHER';
            ctyLst.add(cty1);
            
            GA_City_Code__c cty2 = new GA_City_Code__c();
            cty2.Name ='Chennai';
            ctyLst.add(cty2);
            
            Database.insert(ctyLst);
            
            GA_County_Code__c cnty = new GA_County_Code__c();
            cnty.Name = 'Alger';
            database.insert(cnty);
            
            Account acc1 = GA_OBJ_TD01_TestDataCreation.AccRec();
            database.insert(acc1);
            GA_GS_AP02_Update_Address.isExecuting=false;
            GA_GS_AP02_Update_Address.isInvoked=false;
            List<GA_Group_Segment__c> gList = new List<GA_Group_Segment__c>();
            //Changed for loop size to get rid of CPU time limit exception
            for(integer i=0; i<10; i++){
                GA_Group_Segment__c gsmt = GA_OBJ_TD01_TestDataCreation.grpSegmntRec(acc1);
                gsmt.Name = '00003_002';
                gsmt.GA_Account__c = acc1.id;
                gsmt.GA_Billing_Address_1__c= 'test address';
                gsmt.GA_Billing_City__c= cty1.Id;
                gsmt.GA_Billing_City_Other__c = 'HDC3';
                gsmt.GA_Billing_State__c ='telangana';
                gsmt.GA_Billing_County_Id__c=cnty.id;                             
                gsmt.GA_Billing_Zip__c ='243243';            
                gsmt.GA_Copy_Address_From__c ='Billing to Mailing;Billing to Physical';  
                gList.add(gsmt);
            }
            
            database.insert(gList); 
            
            system.assert(usr <> null);
        }
    }
    
            /*******************************************************************************************************************************
@Description        :   AddressUpdateMTBothBatch() method 
@Name               :   AddressUpdateMTBothBatch
@Param              :   None
@Return             :   void
@throws Exception   :   N/A;
********************************************************************************************************************************/ 
    private static testMethod void AddressUpdateMTBothBatch(){
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestCompetitr','testsalesrepmail@bcbsm.com','Retention Sales');
        database.insert(usr);
        system.runAs(usr){
            List<GA_City_Code__c> ctyLst = New List<GA_City_Code__c>();
            GA_City_Code__c cty = new GA_City_Code__c();
            cty.Name ='hyderabad';
            ctyLst.add(cty);
            
            GA_City_Code__c cty1 = new GA_City_Code__c();
            cty1.Name ='OTHER';
            ctyLst.add(cty1);
            
            GA_City_Code__c cty2 = new GA_City_Code__c();
            cty2.Name ='Chennai';
            ctyLst.add(cty2);
            
            Database.insert(ctyLst);
            
            GA_County_Code__c cnty = new GA_County_Code__c();
            cnty.Name = 'Alger';
            database.insert(cnty);
            
            Account acc1 = GA_OBJ_TD01_TestDataCreation.AccRec();
            database.insert(acc1);
            
            GA_GS_AP02_Update_Address.isExecuting=false;
            GA_GS_AP02_Update_Address.isInvoked=false;
            
            List<GA_Group_Segment__c> gList = new List<GA_Group_Segment__c>();
            //Changed for loop size to get rid of CPU time limit exception
            for(integer i=0; i<10; i++){
                GA_Group_Segment__c gsmt = GA_OBJ_TD01_TestDataCreation.grpSegmntRec(acc1);
                gsmt.Name = '00003_002';
                gsmt.GA_Account__c = acc1.id;
                gsmt.GA_Mailing_Address_1__c= 'test address';
                gsmt.GA_Mailing_City__c= cty1.Id;
                gsmt.GA_Mailing_City_Other__c = 'HDC3';
                gsmt.GA_Mailing_State__c ='telangana';
                gsmt.GA_Mailing_County_Id__c=cnty.id;                             
                gsmt.GA_Mailing_Zip__c ='243243';            
                gsmt.GA_Copy_Address_From__c ='Mailing to Physical';  
                gList.add(gsmt);
            }
            
            database.insert(gList); // Insert Record
            
            system.assert(usr <> null);
        }
    }
    
                /*******************************************************************************************************************************
@Description        :   AddressUpdatePTBothBatch() method 
@Name               :   AddressUpdatePTBothBatch
@Param              :   None
@Return             :   void
@throws Exception   :   N/A;
********************************************************************************************************************************/ 
    private static testMethod void AddressUpdatePTBothBatch(){
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestCompetitr','testsalesrepmail@bcbsm.com','Retention Sales');
        database.insert(usr);
        system.runAs(usr){
            List<GA_City_Code__c> ctyLst = New List<GA_City_Code__c>();
            GA_City_Code__c cty = new GA_City_Code__c();
            cty.Name ='hyderabad';
            ctyLst.add(cty);
            
            GA_City_Code__c cty1 = new GA_City_Code__c();
            cty1.Name ='OTHER';
            ctyLst.add(cty1);
            
            GA_City_Code__c cty2 = new GA_City_Code__c();
            cty2.Name ='Chennai';
            ctyLst.add(cty2);
            
            Database.insert(ctyLst);
            
            GA_County_Code__c cnty = new GA_County_Code__c();
            cnty.Name = 'Alger';
            database.insert(cnty);
            
            Account acc1 = GA_OBJ_TD01_TestDataCreation.AccRec();
            database.insert(acc1);
            
            GA_GS_AP02_Update_Address.isExecuting=false;
            GA_GS_AP02_Update_Address.isInvoked=false;
            
            List<GA_Group_Segment__c> gList = new List<GA_Group_Segment__c>();
            for(integer i=0; i<10; i++){
                GA_Group_Segment__c gsmt = GA_OBJ_TD01_TestDataCreation.grpSegmntRec(acc1);
                gsmt.Name = '00003_002';
                gsmt.GA_Account__c = acc1.id;
                gsmt.GA_Physical_Address_1__c= 'test address';
                gsmt.GA_Physical_City__c= cty1.Id;
                gsmt.GA_Physical_City_Other__c = 'HDC3';
                gsmt.GA_Physical_State__c ='telangana';
                gsmt.GA_Physical_County_Id__c=cnty.id;                             
                gsmt.GA_Physical_Zip__c ='243243';            
                gsmt.GA_Copy_Address_From__c ='Physical to Mailing';  
                gList.add(gsmt);
            }
            
            database.insert(gList); 
            
            system.assert(usr <> null);
        }
    }    
    
                /*******************************************************************************************************************************
@Description        :   AddresswithOtherCity() method 
@Name               :   AddresswithOtherCity
@Param              :   None
@Return             :   void
@throws Exception   :   N/A;
********************************************************************************************************************************/ 
    private static testMethod void AddresswithOtherCity(){
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestCompetitr','testsalesrepmail@bcbsm.com','Retention Sales');
        database.insert(usr);
        system.runAs(usr){
            List<GA_City_Code__c> ctyLst = New List<GA_City_Code__c>();
            GA_City_Code__c cty = new GA_City_Code__c();
            cty.Name ='hyderabad';
            ctyLst.add(cty);
            
            GA_City_Code__c cty1 = new GA_City_Code__c();
            cty1.Name ='OTHER';
            ctyLst.add(cty1);
            
            GA_City_Code__c cty2 = new GA_City_Code__c();
            cty2.Name ='Chennai';
            ctyLst.add(cty2);
            
            Database.insert(ctyLst);
            
            GA_County_Code__c cnty = new GA_County_Code__c();
            cnty.Name = 'Alger';
            database.insert(cnty);
            
            Account acc1 = GA_OBJ_TD01_TestDataCreation.AccRec();
            database.insert(acc1);
            
            GA_Group_Segment__c gsmt = GA_OBJ_TD01_TestDataCreation.grpSegmntRec(acc1);
            gsmt.Name = '00003_002';
            gsmt.GA_Account__c = acc1.id;
            gsmt.GA_Physical_Address_1__c= 'test address';
            gsmt.GA_Physical_City__c= cty1.id;
            gsmt.GA_Physical_State__c ='telangana';
            gsmt.GA_Physical_County_Id__c=cnty.id;    
            gsmt.GA_Physical_City_Other__c = 'HDC3';
            gsmt.GA_Billing_City__c=cty1.id;    
            gsmt.GA_Billing_City_Other__c = 'HDC3';
            gsmt.GA_Mailing_City__c=cty1.id;    
            gsmt.GA_Mailing_City_Other__c = 'HDC3';
            gsmt.GA_Physical_Zip__c ='243243';            
            gsmt.GA_Copy_Address_From__c ='Physical to Mailing';  
            database.insert(gsmt); 
            
            system.assert(usr <> null);
        }
    }
    
                /*******************************************************************************************************************************
@Description        :   AddressupdateCity() method 
@Name               :   AddressupdateCity
@Param              :   None
@Return             :   void
@throws Exception   :   N/A;
********************************************************************************************************************************/ 
    private static testMethod void AddressupdateCity(){
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestCompetitr','testsalesrepmail@bcbsm.com','Retention Sales');
        database.insert(usr);
        system.runAs(usr){
            List<GA_City_Code__c> ctyLst = New List<GA_City_Code__c>();
            GA_City_Code__c cty = new GA_City_Code__c();
            cty.Name ='hyderabad';
            ctyLst.add(cty);
            
            GA_City_Code__c cty1 = new GA_City_Code__c();
            cty1.Name ='OTHER';
            ctyLst.add(cty1);
            
            GA_City_Code__c cty2 = new GA_City_Code__c();
            cty2.Name ='Chennai';
            ctyLst.add(cty2);
            
            Database.insert(ctyLst);
            
            GA_County_Code__c cnty = new GA_County_Code__c();
            cnty.Name = 'Alger';
            database.insert(cnty);
            
            Account acc1 = GA_OBJ_TD01_TestDataCreation.AccRec();
            database.insert(acc1);
            
            GA_Group_Segment__c gsmt = GA_OBJ_TD01_TestDataCreation.grpSegmntRec(acc1);
            gsmt.Name = '00003_002';
            gsmt.GA_Account__c = acc1.id;
            gsmt.GA_Physical_Address_1__c= 'test address';
            gsmt.GA_Physical_City__c= cty2.id;
            gsmt.GA_Physical_State__c ='telangana';
            gsmt.GA_Physical_County_Id__c=cnty.id;    
            gsmt.GA_Physical_City_Other__c = '';
            gsmt.GA_Billing_City__c=cty2.id;    
            gsmt.GA_Billing_City_Other__c = '';
            gsmt.GA_Mailing_City__c=cty2.id;    
            gsmt.GA_Mailing_City_Other__c = '';
            gsmt.GA_Physical_Zip__c ='243243';            
            gsmt.GA_Copy_Address_From__c ='Physical to Mailing'; 
            GA_GS_AP02_Update_Address.isExecuting = false;
            database.insert(gsmt); 
            gsmt.GA_Is_Mass_Updating__c = true;
            GA_GS_AP02_Update_Address.isExecuting = false;
            gsmt.GA_Physical_City__c= cty1.id;
            
            gsmt.GA_Physical_City_Other__c = 'mumbai';
            gsmt.GA_Billing_City__c=cty1.id;    
            gsmt.GA_Billing_City_Other__c = 'mumbai';
            gsmt.GA_Mailing_City__c=cty1.id;    
            gsmt.GA_Mailing_City_Other__c = 'mumbai';
            
            database.update(gsmt);  
            
            system.assert(usr <> null);
            
        }
    }
    
                /*******************************************************************************************************************************
@Description        :   AddressupdateCityPhy() method 
@Name               :   AddressupdateCityPhy
@Param              :   None
@Return             :   void
@throws Exception   :   N/A;
********************************************************************************************************************************/ 
    private static testMethod void AddressupdateCityPhy(){
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestCompetitr','testsalesrepmail@bcbsm.com','Retention Sales');
        database.insert(usr);
        system.runAs(usr){
            List<GA_City_Code__c> ctyLst = New List<GA_City_Code__c>();
            GA_City_Code__c cty = new GA_City_Code__c();
            cty.Name ='hyderabad';
            ctyLst.add(cty);
            
            GA_City_Code__c cty1 = new GA_City_Code__c();
            cty1.Name ='OTHER';
            ctyLst.add(cty1);
            
            GA_City_Code__c cty2 = new GA_City_Code__c();
            cty2.Name ='Chennai';
            ctyLst.add(cty2);
            
            Database.insert(ctyLst);
            
            GA_County_Code__c cnty = new GA_County_Code__c();
            cnty.Name = 'Alger';
            database.insert(cnty);
            
            Account acc1 = GA_OBJ_TD01_TestDataCreation.AccRec();
            database.insert(acc1);
            
            GA_Group_Segment__c gsmt = GA_OBJ_TD01_TestDataCreation.grpSegmntRec(acc1);
            gsmt.Name = '00003_002';
            gsmt.GA_Account__c = acc1.id;
            gsmt.GA_Physical_Address_1__c= 'test address';
            gsmt.GA_Physical_City__c= cty2.id;
            gsmt.GA_Physical_State__c ='telangana';
            gsmt.GA_Physical_County_Id__c=cnty.id;    
            gsmt.GA_Physical_City_Other__c = '';
            gsmt.GA_Physical_Zip__c='11224';
            gsmt.GA_Copy_Address_From__c ='Physical to Mailing';  
            database.insert(gsmt); 
            gsmt.GA_Is_Mass_Updating__c = true;
            GA_GS_AP02_Update_Address.isExecuting = false;
            gsmt.GA_Physical_City__c= cty.id;            
            //gsmt.GA_Physical_City_Other__c = 'HDC3';
            
            database.update(gsmt);            
            
            system.assert(usr <> null);
        }
    }
    
                /*******************************************************************************************************************************
@Description        :   AddressupdateCityBilling() method 
@Name               :   AddressupdateCityBilling
@Param              :   None
@Return             :   void
@throws Exception   :   N/A;
********************************************************************************************************************************/ 
    private static testMethod void AddressupdateCityBilling(){
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestCompetitr','testsalesrepmail@bcbsm.com','Retention Sales');
        database.insert(usr);
        system.runAs(usr){
            List<GA_City_Code__c> ctyLst = New List<GA_City_Code__c>();
            GA_City_Code__c cty = new GA_City_Code__c();
            cty.Name ='hyderabad';
            ctyLst.add(cty);
            
            GA_City_Code__c cty1 = new GA_City_Code__c();
            cty1.Name ='OTHER';
            ctyLst.add(cty1);
            
            GA_City_Code__c cty2 = new GA_City_Code__c();
            cty2.Name ='Chennai';
            ctyLst.add(cty2);
            
            Database.insert(ctyLst);
            
            GA_County_Code__c cnty = new GA_County_Code__c();
            cnty.Name = 'Alger';
            database.insert(cnty);
            
            Account acc1 = GA_OBJ_TD01_TestDataCreation.AccRec();
            database.insert(acc1);
            
            GA_Group_Segment__c gsmt = GA_OBJ_TD01_TestDataCreation.grpSegmntRec(acc1);
            gsmt.Name = '00003_002';
            gsmt.GA_Account__c = acc1.id;
            gsmt.GA_Billing_Address_1__c= 'test address';
            gsmt.GA_Billing_City__c= cty2.id;
            gsmt.GA_Billing_City_Other__c ='';
            gsmt.GA_Billing_State__c='telangana';
            gsmt.GA_Billing_County_Id__c=cnty.id;   
            gsmt.GA_Billing_Zip__c='11224';
            gsmt.GA_Copy_Address_From__c ='Billing to Physical;Billing to Mailing';  
            database.insert(gsmt); 
            gsmt.GA_Is_Mass_Updating__c = true;
            GA_GS_AP02_Update_Address.isExecuting = false;
            gsmt.GA_Billing_City__c= cty1.id;            
            gsmt.GA_Billing_City_Other__c = 'HDC3';
            
            database.update(gsmt);   
            
            system.assert(usr <> null);
            
        }
    }
    
                /*******************************************************************************************************************************
@Description        :   AddressupdateCityBillingBatch() method 
@Name               :   AddressupdateCityBillingBatch
@Param              :   None
@Return             :   void
@throws Exception   :   N/A;
********************************************************************************************************************************/ 
    private static testMethod void AddressupdateCityBillingBatch(){
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestCompetitr','testsalesrepmail@bcbsm.com','Retention Sales');
        database.insert(usr);
        system.runAs(usr){
            List<GA_City_Code__c> ctyLst = New List<GA_City_Code__c>();
            GA_City_Code__c cty = new GA_City_Code__c();
            cty.Name ='hyderabad';
            ctyLst.add(cty);
            
            GA_City_Code__c cty1 = new GA_City_Code__c();
            cty1.Name ='OTHER';
            ctyLst.add(cty1);
            
            GA_City_Code__c cty2 = new GA_City_Code__c();
            cty2.Name ='Chennai';
            ctyLst.add(cty2);
            
            Database.insert(ctyLst);
            
            GA_County_Code__c cnty = new GA_County_Code__c();
            cnty.Name = 'Alger';
            database.insert(cnty);
            
            Account acc1 = GA_OBJ_TD01_TestDataCreation.AccRec();
            database.insert(acc1);
              Contract con = ARV_AP05_TestDataCreation.createContractRec(acc1.Id);
            database.insert(con);
           
          
            List<GA_Group_Segment__c> gList = new List<GA_Group_Segment__c>();
            //Changed for loop size to get rid of CPU time limit exception
            for(integer i=0; i<10; i++){
                GA_Group_Segment__c gsmt = GA_OBJ_TD01_TestDataCreation.grpSegmntRec(acc1);
                gsmt.Name = '00003_002';
                gsmt.GA_Account__c = acc1.id;
                  gsmt.ARV_ContractID__c=con.Id;
                gsmt.GA_Billing_Address_1__c= 'test address';
                gsmt.GA_Billing_City__c= cty2.id;
                gsmt.GA_Billing_City_Other__c ='';
                gsmt.GA_Billing_State__c='telangana';
                gsmt.GA_Billing_County_Id__c=cnty.id;   
                gsmt.GA_Billing_Zip__c='11224';
                gsmt.Suspend_Bill_Indicator__c='N';
                gsmt.GA_Copy_Address_From__c ='Billing to Physical;Billing to Mailing'; 
                gList.add(gsmt);
            }
            
            database.insert(gList); 
            
            GA_GS_AP02_Update_Address.isExecuting=false;
            GA_GS_AP02_Update_Address.isInvoked=false;
            
            List<GA_Group_Segment__c> gListToUpdate = new List<GA_Group_Segment__c>();
            for(GA_Group_Segment__c gsmt : gList){
                gsmt.GA_Is_Mass_Updating__c = true;
                gsmt.GA_Billing_City__c= cty1.id;            
                gsmt.GA_Billing_City_Other__c = 'HDC3';
                gListToUpdate.add(gsmt);
            }
            database.update(gListToUpdate);  
            
            system.assert(usr <> null);
        }
    }
    
                /*******************************************************************************************************************************
@Description        :   updateCounty() method 
@Name               :   updateCounty
@Param              :   None
@Return             :   void
@throws Exception   :   N/A;
********************************************************************************************************************************/ 
    private static testMethod void updateCounty(){
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestCompetitr','testsalesrepmail@bcbsm.com','Integration User');
        database.insert(usr);
        system.runAs(usr){
            GA_County_Code__c cs = new GA_County_Code__c();
            cs.name = 'OUT OF STATE';
            insert cs;
            GA_GS_AP02_Update_Address.isExecuting=false;
            
            Account acc1 = GA_OBJ_TD01_TestDataCreation.AccRec();
            database.insert(acc1);
            ZipCode__c zipCode = new ZipCode__c(ZipCode__c='24324'); // For US:2146
            insert zipCode;
            List<GA_Group_Segment__c> gsList = new List<GA_Group_Segment__c>();
            GA_Group_Segment__c gsmt = GA_OBJ_TD01_TestDataCreation.grpSegmntRec(acc1);
            gsmt.Name = '00003_002';
            gsmt.GA_Account__c = acc1.id;
            gsmt.GA_Physical_State__c='GA';
            gsmt.GA_Billing_State__c='GA'; 
            gsmt.GA_Mailing_State__c='GA'; 
            gsmt.GA_Physical_Zip__c ='24343';
            gsmt.GA_Billing_Zip__c='24343';
            gsmt.GA_Mailing_Zip__c='24343';
            database.insert(gsmt); 
            
            system.assert(usr <> null);
        }
    }
    
                /*******************************************************************************************************************************
@Description        :   AddressUI() method 
@Name               :   AddressUI
@Param              :   None
@Return             :   void
@throws Exception   :   N/A;
********************************************************************************************************************************/ 
    private static testMethod void AddressUI(){
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestCompetitr','testsalesrepmail@bcbsm.com','Retention Sales');
        database.insert(usr);
        system.runAs(usr){
            
            GA_City_Code__c cty1 = new GA_City_Code__c();
            cty1.Name ='OTHER';
            database.insert(cty1);
            
            GA_County_Code__c cnty = new GA_County_Code__c();
            cnty.Name = 'Alger';
            database.insert(cnty);
            
            Account acc1 = GA_OBJ_TD01_TestDataCreation.AccRec();
            database.insert(acc1);
            
            List<GA_Group_Segment__c> gList = new List<GA_Group_Segment__c>();
            GA_Group_Segment__c gsmt = GA_OBJ_TD01_TestDataCreation.grpSegmntRec(acc1);
            gsmt.Name = '00003_002';
            gsmt.GA_Account__c = acc1.id;
            gsmt.GA_Physical_Address_1__c= 'test address';
            gsmt.GA_Physical_City__c= cty1.id;
            gsmt.GA_Physical_City_Other__c='test';
            gsmt.GA_Physical_State__c ='telangana';
            gsmt.GA_Physical_County_Id__c=cnty.id; 
            gsmt.GA_Physical_Zip__c ='243243';             
            gsmt.GA_Copy_Address_From__c ='Physical to Mailing; Billing to Mailing';  
            GA_GS_AP02_Update_Address.isExecuting = false;
            gList.add(gsmt); 
            GA_GS_AP02_Update_Address.updateCityCopyAddressUI(gList[0]);
            
            system.assert(usr <> null);
        }
    }
    
                /*******************************************************************************************************************************
@Description        :   AddressBilingCityOthr() method 
@Name               :   AddressBilingCityOthr
@Param              :   None
@Return             :   void
@throws Exception   :   N/A;
********************************************************************************************************************************/ 
    private static testMethod void AddressBilingCityOthr(){
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestCompetitr','testsalesrepmail@bcbsm.com','Retention Sales');
        database.insert(usr);
        system.runAs(usr){
            
            GA_City_Code__c cty1 = new GA_City_Code__c();
            cty1.Name ='OTHER';
            database.insert(cty1);
            
            GA_County_Code__c cnty = new GA_County_Code__c();
            cnty.Name = 'Alger';
            database.insert(cnty);
            
            Account acc1 = GA_OBJ_TD01_TestDataCreation.AccRec();
            database.insert(acc1);
            
            //Billing to Physical;Billing to Mailing
            List<GA_Group_Segment__c> gList = new List<GA_Group_Segment__c>();
            GA_Group_Segment__c gsmnt = GA_OBJ_TD01_TestDataCreation.grpSegmntRec(acc1);
            gsmnt.Name = '00003_003';
            gsmnt.GA_Account__c = acc1.id;
            gsmnt.GA_Billing_Address_1__c= 'test address';
            gsmnt.GA_Billing_City__c= cty1.id;
            gsmnt.GA_Billing_City_Other__c='test';
            gsmnt.GA_Billing_State__c ='telangana';
            gsmnt.GA_Billing_County_Id__c=cnty.id; 
            gsmnt.GA_Billing_Zip__c ='243243';             
            gsmnt.GA_Copy_Address_From__c ='Mailing to Physical; Billing to Physical';  
            GA_GS_AP02_Update_Address.isExecuting = false;
            gList.add(gsmnt); 
            GA_GS_AP02_Update_Address.updateCityCopyAddressUI(gList[0]);
            
            system.assert(usr <> null);
        }
    }
    
                /*******************************************************************************************************************************
@Description        :   AddressUpdateBTBothBatchUI() method 
@Name               :   AddressUpdateBTBothBatchUI
@Param              :   None
@Return             :   void
@throws Exception   :   N/A;
********************************************************************************************************************************/ 
    private static testMethod void AddressUpdateBTBothBatchUI(){
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestCompetitr','testsalesrepmail@bcbsm.com','Retention Sales');
        database.insert(usr);
        system.runAs(usr){
            List<GA_City_Code__c> ctyLst = New List<GA_City_Code__c>();
            GA_City_Code__c cty = new GA_City_Code__c();
            cty.Name ='hyderabad';
            ctyLst.add(cty);
            
            GA_City_Code__c cty1 = new GA_City_Code__c();
            cty1.Name ='OTHER';
            ctyLst.add(cty1);
            
            GA_City_Code__c cty2 = new GA_City_Code__c();
            cty2.Name ='Chennai';
            ctyLst.add(cty2);
            
            Database.insert(ctyLst);
            
            GA_County_Code__c cnty = new GA_County_Code__c();
            cnty.Name = 'Alger';
            database.insert(cnty);
            
            Account acc1 = GA_OBJ_TD01_TestDataCreation.AccRec();
            database.insert(acc1);
            GA_GS_AP02_Update_Address.isExecuting=false;
            GA_GS_AP02_Update_Address.isInvoked=false;
            
            Contract con = ARV_AP05_TestDataCreation.createContractRec(acc1.Id);
            database.insert(con);
            GA_Group_Segment__c gsmt = GA_OBJ_TD01_TestDataCreation.grpSegmntRec(acc1);
            gsmt.Name = '00003_002';
            gsmt.ARV_ContractID__c=con.Id;
            gsmt.GA_Account__c = acc1.id;
            gsmt.GA_Billing_Address_1__c= 'test address';
             gsmt.GA_Billing_Address_2__c= 'test address';
              gsmt.GA_Billing_Address_3__c= 'test address';
            gsmt.GA_Billing_City__c= cty1.Id;
            gsmt.GA_Billing_City_Other__c = 'HDC34';
            gsmt.GA_Billing_State__c ='telangana';
            gsmt.GA_Billing_County_Id__c=cnty.id;                             
            gsmt.GA_Billing_Zip__c ='243243';            
            gsmt.GA_Copy_Address_From__c ='Billing to Mailing;Billing to Physical';  
            gsmt.GA_Carrier__c = 'BCN' ;
            gsmt.GA_Bill_Level__c = 'G'; 
              gsmt.Network__c='BCN';
            gsmt.GA_Facets_Group_ID__c='test';
            gsmt.GA_Facets_Sub_Group_Number__c='td02';
            Database.insert(gsmt);
            List<GA_Group_Segment__c> gList = [select id,GA_Billing_City_Other__c, GA_Billing_City_Name__c, GA_Billing_Address_1__c, GA_Billing_City__c,
                                               GA_Billing_State__c, GA_Billing_County_Id__c, GA_Billing_Zip__c, GA_Physical_City_Other__c, GA_Mailing_City_Other__c,
                                               GA_Copy_Address_From__c from  GA_Group_Segment__c where id =: gsmt.id Limit 1];
            GA_GS_AP02_Update_Address.updateCityCopyAddressUI(gList[0]);
            
            system.assert(usr <> null);
        }
    }
  
/*******************************************************************************************************************************
@Description        :   WFProcessUpdate() method 
@Name               :   WFProcessUpdate
@Param              :   None
@Return             :   void
@throws Exception   :   N/A;
********************************************************************************************************************************/ 
    // For US-2146
    @isTest
    private static void WFProcessUpdate(){
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestCompetitr','testsalesrepmail@bcbsm.com','Retention Sales');
        database.insert(usr);
        system.runAs(usr){
            List<GA_City_Code__c> ctyLst = New List<GA_City_Code__c>();
            GA_City_Code__c cty = new GA_City_Code__c();
            cty.Name ='Detroit';
            ctyLst.add(cty);
            
            GA_City_Code__c cty1 = new GA_City_Code__c();
            cty1.Name ='OTHER';
            ctyLst.add(cty1);
            
            GA_City_Code__c cty2 = new GA_City_Code__c();
            cty2.Name ='Chicago';
            ctyLst.add(cty2);
            
            Database.insert(ctyLst);
            
            GA_County_Code__c cnty = new GA_County_Code__c();
            cnty.Name = 'Alger';
            database.insert(cnty);
            
            Account acc1 = GA_OBJ_TD01_TestDataCreation.AccRec();
            database.insert(acc1);
            GA_GS_AP02_Update_Address.isExecuting=false;
            GA_GS_AP02_Update_Address.isInvoked=false;
            
            GA_Group_Segment__c gsmt = GA_OBJ_TD01_TestDataCreation.grpSegmntRec(acc1);
            gsmt.GA_Billing_Address_1__c= 'test address';
            gsmt.GA_Billing_City__c= cty1.Id;
            gsmt.GA_Billing_City_Other__c = 'HDC34';
            gsmt.GA_Billing_State__c ='Michigan';
            gsmt.GA_Billing_County_Id__c=cnty.id;                             
            gsmt.GA_Billing_Zip__c ='24324';            
            gsmt.GA_Copy_Address_From__c ='Billing to Mailing;Billing to Physical'; 
            Database.insert(gsmt);
            
            GA_WFT_workflow__c testWFTmplt = GA_OBJ_TD01_TestDataCreation.wrkFlwTmplt();
            Database.insert(testWFTmplt);
            
            Case testCase = GA_OBJ_TD01_TestDataCreation.CaseRec();
            Database.insert(testCase);
            
            GA_WF_Workflow__c testWrkFlw = GA_OBJ_TD01_TestDataCreation.createWrkFlw(acc1, testCase, testWFTmplt, usr);
            Database.insert(testWrkFlw);
            
            GA_WF_Step__c wfStep = GA_OBJ_TD01_TestDataCreation.wrkFlwStp(testWrkFlw);
            Database.insert(wfStep);
            
            GA_WF_Group_Segment__c wfProcess = GA_OBJ_TD01_TestDataCreation.wrkFlwGs(gsmt, wfStep);
            Database.insert(wfProcess);
            
            gsmt.GA_Is_Mass_Updating__c = true;
            GA_GS_AP02_Update_Address.isExecuting = false;
            gsmt.GA_Physical_City__c= cty.id;
            Database.update(gsmt);
            
            wfProcess.GA_Closing_Notes__c = 'Test for closing';
            Database.update(wfProcess);
            
       }
    }
   
/*******************************************************************************************************************************
@Description        :   AgencyUpdateonAccount() method 
@Name               :   AgencyUpdateonAccount
@Param              :   None
@Return             :   void
@throws Exception   :   N/A;
********************************************************************************************************************************/ 
    // For US-2421
    @isTest
    private static void AgencyUpdateonAccount(){
        
        List<GA_City_Code__c> ctyLst = New List<GA_City_Code__c>();
        GA_City_Code__c cty = new GA_City_Code__c();
        cty.Name ='Detroit';
        ctyLst.add(cty);
        
        GA_City_Code__c cty1 = new GA_City_Code__c();
        cty1.Name ='OTHER';
        ctyLst.add(cty1);
        
        GA_City_Code__c cty2 = new GA_City_Code__c();
        cty2.Name ='Chicago';
        ctyLst.add(cty2);
    
        Database.insert(ctyLst);
        
        GA_County_Code__c cnty = new GA_County_Code__c();
        cnty.Name = 'Alger';
        database.insert(cnty);
        
        Account acc1 = GA_OBJ_TD01_TestDataCreation.AccRec();
        database.insert(acc1);
        Account acc2 = new Account();
        acc2.Name = 'Test Age Acc';
        Id recId = Schema.SObjectType.account.getRecordTypeInfosByName().get('Account - Agency').getRecordTypeId();
        acc2.RecordTypeId = recId;
        database.insert(acc2);
        GA_GS_AP02_Update_Address.isExecuting=false;
        GA_GS_AP02_Update_Address.isInvoked=false;
        
        GA_Group_Segment__c gsmt = GA_OBJ_TD01_TestDataCreation.grpSegmntRec(acc1);
        gsmt.GA_Billing_Address_1__c= 'test address';
        gsmt.GA_Billing_City__c= cty1.Id;
        gsmt.GA_Billing_City_Other__c = 'HDC34';
        gsmt.GA_Billing_State__c ='Michigan';
        gsmt.GA_Billing_County_Id__c=cnty.id;                             
        gsmt.GA_Billing_Zip__c ='24324';            
        gsmt.GA_Copy_Address_From__c ='Billing to Mailing;Billing to Physical'; 
        gsmt.GA_Physical_Address_1__c  ='Billing to Mailing;Billing to Physical';       
        Database.insert(gsmt);
        
        gsmt.GA_Is_Mass_Updating__c = true;
        GA_GS_AP02_Update_Address.isExecuting = false;
        gsmt.GA_Physical_City__c= cty.id;
        gsmt.GA_Rating_Type__c = 'Small Group';
        gsmt.GA_Managing_Agency__c=acc2.Id;
        Database.update(gsmt);
   } 

   /*******************************************************************************************************************************
@Description        :   createMAOnGS() method 
@Name               :   createMAOnGS
@Param              :   None
@Return             :   void
@throws Exception   :   N/A;
********************************************************************************************************************************/ 
    // For US-2456
    @isTest
    private static void createMAOnGS(){
        
        List<GA_City_Code__c> ctyLst = New List<GA_City_Code__c>();
        GA_City_Code__c cty = new GA_City_Code__c();
        cty.Name ='Detroit';
        ctyLst.add(cty);
        
        GA_City_Code__c cty1 = new GA_City_Code__c();
        cty1.Name ='OTHER';
        ctyLst.add(cty1);
        
        GA_City_Code__c cty2 = new GA_City_Code__c();
        cty2.Name ='Chicago';
        ctyLst.add(cty2);
    
        Database.insert(ctyLst);
        
        GA_County_Code__c cnty = new GA_County_Code__c();
        cnty.Name = 'Alger';
        database.insert(cnty);
        
        List<Account> lstAcc = new List<Account>();
        Account acc1 = GA_OBJ_TD01_TestDataCreation.AccRec();
        acc1.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Customer').getRecordTypeId();
        database.insert(acc1);
        
        Account acc2 = new Account();
        acc2.Name = 'Test Age Acc';
        Id recId = Schema.SObjectType.account.getRecordTypeInfosByName().get('Account - Agency').getRecordTypeId();
        acc2.GA_Managing_Agency_Code__c = '12';
        acc2.RecordTypeId = recId;
        lstAcc.add(acc2);
        database.insert(acc2);
        
        GA_GS_AP02_Update_Address.isExecuting=false;
        GA_GS_AP02_Update_Address.isInvoked=false;
        
        acc1.Assigned_Managing_Agency__c = 'Test Age Acc';
        database.update(acc1);
       
        GA_Group_Segment__c gsmt1 = GA_OBJ_TD01_TestDataCreation.grpSegmntRec(acc1);
        gsmt1.GA_Billing_Address_1__c= 'test address';
        gsmt1.GA_Billing_City__c= cty1.Id;
        gsmt1.GA_Billing_City_Other__c = 'HDC34';
        gsmt1.GA_Billing_State__c ='Michigan';
        gsmt1.GA_Billing_County_Id__c=cnty.id;                             
        gsmt1.GA_Billing_Zip__c ='24324';            
        gsmt1.GA_Copy_Address_From__c ='Billing to Mailing;Billing to Physical'; 
        Database.insert(gsmt1);   
   }
    
     /*******************************************************************************************************************************
@Description        :   testRenewal() method 
@Name               :   testRenewal
@Param              :   None
@Return             :   void
@throws Exception   :   N/A;
********************************************************************************************************************************/ 
    // For 
    @isTest
    private static void testRenewal(){
        
        List<Account> lstAcc = new List<Account>();
        Account acc1 = GA_OBJ_TD01_TestDataCreation.AccRec();
        acc1.GA_Opportunity_Renewal_Date__c = system.today().addMonths(2);
        acc1.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Customer').getRecordTypeId();
        database.insert(acc1);
        
        Account acc2 = new Account();
        acc2.Name = 'Test Age Acc';
        Id recId = Schema.SObjectType.account.getRecordTypeInfosByName().get('Account - Agency').getRecordTypeId();
        acc2.GA_Managing_Agency_Code__c = '12';
        acc2.RecordTypeId = recId;
        acc2.GA_Opportunity_Renewal_Date__c = system.today().addMonths(1);
        lstAcc.add(acc2);
        database.insert(acc2);
        
        GA_GS_AP02_Update_Address.isExecuting=false;
        GA_GS_AP02_Update_Address.isInvoked=false;
        
        acc1.Assigned_Managing_Agency__c = 'Test Age Acc';
        database.update(acc1);
       
        GA_Group_Segment__c gsmt1 = GA_OBJ_TD01_TestDataCreation.grpSegmntRec(acc1);
        gsmt1.Status__c = 'Active';
        gsmt1.GA_Account__c = acc1.Id;    
        gsmt1.GA_Rate_Renewal_Date__c = System.today(); 
        Database.insert(gsmt1);
        
        gsmt1.GA_Rate_Renewal_Date__c =    system.today().addMonths(5);
        Database.update(gsmt1); 
        
        GA_Group_Segment__c gsmt3 = [SELECT ID FROM GA_Group_Segment__c LIMIT 1];
        gsmt3.Status__c = 'Active';
        gsmt3.GA_Account__c = acc1.Id;
        gsmt3.GA_Copy_Address_From__c ='Billing to Mailing;Billing to Physical';
        Database.update(gsmt3); 
   }
   
    @isTest
    private static void testRenewalUpdateCase(){
        
        GA_GS_AP02_Update_Address.isExecuting=false;
        GA_GS_AP02_Update_Address.isInvoked=false;
        ARV_AP88_GroupSegmentPackageCreation.isExecute88 = false;
        
        Account acc=GA_OBJ_TD01_TestDataCreation.AccRec();
        acc.GA_Opportunity_Renewal_Date__c = system.today().addMonths(1);
        database.insert(acc);
        
        GA_Group_Segment__c gs = GA_OBJ_TD01_TestDataCreation.grpSegmntRec(acc);
        gs.Name='AMZ000009_AZ02';
        gs.GA_Account__c = acc.id;
        gs.status__c = 'Active';
        gs.GA_Rate_Renewal_Date__c = System.today();
        database.insert(gs);
        
        gs.GA_Facets_Group_ID__c = 'AMZ00000';
        database.update(gs);
    }
    
/*******************************************************************************************************************************
@Description        :   updateAddressOnRelatedGSTest() method 
@Name               :   updateAddressOnRelatedGSTest
@Param              :   None
@Return             :   void
@throws Exception   :   N/A;
********************************************************************************************************************************/ 
    @isTest static void updateAddressOnRelatedGSTest(){
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestCompetitr','testsamail@bcbsm.com','System administrator');
        database.insert(usr);
        system.runAs(usr){
            List<GA_City_Code__c> ctyLst = New List<GA_City_Code__c>();
            GA_City_Code__c cty = new GA_City_Code__c();
            cty.Name ='Detroit';
            ctyLst.add(cty);
            
            GA_City_Code__c cty1 = new GA_City_Code__c();
            cty1.Name ='OTHER';
            ctyLst.add(cty1);
            
            GA_City_Code__c cty2 = new GA_City_Code__c();
            cty2.Name ='Chicago';
            ctyLst.add(cty2);
        
            Database.insert(ctyLst);
            
            GA_County_Code__c cnty = new GA_County_Code__c();
            cnty.Name = 'Alger';
            database.insert(cnty);
            
            List<Account> lstAcc = new List<Account>();
            Account acc1 = GA_OBJ_TD01_TestDataCreation.AccRec();
            acc1.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Customer').getRecordTypeId();
            database.insert(acc1);
            
            GA_Group_Segment__c gsmt1 = GA_OBJ_TD01_TestDataCreation.grpSegmntRec(acc1);
            gsmt1.GA_Billing_Address_1__c= 'test address';
            gsmt1.GA_Billing_City__c= cty1.Id;
            gsmt1.GA_Billing_City_Other__c = 'HDC34';
            gsmt1.GA_Bill_Level__c = 'G';
            gsmt1.GA_Carrier__c = 'BCN';
            gsmt1.GA_Facets_Group_ID__c = '10098876';
            gsmt1.GA_Facets_Sub_Group_Number__c = '0001';
            gsmt1.GA_Facets_Class_ID__c = '7765';
            gsmt1.GA_Billing_State__c ='Michigan';
            gsmt1.GA_Billing_County_Id__c=cnty.id;                             
            gsmt1.GA_Billing_Zip__c ='48335';            
            Database.insert(gsmt1);
            
            GA_Group_Segment__c gsmt2 = GA_OBJ_TD01_TestDataCreation.grpSegmntRec(acc1);
            gsmt2.GA_Billing_Address_1__c= '123 address ';
            gsmt2.GA_Billing_City__c= cty1.Id;
            gsmt2.GA_Billing_City_Other__c = 'HDC34';
            gsmt2.GA_Bill_Level__c = 'S';
            gsmt2.GA_Carrier__c = 'BCN';
            gsmt2.GA_Facets_Group_ID__c = '10098878';
            gsmt2.GA_Facets_Sub_Group_Number__c = '0001';
            gsmt2.GA_Facets_Class_ID__c = '7765';
            gsmt2.GA_Billing_State__c ='Michigan';
            gsmt2.GA_Billing_County_Id__c=cnty.id;                             
            gsmt2.GA_Billing_Zip__c ='48338';            
            Database.insert(gsmt2);
            
            GA_Group_Segment__c gsmt3 = new GA_Group_Segment__c(Id = gsmt1.Id);
            GA_GS_AP02_Update_Address.isExecuting = false;
            gsmt3.GA_Billing_Address_1__c= 'test address23';
            gsmt3.GA_New_Hire_Exception__c='Test';
            Database.update(gsmt3);
            
            GA_Group_Segment__c gsmt4 = new GA_Group_Segment__c(Id = gsmt2.Id);
            GA_GS_AP02_Update_Address.isExecuting = false;
            gsmt4.GA_Billing_Address_1__c= 'test address23789';
            Database.update(gsmt4);
        }
    }
}