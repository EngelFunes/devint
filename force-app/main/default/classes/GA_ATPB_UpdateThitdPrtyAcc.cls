/*******************************************************************************************************************************
@Author : Raj Jena
@Name: GA_ATPB_UpdateThitdPrtyAcc 
@CreatedDate: 21 - Dec 2018 
@Description: GA_ATPB_UpdateThitdPrtyAcc class is for updating Association Third Party Biller to Account logic.
@version : 1.0  
********************************************************************************************************************************/
public without sharing class GA_ATPB_UpdateThitdPrtyAcc {
    public static final String CLSNAME  = 'GA_ATPB_UpdateThitdPrtyAcc';
    public static final String METHODNME  = 'updtetThrdPrtyHstryToAcc' ;
    public static final String METHODNME1 = 'updtTpbhRecs';
    public static final String METHODNME2 = 'doAction';
    public static final String METHODNME3 = 'updatEndDate';
    public static final integer OCCURENCE = 0;
    public static final String  EXCPSVRTY='ERROR';
    public static  Boolean  endDateExecuting=false;
    public static  Boolean  insrtTBPExecuting=false;
    public static final String  TILTOPRTR='~';
    /*******************************************************************************************************************************
@Description    :  updtetThrdPrtyHstryToAcc 
@Name         :   updtetThrdPrtyHstryToAcc
@Param         :   List<GA_Association_Third_Party_Biller__c> atPBList
@Return       :   void
@throws Exception   :   N/A;
********************************************************************************************************************************/ 
    Public static void updtetThrdPrtyHstryToAcc(List<GA_Association_Third_Party_Biller__c> atPBList,Map<ID,GA_Association_Third_Party_Biller__c> atpbOldMap)
    {
        try
        {
            List<Database.SaveResult> srList = new List<Database.SaveResult>();
            List<ExceptionLog__c> excpLst = New List<ExceptionLog__c>();
            Map<String,GA_Association_Third_Party_Biller__c> atpbMap = new Map<String,GA_Association_Third_Party_Biller__c>();
            Set<Id> accProcessIds = New Set<Id>();
            set<id> accEmtyATPB=new set<id>();
            boolean isChnge=false;
            for(GA_Association_Third_Party_Biller__c atpb : atPBList)
            {
                if(atpbOldMap !=null)
                {
                    GA_Association_Third_Party_Biller__c atpbOld=atpbOldMap.get(atpb.Id);
                    if(atpbOld.GA_Start_Date__c !=atpb.GA_Start_Date__c  
                       || atpbOld.GA_End_Date__c !=atpb.GA_End_Date__c){
                           isChnge=true;     
                       }
                }
                else
                {
                    isChnge=true;
                }
                if(atpb.GA_Start_Date__c  <=system.today() && atpb.GA_End_Date__c>system.today() && isChnge){
                    if(accEmtyATPB.contains(atpb.GA_Association_Account_Id__c))
                    {
                        accEmtyATPB.remove(atpb.GA_Association_Account_Id__c);
                    }
                    atpbMap.put(atpb.Id +TILTOPRTR+atpb.GA_Association_Account_Id__c, atpb);
                    accProcessIds.add(atpb.GA_Association_Account_Id__c);
                }
                if(atpb.GA_End_Date__c<=system.today() && isChnge){
                    if(!atpbMap.keyset().contains(atpb.Id +TILTOPRTR+atpb.GA_Association_Account_Id__c))
                    {
                        accEmtyATPB.add(atpb.GA_Association_Account_Id__c);
                        atpbMap.put(atpb.Id +TILTOPRTR+atpb.GA_Association_Account_Id__c, atpb);
                        accProcessIds.add(atpb.GA_Association_Account_Id__c);
                    }
                }
            }
            List<Account> accLstToUpdte = new List<Account>();
            Set<Id> accIdset = New Set<Id>();
            Map<id,Date> atpbMapDate = new Map<id,Date>();
            //List<GA_Association_Third_Party_Biller__c> processAccLst = New List<GA_Association_Third_Party_Biller__c>();
            Set<GA_Association_Third_Party_Biller__c> processAccLst = New Set<GA_Association_Third_Party_Biller__c>();
            GA_Association_Third_Party_Biller__c processATPB = New  GA_Association_Third_Party_Biller__c();
            for(Account  acc : [select id,GA_Association_Third_Party_Biller__c, GA_Third_Party_Biller_Account_Id__c,GA_Association_Third_Party_Biller__r.GA_End_Date__c from Account where Id In : accProcessIds Limit 10000])
            {
                
                for(String key : atpbMap.keySet()){
                    if(Key.contains(acc.id)){
                        if(acc.GA_Association_Third_Party_Biller__c !=atpbMap.get(Key).Id )
                        { 
                            if( !String.IsEmpty(acc.GA_Association_Third_Party_Biller__c) && atpbMap.get(Key).GA_Is_Active__c){
                                atpbMapDate.put(acc.GA_Association_Third_Party_Biller__c,atpbMap.get(Key).GA_Start_Date__c-1);
                            }
                            
                            if( !String.IsEmpty(acc.GA_Association_Third_Party_Biller__c) && acc.GA_Association_Third_Party_Biller__r.GA_End_Date__c > System.today()  ){
                                accEmtyATPB.remove(acc.id);
                            }
                            
                            if(atpbMap.get(Key).GA_End_Date__c<=system.today() || atpbMap.get(Key).GA_End_Date__c > system.today() ){
                                processATPB = New GA_Association_Third_Party_Biller__c (id = atpbMap.get(Key).id,
                                                                                        GA_Is_Processed__c = true);
                                processAccLst.add(processATPB);
                            }
                            if(atpbMap.get(Key).GA_End_Date__c > system.today())
                            {
                                acc.GA_Association_Third_Party_Biller__c=atpbMap.get(Key).Id;
                                acc.GA_Third_Party_Biller_Account_Id__c=atpbMap.get(Key).GA_Third_Party_Biller_Account_Id__c;
                                acc.GA_Is_Mass_Updating__c=true;
                                //accLstToUpdte.add(acc);
                                if(!accIdset.contains(acc.id)){
                                    accIdset.add(acc.id);
                                    accLstToUpdte.add(acc);
                                }
                            }
                            
                        }
                        else{
                            processATPB = New GA_Association_Third_Party_Biller__c (id = atpbMap.get(Key).id,
                                                                                    GA_Is_Processed__c = true);
                            processAccLst.add(processATPB);
                        }
                    }
                }
                
            }
            
            Account accTonull = New Account();
            for(id accId:accEmtyATPB)
            {
                accTonull=new Account();
                accTonull.Id=accId;
                accTonull.GA_Third_Party_Biller_Account_Id__c =null;
                accTonull.GA_Association_Third_Party_Biller__c=null;
                accTonull.GA_Is_Mass_Updating__c=true;
                //accLstToUpdte.add(accTonull);
                if(!accIdset.contains(accTonull.id)){
                    accIdset.add(accTonull.id);
                    accLstToUpdte.add(accTonull);
                }
            }
            if(!accLstToUpdte.isEmpty())
            {
                GA_AccountTriggerHandlr.isExecuting = true;
                GA_ACC_AP01_CheckPlatinumStatusOnAgency.isExecuting = true;
                GA_Util_lockRecords.isExecuting = true;
                GA_ACC_AP02_IdentifySalesRepOnAccount.isExecuting = true;
                GA_ACC_AP05_CreateHandoverRecord.isExecuting = true;
                GA_ACC_UpdateChildContctsOnAccOwnrChange.isExecuting = true;
                GA_ACC_AP04_UpdtCntOnAccLockUnlock.isExecuting = true;
                GA_ACC_AP_UpdtAssmntOwnrMgrChnge.isExecuting = true; 
                GA_AccountBatchToUpdateContactOwner.isInvodedFrmBtch = true;
                GA_ACC_AP_UpdtAssmntOwnrMgrChnge.isExecuting = true;
                srList = Database.update(accLstToUpdte,false);
            }
            
            set<Id> atphIdSet = New set<Id>();
            if(processAccLst.size() > 0){
                for(GA_Association_Third_Party_Biller__c atpbprc  : processAccLst){
                    if(atpbprc.Id <> null){
                         atphIdSet.add(atpbprc.Id);
                    }
                 }
            }
            
            //List<GA_Association_Third_Party_Biller__c> atpbOldrectoUpdt = new List<GA_Association_Third_Party_Biller__c> ();
            Set<GA_Association_Third_Party_Biller__c> atpbOldrectoUpdt = new Set<GA_Association_Third_Party_Biller__c> ();
            GA_Association_Third_Party_Biller__c atpbEndUpdt = New GA_Association_Third_Party_Biller__c();
            for(id atpbId:atpbMapDate.keySet())
            {
                if(!atphIdSet.contains(atpbId)){
                    atphIdSet.add(atpbId);
                    atpbEndUpdt = new GA_Association_Third_Party_Biller__c();
                    atpbEndUpdt.Id=atpbId;
                    atpbEndUpdt.GA_End_Date__c=atpbMapDate.get(atpbId);
                    atpbEndUpdt.GA_Is_Processed__c = true;
                    atpbOldrectoUpdt.add(atpbEndUpdt);
                }
            }
            
            List<GA_Association_Third_Party_Biller__c> fnlProcessLst = New List<GA_Association_Third_Party_Biller__c>();
            
            if(  processAccLst.size() > 0){
                fnlProcessLst.addAll(processAccLst);
                
            }
            if(atpbOldrectoUpdt.size()>0) 
            {
                fnlProcessLst.addAll(atpbOldrectoUpdt);
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
            GA_LogExceptionCls.LogExcp(e, CLSNAME, METHODNME);
        }
    }
    /*******************************************************************************************************************************
@Description    :  updtTpbhRecs 
@Name         :   updtTpbhRecs
@Param         :   List<GA_Association_Third_Party_Biller__c> atpbLst
@Return       :   void
@throws Exception   :   N/A;
********************************************************************************************************************************/ 
    public static void updtTpbhRecs(List<GA_Association_Third_Party_Biller__c> atpbLst){
        try{
            //insrtTBPExecuting=true;
            Set<ID> accId = new Set<ID>();
            List<GA_Third_Party_Biller_History__c> lstTPBH = new List<GA_Third_Party_Biller_History__c>();
            for(GA_Association_Third_Party_Biller__c obj : atpbLst){
                if(obj.GA_Association_Account_Id__c <> null){
                accId.add(obj.GA_Association_Account_Id__c);
                }
            }
            
            if(!accId.isEmpty()){
                
                List<GA_Group_Association__c> grpAssocLst = [SELECT Id,GA_Group_Segment__c,GA_Account__c FROM GA_Group_Association__c WHERE GA_Account__c IN: accId Limit 3000];
                GA_Third_Party_Biller_History__c  tpbh = New GA_Third_Party_Biller_History__c();
                for(GA_Association_Third_Party_Biller__c atpb : atpbLst){ 
                    for(GA_Group_Association__c grpAssoc : [SELECT Id,GA_Group_Segment__c,GA_Account__c FROM GA_Group_Association__c WHERE GA_Account__c IN: accId Limit 3000]){ 
                        if(atpb.GA_Association_Account_Id__c == grpAssoc.GA_Account__c){
                            
                            tpbh = new GA_Third_Party_Biller_History__c ();
                            tpbh.GA_Group_Segment_Id__c=grpAssoc.GA_Group_Segment__c;
                            tpbh.GA_Third_Party_Biller_Account__c = atpb.GA_Third_Party_Biller_Account_Id__c;
                            tpbh.GA_TPB_End_Date__c = atpb.GA_End_Date__c;
                            tpbh.GA_TPB_Start_Date__c = atpb.GA_Start_Date__c;
                            
                            lstTPBH.add(tpbh);
                        }
                    }
                }
                
                if(!lstTPBH.isEmpty()){
                    Database.insert(lstTPBH);
                }
            }
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, CLSNAME, METHODNME1);
        }
        
    }
    /*******************************************************************************************************************************
@Description    : doAction 
@Name         :   doAction
@Param         :  set<ID> accId
@Return       :   void
@throws Exception   :   N/A;
********************************************************************************************************************************/     
    public static void doAction(set<ID> accntId){
        try{
            List<GA_Association_Third_Party_Biller__c> objatpbLst = [select id,GA_Start_Date__c,
                                                                     GA_End_Date__c,GA_Association_Account_Id__c
                                                                     from GA_Association_Third_Party_Biller__c 
                                                                     where GA_Association_Account_Id__c IN:accntId
                                                                     ORDER BY GA_Start_Date__c desc Limit 50000];
            
            map<id,list<GA_Association_Third_Party_Biller__c>> accAtpbRecs=new map<id,list<GA_Association_Third_Party_Biller__c>>();
            list<GA_Association_Third_Party_Biller__c> atpbTmpLst=new list<GA_Association_Third_Party_Biller__c>();
            list<atpbWrapper> atpbLstSrt=new list<atpbWrapper>();
            for(GA_Association_Third_Party_Biller__c atpb:[select id,GA_Start_Date__c,
                                                           GA_End_Date__c,GA_Association_Account_Id__c
                                                           from GA_Association_Third_Party_Biller__c 
                                                           where GA_Association_Account_Id__c IN:accntId
                                                           ORDER BY GA_Start_Date__c desc Limit 50000])
            {
                if(accAtpbRecs.get(atpb.GA_Association_Account_Id__c)!=null)
                {
                    atpbTmpLst=accAtpbRecs.get(atpb.GA_Association_Account_Id__c);
                }
                else
                {
                    atpbTmpLst=new list<GA_Association_Third_Party_Biller__c>();
                }
                atpbTmpLst.add(atpb);
                accAtpbRecs.put(atpb.GA_Association_Account_Id__c,atpbTmpLst); 
            }
            map<id,list<atpbWrapper>> accAtpbRecsSrted=new map<id,list<atpbWrapper>>();
            list<GA_Association_Third_Party_Biller__c> atpbLstTemp = New list<GA_Association_Third_Party_Biller__c>();
            atpbWrapper atpbWrapperRec;
            for(id accId:accAtpbRecs.keyset())
            {
                atpbLstTemp=accAtpbRecs.get(accId);
                atpbLstSrt=new list<atpbWrapper>();
                for(GA_Association_Third_Party_Biller__c atpbTemp:atpbLstTemp)
                {
                    atpbWrapperRec=new atpbWrapper(atpbTemp);
                    atpbLstSrt.add(atpbWrapperRec);
                }
                atpbLstSrt.sort();
                accAtpbRecsSrted.put(accId,atpbLstSrt); 
                
            }
            list<atpbWrapper> tpbLst=new list<atpbWrapper>();
            GA_Association_Third_Party_Biller__c tpbTmp = New GA_Association_Third_Party_Biller__c();
            list<GA_Association_Third_Party_Biller__c> atpbLstToupte=new list<GA_Association_Third_Party_Biller__c>();
            for(id accId:accAtpbRecsSrted.keyset())
            {
                tpbLst=accAtpbRecsSrted.get(accId);
                for(integer i=0;i<accAtpbRecsSrted.get(accId).size()-1;i++){
                    tpbTmp = new GA_Association_Third_Party_Biller__c();
                    if(tpbLst[i].atpb.GA_End_Date__c >= tpbLst[i+1].atpb.GA_Start_Date__c)
                    {
                        tpbTmp.Id=tpbLst[i].atpb.Id;
                        tpbTmp.GA_End_Date__c=tpbLst[i+1].atpb.GA_Start_Date__c-1;
                        atpbLstToupte.add(tpbTmp);
                    }
                }
            }
            
            if(!atpbLstToupte.isEmpty() && atpbLstToupte.size()<10001){
                Database.update(atpbLstToupte);
            }  
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, CLSNAME, METHODNME2);
        }
    }    
    /*******************************************************************************************************************************
@Description    : updatEndDate 
@Name         :   updatEndDate
@Param         :  List<GA_Association_Third_Party_Biller__c> newList
@Return       :   void
@throws Exception   :   N/A;
********************************************************************************************************************************/     
    public static void updatEndDate(List<GA_Association_Third_Party_Biller__c> newList){
        try{
            endDateExecuting=true;
            set<Id> accIdSet = new Set<Id>();
            for(GA_Association_Third_Party_Biller__c obj : newList){
                if(obj.GA_Association_Account_Id__c <> null){
                accIdSet.add(obj.GA_Association_Account_Id__c);
                }
            }        
            doAction(accIdSet); 
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, CLSNAME, METHODNME3);
        }
        
    }
    /*******************************************************************************************************************************
@Description    :  atpbWrapper 
@Name         :   atpbWrapper
@Param         :   N/A
@Return       :   void
@throws Exception   :   N/A;
*******************************************************************************************************************************/
    public without sharing class atpbWrapper implements Comparable {
        
        public GA_Association_Third_Party_Biller__c atpb;
        
    /**
    @Description: Constructor method 
    @Name : atpbWrapper
    @Param : GA_Association_Third_Party_Biller__c atpbTmp
    @Return : void
    @throws Exception : N/A;
    **/  
        public atpbWrapper(GA_Association_Third_Party_Biller__c atpbTmp) {
            atpb = atpbTmp;
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
               atpbWrapper compareToatpb = (atpbWrapper)compareTo;
            
            // The return value of 0 indicates that both elements are equal.
            Integer returnValue = 0;
            if (atpb.GA_Start_Date__c > compareToatpb.atpb.GA_Start_Date__c) {
                // Set return value to a positive value.
                returnValue = 1;
            } 
           if (atpb.GA_Start_Date__c < compareToatpb.atpb.GA_Start_Date__c) {
                // Set return value to a negative value.
                returnValue = -1;
            }
            return returnValue;  
            }
            catch(exception e){
                return null;
            }
                  
        }
    }  
}