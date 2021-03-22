/*
@Author : Sri Lakshmi Addula
@Name: GA_AP_SendGSNotificationCls_Test 
@CreatedDate: 15 - Nov 2018 
@Description: GA_AP_SendGSNotificationCls Test class
@version : 1.0  
*/
@isTest
private  class GA_AP_SendGSNotificationCls_Test {
/**
@Description: ASEPGrpSgmtSendNtfctns() method 
@Name : ASEPGrpSgmtSendNtfctns
@Param : N/A   
@Return : void
@throws Exception : N/A;
*/   
    private static testmethod void ASEPGrpSgmtSendNtfctns()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestGrpSgmtrelatLst','testsystemadminstrator@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {
            try {
                Account acc=GA_OBJ_TD01_TestDataCreation.AccRec();
                database.insert(acc);
                system.debug('acc debug'+acc);
                acc.GA_System_of_Record__c='Salesforce';
                database.update(acc);
                GA_Group_Segment__c gs = GA_OBJ_TD01_TestDataCreation.grpSegmntRec(acc);
                database.insert(gs);
                system.debug('grp sgment debug'+gs);
                gs.Name='Test';
                gs.GA_Post_Transaction__c=True;
                gs.Status__c='Pending';
                gs.GA_Transaction_Posted__c=True;
                gs.GA_PostGrpNots__c='Notes';
                gs.GA_SourceASG__c=True;
                database.update(gs);
                GA_Trigger_Functionality_By_Pass__c tcs =new GA_Trigger_Functionality_By_Pass__c();
                tcs.GA_Send_GS_Notfication__c = True;
                tcs.SetupOwnerId=usr.ProfileId;
                insert tcs;
                test.startTest();
                GA_AP_SendGSNotificationCls.sendNotification(gs.Id);
                GA_AP_SendGSNotificationCls.sendNotificationToUsers(gs.Id,gs.GA_PostGrpNots__c);
                test.stopTest();
            }
            catch(exception e)
            {
                return;
            }
    }
}
    /**
@Description: NonPendingASEPGrpSgmtSendNtfctns() method 
@Name : NonPendingASEPGrpSgmtSendNtfctns
@Param : N/A   
@Return : void
@throws Exception : N/A;
*/   
    private static testmethod void NonPendingASEPGrpSgmtSendNtfctns()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestGrpSgmtrelatLst','testsystemadminstrator@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {
            try {
                Account acc=GA_OBJ_TD01_TestDataCreation.AccRec();
                database.insert(acc);
                system.debug('acc debug'+acc);
                acc.GA_System_of_Record__c='Salesforce';
                database.update(acc);
                GA_Group_Segment__c gs = GA_OBJ_TD01_TestDataCreation.grpSegmntRec(acc);
                database.insert(gs);
                system.debug('grp sgment debug'+gs);
                gs.Name='Test';
                gs.GA_Post_Transaction__c=True;
                gs.Status__c='Active';
                gs.GA_Transaction_Posted__c=True;
                gs.GA_PostGrpNots__c='Notes';
                gs.GA_SourceASG__c=True;
                database.update(gs);
                GA_Trigger_Functionality_By_Pass__c tcs =new GA_Trigger_Functionality_By_Pass__c();
                tcs.GA_Send_GS_Notfication__c = True;
                tcs.SetupOwnerId=usr.ProfileId;
                insert tcs;
                test.startTest();
                GA_AP_SendGSNotificationCls.sendNotification(gs.Id);
                GA_AP_SendGSNotificationCls.sendNotificationToUsers(gs.Id,gs.GA_PostGrpNots__c);
                test.stopTest();
            }
            catch(exception e)
            {
                return;
            }
    }
}
    /**
@Description: NonASEPGrpSgmtSendNtfctns() method 
@Name : NonASEPGrpSgmtSendNtfctns
@Param : N/A   
@Return : void
@throws Exception : N/A;
*/   
    private static testmethod void NonASEPGrpSgmtSendNtfctns()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestGrpSgmtrelatLst','testsystemadminstrator@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {
            try {
                Account acc=GA_OBJ_TD01_TestDataCreation.AccRec();
                database.insert(acc);
                system.debug('acc debug'+acc);
                acc.GA_System_of_Record__c='Salesforce';
                database.update(acc);
                GA_Group_Segment__c gs = GA_OBJ_TD01_TestDataCreation.grpSegmntRec(acc);
                database.insert(gs);
                system.debug('grp sgment debug'+gs);
                gs.Name='Test';
                gs.GA_Post_Transaction__c=True;
                gs.Status__c='Pending';
                gs.GA_Transaction_Posted__c=True;
                gs.GA_PostGrpNots__c='Notes';
                gs.GA_SourceASG__c=False;
                database.update(gs);
                GA_Trigger_Functionality_By_Pass__c tcs =new GA_Trigger_Functionality_By_Pass__c();
                tcs.GA_Send_GS_Notfication__c = True;
                tcs.SetupOwnerId=usr.ProfileId;
                insert tcs;
                test.startTest();
                GA_AP_SendGSNotificationCls.sendNotification(gs.Id);
                GA_AP_SendGSNotificationCls.sendNotificationToUsers(gs.Id,gs.GA_PostGrpNots__c);
                test.stopTest();
            }
            catch(exception e)
            {
                return;
            }
    }
}
    /**
@Description: SMARTASEPGrpSgmtSendNtfctns() method 
@Name : SMARTASEPGrpSgmtSendNtfctns
@Param : N/A   
@Return : void
@throws Exception : N/A;
*/   
    private static testmethod void SMARTASEPGrpSgmtSendNtfctns()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestGrpSgmtrelatLst','testsystemadminstrator@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {
            try {
                Account acc=GA_OBJ_TD01_TestDataCreation.AccRec();
                database.insert(acc);
                system.debug('acc debug'+acc);
                acc.GA_System_of_Record__c='SMART';
                database.update(acc);
                GA_Group_Segment__c gs = GA_OBJ_TD01_TestDataCreation.grpSegmntRec(acc);
                database.insert(gs);
                system.debug('grp sgment debug'+gs);
                gs.Name='Test';
                gs.GA_Post_Transaction__c=True;
                gs.Status__c='Pending';
                gs.GA_Transaction_Posted__c=True;
                gs.GA_PostGrpNots__c='Notes';
                gs.GA_SourceASG__c=False;
                database.update(gs);
                GA_Trigger_Functionality_By_Pass__c tcs =new GA_Trigger_Functionality_By_Pass__c();
                tcs.GA_Send_GS_Notfication__c = True;
                tcs.SetupOwnerId=usr.ProfileId;
                insert tcs;
                test.startTest();
                GA_AP_SendGSNotificationCls.sendNotification(gs.Id);
                GA_AP_SendGSNotificationCls.sendNotificationToUsers(gs.Id,gs.GA_PostGrpNots__c);
                test.stopTest();
            }
            catch(exception e)
            {
                return;
            }
    }
}
    /**
@Description: InsufPrvASEPGrpSgmtSendNtfctns() method 
@Name : InsufPrvASEPGrpSgmtSendNtfctns
@Param : N/A   
@Return : void
@throws Exception : N/A;
*/   
    private static testmethod void InsufPrvASEPGrpSgmtSendNtfctns()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestGrpSgmtrelatLst','testsystemadminstrator@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {
            try {
                Account acc=GA_OBJ_TD01_TestDataCreation.AccRec();
                database.insert(acc);
                system.debug('acc debug'+acc);
                acc.GA_System_of_Record__c='Salesforce';
                database.update(acc);
                GA_Group_Segment__c gs = GA_OBJ_TD01_TestDataCreation.grpSegmntRec(acc);
                database.insert(gs);
                system.debug('grp sgment debug'+gs);
                gs.Name='Test';
                gs.GA_Post_Transaction__c=True;
                gs.Status__c='Pending';
                gs.GA_Transaction_Posted__c=True;
                gs.GA_PostGrpNots__c='Notes';
                gs.GA_SourceASG__c=False;
                database.update(gs);
                
                test.startTest();
                GA_AP_SendGSNotificationCls.sendNotification(gs.Id);
                GA_AP_SendGSNotificationCls.sendNotificationToUsers(gs.Id,gs.GA_PostGrpNots__c);
                test.stopTest();
            }
            catch(exception e)
            {
                return;
            }
    }
}
}