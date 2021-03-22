/*******************************************************************************************************************************
@Author : Raj Jena
@Name: GA_MngngAgncyHstry_AP01_UpdtToGrpSgmnt 
@CreatedDate: 07 - May 2019 
@Description: GA_MngngAgncyHstry_AP01_UpdtToGrpSgmnt class is for updating maHstry History Info on Group Segment.
@version : 1.0  
********************************************************************************************************************************/
public without sharing class GA_MngngAgncyHstry_AP01_UpdtToGrpSgmnt {
    private static final String CLSNAME  = 'GA_MngngAgncyHstry_AP01_UpdtToGrpSgmnt';
    private static final String METHODNME  = 'updtMngngAgncytoGs' ;
    private static final String METHODNME1  = 'doAction' ;
    private static final String METHODNME2  ='updatEndDate';
    private static final integer OCCURENCE = 0;
    private static final String  EXCPSVRTY='ERROR';
    public static  Boolean  endDateExecuting=false;
    private static final string TLT = '~';
    /*********************************************************************************************************************************
@Description    :  updtMngngAgncytoGs 
@Name         :   updtMngngAgncytoGs
@Param         :   List<GA_Managing_Agency_History__c> maList,Map<ID,GA_Managing_Agency_History__c> maOldMap
@Return       :   void
@throws Exception   :   N/A;
********************************************************************************************************************************/ 
    Public static void updtMngngAgncytoGs(List<GA_Managing_Agency_History__c> mahList,Map<ID,GA_Managing_Agency_History__c> mahOldMap)
    {
        try
        {
            List<Database.SaveResult> srList = new List<Database.SaveResult>();
            List<ExceptionLog__c> excpLst = New List<ExceptionLog__c>();
            Map<String,GA_Managing_Agency_History__c> gsIdMAHMap = new Map<String,GA_Managing_Agency_History__c>();
            Set<Id> gsProcessIds = New Set<Id>();
            set<id> grpSgmntEmtyMAH=new set<id>();
            boolean isChnge=false;
            for(GA_Managing_Agency_History__c mah : mahList)
            {
                if(mahOldMap !=null)
                {
                    GA_Managing_Agency_History__c mahOld=mahOldMap.get(mah.Id);
                    if(mahOld.GA_Start_Date__c !=mah.GA_Start_Date__c  
                       || mahOld.GA_End_Date__c !=mah.GA_End_Date__c   
                       || mahOld.MA_Override_Start_Date__c !=mah.MA_Override_Start_Date__c     //d 1880
                       || mahOld.MA_Override_End_Date__c != mah.MA_Override_End_Date__c){
                           isChnge=true;     
                       }
                }
                else
                {
                    isChnge=true;
                }
                if(mah.GA_Start_Date__c  > system.today() && mah.GA_End_Date__c>system.today() && isChnge){ //d 1880 originally: mah.GA_Start_Date__c  <=system.today
                    if(grpSgmntEmtyMAH.contains(mah.GA_Group_Segment__c))
                    {
                        grpSgmntEmtyMAH.remove(mah.GA_Group_Segment__c);
                    }
                    gsIdMAHMap.put(mah.Id +TLT+mah.GA_Group_Segment__c, mah);
                    gsProcessIds.add(mah.GA_Group_Segment__c);
                }
                if(mah.GA_End_Date__c<=system.today() && isChnge){
                    if(!gsIdMAHMap.keyset().contains(mah.Id +TLT+mah.GA_Group_Segment__c))
                    {
                        grpSgmntEmtyMAH.add(mah.GA_Group_Segment__c);
                        gsIdMAHMap.put(mah.Id +TLT+mah.GA_Group_Segment__c, mah);
                        gsProcessIds.add(mah.GA_Group_Segment__c);
                    }
                    
                }
            }
            List<GA_Group_Segment__c> gsLstToUpdt = new List<GA_Group_Segment__c> ();
            Map<id,Date> gsIdMAHMapDate = new Map<id,Date>();
            Set<Id> gsIdset = New Set<Id>();
            //List<GA_Managing_Agency_History__c> processmahLst = New List<GA_Managing_Agency_History__c>();
            Set<GA_Managing_Agency_History__c> processmahLst = New Set<GA_Managing_Agency_History__c>();
            GA_Managing_Agency_History__c processmah = New GA_Managing_Agency_History__c();
            for(GA_Group_Segment__c gs : [select id, GA_Managing_Agency_History_Id__c,GA_Managing_Agency__c,GA_Managing_Agency_History_Id__r.GA_End_Date__c from GA_Group_Segment__c Where Id In : gsProcessIds Limit 10000])
            {
                
                for(String key : gsIdMAHMap.keySet()){
                    if(Key.contains(gs.id)){
                        if(gs.GA_Managing_Agency_History_Id__c !=gsIdMAHMap.get(Key).Id  )
                        { 
                            if( !String.IsEmpty(gs.GA_Managing_Agency_History_Id__c) && gsIdMAHMap.get(Key).GA_Is_Active__c){
                                gsIdMAHMapDate.put(gs.GA_Managing_Agency_History_Id__c,gsIdMAHMap.get(Key).GA_Start_Date__c-1);
                            }
                            
                            if( !String.IsEmpty(gs.GA_Managing_Agency_History_Id__c) && gs.GA_Managing_Agency_History_Id__r.GA_End_Date__c > System.today()  ){
                                grpSgmntEmtyMAH.remove(gs.id);
                            }
                            
                            if(gsIdMAHMap.get(Key).GA_End_Date__c<=system.today() || gsIdMAHMap.get(Key).GA_End_Date__c > system.today() ){
                                processmah = New GA_Managing_Agency_History__c (id = gsIdMAHMap.get(Key).id,
                                                                                GA_Is_Processed__c = true);
                                processmahLst.add(processmah);
                            }
                            if(gsIdMAHMap.get(Key).GA_End_Date__c > system.today())
                            {
                                gs.GA_Managing_Agency_History_Id__c=gsIdMAHMap.get(Key).Id;
                                gs.GA_Managing_Agency__c=gsIdMAHMap.get(Key).GA_Managing_Agency__c;
                                gs.GA_Is_Mass_Updating__c=true;
                                //gsLstToUpdt.add(gs);
                                if(!gsIdset.contains(gs.id)){
                                    gsIdset.add(gs.id);
                                    gsLstToUpdt.add(gs);
                                }
                            }
                            
                        }
                        
                    }
                    else{
                        processmah = New GA_Managing_Agency_History__c (id = gsIdMAHMap.get(Key).id,
                                                                        GA_Is_Processed__c = true);
                        processmahLst.add(processmah);
                    }
                }
                
            }
            
            GA_Group_Segment__c gsTonull=new GA_Group_Segment__c();
            for(id grpId:grpSgmntEmtyMAH)
            {
                gsTonull=new GA_Group_Segment__c();
                gsTonull.Id=grpId;
                gsTonull.GA_Managing_Agency_History_Id__c=null;
                gsTonull.GA_Managing_Agency__c=null;
                gsTonull.GA_Is_Mass_Updating__c=true;
                if(!gsIdset.contains(gsTonull.id)){
                    gsIdset.add(gsTonull.id);
                    gsLstToUpdt.add(gsTonull);
                }
            }
            
            if(!gsLstToUpdt.isEmpty())
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
                srList = Database.update(gsLstToUpdt,false);
            }
            
            set<Id> mahIdSet = New set<Id>();
            if(processmahLst.size() > 0){
                for(GA_Managing_Agency_History__c mahprc  : processmahLst){
                    if(mahprc.id <> null){
                        mahIdSet.add(mahprc.Id);
                    }
                }
            }
            
            Set<GA_Managing_Agency_History__c> mahOldrectoupte = new Set<GA_Managing_Agency_History__c> ();
            GA_Managing_Agency_History__c mahTmp = new GA_Managing_Agency_History__c();
            for(id mahId:gsIdMAHMapDate.keySet())
            {
                if(!mahIdSet.contains(mahId)){
                    mahIdSet.add(mahId);
                    mahTmp = new GA_Managing_Agency_History__c();
                    mahTmp.Id=mahId;
                    mahTmp.GA_End_Date__c=gsIdMAHMapDate.get(mahId);
                    mahTmp.GA_Is_Processed__c = true;
                    mahOldrectoupte.add(mahTmp);
                }
                
            }
            
            List<GA_Managing_Agency_History__c> fnlProcessLst = New List<GA_Managing_Agency_History__c>();
            
            if(  processmahLst.size() > 0){
                fnlProcessLst.addAll(processmahLst);
                
            }
            if(mahOldrectoupte.size()>0) 
            {
                fnlProcessLst.addAll(mahOldrectoupte);
            }
            
            if(fnlProcessLst.size() > 0 && fnlProcessLst.size() < 10001){
                database.update(fnlProcessLst,false);
            }
            
            ExceptionLog__c objLog = new ExceptionLog__c();
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
            GA_LogExceptionCls.LogExcp(e, CLSNAME, METHODNME);
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
            map<id,list<GA_Managing_Agency_History__c>> maHstryRecs=new map<id,list<GA_Managing_Agency_History__c>>();
            list<GA_Managing_Agency_History__c> maHstryTmpLst=new list<GA_Managing_Agency_History__c>();
            list<MaHstryWrapper> maListSrt=new list<MaHstryWrapper>();
            for(GA_Managing_Agency_History__c maHstry:[select id,GA_Start_Date__c,
                                                       GA_End_Date__c,GA_Group_Segment__c, MA_Override_End_Date__c, MA_Override_Start_Date__c
                                                       from GA_Managing_Agency_History__c where GA_Group_Segment__c IN:lstGroupSeg 
                                                       ORDER BY GA_Start_Date__c desc Limit 50000])
            {
                if(maHstryRecs.get(maHstry.GA_Group_Segment__c)!=null)
                {
                    maHstryTmpLst=maHstryRecs.get(maHstry.GA_Group_Segment__c);
                }
                else
                {
                    maHstryTmpLst=new list<GA_Managing_Agency_History__c>();
                }
                maHstryTmpLst.add(maHstry);
                maHstryRecs.put(maHstry.GA_Group_Segment__c,maHstryTmpLst); 
            }
            map<id,list<MaHstryWrapper>> maHstryRecsSrted=new map<id,list<MaHstryWrapper>>();
            MaHstryWrapper maHstryWrapperRec;
            for(id grpId:maHstryRecs.keyset())
            {
                list<GA_Managing_Agency_History__c> maListTemp=maHstryRecs.get(grpId);
                maListSrt=new list<MaHstryWrapper>();
                for(GA_Managing_Agency_History__c maHstryTemp:maListTemp)
                {
                    maHstryWrapperRec=new MaHstryWrapper(maHstryTemp);
                    maListSrt.add(maHstryWrapperRec);
                }
                maListSrt.sort();
                maHstryRecsSrted.put(grpId,maListSrt); 
                system.debug(' maHstryRecsSrted=' +  maHstryRecsSrted);
            }
            list<MaHstryWrapper> maHstryWrprList=new list<MaHstryWrapper>();
            list<GA_Managing_Agency_History__c> maListToupte=new list<GA_Managing_Agency_History__c>();
            GA_Managing_Agency_History__c maHstryTmp = new GA_Managing_Agency_History__c();
            for(id grpId:maHstryRecsSrted.keyset())
            {
                maHstryWrprList=maHstryRecsSrted.get(grpId);
                for(integer i=0;i<maHstryRecsSrted.get(grpId).size()-1;i++){
                    maHstryTmp = new GA_Managing_Agency_History__c();
                    if(maHstryWrprList[i].maHstry.GA_End_Date__c >= maHstryWrprList[i+1].maHstry.GA_Start_Date__c)
                    {
                        maHstryTmp.Id=maHstryWrprList[i].maHstry.Id;
                        maHstryTmp.GA_End_Date__c=maHstryWrprList[i+1].maHstry.GA_Start_Date__c-1;
                        maHstryTmp.MA_Override_End_Date__c=maHstryWrprList[i+1].maHstry.MA_Override_Start_Date__c-1; // D 1880
                        maListToupte.add(maHstryTmp);
                    }
                }
            }
            system.debug('hello' + maListToupte);
            if(!maListToupte.isEmpty() && maListToupte.size()<10001){
                Database.update(maListToupte);  //update maListToupte;
                system.debug('hello' + maListToupte);
            }  
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, CLSNAME, METHODNME1);
        }
    }    
    /*******************************************************************************************************************************
@Description    :  updatEndDate 
@Name         :   updatEndDate
@Param         :  List<GA_Managing_Agency_History__c> newList
@Return       :   void
@throws Exception   :   N/A;
********************************************************************************************************************************/     
    public static void updatEndDate(List<GA_Managing_Agency_History__c> newList){
        try{
            endDateExecuting = true;
            set<Id> setGroupSeg = new Set<Id>();
            for(GA_Managing_Agency_History__c obj : newList){
                if(obj.GA_Group_Segment__c <> null){
                    setGroupSeg.add(obj.GA_Group_Segment__c);
                }
            }        
            doAction(setGroupSeg); 
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, CLSNAME, METHODNME2);
        }
    }
    /*******************************************************************************************************************************
@Description    :  MaHstryWrapper 
@Name         :   MaHstryWrapper
@Param         :   N/A
@Return       :   void
@throws Exception   :   N/A;
*******************************************************************************************************************************/
    public without sharing class MaHstryWrapper implements Comparable {        
        public GA_Managing_Agency_History__c maHstry;
     /**
    @Description: Constructor method 
    @Name : MaHstryWrapper
    @Param : GA_Managing_Agency_History__c maHstryTmp
    @Return : void
    @throws Exception : N/A;
    **/        
        public MaHstryWrapper(GA_Managing_Agency_History__c maHstryTmp) {
            maHstry = maHstryTmp;
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
                MaHstryWrapper compareTomaHstry = (MaHstryWrapper)compareTo;
                // The return value of 0 indicates that both elements are equal.
                Integer returnValue = 0;
                if (maHstry.GA_Start_Date__c > compareTomaHstry.maHstry.GA_Start_Date__c) {
                    // Set return value to a positive value.
                    returnValue = 1;
                } else{
                    if (maHstry.GA_Start_Date__c < compareTomaHstry.maHstry.GA_Start_Date__c) {
                        // Set return value to a negative value.
                        returnValue = -1;
                    } 
                } 
                return returnValue;
            }
            catch(Exception excpDtl){
                return null;
            }
        }
    }    
}