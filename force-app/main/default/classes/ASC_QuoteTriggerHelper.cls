/*
@Author : Dinesh
@Name: ASC_QuoteTriggerHelper
@CreatedDate: 12-Oct-2020 
@Description: ASC_QuoteTriggerHelper class is used to support the ASC_QuoteTriggerHandler class
@version : 1.0  
*/
public class ASC_QuoteTriggerHelper{

    public static final string CLSNAME  ='ASC_QuoteTriggerHelper';
    public static final string METHODNME  ='updateQuoteName';
    public static boolean isExecuting = false;
    private static final string QUOTNAME = 'Name';
    private static final string ASCQUOTE = 'ASCQuote';
    private static final string HYPSYM = '-';
    public static final string ASC_QUOTE  ='ASC_Quote';    
    public static final Id ASC_QUOTE_RECTYPEID = 
    Schema.SObjectType.Quote.getRecordTypeInfosByName().get('ASC Quote').getRecordTypeId();
    public static final string ASCQUOTE_STR = 'ASC Quote';
    
    /********************************************************************************************************************
    @Description        :   This method is used to update the Quote Name field once Quote has been created
    @Name               :   updateQuoteName
    @Param              :   list<Quote> quotList
    @Return             :   void
    @throws Exception   :   N/A;    
    ********************************************************************************************************************************/   
    public static void updateQuoteName(list<Quote> quotList){     
        
        try{
            List<Quote> quoteListToUpdate = new List<Quote>();
            //TD-1249 - Added By Dinesh - Update Quote Name - Clone Quote
            for(Quote eachRec : [Select Id,Name,ASC_CID__c,ASC_Carrier__c,QuoteNumber from Quote where Id IN:quotList Limit :UTIL_SLB.retrieveQueryLimitValue()]){ 
                  eachRec.Name = ASCQUOTE+HYPSYM+ eachRec.ASC_CID__c +HYPSYM+ eachRec.ASC_Carrier__c +HYPSYM +eachRec.QuoteNumber; 
                  eachRec.ByPass_QuoteName_Updt__c = true;
                  quoteListToUpdate.add(eachRec);                          
            }                         
            if(!quoteListToUpdate.isEmpty()){            
              Update quoteListToUpdate;
            }   
        } 
        catch(exception e){GA_LogExceptionCls.LogExcp(e, CLSNAME, METHODNME);}
    }
        
    /********************************************************************************************************************
    @Description        :   This method is used to update the pilot Territory field on the quote (while creating the quote record) and this field will be used in the 
                            quote Approval process to trigger the Sales Manager Approval Step.
    @Name               :   updateQuotepilotfield
    @Param              :   list<Quote> quoteList,map<id,Quote> quoteOldMap
    @Return             :   void
    @throws Exception   :   N/A;    
    US Number           :   US4379
    ********************************************************************************************************************************/   
    public static void updateQuotepilotfield(list<Quote> quoteList,map<id,Quote> quoteOldMap){

        List<Quote> quoteListToUpdate = new List<Quote>();                                      
        Set<Id> terrnameIdSet = new Set<Id>();
        
        if(!quoteList.isEmpty()){
            for(ASC_Pilot_Territory__c pl:[Select id, Territory_Name__c,Pilot_Access__c 
                                           from ASC_Pilot_Territory__c 
                                           where Pilot_Access__c =:ASCQUOTE_STR 
                                           Limit :UTIL_SLB.retrieveQueryLimitValue()]){
              terrnameIdSet.add(pl.Territory_Name__c);
            }        
            
            for(Quote qt:[Select Id,RecordTypeId,AccountId,Account.GA_Territory__c from Quote where Id IN:quoteList
                          Limit :UTIL_SLB.retrieveQueryLimitValue()]){
    
               if(ASC_QUOTE_RECTYPEID.equals(qt.RecordTypeId) && terrnameIdSet.Contains(qt.Account.GA_Territory__c)){
                  qt.ASC_Pilot_Territory__c = true;      
                  quoteListToUpdate.add(qt);
               }        
            }
        }
        if(!quoteListToUpdate.isEmpty()){
          Update quoteListToUpdate;
        }
     }
}