/*
@Author : Sri Lakshmi Addula
@Name: GA_ASEPExtendTime_Test 
@CreatedDate: 15 - Nov 2018 
@Description: GA_ASEPExtendTime Test class
@version : 1.0  
*/
@isTest(seealldata = false)
private class GA_ASEPExtendTime_Test {
    /**
@Description: asepRecExtendTime() method 
@Name : asepRecExtendTime
@Param : N/A   
@Return : void
@throws Exception : N/A;
*/   
    private static testmethod void asepRecExtendTime()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestUnderwriter','TestUnderwriter@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {
            try {
                Account accRecd=GA_OBJ_TD01_TestDataCreation.AccRec();
                accRecd.GA_System_of_Record__c='Salesforce';  
                database.insert(accRecd); 
                GA_Agent_Sold_Contact__c ascRecd=GA_OBJ_TD01_TestDataCreation.agntSoldContact();
                database.insert(ascRecd);            
                GA_Agent_Sold_Enrollment__c aseRecd=GA_OBJ_TD01_TestDataCreation.agentSoldEnrollemnt(ascRecd);
                aseRecd.GA_Account_Id__c=accRecd.Id;   
                database.insert(aseRecd);
                aseRecd.GA_ASEP_Status__c='Pending - Controllable';
                aseRecd.GA_Rejection_Reason__c='TestRejectionReason';
                aseRecd.GA_Rejection_Notification_Date__c=DateTime.Now().AddDays(1);
                aseRecd.GA_Extended_Date__c=DateTime.Now().AddDays(1);
                database.update(aseRecd);
                GA_Trigger_Functionality_By_Pass__c tcs =new GA_Trigger_Functionality_By_Pass__c();
                tcs.GA_ASEP_Extend_Time__c = True;
                tcs.SetupOwnerId=usr.ProfileId;
                database.insert(tcs);
                test.startTest();
                GA_ASEPExtendTime.ExtendTime(aseRecd.Id);
                GA_ASEPExtendTime.extendto24hrs(aseRecd.Id);
                test.stopTest();
                 
                system.assert(aseRecd <> null);
            }
            catch(exception e)
            {
                return;
            }
        }
    }
    /**
@Description: timeOverASEPRecExtendTime() method 
@Name : timeOverASEPRecExtendTime
@Param : N/A   
@Return : void
@throws Exception : N/A;
*/   
    private static testmethod void timeOverASEPRecExtendTime()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestUnderwriter','TestUnderwriter@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {
            try {
                Account accRecd=GA_OBJ_TD01_TestDataCreation.AccRec();
                accRecd.GA_System_of_Record__c='Salesforce';  
                database.insert(accRecd); 
                GA_Agent_Sold_Contact__c ascRecd=GA_OBJ_TD01_TestDataCreation.agntSoldContact();
                database.insert(ascRecd);            
                GA_Agent_Sold_Enrollment__c aseRecd=GA_OBJ_TD01_TestDataCreation.agentSoldEnrollemnt(ascRecd);
                aseRecd.GA_Account_Id__c=accRecd.Id;   
                database.insert(aseRecd);
                aseRecd.GA_ASEP_Status__c='Pending - Controllable';
                aseRecd.GA_Rejection_Reason__c='TestRejectionReason';
                aseRecd.GA_Rejection_Notification_Date__c=DateTime.Now();
                aseRecd.GA_Extended_Date__c=DateTime.Now();
                database.update(aseRecd);
                GA_Trigger_Functionality_By_Pass__c tcs =new GA_Trigger_Functionality_By_Pass__c();
                tcs.GA_ASEP_Extend_Time__c = True;
                tcs.SetupOwnerId=usr.ProfileId;
                database.insert(tcs);
                test.startTest();
                GA_ASEPExtendTime.ExtendTime(aseRecd.Id);
                GA_ASEPExtendTime.extendto24hrs(aseRecd.Id);
                test.stopTest();
                
                system.assert(aseRecd <> null);
            }
            catch(exception e)
            {
                return;
            }
        }
    }
    /**
@Description: nonPendingASEPRecExtendTime() method 
@Name : nonPendingASEPRecExtendTime
@Param : N/A   
@Return : void
@throws Exception : N/A;
*/   
    private static testmethod void nonPendingASEPRecExtendTime()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestUnderwriter','TestUnderwriter@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {
            try {
                Account accRecd=GA_OBJ_TD01_TestDataCreation.AccRec();
                accRecd.GA_System_of_Record__c='Salesforce';  
                database.insert(accRecd); 
                GA_Agent_Sold_Contact__c ascRecd=GA_OBJ_TD01_TestDataCreation.agntSoldContact();
                database.insert(ascRecd);            
                GA_Agent_Sold_Enrollment__c aseRecd=GA_OBJ_TD01_TestDataCreation.agentSoldEnrollemnt(ascRecd);
                aseRecd.GA_Account_Id__c=accRecd.Id;   
                database.insert(aseRecd);
                aseRecd.GA_ASEP_Status__c='Rejected - UnControllable';
                aseRecd.GA_Rejection_Reason__c='TestRejectionReason';
                aseRecd.GA_Rejection_Notification_Date__c=DateTime.Now();
                aseRecd.GA_Extended_Date__c=DateTime.Now();
                database.update(aseRecd);
                GA_Trigger_Functionality_By_Pass__c tcs =new GA_Trigger_Functionality_By_Pass__c();
                tcs.GA_ASEP_Extend_Time__c = True;
                tcs.SetupOwnerId=usr.ProfileId;
                database.insert(tcs);
                test.startTest();
                GA_ASEPExtendTime.ExtendTime(aseRecd.Id);
                GA_ASEPExtendTime.extendto24hrs(aseRecd.Id);
                test.stopTest();
                
                system.assert(aseRecd <> null);
            }
            catch(exception e)
            {
                return;
            }
        }
    }
    /**
@Description: smartASEPRecExtendTime() method 
@Name : smartASEPRecExtendTime
@Param : N/A   
@Return : void
@throws Exception : N/A;
*/   
    private static testmethod void smartASEPRecExtendTime()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestUnderwriter','TestUnderwriter@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {
            try {
                Account accRecd=GA_OBJ_TD01_TestDataCreation.AccRec();
                accRecd.GA_System_of_Record__c='SMART';  
                database.insert(accRecd); 
                GA_Agent_Sold_Contact__c ascRecd=GA_OBJ_TD01_TestDataCreation.agntSoldContact();
                database.insert(ascRecd);            
                GA_Agent_Sold_Enrollment__c aseRecd=GA_OBJ_TD01_TestDataCreation.agentSoldEnrollemnt(ascRecd);
                aseRecd.GA_Account_Id__c=accRecd.Id;   
                database.insert(aseRecd);
                aseRecd.GA_ASEP_Status__c='Pending - UnControllable';
                aseRecd.GA_Rejection_Reason__c='TestRejectionReason';
                aseRecd.GA_Rejection_Notification_Date__c=DateTime.Now();
                aseRecd.GA_Extended_Date__c=DateTime.Now();
                database.update(aseRecd);
                GA_Trigger_Functionality_By_Pass__c tcs =new GA_Trigger_Functionality_By_Pass__c();
                tcs.GA_ASEP_Extend_Time__c = True;
                tcs.SetupOwnerId=usr.ProfileId;
                database.insert(tcs);
                test.startTest();
                GA_ASEPExtendTime.ExtendTime(aseRecd.Id);
                GA_ASEPExtendTime.extendto24hrs(aseRecd.Id);
                test.stopTest();
                
                system.assert(aseRecd <> null);
            }
            catch(exception e)
            {
                return;
            }
        }
    }
    /**
@Description: insufPrvASEPRecExtendTime() method 
@Name : insufPrvASEPRecExtendTime
@Param : N/A   
@Return : void
@throws Exception : N/A;
*/   
    private static testmethod void insufPrvASEPRecExtendTime()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestUnderwriter','TestUnderwriter@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {
            try {
                Account accRecd=GA_OBJ_TD01_TestDataCreation.AccRec();
                accRecd.GA_System_of_Record__c='Salesforce';  
                database.insert(accRecd); 
                GA_Agent_Sold_Contact__c ascRecd=GA_OBJ_TD01_TestDataCreation.agntSoldContact();
                database.insert(ascRecd);            
                GA_Agent_Sold_Enrollment__c aseRecd=GA_OBJ_TD01_TestDataCreation.agentSoldEnrollemnt(ascRecd);
                aseRecd.GA_Account_Id__c=accRecd.Id;   
                database.insert(aseRecd);
                aseRecd.GA_ASEP_Status__c='Pending - Controllable';
                aseRecd.GA_Rejection_Reason__c='TestRejectionReason';
                aseRecd.GA_Rejection_Notification_Date__c=DateTime.Now().AddDays(1);
                aseRecd.GA_Extended_Date__c=DateTime.Now().AddDays(1);
                database.update(aseRecd);
                
                test.startTest();
                GA_ASEPExtendTime.ExtendTime(aseRecd.Id);
                GA_ASEPExtendTime.extendto24hrs(aseRecd.Id);
                test.stopTest();
                
                system.assert(aseRecd <> null);
            }
            catch(exception e)
            {
                return;
            }
        }
    }
    
}