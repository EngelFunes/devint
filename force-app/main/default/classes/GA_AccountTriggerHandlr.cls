/*********************************************************************************************************************************************
@Author : PadmaHaarika Jayana
@Name: GA_AccountTriggerHandlr
@CreatedDate: 31 - Jul 2017 
@Description: GA_AccountTriggerHandlr class is for creating/updating Account is changed
@version : 1.0  
**********************************************************************************************************************************************/
public without sharing class GA_AccountTriggerHandlr{
    public static final String CLSNAME  ='GA_AccountTriggerHandlr';
    public static final String METHODNMEAFTERINSERT  ='afterinsert';
    public static final String METHODNMEBEFOREUPDATE  ='beforeupdate';
    public static final String METHODNMEBEFOREINSERT  ='beforeinsert';
    public static final String METHODNMEAFTERUPDATE  ='afterupdate';
    public static final String PARTNERMETHOD  ='modifyPartner';
    public static final String ACCOUNTTEAMMETHOD  ='getAccountTeam';
    public static final String SYSOFREC = 'GA_System_of_Record__c';
    public static final String  QUEU='Select id,GA_System_of_Record__c from account where id in:idLst';
    public static final String  QRYUPDTSLSTM='SELECT Id,Name,GA_Territory__c,RecordTypeId,GA_Platinum__c,GA_Retention_Sales_Rep__c from Account where id in:idLst';
    public static final String  QRYCREATEHANDOVER='SELECT Id,Name, RecordTypeId, OwnerId from Account where id in:idLst';
    public static final String  QRYUPDATECONTCTS='Select Id, AccountId, OwnerId, GA_OwnerId__c from Contact Where AccountId IN : idLst';
    public static final String DMLOPINSRT='Insert';
    public static final String DMLOPUPDTE='Update';
    public static boolean isExecuting = false;
    public static boolean isBfrInstExecuting = false;
    public static integer acntLckLmt=Integer.valueof(system.label.GA_Account_Lock_Limit);
    public static boolean isARVAccountOwnerChanged = false;
    public static String acntTeamJSON='null';
    public static final String SUBMITTED = 'Submitted';
    public static final String COMPLETED = 'Completed';
/************************************************************************************************************
@Description: US-4005: This method saves Account Team Members. Since members need to be restored in ARV flow after changing the Owner, we are reinserting them in After Update
@Name : getAccountTeam
@Param : map<id,Account> accOldMap, map<id,Account> accNewMap
@Return : NA
@throws Exception : N/A;
*************************************************************************************************************/
    Public static void getAccountTeam (List<Account> accountList, Map<id, account> oldMap, Map<id, account> newMap){

        Set<Account> ownerChangeARVAccounts = new Set<Account>();
        try{
            
            if(!newMap.values().isEmpty())
            {
                for(account acnt: newMap.values()){
                    if(newMap.get(acnt.id).OwnerId!=oldMap.get(acnt.id).OwnerId){
                        isARVAccountOwnerChanged = true;
                        ownerChangeARVAccounts.add(acnt);
                    }
                }
           	}
            if(isARVAccountOwnerChanged){
                List<AccountTeamMember> listAccTeam = [SELECT Id, AccountAccessLevel, AccountId, CaseAccessLevel, 
                                                   UserId, ContactAccessLevel, OpportunityAccessLevel, TeamMemberRole, 
                                                   PhotoUrl, Title FROM AccountTeamMember Where AccountId in : ownerChangeARVAccounts]; 
                acntTeamJSON = JSON.serialize(listAccTeam);
            }   
        }catch(Exception e){
            GA_LogExceptionCls.LogExcp(e, CLSNAME, ACCOUNTTEAMMETHOD);
        }
    }
/************************************************************************************************************
@Description: This method checks whether agency account is getting enabled to partner or not; US3559
              Avoid calling afterUpdate and beforeUpdate upon modifying partner status
@Name : enablingPartner
@Param : map<id,Account> accOldMap, map<id,Account> accNewMap
@Return : Boolean
@throws Exception : N/A;
*************************************************************************************************************/
    Public Static Boolean modifyPartner (Map<id, account> newMap,Map<id, account> oldMap){
        Boolean updatePartner = false;
        try{
            if(!newMap.values().isEmpty()){
                for(account acnt: newMap.values()){
                    if(newMap.get(acnt.id).IsPartner!=oldMap.get(acnt.id).IsPartner){
                        updatePartner = true;
                    }
                }
           	}
           return updatePartner;
          }
        catch(Exception e){
            GA_LogExceptionCls.LogExcp(e, CLSNAME, PARTNERMETHOD);
            return updatePartner;
        }
    }   
/*********************************************************************************************************************************************
@Description: beforeinsert() method 
@Name : beforeinsert
@Param : list<Account> accList, map<id,Account> accNewMap
@Return : void
@throws Exception : N/A;
**********************************************************************************************************************************************/ 
    public static void beforeinsert(list<Account> accList, map<id,Account> accNewMap)
    {
        try
        {
            //GA_ACC_AP02_IdentifySalesRepOnAccount.assignRepasOwner(accList);
            if(!isBfrInstExecuting)
            {
                isBfrInstExecuting = true;
                GA_ACC_AP02_IdentifySalesRepOnAccount.changePlatinumSts(accList);
                GA_ACC_AP02_IdentifySalesRepOnAccount.UpdtAccFieldsOnInsert(accList);
            }
            
            if(!GA_GS_AP02_Update_Address.isExecuting){
                GA_GS_AP02_Update_Address.isExecuting = true;
                GA_GS_AP02_Update_Address.updateAccCountyByZipCode(accList);
            } 
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, CLSNAME, METHODNMEBEFOREINSERT);
        }
        
    }
    /*********************************************************************************************************************************************
@Description: afterinsert() method 
@Name : afterinsert
@Param : list<Account> accList, map<id,Account> accNewMap  
@Return : void
@throws Exception : N/A;
**********************************************************************************************************************************************/ 
    public static void afterinsert(list<Account> accList, map<id,Account> accNewMap,map<id,Account>  accoldMap)
    {
        try
        {   
            
            if(!accList.isEmpty()){                
                if(accList.size() < acntLckLmt)
                {
                    if(!GA_ACC_AP02_IdentifySalesRepOnAccount.isExecuting ){
                        GA_ACC_AP02_IdentifySalesRepOnAccount.isExecuting = true;
                        GA_ACC_AP02_IdentifySalesRepOnAccount.createsalesTeamOnAccount(accList, accNewMap, accoldMap);
                    } 
                    if(!GA_Util_lockRecords.isExecuting ){
                        GA_Util_lockRecords.isExecuting = true;
                        GA_Util_lockRecords.onInsertlockRecords(accList, SYSOFREC);
                    }  
                }
                else
                {
                    map<id,sobject> sobjOldmap=new map<id,sobject>();
                    List<Id> lockerAccIds = GA_FecthAccountsForBatch.fetchLockedAccountsOnInsert(accList);
                    if( !lockerAccIds.isEmpty()){
                        GA_LockRecords_Batch lockBtch=new GA_LockRecords_Batch(QUEU,DMLOPINSRT,sobjOldmap,lockerAccIds);
                        ID batchprocessid = Database.executeBatch(lockBtch,2000);  
                        GA_Util_lockRecords.isExecuting = true;
                    }
                    
                    List<id> terrAccIds = GA_FecthAccountsForBatch.fetchTerrFlippedAccsOnInsert(accList);
                    if(!terrAccIds.isEmpty()){
                        GA_AccountBatchApexClassForTerritory uptslsTmBtch=new GA_AccountBatchApexClassForTerritory(QRYUPDTSLSTM,terrAccIds);
                        ID uptSlsTmbatchprocessid = Database.executeBatch(uptslsTmBtch,2000); 
                        GA_ACC_AP02_IdentifySalesRepOnAccount.isExecuting = true;
                    }
                }
                if(accNewMap.values().size()==1)
                {
                    if(GA_AP_InvokeCIDOnDml.recrCheck){
                        GA_AP_InvokeCIDOnDml.fetchCIDServiceResponses(accNewMap);
                    }  
                }
            }
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, CLSNAME, METHODNMEAFTERINSERT);
        }
    }
    
    /*********************************************************************************************************************************************
@Description: beforeupdate() method 
@Name : beforeupdate
@Param : list<Account> accList, map<id,Account> accNewMap,map<id,Account>  accoldMap  
@Return : void
@throws Exception : N/A;
**********************************************************************************************************************************************/ 
    public static void beforeupdate(list<Account> accList, map<id,Account> accNewMap, map<id,Account>  accoldMap)
    {
        try
        {
            GA_ACC_BypassRollUpFldsUpdate.bypassRollUpFldsUpdate(accList, accoldMap);

            //User Story 1789, Srinivas Devatha
            //Start :   
            for(Account newAccountRecord : accList){
                if(newAccountRecord.isPartner){}
                Account oldAccountRecord = accoldMap.get(newAccountRecord.Id);
                if(oldAccountRecord.OwnerId != newAccountRecord.OwnerId ){
                	//newAccountRecord.New_Business_Sales_rep__c = oldAccountRecord.OwnerId ;
                }
                // User story 3432
                if(newAccountRecord.RecordType.DeveloperName =='Account_Customer'||
                   newAccountRecord.RecordType.DeveloperName=='Account_Prospect'||
                   newAccountRecord.RecordType.DeveloperName=='Unqualified_Prospect_Agent'){
                newAccountRecord.New_Business_Sales_rep__c =newAccountRecord.ARV_Agent_Name__c; 
                   }
               //End 3432
            }
            //End : Srinivas Devatha
            
            if(!GA_AccountTriggerHandlr.isExecuting && accList.size()>0)
            {
            GA_AccountTriggerHandlr.isExecuting = true;
            GA_GS_AP02_Update_Address.updateAccCountyByZipCode(accList);
            GA_ACC_UpdtGSLastMdfdDt.UpdtGSLstMdfdDt(accList,accoldMap);
            //ARV_AP100_AccountEnrollmentDatesUpdation.updateAccOrigandCurrEnrollDate(accList);//added for US3020
            GA_ACC_AP02_IdentifySalesRepOnAccount.assignRepasOwner(accList);
            GA_ACC_AP02_IdentifySalesRepOnAccount.changePlatinumSts(accList);
            GA_ACC_AP_UnionVldtnCls.showValiderror(accList, accoldMap);
            GA_ACC_AccStatusWFVldtnCls.valdteInctvStatus(accList,accoldMap); 
            //Modified as part of US#2264-Start
            //COMMENTEDYARVASC_Opp_QuoteStartDate.RenewalCycleStartDate(accList, accoldMap);
            //Modified as part of US#2264-End
            
            }
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, CLSNAME, METHODNMEBEFOREUPDATE);
        }
    }
    
    /***********************************************************************************************************************************************
@Description: afterupdate() method 
@Name : afterinsert
@Param : list<Account> accList, map<id,Account> accNewMap,map<id,Account>  accoldMap  
@Return : void
@throws Exception : N/A;
**********************************************************************************************************************************************/ 
    public static void afterupdate(list<Account> accList, map<id,Account> accNewMap,map<id,Account>  accoldMap)
    {
        try{
             checkRenewalDate.checkRenewalDateWithGS(accNewMap,accoldMap);
             updateGWCTransacTableRec(accoldMap, accNewMap);
             ARV_AP99_InsertorUpdateTeamMemonAcc.updateAccountTeamAccess(accNewMap, accoldMap);//added to avoid Submission error
             if(!GA_ACC_updtTBPendDateOnGS.isExecuting){
                GA_ACC_updtTBPendDateOnGS.isExecuting = true;
             GA_ACC_updtTBPendDateOnGS.updtLinkedTPBEndDate(accList, accoldMap);
                }
            if(!GA_ACC_AP01_CheckPlatinumStatusOnAgency.isExecuting ){
                GA_ACC_AP01_CheckPlatinumStatusOnAgency.isExecuting = true;
                GA_ACC_AP01_CheckPlatinumStatusOnAgency.updateCustomerAccountOfAgency(accList, accNewMap,accoldMap);
            }
            
            list<account> accListToLockUnLk=new list<account>();
            list<account> accListOwnerChnge=new list<account>();
            for(account acc:accList)
            {
                account accOld=accoldMap.get(acc.id);
                if(acc.GA_System_of_Record__c !=accOld.GA_System_of_Record__c)
                {
                    accListToLockUnLk.add(acc);
                }
                if(acc.GA_Account_Owner_Manager__c !=accOld.GA_Account_Owner_Manager__c)
                {
                    accListOwnerChnge.add(acc);
                }
            }
            if(accList.size()<acntLckLmt)
            {
                
                if(!GA_Util_lockRecords.isExecuting ){
                    GA_Util_lockRecords.isExecuting = true;
                    GA_Util_lockRecords.onUpdatelockorUnlockRecords(accList, accoldMap,SYSOFREC);
                }
                
                if(!GA_ACC_AP02_IdentifySalesRepOnAccount.isExecuting ){
                    GA_ACC_AP02_IdentifySalesRepOnAccount.isExecuting = true; 
                    GA_ACC_AP02_IdentifySalesRepOnAccount.updatesalesTeamOnAccount(accList, accNewMap, accoldMap);        
                } 
                
                if((!GA_ACC_AP05_CreateHandoverRecord.isExecuting) ){
                    GA_ACC_AP05_CreateHandoverRecord.isExecuting = true;
                    GA_ACC_AP05_CreateHandoverRecord.createhandoverrec(accList, accNewMap,accoldMap);
                }
                if((!GA_ACC_UpdateChildContctsOnAccOwnrChange.isExecuting) ){
                    GA_ACC_UpdateChildContctsOnAccOwnrChange.isExecuting = true;
                    GA_ACC_UpdateChildContctsOnAccOwnrChange.updateAllChildContactsOwner(accList, accoldMap);                
                }
            }
            else
            {
                
                if(!system.isBatch())
                {
                    if(!GA_Util_lockRecords.isExecuting ){  
                        List<Id> lockedAccIds = GA_FecthAccountsForBatch.fetchLockedAccounts(accList, accoldMap);
                        if(!lockedAccIds.isEmpty() ){
                            GA_LockRecords_Batch lockBtch=new GA_LockRecords_Batch(QUEU,DMLOPUPDTE,accoldMap,lockedAccIds);
                             Database.executeBatch(lockBtch,2000);  
                        }
                    }
                    
                    if(!GA_ACC_AP02_IdentifySalesRepOnAccount.isExecuting ){
                        List<Id> terrAccIds = GA_FecthAccountsForBatch.fetchTerrFlippedAccs(accList, accoldMap);
                        if(!terrAccIds.isEmpty() ){
                            GA_AccountBatchApexClassForTerritory uptslsTmBtch=new GA_AccountBatchApexClassForTerritory(QRYUPDTSLSTM,terrAccIds);
                            ID uptSlsTmbatchprocessid = Database.executeBatch(uptslsTmBtch,2000); 
                        }
                    }
                    
                    if(!GA_ACC_AP05_CreateHandoverRecord.isExecuting) {
                        List<Id> prospectToCustomerAccIds = GA_FecthAccountsForBatch.prospectToCustomerAccs(accList, accoldMap);
                        if( !prospectToCustomerAccIds.isEmpty() ){   
                            GA_AccountBatchApexClassForHandover createHandoverBatch=new GA_AccountBatchApexClassForHandover(QRYCREATEHANDOVER,prospectToCustomerAccIds, accoldMap );
                            ID createHandoverbatchprocessid = Database.executeBatch(createHandoverBatch,200);
                        }
                    }
                    
                    if(!GA_AccountBatchToUpdateContactOwner.isInvodedFrmBtch) {
                        Map<Id,Id> accntOwnrToProcess = GA_FecthAccountsForBatch.updateContactOwnerAccs(accList, accoldMap);
                        if( !accntOwnrToProcess.isEmpty() ){   
                            GA_AccountBatchToUpdateContactOwner updateContctsBatch=new GA_AccountBatchToUpdateContactOwner(QRYUPDATECONTCTS,accntOwnrToProcess);
                            ID updateContctsBatchProcessId = Database.executeBatch(updateContctsBatch,200);
                        }
                    }
                }
                
            }
            
            if(!GA_ACC_AP04_UpdtCntOnAccLockUnlock.isExecuting ){
                GA_ACC_AP04_UpdtCntOnAccLockUnlock.isExecuting = true;
                GA_ACC_AP04_UpdtCntOnAccLockUnlock.updateCntlockUnlock(accList, accoldMap);
            }
            if(accListOwnerChnge.size()<acntLckLmt && accListOwnerChnge.size()>0)
            {
                if(!GA_ACC_AP_UpdtAssmntOwnrMgrChnge.isExecuting)
                {
                    GA_ACC_AP_UpdtAssmntOwnrMgrChnge.isExecuting = true;
                    GA_ACC_AP_UpdtAssmntOwnrMgrChnge.updtownrMgrEml(accListOwnerChnge);
                }
                
            }
            else
            {
                list<id> accIds=new list<id>();
                id actId = null;
                for(account acc:accListOwnerChnge)
                {
                    actId=acc.id;
                    accIds.add(actId);
                }
                if(accIds.size()>0 && !system.isBatch()  && !System.isQueueable())
                {
                    GA_UpdtAccAssmntForBatch updateAccAssmntBatch=new GA_UpdtAccAssmntForBatch(accIds);
                    ID updateAccAssmntBatchProcessId = Database.executeBatch(updateAccAssmntBatch,200);  
                }
                
            }
            if(isARVAccountOwnerChanged)
            {
                    //reInsert the queried Account Team Members here
                List<AccountTeamMember> listAccTeam = 
                    (List<AccountTeamMember>) JSON.deserialize(acntTeamJSON,List<AccountTeamMember>.class);
                for(AccountTeamMember objAccTeamMember : listAccTeam){
                    objAccTeamMember.Id= null;
                }
                Upsert listAccTeam;
            }
            
            updateGWCTransacTableRec(accoldMap, accNewMap);
        }
        catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, CLSNAME, METHODNMEAFTERUPDATE);
        }
    }

/***********************************************************************************************************************************************
@Description: change status to 'Completed' for GWC Transaction Table records associated
@Name : updateGWCTransacTableRec
@Param : map<id,Account> oldMap,map<id,Account> newMap  
@Return : void
@throws Exception : N/A;
**********************************************************************************************************************************************/ 
    public static void updateGWCTransacTableRec(Map<Id,Account> oldMap, Map<Id,Account> newMap){
		
        system.debug('entered method ??');
        List<ARV_Gwc_Transaction_Table__c> existingRecs = new List<ARV_Gwc_Transaction_Table__c>();
        List<Id> accIds = new List<Id>();
        Set<ARV_Gwc_Transaction_Table__c> updatedRecs = new Set<ARV_Gwc_Transaction_Table__c>();
        Id recTypeId = Schema.SObjectType.ARV_Gwc_Transaction_Table__c.getRecordTypeInfosByName().get('Maintenance Change').getRecordTypeId();
        
        for(Id accId: newMap.keySet()){
            accIds.add(accId);
        }
        
        existingRecs = [select id, Account_ID__c, Status__c from ARV_Gwc_Transaction_Table__c where Status__c =:SUBMITTED AND Account_ID__c IN:accIds AND RecordTypeId =:recTypeId];
        system.debug('existing GWCTT Records'+existingRecs);
        
        if(existingRecs != null && !existingRecs.isEmpty()){
            for(ARV_Gwc_Transaction_Table__c gwc: existingRecs){
                
                if(newMap.get(gwc.Account_ID__c) != null && oldMap.get(gwc.Account_ID__c) != null){
                    
                    //for Company Name
                    if(newMap.get(gwc.Account_ID__c).Name != oldMap.get(gwc.Account_ID__c).Name){
                        gwc.Status__c = COMPLETED;
                        updatedRecs.add(gwc);
                    }
                    
                    //for Doing Business As
                    if(newMap.get(gwc.Account_ID__c).ARV_Doing_Business_As_DBA__c != oldMap.get(gwc.Account_ID__c).ARV_Doing_Business_As_DBA__c){
                        gwc.Status__c = COMPLETED;
                        updatedRecs.add(gwc);
                    }
                    
                    //for Federal Tax Id
                    if(newMap.get(gwc.Account_ID__c).Federal_Tax_ID__c != oldMap.get(gwc.Account_ID__c).Federal_Tax_ID__c){
                        system.debug('old fed tax---->'+oldMap.get(gwc.Account_ID__c).Federal_Tax_ID__c);
                        system.debug('new fed tax---->'+newMap.get(gwc.Account_ID__c).Federal_Tax_ID__c);
                        gwc.Status__c = COMPLETED;
                        updatedRecs.add(gwc);
                    }
                    
                    //SIC Code
                    if(newMap.get(gwc.Account_ID__c).GA_SIC_Code_Lookup__c != oldMap.get(gwc.Account_ID__c).GA_SIC_Code_Lookup__c){
                        gwc.Status__c = COMPLETED;
                        updatedRecs.add(gwc);
                    }
                    
                    //SPA, hopefully
                    if(newMap.get(gwc.Account_ID__c).GA_Acronym__c != oldMap.get(gwc.Account_ID__c).GA_Acronym__c){
                        gwc.Status__c = COMPLETED;
                        updatedRecs.add(gwc);
                    }				
                    
                    //Is this contact? I feel like it's contact 
                    if((newMap.get(gwc.Account_ID__c).GA_CEO__c != oldMap.get(gwc.Account_ID__c).GA_CEO__c) || (newMap.get(gwc.Account_ID__c).GA_Mutual_Voter__c != oldMap.get(gwc.Account_ID__c).GA_Mutual_Voter__c) || (newMap.get(gwc.Account_ID__c).GA_Principal_Admin__c != oldMap.get(gwc.Account_ID__c).GA_Principal_Admin__c)){
                        gwc.Status__c = COMPLETED;
                        updatedRecs.add(gwc);
                    }
                    
                    //physical address
                    /*if(((newMap.get(gwc.Account_ID__c).ShippingCity != oldMap.get(gwc.Account_ID__c).ShippingCity) || (newMap.get(gwc.Account_ID__c).GA_Mailing_County_id__c != oldMap.get(gwc.Account_ID__c).GA_Mailing_County_id__c) || (newMap.get(gwc.Account_ID__c).ShippingStateCode != oldMap.get(gwc.Account_ID__c).ShippingStateCode) || (newMap.get(gwc.Account_ID__c).ShippingStreet != oldMap.get(gwc.Account_ID__c).ShippingStreet)) && gwc.RatingAreaFlag__c != true){
                        gwc.Status__c = COMPLETED;
                        updatedRecs.add(gwc);
                    }*/
                    
                    if(gwc.RatingAreaFlag__c != true && ((newMap.get(gwc.Account_ID__c).GA_Mailing_County_id__c != oldMap.get(gwc.Account_ID__c).GA_Mailing_County_id__c)||(newMap.get(gwc.Account_ID__c).ShippingAddress != oldMap.get(gwc.Account_ID__c).ShippingAddress))){
                        system.debug('old address---->'+oldMap.get(gwc.Account_ID__c).ShippingAddress);
                        system.debug('new address---->'+newMap.get(gwc.Account_ID__c).ShippingAddress);
                        gwc.Status__c = COMPLETED;
                        updatedRecs.add(gwc);
                    }
                    
                    //mailing address
                    if((newMap.get(gwc.Account_ID__c).BillingCity != oldMap.get(gwc.Account_ID__c).BillingCity) || (newMap.get(gwc.Account_ID__c).GA_Physical_County_id__c != oldMap.get(gwc.Account_ID__c).GA_Physical_County_id__c) || (newMap.get(gwc.Account_ID__c).BillingStateCode != oldMap.get(gwc.Account_ID__c).BillingStateCode) || (newMap.get(gwc.Account_ID__c).BillingStreet != oldMap.get(gwc.Account_ID__c).BillingStreet) || (newMap.get(gwc.Account_ID__c).BillingPostalCode != oldMap.get(gwc.Account_ID__c).BillingPostalCode)){
                        gwc.Status__c = COMPLETED;
                        updatedRecs.add(gwc);
                    }
                }	
            }
            
            if(updatedRecs != null && !updatedRecs.isEmpty()){
                List<ARV_Gwc_Transaction_Table__c> updatedRecsList = new List<ARV_Gwc_Transaction_Table__c>();
                for(ARV_Gwc_Transaction_Table__c gwc: updatedRecs){
                    updatedRecsList.add(gwc);
                }
                system.debug('updated recs'+updatedRecsList);
                Database.update(updatedRecsList);
            }
        }
    }    
}