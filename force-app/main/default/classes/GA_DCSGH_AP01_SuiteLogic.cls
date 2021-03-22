/*******************************************************************************************************************************
@Author : Dilip Junapala
@Name: GA_DCSGH_AP01_SuiteLogic 
@CreatedDate: 20 - Sep 2018 
@Description: GA_DCSGH_AP01_SuiteLogic class is for updating Suite in Group Segment.
@version : 1.0  
********************************************************************************************************************************/
public without sharing class  GA_DCSGH_AP01_SuiteLogic {
    public Static Final String CLSNAME  = 'GA_DCSGH_AP01_SuiteLogic';
    public static boolean isExecuting=false;
    public Static Final String METHODNME = 'doAction';
    public Static Final String METHODNME1 = 'updatEndDate';
    public Static Final String METHODNMEUPDATESUITEINFOTOGS = 'updateSuiteInfoToGS';
    public Static Final integer OCCURENCE = 0;
    public Static Final String  EXCPSVRTY='ERROR';
    public static  Boolean  endDateExecuting=false;
    public static final String  TILTOPRTR='~';
    /*******************************************************************************************************************************
@Description    :   doAction
@Name         :   doAction
@Param         :   set<ID> grpSgmntId
@Return       :   void
@throws Exception   :   N/A;
********************************************************************************************************************************/    
    public static void doAction(set<ID> grpSgmntId){
        try{
            /**  List<GA_DC_Small_Grp_History__c> dcSmlGrpLst = [select id,GA_Suite_Start_Date__c   ,
GA_Suite_End_Date__c,GA_Group_Segment_Id__c
from GA_DC_Small_Grp_History__c 
where GA_Group_Segment_Id__c IN:grpSgmntId
ORDER BY GA_Suite_Start_Date__c desc Limit 50000];**/
            map<id,list<GA_DC_Small_Grp_History__c>> grpdcRecs=new map<id,list<GA_DC_Small_Grp_History__c>>();
            list<GA_DC_Small_Grp_History__c> dcTmpLst=new list<GA_DC_Small_Grp_History__c>();
            list<dcSmlGrpWrapper> dcSmlLstSrt=new list<dcSmlGrpWrapper>();
            for(GA_DC_Small_Grp_History__c dcSml:[select id,GA_Suite_Start_Date__c  ,
                                                  GA_Suite_End_Date__c,GA_Group_Segment_Id__c
                                                  from GA_DC_Small_Grp_History__c 
                                                  where GA_Group_Segment_Id__c IN:grpSgmntId
                                                  ORDER BY GA_Suite_Start_Date__c desc Limit 50000])
            {
                if(grpdcRecs.get(dcSml.GA_Group_Segment_Id__c)!=null)
                {
                    dcTmpLst=grpdcRecs.get(dcSml.GA_Group_Segment_Id__c);
                }
                else
                {
                    dcTmpLst=new list<GA_DC_Small_Grp_History__c>();
                }
                dcTmpLst.add(dcSml);
                grpdcRecs.put(dcSml.GA_Group_Segment_Id__c,dcTmpLst); 
            }
            map<id,list<dcSmlGrpWrapper>> grpdcRecsSrted=new map<id,list<dcSmlGrpWrapper>>();
            for(id grpId:grpdcRecs.keyset())
            {
                list<GA_DC_Small_Grp_History__c> dcSmlLstTemp=grpdcRecs.get(grpId);
                dcSmlLstSrt=new list<dcSmlGrpWrapper>();
                dcSmlGrpWrapper dcSmlGrpWrapperRec;
                for(GA_DC_Small_Grp_History__c dcSmlTemp:dcSmlLstTemp)
                {
                    dcSmlGrpWrapperRec=new dcSmlGrpWrapper(dcSmlTemp);
                    dcSmlLstSrt.add(dcSmlGrpWrapperRec);
                }
                dcSmlLstSrt.sort();
                grpdcRecsSrted.put(grpId,dcSmlLstSrt); 
                
            }
            list<dcSmlGrpWrapper> dcWrprLst=new list<dcSmlGrpWrapper>();
            list<GA_DC_Small_Grp_History__c> dcWrprLstToupte=new list<GA_DC_Small_Grp_History__c>();
            GA_DC_Small_Grp_History__c dcTmp = New GA_DC_Small_Grp_History__c();
            for(id grpId:grpdcRecsSrted.keyset())
            {
                dcWrprLst=grpdcRecsSrted.get(grpId);
                
                for(integer i=0;i<grpdcRecsSrted.get(grpId).size()-1;i++){
                    dcTmp = new GA_DC_Small_Grp_History__c();
                    if(dcWrprLst[i].dcSml.GA_Suite_End_Date__c  >= dcWrprLst[i+1].dcSml.GA_Suite_Start_Date__c)
                    {
                        dcTmp.Id=dcWrprLst[i].dcSml.Id;
                        dcTmp.GA_Suite_End_Date__c=dcWrprLst[i+1].dcSml.GA_Suite_Start_Date__c-1;
                        dcWrprLstToupte.add(dcTmp);
                    }
                }
            }
            
            if(!dcWrprLstToupte.isEmpty() && dcWrprLstToupte.size()<10001){
                database.update(dcWrprLstToupte);
            }  
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, CLSNAME, METHODNME);
        }
    }    
    /*******************************************************************************************************************************
@Description    :   updatEndDate
@Name         :   updatEndDate
@Param         :   List<GA_DC_Small_Grp_History__c> newList
@Return       :   void
@throws Exception   :   N/A;
********************************************************************************************************************************/    
    public static void updatEndDate(List<GA_DC_Small_Grp_History__c> newList){
        try{
            endDateExecuting = true;
            set<Id> setGroupSeg = new Set<Id>();
            for(GA_DC_Small_Grp_History__c obj : newList){
                if(obj <> null){
                    setGroupSeg.add(obj.GA_Group_Segment_Id__c);
                }
            }        
            doAction(setGroupSeg);
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, CLSNAME, METHODNME1);
        }
    }
    /*******************************************************************************************************************************
@Description    :  dcSmlGrpWrapper 
@Name         :   dcSmlGrpWrapper
@Param         :   N/A
@Return       :   void
@throws Exception   :   N/A;
*******************************************************************************************************************************/
    public without sharing class dcSmlGrpWrapper implements Comparable {
        
        public GA_DC_Small_Grp_History__c dcSml;
        
        /**
@Description: Constructor method 
@Name : dcSmlGrpWrapper
@Param : GA_DC_Small_Grp_History__c dcTmp
@Return : void
@throws Exception : N/A;
**/  
        public dcSmlGrpWrapper(GA_DC_Small_Grp_History__c dcTmp) {
            dcSml = dcTmp;
        }
        /**
@Description: compareTo() method 
@Name : compareTo
@Param : Object compareTo
@Return : void
@throws Exception : N/A;
*/    
        public Integer compareTo(Object compareTo) {
            try{
                dcSmlGrpWrapper compareTodc = (dcSmlGrpWrapper)compareTo;
                
                // The return value of 0 indicates that both elements are equal.
                Integer returnValue = 0;
                if (dcSml.GA_Suite_Start_Date__c > compareTodc.dcSml.GA_Suite_Start_Date__c) {
                    // Set return value to a positive value.
                    returnValue = 1;
                } 
                if (dcSml.GA_Suite_Start_Date__c < compareTodc.dcSml.GA_Suite_Start_Date__c) {
                    // Set return value to a negative value.
                    returnValue = -1;
                }
                
                return returnValue;    
            }
            catch(Exception excpDtl) {
                return null;
            }
        }
    }
    /*******************************************************************************************************************************
@Description    :   updateSuiteInfoToGS
@Name         :   updateSuiteInfoToGS
@Param         :   List<GA_DC_Small_Grp_History__c> dcSmlList,Map<ID,GA_DC_Small_Grp_History__c> dcOldMap
@Return       :   void
@throws Exception   :   N/A;
********************************************************************************************************************************/  
    Public static void updateSuiteInfoToGS(List<GA_DC_Small_Grp_History__c> dcSmlList,Map<ID,GA_DC_Small_Grp_History__c> dcOldMap)
    {
        try
        {
            List<Database.SaveResult> srList = new List<Database.SaveResult>();
            List<ExceptionLog__c> excpLst = New List<ExceptionLog__c>();
            Map<String,GA_DC_Small_Grp_History__c> gsIdDcSmlMap = new Map<String,GA_DC_Small_Grp_History__c>();
            Set<Id> grpSegmentProcessIds = New Set<Id>();
            set<id> grpSgmntEmtyDc=new set<id>();
            boolean isChnge=false;
            for(GA_DC_Small_Grp_History__c dcSmlGrp : dcSmlList)
            {
                if(dcOldMap !=null)
                {
                    GA_DC_Small_Grp_History__c dcOld=dcOldMap.get(dcSmlGrp.Id);
                    if(dcOld.GA_Suite_Start_Date__c !=dcSmlGrp.GA_Suite_Start_Date__c  
                       || dcOld.GA_Suite_End_Date__c !=dcSmlGrp.GA_Suite_End_Date__c){
                           isChnge=true;     
                       }
                }
                else
                {
                    isChnge=true;
                }
                if(dcSmlGrp.GA_Suite_Start_Date__c  <=system.today() && dcSmlGrp.GA_Suite_End_Date__c>system.today() && isChnge){
                    if(grpSgmntEmtyDc.contains(dcSmlGrp.GA_Group_Segment_Id__c))
                    {
                        grpSgmntEmtyDc.remove(dcSmlGrp.GA_Group_Segment_Id__c);
                    }
                    gsIdDcSmlMap.put(dcSmlGrp.Id +TILTOPRTR+dcSmlGrp.GA_Group_Segment_Id__c, dcSmlGrp);
                    grpSegmentProcessIds.add(dcSmlGrp.GA_Group_Segment_Id__c);
                }
                if(dcSmlGrp.GA_Suite_End_Date__c<=system.today() && isChnge){
                    if(!gsIdDcSmlMap.keyset().contains(dcSmlGrp.Id +TILTOPRTR+dcSmlGrp.GA_Group_Segment_Id__c))
                    {
                        grpSgmntEmtyDc.add(dcSmlGrp.GA_Group_Segment_Id__c);
                        gsIdDcSmlMap.put(dcSmlGrp.Id +TILTOPRTR+dcSmlGrp.GA_Group_Segment_Id__c, dcSmlGrp);
                        grpSegmentProcessIds.add(dcSmlGrp.GA_Group_Segment_Id__c);
                    }
                    
                }
            }
            List<GA_Group_Segment__c> gsLstToUpdte = new List<GA_Group_Segment__c> ();
            Set<Id> gsIdset = New Set<Id>();
            Map<id,Date> gsIdDcSmlMapDate = new Map<id,Date>();
            GA_DC_Small_Grp_History__c processDcSml = New GA_DC_Small_Grp_History__c();
            system.debug('grpSegmentProcessIds:'+grpSegmentProcessIds);
            //List<GA_DC_Small_Grp_History__c> processDCLst = New List<GA_DC_Small_Grp_History__c>();
            Set<GA_DC_Small_Grp_History__c> processDCLst = New Set<GA_DC_Small_Grp_History__c>();
            for(GA_Group_Segment__c gs : [select id, GA_DC_Small_Group_History_Id__c,GA_Suite__c,GA_DC_Small_Group_History_Id__r.GA_Suite_End_Date__c from GA_Group_Segment__c Where Id In : grpSegmentProcessIds Limit 10000])
            {
                
                for(String key : gsIdDcSmlMap.keySet()){
                    if(Key.contains(gs.id)){
                        if(gs.GA_DC_Small_Group_History_Id__c !=gsIdDcSmlMap.get(Key).Id  )
                        { 
                            if( !String.IsEmpty(gs.GA_DC_Small_Group_History_Id__c) && gsIdDcSmlMap.get(Key).GA_Is_Active__c){
                                gsIdDcSmlMapDate.put(gs.GA_DC_Small_Group_History_Id__c,gsIdDcSmlMap.get(Key).GA_Suite_Start_Date__c-1);
                            }
                            
                            if( !String.IsEmpty(gs.GA_DC_Small_Group_History_Id__c) && gs.GA_DC_Small_Group_History_Id__r.GA_Suite_End_Date__c > System.today()  ){
                                grpSgmntEmtyDc.remove(gs.id);
                            }
                            
                            
                            if(gsIdDcSmlMap.get(Key).GA_Suite_End_Date__c<=system.today() || gsIdDcSmlMap.get(Key).GA_Suite_End_Date__c > system.today() ){
                                processDcSml = New GA_DC_Small_Grp_History__c (id = gsIdDcSmlMap.get(Key).id,
                                                                               GA_Is_Processed__c = true);
                                processDCLst.add(processDcSml);
                                system.debug('processDCLst:'+processDCLst);
                            }
                            if(gsIdDcSmlMap.get(Key).GA_Suite_End_Date__c > system.today())
                            {
                                gs.GA_DC_Small_Group_History_Id__c=gsIdDcSmlMap.get(Key).Id;
                                gs.GA_Suite__c=gsIdDcSmlMap.get(Key).GA_Suite__c;
                                gs.GA_Is_Mass_Updating__c=true;
                                if(!gsIdset.contains(gs.id)){
                                    gsIdset.add(gs.id);
                                    gsLstToUpdte.add(gs);                                    
                                }
                            }
                            
                        }
                        else{
                            if (gsIdDcSmlMap.get(Key).GA_Suite_End_Date__c > system.today())
							{
								processDcSml = New GA_DC_Small_Grp_History__c (id = gsIdDcSmlMap.get(Key).id,GA_Is_Processed__c = false);
							}
							else							
							{
							
							    processDcSml = New GA_DC_Small_Grp_History__c (id = gsIdDcSmlMap.get(Key).id,GA_Is_Processed__c = true);
							}
                            processDCLst.add(processDcSml);
                        }
                    }
                }
            }
            
            GA_Group_Segment__c gsTonull = New GA_Group_Segment__c();
            
            for(id grpId:grpSgmntEmtyDc)
            {
                gsTonull=new GA_Group_Segment__c();
                gsTonull.Id=grpId;
                gsTonull.GA_DC_Small_Group_History_Id__c=null;
                gsTonull.GA_Suite__c=null;
                gsTonull.GA_Is_Mass_Updating__c=true;
                if(!gsIdset.contains(gsTonull.id)){
                    gsIdset.add(gsTonull.id);
                    gsLstToUpdte.add(gsTonull);
                    system.debug('gsLstToUpdte1:'+gsLstToUpdte);
                }
            }
            
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
                
                system.debug('gsLstToUpdte2:'+gsLstToUpdte);
                srList = Database.update(gsLstToUpdte,false);
            }
            
            set<Id> dcIdSet = New set<Id>();
            if(processDCLst.size() > 0){
                for(GA_DC_Small_Grp_History__c dcmprc  : processDCLst){
                    if(dcmprc.id <> null){
                        dcIdSet.add(dcmprc.Id);
                    }
                }
            }
            
            //List<GA_DC_Small_Grp_History__c> dcOldrectoupte = new List<GA_DC_Small_Grp_History__c> ();
            Set<GA_DC_Small_Grp_History__c> dcOldrectoupte = new Set<GA_DC_Small_Grp_History__c> ();
            GA_DC_Small_Grp_History__c dcSmlGrpTmp = New GA_DC_Small_Grp_History__c();
            for(id dcSmlId:gsIdDcSmlMapDate.keySet())
            {
                if(!dcIdSet.contains(dcSmlId)){
                    dcIdSet.add(dcSmlId);
                    dcSmlGrpTmp = new GA_DC_Small_Grp_History__c();
                    dcSmlGrpTmp.Id=dcSmlId;
                    dcSmlGrpTmp.GA_Suite_End_Date__c=gsIdDcSmlMapDate.get(dcSmlId);
                    dcSmlGrpTmp.GA_Is_Processed__c = true;
                    dcOldrectoupte.add(dcSmlGrpTmp);
                }
                
            }
            
            List<GA_DC_Small_Grp_History__c> fnlProcessLst = New List<GA_DC_Small_Grp_History__c>();
            
            if(  processDCLst.size() > 0){
                fnlProcessLst.addAll(processDCLst);
                
            }
            if(dcOldrectoupte.size()>0) 
            {
                fnlProcessLst.addAll(dcOldrectoupte);
            }
            
            if(fnlProcessLst.size() > 0 && fnlProcessLst.size() < 10001){
                database.update(fnlProcessLst,false);
            }
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
            GA_LogExceptionCls.LogExcp(e, CLSNAME, METHODNMEUPDATESUITEINFOTOGS);
        }
    }
}