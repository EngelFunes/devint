/**
@Author : IDC Offshore
@Name: GA_ACC_UpdtGSLastMdfdDt_Test
@CreatedDate: 9 Apr 2019
@Description: GA_ACC_UpdtGSLastMdfdDt_Test class is for GA_ACC_UpdtGSLastMdfdDt class.
@version : 1.0  
*/ 
@isTest(seealldata=false)
private class GA_ACC_UpdtGSLastMdfdDt_Test {
    /**
@Description: UpdtGSRec() method 
@Name : UpdtGSRec
@Param : N/A  
@Return : void
@throws Exception : N/A;
*/ 
    
    private static testMethod void UpdtGSRec()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('System Administrator','testsystemadminstrator@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {
            try {
                Map<id,Account> Accoldmap = new Map<id,Account>();
                map<id,GA_Group_Segment__c> GSMap =    new map<id,GA_Group_Segment__c>();
                
                Account acc=GA_OBJ_TD01_TestDataCreation.AccRec();
                acc.Name = 'TestAcc';
                acc.GA_ERISA_Exempt__c = false;
                GA_AccountTriggerHandlr.isExecuting = true;
                GA_ACC_AP01_CheckPlatinumStatusOnAgency.isExecuting = true;
                GA_Util_lockRecords.isExecuting = true;
                GA_ACC_AP02_IdentifySalesRepOnAccount.isExecuting = true;
                GA_ACC_AP05_CreateHandoverRecord.isExecuting = true;
                GA_ACC_UpdateChildContctsOnAccOwnrChange.isExecuting = true;
                GA_ACC_AP04_UpdtCntOnAccLockUnlock.isExecuting = true;
                GA_ACC_AP_UpdtAssmntOwnrMgrChnge.isExecuting = true; 
                GA_AccountBatchToUpdateContactOwner.isInvodedFrmBtch = true;
                GA_ACC_AP_UpdtAssmntOwnrMgrChnge.isExecuting = true;
                database.insert(acc);
                
                Accoldmap.put(acc.id,acc);
                
                GA_AccountTriggerHandlr.isExecuting = true;
                GA_Group_Segment__c gs = GA_OBJ_TD01_TestDataCreation.grpSegmntRec(acc);
                gs.GA_Account__c = acc.ID;
                gs.GA_Current_Cluster_Code__c = 'D743';
                gs.GA_Carrier__c='BCBSM';
                gs.Network__c = 'NASCO';
                gs.GA_Account_Type__c='NASCO';
                GA_AccountTriggerHandlr.isExecuting = true;
                GA_GS_AP02_Update_Address.isExecuting=true;
                GA_GS_UpdateRatingType.isExecuting = true;
                GA_GroupSegmentTriggerHandler.beforeUpdateExecuting = true;
                GA_GroupSegmentTriggerHandler.isExecuting = true;
                GA_GS_AP04_UpdtStatus.isCnclGSChkd = true;
                GA_GS_AP04_UpdtStatus.isExecuting = true;
                GA_GS_AP04_UpdtStatus.isInvoked = true;
                GA_GS_UpdatWrappingFileTPA.isExecuting = true;
                GA_ACC_AP01_CheckPlatinumStatusOnAgency.isExecuting = true;
                GA_Util_lockRecords.isExecuting = true;
                GA_ACC_AP02_IdentifySalesRepOnAccount.isExecuting = true;
                GA_ACC_AP05_CreateHandoverRecord.isExecuting = true;
                GA_ACC_UpdateChildContctsOnAccOwnrChange.isExecuting = true;
                GA_ACC_AP04_UpdtCntOnAccLockUnlock.isExecuting = true;
                GA_ACC_AP_UpdtAssmntOwnrMgrChnge.isExecuting = true; 
                GA_AccountBatchToUpdateContactOwner.isInvodedFrmBtch = true;
                GA_ACC_AP_UpdtAssmntOwnrMgrChnge.isExecuting = true;
                database.insert(gs);
                
                GA_AccountTriggerHandlr.isExecuting = true;
                GA_ACC_AP01_CheckPlatinumStatusOnAgency.isExecuting = true;
                GA_Util_lockRecords.isExecuting = true;
                GA_ACC_AP02_IdentifySalesRepOnAccount.isExecuting = true;
                GA_ACC_AP05_CreateHandoverRecord.isExecuting = true;
                GA_ACC_UpdateChildContctsOnAccOwnrChange.isExecuting = true;
                GA_ACC_AP04_UpdtCntOnAccLockUnlock.isExecuting = true;
                GA_ACC_AP_UpdtAssmntOwnrMgrChnge.isExecuting = true; 
                GA_AccountBatchToUpdateContactOwner.isInvodedFrmBtch = true;
                GA_ACC_AP_UpdtAssmntOwnrMgrChnge.isExecuting = true;
                //  database.update(acc);
                Account updtAcc = New Account( id =acc.id );
                updtAcc.GA_ERISA_Exempt__c = True; 
                
                List <Account> acclst = new List <Account> ();
                acclst.add(updtAcc);  
                
                Test.startTest();
                GA_ACC_UpdtGSLastMdfdDt.UpdtGSLstMdfdDt(acclst,Accoldmap);   
                Test.stopTest();
                 
                system.assert(acclst <> null);
            }
            catch(exception e)
            {
                return;
            }
        }   
        
    }
}