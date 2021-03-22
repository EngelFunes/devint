/**
@Author : Dinesh
@Name: ASC_UpdateComplianceStatusOnAccount
@CreatedDate: 02/02/2021
@Description: This class is used to update the Compliance informtion on the account record associated to the Contract record,
              This will trigger when there is an update happenning on the Contract Status or NonCompliant_Rollup__c rollup field
                                                        
@version : 1.0
@US Number: US-4394
*/
public without sharing class ASC_UpdateComplianceStatusOnAccount{

    private static final string CLASSNAME  ='ASC_UpdateComplianceStatusOnAccount';
    private static final string METHODNME  ='UpdateCompliance';
    private static final String UNDERSCORE = '_';
    private static final String ID = 'Id';
    private static final String STATUS = 'Status';
    private static final String CONTRACT = 'Contract';
    private static final Integer ZERO = 0;
    private static final Integer FIFTEEN = 15;
    private static final string STR_COMMA = ',';
    private static final string STR_EMPTY  = '';
    private static final string CARR_BCBSM = 'BCBSM';
    private static final string CARR_BCN = 'BCN';
    private static final string STR_NA = 'N/A';
    private static final string STR_NONCOMPLIANT = 'Noncompliant';
    private static final string STR_COMPLIANT = 'Compliant';
    private static final List<String> noteligibleContractStatuses = new List<String>{'Cancelled','Rejected'};
    public static final string ASC_CONTRACT = 'ASC_Contract';
    /********************************************************************************************************************
    @Description        :   This method is used to update the Compliance information on the account records associated to the Contract record.
    @Name               :   UpdateCompliance
    @Param              :   List<Contract> listOfrecords,Map<id,Contract> oldMapOfrecords
    @Return             :   void
    @throws Exception   :   N/A;    
    ********************************************************************************************************************************/   
    public static Void UpdateCompliance(List<Contract> listOfrecords,Map<id,Contract> oldMapOfrecords){

        Map<String,String> existingUniqueKeySet =new Map<String,String>();                                        
        Map<Id,Account> recordsToUpdateBCBSM = new Map<Id,Account>();
        Map<Id,Account> recordsToUpdateBCN = new Map<Id,Account>();
        Set<String> recordIdSet = new Set<String>();
        Account acc = new Account();   
        Set<Id> accIdSet = new Set<Id>();
        
        try{        
              if(!listOfrecords.isEmpty()){
               for(Contract eachRec : listOfrecords){                                     
                  sObject oldMapInContext = Schema.getGlobalDescribe().get('Contract').newSObject();
                  if(oldMapOfrecords !=null){
                      oldMapInContext = oldMapOfrecords.get(eachRec.Id);
                  }
                  
                  if(String.isNotBlank(String.ValueOf(eachRec.get(STATUS)))                   
                     && (oldMapInContext !=null 
                         && (String.ValueOf(eachRec.get(STATUS)) != String.ValueOf(oldMapInContext.get(STATUS))
                             || eachRec.NonCompliant_Rollup__c != oldMapInContext.get('NonCompliant_Rollup__c')
                            )
                        )
                    ){
                     recordIdSet.add(String.valueOf(eachRec.Id));  
                     accIdSet.add(eachRec.AccountId);
                  }                                               
               } 
               
               List<Contract> listOfContractRecords = new List<Contract>();
               if(!recordIdSet.isEmpty()){
                 for(Contract uniqRec:[Select Id,
                                       AccountId,                                                                                                                                                            
                                       ASC_Contract_Year__c,
                                       ASC_Carrier__c,
                                       NonCompliant_Rollup__c,
                                       Status                                       
                                       from Contract 
                                       where (Id IN:recordIdSet OR AccountId IN:accIdSet)
                                       AND RecordType.DeveloperName =:ASC_CONTRACT
                                       ORDER BY ASC_Contract_Year__c
                                       LIMIT :UTIL_SLB.retrieveQueryLimitValue()]){                                                                            
                   
                   listOfContractRecords.add(uniqRec);                                      
                   existingUniqueKeySet.put(uniqRec.Id+UNDERSCORE+uniqRec.AccountId+UNDERSCORE+uniqRec.ASC_Carrier__c,uniqRec.ASC_Contract_Year__c);                                                                             
                 }     
               }
              
               String nonCompliantYearBCBSM = STR_EMPTY;
               String nonCompliantYearBCN = STR_EMPTY;                                             
               Set<String> nonCompliantYearDupSetBCBSM = new Set<String>();
               Set<String> nonCompliantYearDupSetBCN = new Set<String>();
               
               if(!listOfContractRecords.isEmpty()){                        
                 
                 for(Contract eachRec : listOfContractRecords){ 
                                     
                      String uniqueKey = eachRec.Id+UNDERSCORE+eachRec.AccountId+UNDERSCORE+eachRec.ASC_Carrier__c;
                      acc = new Account(Id = eachRec.AccountId);
                      
                      if(eachRec.NonCompliant_Rollup__c > 0 
                         && !noteligibleContractStatuses.Contains(eachRec.Status)
                         && existingUniqueKeySet.ContainsKey(eachRec.Id+UNDERSCORE+eachRec.AccountId+UNDERSCORE+CARR_BCBSM) 
                         && !nonCompliantYearDupSetBCBSM.Contains(existingUniqueKeySet.get(eachRec.Id+UNDERSCORE+eachRec.AccountId+UNDERSCORE+CARR_BCBSM))){
                        nonCompliantYearBCBSM += existingUniqueKeySet.get(eachRec.Id+UNDERSCORE+eachRec.AccountId+UNDERSCORE+CARR_BCBSM)+STR_COMMA;     
                        nonCompliantYearDupSetBCBSM.add(existingUniqueKeySet.get(eachRec.Id+UNDERSCORE+eachRec.AccountId+UNDERSCORE+CARR_BCBSM));
                      }
                      if(eachRec.NonCompliant_Rollup__c > 0 
                         && !noteligibleContractStatuses.Contains(eachRec.Status)
                         && existingUniqueKeySet.ContainsKey(eachRec.Id+UNDERSCORE+eachRec.AccountId+UNDERSCORE+CARR_BCN) 
                         && !nonCompliantYearDupSetBCN.Contains(existingUniqueKeySet.get(eachRec.Id+UNDERSCORE+eachRec.AccountId+UNDERSCORE+CARR_BCN))){
                        nonCompliantYearBCN += existingUniqueKeySet.get(eachRec.Id+UNDERSCORE+eachRec.AccountId+UNDERSCORE+CARR_BCN)+STR_COMMA;     
                        nonCompliantYearDupSetBCN.add(existingUniqueKeySet.get(eachRec.Id+UNDERSCORE+eachRec.AccountId+UNDERSCORE+CARR_BCN));
                      }
                                            
                      if(existingUniqueKeySet.ContainsKey(eachRec.Id+UNDERSCORE+eachRec.AccountId+UNDERSCORE+CARR_BCBSM)){
 
                            acc.ASC_Non_Compliant_Year__c = existingUniqueKeySet.ContainsKey(eachRec.Id+UNDERSCORE+eachRec.AccountId+UNDERSCORE+CARR_BCBSM)?nonCompliantYearBCBSM.removeEnd(STR_COMMA):STR_EMPTY;                            
                                                         
                            if(String.isNotBlank(acc.ASC_Non_Compliant_Year__c)){                              
                              acc.BCBSM_Compliance_Status__c = STR_NONCOMPLIANT;
                              acc.ASC_Compliant__c = false;
                            }
                            else if(String.isBlank(acc.ASC_Non_Compliant_Year__c)                                  
                            ){                              
                              acc.BCBSM_Compliance_Status__c = STR_COMPLIANT;
                            }                             
                            recordsToUpdateBCBSM.put(acc.Id,acc);
                      }                      
                      
                      if(existingUniqueKeySet.ContainsKey(eachRec.Id+UNDERSCORE+eachRec.AccountId+UNDERSCORE+CARR_BCN)){
 
                            acc.BCN_Non_Compliant_Year__c = existingUniqueKeySet.ContainsKey(eachRec.Id+UNDERSCORE+eachRec.AccountId+UNDERSCORE+CARR_BCN)?nonCompliantYearBCN.removeEnd(STR_COMMA):STR_EMPTY;                            
                                                        
                            if(String.isNotBlank(acc.BCN_Non_Compliant_Year__c)){                              
                              acc.BCN_Compliance_Status__c = STR_NONCOMPLIANT;
                              acc.ASC_Compliant__c = false;
                            }
                            else if(String.isBlank(acc.BCN_Non_Compliant_Year__c)                                    
                            ){                              
                              acc.BCN_Compliance_Status__c = STR_COMPLIANT;
                            }                          
                            recordsToUpdateBCN.put(acc.Id,acc);                            
                      }                                                                                             
                 } 
               }           
                                         
               if(recordsToUpdateBCBSM !=null && !recordsToUpdateBCBSM.Values().isEmpty()){
                 Update recordsToUpdateBCBSM.Values();
               }
               if(recordsToUpdateBCN !=null && !recordsToUpdateBCN.Values().isEmpty()){
                 Update recordsToUpdateBCN.Values();
               }               
            }
        }
        catch(Exception e){             
            GA_LogExceptionCls.LogExcp(e,CLASSNAME , METHODNME);
        }   
    }
}