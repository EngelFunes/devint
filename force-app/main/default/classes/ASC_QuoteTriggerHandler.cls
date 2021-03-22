/*************************************************************************************************************
@Author : Mida Komal
@Name: ASC_QuoteTriggerHandler
@CreatedDate: 21 - May 2020 
@Description: ASC_QuoteTriggerHandler class is for Quote object.
@version : 1.0  
*************************************************************************************************************/
public with sharing class ASC_QuoteTriggerHandler {
    public static final string CLSNAME  ='ASC_QuoteTriggerHandler';
    public static final string METHODNME  ='beforeUpdate';
    public static final string METHODNME_AFTRUPDT  ='afterUpdate';    
    public static final string METHODNMEAFTERINSERT  ='afterinsert';       
    public static final string QUOTE  ='Quote';    
    public static final string ASC_QUOTE  ='ASC_Quote';    
    private static final String ACCEPTED = 'Accepted';
    private static final String INREVIEW='In Review';
    /*************************************************************************************************************
    @Description        :   beforeUpdate() method 
    @Name               :   beforeUpdate
    @Param              :   list<Quote> quoteList
    @Return             :   void
    @throws Exception   :   N/A;
    *************************************************************************************************************/
    public static void beforeUpdate(list<Quote> quoteList, map<id,Quote> quoteOldMap)
    {
        try{  
            Id quoteRecordTypeId = Schema.SObjectType.Quote.getRecordTypeInfosByDeveloperName().get(ASC_QUOTE).getRecordTypeId();
            List<Quote> newquoteList = new List<Quote>();
            Map<Id, Quote> oldquoteMap = new Map<Id, Quote>();
            List<Quote> newquoteListActnplan = new List<Quote>();
            Map<Id, Quote> oldquoteMapActnplan = new Map<Id, Quote>();
            Map<Id, Id> accountownerId = new Map<Id, Id>();
            set<Id> accountIds = new set<id>();
            if(!quoteList.isEmpty()){
                for(Quote quot:quoteList){
                    accountIds.add(quot.AccountId);
                    if(quoteRecordTypeId.equals(quot.RecordTypeId) && String.isNotBlank(quot.Status) && ACCEPTED.equals(quot.Status)){
                        newquoteList.add(quot);
                        oldquoteMap.put(quot.Id,quoteOldMap.get(quot.Id));
                    }    
                    if(quoteRecordTypeId.equals(quot.RecordTypeId) && String.isNotBlank(quot.Status) && INREVIEW.equals(quot.Status)){
                        newquoteListActnplan.add(quot);
                        oldquoteMapActnplan.put(quot.Id,quoteOldMap.get(quot.Id));
                    }
                } 
                for(Quote qu: [select id, AccountId, Account.OwnerId from Quote where AccountId in :accountIds ]){
                    accountownerId.put(qu.AccountId, qu.Account.OwnerId);
                }
                for(Quote qut:quoteList){
                    if(qut.ASCAccountOwner__c != accountownerId.get(qut.accountId)){
                        qut.ASCAccountOwner__c =  accountownerId.get(qut.accountId);
                    }
                }
            }
            if(!ASC_CreateContractFromQuote.isExecuting){
                ASC_CreateContractFromQuote.isExecuting = true;
                if(!newquoteList.isEmpty()){                    
                    ASC_CreateContractFromQuote.createContractFrmQuote(newquoteList,oldquoteMap);
                }
            }
            
            if(!newquoteListActnplan.isEmpty()){
                ASC_Product_CreateActionPlan.createActionPlanRecord(newquoteListActnplan,oldquoteMapActnplan);
            }
        }
       catch(exception e){
            GA_LogExceptionCls.LogExcp(e, CLSNAME, METHODNME);
        }
    }
    /**************************************************************************************************************
    @Description        :   beforeInsert() method 
    @Name               :   beforeInsert
    @Param              :   list<Quote> quoteList
    @Return             :   void
    @throws Exception   :   N/A;
    **************************************************************************************************************/     
  	/* here we implemented user story 1894 req 4106*/
    public static void beforeInsert(list<Quote> quoteList)
    {
        try{  
            Map<Id, Id> accountownerId = new Map<Id, Id>();
            set<Id> accountIds = new set<id>();
            for(Quote quo: quoteList){
                accountIds.add(quo.accountId);
            }
            for(Quote qu: [select id, AccountId, Account.OwnerId from Quote where AccountId in :accountIds ]){
                    accountownerId.put(qu.AccountId, qu.Account.OwnerId);
                }
            for(Quote q:quoteList){                  
                q.ASCAccountOwner__c= accountownerId.get(q.accountId);
            }                        
        }
        catch(exception e){
            GA_LogExceptionCls.LogExcp(e, CLSNAME, METHODNME);
        }  
    }  
    /*************************************************************************************************************
    @Description: afterinsert() method 
    @Name : afterinsert
    @Param : list<Quote> quoteList, map<id,Quote> quoteOldMap
    @Return : void
    @throws Exception : N/A;
    ************************************************************************************************************/
    public static void afterinsert(list<Quote> quoteList)
    {
        try
        {    
            /*US-3625 -Added By Dinesh -  after insert - This class is used to create/update the Status History Tracking records when there is an update on
            Contract - Status, Invoice Setup ,Signature Status
            Opportunity - StageName , Sub Stage
            Quote - Status
            Plan - Activation Status*/        
            Id quoteRecordTypeId = Schema.SObjectType.Quote.getRecordTypeInfosByDeveloperName().get(ASC_QUOTE).getRecordTypeId();
            List<Quote> newquoteList = new List<Quote>();
            if(!quoteList.isEmpty()){
                for(Quote quot:quoteList){
                    if(quoteRecordTypeId.equals(quot.RecordTypeId)){
                        newquoteList.add(quot);
                    }    
                }           
            }
            if(!ASC_StatusHistoryTracking.isExecuting){
                ASC_StatusHistoryTracking.isExecuting = true;
                if(!newquoteList.isEmpty()){
                    ASC_StatusHistoryTracking.createUpdateStatusHistoryTracking(newquoteList,null,QUOTE);
                }
            }
            if(!ASC_QuoteTriggerHelper.isExecuting){
                ASC_QuoteTriggerHelper.isExecuting = true;
                if(!newquoteList.isEmpty()){
                    ASC_QuoteTriggerHelper.updateQuoteName(newquoteList);
                }
            }                  
            /*US-3625 -Added By Dinesh -  after insert - to update the Contract - Status,Signature Status , Quote - Status, Opportunity - StageName ,Sub Stage.*/              
            if(!newquoteList.isEmpty()){
                ASC_ContractQuoteStatus_OppStageUpdate.updateValues(newquoteList,null,QUOTE); 
            }
            /*US-4379 -Added By Srilaxmi*/            
            if(!newquoteList.isEmpty()){
            ASC_QuoteTriggerHelper.updateQuotepilotfield(newquoteList,null); 
            }
        }  
        catch(exception e){GA_LogExceptionCls.LogExcp(e, CLSNAME, METHODNMEAFTERINSERT);}
    } 
    /*************************************************************************************************************
    @Description: afterUpdate() method 
    @Name : afterUpdate
    @Param : list<Quote> quoteList, map<id,Quote> quoteOldMap
    @Return : void
    @throws Exception : N/A;
	*************************************************************************************************************/
    public static void afterUpdate(list<Quote> quoteList, map<id,Quote> quoteOldMap)
    {
        try{              
            /*US-3625 -Added By Dinesh -  after update - This class is used to create/update the Status History Tracking records when there is an update on
            Contract - Status, Invoice Setup ,Signature Status
            Opportunity - StageName , Sub Stage
            Quote - Status
            Plan - Activation Status*/                   
            Id quoteRecordTypeId = Schema.SObjectType.Quote.getRecordTypeInfosByDeveloperName().get(ASC_QUOTE).getRecordTypeId();
            List<Quote> newquoteList = new List<Quote>();
            Map<Id, Quote> oldquoteMap = new Map<Id, Quote>();
            if(!quoteList.isEmpty()){
                for(Quote quot:quoteList){
                    if(quoteRecordTypeId.equals(quot.RecordTypeId) && quoteOldMap !=null){
                        Quote oldQuote =quoteOldMap.get(quot.Id);
                        if(String.isNotBlank(quot.Status) && oldQuote.Status != quot.Status){
                            newquoteList.add(quot);
                            oldquoteMap.put(quot.Id,oldQuote);
                        }
                        
                        if(quot.Status == 'Denied' && quot.status != oldQuote.Status ){// added US-4103 
                            cancelDfundRequest(quot.id, quot.Dfund_Request__c);
                        }
                    }    
                }           
            }
            if(!newquoteList.isEmpty()){
                ASC_StatusHistoryTracking.createUpdateStatusHistoryTracking(newquoteList,oldquoteMap,QUOTE);
            }
            if(!newquoteList.isEmpty()){
                ASC_DocuSignParticipantHelper.createDocuSignParticipants(newquoteList,oldquoteMap);
            } 
            /*US-3625 -Added By Dinesh -  after update - to update the Contract - Status,Signature Status , Quote - Status, Opportunity - StageName ,Sub Stage.*/        
            if(!newquoteList.isEmpty()){
                ASC_ContractQuoteStatus_OppStageUpdate.updateValues(newquoteList,oldquoteMap,QUOTE);
            }            
        }
        catch(exception e){
            GA_LogExceptionCls.LogExcp(e, CLSNAME, METHODNME_AFTRUPDT);
        }
    }   
    
    /*************************************************************************************************************
    @Description: cloneDfundRequest() method  user story -4103
    @Name : cloneDfundRequest
    @Param : string currentId
    @Return : 
    @throws Exception : ValidateException;
    *************************************************************************************************************/    
   	Public static void cancelDfundRequest(Id quoteId, Id dfundId){
     try{
       if(dfundId != null){
          Dfund_Request__c dfund = [select id, name,Status__c from Dfund_Request__c where id = :dfundId limit 1]; 
          dfund.Status__c ='Canceled';
          update dfund;
          System.debug(dfund);
       }
      }
     catch(Exception e){
          System.debug('DML Exception ' +e);
     }
   } 
}