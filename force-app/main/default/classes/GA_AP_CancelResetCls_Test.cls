/*
@Author : Sri Lakshmi Addula
@Name: GA_AP_CancelResetCls_Test 
@CreatedDate: 15 - Nov 2018 
@Description: GA_AP_CancelResetCls Test class
@version : 1.0  
*/
@isTest
private class GA_AP_CancelResetCls_Test {
    /**
@Description: ASEPGrpSgmtCnclReset() method 
@Name : ASEPGrpSgmtCnclReset
@Param : N/A   
@Return : void
@throws Exception : N/A;
*/   
    private static testmethod void ASEPGrpSgmtCnclReset()
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
                tcs.GA_Reset_Group_Segments__c = True;
                tcs.SetupOwnerId=usr.ProfileId;
                insert tcs;
                test.startTest();
                GA_AP_CancelResetCls.resetGrpSgmnts(gs.Id);
                GA_AP_CancelResetCls.cnclResetSgmnts(gs.Id);
                GA_AP_CancelResetCls.sendNotificationToUsers(gs.Id,gs.GA_PostGrpNots__c);
                test.stopTest();
            }
            catch(exception e)
            {
                return;
            }
        }
    }
  /**
@Description: NonPendingASEPGrpSgmtCnclReset() method 
@Name : NonPendingASEPGrpSgmtCnclReset
@Param : N/A   
@Return : void
@throws Exception : N/A;
*/   
    private static testmethod void NonPendingASEPGrpSgmtCnclReset()
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
                tcs.GA_Reset_Group_Segments__c = True;
                tcs.SetupOwnerId=usr.ProfileId;
                insert tcs;
                test.startTest();
                GA_AP_CancelResetCls.resetGrpSgmnts(gs.Id);
                GA_AP_CancelResetCls.cnclResetSgmnts(gs.Id);
                GA_AP_CancelResetCls.sendNotificationToUsers(gs.Id,gs.GA_PostGrpNots__c);
                test.stopTest();
            }
            catch(exception e)
            {
                return;
            }
        }
    }
      /**
@Description: NonASEPGrpSgmtCnclReset() method 
@Name : NonASEPGrpSgmtCnclReset
@Param : N/A   
@Return : void
@throws Exception : N/A;
*/   
    private static testmethod void NonASEPGrpSgmtCnclReset()
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
                gs.GA_SourceASG__c=False;
                database.update(gs);
                GA_Trigger_Functionality_By_Pass__c tcs =new GA_Trigger_Functionality_By_Pass__c();
                tcs.GA_Reset_Group_Segments__c = True;
                tcs.SetupOwnerId=usr.ProfileId;
                insert tcs;
                test.startTest();
                GA_AP_CancelResetCls.resetGrpSgmnts(gs.Id);
                GA_AP_CancelResetCls.cnclResetSgmnts(gs.Id);
                GA_AP_CancelResetCls.sendNotificationToUsers(gs.Id,gs.GA_PostGrpNots__c);
                test.stopTest();
            }
            catch(exception e)
            {
                return;
            }
        }
    }
       /**
@Description: SMARTASEPGrpSgmtCnclReset() method 
@Name : SMARTASEPGrpSgmtCnclReset
@Param : N/A   
@Return : void
@throws Exception : N/A;
*/   
    private static testmethod void SMARTASEPGrpSgmtCnclReset()
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
                gs.Status__c='Active';
                gs.GA_Transaction_Posted__c=True;
                gs.GA_PostGrpNots__c='Notes';
                gs.GA_SourceASG__c=False;
                database.update(gs);
                GA_Trigger_Functionality_By_Pass__c tcs =new GA_Trigger_Functionality_By_Pass__c();
                tcs.GA_Reset_Group_Segments__c = True;
                tcs.SetupOwnerId=usr.ProfileId;
                insert tcs;
                test.startTest();
                GA_AP_CancelResetCls.resetGrpSgmnts(gs.Id);
                GA_AP_CancelResetCls.cnclResetSgmnts(gs.Id);
                GA_AP_CancelResetCls.sendNotificationToUsers(gs.Id,gs.GA_PostGrpNots__c);
                test.stopTest();
            }
            catch(exception e)
            {
                return;
            }
        }
    }
   /**
@Description: InsufPrvGrpSgmtCnclReset() method 
@Name : InsufPrvGrpSgmtCnclReset
@Param : N/A   
@Return : void
@throws Exception : N/A;
*/   
    private static testmethod void InsufPrvGrpSgmtCnclReset()
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
               
                test.startTest();
                GA_AP_CancelResetCls.resetGrpSgmnts(gs.Id);
                GA_AP_CancelResetCls.cnclResetSgmnts(gs.Id);
                GA_AP_CancelResetCls.sendNotificationToUsers(gs.Id,gs.GA_PostGrpNots__c);
                test.stopTest();
            }
            catch(exception e)
            {
                return;
            }
        }
    }  
    
     /**
@Description: CtchGrpSgmtCnclReset() method 
@Name : CtchGrpSgmtCnclReset
@Param : N/A   
@Return : void
@throws Exception : N/A;
*/   
    private static testmethod void CtchGrpSgmtCnclReset()
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
                tcs.GA_Reset_Group_Segments__c = True;
                tcs.SetupOwnerId=usr.ProfileId;
                insert tcs;
                test.startTest();
                GA_AP_CancelResetCls.resetGrpSgmnts(null);
                GA_AP_CancelResetCls.cnclResetSgmnts(null);
                GA_AP_CancelResetCls.sendNotificationToUsers(null,gs.GA_PostGrpNots__c);
                test.stopTest();
            }
            catch(exception e)
            {
                return;
            }
        }
    }
}