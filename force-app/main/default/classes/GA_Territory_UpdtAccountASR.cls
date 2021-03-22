/*******************************************************************************************************************************
@Author : IDC Offshore
@Name: GA_Territory_UpdtAccountASR
@CreatedDate: 07 - May 2019 
@Description: GA_Territory_UpdtAccountASR class to update Account ASR
@version : 1.0  
********************************************************************************************************************************/
public without sharing class GA_Territory_UpdtAccountASR{
    public static boolean isExecuting = false;
    public static final string clsName  ='GA_Territory_UpdtAccountASR';
    public static final string mthdupdtAccASRFrmTerrtry  ='updtAccASRFrmTerrtry';
    public static final string CustomerRecType = System.Label.GA_CustomerRecType;
    public static final string ProspectRecType = System.Label.GA_ProspectRecType;
    public static final  Id CustomerRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(CustomerRecType).getRecordTypeId();
    public static final  Id ProspectRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(ProspectRecType).getRecordTypeId(); 
    public static final integer UpdtAccOwnrlmt=Integer.valueof(system.label.GA_UpdateAccOwner_Limit);
    public static final integer occurence = 1;
    public static final String  excpSvrty='ERROR';
    /**
@Description: updtAccASRFrmTerrtry() method 
@Name : updtAccASRFrmTerrtry
@Param : list<GA_Territory__c > TerritoryLst, map<id,GA_Territory__c > TerritoryOldMap
@Return : void
@throws Exception : N/A;
*/     
    public static void updtAccASRFrmTerrtry(list<GA_Territory__c > TerritoryLst,
                                            map<id,GA_Territory__c > TerritoryOldMap)
    {
        
        try{
            List<Database.SaveResult> srList = new List<Database.SaveResult>();
            List<ExceptionLog__c> excpLst = New List<ExceptionLog__c>();
            map<Id,Id> AccntTerrtryMap = New map<Id,Id>();
            Map<ID,Id> TerrtryASRMap = New  Map<ID,Id>();
            Map<String,String> asrMap=new  Map<String,String>();
            
            for(GA_Territory__c Terrtry:TerritoryLst)
            {
                if(TerritoryOldMap.get(Terrtry.Id).GA_Support_Representative__c !=Terrtry.GA_Support_Representative__c)
                {
                    if(String.isNotBlank(Terrtry.GA_Support_Representative__c ) ){
                        TerrtryASRMap.put(Terrtry.Id,Terrtry.GA_Support_Representative__c);
                    }
                }
            } 
            Set<Id> recordTypes =  new Set<Id>{CustomerRecordTypeId,ProspectRecordTypeId};
                
                
                List <Account> AccLst = [select Id,Name,Account_Services_Representative__c,GA_Territory__c,recordtypeid from Account 
                                         where GA_Territory__c in: TerrtryASRMap.Keyset() and 
                                         recordtypeid in: recordTypes limit 30000];
            if(AccLst.size()>0){
                for(Account Acc : AccLst){
                    AccntTerrtryMap.put(Acc.Id,Acc.GA_Territory__c);
                }
            }
            List<Account> UpdtAccLst = New List<Account> ();
            Account UpdtAcc;
            if(AccntTerrtryMap.size()>0){
                for(GA_Territory__c Terrtry:TerritoryLst)
                {
                    for(Id accId: AccntTerrtryMap.keyset())
                    {
                        
                        Account exstngAcc = [select Id,Name,Account_Services_Representative__c from Account where Id =: accId limit 1];
                        UpdtAcc = New Account(Id=accId) ;
                        
                        if((exstngAcc.Account_Services_Representative__c == null) || (exstngAcc.Account_Services_Representative__c == TerritoryOldMap.get(Terrtry.Id).GA_Support_Representative__c))
                        {
                            UpdtAcc.Account_Services_Representative__c = TerrtryASRMap.get(AccntTerrtryMap.get(accId));
                            UpdtAcc.GA_Is_Mass_Updating__c = true;
                            UpdtAccLst.add(UpdtAcc);
                            asrMap.put(UpdtAcc.Id,TerrtryASRMap.get(AccntTerrtryMap.get(accId)));
                        }
                    }
                }
            }
            if(!UpdtAccLst.isEmpty())
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
                
                if(UpdtAccLst.size() <= UpdtAccOwnrlmt){
                    srList = Database.update(UpdtAccLst,false); 
                }
                else{ 
                    Integer counter = UpdtAccOwnrlmt;
                    List<Account> newList = New List<Account>();
                    GA_AccOwnerUpdateQueueble updateJob;
                    for (Integer j=0; j < UpdtAccLst.size() ;j++){
                        
                        if(j < counter ){
                            newList.add(UpdtAccLst[j]);
                        }
                        if(j == counter ){ 
                            newList.add(UpdtAccLst[j]);
                            updateJob = new GA_AccOwnerUpdateQueueble(newList);
                            ID jobID = System.enqueueJob(updateJob);
                            counter = counter + UpdtAccOwnrlmt;
                            newList.clear();
                        }
                        
                    }
                    
                    if(!newList.isEmpty() && (Limits.getQueueableJobs() < 50)  ){ 
                        updateJob = new GA_AccOwnerUpdateQueueble(newList);
                        ID jobID = System.enqueueJob(updateJob);
                        counter = counter + UpdtAccOwnrlmt;
                        newList.clear();
                    } 
                    
                }
            }
            
            Integer i=0;
            ExceptionLog__c objLog;
            if(!srList.isEmpty()){
                for(Database.SaveResult obj : srList){
                    
                    for(Database.Error objErr : obj.getErrors()){
                        if(!obj.isSuccess()){
                            objLog = new ExceptionLog__c(
                                Object_ID__c =UpdtAccLst[i].id,
                                ExceptionDescription__c = objErr.getMessage(),
                                ExceptionCode__c =  String.valueOf(objErr.getStatusCode()),
                                NumberOfTimesOccured__c = occurence,
                                ExceptionDetails__c = objErr.getMessage(),
                                Severity__c = excpSvrty);
                            excpLst.add(objLog);
                        } 
                    }
                    i++;
                }
            }
            if(!excpLst.isEmpty()){
                Database.insert(excpLst);
            }
            
        }
        catch(Exception e)
        {
            GA_LogExceptionCls.LogExcp(e, clsName, mthdupdtAccASRFrmTerrtry);
        }
    }
    
    
    
}