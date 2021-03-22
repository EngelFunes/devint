/*****************************************************************************************************************************************
@Author : Raj
@Name: GA_BCNHstry_TriggerHandlr
@CreatedDate: 07 - May 2018 
@Description: GA_BCNHstry_TriggerHandlr class is used as handler class for BCN History Trigger.
@version : 1.0  
*****************************************************************************************************************************************/
public without sharing class GA_BCNHstry_TriggerHandlr {
    public static final string ClsName  ='GA_BCNHstry_TriggerHandlr';
    public static final string METHODNAME1  ='afterInsert';
    public static final string METHODNAME2  ='afterUpdate';
    public static final string METHODNME  ='beforeInsert';
    private static integer BATCHLMT=Integer.valueof(system.label.GA_GrpAssoc_BatchLimit);
    public static boolean isExecuting=false;
    public static final string QRYBCN ='Select id,Name,GA_Group_Segment__c,GA_Plan_Year_Month__c,GA_Start_Date__c,GA_End_Date__c,GA_Is_Processed__c from GA_Plan_Year_Exception_History__c';
    /******************************************************************************************************************************************
@Description: afterInsert() method 
@Name : afterInsert
@Param : List<GA_Plan_Year_Exception_History__c> bcnLst 
@Return : void
@throws Exception : N/A;
*****************************************************************************************************************************************/      
    public static void afterInsert(List<GA_Plan_Year_Exception_History__c> bcnLst)
    {
        try
        {
            if(bcnLst.size()<BATCHLMT && bcnLst.size()>0 && !System.isFuture() && !System.isBatch() && !isExecuting){
                isExecuting = true;
                GA_BCNHstry_AP01_UpdtToGrpSgmnt.updtBCNtoGs(bcnLst,null);
            }
            if(bcnLst.size()<BATCHLMT && bcnLst.size()>0 && !system.isBatch()){
                if(!GA_BCNHstry_AP01_UpdtToGrpSgmnt.endDateExecuting ){
                    GA_BCNHstry_AP01_UpdtToGrpSgmnt.updatEndDate(bcnLst);
                }           
            }
            else{
                if(!GA_BCNHstry_AP01_UpdtToGrpSgmnt.endDateExecuting && !system.isBatch()){
                    GA_BCNBatchToUpdateEndDates updtEndDtBatch = new GA_BCNBatchToUpdateEndDates(QRYBCN);
                    ID endDtBatchPrsngid = Database.executeBatch(updtEndDtBatch,200);
                }
            }
        }
        catch(Exception e){
            GA_LogExceptionCls.LogExcp(e, ClsName, METHODNAME1);
        }
    }
    /******************************************************************************************************************************************
@Description: afterUpdate() method 
@Name : afterUpdate
@Param : List<GA_Plan_Year_Exception_History__c> bcnLst,Map<ID,GA_Plan_Year_Exception_History__c> bcnOldMap 
@Return : void
@throws Exception : N/A;
*****************************************************************************************************************************************/      
    public static void afterUpdate(List<GA_Plan_Year_Exception_History__c> bcnLst,Map<ID,GA_Plan_Year_Exception_History__c> bcnOldMap)
    {
        try
        {
            if(bcnLst.size()<BATCHLMT && bcnLst.size()>0 && !isExecuting && !System.isFuture() && !System.isBatch()){
                isExecuting=true;
                GA_BCNHstry_AP01_UpdtToGrpSgmnt.updtBCNtoGs(bcnLst,bcnOldMap);
            }
            if(bcnLst.size()<BATCHLMT && bcnLst.size()>0 && !system.isBatch()  ){
                if(!GA_BCNHstry_AP01_UpdtToGrpSgmnt.endDateExecuting ){
                    GA_BCNHstry_AP01_UpdtToGrpSgmnt.updatEndDate(bcnLst);
                }           
            }
            else{
                if(!GA_BCNHstry_AP01_UpdtToGrpSgmnt.endDateExecuting && !system.isBatch()){
                    GA_BCNBatchToUpdateEndDates updtEndDtBatch = new GA_BCNBatchToUpdateEndDates(QRYBCN);
                    ID endDtBatchPrsngid = Database.executeBatch(updtEndDtBatch,200);
                }
            }
        }
        catch(Exception e){
            GA_LogExceptionCls.LogExcp(e, CLSNAME, METHODNAME2);
        }
    }
    /******************************************************************************************************************************************
@Description: beforeInsert() method 
@Name : beforeInsert
@Param : list<GA_Plan_Year_Exception_History__c> planHistoryList
@Return : void
@throws Exception : N/A;
*****************************************************************************************************************************************/      
    public static void beforeInsert(list<GA_Plan_Year_Exception_History__c> planHistoryList)
    {
        try
        {   
            GA_BCNHstry_AP02_BCNNamingConventn.updateBCNHistoryRecordName(planHistoryList);           
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, CLSNAME, methodNme);
        }
    }  
    /******************************************************************************************************************************************
@Description: beforeUpdate() method 
@Name : beforeUpdate
@Param : List<GA_Plan_Year_Exception_History__c> bcnLst,Map<ID,GA_Plan_Year_Exception_History__c> bcnOldMap
@Return : void
@throws Exception : N/A;
*****************************************************************************************************************************************/      
    public static void beforeUpdate(List<GA_Plan_Year_Exception_History__c> bcnLst,Map<ID,GA_Plan_Year_Exception_History__c> bcnOldMap)
    {
        try
        {   
            list<GA_Plan_Year_Exception_History__c> planHistoryList = new list<GA_Plan_Year_Exception_History__c>();
            for(GA_Plan_Year_Exception_History__c bcnNew:bcnLst){
                GA_Plan_Year_Exception_History__c bcnOld=bcnOldMap.get(bcnNew.Id);
                if(bcnOld.GA_Plan_Year_Month__c !=bcnNew.GA_Plan_Year_Month__c)
                {
                    planHistoryList.add(bcnNew);
                }              
            } 
            GA_BCNHstry_AP02_BCNNamingConventn.updateBCNHistoryRecordName(planHistoryList);            
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, CLSNAME, METHODNME);
        }
    } 
}