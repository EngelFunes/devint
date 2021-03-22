/*******************************************************************************************************************************
@Author : Raj Jena
@Name: GA_BCNHstry_AP01_UpdtToGrpSgmnt 
@CreatedDate: 07 - May 2019 
@Description: GA_BCNHstry_AP01_UpdtToGrpSgmnt class is for updating BCN History Info on Group Segment.
@version : 1.0  
********************************************************************************************************************************/
public without sharing class GA_BCNHstry_AP01_UpdtToGrpSgmnt {
    public static final String CLSNAME  = 'GA_BCNHstry_AP01_UpdtToGrpSgmnt';
    public static final String METHODNME  = 'updtBCNtoGs' ;
    public static final String METHODNME1  = 'doAction' ;
    public static final String METHODNME2  ='updatEndDate';
    public static final integer OCCURENCE = 0;
    public static final String  EXCPSVRTY='ERROR';
    public static  Boolean  endDateExecuting=false;
    public static final String  TILTOPRTR='~';
    /*******************************************************************************************************************************
@Description    :  updtBCNtoGs 
@Name         :   updtBCNtoGs
@Param         :   List<GA_Plan_Year_Exception_History__c> bcnLst,Map<ID,GA_Plan_Year_Exception_History__c> bcnOldMap
@Return       :   void
@throws Exception   :   N/A;
********************************************************************************************************************************/ 
    public static void updtBCNtoGs(List<GA_Plan_Year_Exception_History__c> bcnLst,Map<ID,GA_Plan_Year_Exception_History__c> bcnOldMap){
        try{
            List<Database.SaveResult> srList = new List<Database.SaveResult>();
            List<ExceptionLog__c> excpLst = New List<ExceptionLog__c>();
            Map<String,GA_Plan_Year_Exception_History__c> gsIdBCNMap = new Map<String,GA_Plan_Year_Exception_History__c>();
            Set<Id> grpSegmentProcessIds = New Set<Id>();
            set<id> grpSgmntEmtyBCN=new set<id>();
            boolean isChnge=false;
            for(GA_Plan_Year_Exception_History__c bcn : bcnLst){
                
                //Below conditions are to check if there is any change on Date info or not.
                if(bcnOldMap !=null)
                {
                    GA_Plan_Year_Exception_History__c bcnOld=bcnOldMap.get(bcn.Id);
                    if(bcnOld.GA_Start_Date__c !=bcn.GA_Start_Date__c  
                       || bcnOld.GA_End_Date__c !=bcn.GA_End_Date__c){
                           isChnge=true;     
                       }
                }
                else
                {
                    isChnge=true;
                }
                
                //Below conditions are to check whether the records to be updated on GS are within date ranges or not.
                if(bcn.GA_Start_Date__c  <=system.today() && bcn.GA_End_Date__c>system.today() && isChnge){
                    if(grpSgmntEmtyBCN.contains(bcn.GA_Group_Segment__c))
                    {
                        grpSgmntEmtyBCN.remove(bcn.GA_Group_Segment__c);
                    }
                    gsIdBCNMap.put(bcn.Id +TILTOPRTR+bcn.GA_Group_Segment__c, bcn);
                    grpSegmentProcessIds.add(bcn.GA_Group_Segment__c);
                }
                if(bcn.GA_End_Date__c<=system.today() && isChnge){
                    if(!gsIdBCNMap.keyset().contains(bcn.Id +TILTOPRTR+bcn.GA_Group_Segment__c))
                    {
                        grpSgmntEmtyBCN.add(bcn.GA_Group_Segment__c);
                        gsIdBCNMap.put(bcn.Id +TILTOPRTR+bcn.GA_Group_Segment__c, bcn);
                        grpSegmentProcessIds.add(bcn.GA_Group_Segment__c);
                    }
                }
            }
            List<GA_Group_Segment__c> gsLstToUpdte = new List<GA_Group_Segment__c> ();
            Set<Id> gsIdset = New Set<Id>();
            Map<id,Date> gsIdBCNMapDate = new Map<id,Date>();
            Set<GA_Plan_Year_Exception_History__c> processBCNLst = New Set<GA_Plan_Year_Exception_History__c>();
            GA_Plan_Year_Exception_History__c processBCN = New GA_Plan_Year_Exception_History__c ();
            //Querying the Group Segment info to update the BCN History Info on GS records.
            for(GA_Group_Segment__c gs : [select id, GA_BCN_Plan_Year_Exception_History_Id__c,GA_BCN_Plan_Year_Month_1__c,GA_BCN_Plan_Year_Exception_History_Id__r.GA_End_Date__c from GA_Group_Segment__c Where Id In : grpSegmentProcessIds Limit 10000])
            {
                for(String key : gsIdBCNMap.keySet()){
                    if(Key.contains(gs.id)){
                        if(gs.GA_BCN_Plan_Year_Exception_History_Id__c !=gsIdBCNMap.get(Key).Id  )
                        { 
                            if( !String.IsEmpty(gs.GA_BCN_Plan_Year_Exception_History_Id__c) && gsIdBCNMap.get(Key).GA_Is_Active__c){
                                gsIdBCNMapDate.put(gs.GA_BCN_Plan_Year_Exception_History_Id__c,gsIdBCNMap.get(Key).GA_Start_Date__c-1);
                            }
                            if( !String.IsEmpty(gs.GA_BCN_Plan_Year_Exception_History_Id__c) && gs.GA_BCN_Plan_Year_Exception_History_Id__r.GA_End_Date__c > System.today()  ){
                                grpSgmntEmtyBCN.remove(gs.id);
                            }
                            
                            if(gsIdBCNMap.get(Key).GA_End_Date__c<=system.today() || gsIdBCNMap.get(Key).GA_End_Date__c > system.today() ){
                                processBCN = New GA_Plan_Year_Exception_History__c (id = gsIdBCNMap.get(Key).id,
                                                                                    GA_Is_Processed__c = true);
                                processBCNLst.add(processBCN);
                            }
                            
                            //Below conditions is to update the BCN History Info on the related Group Segments.
                            if(gsIdBCNMap.get(Key).GA_End_Date__c > system.today())
                            {
                                gs.GA_BCN_Plan_Year_Exception_History_Id__c=gsIdBCNMap.get(Key).Id;
                                gs.GA_BCN_Plan_Year_Month_1__c=gsIdBCNMap.get(Key).GA_Plan_Year_Month__c;
                                gs.GA_Is_Mass_Updating__c=true;
                                if(!gsIdset.contains(gs.id)){
                                    gsIdset.add(gs.id);
                                    gsLstToUpdte.add(gs);
                                }
                            }
                        }
                        else{
                            processBCN = New GA_Plan_Year_Exception_History__c (id = gsIdBCNMap.get(Key).id,
                                                                                GA_Is_Processed__c = true);
                            processBCNLst.add(processBCN);
                        }
                    }
                }
            }
            //Below logic is update the BCN History info to NULL on Group Segment.
            GA_Group_Segment__c gsTonull=new GA_Group_Segment__c();
            for(id grpId:grpSgmntEmtyBCN)
            {
                gsTonull=new GA_Group_Segment__c();
                gsTonull.Id=grpId;
                gsTonull.GA_BCN_Plan_Year_Exception_History_Id__c=null;
                gsTonull.GA_BCN_Plan_Year_Month_1__c=null;
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
                GA_GS_Insert_ThrdPartyBillerRecs.isExecuting = true;
                GA_GS_Insert_ThrdPartyBillerRecs.isInvoked = true;
                GA_GS_Insert_ThrdPartyBillerRecs.isInvoking = true;
                GA_ExternalAppealRecdCrtnUpdt.isExecuting = true; 
                
                srList = Database.update(gsLstToUpdte,false);
            }
            
            set<Id> gsaIdSet = New set<Id>();
            if(processBCNLst.size() > 0){
                for(GA_Plan_Year_Exception_History__c bcnprc  : processBCNLst){
                    if(bcnprc.Id <> null){
                        gsaIdSet.add(bcnprc.Id);
                    }
                }
            }
            //Below logic is to update the end date of the BCN history records.
            Set<GA_Plan_Year_Exception_History__c> bcnOldrectoupte = new Set<GA_Plan_Year_Exception_History__c> ();
            GA_Plan_Year_Exception_History__c bcnTmp = new GA_Plan_Year_Exception_History__c();
            for(id bcnId:gsIdBCNMapDate.keySet())
            {
                if(!gsaIdSet.contains(bcnId)){
                    gsaIdSet.add(bcnId);
                    bcnTmp = new GA_Plan_Year_Exception_History__c();
                    bcnTmp.Id=bcnId;
                    bcnTmp.GA_End_Date__c=gsIdBCNMapDate.get(bcnId);
                    bcnTmp.GA_Is_Processed__c = true;
                    bcnOldrectoupte.add(bcnTmp);
                }
            }
            
            List<GA_Plan_Year_Exception_History__c> fnlProcessLst = New List<GA_Plan_Year_Exception_History__c>();
            
            if(  processBCNLst.size() > 0){
                fnlProcessLst.addAll(processBCNLst);
                
            }
            if(bcnOldrectoupte.size()>0) 
            {
                fnlProcessLst.addAll(bcnOldrectoupte);
            }
            
            if(fnlProcessLst.size() > 0 && fnlProcessLst.size() < 10001){
                database.update(fnlProcessLst,false);
            }
            //Below logic is to handle exceptions and creation of exception logs for the failed records.
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
        Catch(exception e){
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
            map<id,list<GA_Plan_Year_Exception_History__c>> bcnRecs=new map<id,list<GA_Plan_Year_Exception_History__c>>();
            list<GA_Plan_Year_Exception_History__c> bcnTmpLst=new list<GA_Plan_Year_Exception_History__c>();
            list<bcnHstryWrapper> bcnLstSrt=new list<bcnHstryWrapper>();
            for(GA_Plan_Year_Exception_History__c bcn:[select id,GA_Start_Date__c,
                                                       GA_End_Date__c,GA_Group_Segment__c
                                                       from GA_Plan_Year_Exception_History__c where GA_Group_Segment__c IN:lstGroupSeg 
                                                       ORDER BY GA_Start_Date__c desc Limit 50000])
            {
                if(bcnRecs.get(bcn.GA_Group_Segment__c)!=null)
                {
                    bcnTmpLst=bcnRecs.get(bcn.GA_Group_Segment__c);
                }
                else
                {
                    bcnTmpLst=new list<GA_Plan_Year_Exception_History__c>();
                }
                bcnTmpLst.add(bcn);
                bcnRecs.put(bcn.GA_Group_Segment__c,bcnTmpLst); 
            }
            map<id,list<bcnHstryWrapper>> bcnRecsSrted=new map<id,list<bcnHstryWrapper>>();
            bcnHstryWrapper bcnHstryWrapperRec;
            for(id grpId:bcnRecs.keyset())
            {
                list<GA_Plan_Year_Exception_History__c> bcnLstTemp=bcnRecs.get(grpId);
                bcnLstSrt=new list<bcnHstryWrapper>();
                for(GA_Plan_Year_Exception_History__c bcnTemp:bcnLstTemp)
                {
                    bcnHstryWrapperRec=new bcnHstryWrapper(bcnTemp);
                    bcnLstSrt.add(bcnHstryWrapperRec);
                }
                bcnLstSrt.sort();
                bcnRecsSrted.put(grpId,bcnLstSrt); 
                
            }
            list<bcnHstryWrapper> bcnWrprList=new list<bcnHstryWrapper>();
            list<GA_Plan_Year_Exception_History__c> bcnLstToupte=new list<GA_Plan_Year_Exception_History__c>();
            GA_Plan_Year_Exception_History__c bcnTmp = new GA_Plan_Year_Exception_History__c();
            for(id grpId:bcnRecsSrted.keyset())
            {
                bcnWrprList=bcnRecsSrted.get(grpId);
                for(integer i=0;i<bcnRecsSrted.get(grpId).size()-1;i++){
                    bcnTmp = new GA_Plan_Year_Exception_History__c();
                    if(bcnWrprList[i].bcn.GA_End_Date__c >= bcnWrprList[i+1].bcn.GA_Start_Date__c)
                    {
                        bcnTmp.Id=bcnWrprList[i].bcn.Id;
                        bcnTmp.GA_End_Date__c=bcnWrprList[i+1].bcn.GA_Start_Date__c-1;
                        bcnLstToupte.add(bcnTmp);
                    }
                }
            }
            
            if(!bcnLstToupte.isEmpty() && bcnLstToupte.size()<10001){
                Database.update(bcnLstToupte);
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
@Param         :  List<GA_Plan_Year_Exception_History__c> newList
@Return       :   void
@throws Exception   :   N/A;
********************************************************************************************************************************/     
    public static void updatEndDate(List<GA_Plan_Year_Exception_History__c> newList){
        try{
            endDateExecuting = true;
            set<Id> setGroupSeg = new Set<Id>();
            for(GA_Plan_Year_Exception_History__c obj : newList){
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
@Description    :  bcnHstryWrapper 
@Name         :   bcnHstryWrapper
@Param         :   N/A
@Return       :   void
@throws Exception   :   N/A;
*******************************************************************************************************************************/
    public without sharing class bcnHstryWrapper implements Comparable {
        
        public GA_Plan_Year_Exception_History__c bcn;
        
        /**
@Description: Constructor method 
@Name : bcnHstryWrapper
@Param : GA_Plan_Year_Exception_History__c bcnTmp
@Return : void
@throws Exception : N/A;
**/  
        public bcnHstryWrapper(GA_Plan_Year_Exception_History__c bcnTmp) {
            bcn = bcnTmp;
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
                bcnHstryWrapper compareTobcn = (bcnHstryWrapper)compareTo;
                
                // The return value of 0 indicates that both elements are equal.
                Integer returnValue = 0;
                if (bcn.GA_Start_Date__c > compareTobcn.bcn.GA_Start_Date__c) {
                    // Set return value to a positive value.
                    returnValue = 1;
                } 
                if (bcn.GA_Start_Date__c < compareTobcn.bcn.GA_Start_Date__c) {
                    // Set return value to a negative value.
                    returnValue = -1;
                }
                
                return returnValue; 
            }
            catch(Exception excpDtls){
                return null;
            }
        }
    }    
}