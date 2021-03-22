/**
@Author : IDCOffshore
@Name: GA_UpdateAccOwner
@CreatedDate: 1/7/2019 
@Description: GA_UpdateAccOwner class is for updation of Account Owner based on Territory.
@version : 1.0  
*/ 
public without sharing class GA_UpdateAccOwner {
    
    public static boolean isExecuting = false;
    public static final string CLSNAME  ='GA_UpdateAccOwner';
    public static final string MTHDUPDTFRMTERRTRY  ='updtFrmTerrtry';
    public static final string MTHDUPDTLIASNREGMANGR='updtLiasnRegMangr';
    public static final string CUSTOMERRECTYPE = System.Label.GA_CustomerRecType;
    public static final string PROSPECTRECTYPE = System.Label.GA_ProspectRecType;
    public static final Id CUSTOMERRECORDTYPEID = Schema.SObjectType.Account.getRecordTypeInfosByName().get(CUSTOMERRECTYPE).getRecordTypeId();
    public static final Id PROSPECTRECORDTYPEID = Schema.SObjectType.Account.getRecordTypeInfosByName().get(PROSPECTRECTYPE).getRecordTypeId(); 
    public static final integer OCCURENCE = 1;
    public static final String EXCPSVRTY='ERROR';
    public static final integer UPDTACCOWNRLMT=Integer.valueof(system.label.GA_UpdateAccOwner_Limit);
    public static final string NULLSTRNG='';
    /**
@Description: updtFrmTerrtry() method 
@Name : updtFrmTerrtry
@Param : list<GA_Territory__c > TerritoryLst, map<id,GA_Territory__c > TerritoryOldMap
@Return : void
@throws Exception : N/A;
*/      
    public static void updtFrmTerrtry(list<GA_Territory__c > TerritoryLst,
                                      map<id,GA_Territory__c > TerritoryOldMap)
    {
        
        try{
            List<Database.SaveResult> srList = new List<Database.SaveResult>();
            List<ExceptionLog__c> excpLst = New List<ExceptionLog__c>();
            map<Id,Id> accntTerrtryMap = New map<Id,Id>();
            Map<ID,Id> terrtryRSRMap = New  Map<ID,Id>();
            Map<String,String> rsrMap=new  Map<String,String>();
            
            for(GA_Territory__c Terrtry:TerritoryLst)
            {
                if((TerritoryOldMap.get(Terrtry.Id).GA_RetentionSalesRepresentative__c !=Terrtry.GA_RetentionSalesRepresentative__c) ||(TerritoryOldMap.get(Terrtry.Id).GA_Sales_Rep_Effective_Date__c !=Terrtry.GA_Sales_Rep_Effective_Date__c))
                {
                    if(Terrtry.GA_Sales_Rep_Effective_Date__c <= System.today())
                    {
                        if(String.isNotBlank(Terrtry.GA_RetentionSalesRepresentative__c ) ){
                            terrtryRSRMap.put(Terrtry.Id,Terrtry.GA_RetentionSalesRepresentative__c);
                        }
                        else{
                            terrtryRSRMap.put(Terrtry.Id,System.label.GA_Informatica_User);
                        }
                        Terrtry.GA_IsProcessed__c=true;
                    }else if(Terrtry.GA_Sales_Rep_Effective_Date__c > System.today())
                    {
                        //terrtryRSRMap.put(Terrtry.Id,System.label.GA_Informatica_User);
                        Terrtry.GA_IsProcessed__c=false;
                    }
                    /*else if(Terrtry.GA_Sales_Rep_Effective_Date__c < System.today())
                    {
                        terrtryRSRMap.put(Terrtry.Id,System.label.GA_Informatica_User);
                        Terrtry.GA_IsProcessed__c=true;
                    }*/
                }
            } 
            
            Set<Id> recordTypes =  new Set<Id>{CUSTOMERRECORDTYPEID,PROSPECTRECORDTYPEID};
                
                List <Account> accLst = [select Id,OwnerId,GA_Territory__c,recordtypeid from Account 
                                         where GA_Territory__c in: terrtryRSRMap.Keyset() and 
                                         recordtypeid in: recordTypes    limit 30000];
            
            for(Account Acc : accLst){
                accntTerrtryMap.put(Acc.Id,Acc.GA_Territory__c);
            }
            
            List<Account> updtAccLst = New List<Account> ();
            Account updtAcc = New Account();
            for(Id accId:accntTerrtryMap.keyset())
            {
                updtAcc = New Account(Id=accId) ;
                updtAcc.OwnerId = terrtryRSRMap.get(accntTerrtryMap.get(accId));
                updtAcc.GA_Is_Mass_Updating__c = true;
                updtAccLst.add(updtAcc);
                rsrMap.put(updtAcc.Id,terrtryRSRMap.get(accntTerrtryMap.get(accId)));
                /*for(Id TertryId:terrtryRSRMap.keyset())
                {
                    if(TertryId==accntTerrtryMap.get(key))
                    {
                        Account updtAcc = New Account(Id=key) ;
                        updtAcc.OwnerId = terrtryRSRMap.get(TertryId);
                        updtAcc.GA_Is_Mass_Updating__c = true;
                        updtAccLst.add(updtAcc);
                        rsrMap.put(updtAcc.Id,terrtryRSRMap.get(TertryId));
                    }
                }*/
            }
            
            if(!updtAccLst.isEmpty())
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
                //GA_ACC_updtTBPendDateOnGS.isExecuting = true;
                
               system.debug('List size - >'+updtAccLst.size());
               if(updtAccLst.size() <= UPDTACCOWNRLMT){
                srList = Database.update(updtAccLst,false); 
                   
               GA_ACC_AP02_IdentifySalesRepOnAccount.acctSalesTeamMap = rsrMap;
               GA_ACC_AP02_IdentifySalesRepOnAccount.updateAccManagerOnJeoRecs();
               }
                else{ 
                    //system.debug('Invoke Queueable');
                 /**   String territoryIds = GA_Util08_FilterProcessHelper.idSet(terrtryRSRMap.Keyset());
                    String querytoUpdate  = 'Select id,ownerid, ga_territory__r.GA_RetentionSalesRepresentative__c,GA_Retention_Sales_Rep__c,GA_Is_Mass_Updating__c from Account'+
                        ' where   GA_IsAccOwnerRSR__C = TRUE '+
                        ' and GA_Territory__c in '+territoryIds;
                    
                    //system.debug('querytoUpdate'+querytoUpdate);
                    
                    GA_UpdateTerritoryRtnSalesRepBatch uptslsTmBtch=new GA_UpdateTerritoryRtnSalesRepBatch(querytoUpdate);
                    ID uptSlsTmbatchprocessid = Database.executeBatch(uptslsTmBtch,UPDTACCOWNRLMT);  **/
                    Integer counter = UPDTACCOWNRLMT;
                    List<Account> newList = New List<Account>();
                    GA_AccOwnerUpdateQueueble updateJob;
                    for (Integer j=0; j < updtAccLst.size() ;j++){
                        
                        if(j < counter ){
                            newList.add(updtAccLst[j]);
                            }
                        if(j == counter && Limits.getQueueableJobs() == 0){ // originally if(j == counter ){ 
                              //system.debug('newList size'+newList.size());
                               newList.add(updtAccLst[j]);
                                updateJob = new GA_AccOwnerUpdateQueueble(newList);
                                ID jobID = System.enqueueJob(updateJob);
                                counter = counter + UPDTACCOWNRLMT;
                                newList.clear();
                           }
                        
                    }
                    
                    if(!newList.isEmpty() && (Limits.getQueueableJobs() == 0)  ){// originally if(!newList.isEmpty() && (Limits.getQueueableJobs() < 50)  ){ 
                             //  system.debug('newList size'+newList.size());
                                updateJob = new GA_AccOwnerUpdateQueueble(newList);
                                ID jobID = System.enqueueJob(updateJob);
                                counter = counter + UPDTACCOWNRLMT;
                                newList.clear();
                           } 
                    
                }
            }
            
            Integer intgr=0;
            ExceptionLog__c objLog = new ExceptionLog__c();
            if(!srList.isEmpty()){
                for(Database.SaveResult obj : srList){
                    
                    for(Database.Error objErr : obj.getErrors()){
                        if(!obj.isSuccess()){
                                objLog = new ExceptionLog__c(
                                Object_ID__c =updtAccLst[intgr].id,
                                ExceptionDescription__c = objErr.getMessage(),
                                ExceptionCode__c =  String.valueOf(objErr.getStatusCode()),
                                NumberOfTimesOccured__c = OCCURENCE,
                                ExceptionDetails__c = objErr.getMessage(),
                                Severity__c = EXCPSVRTY);
                            excpLst.add(objLog);
                        } 
                    }
                    intgr++;
                }
            }
            if(!excpLst.isEmpty()){
                Database.insert(excpLst);
            }
            
        }
        catch(Exception e)
        {
            GA_LogExceptionCls.LogExcp(e, CLSNAME, MTHDUPDTFRMTERRTRY);
        }
    }
     /*******************************************************************************************************************************
@Description  :   constructMap 
@Name         :   constructMap
@Param        :   List<GA_Territory__c> trryList
@Return       :   List<id>
@throws Exception   :   N/A;
*******************************************************************************************************************************/       
    public static List<id> constructMap(list<GA_Territory__c> trryList){
        list<id> trryIds=new list<id>();
        id trryId = null;
        for(GA_Territory__c trry:trryList)
        {
            trryId=trry.Id;
            trryIds.add(trryId);
        }
        return trryIds;
    }
    /*******************************************************************************************************************************
@Description  :   updtLiasnRegMangr 
@Name         :   updtLiasnRegMangr
@Param        :   List<GA_Territory__c> terList
@Return       :   void
@throws Exception   :   N/A;
*******************************************************************************************************************************/    
   /* public static void updtLiasnRegMangr(List<GA_Territory__c> terList){
        try{
            for(GA_Territory__c trry :terList){
                trry.GA_Liaison_Regional_Manager__c=trry.GA_ABR_Specialist__c;
            } 
        }
        catch(Exception e){
            GA_LogExceptionCls.LogExcp(e, CLSNAME, MTHDUPDTLIASNREGMANGR);
        } 
    } */
}