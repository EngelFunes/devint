/**
@Author : Dinesh
@Name: ASC_DocumentLanguage_TriggerHelper
@CreatedDate: 28 - July - 2020 
@Description: This class is to used for Validation - Duplicate check - To prevent record creation/updation
@version : 1.0  
@US Number: US-3309
*/
public class ASC_DocumentLanguage_TriggerHelper {

    public static final string CLSNAME  ='ASC_DocumentLanguage_TriggerHandler';
    public static final string METHODNME  ='checkDuplicateDocLangugaeRecords';
    public static final string ERROR_MSG = system.label.ASC_DocLanguage_DuplicateCheck;
    private static final String UNDERSCORE = '_';

   /********************************************************************************************************************
    @Description        :   This method is used to check for duplicate check on combition of fields , 
                            if there is match exist on record , it will prevent to create a new records updating the existing records
                            To restrict the user to create more than 1 active/draft record.
    @Name               :   checkForDuplicateDocLanguage
    @Param              :   list<ASC_Document_Language__c> doclList,map<id,ASC_Document_Language__c> doclOldMap
    @Return             :   void
    @throws Exception   :   N/A;    
    ********************************************************************************************************************************/             
    public static void checkForDuplicateDocLanguage(list<ASC_Document_Language__c> doclList,
                                                    map<id,ASC_Document_Language__c> doclOldMap)
    {        
        Set<String> existingUniqueKeySet = new Set<String>();
        Set<String> existingUniqueKeySet_Template = new Set<String>();
        Set<String> relatedQuoteRecSet = new Set<String>();
        Set<String> docTypeSet = new Set<String>();
        Set<String> docLStatus = new Set<String>();
        Set<String> docLIDSet = new Set<String>();
        try{        
          if(!doclList.isEmpty()){
            for(ASC_Document_Language__c docl:doclList){
                system.debug(docl.ASC_Quote__c);
                relatedQuoteRecSet.add(docl.ASC_Quote__c);                  
                docTypeSet.add(docl.ASC_Document_Type__c);
                docLStatus.add(docl.ASC_Document_Language_State__c);
                docLIDSet.add(docl.Id);
            }
                  
            for(ASC_Document_Language__c queryResult:[select Id,ASC_Quote__c,Name,ASC_Document_Language_State__c,ASC_Document_Type__c,Template__c
                                                      from ASC_Document_Language__c where Template__c = false
                                                      AND ASC_Quote__c IN:relatedQuoteRecSet 
                                                      AND ASC_Document_Type__c IN: docTypeSet
                                                      AND ASC_Document_Language_State__c !=null
                                                      AND ASC_Document_Language_State__c !='Deleted'                                                      
                                                      AND ID Not IN:docLIDSet
                                                      Limit :UTIL_SLB.retrieveQueryLimitValue()]){
                                                                                  
               existingUniqueKeySet.add(queryResult.ASC_Quote__c+UNDERSCORE+queryResult.ASC_Document_Type__c);            
            }
            
            for(ASC_Document_Language__c queryResult:[select Id,ASC_Quote__c,Name,ASC_Document_Language_State__c,ASC_Document_Type__c,Template__c
                                                      from ASC_Document_Language__c where Template__c = true                                                      
                                                      AND ASC_Document_Type__c IN: docTypeSet
                                                      AND ASC_Document_Language_State__c !=null
                                                      AND ASC_Document_Language_State__c !='Deleted'                                                      
                                                      AND ID Not IN:docLIDSet
                                                      Limit :UTIL_SLB.retrieveQueryLimitValue()]){
                                                                                  
               existingUniqueKeySet_Template.add(queryResult.ASC_Document_Type__c+UNDERSCORE+queryResult.Template__c);          
            }
         
            if(!existingUniqueKeySet.isEmpty() || !existingUniqueKeySet_Template.isEmpty()){                                                                                                                                           
                for(ASC_Document_Language__c docl:doclList){    
                    String uniqueKey = docl.ASC_Quote__c+UNDERSCORE+docl.ASC_Document_Type__c;
                    String uniqueKey_Template = docl.ASC_Document_Type__c+UNDERSCORE+docl.Template__c;
                     
                     if(existingUniqueKeySet.Contains(uniqueKey)
                        && docl.Template__c == false 
                        && !'Deleted'.equals(docl.ASC_Document_Language_State__c)
                        && (doclOldMap == null || (doclOldMap !=null && ((docl.ASC_Document_Language_State__c != doclOldMap.get(docl.Id).ASC_Document_Language_State__c) 
                                                                         || (docl.ASC_Document_Type__c != doclOldMap.get(docl.Id).ASC_Document_Type__c))))){                                                 
                           docl.addError(ERROR_MSG);                                         
                     } 
                     if(existingUniqueKeySet_Template.Contains(uniqueKey_Template)
                        && docl.Template__c == true 
                        && docl.ASC_Quote__c == null
                        && !'Deleted'.equals(docl.ASC_Document_Language_State__c)
                        && (doclOldMap == null || (doclOldMap !=null && ((docl.ASC_Document_Language_State__c != doclOldMap.get(docl.Id).ASC_Document_Language_State__c) 
                                                                         || (docl.ASC_Document_Type__c != doclOldMap.get(docl.Id).ASC_Document_Type__c))))){  
                                                
                           docl.addError(ERROR_MSG);                         
                     } 
                }
            }            
          }
        }
        catch(exception e){
            GA_LogExceptionCls.LogExcp(e, CLSNAME, METHODNME);
        }
    }           
}