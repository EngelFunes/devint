/**
@Author : IDC Offshore
@Name: GA_TPBHBatchToUpdateThrdPrtyBllrOnGS
@CreatedDate: 25 - Oct - 2018 
@Description: GA_TPBHBatchToUpdateThrdPrtyBllrOnGS batch class to update latest TPB history information on GS
*/
global class GA_TPBHBatchToUpdateThrdPrtyBllrOnGS implements Database.Batchable<sObject>{
    private string query;
    /**
@Description: GA_TPBHBatchToUpdateThrdPrtyBllrOnGS() Constructer method 
@Name : GA_TPBHBatchToUpdateThrdPrtyBllrOnGS
@Param : string tpbQry
@Return : void
@throws Exception : N/A;
*/  
    global GA_TPBHBatchToUpdateThrdPrtyBllrOnGS(string tpbQry)
    {
        query=tpbQry;
    }
    /**
@Description: start() method 
@Name : start
@Param : Database.BatchableContext BC
@Return : Database.QueryLocator
@throws Exception : N/A;
*/
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
        return Database.getQueryLocator(query); 
    }
    /**
@Description: execute() method 
@Name : execute
@Param : Database.BatchableContext BC, List<sObject> scope
@Return : Database.QueryLocator
@throws Exception : N/A;
*/ 
    global void execute(Database.BatchableContext bc, List<GA_Third_Party_Biller_History__c> scope)
    {
        GA_GS_AP02_Update_Address.isExecuting=true;
        GA_GS_UpdateRatingType.isExecuting = true;
        GA_GroupSegmentTriggerHandler.beforeUpdateExecuting = true;
        GA_GroupSegmentTriggerHandler.isExecuting = true;
        GA_GS_AP04_UpdtStatus.isCnclGSChkd = true;
        GA_GS_AP04_UpdtStatus.isExecuting = true;
        GA_GS_AP04_UpdtStatus.isInvoked = true;
        GA_GS_UpdatWrappingFileTPA.isExecuting = true;
        GA_GroupSegAccUpdateCls.isExecuting = true;
        GA_ExternalAppealSrvcCls_MOS.isExecuting = true;
        GA_GS_Insert_ThrdPartyBillerRecs.isExecuting = true;
        GA_ExternalAppealRecdCrtnUpdt.isExecuting = true; 

        GA_TPBH_AP01_ThrdPrtyBllrUpdtngToGSLogic.updatetThirdPartyBillrToGS(scope,null);
    }
    /**
@Description: finish() method 
@Name : finish
@Param : Database.BatchableContext BC
@Return : Void
@throws Exception : N/A;
*/ 
    global void finish(Database.BatchableContext bc)
    {
        
    }
}