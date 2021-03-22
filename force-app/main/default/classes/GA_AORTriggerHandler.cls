/**
* @author        IDC offshore
* @date          6/28/2019
* @description   AOR Trigger Handler
*/
public with sharing class GA_AORTriggerHandler {
    public static final string CLSNAME  ='GA_AORTriggerHandler';
    public static final string MTHDAFTERUPDATE ='afterUpdate';
    public static final string MTHDBEFOREINSERT  ='beforeInsert';
    public static boolean isExecuting=false;
    
    /******************************************************************************************************************************************
@Description: afterUpdate() method 
@Name : afterUpdate
@Param : list<GA_AOR_Group_Segment__c> aorGsLst,map<id,GA_AOR_Group_Segment__c> aorGsOldMap 
@Return : void
@throws Exception : N/A;
*****************************************************************************************************************************************/   
    public static void beforeInsert(list<GA_AOR__c> aorLst)
    {
        try{
            GA_AORSrvcDateRangeChk.checkServiceDateRange(aorLst, null); 
            if(!GA_UpdateAORName.isExecuting){
                GA_UpdateAORName.isExecuting = true;
                GA_UpdateAORName.updateAORName(aorLst); 
            }
            
            if(GA_AP_ASEPRecordMatchCls.asepGrpSeg && !GA_updateAORSrvcCommissionDate.isExecuting){
                    GA_updateAORSrvcCommissionDate.isExecuting = true;                   
                    GA_updateAORSrvcCommissionDate.updateAORdates(aorLst);
             }
       }
        catch(Exception e){
            GA_LogExceptionCls.LogExcp(e, CLSNAME, MTHDAFTERUPDATE);
        }
    }
    /******************************************************************************************************************************************
@Description: afterUpdate() method 
@Name : afterUpdate
@Param : list<GA_AOR_Group_Segment__c> aorGsLst,map<id,GA_AOR_Group_Segment__c> aorGsOldMap 
@Return : void
@throws Exception : N/A;
*****************************************************************************************************************************************/   
    public static void beforeUpdate(list<GA_AOR__c> aorLst,map<Id,GA_AOR__c> aorOldMap)
    {
        try{
            
            if(aorLst.size() < Integer.ValueOf(System.Label.GA_AORGS_BatchLimit))
            {
                GA_AORSrvcDateRangeChk.checkServiceDateRange(aorLst, aorOldMap);
                if(!GA_updateAORGSSvcCls.isExecuting){
                    GA_updateAORGSSvcCls.isExecuting = true;
                    GA_updateAORGSSvcCls.updateAORGSInfo(aorLst,aorOldMap); 
                }             
            }   
            
            for (GA_AOR__c aorRec : aorLst) {
                if (aorRec.GA_Service_Start_Date__c <> aorOldMap.get(aorRec.id).GA_Service_Start_Date__c) {
                    aorRec.isStatusDatesModified__c = true; 
                }
                else if (aorRec.GA_Service_End_Date__c <> aorOldMap.get(aorRec.id).GA_Service_End_Date__c) {
                    aorRec.isStatusDatesModified__c = true; 
                }
            }

            
        }
        catch(Exception e){
            GA_LogExceptionCls.LogExcp(e, CLSNAME, MTHDAFTERUPDATE);
        }
    }
/***************************************************************************************************************
@Description: afterInsert() method 
@Name : afterInsert
@Param : list<GA_AOR__c> aorLst,map<Id,GA_AOR__c> aorOldMap 
@Return : void
@throws Exception : N/A;
***************************************************************************************************************/
    public static void afterInsert(list<GA_AOR__c> aorLst,map<Id,GA_AOR__c> aorOldMap)
    {
        try{
            
            system.debug('inAfter Insert');
            GA_updateAORBoB.accountShareUpdateBoB(aorLst, aorOldMap); 
            GA_updateAORBoB.sharingSupportRequestRecordsBOB(aorLst, aorOldMap,true);      
        }
        catch(Exception e){
        
            system.debug('exception class inserr after');
            GA_LogExceptionCls.LogExcp(e, CLSNAME, MTHDAFTERUPDATE);
        }
    }
/***************************************************************************************************************
@Description: afterUpdate() method 
@Name : afterUpdate
@Param : list<GA_AOR__c> aorLst,map<Id,GA_AOR__c> aorOldMap 
@Return : void
@throws Exception : N/A;
***************************************************************************************************************/  
    public static void afterUpdate(list<GA_AOR__c> aorLst,map<Id,GA_AOR__c> aorOldMap)
    {
        try{
            GA_updateAORBoB.accountShareUpdateBoB(aorLst, aorOldMap); 
               GA_updateAORBoB.sharingSupportRequestRecordsBOB(aorLst, aorOldMap,false);   
            
            List<Id> lstAORIDs = new List<ID>();
            List<GA_Group_Segment__c> lstGS = new List<GA_Group_Segment__c>();
            for(GA_AOR__c objAOR : aorLst){
            	if((objAOR.GA_Commission_End_Date__c != aorOldMap.get(objAOR.Id).GA_Commission_End_Date__c  && objAOR.GA_Commission_End_Date__c < System.today()) || 
                    (objAOR.GA_Commission_Start_Date__c != aorOldMap.get(objAOR.Id).GA_Commission_Start_Date__c  && objAOR.GA_Commission_Start_Date__c > System.today())){
                	lstAORIDs.add(objAOR.Id);    
                }
            }
            if(lstAORIDs.size() > 0){
                for(GA_AOR_Group_Segment__c objAORGS : [SELECT Id, GA_AOR_Id__c, GA_Group_Segment_Id__c, GA_Group_Segment_Id__r.GA_Commissioning_Agent__c 
                                                    	FROM GA_AOR_Group_Segment__c
                                                   		WHERE GA_AOR_Id__c IN:lstAORIDs]){
                	if(objAORGS.GA_Group_Segment_Id__c  != null){
                    	GA_Group_Segment__c objGS = new GA_Group_Segment__c(Id=objAORGS.GA_Group_Segment_Id__c);
                        objGS.GA_Commissioning_Agent__c = null;
                        lstGS.add(objGS);
                    }
                }	
        	}
            if(lstGS.size() > 0 ){
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
        catch(Exception e){
            system.debug('exception class');
            GA_LogExceptionCls.LogExcp(e, CLSNAME, MTHDAFTERUPDATE);
        }
    }
}