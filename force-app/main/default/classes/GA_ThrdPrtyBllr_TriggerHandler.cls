/*******************************************************************************************************************************
@Author : Dilip Junapala
@Name: GA_ThrdPrtyBllr_TriggerHandler 
@CreatedDate: 21 - Sep 2018 
@Description: GA_ThrdPrtyBllr_TriggerHandler class is for updating Third Party Biller to in Group Segment.
@version : 1.0  
********************************************************************************************************************************/
public with sharing class GA_ThrdPrtyBllr_TriggerHandler {
    
    public static final string CLSNAME  ='GA_ThrdPrtyBllr_TriggerHandler';
    public static final string METHODNAME  ='afterInsert';
    public static final string METHODNAME1  ='afterUpdate';
    public static final string METHODBEFOREINSERT  ='beforeInsert';
    public static boolean isExecuting=false;
    public static final integer TPBBATCHLIMT=Integer.valueof(system.label.GA_TPB_BatchLimit);
    public static final string QRYTPB ='Select id,Name,GA_TPB_Start_Date__c,GA_TPB_End_Date__c,GA_System_Of_Record__c,GA_Group_Segment_Id__c,GA_Third_Party_Biller_Account__c from GA_Third_Party_Biller_History__c';
    /**
@Description: beforeInsert() method 
@Name : beforeInsert
@Param : List<GA_Third_Party_Biller_History__c> tPBList  
@Return : void
@throws Exception : N/A;
*/  
    public static void beforeInsert(List<GA_Third_Party_Biller_History__c> tPBList)
    {
        try
        { 
            if(!GA_TPBH_AP02_RestrictTPBHCreation.isExecuting){
                GA_TPBH_AP02_RestrictTPBHCreation.isExecuting = true;
                GA_TPBH_AP02_RestrictTPBHCreation.restrictThirdPrtyBilrHstryCrtn(tPBList);
            }
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, CLSNAME, METHODBEFOREINSERT);
        }
    }   
    /**
@Description: afterInsert() method 
@Name : afterInsert
@Param : List<GA_Third_Party_Biller_History__c> tPBList  
@Return : void
@throws Exception : N/A;
*/     
    public static void afterInsert(List<GA_Third_Party_Biller_History__c> tPBList)
    {
        try
        {
            if(tPBList.size()<TPBBATCHLIMT && tPBList.size()>0 && !GA_TPBH_AP01_ThrdPrtyBllrUpdtngToGSLogic.isExecuting){
                GA_TPBH_AP01_ThrdPrtyBllrUpdtngToGSLogic.isExecuting = true;
                GA_TPBH_AP01_ThrdPrtyBllrUpdtngToGSLogic.updatetThirdPartyBillrToGS(tPBList,null);
            }
            if(tPBList.size()<TPBBATCHLIMT && tPBList.size()>0 && !system.isBatch()){
                if(!GA_TPBH_AP01_ThrdPrtyBllrUpdtngToGSLogic.endDateExecuting){
                    GA_TPBH_AP01_ThrdPrtyBllrUpdtngToGSLogic.updatEndDate(tPBList);
                }
            }
            else{
                if(!system.isBatch() && !GA_TPBH_AP01_ThrdPrtyBllrUpdtngToGSLogic.endDateExecuting){
                    GA_TPBHBatchToUpdateEndDates updtEndDtBatch = new GA_TPBHBatchToUpdateEndDates(QRYTPB);
                    ID endDtBatchPrsngid = Database.executeBatch(updtEndDtBatch,200);
                }
            }
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, CLSNAME, METHODNAME);
        }
    }
    /**
@Description: afterUpdate() method 
@Name : afterUpdate
@Param :List<GA_Third_Party_Biller_History__c> tPBList,Map<ID,GA_Third_Party_Biller_History__c> tpbOldMap 
@Return : void
@throws Exception : N/A;
*/    
    public static void afterUpdate(List<GA_Third_Party_Biller_History__c> tPBList,Map<ID,GA_Third_Party_Biller_History__c> tpbOldMap)
    {
        try
        {
            if(tPBList.size()<TPBBATCHLIMT && tPBList.size()>0 && !GA_TPBH_AP01_ThrdPrtyBllrUpdtngToGSLogic.isExecuting && !System.isFuture())
            {
                GA_TPBH_AP01_ThrdPrtyBllrUpdtngToGSLogic.isExecuting = true;
                GA_TPBH_AP01_ThrdPrtyBllrUpdtngToGSLogic.updatetThirdPartyBillrToGS(tPBList,tpbOldMap);
            }
            if(tPBList.size()<TPBBATCHLIMT && tPBList.size()>0 && !system.isBatch()){
                if(!GA_TPBH_AP01_ThrdPrtyBllrUpdtngToGSLogic.endDateExecuting){
                    GA_TPBH_AP01_ThrdPrtyBllrUpdtngToGSLogic.updatEndDate(tPBList);
                }
            }
            else{
                if(!system.isBatch() && !GA_TPBH_AP01_ThrdPrtyBllrUpdtngToGSLogic.endDateExecuting){
                    GA_TPBHBatchToUpdateEndDates updtEndDtBatch = new GA_TPBHBatchToUpdateEndDates(QRYTPB);
                    ID endDtBatchPrsngid = Database.executeBatch(updtEndDtBatch,200);
                }
            }
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, CLSNAME, METHODNAME1);
        }
    }
}