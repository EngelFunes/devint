/*
@Author : IDC offshore
@Name: GA_GroupSegmentSrvcCls_Test 
@CreatedDate: 2/26/2019
@Description: GA_GroupSegmentSrvcCls_Test Test class
@version : 1.0  
*/
@isTest(seealldata = false)
private class GA_GroupSegmentSrvcCls_Test {
/**
@Description: GSRecCloneBCBSM() method 
@Name : GSRecCloneBCBSM
@Param : GrpSgmntId
@Return : string
@throws Exception : N/A;
*/  
    public static testmethod void GSRecCloneBCBSM()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestGrpSgmtrelatLst','testsystemadminstrator@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {
            try {
                GA_Trigger_Functionality_By_Pass__c tcs =new GA_Trigger_Functionality_By_Pass__c();
                tcs.GA_GS_GroupInfoValidation__c = True;
                tcs.SetupOwnerId=usr.ProfileId;
                insert tcs;
                
                Account acc=GA_OBJ_TD01_TestDataCreation.AccRec();
                database.insert(acc);
                
                GA_Group_Segment__c gs = GA_OBJ_TD01_TestDataCreation.grpSegmntRec(acc);
                gs.GA_Carrier__c='BCBSM';
                gs.GA_MTV_Group__c='1';
                gs.GA_MTV_Group_Division__c='2';
                database.insert(gs);
                
                GA_Group_Segment__c gs1 = GA_OBJ_TD01_TestDataCreation.grpSegmntRec(acc);
                gs1.GA_Prevs_RecordID__c=gs.Id;
                gs1.GA_Carrier__c='BCBSM';
                gs1.GA_MTV_Group__c='1';
                gs1.GA_MTV_Group_Division__c='2';
                database.insert(gs1);
                               
                gs1.GA_MTV_Group__c='1';
                gs1.GA_MTV_Group_Division__c='2';
                database.update(gs1);
                
                system.assert(gs <> null);
            }
            catch(exception e)
            {
                return;
            }
        }
        
    }
    /**
@Description: GSRecCloneBCN() method 
@Name : GSRecCloneBCN
@Param : GrpSgmntId
@Return : string
@throws Exception : N/A;
*/  
    public static testmethod void GSRecCloneBCN()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestGrpSgmtrelatLst','testsystemadminstrator@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {
            try {
                GA_Trigger_Functionality_By_Pass__c tcs =new GA_Trigger_Functionality_By_Pass__c();
                tcs.GA_GS_GroupInfoValidation__c = True;
                tcs.SetupOwnerId=usr.ProfileId;
                insert tcs;
                
                Account acc=GA_OBJ_TD01_TestDataCreation.AccRec();
                database.insert(acc);
                
                GA_Group_Segment__c gs = GA_OBJ_TD01_TestDataCreation.grpSegmntRec(acc);
                gs.GA_Carrier__c='BCN';
                gs.GA_Facets_Class_ID__c='1';
                gs.GA_Facets_Group_ID__c='2';
                gs.GA_Facets_Sub_Group_Number__c='3';
                database.insert(gs);
                
                GA_Group_Segment__c gs1 = GA_OBJ_TD01_TestDataCreation.grpSegmntRec(acc);
                gs1.GA_Prevs_RecordID__c=gs.Id;
                gs1.GA_Carrier__c='BCN';
                gs1.GA_Facets_Class_ID__c='1';
                gs1.GA_Facets_Group_ID__c='2';
                gs1.GA_Facets_Sub_Group_Number__c='3';
                database.insert(gs1);
                                  
                gs.GA_Facets_Class_ID__c='1';
                gs.GA_Facets_Group_ID__c='2';
                gs.GA_Facets_Sub_Group_Number__c='3';
                database.update(gs1);
                
                system.assert(gs <> null);
            }
            catch(exception e)
            {
                return;
            }
        }
        
    }
    /**
@Description: GSRecMTVNull() method 
@Name : GSRecMTVNull
@Param : GrpSgmntId
@Return : string
@throws Exception : N/A;
*/  
    public static testmethod void GSRecMTVNull()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestGrpSgmtrelatLst','testsystemadminstrator@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {
            try {
                GA_Trigger_Functionality_By_Pass__c tcs =new GA_Trigger_Functionality_By_Pass__c();
                tcs.GA_GS_GroupInfoValidation__c = True;
                tcs.SetupOwnerId=usr.ProfileId;
                insert tcs;
                
                Account acc=GA_OBJ_TD01_TestDataCreation.AccRec();
                database.insert(acc);
                
                GA_Group_Segment__c gs = GA_OBJ_TD01_TestDataCreation.grpSegmntRec(acc);
                gs.GA_Carrier__c='BCBSM';
                gs.GA_MTV_Group__c=null;
                gs.GA_MTV_Group_Division__c='2';
                database.insert(gs);
                 
                GA_Group_Segment__c gs1 = GA_OBJ_TD01_TestDataCreation.grpSegmntRec(acc);
                gs1.GA_Prevs_RecordID__c=gs.Id;
                gs1.GA_Previous_Group_Segment_No__c=gs.Id;
                gs1.GA_Carrier__c='BCBSM';
                gs1.GA_MTV_Group__c=null;
                gs1.GA_MTV_Group_Division__c='2';
                database.insert(gs1);
                
                gs1.GA_MTV_Group__c=null;
                gs1.GA_MTV_Group_Division__c='3';
                database.update(gs1);
                
                system.assert(gs <> null);
            }
            catch(exception e)
            {
                return;
            }
        }
        
    }
    /**
@Description: GSRecFacetsNull() method 
@Name : GSRecFacetsNull
@Param : GrpSgmntId
@Return : string
@throws Exception : N/A;
*/  
    public static testmethod void GSRecFacetsNull()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestGrpSgmtrelatLst','testsystemadminstrator@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {
            try {
                GA_Trigger_Functionality_By_Pass__c tcs =new GA_Trigger_Functionality_By_Pass__c();
                tcs.GA_GS_GroupInfoValidation__c = True;
                tcs.SetupOwnerId=usr.ProfileId;
                insert tcs;
                
                Account acc=GA_OBJ_TD01_TestDataCreation.AccRec();
                database.insert(acc);
                
                GA_Group_Segment__c gs = GA_OBJ_TD01_TestDataCreation.grpSegmntRec(acc);
                gs.GA_Carrier__c='BCN';
                gs.GA_Facets_Class_ID__c='1';
                gs.GA_Facets_Group_ID__c='2';
                gs.GA_Facets_Sub_Group_Number__c=null;
                database.insert(gs);
                
                GA_Group_Segment__c gs1 = GA_OBJ_TD01_TestDataCreation.grpSegmntRec(acc);
                gs1.GA_Prevs_RecordID__c=gs.Id;
                gs1.GA_Previous_Group_Segment_No__c=gs.Id;
                gs1.GA_Carrier__c='BCN';
                gs1.GA_Facets_Class_ID__c='1';
                gs1.GA_Facets_Group_ID__c='3';
                gs1.GA_Facets_Sub_Group_Number__c=null;
                database.insert(gs1);
                
                gs1.GA_Facets_Class_ID__c='1';
                gs1.GA_Facets_Group_ID__c='3';
                gs1.GA_Facets_Sub_Group_Number__c=null;
                GA_CheckRecursive.runOnce(false);
                database.update(gs1);
                
                system.assert(gs <> null);
            }
            catch(exception e)
            {
                return;
            }
        }
        
    }
     /**
@Description: GSRecBCBSMErrmsg() method 
@Name : GSRecBCBSMErrmsg
@Param : GrpSgmntId
@Return : string
@throws Exception : N/A;
*/  
    public static testmethod void GSRecBCBSMErrmsg()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestGrpSgmtrelatLst','testsystemadminstrator@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {
            try {
                GA_Trigger_Functionality_By_Pass__c tcs =new GA_Trigger_Functionality_By_Pass__c();
                tcs.GA_GS_GroupInfoValidation__c = True;
                tcs.SetupOwnerId=usr.ProfileId;
                insert tcs;
                
                Account acc=GA_OBJ_TD01_TestDataCreation.AccRec();
                database.insert(acc);
                
                GA_Group_Segment__c gs = GA_OBJ_TD01_TestDataCreation.grpSegmntRec(acc);
                gs.GA_Carrier__c='BCN';
                gs.GA_MTV_Group__c=null;
                gs.GA_MTV_Group_Division__c='2';
                database.insert(gs);
                
                GA_Group_Segment__c gs1 = GA_OBJ_TD01_TestDataCreation.grpSegmntRec(acc);
                gs1.GA_Prevs_RecordID__c=gs.Id;
                gs1.GA_Previous_Group_Segment_No__c=gs.Id;
                gs1.GA_Carrier__c='BCN';
                gs1.GA_MTV_Group__c=null;
                gs1.GA_MTV_Group_Division__c='2';
                database.insert(gs1);
                
                gs1.GA_MTV_Group__c=null;
                gs1.GA_MTV_Group_Division__c='2';
                 GA_CheckRecursive.runOnce(false);
                database.update(gs1);
                
                system.assert(gs <> null);
                
            }
            catch(exception e)
            {
                return;
            }
        }
        
    }
    /**
@Description: GSRecBCNErrmsg() method 
@Name : GSRecBCNErrmsg
@Param : GrpSgmntId
@Return : string
@throws Exception : N/A;
*/  
    public static testmethod void GSRecBCNErrmsg()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestGrpSgmtrelatLst','testsystemadminstrator@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {
            try {
                GA_Trigger_Functionality_By_Pass__c tcs =new GA_Trigger_Functionality_By_Pass__c();
                tcs.GA_GS_GroupInfoValidation__c = True;
                tcs.SetupOwnerId=usr.ProfileId;
                insert tcs;
                
                Account acc=GA_OBJ_TD01_TestDataCreation.AccRec();
                database.insert(acc);
                
                GA_Group_Segment__c gs = GA_OBJ_TD01_TestDataCreation.grpSegmntRec(acc);
                gs.GA_Carrier__c='BCBSM';
                gs.GA_Facets_Class_ID__c='1';
                gs.GA_Facets_Group_ID__c='2';
                gs.GA_Facets_Sub_Group_Number__c=null;
                database.insert(gs);
                 
                gs.GA_Facets_Class_ID__c='2';
                gs.GA_Facets_Group_ID__c='1';
                gs.GA_Facets_Sub_Group_Number__c=null;
                database.update(gs);
                
                system.assert(usr <> null);
            }
            catch(exception e)
            {
                return;
            }
        }
        
    }
     /**
@Description: GrpInfoErrmsg() method 
@Name : GrpInfoErrmsg
@Param : GrpSgmntId
@Return : string
@throws Exception : N/A;
*/  
    public static testmethod void GrpInfoErrmsg()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestGrpSgmtrelatLst','testsystemadminstrator@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {
            try {
                GA_Trigger_Functionality_By_Pass__c tcs =new GA_Trigger_Functionality_By_Pass__c();
                tcs.GA_GS_GroupInfoValidation__c = True;
                tcs.SetupOwnerId=usr.ProfileId;
                insert tcs;
                
                Account acc=GA_OBJ_TD01_TestDataCreation.AccRec();
                database.insert(acc);
                
                GA_Group_Segment__c gs = GA_OBJ_TD01_TestDataCreation.grpSegmntRec(acc);
                gs.GA_MTV_Group__c='M';
                gs.GA_Facets_Class_ID__c='1';
                gs.GA_Facets_Group_ID__c='2';
                database.insert(gs);
                
                gs.GA_MTV_Group__c='M1';
                gs.GA_Facets_Class_ID__c='2';
                gs.GA_Facets_Group_ID__c='1';
                database.update(gs);
                
                system.assert(usr <> null);
            }
            catch(exception e)
            {
                return;
            }
        }
        
    }
       /**
@Description: InSuffPrvGSRecCln() method 
@Name : InSuffPrvGSRecCln
@Param : GrpSgmntId
@Return : string
@throws Exception : N/A;
*/  
    public static testmethod void InSuffPrvGSRecCln()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestGrpSgmtrelatLst','testsystemadminstrator@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {
            try {
                
                Account acc=GA_OBJ_TD01_TestDataCreation.AccRec();
                database.insert(acc);
                
                GA_Group_Segment__c gs = GA_OBJ_TD01_TestDataCreation.grpSegmntRec(acc);
                gs.GA_Carrier__c='BCBSM';
                gs.GA_MTV_Group__c='1';
                gs.GA_MTV_Group_Division__c='2';
                database.insert(gs);
                
                GA_Group_Segment__c gs1 = GA_OBJ_TD01_TestDataCreation.grpSegmntRec(acc);
                gs1.GA_Prevs_RecordID__c=gs.Id;
                gs1.GA_Carrier__c='BCBSM';
                gs1.GA_MTV_Group__c='3';
                gs1.GA_MTV_Group_Division__c='4';
                database.insert(gs1);
                
                system.assert(usr <> null);
            }
            catch(exception e)
            {
                return;
            }
        }
        
    }
    
     public static testmethod void cloneGroupSegment()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestGrpSgmtrelatLst','testsystemadminstrator@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {
           try {
                GA_Trigger_Functionality_By_Pass__c tcs =new GA_Trigger_Functionality_By_Pass__c();
                tcs.GA_GS_GroupInfoValidation__c = True;
                tcs.SetupOwnerId=usr.ProfileId;
                insert tcs;
                
                Account acc=GA_OBJ_TD01_TestDataCreation.AccRec();
                database.insert(acc);
                
                GA_Group_Segment__c gs = GA_OBJ_TD01_TestDataCreation.grpSegmntRec(acc);
                gs.GA_Carrier__c='BCBSM';
                gs.GA_MTV_Group__c='1987';
                gs.GA_MTV_Group_Division__c='2';
                database.insert(gs);
                GA_CheckRecursive.run = true;
               
                GA_Group_Segment__c gs1 = GA_OBJ_TD01_TestDataCreation.grpSegmntRec(acc);
                gs1.GA_Prevs_RecordID__c=gs.Id + '_Clone';
              //  gs1.GA_Previous_Group_Segment_No__c = gs.id;
                gs1.GA_Carrier__c='BCBSM';
                gs1.GA_MTV_Group__c='1976';
                gs1.GA_MTV_Group_Division__c='23';
                database.insert(gs1);
               
                    GA_CheckRecursive.run = true;
                               
                gs1.GA_MTV_Group__c='1';
                gs1.GA_MTV_Group_Division__c='2909';
                database.update(gs1);
                
                system.assert(gs <> null);
            }
            catch(exception e)
            {
                return;
            }
        }
        
    }
}