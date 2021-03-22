/*
@Author : IDC Offshore
@Name: GA_AORGS_RestrictDuplicateAORGS_Test 
@CreatedDate: 5 - Aug 2019 
@Description: GA_AORGS_RestrictDuplicateAORGS Test class
@version : 1.0  
*/
@isTest(seealldata = false)
private class GA_AORGS_RestrictDuplicateAORGS_Test {

    /**
@Description: aorGSRecDuplct() method 
@Name : aorGSRecDuplct
@Param : N/A   
@Return : void
@throws Exception : N/A;
*/   
    private static testmethod void aorGSRecDuplct()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestUnderwriter','TestUnderwriter@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {
            try {
                Account acc=GA_OBJ_TD01_TestDataCreation.AccRec();
                database.insert(acc);
                
                Map<Id,GA_AOR_Group_Segment__c> aorGSoldmap = new Map<Id,GA_AOR_Group_Segment__c> ();
                list<GA_AOR_Group_Segment__c> aorGSLst = new list<GA_AOR_Group_Segment__c> ();
                
                GA_Group_Segment__c gsmt = GA_OBJ_TD01_TestDataCreation.grpSegmntRec(acc);
                gsmt.GA_Carrier__c='BCBSM';
                gsmt.GA_MTV_Group__c='1';
                gsmt.GA_MTV_Group_Division__c='2';
                gsmt.GA_Is_Mass_Updating__c = True;
                GA_GS_AP02_Update_Address.isExecuting=true;
                GA_GroupSegmentTriggerHandler.beforeUpdateExecuting = true;
                GA_GroupSegmentTriggerHandler.isExecuting = true;
                GA_GS_AP04_UpdtStatus.isCnclGSChkd = true;
                GA_GS_AP04_UpdtStatus.isExecuting = true;
                GA_GS_AP04_UpdtStatus.isInvoked = true;
                GA_GS_UpdatWrappingFileTPA.isExecuting = true;
                GA_ExternalAppealSrvcCls_MOS.isExecuting = true;
                GA_GS_Insert_ThrdPartyBillerRecs.isExecuting = true;
                GA_GS_Insert_ThrdPartyBillerRecs.isInvoked = true;
                GA_GS_Insert_ThrdPartyBillerRecs.isInvoking = true;
                GA_ExternalAppealRecdCrtnUpdt.isExecuting = true; 
                database.insert(gsmt);
                
                gsmt.Status__c='Active';
                gsmt.GA_Is_Mass_Updating__c = True;
                GA_GS_AP02_Update_Address.isExecuting=true;
                GA_GroupSegmentTriggerHandler.beforeUpdateExecuting = true;
                GA_GroupSegmentTriggerHandler.isExecuting = true;
                GA_GS_AP04_UpdtStatus.isCnclGSChkd = true;
                GA_GS_AP04_UpdtStatus.isExecuting = true;
                GA_GS_AP04_UpdtStatus.isInvoked = true;
                GA_GS_UpdatWrappingFileTPA.isExecuting = true;
                GA_ExternalAppealSrvcCls_MOS.isExecuting = true;
                GA_GS_Insert_ThrdPartyBillerRecs.isExecuting = true;
                GA_GS_Insert_ThrdPartyBillerRecs.isInvoked = true;
                GA_GS_Insert_ThrdPartyBillerRecs.isInvoking = true;
                GA_ExternalAppealRecdCrtnUpdt.isExecuting = true;
                
                database.update(gsmt);
                
                Id cntcagencyRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Contact - Agent').getRecordTypeId();
                
                Contact cntc=GA_OBJ_TD01_TestDataCreation.cntactRec(acc.id);
                cntc.RecordTypeId=cntcagencyRecordTypeId;
                database.insert(cntc);
                
                GA_Aor__C aorRecd=GA_OBJ_TD01_TestDataCreation.createAOR(acc,cntc);
                aorRecd.GA_Service_Start_Date__c =  System.Today() - 100;
                aorRecd.GA_Service_End_Date__c = Date.newInstance(2020, 1, 1);
                database.insert(aorRecd);
                
                GA_Aor__C aorQuery= [select GA_Service_Start_Date__c,Id from GA_Aor__C where Id =:aorRecd.id limit 1];
                
                GA_AOR_Group_Segment__c aorGsRec1 = GA_OBJ_TD01_TestDataCreation.createAORGS(aorRecd,gsmt);
                
                database.insert(aorGsRec1);
                GA_AOR_Group_Segment__c aorGsRecquery= [select GA_Service_Start_Date__c,Id,
                                                        GA_Is_StartDateProcessed__c,GA_Cancel_Flag__c,GA_Is_EndDateProcessed__c 
                                                        from GA_AOR_Group_Segment__c where Id =:aorGsRec1.id limit 1];
                
                aorGSLst.add(aorGsRec1);
                
                GA_AOR_Group_Segment__c aorGsRec2 = new GA_AOR_Group_Segment__c ();
                aorGsRec2.Name = 'Test';
                aorGsRec2.GA_AOR_Id__c = aorRecd.id;
                aorGsRec2.GA_Group_Segment_Id__c = gsmt.id;
                GA_AORGrpSgmntTriggerHandler.isBeforeExecuting = false;
                
                database.insert(aorGsRec2); 			
                aorGsRecquery= [select GA_Service_Start_Date__c,Id,
                                GA_Is_StartDateProcessed__c,GA_Cancel_Flag__c,GA_Is_EndDateProcessed__c 
                                from GA_AOR_Group_Segment__c where Id =:aorGsRec2.id limit 1];
                
                aorGSLst.add(aorGsRec2); 
                
                test.startTest(); 
                
                test.stopTest();
                system.assert(usr <> null);
                
            }
            catch(exception e)
            {
                return;
            }
        }
    }
    
    
}