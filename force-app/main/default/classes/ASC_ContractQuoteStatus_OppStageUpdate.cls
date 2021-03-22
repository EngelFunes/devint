/**
@Author : Dinesh
@Name: ASC_ContractQuoteStatus_OppStageUpdate
@CreatedDate:  22-Sep-2020
@Description: This class is used to update the Contract - Status,Signature Status , Quote - Status, Opportunity - StageName ,Sub Stage.
@version : 1.0
@US Number: US-3625
*/
public without sharing class ASC_ContractQuoteStatus_OppStageUpdate{

    private static final string CLASSNAME  ='ASC_ContractQuoteStatus_OppStageUpdate';
    private static final string METHODNME  ='updateValues';
    private static final String UNDERSCORE = '_';
    private static final String STATUS = 'Status';
    private static final String ID = 'Id';
    private static final String SIGNATURESTATUS = 'ASC_Signature_Status__c';
    private static final String CONTRACTOBJNAME = 'Contract';
    private static final String GA_CLOSEDREASON = 'GA_ClosedReason__c';
    private static final String OTHER = 'Other';
    private static final String GA_OTHERPLEASESPECIFY = 'GA_OtherPleaseSpecify__c';
    private static final String AUTOCLOSED = 'Auto-Closed';
    private static final String BYPASSVALIDATION = 'ByPassValidation__c';
    private static final String OPPORTUNITY = 'Opportunity';
    private static final String STAGENAME = 'StageName';
    /********************************************************************************************************************
    @Description        :   This method is used to update the Status and Stage Values.
    @Name               :   updateValues
    @Param              :   List<sobject> listOfrecords,Map<id,sobject> oldMapOfrecords,String objectAPIName
    @Return             :   void
    @throws Exception   :   N/A;    
    ********************************************************************************************************************************/   
    public static void updateValues(List<sobject> listOfrecords,Map<id,sobject> oldMapOfrecords,String objectAPIName)
    {           
        List<sObject> listOfrecordsToUpdate = new List<sObject>();
        try{                   
            if(!listOfrecords.isEmpty()){
                Map<String,ASC_Contract_Opp_Stage_Mapping__mdt> contractOppMap = new Map<String,ASC_Contract_Opp_Stage_Mapping__mdt>();                
                for(ASC_Contract_Opp_Stage_Mapping__mdt copp :[Select Id,
                                                             Input_Object_Name1__c,
                                                             Input_Field_Name1__c,
                                                             Input_Field_Name1_Value__c,
                                                             Input_Object_Name2__c,
                                                             Input_Field_Name2__c,
                                                             Input_Field_Name2_Value__c,
                                                             Input_Field_Name2_lookup__c,
                                                             Input_Field_Name1_1__c,
                                                             Input_Field_Name1_1_Value__c,
                                                             Input_Field_Name2_1__c,
                                                             Input_Field_Name2_1_Value__c
                                                             from ASC_Contract_Opp_Stage_Mapping__mdt
                                                             LIMIT :UTIL_SLB.retrieveQueryLimitValue()]){            
                   contractOppMap.put(copp.Input_Object_Name1__c+UNDERSCORE+copp.Input_Field_Name1__c+
                                      UNDERSCORE+copp.Input_Field_Name1_Value__c,copp);
                   }   
                                                                                         
                for(sObject eachRec : listOfrecords){ 
                    sObject oldMapInContext = Schema.getGlobalDescribe().get(objectAPIName).newSObject();                 
                    if(oldMapOfrecords !=null){
                      oldMapInContext = oldMapOfrecords.get(eachRec.Id);
                    }                                                                                     
                       
                       //If there is a change in the status field of Contract or Quote
                       //Input Field Name2 (lookup) - getting the lookup field APIName to map it to Id field
                    if(contractOppMap.ContainsKey(objectAPIName+UNDERSCORE+STATUS+UNDERSCORE+String.ValueOf(eachRec.get(STATUS)))
                       && String.isNotBlank(String.ValueOf(eachRec.get(STATUS)))
                       && (oldMapInContext ==null || (oldMapInContext !=null && String.ValueOf(eachRec.get(STATUS)) != String.ValueOf(oldMapInContext.get(STATUS))))){
                      
                       String objLookupAPIName = contractOppMap.get(objectAPIName+UNDERSCORE+STATUS+UNDERSCORE+String.ValueOf(eachRec.get(STATUS))).Input_Field_Name2_lookup__c;                          
                       String objAPIName = contractOppMap.get(objectAPIName+UNDERSCORE+STATUS+UNDERSCORE+String.ValueOf(eachRec.get(STATUS))).Input_Object_Name2__c;   
                       String objFieldName1 = contractOppMap.get(objectAPIName+UNDERSCORE+STATUS+UNDERSCORE+String.ValueOf(eachRec.get(STATUS))).Input_Field_Name2__c; // Input Field Name2
                       String objFieldValue1 = contractOppMap.get(objectAPIName+UNDERSCORE+STATUS+UNDERSCORE+String.ValueOf(eachRec.get(STATUS))).Input_Field_Name2_Value__c; // Input Field Name2 Value                         
                       String objFieldName2 = contractOppMap.get(objectAPIName+UNDERSCORE+STATUS+UNDERSCORE+String.ValueOf(eachRec.get(STATUS))).Input_Field_Name2_1__c;   // Input Field Name2.1
                       String objFieldValue2 = contractOppMap.get(objectAPIName+UNDERSCORE+STATUS+UNDERSCORE+String.ValueOf(eachRec.get(STATUS))).Input_Field_Name2_1_Value__c;   // Input Field Name2.1 Value                       
                       String objFieldNameInContext = contractOppMap.get(objectAPIName+UNDERSCORE+STATUS+UNDERSCORE+String.ValueOf(eachRec.get(STATUS))).Input_Field_Name1_1__c; //Input Field Name1.1                
                       String objFieldValueInContext = contractOppMap.get(objectAPIName+UNDERSCORE+STATUS+UNDERSCORE+String.ValueOf(eachRec.get(STATUS))).Input_Field_Name1_1_Value__c; //Input Field Name1.1 Value
                      
                       //updating same record field values - When Contract Status is Accepted -- Set ASC_Signature_Status__c to Group
                       //when Contract Status is Presented -- Set ASC_Signature_Status__c to Requested
                       /*
                       if(String.isNotBlank(objFieldNameInContext) && String.isNotBlank(objFieldValueInContext)){
                       eachRec.put(objFieldNameInContext,objFieldValueInContext);
                       }
                       */
                       
                       sObject sObj = Schema.getGlobalDescribe().get(objAPIName).newSObject() ;                 
                       if(String.isNotBlank(objLookupAPIName)){
                       sObj.put(ID,String.ValueOf(eachRec.get(objLookupAPIName)));           
                       }                                              
                       
                       if(String.isNotBlank(objFieldName1) && String.isNotBlank(objFieldValue1)){               
                       sObj.put(objFieldName1,objFieldValue1);                                   
                       }
                       if(String.isNotBlank(objFieldName2) && String.isNotBlank(objFieldValue2)){               
                       sObj.put(objFieldName2,objFieldValue2);                                   
                       }
                       
                       //Bypassvalidation to true
                       if(String.isNotBlank(objAPIName) && OPPORTUNITY.equals(objAPIName)
                          && String.isNotBlank(objFieldName1) && STAGENAME.equals(objFieldName1)){
                           sObj.put(BYPASSVALIDATION,true);                         
                       }                  
                       
                       listOfrecordsToUpdate.add(sObj);  
                    }
                    
                    if(CONTRACTOBJNAME.equals(objectAPIName) 
                       && contractOppMap.ContainsKey(objectAPIName+UNDERSCORE+SIGNATURESTATUS+UNDERSCORE+String.ValueOf(eachRec.get(SIGNATURESTATUS)))
                       && String.isNotBlank(String.ValueOf(eachRec.get(SIGNATURESTATUS)))
                       && (oldMapInContext ==null || (oldMapInContext !=null && String.ValueOf(eachRec.get(SIGNATURESTATUS)) != String.ValueOf(oldMapInContext.get(SIGNATURESTATUS))))){  
                       //If there is a change in the ASC_Signature_Status__c field on Contract 
                       //Input Field Name2 (lookup) - getting the lookup field APIName to map it to Id field 
                       String objLookupAPIName_SigSt = contractOppMap.get(objectAPIName+UNDERSCORE+SIGNATURESTATUS+UNDERSCORE+String.ValueOf(eachRec.get(SIGNATURESTATUS))).Input_Field_Name2_lookup__c;                          
                       String objAPIName_SigSt = contractOppMap.get(objectAPIName+UNDERSCORE+SIGNATURESTATUS+UNDERSCORE+String.ValueOf(eachRec.get(SIGNATURESTATUS))).Input_Object_Name2__c;   
                       String objFieldName1_SigSt = contractOppMap.get(objectAPIName+UNDERSCORE+SIGNATURESTATUS+UNDERSCORE+String.ValueOf(eachRec.get(SIGNATURESTATUS))).Input_Field_Name2__c; // Input Field Name2
                       String objFieldValue1_SigSt = contractOppMap.get(objectAPIName+UNDERSCORE+SIGNATURESTATUS+UNDERSCORE+String.ValueOf(eachRec.get(SIGNATURESTATUS))).Input_Field_Name2_Value__c; // Input Field Name2 Value                         
                       String objFieldName2_SigSt = contractOppMap.get(objectAPIName+UNDERSCORE+SIGNATURESTATUS+UNDERSCORE+String.ValueOf(eachRec.get(SIGNATURESTATUS))).Input_Field_Name2_1__c;   // Input Field Name2.1
                       String objFieldValue2_SigSt = contractOppMap.get(objectAPIName+UNDERSCORE+SIGNATURESTATUS+UNDERSCORE+String.ValueOf(eachRec.get(SIGNATURESTATUS))).Input_Field_Name2_1_Value__c;   // Input Field Name2.1 Value                       
                       
                       sObject sObj = Schema.getGlobalDescribe().get(objAPIName_SigSt).newSObject() ;                 
                       if(String.isNotBlank(objLookupAPIName_SigSt)){
                       sObj.put(ID,String.ValueOf(eachRec.get(objLookupAPIName_SigSt)));
                       }
                       if(String.isNotBlank(objFieldName1_SigSt) && String.isNotBlank(objFieldValue1_SigSt)){               
                       sObj.put(objFieldName1_SigSt,objFieldValue1_SigSt);                                   
                       }
                       if(String.isNotBlank(objFieldName2_SigSt) && String.isNotBlank(objFieldValue2_SigSt)){               
                       sObj.put(objFieldName2_SigSt,objFieldValue2_SigSt);                                   
                       
                       //Opportunity - Closed-Won
                         if(GA_CLOSEDREASON.equals(objFieldName2_SigSt) && OTHER.equals(objFieldValue2_SigSt)){
                          sObj.put(GA_OTHERPLEASESPECIFY,AUTOCLOSED);  
                         }
                       }
                       
                       //Bypassvalidation to true
                       if(String.isNotBlank(objAPIName_SigSt) && OPPORTUNITY.equals(objAPIName_SigSt)
                          && String.isNotBlank(objFieldName1_SigSt) && STAGENAME.equals(objFieldName1_SigSt)){
                           sObj.put(BYPASSVALIDATION,true);                         
                       }                  
                                              
                       listOfrecordsToUpdate.add(sObj);                        
                    }   
                                                                                                                                                                    
                }                 
            }  
            if(!listOfrecordsToUpdate.isEmpty()){
              Update listOfrecordsToUpdate;
            }
        }        
        catch(Exception e){             
            GA_LogExceptionCls.LogExcp(e, CLASSNAME, METHODNME);
        }        
    }                
}