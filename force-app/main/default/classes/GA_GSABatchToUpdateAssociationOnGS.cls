/**
@Author : IDC Offshore
@Name: GA_GSABatchToUpdateAssociationOnGS
@CreatedDate: 25 - Oct - 2018 
@Description: GA_GSABatchToUpdateAssociationOnGS batch class to update latest Group Segment Association information on GS
*/
global class GA_GSABatchToUpdateAssociationOnGS implements Database.Batchable<sObject>{
    private string query;
    /**
@Description: GA_GSABatchToUpdateAssociationOnGS() Constructer method 
@Name : GA_GSABatchToUpdateAssociationOnGS
@Param : string gsaQry
@Return : void
@throws Exception : N/A;
*/ 
    global GA_GSABatchToUpdateAssociationOnGS(string gsaQry)
    {
        query=gsaQry;
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
    global void execute(Database.BatchableContext bc, List<GA_Group_Association__c> scope)
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
        GA_ExternalAppealRecdCrtnUpdt.isExecuting = true;
        GA_GSA_AP01_AssoctnUpdatngToGsLogic.updateAssttoGS(scope,null);
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