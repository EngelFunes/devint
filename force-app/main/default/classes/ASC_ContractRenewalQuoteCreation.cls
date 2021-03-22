/*************************************************************************************************************
@Author : Dinesh
@Name: ASC_ContractRenewalQuoteCreation
@CreatedDate:  05-29-2020 
@Description: ASC_ContractRenewalQuoteCreation class 
@version : 1.0  
@US# :US-1830
*************************************************************************************************************/
public without sharing class ASC_ContractRenewalQuoteCreation {
    private static final string CLSNAME = 'ASC_ContractRenewalQuoteCreation';
    private static final string METHODNME1 = 'createQuote';
    private static final string METHODNME2 = 'getQuoteDetails';
    private static final string METHODNME3 = 'validateContractDetails';
    private static final string PROCEDURE_NAME = 'ASC_CreateRenewalQuote';
    private static final string IP_FAILED = 'ipfailed';
    private static final string SUCCESS = 'success';
    private static final string QUOTEID = 'quoteId';
    private static final string CONTEXTID = 'ContextId';
    private static final string RENEWALYEAR = 'RenewalYear';
    private static final string STARTDATE = 'StartDate';
    private static final string ENDDATE = 'EndDate';
    private static final string ERRMSG ='Aura Error';
    private static final string STR_EMPTY ='';
    private static final string CARRIER_CID_ERRORMSG = 'Both Carrier and CID are mandatory to proceed with Renewal Quote.';
    private static final string NOACCESS_ERROR = 'Insufficient Privileges – you do not have the level of access required to perform this action.';
    private static final List<String> PERMISSIONSETNAMES = new List<String>{'ASC_Quoting_Specialist'};
    private static final List<String> PROFILENAMES = new List<String>{'System Administrator','Support Admin'};
    /**************************************************************************************************************
    @Description        :   This method is used to create the Quote record using Integration Procedure method
    @Name               :   createQuote
    @Param              :   Id rId,String renewalyr,String strDate,String endDate
    @Return             :   String
    @throws Exception   :   Aura Exception    
    **************************************************************************************************************/           
    @AuraEnabled
    public static String createQuote(Id rId,String renewalyr,
                                     String strDate,String endDate){
        String result = STR_EMPTY;
        try
        {
            if(rId !=null && !String.isBlank(renewalyr) 
               && !String.isBlank(strDate) && !String.isBlank(endDate)){
               CreateQuoteFromIPService(rId,renewalyr,strDate,endDate);
            }
        }            
        catch(exception e){
            GA_LogExceptionCls.LogExcp(e, CLSNAME, METHODNME1); throw new AuraHandledException(ERRMSG); 
        } 
        return result;
    }
    /**************************************************************************************************************
    @Description        :   This method is used to create the Quote record using Integration Procedure
    @Name               :   CreateQuoteFromIPService
    @Param              :   Id rId,String renewalyr,String strDate,String endDate
    @Return             :   String
    @throws Exception   :   Aura Exception    
    **************************************************************************************************************/           
     @future
     public static void CreateQuoteFromIPService(Id rId,String renewalyr,
                                     String strDate,String endDate) {
        String result = '';
        try
        {
            if(rId !=null && !String.isBlank(renewalyr) 
               && !String.isBlank(strDate) && !String.isBlank(endDate)){
                Map<String, Object> ipInput = new Map <String, Object>();
                Map<String, Object> ipOutput = new Map <String, Object>();
                Map<String, Object> ipOptions = new Map <String, Object>();
                ipInput.put(CONTEXTID,rId);
                ipInput.put(RENEWALYEAR,renewalyr);
                ipInput.put(STARTDATE, strDate);
                ipInput.put('EndDate', endDate);
                System.debug('**ipinput'+ipInput);   
                ipOutput = (Map <String, Object>) vlocity_ins.IntegrationProcedureService.runIntegrationService(PROCEDURE_NAME, ipInput, ipOptions);    
                System.debug('**ipoutput'+ipOutput);      
                if(ipOutput !=null && ipOutput.get(QUOTEID) !=null){
                    result = (String)ipOutput.get(QUOTEID);
                 //Added by Vishwa
                  Quote q = [select id , AccountId, ASC_Quote_Type__c, ParentContractId__c from quote where id = :result limit 1];
                  q.ParentContractId__c = rId;
                  update q;
                  //end by vishwa
                }
                else if(ipOutput.get(SUCCESS) == false){
                  result = IP_FAILED;
                }
                else{
                }
            }          
        }        
        catch(exception e){
            GA_LogExceptionCls.LogExcp(e, CLSNAME, METHODNME1);
        }         
     }
    /**************************************************************************************************************
    @Description        :   This method is used to fetch the quote records to display it in Model Popup - Possible Duplicate Quotes
    @Name               :   getQuoteDetails
    @Param              :   String renewalyr,String rId
    @Return             :   List<Quote>
    @throws Exception   :   Aura Exception    
    **************************************************************************************************************/   
    @AuraEnabled
    public static List<Quote> getQuoteDetails(String renewalyr,String rId){
        List<Quote> qtList = new List<Quote>();
        try{
            if(rId !=null){
              Contract contr = [Select Id,CID__c,ASC_Carrier__c from Contract 
                                where Id=:rId Limit 1];
              if(!String.isBlank(renewalyr) !=null && !String.isBlank(contr.CID__c) 
                 && !String.isBlank(contr.ASC_Carrier__c)){
                qtList = [Select Id,QuoteNumber,vlocity_ins__EffectiveDate__c,
                                      vlocity_ins__EndDate__c,Status,
                                      ASC_Carrier__c,ASC_CID__c from Quote 
                                      Where ASC_Renewal_Year__c =:renewalyr
                                      AND ASC_CID__c =:contr.CID__c
                                      AND ASC_Carrier__c =:contr.ASC_Carrier__c
                                      ORDER BY QuoteNumber DESC
                                      Limit :UTIL_SLB.retrieveQueryLimitValue()];                
              }
            }
            return qtList;                        
        }        
        catch(exception e){
            GA_LogExceptionCls.LogExcp(e, CLSNAME, METHODNME2); throw new AuraHandledException(ERRMSG); 
        } 
    }
    /**************************************************************************************************************
    @Description        :   This method is used to validate the Carrier and CID data in the Contract record.
    @Name               :   validateContractDetails
    @Param              :   String rId
    @Return             :   Boolean
    @throws Exception   :   Aura Exception    
    **************************************************************************************************************/   
    @AuraEnabled
    public static String validateContractDetails(String rId){
        String result = STR_EMPTY;
        try{
            if(rId !=null){
                
                User currentuser = [SELECT Id, Profile.Name FROM User where Id=:UserInfo.getUserId() LIMIT 1];
            
                Contract contr = [Select Id,CID__c,ASC_Carrier__c from Contract 
                                  where Id=:rId Limit 1];
                
                /*TD-2181 Added By Dinesh - Only Quote specialist permission User /System Administrator/Support Admi should not be able to Renew the Quote. */
                List<PermissionSetAssignment> userpermissionSet = [select PermissionSet.Name from PermissionSetAssignment 
                                           where AssigneeId =:UserInfo.getUserId() 
                                           AND PermissionSet.Name IN:PERMISSIONSETNAMES
                                           Limit :UTIL_SLB.retrieveQueryLimitValue()];
                
                if(!PROFILENAMES.Contains(currentuser.Profile.Name) && userpermissionSet.isEmpty()){ 
                 result = NOACCESS_ERROR;
                }
                /*TD-2181 Added By Dinesh - End*/                
                else if(String.isBlank(contr.CID__c) 
                   || String.isBlank(contr.ASC_Carrier__c)){
                 result = CARRIER_CID_ERRORMSG;
                }
                else{
                 result = SUCCESS;
                }
            }
            return result;                        
        }        
        catch(exception e){
            GA_LogExceptionCls.LogExcp(e, CLSNAME, METHODNME3); throw new AuraHandledException(ERRMSG); 
        } 
    }
}