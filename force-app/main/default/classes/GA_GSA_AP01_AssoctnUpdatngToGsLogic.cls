/*******************************************************************************************************************************
@Author : Dilip Junapala
@Name: GA_GSA_AP01_AssoctnUpdatngToGsLogic 
@CreatedDate: 21 - Sep 2018 
@Description: GA_GSA_AP01_AssoctnUpdatngToGsLogic class is for updating Association in Group Segment logic.
@version : 1.0  
********************************************************************************************************************************/
public without sharing class GA_GSA_AP01_AssoctnUpdatngToGsLogic {
    public static final String CLSNAME  = 'GA_GSA_AP01_AssoctnUpdatngToGsLogic';
    public static final String METHODNMEUPDATEASSTTOGS  = 'updateAssttoGS' ;
    public static final String METHODNMEDDOACTION  = 'doAction' ;
    public static final String METHODNMEUPDATENDDATE  ='updatEndDate';
    public static final integer OCCURENCE = 0;
    public static final String  EXCPSVRTY='ERROR';
    public static final String  SYSOFREC='SMART';
    public static  Boolean  endDateExecuting=false;
    public static final String  TILTOPRTR= '~';
    public static final String EXCPCODE = 'GROUP ASSOCIATION PROCESSING';
    /*******************************************************************************************************************************
@Description    :  updateAssttoGS 
@Name         :   updateAssttoGS
@Param         :   List<GA_Group_Association__c> gAsList
@Return       :   void
@throws Exception   :   N/A;
********************************************************************************************************************************/ 
    Public static void updateAssttoGS(List<GA_Group_Association__c> gAsList,Map<ID,GA_Group_Association__c> gasOldMap)
    {
        try
        {
            List<Database.SaveResult> srList = new List<Database.SaveResult>();
            List<ExceptionLog__c> excpLst = New List<ExceptionLog__c>();
            Map<String,GA_Group_Association__c> gsIdAssotnMap = new Map<String,GA_Group_Association__c>();
            Set<Id> grpSegmentProcessIds = New Set<Id>();
            set<id> grpSgmntEmtyAsstn=new set<id>();
            boolean isChnge=false;
            
            List<GA_Group_Association__c> fltrGSAList = [select id,GA_Group_Segment__c,GA_Account__c,GA_Start_Date__c,GA_End_Date__c,GA_System_Of_Record__c,
                                                         GA_Is_Processed__c,GA_Is_Active__c from GA_Group_Association__c 
                                                         Where GA_Is_Processed__c=false  and GA_System_Of_Record__c !=: SYSOFREC ];
            System.debug(gAsList);
            for(GA_Group_Association__c gas : gAsList)
            {
                if(gasOldMap !=null)
                {
                    GA_Group_Association__c gasOld=gasOldMap.get(gas.Id);
                    if(gasOld.GA_Start_Date__c !=gas.GA_Start_Date__c  
                       || gasOld.GA_End_Date__c !=gas.GA_End_Date__c){
                           isChnge=true;     
                       }
                }
                else
                {
                    isChnge=true;
                }
                if(gas.GA_Start_Date__c  <=system.today() && gas.GA_End_Date__c>system.today() 
                   && gas.GA_System_Of_Record__c !=SYSOFREC && isChnge){
                       if(grpSgmntEmtyAsstn.contains(gas.GA_Group_Segment__c))
                       {
                           grpSgmntEmtyAsstn.remove(gas.GA_Group_Segment__c);
                       }
                       gsIdAssotnMap.put(gas.Id +TILTOPRTR+gas.GA_Group_Segment__c, gas);
                       grpSegmentProcessIds.add(gas.GA_Group_Segment__c);
                   }
                
                if(gas.GA_End_Date__c<=system.today() && gas.GA_System_Of_Record__c !=SYSOFREC && isChnge){
                    if(!gsIdAssotnMap.keyset().contains(gas.Id +TILTOPRTR+gas.GA_Group_Segment__c))
                    {
                        
                        
                        grpSgmntEmtyAsstn.add(gas.GA_Group_Segment__c);
                        gsIdAssotnMap.put(gas.Id +TILTOPRTR+gas.GA_Group_Segment__c, gas);
                        grpSegmentProcessIds.add(gas.GA_Group_Segment__c);
                        
                        
                    }
                    
                }
            }
            
            List<GA_Group_Segment__c> gsLstToUpdte = new List<GA_Group_Segment__c> ();
            Set<Id> gsIdset = New Set<Id>();
            Map<id,Date> gsIdAssotnMapDate = new Map<id,Date>();
            Set<GA_Group_Association__c> processGSLst = New Set<GA_Group_Association__c>();
            GA_Group_Association__c processGSA = New GA_Group_Association__c();
            for(GA_Group_Segment__c gs : [select id, GA_Group_Association_id__c,GA_Association_Id__c,GA_Group_Association_id__r.GA_End_Date__c from GA_Group_Segment__c Where Id In : grpSegmentProcessIds Limit 10000])
            {
                
                for(String key : gsIdAssotnMap.keySet()){
                    if(Key.contains(gs.id)){
                        if(gs.GA_Group_Association_id__c !=gsIdAssotnMap.get(Key).Id  )
                        { 
                            if( !String.IsEmpty(gs.GA_Group_Association_id__c) && gsIdAssotnMap.get(Key).GA_Is_Active__c  ){
                                gsIdAssotnMapDate.put(gs.GA_Group_Association_id__c,gsIdAssotnMap.get(Key).GA_Start_Date__c-1);
                            }
                            if( !String.IsEmpty(gs.GA_Group_Association_id__c) && gs.GA_Group_Association_id__r.GA_End_Date__c > System.today()  ){
                                grpSgmntEmtyAsstn.remove(gs.id);
                            }
                            
                            if(gsIdAssotnMap.get(Key).GA_End_Date__c<=system.today() || gsIdAssotnMap.get(Key).GA_End_Date__c > system.today() ){
                                processGSA = New GA_Group_Association__c (id = gsIdAssotnMap.get(Key).id,
                                                                          GA_Is_Processed__c = true);
                                processGSLst.add(processGSA);
                            }
                            if(gsIdAssotnMap.get(Key).GA_End_Date__c > system.today())
                            {
                                gs.GA_Group_Association_id__c=gsIdAssotnMap.get(Key).Id;
                                gs.GA_Association_Id__c=gsIdAssotnMap.get(Key).GA_Account__c;
                                gs.GA_Is_Mass_Updating__c=true;
                                if(!gsIdset.contains(gs.id)){
                                    gsIdset.add(gs.id);
                                    gsLstToUpdte.add(gs);
                                }
                            }
                            
                        }
                        else{
                            processGSA = New GA_Group_Association__c (id = gsIdAssotnMap.get(Key).id,
                                                                      GA_Is_Processed__c = true);
                            processGSLst.add(processGSA);
                        }
                    }
                }
                
            }
            
            GA_Group_Segment__c gsTonull=new GA_Group_Segment__c();
            for(id grpId:grpSgmntEmtyAsstn)
            {
                gsTonull=new GA_Group_Segment__c();
                gsTonull.Id=grpId;
                gsTonull.GA_Group_Association_id__c=null;
                gsTonull.GA_Association_Id__c=null;
                gsTonull.GA_Is_Mass_Updating__c=true;
                if(!gsIdset.contains(gsTonull.id)){
                    gsIdset.add(gsTonull.id);
                    gsLstToUpdte.add(gsTonull);
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
                GA_ExternalAppealRecdCrtnUpdt.isExecuting = true; 
                
                srList = Database.update(gsLstToUpdte,false);
            }
            
            set<Id> gsaIdSet = New set<Id>();
            if(processGSLst.size() > 0){
                for(GA_Group_Association__c gsaprc  : processGSLst){
                    if(gsaprc.id <> null){
                        gsaIdSet.add(gsaprc.Id);  
                    }
                }
            }
            
            Set<GA_Group_Association__c> assntnOldrectoupte = new Set<GA_Group_Association__c> ();
            GA_Group_Association__c assntionTmp= new GA_Group_Association__c();
            for(id assntnId:gsIdAssotnMapDate.keySet())
            {
                if(!gsaIdSet.contains(assntnId)){
                    gsaIdSet.add(assntnId);
                    assntionTmp = new GA_Group_Association__c();
                    assntionTmp.Id=assntnId;
                    assntionTmp.GA_End_Date__c=gsIdAssotnMapDate.get(assntnId);
                    assntionTmp.GA_Is_Processed__c = true;
                    assntnOldrectoupte.add(assntionTmp);
                }
            }
            
            List<GA_Group_Association__c> fnlProcessLst = New List<GA_Group_Association__c>();
            
            if(  processGSLst.size() > 0){
                fnlProcessLst.addAll(processGSLst);
                
            }
            if(assntnOldrectoupte.size()>0) 
            {
                fnlProcessLst.addAll(assntnOldrectoupte);
            }
            
            if(fnlProcessLst.size() > 0 && fnlProcessLst.size() < 10001){
                database.update(fnlProcessLst,false);
            }
            ExceptionLog__c objLog= new ExceptionLog__c();
            if(!srList.isEmpty()){
                for(Database.SaveResult obj : srList){
                    for(Database.Error objErr : obj.getErrors()){
                        if(!obj.isSuccess()){
                            objLog = new ExceptionLog__c(
                                Object_ID__c =obj.getId(),
                                ExceptionDescription__c = objErr.getMessage(),
                                ExceptionCode__c =  EXCPCODE,
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
            GA_LogExceptionCls.LogExcp(e, CLSNAME, METHODNMEUPDATEASSTTOGS);
        }
    }
    /*******************************************************************************************************************************
@Description    :  doAction 
@Name         :   doAction
@Param         :  Set<Id> lstGroupSeg
@Return       :   void
@throws Exception   :   N/A;
********************************************************************************************************************************/ 
    public static void doAction(Set<Id> lstGroupSeg){
        try{
            
            map<id,list<GA_Group_Association__c>> grpgsaRecs=new map<id,list<GA_Group_Association__c>>();
            list<GA_Group_Association__c> gsaTmpLst=new list<GA_Group_Association__c>();
            list<grpAssocWrapper> gsaLstSrt=new list<grpAssocWrapper>();
            for(GA_Group_Association__c gsa:[select id,GA_Start_Date__c,
                                             GA_End_Date__c,GA_Group_Segment__c
                                             from GA_Group_Association__c where GA_Group_Segment__c IN:lstGroupSeg 
                                             ORDER BY GA_Start_Date__c desc Limit 50000])
            {
                if(grpgsaRecs.get(gsa.GA_Group_Segment__c)!=null)
                {
                    gsaTmpLst=grpgsaRecs.get(gsa.GA_Group_Segment__c);
                }
                else
                {
                    gsaTmpLst=new list<GA_Group_Association__c>();
                }
                gsaTmpLst.add(gsa);
                grpgsaRecs.put(gsa.GA_Group_Segment__c,gsaTmpLst); 
            }
            map<id,list<grpAssocWrapper>> grpgsaRecsSrted=new map<id,list<grpAssocWrapper>>();
            grpAssocWrapper grpAssocWrapperRec;
            
            for(id grpId:grpgsaRecs.keyset())
            {
                list<GA_Group_Association__c> gsaLstTemp=grpgsaRecs.get(grpId);
                gsaLstSrt=new list<grpAssocWrapper>();
                for(GA_Group_Association__c gsaTemp:gsaLstTemp)
                {
                    grpAssocWrapperRec=new grpAssocWrapper(gsaTemp);
                    gsaLstSrt.add(grpAssocWrapperRec);
                }
                gsaLstSrt.sort();
                grpgsaRecsSrted.put(grpId,gsaLstSrt); 
                
            }
            list<grpAssocWrapper> tpbLst=new list<grpAssocWrapper>();
            list<GA_Group_Association__c> gsaLstToupte=new list<GA_Group_Association__c>();
            GA_Group_Association__c gsaTmp = New GA_Group_Association__c();
            for(id grpId:grpgsaRecsSrted.keyset())
            {
                tpbLst=grpgsaRecsSrted.get(grpId);
                for(integer i=0;i<grpgsaRecsSrted.get(grpId).size()-1;i++){
                    gsaTmp = new GA_Group_Association__c();
                    if(tpbLst[i].gsa.GA_End_Date__c >= tpbLst[i+1].gsa.GA_Start_Date__c)
                    {
                        gsaTmp.Id=tpbLst[i].gsa.Id;
                        gsaTmp.GA_End_Date__c=tpbLst[i+1].gsa.GA_Start_Date__c-1;
                        gsaLstToupte.add(gsaTmp);
                    }
                }
            }
            
            if(!gsaLstToupte.isEmpty() && gsaLstToupte.size()<10001){
                database.update(gsaLstToupte);
            }  
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, CLSNAME, METHODNMEDDOACTION);
        }
    }    
    /*******************************************************************************************************************************
@Description    :  updatEndDate 
@Name         :   updatEndDate
@Param         :  List<GA_Group_Association__c> newList
@Return       :   void
@throws Exception   :   N/A;
********************************************************************************************************************************/     
    public static void updatEndDate(List<GA_Group_Association__c> newList){
        try{
            endDateExecuting = true;
            set<Id> setGroupSeg = new Set<Id>();
            for(GA_Group_Association__c obj : newList){
                if(obj <> null){
                    setGroupSeg.add(obj.GA_Group_Segment__c);
                }
            }        
            doAction(setGroupSeg); 
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, CLSNAME, METHODNMEUPDATENDDATE);
        }
    }
    /*******************************************************************************************************************************
@Description    :  grpAssocWrapper 
@Name         :   grpAssocWrapper
@Param         :   N/A
@Return       :   void
@throws Exception   :   N/A;
*******************************************************************************************************************************/
    public without sharing class grpAssocWrapper implements Comparable {
        
        public GA_Group_Association__c gsa;
        
        /**
@Description: Constructor method 
@Name : grpAssocWrapper
@Param : GA_Group_Association__c gsaTmp
@Return : void
@throws Exception : N/A;
**/ 
        public grpAssocWrapper(GA_Group_Association__c gsaTmp) {
            gsa = gsaTmp;
        }
        /**
@Description: compareTo() method 
@Name : compareTo
@Param : Object compareTo
@Return : void
@throws Exception : N/A;
*/       
        public Integer compareTo(Object compareTo) {
            try {
                grpAssocWrapper compareTogsa = (grpAssocWrapper)compareTo;
                
                // The return value of 0 indicates that both elements are equal.
                Integer returnValue = 0;
                if (gsa.GA_Start_Date__c > compareTogsa.gsa.GA_Start_Date__c) {
                    // Set return value to a positive value.
                    returnValue = 1;
                } if (gsa.GA_Start_Date__c < compareTogsa.gsa.GA_Start_Date__c) {
                    // Set return value to a negative value.
                    returnValue = -1;
                }
                
                return returnValue;  
            }
            catch(Exception expcDtls){
                return null;
            }
        }
    }    
}