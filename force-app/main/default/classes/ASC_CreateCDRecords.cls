/**
@Author : Mida Komal
@Name: ASC_CreateCDRecords
@CreatedDate: 29 - June 2020
@version : 1.0

---Modified --
@US3309 -Req#3665 update the adderror methods for associated document language  - 07/22/2020
@TD-0902 - Added By Dinesh - Error message on Document Language - duplicate check
*/
public without sharing class ASC_CreateCDRecords {
    
    private static final String SELECT_STRING ='SELECT ';
    private static final String CLASSNAME ='ASC_CreateCDRecords';
    private static final String METHODNAME_CLONECDRECORDS = 'cloneCDRecords';
    private static final String METHODNAME_CLONEDOCLANGREC = 'cloneDocumentLanguageRecords';
    private static final String NULL_STR = 'null';
    private static final String DOUBLEUNDERSCORE = '__';    
    private static final String OTHER_QUOTE_DOC_LANGUAGE_ERROR = 'The selected Document Language belongs to a different Quote.';
    private static final String OTHER_DOCTYPE_ERROR = 
    'The selected document type does not match with the document type of Document Language';
    private static final String DOCLANGUAGE_FIELD = 'ASC_Document_Language__c';
    private static final String STR_COMMA = ',';
    private static final String ASCQUOTE_FIELD = 'ASC_Quote__c';
    private static final String TEMPLATEUSED_FIELD = 'Template_Used__c';
    private static final String TEMPLATE_FIELD = 'Template__c';
    private static final String STR_EMPTY = '';
    private static final String SCHEDULEAEXHIBIT2 = 'Schedule A - Exhibit 2';
    private static final String SCHEDULEAEX2 = 'Schedule A - Ex 2';
    private static final String SCHEDULEAEXHIBIT1 = 'Schedule A - Exhibit 1';
    private static final String SCHEDULEAEX1 = 'Schedule A - Ex 1';
    private static final String UNDERSCORE = '_';
    public static final string ERROR_MSG_DOCLAN_DUPCHK = system.label.ASC_DocLan_DupChk_In_ConDoc;


    /**
    @Description: Cloning Contractual Document language records
    @Name : cloneCDRecords
    @Param :list<ASC_Contractual_Document__c> cdLst,map<id,ASC_Contractual_Document__c> cdoldMap
    @Return : void
    */
    public static void cloneCDRecords(list<ASC_Contractual_Document__c> cdLst,map<id,ASC_Contractual_Document__c> cdoldMap){
        
      try{
        Set<id> dlIds = new Set<id>();
        Set<id> contractIds = new Set<id>();
        Map<ID,Contract> contractIdMap = new Map<ID,Contract>();
        Map<ID,String> contractQuoteMap = new Map<ID,String>();   
        Map<ID,ASC_Document_Language__c> dlIdMap = new Map<ID,ASC_Document_Language__c>();
        Map<ID,String> dLQuoteMap = new Map<ID,String>();
        ASC_Contractual_Document__c conDocOldMap = new ASC_Contractual_Document__c();        
        Set<String> relatedQuoteRecSet = new Set<String>(); //Added By Dinesh - TD-0902
        Set<String> existingUniqueKeySet = new Set<String>();
        Set<String> existingUniqueKeySet_SCHEDULEAEXHIBIT = new Set<String>();
        
        if(!cdLst.isEmpty()){
            for(ASC_Contractual_Document__c cd :cdLst){ 
                if(cd.ASC_Document_Language__c != null){
                   
                    dlIds.add(cd.ASC_Document_Language__c);
                    contractIds.add(cd.ASC_Contract__c);                                        
                }
            }
        }
        if(!contractIds.isEmpty()){
            contractIdMap = new Map<ID,Contract>([Select Id, vlocity_ins__QuoteId__c from Contract 
                                                  where Id IN :contractIds
                                                  LIMIT :UTIL_SLB.retrieveQueryLimitValue()]);
            
            for(Contract sno: contractIdMap.values()){
                contractQuoteMap.put(sno.Id,sno.vlocity_ins__QuoteId__c);
                relatedQuoteRecSet.add(sno.vlocity_ins__QuoteId__c); //Added By Dinesh - TD-0902
            }
        }               
         
        if(!dlIds.isEmpty()){
            dlIdMap = new Map<ID,ASC_Document_Language__c>([Select Id,ASC_Quote__c,ASC_Document_Type__c from
                                                            ASC_Document_Language__c where Id in :dlIds 
                                                            LIMIT :UTIL_SLB.retrieveQueryLimitValue()]);
            
            for(ASC_Document_Language__c sno: dlIdMap.values()){
                dLQuoteMap.put(sno.Id,sno.ASC_Document_Type__c+DOUBLEUNDERSCORE+sno.ASC_Quote__c);
            }
        }

        
        /*Added By Dinesh - TD-0902 - Start*/
        for(ASC_Document_Language__c queryResult:[select Id,ASC_Quote__c,Name,ASC_Document_Language_State__c,ASC_Document_Type__c,Template__c
                                                  from ASC_Document_Language__c where Template__c = false
                                                  AND ASC_Quote__c IN:relatedQuoteRecSet                                                   
                                                  AND ASC_Document_Language_State__c !=null
                                                  AND ASC_Document_Language_State__c !='Deleted'                                                      
                                                  Limit :UTIL_SLB.retrieveQueryLimitValue()]){
                                                   
           if(!SCHEDULEAEXHIBIT2.equals(queryResult.ASC_Document_Type__c) && !SCHEDULEAEXHIBIT1.equals(queryResult.ASC_Document_Type__c)){                                                                   
             existingUniqueKeySet.add(queryResult.ASC_Quote__c+UNDERSCORE+queryResult.ASC_Document_Type__c);     
           }
           if(SCHEDULEAEXHIBIT2.equals(queryResult.ASC_Document_Type__c) || SCHEDULEAEXHIBIT1.equals(queryResult.ASC_Document_Type__c)){
             existingUniqueKeySet_SCHEDULEAEXHIBIT.add(queryResult.ASC_Quote__c+UNDERSCORE+queryResult.ASC_Document_Type__c);
           }           
        }
        /*Added By Dinesh - TD-0902 - End*/
        
        if(!cdLst.isEmpty()){
            for(ASC_Contractual_Document__c cd :cdLst){ 
                
                String uniqueKey = STR_EMPTY;
                String uniqueKey_SCHEDULEAEXHIBIT1 = STR_EMPTY;
                String uniqueKey_SCHEDULEAEXHIBIT2 = STR_EMPTY; 
                                            
                conDocOldMap = cdoldMap !=null?cdoldMap.get(cd.Id):null;

                String quoteTypeInDL = cd.ASC_Document_Language__c !=null ? dLQuoteMap.get(cd.ASC_Document_Language__c):STR_EMPTY;                
                String quoteIdInDL = String.isNotBlank(quoteTypeInDL)?quoteTypeInDL.substringAfter(DOUBLEUNDERSCORE):STR_EMPTY;
                String documentType = String.isNotBlank(quoteTypeInDL)?quoteTypeInDL.substringBefore(DOUBLEUNDERSCORE):STR_EMPTY;                 
                
                if(!SCHEDULEAEX2.equals(cd.ASC_Document_Type__c) && !SCHEDULEAEX1.equals(cd.ASC_Document_Type__c)){
                  uniqueKey = contractQuoteMap.get(cd.ASC_Contract__c)+UNDERSCORE+cd.ASC_Document_Type__c; //Added By Dinesh - TD-0902
                }
                if(SCHEDULEAEX2.equals(cd.ASC_Document_Type__c)){
                  uniqueKey_SCHEDULEAEXHIBIT2 = contractQuoteMap.get(cd.ASC_Contract__c)+UNDERSCORE+SCHEDULEAEXHIBIT2 ; //Added By Dinesh - TD-0902                 
                }
                if(SCHEDULEAEX1.equals(cd.ASC_Document_Type__c)){
                  uniqueKey_SCHEDULEAEXHIBIT1 = contractQuoteMap.get(cd.ASC_Contract__c)+UNDERSCORE+SCHEDULEAEXHIBIT1 ; //Added By Dinesh - TD-0902                 
                }
                    if(cd.ASC_Document_Language__c !=null 
                       && (documentType.equals(cd.ASC_Document_Type__c) 
                           || (SCHEDULEAEXHIBIT2.equals(documentType) && SCHEDULEAEX2.equals(cd.ASC_Document_Type__c)) 
                           || (SCHEDULEAEXHIBIT1.equals(documentType) && SCHEDULEAEX1.equals(cd.ASC_Document_Type__c)) 
                          )
                      ){                        
                        if(String.isBlank(quoteIdInDL) || NULL_STR.equals(quoteIdInDL)){
                           String quoteId = contractQuoteMap.get(cd.ASC_Contract__c);                                                                      
                            //Clone DL records
                           if(
                            !existingUniqueKeySet.Contains(uniqueKey) &&
                            !existingUniqueKeySet_SCHEDULEAEXHIBIT.Contains(uniqueKey_SCHEDULEAEXHIBIT2) &&
                            !existingUniqueKeySet_SCHEDULEAEXHIBIT.Contains(uniqueKey_SCHEDULEAEXHIBIT1)
                            ){ //Added By Dinesh - TD-0902 only if check
                              String clonedDLId = cloneDocumentLanguageRecords(DOCLANGUAGE_FIELD, cd.ASC_Document_Language__c, quoteId);
                              cd.ASC_Document_Language__c = clonedDLId;
                            }
                            else{                                                   
                              cd.addError(ERROR_MSG_DOCLAN_DUPCHK); //Added By Dinesh - TD-0902
                            }
                        }
                        else if(conDocOldMap == null || 
                                (conDocOldMap!=null && cd.ASC_Document_Language__c !=conDocOldMap.ASC_Document_Language__c)
                              ){
                            String quoteId = contractQuoteMap.get(cd.ASC_Contract__c);
                            if(!quoteId.equals(quoteIdInDL)){
                                cd.addError(OTHER_QUOTE_DOC_LANGUAGE_ERROR);
                            }
                        }
                        else{}
                    }
                    else if(cd.ASC_Document_Language__c !=null 
                            && (conDocOldMap == null || 
                               (conDocOldMap != null && cd.ASC_Document_Language__c !=conDocOldMap.ASC_Document_Language__c))
                           ){
                          cd.addError(OTHER_DOCTYPE_ERROR);
                    }                                
                    else{}                    
            }
        }
       }
       catch(Exception e){            
            GA_LogExceptionCls.LogExcp(e, CLASSNAME, METHODNAME_CLONECDRECORDS);
       }
    }    
    /**
    @Description: Cloning Document language records method 
    @Name : cloneDocumentLanguageRecords
    @Param :String objectAPIName, string recordId,String quoteId
    @Return : Id
    @throws Exception : AuraHandledException;
    */    
    public static Id cloneDocumentLanguageRecords(String objectAPIName, string recordId,String quoteId)
    {
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Set <String> fieldMap = schemaMap.get(objectAPIName).getDescribe().fields.getMap().keySet();
        String soqlQuery = SELECT_STRING ; 
        for (String s :fieldMap ){           
            soqlQuery +=  + s+STR_COMMA;          
        }
        soqlQuery =  soqlQuery.removeEnd(STR_COMMA);
        soqlQuery += ' FROM ' +objectAPIName +' WHERE Id =: recordId';      
        SObject record = Database.query(soqlQuery);
        record.put(ASCQUOTE_FIELD, quoteId); 
        record.put(TEMPLATEUSED_FIELD, recordId);
        record.put(TEMPLATE_FIELD, false);  
        List<SObject> lstOfSObjectToBeInserted = new List<SObject>();
        
        SObject clondedChildRecordID= record.clone(false, true);            
        lstOfSObjectToBeInserted.add(clondedChildRecordID);          
        
        try{
            insert lstOfSObjectToBeInserted ;              
        }
        catch(Exception e){            
            GA_LogExceptionCls.LogExcp(e, CLASSNAME, METHODNAME_CLONEDOCLANGREC);
        }
        return clondedChildRecordID.Id;
    }    
}