/*****************************************************************************************************************************************
@Author : Dilip
@Name: GA_Group_Seg_AssociationTriggerHndlr
@CreatedDate: 09 - Sep 2018 
@Description: GA_Group_Seg_AssociationTriggerHndlr class is used as handler class for Group Segment Association Trigger.
@version : 1.0  
*****************************************************************************************************************************************/
public with sharing class GA_Group_Seg_AssociationTriggerHndlr {
    public static final string ClsName  ='GA_Group_Support_RqstTriggerHndlr';
    public static final string methodName  ='beforeInsert';
    public static final string methodName1  ='beforeUpdate';
    public static final string methodName2  ='afterInsert';
    public static final string methodName3  ='afterUpdate';
    public static integer grpAsocBatchLmt=Integer.valueof(system.label.GA_GrpAssoc_BatchLimit);
    public static boolean isExecuting=false;
    public static Boolean BypassTrigger = false; // set to `false` to skip  trigger code execution, ex. during unit testing
    public static final string qryGRAS ='Select id,Name,GA_Group_Segment__c,GA_Account__c,GA_System_Of_Record__c,GA_Start_Date__c,GA_End_Date__c from GA_Group_Association__c';
    /******************************************************************************************************************************************
@Description: beforeInsert() method 
@Name : beforeInsert
@Param : list<GA_Group_Association__c> gsALst  
@Return : void
@throws Exception : N/A;
*****************************************************************************************************************************************/      
    public static void beforeInsert(list<GA_Group_Association__c> gsALst)
    {
        try
        {
            GA_Group_Seg_AssociationServcCls.prepopulateName(gsALst,null);
        }
        catch(Exception e){
            GA_LogExceptionCls.LogExcp(e, ClsName, methodName);
        }
    }
    /******************************************************************************************************************************************
@Description: beforeUpdate() method 
@Name : beforeUpdate
@Param : list<GA_Group_Association__c> gsALst,map<id,GA_Group_Association__c> gsALstOldMp 
@Return : void
@throws Exception : N/A;
*****************************************************************************************************************************************/      
    public static void beforeUpdate(list<GA_Group_Association__c> gsALst,map<id,GA_Group_Association__c> gsALstOldMp)
    {
        try
        {
            GA_Group_Seg_AssociationServcCls.prepopulateName(gsALst,gsALstOldMp);
        }
        catch(Exception e){
            GA_LogExceptionCls.LogExcp(e, ClsName, methodName1);
        }
    }
    /******************************************************************************************************************************************
@Description: afterInsert() method 
@Name : afterInsert
@Param : list<GA_Group_Association__c> gsALst 
@Return : void
@throws Exception : N/A;
*****************************************************************************************************************************************/      
    public static void afterInsert(list<GA_Group_Association__c> gsALst)
    {
        try
        {	if(!BypassTrigger){
            	if(gsALst.size()<grpAsocBatchLmt && gsALst.size()>0 && !System.isFuture() && !System.isBatch() && !isExecuting){
                    isExecuting = true;
                    GA_GSA_AP01_AssoctnUpdatngToGsLogic.updateAssttoGS(gsALst,null);
                }
                if(gsALst.size()<grpAsocBatchLmt && gsALst.size()>0 && !system.isBatch()  ){
                    if(!GA_GSA_AP01_AssoctnUpdatngToGsLogic.endDateExecuting ){
                        GA_GSA_AP01_AssoctnUpdatngToGsLogic.updatEndDate(gsALst);
                    }           
                }
                else{
                    if(!system.isBatch() && !GA_GSA_AP01_AssoctnUpdatngToGsLogic.endDateExecuting){
                        GA_GSABatchToUpdateEndDates updtEndDtBatch = new GA_GSABatchToUpdateEndDates(qryGRAS);
                        ID endDtBatchPrsngid = Database.executeBatch(updtEndDtBatch,200);
                    }
                }
        	}
            
        }
        catch(Exception e){
            GA_LogExceptionCls.LogExcp(e, ClsName, methodName2);
        }
    }
    /******************************************************************************************************************************************
@Description: afterUpdate() method 
@Name : afterUpdate
@Param : list<GA_Group_Association__c> gsALst,map<id,GA_Group_Association__c> gsALstOldMp 
@Return : void
@throws Exception : N/A;
*****************************************************************************************************************************************/      
    public static void afterUpdate(list<GA_Group_Association__c> gsALst,map<id,GA_Group_Association__c> gsALstOldMp)
    {
        try
        {	if(!BypassTrigger){
            	if(gsALst.size()<grpAsocBatchLmt && gsALst.size()>0 && !isExecuting && !System.isFuture() && !System.isBatch()){
                    isExecuting=true;
                    GA_GSA_AP01_AssoctnUpdatngToGsLogic.updateAssttoGS(gsALst,gsALstOldMp);
                }
                if(gsALst.size()<grpAsocBatchLmt && gsALst.size()>0 && !system.isBatch() ){
                    if(!GA_GSA_AP01_AssoctnUpdatngToGsLogic.endDateExecuting){
                        GA_GSA_AP01_AssoctnUpdatngToGsLogic.updatEndDate(gsALst);
                    }
                }
                else{
                    if(!system.isBatch() && !GA_GSA_AP01_AssoctnUpdatngToGsLogic.endDateExecuting){
                        GA_GSABatchToUpdateEndDates updtEndDtBatch = new GA_GSABatchToUpdateEndDates(qryGRAS);
                        ID endDtBatchPrsngid = Database.executeBatch(updtEndDtBatch,200);
                    }
                }
            }
        }
        catch(Exception e){
            GA_LogExceptionCls.LogExcp(e, ClsName, methodName3);
        }
    }
}