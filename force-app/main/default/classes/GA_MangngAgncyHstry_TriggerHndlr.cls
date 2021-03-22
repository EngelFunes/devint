/*****************************************************************************************************************************************
@Author : Raj Jena
@Name: GA_MangngAgncyHstry_TriggerHndlr
@CreatedDate: 08 - May 2019 
@Description: GA_MangngAgncyHstry_TriggerHndlr class is used as handler class for Managing Agency History Trigger.
@version : 1.0  
*****************************************************************************************************************************************/
public with sharing class GA_MangngAgncyHstry_TriggerHndlr {
    public static final string CLASSNAME  ='GA_MangngAgncyHstry_TriggerHndlr';
    public static final string METHODNAME3  ='beforeInsert';
    public static final string METHODNAME1  ='afterInsert';
    public static final string METHODNAME2  ='afterUpdate';
    private static integer batchLmt=Integer.valueof(system.label.GA_GrpAssoc_BatchLimit);
    public static boolean isExecuting=false;
    public static final string QRYMAH ='Select id,Name,GA_Group_Segment__c,GA_Managing_Agency__c,GA_Start_Date__c,GA_End_Date__c,GA_Is_Processed__c, MA_Override_End_Date__c, MA_Override_Start_Date__c from GA_Managing_Agency_History__c';
   
       /******************************************************************************************************************************************
@Description: beforeInsert() method 
@Name : beforeInsert
@Param : list<GA_Managing_Agency_History__c> mahList 
@Return : void
@throws Exception : N/A;
*****************************************************************************************************************************************/   
    public static void beforeInsert(list<GA_Managing_Agency_History__c> mahNew)
    {
        try{
            System.debug('RUNNING: GA_MangngAgncyHstry_TriggerHndlr beforeInsert');
            if(!GA_AP_Set_MAHistory_EndDate.isExecuting){
                    GA_AP_Set_MAHistory_EndDate.isExecuting = true;
                    GA_AP_Set_MAHistory_EndDate.setMAHistoryEndDate(mahNew);                     
             }            
 			
       }
        catch(Exception e){
            GA_LogExceptionCls.LogExcp(e, CLASSNAME, METHODNAME3);
        }
    }
    
    /******************************************************************************************************************************************
@Description: afterInsert() method 
@Name : afterInsert
@Param : list<GA_Managing_Agency_History__c> mahList 
@Return : void
@throws Exception : N/A;
*****************************************************************************************************************************************/      
    public static void afterInsert(list<GA_Managing_Agency_History__c> mahList)
    {
        try
        {
            System.debug('RUNNING: GA_MangngAgncyHstry_TriggerHndlr afterInsert');
            if(mahList.size()<batchLmt && mahList.size()>0 && !System.isFuture() && !System.isBatch() && !isExecuting){
                isExecuting = true;
                GA_MngngAgncyHstry_AP01_UpdtToGrpSgmnt.updtMngngAgncytoGs(mahList,null);
            }
            if(mahList.size()<batchLmt && mahList.size()>0 && !system.isBatch()){
                if(!GA_MngngAgncyHstry_AP01_UpdtToGrpSgmnt.endDateExecuting ){
                    GA_MngngAgncyHstry_AP01_UpdtToGrpSgmnt.updatEndDate(mahList);
                }           
            }
            else{
                if(!system.isBatch() && !GA_MngngAgncyHstry_AP01_UpdtToGrpSgmnt.endDateExecuting){
                    GA_MAHBatchToUpdateEndDates updtEndDtBatch = new GA_MAHBatchToUpdateEndDates(QRYMAH);
                    ID endDtBatchPrsngid = Database.executeBatch(updtEndDtBatch,200);
                }
            }
        }
        catch(Exception e){
            GA_LogExceptionCls.LogExcp(e, CLASSNAME, METHODNAME1);
        }
    }
    /******************************************************************************************************************************************
@Description: afterUpdate() method 
@Name : afterUpdate
@Param : list<GA_Managing_Agency_History__c> mahList,map<id,GA_Managing_Agency_History__c> mahListOldMp 
@Return : void
@throws Exception : N/A;
*****************************************************************************************************************************************/      
    public static void afterUpdate(list<GA_Managing_Agency_History__c> mahList,map<id,GA_Managing_Agency_History__c> mahListOldMp)
    {
        try
        {
            System.debug('RUNNING: GA_MangngAgncyHstry_TriggerHndlr afterUpdate');
            if(mahList.size()<batchLmt && mahList.size()>0 && !isExecuting && !System.isFuture() && !System.isBatch()){
                isExecuting=true;
                GA_MngngAgncyHstry_AP01_UpdtToGrpSgmnt.updtMngngAgncytoGs(mahList,mahListOldMp);
            }
            if(mahList.size()<batchLmt && mahList.size()>0 && !system.isBatch()){
                if(!GA_MngngAgncyHstry_AP01_UpdtToGrpSgmnt.endDateExecuting){
                    GA_MngngAgncyHstry_AP01_UpdtToGrpSgmnt.updatEndDate(mahList);
                }
            }
            else{
                if(!system.isBatch() && !GA_MngngAgncyHstry_AP01_UpdtToGrpSgmnt.endDateExecuting){
                    GA_MAHBatchToUpdateEndDates updtEndDtBatch = new GA_MAHBatchToUpdateEndDates(QRYMAH);
                    ID endDtBatchPrsngid = Database.executeBatch(updtEndDtBatch,200);
                }
            }
        }
        catch(Exception e){
            GA_LogExceptionCls.LogExcp(e, CLASSNAME, METHODNAME2);
        }
    }
}