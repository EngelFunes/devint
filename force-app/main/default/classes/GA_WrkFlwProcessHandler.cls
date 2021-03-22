/*********************************************************************************************************************************************
@Author : IDC Offshore
@Name: GA_WrkFlwProcessHandler
@CreatedDate: 20-05
@Description: GA_WrkFlwProcessHandler class is for creating/updating workflow process is changed
@version : 1.0  
**********************************************************************************************************************************************/
public without sharing class GA_WrkFlwProcessHandler {
    
    public static final String CLSNAME  ='GA_WrkFlwProcessHandler';
    public static final String METHODNMEBEFOREUPDATE  ='beforeupdate';
    public static final String METHODNMEAFTERUPDATE  ='afterupdate';
    public static final String METHODNMEAFTERINSERT  ='afterinsert';
    public static final String METHODNMENEFOREINSERT = 'beforeinsert';
    public static final String QUEU='Select id,GA_Workflow_ID__r.GA_Workflow_Template__c,GA_Workflow_Next_Step__r.Name,GA_Workflow_Next_Step__c,GA_Workflow_ID__r.GA_Sold_After_3PM__c,'
                      +'GA_Result__c,GA_Date_Closed__c,GA_Status__c,GA_Group_Segment_ID__c,GA_WF_Step_ID__c,GA_WF_Step_ID__r.Name'
                      +' from GA_WF_Group_Segment__c where id in :wfgsSetId';
/*********************************************************************************************************************************************
@Description: beforeupdate() method 
@Name : beforeupdate
@Param : list<GA_WF_Group_Segment__c> wkflProcssList,
 map<id,GA_WF_Group_Segment__c> wkflProcssMap, map<id,Account>  wkflProcssMap 
@Return : void
@throws Exception : N/A;
**********************************************************************************************************************************************/ 
    public static void beforeupdate(list<GA_WF_Group_Segment__c> wkflProcssList,
                                    map<id,GA_WF_Group_Segment__c> wkflProcssNewMap, map<id,GA_WF_Group_Segment__c>  wkflProcssOldMap)
    {
        try
        {
            GA_WrkFlwSldAftr3pm.fetchWFGSLst(wkflProcssNewMap,wkflProcssOldMap);
            
            if(!GA_WrkFlwSldAftr3pm.isCallBatch)
            {
            GA_WrkFlwSldAftr3pm.beforeUpdate(wkflProcssNewMap,wkflProcssOldMap);
            }
          
            GA_WrkFlwPrcssChangeOwner.restrictChangeOwnerOManagedQueue(wkflProcssNewMap, wkflProcssOldMap);
           
          
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, CLSNAME, METHODNMEBEFOREUPDATE);
        }
    }
    
/***********************************************************************************************************************************************
@Description: afterupdate() method 
@Name : afterupdate
@Param :list<GA_WF_Group_Segment__c> wkflProcssList,
map<id,GA_WF_Group_Segment__c> wkflProcssMap, map<id,Account>  wkflProcssMap
@Return : void
@throws Exception : N/A;
**********************************************************************************************************************************************/ 
    public static void afterupdate(list<GA_WF_Group_Segment__c> wkflProcssList,
                                    map<id,GA_WF_Group_Segment__c> wkflProcssNewMap, map<id,GA_WF_Group_Segment__c>  wkflProcssOldMap)
    {
        try{
            if(!GA_WrkFlwSldAftr3pm.isCallBatch)
            {
            GA_WrkFlwSldAftr3pm.afterUpdate(wkflProcssNewMap,wkflProcssOldMap);
            }
            else
            {
                GA_UpdateWFGrpSgmntsBatch updteWFGrmnts=new GA_UpdateWFGrpSgmntsBatch(QUEU,wkflProcssOldMap,wkflProcssNewMap,GA_WrkFlwSldAftr3pm.wfgsLstId);
                ID batchprocessid = Database.executeBatch(updteWFGrmnts,1000); 
            }
            
             if(!GA_WrkFlwPrcssUpdtRecvandCmpDts.isExecuting){
                GA_WrkFlwPrcssUpdtRecvandCmpDts.isExecuting = true;
                GA_WrkFlwPrcssUpdtRecvandCmpDts.updtRecandCompDts(wkflProcssNewMap, wkflProcssOldMap);
                 }
               if( !GA_WrkFlwSldAftr3pm.isRecursive){
                GA_WrkFlwSldAftr3pm.isRecursive = true; 
            GA_WrkFlwSldAftr3pm.updtPCSNotification(wkflProcssList,wkflProcssNewMap,wkflProcssOldMap);
             }
       }
        catch(exception e)
        {
        
            GA_LogExceptionCls.LogExcp(e, CLSNAME, METHODNMEAFTERUPDATE);
        }
    }
    
        
/***********************************************************************************************************************************************
@Description: afterinsert() method 
@Name : afterinsert
@Param :list<GA_WF_Group_Segment__c> wkflProcssList,
map<id,GA_WF_Group_Segment__c> wkflProcssMap, map<id,Account>  wkflProcssMap
@Return : void
@throws Exception : N/A;
**********************************************************************************************************************************************/ 
    public static void afterinsert(list<GA_WF_Group_Segment__c> wkflProcssList,
                                   map<id,GA_WF_Group_Segment__c> wkflProcssNewMap,map<id,GA_WF_Group_Segment__c> wkflProcssOldMap)
    {
        try{
            
            if(!GA_WrkFlwPrcssUpdtRecvandCmpDts.isExecuting){
                GA_WrkFlwPrcssUpdtRecvandCmpDts.isExecuting = true;
 				GA_WrkFlwPrcssUpdtRecvandCmpDts.updtRecandCompDts(wkflProcssNewMap, wkflProcssNewMap);
                }
            if( !GA_WrkFlwSldAftr3pm.isRecursive){
                GA_WrkFlwSldAftr3pm.isRecursive = true;  
                GA_WrkFlwSldAftr3pm.updtPCSNotification(wkflProcssList,wkflProcssNewMap,null); 
            }
        }
        catch(exception e)
        {
        
            GA_LogExceptionCls.LogExcp(e, CLSNAME, METHODNMEAFTERINSERT);
        }
    }
/***********************************************************************************************************************************************
@Description: beforeinsert() method 
@Name : beforeinsert
@Param :list<GA_WF_Group_Segment__c> wkflProcssList,
map<id,GA_WF_Group_Segment__c> wkflProcssMap, map<id,Account>  wkflProcssMap
@Return : void
@throws Exception : N/A;
**********************************************************************************************************************************************/ 
    public static void beforeinsert(list<GA_WF_Group_Segment__c> wkflProcssList,map<id,GA_WF_Group_Segment__c> wkflProcssNewMap)
    {
            GA_WrkFlwPrcssUpdtRecvandCmpDts.updteOwnrMngrEml(wkflProcssList);
    }  
    

/***********************************************************************************************************************************************
@Description: updateWrkFlwSegmentNames() method 
@Name : updateWrkFlwSegmentNames
@Param :list<GA_WF_Group_Segment__c> wkflProcssList
@Return : void
@throws Exception : N/A;
**********************************************************************************************************************************************/ 
    
    public static void updateWrkFlwSegmentNames(List<GA_WF_Group_Segment__c> lstWorkFlowProcesses, Map<Id,GA_WF_Group_Segment__c> oldMap)
    {
        List<Id> lstWorkflowIds = new List<Id>();
        Set<Id> setWorkflowIds = new Set<Id>();
        
        for(GA_WF_Group_Segment__c objWFP : lstWorkFlowProcesses)
        {
            if(oldMap == null)
            {
                System.debug('====in after insert====');
                if(objWFP.GA_Workflow_ID__c != null)
                {
                    setWorkflowIds.add(objWFP.GA_Workflow_ID__c);
                }
            }
            else
            {
                System.debug('====in after update new value===='+objWFP.GA_Group_Seg_Name__c);
                System.debug('====old value===='+oldMap.get(objWFP.Id).GA_Group_Seg_Name__c);
                if(objWFP.GA_Group_Seg_Name__c != oldMap.get(objWFP.Id).GA_Group_Seg_Name__c)
                {
                    setWorkflowIds.add(objWFP.GA_Workflow_ID__c);
                }
            }
        }
        System.debug('====setWorkflowIds==='+setWorkflowIds);
        lstWorkflowIds.addAll(setWorkflowIds);
        List<GA_WF_Workflow__c> lstWorkflowForUpdate = new List<GA_WF_Workflow__c>();
        if(lstWorkflowIds.size() > 0)
        {
            for(GA_WF_Workflow__c objWorkflow : [select Id, group_Segments__c, (select Id,GA_Group_Seg_Name__c, GA_Group_Segment_Name__c FROM GA_Workflow_Group_Segments__r) from GA_WF_Workflow__c WHERE Id IN :lstWorkflowIds])
            {
                System.debug('====objWorkflow==='+objWorkflow);
                Set<String> setSegmentName = new Set<String>();
              //  if(objWorkflow.group_Segments__c == null)
              //  {
                    for(GA_WF_Group_Segment__c objGS : objWorkflow.GA_Workflow_Group_Segments__r)
                    {
                        setSegmentName.add(objGS.GA_Group_Segment_Name__c);
                    }
                    System.debug('====setSegmentName==='+setSegmentName);
                    String segmentName = null;
                    Integer count = 0;
                    for(String s : setSegmentName)
                    {
                        if(count == 0)
                        {
                            segmentName = s;
                        }
                        else if (count > 0)
                        {
                            segmentName = segmentName + ',' +s;    
                        }
                        ++count;
                           
                    }
                    objWorkflow.group_Segments__c = segmentName; 
                    lstWorkflowForUpdate.add(objWorkflow);
               // }
            }
            System.debug('====lstWorkflowForUpdate===='+lstWorkflowForUpdate.size());
            if(lstWorkflowForUpdate.size() > 0)
            {
                update lstWorkflowForUpdate;
            }  
        }  
    }
    
}