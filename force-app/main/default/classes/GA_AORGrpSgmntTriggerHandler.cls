/*************************************************************************************************
@Author : IDC offshore
@Name: GA_AORGrpSgmntTriggerHandler
@CreatedDate: 02 - Jan 2019 
@Description: GA_AORGrpSgmntTriggerHandler class 
@version : 1.0  
**************************************************************************************************/
public with sharing class GA_AORGrpSgmntTriggerHandler {
    public static final string CLSNAME  ='GA_AORGrpSgmntTriggerHandler';
    public static final string MTHDAFTERINSERT ='afterInsert';
    public static final string MTHDAFTERUPDATE ='afterUpdate';
    public static final string MTHDBEFOREINSERT  ='beforeInsert';
    public static final string MTHDBEFOREUPDT  ='beforeUpdate';
    public static boolean isExecuting=false;
    public static boolean isBeforeExecuting=false;
    public static boolean removeCommissionAgentFlag=false;
    /**
@Description: beforeInsert() method 
@Name : beforeInsert
@Param : List<GA_Third_Party_Biller_History__c> tPBList  
@Return : void
@throws Exception : N/A;
*/  
    public static void beforeInsert(list<GA_AOR_Group_Segment__c> aorGSLst)
    {
        try
        { 
            if(aorGSLst.size()>0){
            if(!isBeforeExecuting){
                isBeforeExecuting = true;
                GA_AORGS_RestrictDuplicateAORGS.restrictDuplctAORGSCrtn(aorGSLst,null);
                GA_AORGS_AP01_SrvcAgntUpdatToGrpSegmnt.updtDateInfo(aorGSLst,null);
                GA_AORGS_AP01_SrvcAgntUpdatToGrpSegmnt.updtProcessedFlag(aorGSLst,null);
            }}
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, CLSNAME, MTHDBEFOREINSERT);
        }
    } 
    
    /******************************************************************************************************************************************
@Description: afterInsert() method 
@Name : afterInsert
@Param : list<GA_Group_Association__c> gsALst 
@Return : void
@throws Exception : N/A;
*****************************************************************************************************************************************/      
    public static void afterInsert(list<GA_AOR_Group_Segment__c> aorGSLst)
    {
        try
        { if(aorGSLst.size()>0){
            if(!isExecuting){
                isExecuting = true;
                GA_AORGS_AP01_SrvcAgntUpdatToGrpSegmnt.updtSrvcAgntToGS(aorgsLst,null);
            }
        }}
        catch(Exception e){
            GA_LogExceptionCls.LogExcp(e, CLSNAME, MTHDAFTERINSERT);
        }
    }
    /******************************************************************************************************************************************
@Description: beforeUpdate() method 
@Name : beforeUpdate
@Param : list<GA_AOR_Group_Segment__c> aorGSLst,Map<Id,GA_AOR_Group_Segment__c> aorGSoldmap
@Return : void
@throws Exception : N/A;
*****************************************************************************************************************************************/      
    public static void beforeUpdate(list<GA_AOR_Group_Segment__c> aorGSLst,Map<Id,GA_AOR_Group_Segment__c> aorGSoldmap)
    {
        try
        { 
            if(aorGSLst.size()>0){ 
            if(!isBeforeExecuting){
                isBeforeExecuting = true;
                GA_AORGS_RestrictDuplicateAORGS.restrictDuplctAORGSCrtn(aorGSLst,aorGSoldmap);
                GA_AORGS_AP01_SrvcAgntUpdatToGrpSegmnt.updtDateInfo(aorGSLst,aorGSoldmap);
                
            }
            }
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, CLSNAME, MTHDBEFOREUPDT);
        }
    } 
    /******************************************************************************************************************************************
@Description: afterUpdate() method 
@Name : afterUpdate
@Param : list<GA_AOR_Group_Segment__c> aorGsLst,map<id,GA_AOR_Group_Segment__c> aorGsOldMap 
@Return : void
@throws Exception : N/A;
*****************************************************************************************************************************************/   
    public static void afterUpdate(list<GA_AOR_Group_Segment__c> aorGSLst,Map<Id,GA_AOR_Group_Segment__c> aorGSoldmap)
    {
        try{
             if(aorGSLst.size()>0){
            if(!isExecuting){
                isExecuting = true;
                GA_AORGS_AP01_SrvcAgntUpdatToGrpSegmnt.updtSrvcAgntToGS(aorgsLst,aorGSoldmap);
            }
             }}
        catch(Exception e){
            GA_LogExceptionCls.LogExcp(e, CLSNAME, MTHDAFTERUPDATE);
        }
    }
    
/******************************************************************************************************************************************
@Description: commissionAgentUpdateOnGS() method 
@Name : commissionAgentUpdateOnGS
@Param : list<GA_AOR_Group_Segment__c> lstAORGS 
@Return : void
@throws Exception : N/A;
*****************************************************************************************************************************************/    
    //Implemented as part of US-3418 and US-3492 
    public static void commissionAgentOnGS(List<GA_AOR_Group_Segment__c> lstAORGS){
        try{
            List<Id> lstGSIds = new List<Id>();
            Map<Id,List<GA_AOR_Group_Segment__c>> mapGSId_lstAORGS = new Map<Id,List<GA_AOR_Group_Segment__c>>();
            for(GA_AOR_Group_Segment__c objAORGS : lstAORGS){
                lstGSIds.add(objAORGS.GA_Group_Segment_Id__c);    
            }
            if(!lstGSIds.isEmpty()){
                for(GA_Group_Segment__c objGrpSeg  : [SELECT Id, GA_Commissioning_Agent__c,  
                                                           (SELECT Id,GA_Group_Segment_Id__c, AOR_Agent__c, GA_Service_Start_Date__c, GA_Service_End_Date__c, GA_Commission_Start_Date__c, GA_Commission_End_Date__c 
                                                            FROM AOR_Group_Segments__r) 
                                                      FROM  GA_Group_Segment__c
                                                      WHERE Id IN: lstGSIds]){
                    List<GA_AOR_Group_Segment__c> lstAOR = new List<GA_AOR_Group_Segment__c>();
                    lstAOR.addAll(objGrpSeg.AOR_Group_Segments__r);
                    if(!mapGSId_lstAORGS.containsKey(objGrpSeg.Id)){
                        mapGSId_lstAORGS.put(objGrpSeg.Id, lstAOR);    
                    } else{
                        List<GA_AOR_Group_Segment__c> AORGS = mapGSId_lstAORGS.get(objGrpSeg.Id);
                        AORGS.addAll(lstAOR);
                        mapGSId_lstAORGS.put(objGrpSeg.Id, AORGS);
                    }    
                }
                if(!mapGSId_lstAORGS.isEmpty() && removeCommissionAgentFlag){
                    removeCommissionAgentOnGS(mapGSId_lstAORGS);
                } else if(!mapGSId_lstAORGS.isEmpty()){
                    updateCommissionAgentOnGS(mapGSId_lstAORGS);
                }
            } 
        }catch(Exception e){
            GA_LogExceptionCls.LogExcp(e, CLSNAME, 'commissionAgentOnGS');
        }
    }

/******************************************************************************************************************************************
@Description: updateCommissionAgentOnGS() method 
@Name : updateCommissionAgentOnGS
@Param : Map<Id,List<GA_AOR_Group_Segment__c>> 
@Return : void
@throws Exception : N/A;
*****************************************************************************************************************************************/    
    //Implemented as part of US-3418 and US-3492 
    private static void updateCommissionAgentOnGS(Map<Id,List<GA_AOR_Group_Segment__c>> mapGSId_lstAORGS){
        try{
            List<GA_Group_Segment__c> lstGS = new List<GA_Group_Segment__c>();
            for(Id gsId : mapGSId_lstAORGS.keySet()){
                if(mapGSId_lstAORGS.get(gsId).size() > 1){
                    Boolean flag1 = false;
                    Boolean flag2 = false;
                    Integer count = 0;
                    Id commissionAgentId;
                    for(GA_AOR_Group_Segment__c objAORGS : mapGSId_lstAORGS.get(gsId)){
                        if((objAORGS.GA_Commission_Start_Date__c != null && objAORGS.GA_Commission_End_Date__c !=null && objAORGS.GA_Service_End_Date__c != null && objAORGS.GA_Service_Start_Date__c != null)
                            &&  (objAORGS.GA_Commission_Start_Date__c <= system.today() && objAORGS.GA_Commission_End_Date__c >= system.today())){  // && objAORGS.GA_Service_End_Date__c >=  system.today()
                                flag1 = true;
                                count++;
                                commissionAgentId = objAORGS.AOR_Agent__c;
                        }
                        else if((objAORGS.GA_Commission_Start_Date__c != null && objAORGS.GA_Commission_End_Date__c !=null 
                            		&& ((objAORGS.GA_Service_End_Date__c == null && objAORGS.GA_Service_Start_Date__c == null) || objAORGS.GA_Service_End_Date__c < system.today()))
                                    &&  (objAORGS.GA_Commission_Start_Date__c <= system.today() && objAORGS.GA_Commission_End_Date__c >=  system.today())){
                                        flag2 = true;
                                        if(commissionAgentId == null){
                                            commissionAgentId = objAORGS.AOR_Agent__c;
                                        }
                        }
                    }
                    if(flag1){
                        if(count==1){
                            GA_Group_Segment__c objGS = new GA_Group_Segment__c(Id=gsId);
                            objGS.GA_Commissioning_Agent__c = commissionAgentId;
                            if(flag2){
                                objGS.Multiple_Commission_Agents__c = true; 
                            }
                            lstGS.add(objGS);
                        } else if (count > 1){
                            GA_Group_Segment__c objGS = new GA_Group_Segment__c(Id=gsId);
                            objGS.GA_Commissioning_Agent__c = null;
                            objGS.Multiple_Commission_Agents__c = true;
                            lstGS.add(objGS);  
                        }
                    } else if(flag2){
                        GA_Group_Segment__c objGS = new GA_Group_Segment__c(Id=gsId);
                        objGS.GA_Commissioning_Agent__c = commissionAgentId;
                        objGS.Multiple_Commission_Agents__c = false;
                        lstGS.add(objGS);    
                    }
                }else if(mapGSId_lstAORGS.get(gsId).size() == 1){
                    if(mapGSId_lstAORGS.get(gsId)[0].GA_Commission_Start_Date__c <= system.today() && mapGSId_lstAORGS.get(gsId)[0].GA_Commission_End_Date__c >= system.today()){
                        GA_Group_Segment__c objGS = new GA_Group_Segment__c(Id=gsId);
                        objGS.GA_Commissioning_Agent__c = mapGSId_lstAORGS.get(gsId)[0].AOR_Agent__c;
                        objGS.Multiple_Commission_Agents__c = false;
                        lstGS.add(objGS);    
                    }else if(mapGSId_lstAORGS.get(gsId)[0].GA_Commission_End_Date__c < system.today()){ //To remove commission agent on GS when commission end date is in past 
                        GA_Group_Segment__c objGS = new GA_Group_Segment__c(Id=gsId);
                        objGS.GA_Commissioning_Agent__c = null;
                        if(objGS.Multiple_Commission_Agents__c){
                            objGS.Multiple_Commission_Agents__c = false;
                        }
                        lstGS.add(objGS); 
                    }
                }
            }
            if(!lstGS.isEmpty()){
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
                GA_GS_Insert_ThrdPartyBillerRecs.isExecuting = true;
                GA_GS_Insert_ThrdPartyBillerRecs.isInvoked = true;
                GA_ExternalAppealRecdCrtnUpdt.isExecuting = true;
                GA_GS_Insert_ThrdPartyBillerRecs.isInvoking = true;
                GA_GroupSegmentSrvcCls.isExecuting = true;
                update lstGS;    
            }
        }catch(Exception e){
            GA_LogExceptionCls.LogExcp(e, CLSNAME, 'updateCommissionAgentOnGS');
        }
    }  

/******************************************************************************************************************************************
@Description: removeCommissionAgentOnGS() method 
@Name : removeCommissionAgentOnGS
@Param : Map<Id,List<GA_AOR_Group_Segment__c>> 
@Return : void
@throws Exception : N/A;
*****************************************************************************************************************************************/    
    //Implemented as part of US-3418 and US-3492    
    private static void removeCommissionAgentOnGS(Map<Id,List<GA_AOR_Group_Segment__c>> mapGSId_lstAORGS){
        List<GA_Group_Segment__c> lstGS = new List<GA_Group_Segment__c>();
        for(Id gsId : mapGSId_lstAORGS.keySet()){
            if(mapGSId_lstAORGS.get(gsId).size() > 1){
                Integer count = 0;
                for(GA_AOR_Group_Segment__c objAORGS : mapGSId_lstAORGS.get(gsId)){
                    if(objAORGS.GA_Commission_End_Date__c < System.today()){
                        count++;
                    }
                }
                if(mapGSId_lstAORGS.get(gsId).size() == count){
                    GA_Group_Segment__c objGS = new GA_Group_Segment__c(Id=gsId);
                    objGS.GA_Commissioning_Agent__c = null;
                    if(objGS.Multiple_Commission_Agents__c){
                            objGS.Multiple_Commission_Agents__c = false;
                    }
                    lstGS.add(objGS);
                }
            }else if(mapGSId_lstAORGS.get(gsId).size() == 1){
                if(mapGSId_lstAORGS.get(gsId)[0].GA_Commission_End_Date__c <= system.today()){
                    GA_Group_Segment__c objGS = new GA_Group_Segment__c(Id=gsId);
                    objGS.GA_Commissioning_Agent__c = null;
                    if(objGS.Multiple_Commission_Agents__c){
                            objGS.Multiple_Commission_Agents__c = false;
                    }
                    lstGS.add(objGS);
                }
            }
        } 
        if(!lstGS.isEmpty()){
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
            GA_GS_Insert_ThrdPartyBillerRecs.isExecuting = true;
            GA_GS_Insert_ThrdPartyBillerRecs.isInvoked = true;
            GA_ExternalAppealRecdCrtnUpdt.isExecuting = true;
            GA_GS_Insert_ThrdPartyBillerRecs.isInvoking = true;
            GA_GroupSegmentSrvcCls.isExecuting = true;
            update lstGS;
        }
    }
}