/**
@Author : Dinesh
@Name: ASC_StatusHistoryTracking
@CreatedDate:  22-Sep-2020
@Description: This class is used to create/update the Status History Tracking records when there is an update on
              Contract - Status, Invoice Setup ,Signature Status
              Opportunity - StageName , Sub Stage
              Quote - Status
              Plan - Activation Status
@version : 1.0
@US Number: US-3625
*/
public class ASC_StatusHistoryTracking{

    private static final string CLASSNAME  ='ASC_StatusHistoryTracking';
    private static final string METHODNME  ='createUpdateStatusHistoryTracking';
    private static final String UNDERSCORE = '_';
    private static final String ID = 'Id';
    private static final String STATUS = 'Status';
    private static final String STAGENAME = 'StageName';
    private static final String STAGE = 'Stage';
    private static final String ASC_SUBSTAGE = 'ASC_Sub_stage__c';
    private static final String SUBSTAGE = 'ASC Sub-Stage';
    private static final String ACTIVATIONSTATUS = 'Activation Status';
    private static final String ASC_ACTIVATIONSTATUS = 'ASC_Activation_Status__c';
    private static final String CONTRACTSTATUS = 'Contract Status';
    private static final String QUOTESTATUS = 'Quote Status';
    private static final String SIGNATURESTATUS = 'Signature Status';
    private static final String ASC_SIGNATURESTATUS = 'ASC_Signature_Status__c';
    private static final String ASC_INVOICESETUP = 'ASC_Invoice_Setup__c';
    private static final String INVOICESETUP = 'Invoice Setup';
    private static final String OPPORTUNITY = 'Opportunity';
    private static final String QUOTE = 'Quote';    
    private static final String CONTRACT = 'Contract';
    private static final String PLAN_OBJ = 'vlocity_ins__ContractLineItem__c';
    private static final String PLAN = 'Plan';
    public static boolean isExecuting = false;
    private static final Integer ZERO = 0;
    private static final Integer FIFTEEN = 15;
    
    /********************************************************************************************************************
    @Description        :   This method is used to create/update the Status History Tracking records - Reporting Purpose.
    @Name               :   createUpdateStatusHistoryTracking
    @Param              :   List<sobject> listOfrecords,Map<id,sobject> oldMapOfrecords,String objectAPIName
    @Return             :   void
    @throws Exception   :   N/A;    
    ********************************************************************************************************************************/   
    public static Void createUpdateStatusHistoryTracking(List<sobject> listOfrecords,Map<id,sobject> oldMapOfrecords,String objectAPIName){

        Map<String,Id> existingUniqueKeySet =new Map<String,Id>();
        List<sObject> recordsToUpsert = new List<sObject>();
        Set<String> recordIdSet = new Set<String>();
        List<sObject> qtrecordsToUpsert = new List<sObject>();
        
        ASC_Status_History_Tracking__c newRecordQt = new ASC_Status_History_Tracking__c();
        ASC_Status_History_Tracking__c newRecordCnrt = new ASC_Status_History_Tracking__c();                
        ASC_Status_History_Tracking__c newRecordCnrtSigSt = new ASC_Status_History_Tracking__c();
        ASC_Status_History_Tracking__c newRecordInvSetup = new ASC_Status_History_Tracking__c();
        ASC_Status_History_Tracking__c newRecordOpp = new ASC_Status_History_Tracking__c();        
        ASC_Status_History_Tracking__c newRecordOppSubStg = new ASC_Status_History_Tracking__c();
        ASC_Status_History_Tracking__c newRecordPlan = new ASC_Status_History_Tracking__c();
        
        try{        
            if(!listOfrecords.isEmpty()){
               for(sObject eachRec : listOfrecords){                                     
                  if(eachRec.Id!=null && String.isNotBlank(String.valueOf(eachRec.Id).substring(0, 15))){
                  recordIdSet.add(String.valueOf(eachRec.Id).substring(ZERO, FIFTEEN));     
                  }                                                 
               }               
               if(!recordIdSet.isEmpty()){
                 for(ASC_Status_History_Tracking__c uniqRec:[Select Id,Record_Id__c,Object_Type__c,Aging_Record_Type__c,
                                                             Aging_Values__c,End_Date__c from ASC_Status_History_Tracking__c
                                                             where Record_Id__c IN:recordIdSet
                                                             AND End_Date__c = null
                                                             Limit :UTIL_SLB.retrieveQueryLimitValue()]){
                   existingUniqueKeySet.put(uniqRec.Object_Type__c+UNDERSCORE+uniqRec.Aging_Record_Type__c+
                                            UNDERSCORE+uniqRec.Aging_Values__c+UNDERSCORE+uniqRec.Record_Id__c,uniqRec.Id);
                 }     
               }
                                    
               for(sObject eachRec : listOfrecords){ 
                   sObject oldMapInContext = Schema.getGlobalDescribe().get(objectAPIName).newSObject();                 
                    if(oldMapOfrecords !=null){
                      oldMapInContext = oldMapOfrecords.get(eachRec.Id);
                    }                    
                    
                    //Quote - Start
                    if(QUOTE.equals(objectAPIName) 
                       && String.isNotBlank(String.ValueOf(eachRec.get(STATUS)))
                       //&& String.ValueOf(eachRec.get(STATUS)) != String.ValueOf(oldMapInContext.get(STATUS))
                       && (oldMapInContext == null || (oldMapInContext !=null && String.ValueOf(eachRec.get(STATUS)) != String.ValueOf(oldMapInContext.get(STATUS))))                                                                                      
                    ){   
                      String uniqueKey = QUOTE+UNDERSCORE+QUOTESTATUS+UNDERSCORE+String.ValueOf(oldMapInContext.get(STATUS))+
                                         UNDERSCORE+String.valueOf(eachRec.Id).substring(ZERO, FIFTEEN);
                                                                  
                      if (existingUniqueKeySet.ContainsKey(uniqueKey)) {
                            newRecordQt = new ASC_Status_History_Tracking__c(Id = existingUniqueKeySet.get(uniqueKey));
                            newRecordQt.End_Date__c = DateTime.Now();                            
                            recordsToUpsert.add(newRecordQt);
                      }
                      newRecordQt = new ASC_Status_History_Tracking__c();
                      newRecordQt.Object_Type__c = QUOTE;
                      newRecordQt.Quote__c = String.ValueOf(eachRec.get(ID));
                      newRecordQt.Aging_Record_Type__c = QUOTESTATUS;
                      newRecordQt.Aging_Values__c = String.ValueOf(eachRec.get(STATUS));                      
                      newRecordQt.Start_Date__c = DateTime.Now();
                      recordsToUpsert.add(newRecordQt);                      
                    }
                    //Quote - End
                    
                    //Contract - Start                     
                    if(CONTRACT.equals(objectAPIName)
                       && String.isNotBlank(String.ValueOf(eachRec.get(STATUS)))                   
                       && (oldMapInContext == null || (oldMapInContext !=null && String.ValueOf(eachRec.get(STATUS)) != String.ValueOf(oldMapInContext.get(STATUS))))
                    ){
                      String uniqueKey = CONTRACT+UNDERSCORE+CONTRACTSTATUS+UNDERSCORE+String.ValueOf(oldMapInContext.get(STATUS))+
                                         UNDERSCORE+String.valueOf(eachRec.Id).substring(ZERO, FIFTEEN);
                      //System.debug('***********uniqKey'+uniqueKey);
                      //System.debug('***********existingUniqueKeySet'+existingUniqueKeySet);
                      if (existingUniqueKeySet.ContainsKey(uniqueKey)) {
                            newRecordCnrt = new ASC_Status_History_Tracking__c(Id = existingUniqueKeySet.get(uniqueKey));
                            newRecordCnrt.End_Date__c = DateTime.Now();                            
                            recordsToUpsert.add(newRecordCnrt);
                      }
                      newRecordCnrt = new ASC_Status_History_Tracking__c();
                      newRecordCnrt.Object_Type__c = CONTRACT;
                      newRecordCnrt.Contract__c = String.ValueOf(eachRec.get(ID));
                      newRecordCnrt.Aging_Record_Type__c = CONTRACTSTATUS;
                      newRecordCnrt.Aging_Values__c = String.ValueOf(eachRec.get(STATUS));                      
                      newRecordCnrt.Start_Date__c = DateTime.Now();
                      recordsToUpsert.add(newRecordCnrt);                      
                    }
                    
                    if(CONTRACT.equals(objectAPIName) 
                       && String.isNotBlank(String.ValueOf(eachRec.get(ASC_SIGNATURESTATUS)))                  
                       && (oldMapInContext == null || (oldMapInContext !=null && String.ValueOf(eachRec.get(ASC_SIGNATURESTATUS)) != String.ValueOf(oldMapInContext.get(ASC_SIGNATURESTATUS))))
                                           
                    ){
                      String uniqueKey = CONTRACT+UNDERSCORE+SIGNATURESTATUS+UNDERSCORE+String.ValueOf(oldMapInContext.get(ASC_SIGNATURESTATUS))+
                                         UNDERSCORE+String.valueOf(eachRec.Id).substring(ZERO, FIFTEEN);
                                                                  
                      if (existingUniqueKeySet.ContainsKey(uniqueKey)) {
                            newRecordCnrtSigSt = new ASC_Status_History_Tracking__c(Id = existingUniqueKeySet.get(uniqueKey));
                            newRecordCnrtSigSt.End_Date__c = DateTime.Now();                            
                            recordsToUpsert.add(newRecordCnrtSigSt);
                      }
                      newRecordCnrtSigSt = new ASC_Status_History_Tracking__c();
                      newRecordCnrtSigSt.Object_Type__c = CONTRACT;
                      newRecordCnrtSigSt.Contract__c = String.ValueOf(eachRec.get(ID));
                      newRecordCnrtSigSt.Aging_Record_Type__c = SIGNATURESTATUS;
                      newRecordCnrtSigSt.Aging_Values__c = String.ValueOf(eachRec.get(ASC_SIGNATURESTATUS));                      
                      newRecordCnrtSigSt.Start_Date__c = DateTime.Now();
                      recordsToUpsert.add(newRecordCnrtSigSt);                          
                    }
                    
                    if(CONTRACT.equals(objectAPIName) 
                       && String.isNotBlank(String.ValueOf(eachRec.get(ASC_INVOICESETUP)))                      
                       && (oldMapInContext == null || (oldMapInContext !=null && String.ValueOf(eachRec.get(ASC_INVOICESETUP)) != String.ValueOf(oldMapInContext.get(ASC_INVOICESETUP))))                                           
                    ){
                      String uniqueKey = CONTRACT+UNDERSCORE+INVOICESETUP+UNDERSCORE+String.ValueOf(oldMapInContext.get(ASC_INVOICESETUP))+
                                         UNDERSCORE+String.valueOf(eachRec.Id).substring(ZERO, FIFTEEN);
                                                                  
                      if (existingUniqueKeySet.ContainsKey(uniqueKey)) {
                            newRecordInvSetup = new ASC_Status_History_Tracking__c(Id = existingUniqueKeySet.get(uniqueKey));
                            newRecordInvSetup.End_Date__c = DateTime.Now();                            
                            recordsToUpsert.add(newRecordInvSetup);
                      }
                      newRecordInvSetup = new ASC_Status_History_Tracking__c();
                      newRecordInvSetup.Object_Type__c = CONTRACT;
                      newRecordInvSetup.Contract__c = String.ValueOf(eachRec.get(ID));
                      newRecordInvSetup.Aging_Record_Type__c = INVOICESETUP;
                      newRecordInvSetup.Aging_Values__c = String.ValueOf(eachRec.get(ASC_INVOICESETUP));                      
                      newRecordInvSetup.Start_Date__c = DateTime.Now();
                      recordsToUpsert.add(newRecordInvSetup);                          
                    }
                    //Contract - End

                    //Opportunity - Start
                    if(OPPORTUNITY.equals(objectAPIName) 
                       && String.isNotBlank(String.ValueOf(eachRec.get(STAGENAME)))                    
                       && (oldMapInContext == null || (oldMapInContext !=null && String.ValueOf(eachRec.get(STAGENAME)) != String.ValueOf(oldMapInContext.get(STAGENAME))))                    
                    ){
                      String uniqueKey = OPPORTUNITY+UNDERSCORE+STAGE+UNDERSCORE+String.ValueOf(oldMapInContext.get(STAGENAME))+
                                         UNDERSCORE+String.valueOf(eachRec.Id).substring(ZERO, FIFTEEN);
                                                                  
                      if (existingUniqueKeySet.ContainsKey(uniqueKey)) {
                            newRecordOpp = new ASC_Status_History_Tracking__c(Id = existingUniqueKeySet.get(uniqueKey));
                            newRecordOpp.End_Date__c = DateTime.Now();                            
                            recordsToUpsert.add(newRecordOpp);
                      }
                      newRecordOpp = new ASC_Status_History_Tracking__c();
                      newRecordOpp.Object_Type__c = OPPORTUNITY;
                      newRecordOpp.Opportunity__c = String.ValueOf(eachRec.get(ID));
                      newRecordOpp.Aging_Record_Type__c = STAGE;
                      newRecordOpp.Aging_Values__c = String.ValueOf(eachRec.get(STAGENAME));                      
                      newRecordOpp.Start_Date__c = DateTime.Now();
                      recordsToUpsert.add(newRecordOpp);                                                                      
                    }
                    
                    if(OPPORTUNITY.equals(objectAPIName) 
                       && String.isNotBlank(String.ValueOf(eachRec.get(ASC_SUBSTAGE)))
                       && (oldMapInContext == null || (oldMapInContext !=null && String.ValueOf(eachRec.get(ASC_SUBSTAGE)) != String.ValueOf(oldMapInContext.get(ASC_SUBSTAGE))))                                           
                    ){
                      String uniqueKey = OPPORTUNITY+UNDERSCORE+SUBSTAGE+UNDERSCORE+String.ValueOf(oldMapInContext.get(ASC_SUBSTAGE))+
                                         UNDERSCORE+String.valueOf(eachRec.Id).substring(ZERO, FIFTEEN);
                                                                  
                      if(existingUniqueKeySet.ContainsKey(uniqueKey)){
                            newRecordOppSubStg = new ASC_Status_History_Tracking__c(Id = existingUniqueKeySet.get(uniqueKey));
                            newRecordOppSubStg.End_Date__c = DateTime.Now();                            
                            recordsToUpsert.add(newRecordOppSubStg);
                      }
                      newRecordOppSubStg = new ASC_Status_History_Tracking__c();
                      newRecordOppSubStg.Object_Type__c = OPPORTUNITY;
                      newRecordOppSubStg.Opportunity__c = String.ValueOf(eachRec.get(ID));
                      newRecordOppSubStg.Aging_Record_Type__c = SUBSTAGE;
                      newRecordOppSubStg.Aging_Values__c = String.ValueOf(eachRec.get(ASC_SUBSTAGE));                      
                      newRecordOppSubStg.Start_Date__c = DateTime.Now();
                      recordsToUpsert.add(newRecordOppSubStg);                                                                                            
                    } 
                    //Opportunity - End
                    
                    //Plan - Start
                    if(PLAN_OBJ.equals(objectAPIName) 
                       && String.isNotBlank(String.ValueOf(eachRec.get(ASC_ACTIVATIONSTATUS)))
                       && (oldMapInContext == null || (oldMapInContext !=null && String.ValueOf(eachRec.get(ASC_ACTIVATIONSTATUS)) != String.ValueOf(oldMapInContext.get(ASC_ACTIVATIONSTATUS))))                                           
                    ){
                      String uniqueKey = PLAN+UNDERSCORE+ACTIVATIONSTATUS+UNDERSCORE+String.ValueOf(oldMapInContext.get(ASC_ACTIVATIONSTATUS))+
                                         UNDERSCORE+String.valueOf(eachRec.Id).substring(ZERO, FIFTEEN);
                                                                  
                      if(existingUniqueKeySet.ContainsKey(uniqueKey)){
                            newRecordPlan = new ASC_Status_History_Tracking__c(Id = existingUniqueKeySet.get(uniqueKey));
                            newRecordPlan.End_Date__c = DateTime.Now();                            
                            recordsToUpsert.add(newRecordPlan);
                      }
                      newRecordPlan = new ASC_Status_History_Tracking__c();
                      newRecordPlan.Object_Type__c = PLAN;
                      newRecordPlan.Plan__c = String.ValueOf(eachRec.get(ID));
                      newRecordPlan.Aging_Record_Type__c = ACTIVATIONSTATUS;
                      newRecordPlan.Aging_Values__c = String.ValueOf(eachRec.get(ASC_ACTIVATIONSTATUS));                      
                      newRecordPlan.Start_Date__c = DateTime.Now();
                      recordsToUpsert.add(newRecordPlan);                                                                                            
                    }
                    //Plan - End                                                                                
               }            
               if(!recordsToUpsert.isEmpty()){
                 Upsert recordsToUpsert;
               }               
            }
        }
        catch(Exception e){             
            GA_LogExceptionCls.LogExcp(e,CLASSNAME , METHODNME);
        }   
    }
}