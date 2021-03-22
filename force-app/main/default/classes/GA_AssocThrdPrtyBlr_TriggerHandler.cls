/*******************************************************************************************************************************
@Author : Raj Jena
@Name: GA_AssocThrdPrtyBlr_TriggerHandler 
@CreatedDate: 21 - Dec 2018 
@Description: GA_AssocThrdPrtyBlr_TriggerHandler class is for updating Association Third Party Biller.
@version : 1.0  
********************************************************************************************************************************/
public with sharing class GA_AssocThrdPrtyBlr_TriggerHandler {
    
    public static final string ClsName  ='GA_AssocThrdPrtyBlr_TriggerHandler';
    public static final string methodName  ='afterInsert';
    public static final string methodName1  ='afterUpdate';
    public static boolean isExecuting=false;
    public static final string qryATPB ='Select id,Name,GA_Start_Date__c,GA_End_Date__c,GA_Third_Party_Biller_Account_Id__c,GA_Association_Account_Id__c from GA_Association_Third_Party_Biller__c';
    public static final string qryInsrtTPB ='Select id,Name,GA_Start_Date__c,GA_End_Date__c,GA_Third_Party_Biller_Account_Id__c,GA_Association_Account_Id__c from GA_Association_Third_Party_Biller__c where id in:idLst';
    public static integer atpbBatchLmt=Integer.valueof(system.label.GA_ATPB_BatchLimit);
    /**
@Description: afterInsert() method 
@Name : afterInsert
@Param : List<GA_Association_Third_Party_Biller__c> atPBList  
@Return : void
@throws Exception : N/A;
*/     
    public static void afterInsert(List<GA_Association_Third_Party_Biller__c> atPBList)
    {
        try
        {
            if(atPBList.size()<atpbBatchLmt && atPBList.size()>0 && !System.isBatch() && !isExecuting){
                isExecuting=true;
                GA_ATPB_UpdateThitdPrtyAcc.updtetThrdPrtyHstryToAcc(atPBList,null);
            }
            List<id> atpbIds = new List<id>();
            for(GA_Association_Third_Party_Biller__c atpb : atPBList){
                   atpbIds.add(atpb.Id);
            }
            
            if(atPBList.size()<atpbBatchLmt && atPBList.size()>0 && !system.isBatch()){
                GA_ATPB_UpdateThitdPrtyAcc.updtTpbhRecs(atPBList);
                /*if(!GA_ATPB_UpdateThitdPrtyAcc.insrtTBPExecuting){
                     GA_ATPB_UpdateThitdPrtyAcc.updtTpbhRecs(atPBList);
                }*/
            }
            else{
                if(!system.isBatch()){//&& !GA_ATPB_UpdateThitdPrtyAcc.insrtTBPExecuting
                    GA_ATPBBatchToInsertTBPrecs insrtTBPBatch = new GA_ATPBBatchToInsertTBPrecs(qryInsrtTPB,atpbIds);
                    ID insertTBPBatchPrsngid = Database.executeBatch(insrtTBPBatch,200);
                }
            }
            
            if(atPBList.size()<atpbBatchLmt && atPBList.size()>0 && !system.isBatch()){
                if(!GA_ATPB_UpdateThitdPrtyAcc.endDateExecuting){
                    GA_ATPB_UpdateThitdPrtyAcc.updatEndDate(atPBList);
                }
            }
            else{
                if(!system.isBatch() && !GA_ATPB_UpdateThitdPrtyAcc.endDateExecuting){
                    GA_ATPBBatchToUpdateEndDates updtEndDtBatch = new GA_ATPBBatchToUpdateEndDates(qryATPB);
                    ID endDtBatchPrsngid = Database.executeBatch(updtEndDtBatch,200);
                }
            }
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, ClsName, methodName);
        }
    }
    /**
@Description: afterUpdate() method 
@Name : afterUpdate
@Param :List<GA_Association_Third_Party_Biller__c> atPBList,Map<ID,GA_Association_Third_Party_Biller__c> atpbOldMap 
@Return : void
@throws Exception : N/A;
*/    
    public static void afterUpdate(List<GA_Association_Third_Party_Biller__c> atPBList,Map<ID,GA_Association_Third_Party_Biller__c> atpbOldMap)
    {
        try
        {
            if(atPBList.size()<atpbBatchLmt && atPBList.size()>0 && !isExecuting && !System.isBatch()){
                isExecuting=true;
                GA_ATPB_UpdateThitdPrtyAcc.updtetThrdPrtyHstryToAcc(atPBList,atpbOldMap);
            }
            if(atPBList.size()<atpbBatchLmt && atPBList.size()>0 && !system.isBatch()){
                if(!GA_ATPB_UpdateThitdPrtyAcc.endDateExecuting){
                    GA_ATPB_UpdateThitdPrtyAcc.updatEndDate(atPBList);
                }
            }
            else{
                if(!system.isBatch() && !GA_ATPB_UpdateThitdPrtyAcc.endDateExecuting){
                    GA_ATPBBatchToUpdateEndDates updtEndDtBatch = new GA_ATPBBatchToUpdateEndDates(qryATPB);
                    ID endDtBatchPrsngid = Database.executeBatch(updtEndDtBatch,200);
                }
            }
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, ClsName, methodName1);
        }
    }
}