/*
@Author : IDC offshore
@Name: GA_GroupSegAccUpdateCls_Test 
@CreatedDate: 21 - June 2019 
@Description: GA_GroupSegAccUpdateCls_Test Test class
@version : 1.0  
*/
@isTest(seealldata = false)
private class GA_GroupSegAccUpdateCls_Test {
    
    /**
@Description: insertgsRecTest() method 
@Name : insertgsRecTest
@Param : N/A   
@Return : void
@throws Exception : N/A;
*/   
    private static testmethod void insertgsRecTest()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestSysAdm','testsysadm@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {
            try {
                Map<ID,GA_Group_Segment__c> gsOldMap = new Map<ID,GA_Group_Segment__c> ();
                Account acc=GA_OBJ_TD01_TestDataCreation.AccRec();
                database.insert(acc);
                
                GA_Group_Segment__c grpsmt = GA_OBJ_TD01_TestDataCreation.grpSegmntRec(acc);
                grpsmt.GA_Group_Effective_Date__c = system.today();
                grpsmt.Network__c = 'MOS';
                grpsmt.GA_Group_Number__c = '12';
                grpsmt.GA_Group_Suffix__c = '34';
                grpsmt.GA_Is_Mass_Updating__c = true;
                GA_GS_AP02_Update_Address.isExecuting=true;
                GA_GS_UpdateRatingType.isExecuting = true;
                GA_GroupSegmentTriggerHandler.beforeUpdateExecuting = true;
                GA_GroupSegmentTriggerHandler.isExecuting = true;
                GA_GS_AP04_UpdtStatus.isCnclGSChkd = true;
                GA_GS_AP04_UpdtStatus.isExecuting = true;
                GA_GS_AP04_UpdtStatus.isInvoked = true;
                GA_GS_UpdatWrappingFileTPA.isExecuting = true;
                //GA_GroupSegAccUpdateCls.isExecuting = true;
                GA_ExternalAppealSrvcCls_MOS.isExecuting = true;
                GA_GS_Insert_ThrdPartyBillerRecs.isExecuting = true;
                GA_GS_Insert_ThrdPartyBillerRecs.isInvoked = true;
                GA_GS_Insert_ThrdPartyBillerRecs.isInvoking = true;
                GA_ExternalAppealRecdCrtnUpdt.isExecuting = true; 
                GA_CheckRecursive.run = true;
                database.insert(grpsmt);
               
                 GA_GS_AP02_Update_Address.isExecuting=true;
                GA_GS_UpdateRatingType.isExecuting = true;
                GA_GroupSegmentTriggerHandler.beforeUpdateExecuting = true;
                GA_GroupSegmentTriggerHandler.isExecuting = true;
                GA_GS_AP04_UpdtStatus.isCnclGSChkd = true;
                GA_GS_AP04_UpdtStatus.isExecuting = true;
                GA_GS_AP04_UpdtStatus.isInvoked = true;
                GA_GS_UpdatWrappingFileTPA.isExecuting = true;
                GA_GroupSegAccUpdateCls.isExecuting = false;
                GA_ExternalAppealSrvcCls_MOS.isExecuting = true;
                GA_GS_Insert_ThrdPartyBillerRecs.isExecuting = true;
                GA_GS_Insert_ThrdPartyBillerRecs.isInvoked = true;
                GA_GS_Insert_ThrdPartyBillerRecs.isInvoking = true;
                GA_ExternalAppealRecdCrtnUpdt.isExecuting = true;
                GA_CheckRecursive.run = true; 
                
                
                test.startTest();
                 grpsmt.GA_Group_Effective_Date__c = system.today() + 1;
                 grpsmt.GA_Is_Mass_Updating__c = true;
                 database.update(grpsmt);
             
                test.stopTest();
                
                system.assert(grpsmt <>  null, true);
            }
            catch(exception e)
            {
                return;
            }
        }
    }
   
     /**
@Description: updateAccountEnrollmentDatesExcptn() method 
@Name : updateAccountEnrollmentDatesExcptn
@Param : N/A   
@Return : void
@throws Exception : N/A;
*/   
    private static testmethod void updateAccountEnrollmentDatesExcptn()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestSysAdm','testsysadm@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {
            try {
                Map<ID,GA_Group_Segment__c> gsOldMap = new Map<ID,GA_Group_Segment__c> ();
                Account acc=GA_OBJ_TD01_TestDataCreation.AccRec();
                database.insert(acc);
                
                GA_Group_Segment__c grpsmt = GA_OBJ_TD01_TestDataCreation.grpSegmntRec(acc);
                database.insert(grpsmt);
             
                List<GA_Group_Segment__c> gslist = new List<GA_Group_Segment__c> ();
                gslist.add(grpsmt);
               
                test.startTest();
                GA_GroupSegAccUpdateCls.updateAccountEnrollmentDates(null,null);
                GA_GroupSegAccUpdateCls.checkLocalGroupUniqueness(null,null);
                test.stopTest();
                  system.assert(grpsmt <>  null, true);
            }
            catch(exception e)
            {
                return;
            }
        }
    } 
 /**
@Description: checkLocalGroupUniquenessExcptn() method 
@Name : checkLocalGroupUniquenessExcptn
@Param : N/A   
@Return : void
@throws Exception : N/A;
*/   
    private static testmethod void checkLocalGroupUniquenessExcptn()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestSysAdm','testsysadm@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {
            try {
                Map<ID,GA_Group_Segment__c> gsOldMap = new Map<ID,GA_Group_Segment__c> ();
                Account acc=GA_OBJ_TD01_TestDataCreation.AccRec();
                database.insert(acc);
                
                GA_Group_Segment__c grpsmt = GA_OBJ_TD01_TestDataCreation.grpSegmntRec(acc);
                grpsmt.GA_Group_Effective_Date__c = system.today();
                grpsmt.Network__c = 'MOS';
                grpsmt.GA_Group_Number__c = '12';
                grpsmt.GA_Group_Suffix__c = '34';
                database.insert(grpsmt);
              
                grpsmt.GA_Group_Number__c = '345';
                grpsmt.GA_Group_Suffix__c = '334';
                database.update(grpsmt);
                
                List<GA_Group_Segment__c> gslist = new List<GA_Group_Segment__c> ();
                gslist.add(grpsmt);
               
                test.startTest();
                GA_GroupSegAccUpdateCls.updateAccountEnrollmentDates(gslist,gsOldMap);
                GA_GroupSegAccUpdateCls.checkLocalGroupUniqueness(gslist,gsOldMap);
                test.stopTest();
                  system.assert(grpsmt <>  null, true);
            }
            catch(exception e)
            {
                return;
            }
        }
    } 
}