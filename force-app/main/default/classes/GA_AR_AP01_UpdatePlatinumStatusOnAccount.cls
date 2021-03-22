/**
@Author : Padmahaarika Jayana
@Name: GA_AR_AP01_UpdatePlatinumStatusOnAccount
@CreatedDate: 24- Jul 2017 
@Description: GA_AR_AP01_UpdatePlatinumStatusOnAccount class is for creating/updating Agency relation and updating platinum 
status on customer account
@version : 1.0  
*/
public with sharing class GA_AR_AP01_UpdatePlatinumStatusOnAccount{
    public static boolean isExecuting = false;
    public static final String VarTrue = 'true';
    public static final String VarFalse = 'false';
    public static final String PlatErrMsg ='This Account is locked and cannot be updated in Salesforce. All modifications to the Account must be made in SMART';
    public static final string ClsName  ='GA_AR_AP01_UpdatePlatinumStatusOnAccount';
    public static final string methodNme  ='createAgencyRelation';
    public static final string ARqury='Select Id,GA_Agency__c,GA_Account__c,GA_Is_Active__c FROM GA_AgencyRelationship__c ';
    public static final string ARWhr='where GA_Account__c in ';
    public static final string ARLimit=' Limit 1000';
    public static final string actqury='Select Id,GA_Platinum__C,Account_Status__c,GA_Active_Account_Status__c from Account ';
    public static final string actWhr='where id in ';
    public static final string actLimit=' Limit 5000';
    public static List<GA_AgencyRelationship__c> CustomerAcctAgencyRelation=new List<GA_AgencyRelationship__c>();
        /**
@Description: ValidateException
@Name : ValidateException
@Param : non
@Return : void
@throws Exception : N/A;
*/ 
    public with sharing class ValidateException extends Exception {}
    
    /**
@Description: createAgencyRelation() method 
@Name : createAgencyRelation
@Param : list<GA_AgencyRelationship__c> arList, map<id,GA_AgencyRelationship__c> arNewMap
@Return : void
@throws Exception : N/A;
*/ 
public static void createAgencyRelation(list<GA_AgencyRelationship__c> arList, map<id,GA_AgencyRelationship__c> arNewMap)
    {
        try{
            Set<Id> agencyAccIdSet = New Set<Id>();
            Set<Id> cutomerAccIdSet = New Set<Id>();   
            Map<Id,account> agencyAcctPlatinumStatus =  New Map<Id,account>();
            Map<Id,GA_AgencyRelationship__c> custAccountAgencyRelationMap =New Map<Id,GA_AgencyRelationship__c>();
            Map<Id,Account> accountsMap = New Map<Id,Account>();
            if(!arList.isEmpty()) {
                for(GA_AgencyRelationship__c ar : arList){
                    id agncyId=ar.GA_Agency__c;
                    id acctId=ar.GA_Account__c;
                    agencyAccIdSet.add(agncyId);
                    cutomerAccIdSet.add(acctId);
                }
                
                customerAcctAgencyRelation =  New  List<GA_AgencyRelationship__c> ();
                
                if(!cutomerAccIdSet.isEmpty()){
                    
                     // fetch the set id's in String with comma seperated 
                    String customerAccIdString = GA_Util08_FilterProcessHelper.idSet(cutomerAccIdSet);
                    
                    //Fetch the Agency Relations with all customer accounts based in Agency Acc Id to update the platinum status
                    custAccountAgencyRelationMap = GA_Util04_AgencyRelDataAccessHelper.fetchAgencyRelationsMap(ARqury, ARWhr + customerAccIdString, GA_Util04_AgencyRelDataAccessHelper.BLANK, ARLimit);
                    if(!custAccountAgencyRelationMap.isEmpty()){
                    customerAcctAgencyRelation =  custAccountAgencyRelationMap.values();  
                        }
		
                    
                   
                    if(!customerAcctAgencyRelation.isEmpty()){
                        for(GA_AgencyRelationship__c cr : customerAcctAgencyRelation){
                            id agncyCustId=cr.GA_Agency__c;
                            agencyAccIdSet.add(agncyCustId);
                        }
                    }
                }
                
                if(!agencyAccIdSet.isEmpty()){
                    // fetch the set id's in String with comma seperated 
                    String agencyAccIdString = GA_Util08_FilterProcessHelper.idSet(agencyAccIdSet);
                    
                    accountsMap = GA_Util03_AccountDataAccessHelper.fetchAccountsMap(actqury, actWhr + agencyAccIdString , GA_Util03_AccountDataAccessHelper.BLANK, actLimit);
                    
                    List<Account> agencyAccts = New List<Account>();
                         if(!accountsMap.isEmpty()){
                           agencyAccts  =  accountsMap.values();
                         } 
                    
                    
                    if(!agencyAccts.isEmpty()){    
                        for (Account a : agencyAccts){
                            agencyAcctPlatinumStatus.put(a.id,a);
                        }
                    }                
                }
                
                Map<String,Id> accountPlatinumStatusMap =  New Map<String,Id>();
                if(!customerAcctAgencyRelation.isEmpty()){
                    for(GA_AgencyRelationship__c ar : customerAcctAgencyRelation){
                        
                        for(Id agentAccId : agencyAcctPlatinumStatus.keySet()){
                                 
                            if(agentAccId== ar.GA_Agency__c && (agencyAcctPlatinumStatus.get(agentAccId).GA_Platinum__c == false || !agencyAcctPlatinumStatus.get(agentAccId).GA_Active_Account_Status__c || !ar.GA_Is_Active__c)){
                                accountPlatinumStatusMap.put(ar.GA_Account__c+System.Label.Hyphen+varFalse,ar.GA_Account__c);
                            }
                            if(agentAccId== ar.GA_Agency__c && (agencyAcctPlatinumStatus.get(agentAccId).GA_Platinum__c == true && agencyAcctPlatinumStatus.get(agentAccId).GA_Active_Account_Status__c && ar.GA_Is_Active__c)){
                                accountPlatinumStatusMap.put(ar.GA_Account__c+System.Label.Hyphen+varTrue,ar.GA_Account__c);
                            }
                        }
                        
                    }
                }
                else
                {
                    for(GA_AgencyRelationship__c ar : arList){
                        accountPlatinumStatusMap.put(ar.GA_Account__c+System.Label.Hyphen+varFalse,ar.GA_Account__c);   
                    }
                }
                List<Account> custAcctListFltr = New List<Account>();
                List<Account> custAcctList = New List<Account>();
                
                
                custAcctList = [Select Id,GA_Platinum__c from Account where id in :(cutomerAccIdSet) limit 5000];
                if(!custAcctList.isEmpty())   {
                    custAcctListFltr = New List<Account>();
                    for(Account acc : custAcctList){
                        if(!accountPlatinumStatusMap.isEmpty()){
                            if(accountPlatinumStatusMap.containsKey(acc.id+System.Label.Hyphen+varTrue)){
                                acc.GA_Platinum__c = true;
                                acc.GA_Is_Mass_Updating__c = true;
                                custAcctListFltr.add(acc);
                            } 
                            
                            else{
                                acc.GA_Platinum__c = false;
                                acc.GA_Is_Mass_Updating__c = true;
                                custAcctListFltr.add(acc);
                            }
                        }
                    }
                    
                }
                if(!custAcctListFltr.isEmpty()){
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
                  GA_Util03_AccountDataAccessHelper.dmlOnAccount(custAcctListFltr, GA_Util03_AccountDataAccessHelper.UPDATE_OPERATION);
                }
            }
        }
        catch (Exception e){
            
            GA_LogExceptionCls.LogExcp(e, ClsName, methodNme);
            arList[0].adderror(platErrMsg);
        }
    }
}