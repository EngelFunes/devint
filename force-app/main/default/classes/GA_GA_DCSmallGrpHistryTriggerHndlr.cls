/*****************************************************************************************************************************************
@Author : Dilip
@Name: GA_GA_DCSmallGrpHistryTriggerHndlr
@CreatedDate: 28 - Sep 2018 
@Description: GA_GA_DCSmallGrpHistryTriggerHndlr class is used as handler class for DC Small Group History Trigger.
@version : 1.0  
*****************************************************************************************************************************************/
public class GA_GA_DCSmallGrpHistryTriggerHndlr {
    public static final string ClsName  ='GA_GA_DCSmallGrpHistryTriggerHndlr';
    public static final string methodName  ='afterInsert';
    public static final string methodName1  ='afterUpdate';
    public static integer dcSmBatLimit=Integer.valueof(system.label.GA_SmallGropBatchLimit);
    public static boolean isExecuting=false;
    public static final String  dcSmlQry ='Select id, GA_Suite__c, GA_Group_Segment_Id__c, GA_Suite_Start_Date__c,GA_Suite_End_Date__c from GA_DC_Small_Grp_History__c';
    
    /******************************************************************************************************************************************
@Description: afterInsert() method 
@Name : afterInsert
@Param : list<GA_DC_Small_Grp_History__c> dcSLst
@Return : void
@throws Exception : N/A;
*****************************************************************************************************************************************/      
    public static void afterInsert(list<GA_DC_Small_Grp_History__c> dcSLst)
    {
        try
        {
            /**if(dcSLst.size() < dcSmBatLimit)
				{
					GA_DCSGH_AP01_SuiteLogic.nullifySuite(dcSLst);
				if(!GA_DCSGH_AP01_SuiteLogic.isExecuting){
						GA_DCSGH_AP01_SuiteLogic.updateSuitetoGS(dcSLst);
						GA_DCSGH_AP01_SuiteLogic.isExecuting=true;
					}
				}**/
            if (!GA_CloneGrpSegmentCls.cloneChildExecuting){
				if(dcSLst.size() < dcSmBatLimit && dcSLst.size()>0 && !System.isFuture() && !System.isBatch() && !isExecuting){
					isExecuting = true;
					//GA_DCSGH_AP01_SuiteLogic.updateSuitetoGS(dcSLst);
					//GA_DCSGH_AP01_SuiteLogic.nullifySuite(dcSLst);
					GA_DCSGH_AP01_SuiteLogic.updateSuiteInfoToGS(dcSLst,null);
				}
				if(dcSLst.size()<dcSmBatLimit && dcSLst.size()>0 && !system.isBatch() ){
					if(!GA_DCSGH_AP01_SuiteLogic.endDateExecuting){
						GA_DCSGH_AP01_SuiteLogic.updatEndDate(dcSLst);
					}
				}
				else{
					if(!system.isBatch() && !GA_DCSGH_AP01_SuiteLogic.endDateExecuting){
						GA_DCGRPBatchToUpdateEndDates updtEndDtBatch = new GA_DCGRPBatchToUpdateEndDates(dcSmlQry);
						ID endDtBatchPrsngid = Database.executeBatch(updtEndDtBatch,200);
					}
				}
			}
        }
        catch(Exception e){
            GA_LogExceptionCls.LogExcp(e, ClsName, methodName);
        }
    }
    /******************************************************************************************************************************************
@Description: afterUpdate() method 
@Name : beforeInsert
@Param : list<GA_DC_Small_Grp_History__c> dcSLst
@Return : void
@throws Exception : N/A;
*****************************************************************************************************************************************/      
    public static void afterUpdate(list<GA_DC_Small_Grp_History__c> dcSLst,map<id,GA_DC_Small_Grp_History__c> dcSmlOldMap)
    {
        try
        {  
            /**if(dcSLst.size() < dcSmBatLimit)
				{
					GA_DCSGH_AP01_SuiteLogic.nullifySuite(dcSLst);
					if(!GA_DCSGH_AP01_SuiteLogic.isExecuting){
						GA_DCSGH_AP01_SuiteLogic.updateSuitetoGS(dcSLst);
						GA_DCSGH_AP01_SuiteLogic.isExecuting=true;
					}
				}**/
            if (!GA_CloneGrpSegmentCls.cloneChildExecuting){
			if(dcSLst.size() < dcSmBatLimit && dcSLst.size()>0 && !isExecuting && !System.isFuture() && !System.isBatch()){
                isExecuting=true;
                //GA_DCSGH_AP01_SuiteLogic.updateSuitetoGS(dcSLst);
                //GA_DCSGH_AP01_SuiteLogic.nullifySuite(dcSLst);
                GA_DCSGH_AP01_SuiteLogic.updateSuiteInfoToGS(dcSLst, dcSmlOldMap);
            }
            if(dcSLst.size()<dcSmBatLimit && dcSLst.size()>0 && !system.isBatch() ){
                if(!GA_DCSGH_AP01_SuiteLogic.endDateExecuting){
                    GA_DCSGH_AP01_SuiteLogic.updatEndDate(dcSLst);
                }
            }
            else{
                if(!system.isBatch() && !GA_DCSGH_AP01_SuiteLogic.endDateExecuting){
                    GA_DCGRPBatchToUpdateEndDates updtEndDtBatch = new GA_DCGRPBatchToUpdateEndDates(dcSmlQry);
                    ID endDtBatchPrsngid = Database.executeBatch(updtEndDtBatch,200);
                }
            }
			}
        }
        catch(Exception e){
            GA_LogExceptionCls.LogExcp(e, ClsName, methodName1);
        }
    }
}