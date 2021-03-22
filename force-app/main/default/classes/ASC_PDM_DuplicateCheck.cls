/************************************************************************************************************************
@Author : IDC Offshore
@Name: ASC_PDM_DuplicateCheck
@CreatedDate: 29 - April 2020
@Description: ASC_PDM_DuplicateCheck class is for to check PDM Duplicate records
@version : 1.0  
**********************************************************************************************************************************************/
public without sharing class ASC_PDM_DuplicateCheck {
    public static final string NULLSTRNG='';
    public static final string NONEVAL='--None--';
    public static final string SLASH=' / ';
    private static string pdmInfoErrMsg=system.label.ASC_PDMFieldsInfo_Error;  
    public static final string CLSNAME  ='ASC_PDM_DuplicateCheck';
    public static final string METHODCHECKPDMRECDDUPLICT  ='checkPDMRecdDuplict';
    private static final String UNDERSCORE = '_';
     /**
@Description: checkPDMRecdDuplict() method 
@Name : checkPDMRecdDuplict
@Param : list<Product_Document_Mapping__c> pdmList, map<id,Product_Document_Mapping__c> pdmoldMap
@Return : void
@throws Exception : N/A;
*/    
    public static void checkPDMRecdDuplict(list<Product_Document_Mapping__c> pdmList,
                                           map<id,Product_Document_Mapping__c> pdmoldMap)
    {
        set<String> documentTypeVal =new set<String>();
        set<String> documentVersionVal=new set<String>();
        set<String> sectionVal=new set<String>();
        Set<Decimal> sequenceVal=new Set<Decimal>();
        set<String> existingUniqueKeySet =new set<String>();
        set<String> prdIdSet =new set<String>();
        
        list<Product_Document_Mapping__c> pdmErrorRecdList = new list<Product_Document_Mapping__c>();
        try{
            if(pdmList.size()>0){
                for(Product_Document_Mapping__c pdmRec:pdmList){                    
                    /*string documentTypeVal = pdmRec.Document_Type__c;
string documentVersionVal = pdmRec.Document_Version__c;
string sectionVal = pdmRec.Section__c;
string sequenceVal = string.valueof(pdmRec.Sequence__c); */
                    documentTypeVal.add(pdmRec.Document_Type__c);
                    documentVersionVal.add(pdmRec.Document_Version__c);
                    sectionVal.add(pdmRec.Section__c);
                    sequenceVal.add(pdmRec.Sequence__c);                    
                    prdIdSet.add(pdmRec.Id);
                }
            }
            for(Product_Document_Mapping__c dupRec:[select Id,Document_Type__c,Document_Version__c,Section__c,
                                                    Sequence__c from Product_Document_Mapping__c 
                                                    Where Document_Type__c IN:documentTypeVal 
                                                    AND Document_Version__c IN:documentVersionVal 
                                                    AND Section__c IN:sectionVal                            
                                                    AND Sequence__c IN:sequenceVal
                                                    AND Id Not IN:prdIdSet 
                                                    AND Document_Type__c != null 
                                                    AND Document_Version__c != null 
                                                    AND Section__c != null                            
                                                    AND Sequence__c != null
                                                    Limit :UTIL_SLB.retrieveQueryLimitValue()]){
                                                        existingUniqueKeySet.add(dupRec.Document_Type__c+UNDERSCORE+
                                                                                 dupRec.Document_Version__c+UNDERSCORE+
                                                                                 dupRec.Section__c+UNDERSCORE+dupRec.Sequence__c);           
                                                    } 
            
            if(!existingUniqueKeySet.isEmpty()){                                                                                                                                           
                for(Product_Document_Mapping__c pdm:pdmList){    
                    String uniqueKey = pdm.Document_Type__c+UNDERSCORE+pdm.Document_Version__c+
                        				UNDERSCORE+pdm.Section__c+UNDERSCORE+pdm.Sequence__c;
                    
                    if(pdmoldMap == null || (pdmoldMap !=null && (pdm.Document_Type__c != pdmoldMap.get(pdm.Id).Document_Type__c ||
                                                                  pdm.Document_Version__c != pdmoldMap.get(pdm.Id).Document_Version__c  || pdm.Section__c
                                                                  !=pdmoldMap.get(pdm.Id).Section__c || pdm.Sequence__c != pdmoldMap.get(pdm.Id).Sequence__c ))){  
                                                                      
                                                                      if(existingUniqueKeySet.Contains(uniqueKey)){
                                                                          pdm.addError(pdmInfoErrMsg);
                                                                      }                    
                                                                  }  
                }
            }                       
        }   
        catch(exception e){
            GA_LogExceptionCls.LogExcp(e, CLSNAME, METHODCHECKPDMRECDDUPLICT);
        }      
    }
}