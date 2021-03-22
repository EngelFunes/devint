/**
@Author : IDC Offshore
@Name: GA_WorkflowTrgrHndlr
@CreatedDate: 8 - June 2018 
@Description: GA_WorkflowTrgrHndlr class is for create/update of workflow
@version : 1.0  
*/ 
public with sharing class GA_WorkflowTrgrHndlr {
    public static final String ClsName  ='GA_WorkflowTriggerHandler';
    public static final String methodNmebeforeinsert  ='beforeInsert';
    public static final String methodNmeafterinsert  ='afterInsert';
    public static final String methodNmeafterupdate  ='afterUpdate';
    /**
@Description: beforeInsert() method 
@Name : beforeInsert
@Param : list<GA_WF_Workflow__c> wrkFLwLst  
@Return : void
@throws Exception : N/A;
*/      
    public static void beforeInsert(list<GA_WF_Workflow__c> wrkFLwLst)
    {
        try
        {   
            
            if(!GA_WorkflowServiceCls.isExecuting)
            {
                GA_WorkflowServiceCls.isExecuting=true;
                GA_WorkflowServiceCls.wrkflw(wrkFLwLst);  
            }
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, ClsName, methodNmebeforeinsert);        }
    }
    /**
@Description: afterInsert() method 
@Name : afterInsert
@Param : list<GA_WF_Workflow__c> wrkFLwLst
@Return : void
@throws Exception : N/A;
*/  
    public static void afterInsert(list<GA_WF_Workflow__c> wrkFLwLst)
    {
        try
        {
            GA_WrkflowAutomatedCls.AutoCrteWrkFlw(wrkFLwLst);   
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, ClsName, methodNmeafterinsert);        
        }
    }
    /**
@Description: afterUpdate() method 
@Name : afterUpdate
@Param :list<GA_WF_Workflow__c> wrkFLwLst, map<id,GA_WF_Workflow__c> wrkflowOldMap 
@Return : void
@throws Exception : N/A;
*/      
    public static void afterUpdate(list<GA_WF_Workflow__c> wrkFLwLst, map<id,GA_WF_Workflow__c> wrkflowOldMap)
    {
        try
        {
            if(!system.isFuture())
                GA_WrkflwUpadteCompDatesCls.UpdteCompDates(wrkFLwLst,wrkflowOldMap);  
            
            GA_AP_UpdateGSBenefitEffDtFromWF.UpdtGSBenefitEffDt(wrkFLwLst);
            
            if(!ARV_AP75_updateContractStatus.isExecuting){
                ARV_AP75_updateContractStatus.updtCntrctStatus(wrkFLwLst);
            }
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, ClsName, methodNmeafterupdate);        
        }
    }
}