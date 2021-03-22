/*******************************************************************************************************************************
@Author : Raj Jena
@Name: GA_ATH_AP01_TerritoryUpdatngToAcc 
@CreatedDate: 03 - MAR 2019 
@Description: GA_ATH_AP01_TerritoryUpdatngToAcc class is for updating Association Third Party Biller to Account logic.
@version : 1.0  
********************************************************************************************************************************/
public without sharing class GA_ATH_AP01_TerritoryUpdatngToAcc {
    public static final String CLSNAME  = 'GA_ATH_AP01_TerritoryUpdatngToAcc';
    public static final String METHODNME  = 'updateATHtoAcc' ;
    public static final integer OCCURENCE = 0;
    public static final String  EXCPSVRTY='ERROR';
    public static List<Account> accLstToUpdt = new List<Account>();
    public static final String  TILTOPRTR='~';
    /*******************************************************************************************************************************
@Description    :  updateATHtoAcc 
@Name         :   updateATHtoAcc
@Param         :   List<GA_Association_Third_Party_Biller__c> atPBList
@Return       :   void
@throws Exception   :   N/A;
********************************************************************************************************************************/ 
    Public static void updateATHtoAcc(List<GA_Account_Territory_History__c> athList,Map<ID,GA_Account_Territory_History__c> athOldMap)
    {
        try
        {
            List<Database.SaveResult> srList = new List<Database.SaveResult>();
            List<ExceptionLog__c> excpLst = New List<ExceptionLog__c>();
            Map<String,GA_Account_Territory_History__c> accIdATHMap = new Map<String,GA_Account_Territory_History__c>();
            Set<Id> accProcessIds = New Set<Id>();
            boolean isChnge=false;
            Set<Id> setTerritoryId = new Set<Id>();
            
            for(GA_Account_Territory_History__c ath : athList)
            {
                if(athOldMap !=null)
                {
                    GA_Account_Territory_History__c athOld=athOldMap.get(ath.Id);
                    if(athOld.GA_Start_Date__c !=ath.GA_Start_Date__c  
                       || athOld.GA_End_Date__c !=ath.GA_End_Date__c){
                           isChnge=true;     
                       }
                }
                else
                {
                    isChnge=true;
                }
                if(ath.GA_Start_Date__c  <=system.today() && ath.GA_End_Date__c>system.today() && isChnge){
                    accIdATHMap.put(ath.Id +TILTOPRTR+ath.GA_Account_Id__c, ath);
                    accProcessIds.add(ath.GA_Account_Id__c);
                    setTerritoryId.add(ath.GA_Territory_Id__c);
                }
                if(ath.GA_End_Date__c<=system.today() && isChnge){
                    if(!accIdATHMap.keyset().contains(ath.Id +TILTOPRTR+ath.GA_Account_Id__c))
                    {
                        accIdATHMap.put(ath.Id +TILTOPRTR+ath.GA_Account_Id__c, ath);
                        accProcessIds.add(ath.GA_Account_Id__c);
                        setTerritoryId.add(ath.GA_Territory_Id__c);
                    }
                    
                }
            }
            
            Map<Id, GA_Territory__c> mapTerritory_ASR = new Map<Id, GA_Territory__c>([SELECT Id, GA_Support_Representative__c FROM GA_Territory__c WHERE Id IN :setTerritoryId]);
            Map<id,Date> accIdATHMapDate = new Map<id,Date>();
            Set<Id> accIdset = New Set<Id>();
            //List<GA_Account_Territory_History__c> processATHLst = New List<GA_Account_Territory_History__c>();
            Set<GA_Account_Territory_History__c> processATHLst = New Set<GA_Account_Territory_History__c>();
            GA_Account_Territory_History__c processATH = New GA_Account_Territory_History__c();
            for(Account acc : [select id, GA_Territory__c,GA_Account_Territory_History__c from Account Where Id In : accProcessIds Limit 50000])
            {
                for(String key : accIdATHMap.keySet()){
                    if(Key.contains(acc.id)){
                        if(acc.GA_Account_Territory_History__c !=accIdATHMap.get(Key).Id  )
                        { 
                            if( !String.IsEmpty(acc.GA_Account_Territory_History__c) && accIdATHMap.get(Key).GA_Is_Active__c){
                                accIdATHMapDate.put(acc.GA_Account_Territory_History__c,accIdATHMap.get(Key).GA_Start_Date__c-1);
                            }
                            if(accIdATHMap.get(Key).GA_End_Date__c<=system.today() || accIdATHMap.get(Key).GA_End_Date__c > system.today() ){
                                processATH = New GA_Account_Territory_History__c (id = accIdATHMap.get(Key).id,
                                                                                  GA_Is_Processed__c = true);
                                processATHLst.add(processATH);
                            }
                            if(accIdATHMap.get(Key).GA_End_Date__c > system.today())
                            {
                                acc.GA_Account_Territory_History__c=accIdATHMap.get(Key).Id;
                                acc.GA_Territory__c=accIdATHMap.get(Key).GA_Territory_Id__c;
                                acc.Account_Services_Representative__c = mapTerritory_ASR.get(accIdATHMap.get(Key).GA_Territory_Id__c).GA_Support_Representative__c;
                                acc.GA_Is_Mass_Updating__c=true;
                                //accLstToUpdt.add(acc);
                                if(!accIdset.contains(acc.id)){
                                    accIdset.add(acc.id);
                                    accLstToUpdt.add(acc);
                                }
                            }
                        }
                    }
                    else{
                        processATH = New GA_Account_Territory_History__c (id = accIdATHMap.get(Key).id,
                                                                         GA_Is_Processed__c = true);
                        processATHLst.add(processATH);
                    }
                }
                
            }
            
            if(!accLstToUpdt.isEmpty())
            {
                GA_ACC_AP01_CheckPlatinumStatusOnAgency.isExecuting = true;
                GA_Util_lockRecords.isExecuting = true;
                GA_ACC_AP05_CreateHandoverRecord.isExecuting = true;
                GA_ACC_UpdateChildContctsOnAccOwnrChange.isExecuting = true;
                GA_ACC_AP04_UpdtCntOnAccLockUnlock.isExecuting = true;
                GA_ACC_AP_UpdtAssmntOwnrMgrChnge.isExecuting = true; 
                GA_AccountBatchToUpdateContactOwner.isInvodedFrmBtch = true;
                GA_ACC_AP_UpdtAssmntOwnrMgrChnge.isExecuting = true;
                srList = Database.update(accLstToUpdt,false);
            }
            
            set<Id> athIdSet = New set<Id>();
            if(processATHLst.size() > 0){
                for(GA_Account_Territory_History__c athprc  : processATHLst){
                    if(athprc.id <> null){
                           athIdSet.add(athprc.Id);
                    }                 
                }
            }
            
            //List<GA_Account_Territory_History__c> athOldrectoupte = new List<GA_Account_Territory_History__c> ();
            Set<GA_Account_Territory_History__c> athOldrectoupte = new Set<GA_Account_Territory_History__c> ();
            GA_Account_Territory_History__c athTmp = New GA_Account_Territory_History__c();
            for(id athId:accIdATHMapDate.keySet())
            {
                if(!athIdSet.contains(athId)){
                    athIdSet.add(athId);
                    athTmp = new GA_Account_Territory_History__c();
                    athTmp.Id=athId;
                    athTmp.GA_End_Date__c=accIdATHMapDate.get(athId);
                    athTmp.GA_Is_Processed__c = true;
                    athOldrectoupte.add(athTmp);
                }
                
            }
            
            List<GA_Account_Territory_History__c> fnlProcessLst = New List<GA_Account_Territory_History__c>();
            
            if(  processATHLst.size() > 0){
                fnlProcessLst.addAll(processATHLst);
                
            }
            if(athOldrectoupte.size()>0) 
            {
                fnlProcessLst.addAll(athOldrectoupte);
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
}