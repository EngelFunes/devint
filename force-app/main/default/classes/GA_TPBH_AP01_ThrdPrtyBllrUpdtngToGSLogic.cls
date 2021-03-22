/*******************************************************************************************************************************
@Author : Dilip Junapala
@Name: GA_TPBH_AP01_ThrdPrtyBllrUpdtngToGSLogic 
@CreatedDate: 21 - Sep 2018 
@Description: GA_TPBH_AP01_ThrdPrtyBllrUpdtngToGSLogic class is for updating Third Party Biller to in Group Segment.
@version : 1.0  
********************************************************************************************************************************/
public without sharing class GA_TPBH_AP01_ThrdPrtyBllrUpdtngToGSLogic {
    public Static Final String CLSNAME  = 'GA_TPBH_AP01_ThrdPrtyBllrUpdtngToGSLogic';
    public Static Final String METHODNME  = 'updatetThirdPartyBillrToGS' ;
    public Static Final String METHODNME1  = 'doAction' ;
    public Static Final String METHODNME2  = 'updatEndDate' ;
    public Static Final String UPDATETPBTOGSBFRE  = 'updateTPBtoGSBfre' ;
    public static final integer OCCURENCE = 0;
    public static final String  EXCPSVRTY='ERROR';
    public Static  boolean isExecuting=false;
    public static final String  SYSOFREC='SMART';
    public static  Boolean  endDateExecuting=false;
    public static final String TILDEOP='~';
    public static final String EXCPCODE = 'TPBH PROCESSING';
    /*******************************************************************************************************************************
@Description    :  updatetThirdPartyBillrToGS 
@Name         :   updatetThirdPartyBillrToGS
@Param         :   List<GA_Third_Party_Biller_History__c> tPDList
@Return       :   void
@throws Exception   :   N/A;
*******************************************************************************************************************************/ 
    Public static void updatetThirdPartyBillrToGS(List<GA_Third_Party_Biller_History__c> tPBList,Map<ID,GA_Third_Party_Biller_History__c> tpbOldMap)
    {
        try
        {
            List<Database.SaveResult> srList = new List<Database.SaveResult>();
            List<ExceptionLog__c> excpLst = New List<ExceptionLog__c>();
            Map<String,GA_Third_Party_Biller_History__c> gsIdThrdPryBllrMap = new Map<String,GA_Third_Party_Biller_History__c>();
            Set<Id> grpIds = New Set<Id>();
            boolean isChnge=false;
            for(GA_Third_Party_Biller_History__c tp : tPBList)
            {
                if(tpbOldMap !=null)
                {
                    GA_Third_Party_Biller_History__c tpbOld=tpbOldMap.get(tp.Id);
                    if(tpbOld.GA_TPB_Start_Date__c !=tp.GA_TPB_Start_Date__c  
                       || tpbOld.GA_TPB_End_Date__c !=tp.GA_TPB_End_Date__c){
                           isChnge=true;     
                       }
                }
                
                else
                {
                    isChnge=true;
                }
                
                if(tp.GA_TPB_Start_Date__c  <=system.today() && tp.GA_TPB_End_Date__c>system.today()&& tp.GA_System_Of_Record__c !=SYSOFREC && isChnge){
                    gsIdThrdPryBllrMap.put(tp.GA_Group_Segment_Id__c+TILDEOP+tp.id, tp);
                    grpIds.add(tp.GA_Group_Segment_Id__c);
                    
                }
                
                if( (tp.GA_TPB_End_Date__c   <= system.today() ) && tp.GA_System_Of_Record__c !=SYSOFREC && isChnge){
                    if(!gsIdThrdPryBllrMap.keyset().contains(tp.GA_Group_Segment_Id__c+TILDEOP+tp.id))
                    {
                        gsIdThrdPryBllrMap.put(tp.GA_Group_Segment_Id__c+TILDEOP+tp.id, tp);
                        grpIds.add(tp.GA_Group_Segment_Id__c);
                    }
                    
                }
            }
            List<GA_Group_Segment__c> gsLstToUpdte = new List<GA_Group_Segment__c> ();
            Set<GA_Third_Party_Biller_History__c> tpbHstryEndDtelst=new Set<GA_Third_Party_Biller_History__c>();
            Set<GA_Third_Party_Biller_History__c> tpbHstryPrcsslst=new Set<GA_Third_Party_Biller_History__c>();
            Set<Id> gsIdset = New Set<Id>();
            Map<id,Date> gsIdTPBHMapDate = new Map<id,Date>();
            boolean tphChnged=false;
            GA_Third_Party_Biller_History__c procssTPHB= New GA_Third_Party_Biller_History__c();
            for(GA_Group_Segment__c gs : [select id, GA_Third_Party_Biller_History__c,GA_Third_Party_Biller_Account__c,
                                          GA_GSA_Start_Date__c,GA_Group_Association_id__c,GA_TPB_Start_Date__c,GA_Third_Party_Biller_History__r.GA_TPB_End_Date__c
                                          from GA_Group_Segment__c 
                                          Where Id In : grpIds Limit 10000])
            {
                for(String Key : gsIdThrdPryBllrMap.keySet()){
                    if(Key.contains(gs.id) && ((gs.GA_Third_Party_Biller_History__c !=gsIdThrdPryBllrMap.get(Key).Id))
                       || (gs.GA_Third_Party_Biller_History__c ==gsIdThrdPryBllrMap.get(Key).Id)){
                           
                           
                           if(gs.GA_Third_Party_Biller_History__c <> null && gsIdThrdPryBllrMap.get(Key).GA_Is_Active__c){
                               gsIdTPBHMapDate.put(gs.GA_Third_Party_Biller_History__c,gsIdThrdPryBllrMap.get(Key).GA_TPB_Start_Date__c-1);
                           }
                           
                           if(gsIdThrdPryBllrMap.get(Key).GA_TPB_End_Date__c <= System.today())   
                           {
                               if(gs.GA_Third_Party_Biller_History__c!=null && gs.GA_Third_Party_Biller_History__r.GA_TPB_End_Date__c <= System.today() )
                               {
                                   tphChnged=true;
                               }
                               if(tphChnged)
                               {
                                   gs.GA_Third_Party_Biller_History__c =null; 
                                   gs.GA_Third_Party_Biller_Account__c=null;
                                   gs.GA_Is_Mass_Updating__c=true;   
                                   
                                   
                               }
                               
                           }
                           else
                           {
                               gs.GA_Third_Party_Biller_History__c =gsIdThrdPryBllrMap.get(Key).id;
                               gs.GA_Third_Party_Biller_Account__c=gsIdThrdPryBllrMap.get(Key).GA_Third_Party_Biller_Account__c;
                               gs.GA_Is_Mass_Updating__c=true;
                               tphChnged=true;
                           }
                           
                           if(tphChnged){
                               if(!gsIdset.contains(gs.id)){
                                   gsIdset.add(gs.id);
                                   gsLstToUpdte.add(gs);
                               }
                               
                               
                           }
                           
                           procssTPHB = New GA_Third_Party_Biller_History__c (
                               id =gsIdThrdPryBllrMap.get(Key).Id,
                               GA_Is_Processed__c = true);
                           tpbHstryPrcsslst.add(procssTPHB);
                           
                       }
                    else{
                        procssTPHB = New GA_Third_Party_Biller_History__c (
                            id =gsIdThrdPryBllrMap.get(Key).Id,
                            GA_Is_Processed__c = true);
                        tpbHstryPrcsslst.add(procssTPHB);
                    }
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
                GA_ExternalAppealRecdCrtnUpdt.isExecuting = true; 
                
                srList = Database.update(gsLstToUpdte,false);
            }
            
            set<Id> tpbhIdSet = New set<Id>();
            if(tpbHstryPrcsslst.size() > 0){
                for(GA_Third_Party_Biller_History__c tpbhprc  : tpbHstryPrcsslst){
                    if(tpbhprc.id <> null){
                        tpbhIdSet.add(tpbhprc.id);
                    }
                }
            }
            
            List<GA_Third_Party_Biller_History__c> assntnOldrectoupte = new List<GA_Third_Party_Biller_History__c> ();
            GA_Third_Party_Biller_History__c tphtoupt = New GA_Third_Party_Biller_History__c();
            if(gsIdTPBHMapDate.size() > 0){
                for(id tphbId: gsIdTPBHMapDate.keySet())
                {
                    if(!tpbhIdSet.contains(tphbId)){
                        tpbhIdSet.add(tphbId);
                        tphtoupt = new GA_Third_Party_Biller_History__c();
                        tphtoupt.Id=tphbId;
                        tphtoupt.GA_TPB_End_Date__c=gsIdTPBHMapDate.get(tphbId);
                        tphtoupt.GA_Is_Processed__c = true;
                        tphtoupt.GA_Is_Mass_Updating__c=true;
                        tpbHstryEndDtelst.add(tphtoupt);     
                        
                    }
                    
                }    
            }
            
            List<GA_Third_Party_Biller_History__c> finlPrcssLst = New  List<GA_Third_Party_Biller_History__c>();
            
            if(tpbHstryPrcsslst.size() > 0){
                finlPrcssLst.addAll(tpbHstryPrcsslst);
            }
            
            if(tpbHstryEndDtelst.size()>0)
            {
                finlPrcssLst.addAll(tpbHstryEndDtelst);
            }
            
            if(finlPrcssLst.size() > 0 && finlPrcssLst.size() < 10001){
                database.update(finlPrcssLst,false);
            }
            ExceptionLog__c objLog = new ExceptionLog__c();
            
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
            isExecuting=true;
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, CLSNAME, METHODNME);
        }
    }
    /*******************************************************************************************************************************
@Description    :  doAction 
@Name         :   doAction
@Param         :   set<ID> grpSgmntId
@Return       :   void
@throws Exception   :   N/A;
*******************************************************************************************************************************/     
    public static void doAction(set<ID> grpSgmntId){
        try{
            
            map<id,list<GA_Third_Party_Biller_History__c>> grptpbhRecs=new map<id,list<GA_Third_Party_Biller_History__c>>();
            list<GA_Third_Party_Biller_History__c> tpbhTmpLst=new list<GA_Third_Party_Biller_History__c>();
            list<TpbhWrapper> tpbhLstSrt=new list<TpbhWrapper>();
            for(GA_Third_Party_Biller_History__c tpbh:[select id,GA_TPB_Start_Date__c,
                                                       GA_TPB_End_Date__c,GA_Group_Segment_Id__c
                                                       from GA_Third_Party_Biller_History__c 
                                                       where GA_Group_Segment_Id__c IN:grpSgmntId
                                                       ORDER BY GA_TPB_Start_Date__c desc Limit 50000])
            {
                if(grptpbhRecs.get(tpbh.GA_Group_Segment_Id__c)!=null)
                {
                    tpbhTmpLst=grptpbhRecs.get(tpbh.GA_Group_Segment_Id__c);
                }
                else
                {
                    tpbhTmpLst=new list<GA_Third_Party_Biller_History__c>();
                }
                tpbhTmpLst.add(tpbh);
                grptpbhRecs.put(tpbh.GA_Group_Segment_Id__c,tpbhTmpLst); 
            }
            
            map<id,list<TpbhWrapper>> grptpbhRecsSrted=new map<id,list<TpbhWrapper>>();
            TpbhWrapper tpbhWrapperRec;
            for(id grpId:grptpbhRecs.keyset())
            {
                list<GA_Third_Party_Biller_History__c> tpbhLstTemp=grptpbhRecs.get(grpId);
                tpbhLstSrt=new list<TpbhWrapper>();
                for(GA_Third_Party_Biller_History__c tpbhTemp:tpbhLstTemp)
                {
                    tpbhWrapperRec=new TpbhWrapper(tpbhTemp);
                    tpbhLstSrt.add(tpbhWrapperRec);
                }
                tpbhLstSrt.sort();
                grptpbhRecsSrted.put(grpId,tpbhLstSrt); 
                
            }
            
            list<TpbhWrapper> tpbLst=new list<TpbhWrapper>();
            list<GA_Third_Party_Biller_History__c> tpbLstToupte=new list<GA_Third_Party_Biller_History__c>();
            GA_Third_Party_Biller_History__c tpbTmp = new GA_Third_Party_Biller_History__c();
            for(id grpId:grptpbhRecsSrted.keyset())
            {
                tpbLst=grptpbhRecsSrted.get(grpId);
                for(integer i=0;i<grptpbhRecsSrted.get(grpId).size()-1;i++){
                    tpbTmp = new GA_Third_Party_Biller_History__c();
                    if(tpbLst[i].tpbh.GA_TPB_End_Date__c >= tpbLst[i+1].tpbh.GA_TPB_Start_Date__c)
                    {
                        tpbTmp.Id=tpbLst[i].tpbh.Id;
                        tpbTmp.GA_TPB_End_Date__c=tpbLst[i+1].tpbh.GA_TPB_Start_Date__c-1;
                        tpbTmp.GA_Is_Mass_Updating__c=true;
                        tpbLstToupte.add(tpbTmp);
                    }
                }
            }
            
            if(!tpbLstToupte.isEmpty() && tpbLstToupte.size()<10001){
                database.update(tpbLstToupte);
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
@Param         :   List<GA_Third_Party_Biller_History__c> newList
@Return       :   void
@throws Exception   :   N/A;
*******************************************************************************************************************************/     
    public static void updatEndDate(List<GA_Third_Party_Biller_History__c> newList){
        try{
            endDateExecuting = true;
            set<Id> setGroupSeg = new Set<Id>();
            for(GA_Third_Party_Biller_History__c obj : newList){
                if(obj.GA_Group_Segment_Id__c<> null){
                    setGroupSeg.add(obj.GA_Group_Segment_Id__c);
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
@Description    :  TpbhWrapper 
@Name         :   TpbhWrapper
@Param         :   N/A
@Return       :   void
@throws Exception   :   N/A;
*******************************************************************************************************************************/     
    public without sharing class TpbhWrapper implements Comparable {
        public GA_Third_Party_Biller_History__c tpbh;
        /**
@Description: Constructor method 
@Name : TpbhWrapper
@Param : GA_Third_Party_Biller_History__c tpbhTmp
@Return : void
@throws Exception : N/A;
**/ 
        public TpbhWrapper(GA_Third_Party_Biller_History__c tpbhTmp) {
            tpbh = tpbhTmp;
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
                TpbhWrapper compareToTpbh = (TpbhWrapper)compareTo;
                // The return value of 0 indicates that both elements are equal.
                Integer returnValue = 0;
                if (tpbh.GA_TPB_Start_Date__c > compareToTpbh.tpbh.GA_TPB_Start_Date__c) {
                    // Set return value to a positive value.
                    returnValue = 1;
                } else {
                    if (tpbh.GA_TPB_Start_Date__c < compareToTpbh.tpbh.GA_TPB_Start_Date__c) {
                        // Set return value to a negative value.
                        returnValue = -1;
                    }
                }
                return returnValue; 
            }
            catch(Exception excpDtls){
                return null;
            }
        }
    }
}