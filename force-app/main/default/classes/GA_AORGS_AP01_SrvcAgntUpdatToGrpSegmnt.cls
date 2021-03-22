/*******************************************************************************************************************************
@Author : Raj Jena
@Name: GA_AORGS_AP01_SrvcAgntUpdatToGrpSegmnt 
@CreatedDate: 18 - June 2019 

@version : 1.0  
********************************************************************************************************************************/
public without sharing class GA_AORGS_AP01_SrvcAgntUpdatToGrpSegmnt {
    public static final String CLSNAME  = 'GA_AORGS_AP01_SrvcAgntUpdatToGrpSegmnt';
    public static final String METHDNAMESRVCAGNTTOGS  = 'updtSrvcAgntToGS' ;
    public static final integer OCCURENCE = 0;
    public static final String  EXCPSVRTY='ERROR';
    public static final String  TILTOPRTR='~';
    public static final String  BLNK='';
    public static final String  GSGMTQUERY = 'select id, GA_AOR_Group_Segment_Id__c,GA_Servicing_Agent__c,'+
        'GA_AOR_Group_Segment_Id__r.GA_Process_End_Date__c ,GA_AOR_Group_Segment_Id__r.GA_Is_EndDateProcessed__c,'+
        'GA_AOR_Group_Segment_Id__r.GA_Cancel_Flag__c ' +
        ' from GA_Group_Segment__c ';
    public static final String   GSGMTWHERE = '  Where Id In  ';
    public static final String   GSLSTLMT = ' Limit 10000';
    public static  boolean isChnge=false;
    /*******************************************************************************************************************************
@Description    :  updtSrvcAgntToGS 
@Name         :   updtSrvcAgntToGS
@Param         :   list<GA_AOR_Group_Segment__c> aorgsLst,Map<Id,GA_AOR_Group_Segment__c> aorgsOldMap
@Return       :   void
@throws Exception   :   N/A;
********************************************************************************************************************************/     
    Public static void updtSrvcAgntToGS(list<GA_AOR_Group_Segment__c> aorgsLst,Map<Id,GA_AOR_Group_Segment__c> aorgsOldMap){
        try{
            
            List<Database.SaveResult> srList = new List<Database.SaveResult>();
            List<ExceptionLog__c> excpLst = New List<ExceptionLog__c>();
            Map<String,GA_AOR_Group_Segment__c> gsIdaorGsMap = new Map<String,GA_AOR_Group_Segment__c>();
            Set<Id> grpSegmentProcessIds = New Set<Id>();
            set<id> grpSgmntEmtyAgnt=new set<id>();
            Map<Id,String> aorGSServicingAgent =  new Map<Id,String>();
            Map<Id,String> grpsegServicingAgent =  new Map<Id,String>();
            for(GA_AOR_Group_Segment__c aorgs :aorgsLst){
                if(aorgsOldMap!=null){
                    GA_AOR_Group_Segment__c aorgsOld =aorgsOldMap.get(aorgs.Id);
                    if(aorgsOld.GA_Process_Start_Date__c!=aorgs.GA_Process_Start_Date__c ||
                       aorgsOld.GA_Process_End_Date__c!=aorgs.GA_Process_End_Date__c ||
                       aorgsOld.GA_Cancel_Flag__c!=aorgs.GA_Cancel_Flag__c ){
                           isChnge=true; 
                       }
                }
                else{
                    isChnge=true;
                }
                
                //To retrive the IDs of the record falling within the date ranges i.e. Active records 
                if(aorgs.GA_Process_Start_Date__c<=system.today() && aorgs.GA_Process_End_Date__c>=system.today() && isChnge){
                    if(grpSgmntEmtyAgnt.contains(aorgs.GA_Group_Segment_Id__c))
                    {
                        grpSgmntEmtyAgnt.remove(aorgs.GA_Group_Segment_Id__c);
                    }
                    gsIdaorGsMap.put(aorgs.Id +TILTOPRTR+aorgs.GA_Group_Segment_Id__c, aorgs);
                    grpSegmentProcessIds.add(aorgs.GA_Group_Segment_Id__c);
                }
                
                //To retrive the IDs of the record when the END DATE has reached.
                if(aorgs.GA_Process_End_Date__c<system.today() && isChnge){
                    if(!gsIdaorGsMap.keyset().contains(aorgs.Id +TILTOPRTR+aorgs.GA_Group_Segment_Id__c))
                    {
                        grpSgmntEmtyAgnt.add(aorgs.GA_Group_Segment_Id__c);
                        aorGSServicingAgent.put(aorgs.GA_Group_Segment_Id__c,aorgs.GA_ProcessAgentId__c);
                        gsIdaorGsMap.put(aorgs.Id +TILTOPRTR+aorgs.GA_Group_Segment_Id__c, aorgs);
                        grpSegmentProcessIds.add(aorgs.GA_Group_Segment_Id__c);
                    }                  
                }
                //To retrive the IDs of the record when the cancel flag is set to true.
                if(aorgs.GA_Cancel_Flag__c && isChnge){
                    grpSgmntEmtyAgnt.add(aorgs.GA_Group_Segment_Id__c);
                    aorGSServicingAgent.put(aorgs.GA_Group_Segment_Id__c,aorgs.GA_ProcessAgentId__c);
                    gsIdaorGsMap.put(aorgs.Id +TILTOPRTR+aorgs.GA_Group_Segment_Id__c, aorgs);
                    grpSegmentProcessIds.add(aorgs.GA_Group_Segment_Id__c);                   
                }
            }
            Map<id,Date> gsIdaorGsMapDate = new Map<id,Date>();
            Set<Id> gsIdset = New Set<Id>();
            List<GA_Group_Segment__c> gsLstToUpdte = new List<GA_Group_Segment__c> ();
            Set<GA_AOR_Group_Segment__c> processGSLst = New Set<GA_AOR_Group_Segment__c>();
            Set<GA_AOR_Group_Segment__c> processEndGSLst = New Set<GA_AOR_Group_Segment__c>();
            Set<Id> processErrGSLst = New Set<Id>();
            GA_AOR_Group_Segment__c processAORGS = New GA_AOR_Group_Segment__c();
            Map<Id,GA_Group_Segment__c> gsMap =  New  Map<Id,GA_Group_Segment__c> ();
            
            if(grpSegmentProcessIds.size() > 0){
                gsMap = GA_Util17_GrpSgmntDataAccesHelper.fetchGrpSgmMap(GSGMTQUERY, GSGMTWHERE +  GA_Util08_FilterProcessHelper.idSet(grpSegmentProcessIds), BLNK, GSLSTLMT);
                
                for(GA_Group_Segment__c gs : gsMap.values())
                {
                    grpsegServicingAgent.put(gs.Id,gs.GA_Servicing_Agent__c);
                    for(String key : gsIdaorGsMap.keySet())
                    {
                        if(Key.contains(gs.id))
                        {
                            // if(gs.GA_AOR_Group_Segment_Id__c !=gsIdaorGsMap.get(Key).Id  )
                            // {
                            Boolean isCancelFlagSet = false;
                            Boolean isEndDatingToday = false;
                            //To update the Is_EndDateProcessed Flag
                            
                            if( ( String.IsEmpty(gs.GA_AOR_Group_Segment_Id__c) ||
                                 (!String.IsEmpty(gs.GA_AOR_Group_Segment_Id__c) && 
                                  (!gs.GA_AOR_Group_Segment_Id__r.GA_Cancel_Flag__c 
                                   || !gs.GA_AOR_Group_Segment_Id__r.GA_Is_EndDateProcessed__c )  ) ) ){
                                       
                                       if(gsIdaorGsMap.get(Key).GA_Cancel_Flag__c && gsIdaorGsMap.get(Key).GA_Cancel_Date__c == null ){
                                           isCancelFlagSet = true;
                                           processAORGS = New GA_AOR_Group_Segment__c (id = gsIdaorGsMap.get(Key).id,
                                                                                       GA_Cancel_Date__c=system.today(),
                                                                                       GA_Process_End_Date__c=system.today());
                                           processEndGSLst.add(processAORGS);
                                       }
                                       
                                       if(gsIdaorGsMap.get(Key).GA_Process_End_Date__c < system.today() && !isCancelFlagSet){
                                           isEndDatingToday = true;
                                           processAORGS = New GA_AOR_Group_Segment__c (id = gsIdaorGsMap.get(Key).id,
                                                                                       GA_Is_EndDateProcessed__c = true);
                                           processGSLst.add(processAORGS);
                                       }
                                       
                                       if(gsIdaorGsMap.get(Key).GA_Process_End_Date__c > system.today() && !isCancelFlagSet && !isEndDatingToday)
                                       {
                                           gs.GA_AOR_Group_Segment_Id__c=gsIdaorGsMap.get(Key).Id;
                                           gs.GA_Servicing_Agent__c=gsIdaorGsMap.get(Key).GA_ProcessAgentId__c;
                                           gs.GA_Is_Mass_Updating__c=true;
                                           processAORGS = New GA_AOR_Group_Segment__c (id = gsIdaorGsMap.get(Key).id,
                                                                                       GA_Is_StartDateProcessed__c = true,
                                                                                       GA_Is_EndDateProcessed__c=false);
                                           processGSLst.add(processAORGS);
                                           if(!gsIdset.contains(gs.id)){
                                               gsIdset.add(gs.id);
                                               gsLstToUpdte.add(gs);
                                           }
                                       }  
                                       
                                   }
                            else{
                                processAORGS = New GA_AOR_Group_Segment__c (id = gsIdaorGsMap.get(Key).id);
                                // processAORGS.addError('Group segment is Active with AOR');
                                processErrGSLst.add(processAORGS.id);
                            }
                            
                            // }
                        }
                    }
                }
            }
            //To nullify the Service Agent Info on GS records.
            GA_Group_Segment__c gsTonull = New GA_Group_Segment__c();
            for(id grpId:grpSgmntEmtyAgnt)
            {
                system.debug('aorGSServicingAgent '+aorGSServicingAgent);
                system.debug('grpsegServicingAgent '+grpsegServicingAgent);
                if(aorGSServicingAgent.get(grpId)!=null && grpsegServicingAgent.get(grpId)!=null && aorGSServicingAgent.get(grpId).substring(0,15).equals(grpsegServicingAgent.get(grpId).substring(0,15)) )
                {
                gsTonull=new GA_Group_Segment__c();
                gsTonull.Id=grpId;
                gsTonull.GA_AOR_Group_Segment_Id__c=null;
                gsTonull.GA_Servicing_Agent__c=null;
                gsTonull.GA_Is_Mass_Updating__c=true;
                if(!gsIdset.contains(gsTonull.id)){
                    gsIdset.add(gsTonull.id);
                    gsLstToUpdte.add(gsTonull);
                 }
                }                
            }
            //To update the Service Agent on GS records.
            if(!gsLstToUpdte.isEmpty())
            {
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
                
                srList = Database.update(gsLstToUpdte,false);
            }
            
            //To update the END DATE on the previous AOR_GS records when a new record is processed.
            set<Id> gsaIdSet = New set<Id>();
            if(processGSLst.size() > 0){
                for(GA_AOR_Group_Segment__c aorGsprc  : processGSLst){
                    if(aorGsprc.Id <> null){
                        gsaIdSet.add(aorGsprc.Id);
                    }
                }
            }
            Set<GA_AOR_Group_Segment__c> aorGsOldrectoupte = new Set<GA_AOR_Group_Segment__c> ();
            GA_AOR_Group_Segment__c aorGsTmp =  New GA_AOR_Group_Segment__c();
            for(id aorGsId:gsIdaorGsMapDate.keySet())
            {
                
                if(!gsaIdSet.contains(aorGsId)){
                    gsaIdSet.add(aorGsId);
                    aorGsTmp = new GA_AOR_Group_Segment__c();
                    aorGsTmp.Id=aorGsId;
                    aorGsTmp.GA_Process_End_Date__c=gsIdaorGsMapDate.get(aorGsId);
                    //  aorGsTmp.GA_Is_StartDateProcessed__c = true;
                    aorGsTmp.GA_Is_EndDateProcessed__c = true;                    
                    aorGsOldrectoupte.add(aorGsTmp);
                }
            }
            
            List<GA_AOR_Group_Segment__c> fnlProcessLst = New List<GA_AOR_Group_Segment__c>();
            
            //Adding the list of Is_StartDateProcessed records to be updated.
            if(  processGSLst.size() > 0){
                fnlProcessLst.addAll(processGSLst);
            }
            
            //Adding the list of Is_EndDateProcessed records to be updated for - Defect 0659
            if(  processEndGSLst.size() > 0){
                fnlProcessLst.addAll(processEndGSLst);
            }
            
            //Adding the list of records to update the END DATES.
            if(aorGsOldrectoupte.size()>0){
                fnlProcessLst.addAll(aorGsOldrectoupte);
            }
            
            //DML operation to update all the records.
            if(fnlProcessLst.size() > 0 && fnlProcessLst.size() < 10001){
                database.update(fnlProcessLst,false);
            }
            /**   if(aorgsOldMap == null){
for(GA_AOR_Group_Segment__c errAor : aorgsLst){
if(processErrGSLst.contains(errAor.id)){

errAor.addError('Group segment is Active with AOR');
}
}
}**/
            
            //Logging Exceptions for the failed records.
            ExceptionLog__c objLog = New ExceptionLog__c();
            if(!srList.isEmpty()){
                for(Database.SaveResult obj : srList){
                    for(Database.Error objErr : obj.getErrors()){
                        if(!obj.isSuccess()){
                            objLog = new ExceptionLog__c(
                                Object_ID__c =obj.getId(),
                                ExceptionDescription__c = objErr.getMessage(),
                                ExceptionCode__c =  String.valueOf(objErr.getStatusCode()),
                                NumberOfTimesOccured__c = OCCURENCE + 1,
                                ExceptionDetails__c = objErr.getMessage(),
                                Severity__c = EXCPSVRTY);
                            excpLst.add(objLog);
                        } 
                    }
                }
            }
            if(!excpLst.isEmpty()){
                Database.upsert(excpLst,false);
            }
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, CLSNAME, METHDNAMESRVCAGNTTOGS);
        }
    }
    
    /*******************************************************************************************************************************
@Description    :  updtDateInfo 
@Name         :   updtDateInfo
@Param         :   List<GA_AOR_Group_Segment__c> aorGsList
@Return       :   void
@throws Exception   :   N/A;
********************************************************************************************************************************/     
    public static void updtDateInfo(List<GA_AOR_Group_Segment__c> aorGsList,Map<Id,GA_AOR_Group_Segment__c> aorGSoldmap){
        
        try{         
            for(GA_AOR_Group_Segment__c aorGs :aorGsList){
                if(GA_updateAORGSSvcCls.changedSrvEndtLogic ){
                    if(GA_updateAORGSSvcCls.aorSrvEndDtMap.Keyset().contains(aorGs.GA_AOR_Id__c)){
                        aorGs.GA_Process_Start_Date__c=GA_updateAORGSSvcCls.aorSrvStartDtMap.get(aorGs.GA_AOR_Id__c);
                        if(aorGs.GA_Cancel_Date__c == null){
                            aorGs.GA_Process_End_Date__c=GA_updateAORGSSvcCls.aorSrvEndDtMap.get(aorGs.GA_AOR_Id__c);
                        }
                        else{
                            aorGs.GA_Process_End_Date__c =  aorGs.GA_Cancel_Date__c ;
                        }  
                        
                    }  
                }
                else{
                    aorGs.GA_Process_Start_Date__c=aorGs.GA_Service_Start_Date__c;
                    if(aorGs.GA_Cancel_Date__c == null){
                        aorGs.GA_Process_End_Date__c=aorGs.GA_Service_End_Date__c;
                    }
                    else{
                        aorGs.GA_Process_End_Date__c =  aorGs.GA_Cancel_Date__c ;
                    }
                }
                //aorGs.GA_Process_Agent__c=aorGs.GA_AOR_Agent__c;
            } 
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, CLSNAME, METHDNAMESRVCAGNTTOGS);
        }
    }
    /*******************************************************************************************************************************
@Description    :  updtProcessedFlag 
@Name         :   updtProcessedFlag
@Param         :   List<GA_AOR_Group_Segment__c> aorGsList
@Return       :   void
@throws Exception   :   N/A;
********************************************************************************************************************************/     
    public static void updtProcessedFlag(List<GA_AOR_Group_Segment__c> aorGsList,Map<Id,GA_AOR_Group_Segment__c> aorGSoldmap){
        
        try{         
            for(GA_AOR_Group_Segment__c aorGs :aorGsList){         
                aorGs.GA_Is_EndDateProcessed__c=false;
                aorGs.GA_Is_StartDateProcessed__c=false;          
            } 
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, CLSNAME, METHDNAMESRVCAGNTTOGS);
        }
    }
}