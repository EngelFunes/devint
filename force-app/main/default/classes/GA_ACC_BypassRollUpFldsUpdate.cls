/*********************************************************************************************************************************************
@Author : IDC Offshore
@Name: GA_ACC_BypassRollUpFldsUpdate
@CreatedDate: 10 - Jan 2017 
@Description: GA_ACC_BypassRollUpFldsUpdate class to bypass fields rollup change updating Account
@version : 1.0  
**********************************************************************************************************************************************/
public without sharing class GA_ACC_BypassRollUpFldsUpdate {
    Public static final boolean isExecuting = false;
    /*********************************************************************************************************************************************
@Description: bypassRollUpFldsUpdate() method 
@Name : bypassRollUpFldsUpdate
@Param :list<Account> accList, map<id,Account>  accoldMap
@Return : void
@throws Exception : N/A;
**********************************************************************************************************************************************/ 
    
    public static void bypassRollUpFldsUpdate (list<Account> accList, map<id,Account>  accoldMap)
    {
        
        
        for(Account selAcct : accList){
            
            if(selAcct.GA_ASC_Count__c != accOldMap.get(selAcct.Id).GA_ASC_Count__c ||
               selAcct.GA_ASC_National_ITS_Count__c != accOldMap.get(selAcct.Id).GA_ASC_National_ITS_Count__c  ||
               selAcct.GA_BCN_Count__c != accOldMap.get(selAcct.Id).GA_BCN_Count__c  ||
               selAcct.GA_ERS_Count__c != accOldMap.get(selAcct.Id).GA_ERS_Count__c  ||
               selAcct.GA_Experience_Rated_Count__c != accOldMap.get(selAcct.Id).GA_Experience_Rated_Count__c  ||
               selAcct.GA_GroupSegment_Count__c != accOldMap.get(selAcct.Id).GA_GroupSegment_Count__c  ||
               selAcct.GA_IKA_Count__c != accOldMap.get(selAcct.Id).GA_IKA_Count__c  ||
               selAcct.GA_NASCO_Count__c != accOldMap.get(selAcct.Id).GA_NASCO_Count__c  ||
               selAcct.GA_NoOfOpportunities__c != accOldMap.get(selAcct.Id).GA_NoOfOpportunities__c  ||
               selAcct.GA_NoOfOpportunityCancelled__c != accOldMap.get(selAcct.Id).GA_NoOfOpportunityCancelled__c  ||
               selAcct.GA_Small_Group_Count__c != accOldMap.get(selAcct.Id).GA_Small_Group_Count__c  ||
               selAcct.GA_Small_Group_Shop_Count__c != accOldMap.get(selAcct.Id).GA_Small_Group_Shop_Count__c  ||
               selAcct.GA_TotalNoOfOpenJeopardies__c != accOldMap.get(selAcct.Id).GA_TotalNoOfOpenJeopardies__c|| 
               GA_GS_AP02_Update_Address.isExecuting ||  GA_GroupSegmentTriggerHandler.beforeUpdateExecuting ||
               GA_GroupSegmentTriggerHandler.isExecuting || GA_GS_AP02_Update_Address.isInvoked || 
               GA_GS_Insert_ThrdPartyBillerRecs.isInvoked ||
               GA_GS_Insert_ThrdPartyBillerRecs.isExecuting  || GA_GS_Insert_ThrdPartyBillerRecs.isInvoking  ||
               GA_GroupSegmentSrvcCls.isExecuting ){
                   selAcct.GA_Is_Mass_Updating__c = true; 
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
                   
               }
        }   
    }
    
}