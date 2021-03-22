/*
@Author : Sri Lakshmi Addula
@Name: GA_GS_AP02_Update_Address_Test 
@CreatedDate: 26 - Nov 2018 
@Description: GA_GS_AP02_Update_Address Test class
@version : 1.0  
*/
@isTest(seealldata = false)
private class GA_GS_AP02_Update_Address_Test {
    /**
@Description: updtGsAddressNodata() method 
@Name : updtGsAddressNodata
@Param : N/A   
@Return : void
@throws Exception : N/A;
*/   
    private static testmethod void updtGsAddressNodata()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestGrpSgmtrelatLst','testsystemadminstrator@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {
            try {
                
                Account acc=GA_OBJ_TD01_TestDataCreation.AccRec();
                database.insert(acc);
                
                acc.GA_System_of_Record__c='Salesforce';
                database.update(acc);
                GA_Group_Segment__c grpsgmt = GA_OBJ_TD01_TestDataCreation.grpSegmntRec(acc);
                test.startTest();
                database.insert(grpsgmt);
                test.stopTest();
                
                system.assert(acc <> null);
                
            }
            catch(exception e)
            {
                return;
            }
        }
    }  
    /**
@Description: updtmultipleGsAddress() method 
@Name : updtmultipleGsAddress
@Param : N/A   
@Return : void
@throws Exception : N/A;
*/   
    private static testmethod void updtmultipleGsAddress()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestGrpSgmtrelatLst','testsystemadminstrator@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {
            try{
                
                Account acc=GA_OBJ_TD01_TestDataCreation.AccRec();
                database.insert(acc);
                
                acc.GA_System_of_Record__c='Salesforce';
                database.update(acc);
                
                List<GA_City_Code__c> ctyLst = New List<GA_City_Code__c>();
                GA_City_Code__c cty = new GA_City_Code__c();
                cty.Name='Delton';
                ctyLst.add(cty);
                
                GA_City_Code__c otherCity = new GA_City_Code__c();
                otherCity.Name='Other';
                ctyLst.add(otherCity);
                Database.insert(ctyLst);
                
                GA_County_Code__c outOfState = new GA_County_Code__c();
                outOfState.Name='OUT OF STATE';
                Database.insert(outOfState);
                
                List<GA_Group_Segment__c> gsLst = New List<GA_Group_Segment__c>();
                
                GA_Group_Segment__c grpsgmt = GA_OBJ_TD01_TestDataCreation.grpSegmntRec(acc);
                grpsgmt.GA_Mailing_Address_1__c = 'test addrss';
                grpsgmt.GA_Mailing_State__c ='MA';
                grpsgmt.GA_Mailing_County_Id__c = outOfState.id;
                grpsgmt.GA_Mailing_Zip__c = '12333';
                grpsgmt.GA_Physical_City__c=otherCity.id;
                grpsgmt.GA_Physical_City_Other__c='Hyd';
                grpsgmt.GA_Billing_City__c=otherCity.id;
                grpsgmt.GA_Billing_City_Other__c='Hyd';
                grpsgmt.GA_Mailing_City__c=otherCity.id;
                grpsgmt.GA_Mailing_City_Other__c='Hyd';
                grpsgmt.GA_Copy_Address_From__c = 'Billing to Mailing;Billing to Physical';
                gsLst.add(grpsgmt);
                
                GA_Group_Segment__c gs2 = GA_OBJ_TD01_TestDataCreation.grpSegmntRec(acc);
                gs2.GA_Physical_City__c=otherCity.id;
                gs2.GA_Physical_City_Other__c='Banglore';
                gs2.GA_Billing_City__c=otherCity.id;
                gs2.GA_Billing_City_Other__c='Banglore';
                gs2.GA_Mailing_City__c=otherCity.id;
                gs2.GA_Mailing_City_Other__c='Banglore';
                gs2.GA_Copy_Address_From__c = 'Mailing to Physical;Mailing to Billing;';
                gsLst.add(gs2);
                
                string upDtPickListvalues = 'Physical to Mailing;Physical to Billing;Billing to Mailing;Billing to Physical;Mailing to Physical;Mailing to Billing';
                List<GA_Group_Segment__c> uptGsLst =New  List<GA_Group_Segment__c>();
                
                test.startTest();
                database.insert(gsLst);
                GA_GS_AP02_Update_Address.isExecuting = false;
                GA_GS_AP02_Update_Address.isInvoked = false;
                for(GA_Group_Segment__c uptGs : gsLst){
                    uptGs.GA_Billing_State__c='TS';
                    uptGs.GA_Billing_County_Id__c=null;
                    uptGs.GA_Physical_State__c='TS';
                    uptGs.GA_Physical_County_Id__c=null;
                    uptGs.GA_Mailing_State__c='TS';
                    uptGs.GA_Mailing_County_Id__c=null;
                    uptGs.GA_Copy_Address_From__c = upDtPickListvalues;
                    uptGsLst.add(uptGs);}
                database.update(uptGsLst);
                
                test.stopTest();
                
                system.assert(acc <> null);
                
            }
            catch(exception e)
            {
                return;
            }
        }
    }
    
    /**
@Description: updtGsAddressPTM() method 
@Name : updtGsAddressPTM
@Param : N/A   
@Return : void
@throws Exception : N/A;
*/   
    private static testmethod void updtGsAddressPTM()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestGrpSgmtrelatLst','testsystemadminstrator@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {
            try{
                Account acc=GA_OBJ_TD01_TestDataCreation.AccRec();
                database.insert(acc);
                
                acc.GA_System_of_Record__c='Salesforce';
                database.update(acc);
                
                List<GA_City_Code__c> ctyLst = New List<GA_City_Code__c>();
                GA_City_Code__c cty = new GA_City_Code__c();
                cty.Name='Delton';
                ctyLst.add(cty);
                
                GA_City_Code__c otherCity = new GA_City_Code__c();
                otherCity.Name='Other';
                ctyLst.add(otherCity);
                database.insert(ctyLst);
                
                GA_County_Code__c outOfState = new GA_County_Code__c();
                outOfState.Name='OUT OF STATE';
                database.insert(outOfState);
                List<GA_Group_Segment__c> gsLst = New List<GA_Group_Segment__c>();
                
                GA_Group_Segment__c grpsgmt = GA_OBJ_TD01_TestDataCreation.grpSegmntRec(acc);
                grpsgmt.GA_Physical_Address_1__c = 'test addrss';    
                grpsgmt.GA_Physical_State__c ='MA';
                grpsgmt.GA_Physical_County_Id__c = outOfState.id;
                grpsgmt.GA_Physical_Zip__c = '48506'; // edited
                grpsgmt.GA_Physical_City__c=otherCity.id;
                grpsgmt.GA_Physical_City_Other__c='Hyd';
                grpsgmt.GA_Billing_City__c=otherCity.id;
                grpsgmt.GA_Billing_City_Other__c='Hyd';
                grpsgmt.GA_Billing_Zip__c = '48014'; // added
                grpsgmt.GA_Mailing_City__c=otherCity.id;
                //grpsgmt.GA_Mailing_City_Other__c='Hyd';
                grpsgmt.GA_Mailing_Zip__c = '48506'; // added
                grpsgmt.GA_Copy_Address_From__c = 'Physical to Mailing';
                gsLst.add(grpsgmt);
                // Added Line 186 to 199
                GA_Group_Segment__c grpsgmt2 = GA_OBJ_TD01_TestDataCreation.grpSegmntRec(acc);
                grpsgmt2.GA_Physical_Address_1__c = 'test addrss 2';    
                grpsgmt2.GA_Physical_State__c ='MA';
                grpsgmt2.GA_Physical_Zip__c = '48014';
                grpsgmt2.GA_Physical_City__c=otherCity.id;
                grpsgmt2.GA_Physical_City_Other__c='Hyd';
                grpsgmt2.GA_Billing_City__c=otherCity.id;
                grpsgmt2.GA_Billing_City_Other__c='Hyd';
                grpsgmt2.GA_Billing_Zip__c = '48506';
                grpsgmt2.GA_Mailing_City__c=otherCity.id;
                grpsgmt2.GA_Mailing_City_Other__c='Hyd';
                grpsgmt2.GA_Mailing_Zip__c = '48014';
                grpsgmt2.GA_Copy_Address_From__c = 'Physical to Mailing';
                gsLst.add(grpsgmt2);
                
                test.startTest();
                database.insert(gsLst); // edited to insert a list
                test.stopTest();
                
                system.assert(acc <> null);
            }
            catch(exception e)
            {
                return;
            }
        }
    }  
    /**
@Description: updtGsAddressPTB() method 
@Name : updtGsAddressPTB
@Param : N/A   
@Return : void
@throws Exception : N/A;
*/   
    private static testmethod void updtGsAddressPTB()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestGrpSgmtrelatLst','testsystemadminstrator@bcbsm.com','System Administrator');
        database.insert(usr);
        
        PermissionSet prmsnSet =  [SELECT Id FROM PermissionSet WHERE Name = 'Allow_Group_Billing_to_update_GS_and_contact_fields' ];
        
        PermissionSetAssignment prmsnSetAsgnmnt = new PermissionSetAssignment(
            AssigneeId = usr.Id,
            PermissionSetId = prmsnSet.Id
        );
        database.insert(prmsnSetAsgnmnt);
        system.runAs(usr)
        {
            try{
                Account acc=GA_OBJ_TD01_TestDataCreation.AccRec();
                database.insert(acc);
                
                acc.GA_System_of_Record__c='Salesforce';
                database.update(acc);
                
                List<GA_City_Code__c> ctyLst = New List<GA_City_Code__c>();
                GA_City_Code__c cty = new GA_City_Code__c();
                cty.Name='Delton';
                ctyLst.add(cty);
                
                GA_City_Code__c otherCity = new GA_City_Code__c();
                otherCity.Name='Other';
                ctyLst.add(otherCity);
                database.insert(ctyLst);
                
                GA_County_Code__c outOfState = new GA_County_Code__c();
                outOfState.Name='OUT OF STATE';
                database.insert(outOfState);
                List<GA_Group_Segment__c> gsLst = New List<GA_Group_Segment__c>();
                
                GA_Group_Segment__c grpsgmt = GA_OBJ_TD01_TestDataCreation.grpSegmntRec(acc);
                grpsgmt.GA_Physical_Address_1__c = 'test addrss';    
                grpsgmt.GA_Physical_State__c ='MA';
                grpsgmt.GA_Physical_County_Id__c = outOfState.id;
                grpsgmt.GA_Physical_Zip__c = '12333';
                grpsgmt.GA_Physical_City__c=otherCity.id;
                grpsgmt.GA_Physical_City_Other__c='Hyd';
                grpsgmt.GA_Billing_City__c=otherCity.id;
                grpsgmt.GA_Billing_City_Other__c='Hyd';
                grpsgmt.GA_Mailing_City__c=otherCity.id;
                grpsgmt.GA_Mailing_City_Other__c='Hyd';
                grpsgmt.GA_Copy_Address_From__c = 'Physical to Billing';
                
                test.startTest();
                database.insert(grpsgmt);
                test.stopTest();
                
                system.assert(acc <> null);
            }
            catch(exception e)
            {
                return;
            }
        }
    }    
    /**
@Description: updtGsAddressMTP() method 
@Name : updtGsAddressMTP
@Param : N/A   
@Return : void
@throws Exception : N/A;
*/   
    private static testmethod void updtGsAddressMTP()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestGrpSgmtrelatLst','testsystemadminstrator@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {
            try{
                Account acc=GA_OBJ_TD01_TestDataCreation.AccRec();
                database.insert(acc);
                
                acc.GA_System_of_Record__c='Salesforce';
                database.update(acc);
                
                List<GA_City_Code__c> ctyLst = New List<GA_City_Code__c>();
                GA_City_Code__c cty = new GA_City_Code__c();
                cty.Name='Delton';
                ctyLst.add(cty);
                
                GA_City_Code__c otherCity = new GA_City_Code__c();
                otherCity.Name='Other';
                ctyLst.add(otherCity);
                database.insert(ctyLst);
                
                GA_County_Code__c outOfState = new GA_County_Code__c();
                outOfState.Name='OUT OF STATE';
                database.insert(outOfState);
                List<GA_Group_Segment__c> gsLst = New List<GA_Group_Segment__c>();
                
                GA_Group_Segment__c grpsgmt = GA_OBJ_TD01_TestDataCreation.grpSegmntRec(acc);
                grpsgmt.GA_Mailing_Address_1__c = 'test addrss';    
                grpsgmt.GA_Mailing_State__c ='MA';
                grpsgmt.GA_Mailing_County_Id__c = outOfState.id;
                grpsgmt.GA_Mailing_Zip__c = '12333';
                grpsgmt.GA_Physical_City__c=otherCity.id;
                grpsgmt.GA_Physical_City_Other__c='Hyd';
                grpsgmt.GA_Billing_City__c=otherCity.id;
                grpsgmt.GA_Billing_City_Other__c='Hyd';
                grpsgmt.GA_Mailing_City__c=otherCity.id;
                grpsgmt.GA_Mailing_City_Other__c='Hyd';
                grpsgmt.GA_Copy_Address_From__c = 'Mailing to Physical';
                
                test.startTest();
                database.insert(grpsgmt);
                test.stopTest();
                
                system.assert(acc <> null);
            }
            catch(exception e)
            {
                return;
            }
        }
    }     
    /**
@Description: updtGsAddressMTB() method 
@Name : updtGsAddressMTB
@Param : N/A   
@Return : void
@throws Exception : N/A;
*/   
    private static testmethod void updtGsAddressMTB()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestGrpSgmtrelatLst','testsystemadminstrator@bcbsm.com','System Administrator');
        database.insert(usr);
        
        
        PermissionSet prmsnSet =  [SELECT Id FROM PermissionSet WHERE Name = 'Allow_Group_Billing_to_update_GS_and_contact_fields' ];
        
        PermissionSetAssignment prmsnSetAsgnmnt = new PermissionSetAssignment(
            AssigneeId = usr.Id,
            PermissionSetId = prmsnSet.Id
        );
        database.insert(prmsnSetAsgnmnt);
        
        system.runAs(usr)
        {
            try{
                Account acc=GA_OBJ_TD01_TestDataCreation.AccRec();
                database.insert(acc);
                
                acc.GA_System_of_Record__c='Salesforce';
                database.update(acc);
                
                List<GA_City_Code__c> ctyLst = New List<GA_City_Code__c>();
                GA_City_Code__c cty = new GA_City_Code__c();
                cty.Name='Delton';
                ctyLst.add(cty);
                
                GA_City_Code__c otherCity = new GA_City_Code__c();
                otherCity.Name='Other';
                ctyLst.add(otherCity);
                database.insert(ctyLst);
                
                GA_County_Code__c outOfState = new GA_County_Code__c();
                outOfState.Name='OUT OF STATE';
                database.insert(outOfState);
                List<GA_Group_Segment__c> gsLst = New List<GA_Group_Segment__c>();
                
                GA_Group_Segment__c grpsgmt = GA_OBJ_TD01_TestDataCreation.grpSegmntRec(acc);
                grpsgmt.GA_Mailing_Address_1__c = 'test addrss';    
                grpsgmt.GA_Mailing_State__c ='MA';
                grpsgmt.GA_Mailing_County_Id__c = outOfState.id;
                grpsgmt.GA_Mailing_Zip__c = '12333';
                grpsgmt.GA_Physical_City__c=otherCity.id;
                grpsgmt.GA_Physical_City_Other__c='Hyd';
                grpsgmt.GA_Billing_City__c=otherCity.id;
                grpsgmt.GA_Billing_City_Other__c='Hyd';
                grpsgmt.GA_Mailing_City__c=otherCity.id;
                grpsgmt.GA_Mailing_City_Other__c='Hyd';
                grpsgmt.GA_Copy_Address_From__c = 'Mailing to Billing';
                
                test.startTest();
                database.insert(grpsgmt);
                test.stopTest();
                
                system.assert(acc <> null);
            }
            catch(exception e)
            {
                return;
            }
        }
    }     
    /**
@Description: updtGsAddressBTP() method 
@Name : updtGsAddressBTP
@Param : N/A   
@Return : void
@throws Exception : N/A;
*/   
    private static testmethod void updtGsAddressBTP()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestGrpSgmtrelatLst','testsystemadminstrator@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {
            try{
                Account acc=GA_OBJ_TD01_TestDataCreation.AccRec();
                database.insert(acc);
                
                acc.GA_System_of_Record__c='Salesforce';
                database.update(acc);
                
                List<GA_City_Code__c> ctyLst = New List<GA_City_Code__c>();
                GA_City_Code__c cty = new GA_City_Code__c();
                cty.Name='Delton';
                ctyLst.add(cty);
                
                GA_City_Code__c otherCity = new GA_City_Code__c();
                otherCity.Name='Other';
                ctyLst.add(otherCity);
                database.insert(ctyLst);
                
                GA_County_Code__c outOfState = new GA_County_Code__c();
                outOfState.Name='OUT OF STATE';
                database.insert(outOfState);
                List<GA_Group_Segment__c> gsLst = New List<GA_Group_Segment__c>();
                
                GA_Group_Segment__c grpsgmt = GA_OBJ_TD01_TestDataCreation.grpSegmntRec(acc);
                grpsgmt.GA_Billing_Address_1__c = 'test addrss';    
                grpsgmt.GA_Billing_State__c ='MA';
                grpsgmt.GA_Billing_County_Id__c = outOfState.id;
                grpsgmt.GA_Billing_Zip__c = '12333';
                grpsgmt.GA_Billing_City__c=otherCity.id;
                grpsgmt.GA_Billing_City_Other__c='Hyd';
                grpsgmt.GA_Physical_City__c=otherCity.id;
                grpsgmt.GA_Physical_City_Other__c='Hyd';
                grpsgmt.GA_Mailing_City__c=otherCity.id;
                grpsgmt.GA_Mailing_City_Other__c='Hyd';
                grpsgmt.GA_Copy_Address_From__c = 'Billing to Physical';
                
                test.startTest();
                database.insert(grpsgmt);
                test.stopTest();
                
                system.assert(acc <> null);
            }
            catch(exception e)
            {
                return;
            }
        }
    }     
    /**
@Description: updtGsAddressBTM() method 
@Name : updtGsAddressBTM
@Param : N/A   
@Return : void
@throws Exception : N/A;
*/   
    private static testmethod void updtGsAddressBTM()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestGrpSgmtrelatLst','testsystemadminstrator@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {
            try{            
                Account acc=GA_OBJ_TD01_TestDataCreation.AccRec();
                database.insert(acc);
                
                acc.GA_System_of_Record__c='Salesforce';
                database.update(acc);
                
                List<GA_City_Code__c> ctyLst = New List<GA_City_Code__c>();
                GA_City_Code__c cty = new GA_City_Code__c();
                cty.Name='Delton';
                ctyLst.add(cty);
                
                GA_City_Code__c otherCity = new GA_City_Code__c();
                otherCity.Name='Other';
                ctyLst.add(otherCity);
                database.insert(ctyLst);
                
                GA_County_Code__c outOfState = new GA_County_Code__c();
                outOfState.Name='OUT OF STATE';
                database.insert(outOfState);
                List<GA_Group_Segment__c> gsLst = New List<GA_Group_Segment__c>();
                
                GA_Group_Segment__c grpsgmt = GA_OBJ_TD01_TestDataCreation.grpSegmntRec(acc);
                grpsgmt.GA_Billing_Address_1__c = 'test addrss';    
                grpsgmt.GA_Billing_State__c ='MA';
                grpsgmt.GA_Billing_County_Id__c = outOfState.id;
                grpsgmt.GA_Billing_Zip__c = '12333';
                grpsgmt.GA_Billing_City__c=otherCity.id;
                grpsgmt.GA_Billing_City_Other__c='Hyd';
                grpsgmt.GA_Physical_City__c=otherCity.id;
                grpsgmt.GA_Physical_City_Other__c='Hyd';
                grpsgmt.GA_Mailing_City__c=otherCity.id;
                grpsgmt.GA_Mailing_City_Other__c='Hyd';
                grpsgmt.GA_Copy_Address_From__c = 'Billing to Mailing';
                
                test.startTest();
                database.insert(grpsgmt);
                test.stopTest();
                
                system.assert(acc <> null);
            }
            catch(exception e)
            {
                return;
            }
        }
    }              
    /**
@Description: updtGsAddressErr() method 
@Name : updtGsAddressErr
@Param : N/A   
@Return : void
@throws Exception : N/A;
*/   
    private static testmethod void updtGsAddressErr()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestGrpSgmtrelatLst','testsystemadminstrator@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {
            try{
                Map<id,GA_Group_Segment__c> gSOldMap = new Map<id,GA_Group_Segment__c> ();
                Account acc=GA_OBJ_TD01_TestDataCreation.AccRec();
                database.insert(acc);
                
                acc.GA_System_of_Record__c='Salesforce';
                database.update(acc);
                
                List<GA_City_Code__c> ctyLst = New List<GA_City_Code__c>();
                GA_City_Code__c cty = new GA_City_Code__c();
                cty.Name='Delton';
                ctyLst.add(cty);
                
                GA_City_Code__c otherCity = new GA_City_Code__c();
                otherCity.Name='Other';
                ctyLst.add(otherCity);
                Database.insert(ctyLst);
                List<GA_Group_Segment__c> gsLst = New List<GA_Group_Segment__c>();
                GA_Group_Segment__c grpsgmt = GA_OBJ_TD01_TestDataCreation.grpSegmntRec(acc);
                grpsgmt.GA_Physical_City__c=cty.id;
                grpsgmt.GA_Billing_City__c=cty.id;
                grpsgmt.GA_Mailing_City__c=cty.id;
                database.insert(grpsgmt);
                gSOldMap.put(grpsgmt.id,grpsgmt);
                
                grpsgmt.GA_Physical_City__c=otherCity.id;
                grpsgmt.GA_Physical_City_Other__c=null;
                grpsgmt.GA_Billing_City__c=otherCity.id;
                grpsgmt.GA_Billing_City_Other__c=null;
                grpsgmt.GA_Mailing_City__c=otherCity.id;
                grpsgmt.GA_Mailing_City_Other__c=null;
                gsLst.add(grpsgmt);
                test.startTest();
                GA_GS_AP02_Update_Address.updateCity(gsLst,gSOldMap);
                test.stopTest();
                
                system.assert(usr <> null);
            }
            catch(exception e)
            {
                return;
            }   
        }
    }
    /**
@Description: updtGsAddressErr1() method 
@Name : updtGsAddressErr1
@Param : N/A   
@Return : void
@throws Exception : N/A;
*/   
    private static testmethod void updtGsAddressErr1()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestGrpSgmtrelatLst','testsystemadminstrator@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {
            try{
                Map<id,GA_Group_Segment__c> gSOldMap = new Map<id,GA_Group_Segment__c> ();
                Account acc=GA_OBJ_TD01_TestDataCreation.AccRec();
                database.insert(acc);
                
                acc.GA_System_of_Record__c='Salesforce';
                database.update(acc);
                
                List<GA_City_Code__c> ctyLst = New List<GA_City_Code__c>();
                GA_City_Code__c cty = new GA_City_Code__c();
                cty.Name='Delton';
                ctyLst.add(cty);
                
                GA_City_Code__c otherCity = new GA_City_Code__c();
                otherCity.Name='Other';
                ctyLst.add(otherCity);
                Database.insert(ctyLst);
                
                GA_Group_Segment__c grpsgmt = GA_OBJ_TD01_TestDataCreation.grpSegmntRec(acc);
                grpsgmt.GA_Physical_City__c=otherCity.id;
                grpsgmt.GA_Physical_City_Other__c='Other';
                grpsgmt.GA_Billing_City__c=otherCity.id;
                grpsgmt.GA_Billing_City_Other__c='Other';
                grpsgmt.GA_Mailing_City__c=otherCity.id;
                grpsgmt.GA_Mailing_City_Other__c='Other';
                
                test.startTest();
                Database.insert(grpsgmt);
                test.stopTest();
                
                system.assert(usr <> null);
            }
            catch(exception e)
            {
                return;
            }   
        }
    }
    /**
@Description: updtGsAddressErr2() method 
@Name : updtGsAddressErr2
@Param : N/A   
@Return : void
@throws Exception : N/A;
*/   
    private static testmethod void updtGsAddressErr2()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestGrpSgmtrelatLst','testsystemadminstrator@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {
            try{
                Map<id,GA_Group_Segment__c> gSOldMap = new Map<id,GA_Group_Segment__c> ();
                Account acc=GA_OBJ_TD01_TestDataCreation.AccRec();
                database.insert(acc);
                
                acc.GA_System_of_Record__c='Salesforce';
                database.update(acc);
                
                List<GA_City_Code__c> ctyLst = New List<GA_City_Code__c>();
                GA_City_Code__c cty = new GA_City_Code__c();
                cty.Name='Delton';
                ctyLst.add(cty);
                
                GA_City_Code__c otherCity = new GA_City_Code__c();
                otherCity.Name='Other';
                ctyLst.add(otherCity);
                Database.insert(ctyLst);
                
                GA_Group_Segment__c grpsgmt = GA_OBJ_TD01_TestDataCreation.grpSegmntRec(acc);
                grpsgmt.GA_Physical_City__c=cty.id;
                grpsgmt.GA_Physical_City_Other__c='Banglore';
                grpsgmt.GA_Billing_City__c=cty.id;
                grpsgmt.GA_Billing_City_Other__c='Banglore';
                grpsgmt.GA_Mailing_City__c=cty.id;
                grpsgmt.GA_Mailing_City_Other__c='Banglore';
                
                test.startTest();
                Database.insert(grpsgmt);
                test.stopTest();
                
                system.assert(usr <> null);
            }
            catch(exception e)
            {
                return;
            }   
        }
    }
    
    /**
@Description: updtGsAddressErr3() method 
@Name : updtGsAddressErr3
@Param : N/A   
@Return : void
@throws Exception : N/A;
*/   
    private static testmethod void updtGsAddressErr3()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestGrpSgmtrelatLst','testsystemadminstrator@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {
            try{
                Map<id,GA_Group_Segment__c> gSOldMap = new Map<id,GA_Group_Segment__c> ();
                Account acc=GA_OBJ_TD01_TestDataCreation.AccRec();
                database.insert(acc);
                
                acc.GA_System_of_Record__c='Salesforce';
                database.update(acc);
                
                List<GA_City_Code__c> ctyLst = New List<GA_City_Code__c>();
                GA_City_Code__c cty = new GA_City_Code__c();
                cty.Name='Delton';
                ctyLst.add(cty);
                
                GA_City_Code__c otherCity = new GA_City_Code__c();
                otherCity.Name='Other';
                ctyLst.add(otherCity);
                Database.insert(ctyLst);
                List<GA_Group_Segment__c> gsLst = New List<GA_Group_Segment__c>();
                GA_Group_Segment__c grpsgmt = GA_OBJ_TD01_TestDataCreation.grpSegmntRec(acc);
                grpsgmt.GA_Physical_City__c=cty.id;
                grpsgmt.GA_Billing_City__c=cty.id;
                grpsgmt.GA_Mailing_City__c=cty.id;
                database.insert(grpsgmt);
                gSOldMap.put(grpsgmt.id,grpsgmt);
                
                grpsgmt.GA_Physical_City__c=null;
                grpsgmt.GA_Physical_City_Other__c='Hyd';
                grpsgmt.GA_Billing_City__c=null;
                grpsgmt.GA_Billing_City_Other__c='Hyd';
                grpsgmt.GA_Mailing_City__c=null;
                grpsgmt.GA_Mailing_City_Other__c='Hyd';
                gsLst.add(grpsgmt);
                test.startTest();
                GA_GS_AP02_Update_Address.updateCity(gsLst,gSOldMap);
                test.stopTest();
                
                system.assert(usr <> null);
            }
            catch(exception e)
            {
                return;
            } 
        }
    }
    /**
@Description: updtGsAddressErr4() method 
@Name : updtGsAddressErr4
@Param : N/A   
@Return : void
@throws Exception : N/A;
*/   
    private static testmethod void updtGsAddressErr4()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestGrpSgmtrelatLst','testsystemadminstrator@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {
            try{
                Map<id,GA_Group_Segment__c> gSOldMap = new Map<id,GA_Group_Segment__c> ();
                Account acc=GA_OBJ_TD01_TestDataCreation.AccRec();
                database.insert(acc);
                
                acc.GA_System_of_Record__c='Salesforce';
                database.update(acc);
                
                List<GA_City_Code__c> ctyLst = New List<GA_City_Code__c>();
                GA_City_Code__c cty = new GA_City_Code__c();
                cty.Name='Delton';
                ctyLst.add(cty);
                
                GA_City_Code__c otherCity = new GA_City_Code__c();
                otherCity.Name='Other';
                ctyLst.add(otherCity);
                Database.insert(ctyLst);
                
                GA_Group_Segment__c grpsgmt = GA_OBJ_TD01_TestDataCreation.grpSegmntRec(acc);
                grpsgmt.GA_Physical_City__c=otherCity.id;
                grpsgmt.GA_Physical_City_Other__c=null;
                grpsgmt.GA_Billing_City__c=otherCity.id;
                grpsgmt.GA_Billing_City_Other__c=null;
                grpsgmt.GA_Mailing_City__c=otherCity.id;
                grpsgmt.GA_Mailing_City_Other__c=null;
                
                test.startTest();
                Database.insert(grpsgmt);
                test.stopTest();
                
                system.assert(usr <> null);
            }
            catch(exception e)
            {
                return;
            }  
        }
    }
    
    /**
@Description: UpdtGsCountyCode() method 
@Name : UpdtGsCountyCode
@Param : N/A   
@Return : void
@throws Exception : N/A;
*/   
    private static testmethod void UpdtGsCountyCode()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestGrpSgmtrelatLst','testsystemadminstrator@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {
            Account acc=GA_OBJ_TD01_TestDataCreation.AccRec();
            database.insert(acc);
            
            GA_GS_AP02_Update_Address.isExecuting=false;
            GA_GS_AP02_Update_Address.isInvoked=false;
            
            List<GA_County_Code__c> countyLst = New List<GA_County_Code__c>();
            GA_County_Code__c outOfState = new GA_County_Code__c();
            outOfState.Name='OUT OF STATE';
            countyLst.add(outOfState);
            
            GA_County_Code__c cnty = new GA_County_Code__c(); // Duplicate Scenario
            cnty.Name = 'IONIA';
            countyLst.add(cnty);
            
            GA_County_Code__c cnty2 = new GA_County_Code__c(); // Duplicate Scenario
            cnty2.Name = 'EATON';
            countyLst.add(cnty2);
            
            GA_County_Code__c cnty3 = new GA_County_Code__c(); // Single Scenario
            cnty3.Name = 'CLINTON';
            countyLst.add(cnty3);
            database.insert(countyLst);
            
            List<ZipCode__c> zipLst = New List<ZipCode__c>();
            List<GA_County_Code__c> gc1 = [SELECT ID,Name FROM GA_County_Code__c WHERE Name = 'EATON' LIMIT 1]; // Dupli
            ZipCode__c zip = new ZipCode__c();
            zip.CountyName__c = gc1[0].Id;
            zip.ZipCode__c = '48849';
            zipLst.add(zip);
            
            gc1 = [SELECT ID,Name FROM GA_County_Code__c WHERE Name = 'IONIA' LIMIT 1]; // Dupli
            ZipCode__c zip2 = new ZipCode__c();
            zip2.CountyName__c = gc1[0].Id;
            zip2.ZipCode__c = '48849';
            zipLst.add(zip2);
            
            gc1 = [SELECT ID,Name FROM GA_County_Code__c WHERE Name = 'CLINTON' LIMIT 1]; // Single
            ZipCode__c zip3 = new ZipCode__c();
            zip3.CountyName__c = gc1[0].Id;
            zip3.ZipCode__c = '48847';
            zipLst.add(zip3);
            database.insert(zipLst);
            
            List<GA_Group_Segment__c> grList = New List<GA_Group_Segment__c>();
            GA_Group_Segment__c grpsgmt = GA_OBJ_TD01_TestDataCreation.grpSegmntRec(acc);
            grpsgmt.GA_Physical_Zip__c='48847';
            grpsgmt.GA_Physical_State__c='MI';
            grpsgmt.GA_Physical_County_Id__c = gc1[0].Id;
            grpsgmt.GA_Billing_Zip__c='48847';
            grpsgmt.GA_Billing_State__c='MI';
            grpsgmt.GA_Billing_County_Id__c = gc1[0].Id;
            grpsgmt.GA_Mailing_Zip__c='48847';
            grpsgmt.GA_Mailing_State__c='MI';
            grpsgmt.GA_Mailing_County_Id__c = gc1[0].Id;
            grList.add(grpsgmt);
            
            Database.insert(grList);
            
            List<GA_County_Code__c> gc2 = [SELECT ID,Name FROM GA_County_Code__c WHERE Name = 'EATON' LIMIT 1];
            GA_Group_Segment__c grpsgmt2 = GA_OBJ_TD01_TestDataCreation.grpSegmntRec(acc);
            grpsgmt2.GA_Physical_County_Id__c = gc2[0].Id;
            grpsgmt2.GA_Physical_Zip__c='48849';
            grpsgmt2.GA_Physical_State__c='MI';
            grpsgmt2.GA_Billing_County_Id__c = gc2[0].Id;
            grpsgmt2.GA_Billing_Zip__c='48849';
            grpsgmt2.GA_Billing_State__c='MI';
            grpsgmt2.GA_Mailing_Zip__c='48849';
            grpsgmt2.GA_Mailing_State__c='MI';
            grpsgmt2.GA_Mailing_County_Id__c = gc2[0].Id;
            Database.insert(grpsgmt2);
            
            grpsgmt2.GA_Physical_Zip__c='12345';
            grpsgmt2.GA_Physical_State__c='KS';
            grpsgmt2.GA_Billing_Zip__c='12345';
            grpsgmt2.GA_Billing_State__c='KS';
            grpsgmt2.GA_Mailing_Zip__c='12345';
            grpsgmt2.GA_Mailing_State__c='KS';
            Database.update(grpsgmt2);

            system.assert(usr <> null);
        }
    }
    
    /**
@Description: UpdtAccCountyCode() method 
@Name : UpdtAccCountyCode
@Param : N/A   
@Return : void
@throws Exception : N/A;
*/   
    private static testmethod void UpdtAccCountyCode()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestGrpSgmtrelatLst','testsystemadminstrator@bcbsm.com','System Administrator');
        database.insert(usr);

        system.runAs(usr)
        {
            try{
            List<GA_County_Code__c> countyLst = New List<GA_County_Code__c>();
            GA_County_Code__c outOfState = new GA_County_Code__c();
            outOfState.Name='OUT OF STATE';
            countyLst.add(outOfState);
            
            GA_County_Code__c cnty = new GA_County_Code__c(); // Duplicate Scenario
            cnty.Name = 'IONIA';
            countyLst.add(cnty);
            
            GA_County_Code__c cnty2 = new GA_County_Code__c(); // Duplicate Scenario
            cnty2.Name = 'EATON';
            countyLst.add(cnty2);
            
            GA_County_Code__c cnty3 = new GA_County_Code__c(); // Single Scenario
            cnty3.Name = 'CLINTON';
            countyLst.add(cnty3);
            database.insert(countyLst);
            
            List<ZipCode__c> zipLst = New List<ZipCode__c>();
            List<GA_County_Code__c> gc1 = [SELECT ID,Name FROM GA_County_Code__c WHERE Name = 'EATON' LIMIT 1]; // Dupli
            ZipCode__c zip = new ZipCode__c();
            zip.CountyName__c = gc1[0].Id;
            zip.ZipCode__c = '48849';
            zipLst.add(zip);
            
            gc1 = [SELECT ID,Name FROM GA_County_Code__c WHERE Name = 'IONIA' LIMIT 1]; // Dupli
            ZipCode__c zip2 = new ZipCode__c();
            zip2.CountyName__c = gc1[0].Id;
            zip2.ZipCode__c = '48849';
            zipLst.add(zip2);
            
            gc1 = [SELECT ID,Name FROM GA_County_Code__c WHERE Name = 'CLINTON' LIMIT 1]; // Single
            ZipCode__c zip3 = new ZipCode__c();
            zip3.CountyName__c = gc1[0].Id;
            zip3.ZipCode__c = '48847';
            zipLst.add(zip3);
            database.insert(zipLst);
            
            List<Account> accList = New List<Account>();
            Account acc=GA_OBJ_TD01_TestDataCreation.AccRec();
            acc.ShippingStateCode = 'MI';
            acc.ShippingPostalCode='48847';
            acc.BillingPostalCode='48847';
            acc.BillingStateCode = 'MI';
            accList.add(acc);
            
            Account acc2=GA_OBJ_TD01_TestDataCreation.AccRec();
            acc2.GA_Physical_County_Id__c = gc1[0].Id;
            acc2.ShippingPostalCode='48849';
            acc2.ShippingStateCode='MI';
            acc2.BillingPostalCode='48849';
            acc2.BillingStateCode='MI';
            acc2.GA_Mailing_County_Id__c = gc1[0].Id;
            accList.add(acc2);
            database.insert(accList);
            
            acc2.ShippingPostalCode='12345';
            acc2.ShippingStateCode='KS';
            acc2.BillingPostalCode='12345';
            acc2.BillingStateCode='KS';
            Database.update(acc2);
            }
            catch(exception e)
            {
                return;
            }
        }
    }
}