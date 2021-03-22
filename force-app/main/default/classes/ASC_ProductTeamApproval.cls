/*************************************************************************************************************
@Author : Dinesh
@Name: ASC_Product_CreateActionPlan
@CreatedDate:  05-Nov-2020 
@Description: ASC_ProductTeamApproval class is used to update the Pricing Approval Needed checbox on the QuoteLineItem based on the FieldCriteria in the Custom Metadata.
@version : 1.0  
@US Number: US-4025/3935
*************************************************************************************************************/
public without sharing class ASC_ProductTeamApproval{

     private static final string FIELD_CONSTANT = 'field';
     private static final string OPERATOR_CONSTANT='operator';
     private static final string VALUE_CONSTANT='value';
     private static final string FIELDTYPE_CONSTANT = 'fieldType';
     private static final string VALUE_YES = 'Yes';

     public static Map<String,boolean> getApprovalNeeded(List<Line_Item_Extension__c> lineItemExtList){ 
         
         Map<String,Boolean> varianceUpdtMap = new Map<String,Boolean>();                       
         Map<String,ASC_ApprovalProduct_Rule__c> varapprvlMap = new Map<String,ASC_ApprovalProduct_Rule__c>();
         
         try{
         
         for(ASC_ApprovalProduct_Rule__c var:[select id, 
                                             Name, 
                                             ASC_AP_Active__c,
                                             ASC_AP_Expression_Logic__c,
                                             ASC_AP_Expression_Count__c,                                             
                                             ASC_AP_Expression_1_Field__c,ASC_AP_Expression_1_Operator__c,ASC_AP_Expression_1_Value__c,
                                             ASC_AP_Expression_2_Field__c,ASC_AP_Expression_2_Operator__c,ASC_AP_Expression_2_Value__c,                                             
                                             ASC_AP_Expression_3_Field__c,ASC_AP_Expression_3_Operator__c,ASC_AP_Expression_3_Value__c,
                                             ASC_AP_Expression_4_Field__c,ASC_AP_Expression_4_Operator__c,ASC_AP_Expression_4_Value__c,
                                             ASC_AP_Expression_5_Field__c,ASC_AP_Expression_5_Operator__c,ASC_AP_Expression_5_Value__c,
                                             ASC_AP_Expression_6_Field__c,ASC_AP_Expression_6_Operator__c,ASC_AP_Expression_6_Value__c,
                                             ASC_AP_Expression_7_Field__c,ASC_AP_Expression_7_Operator__c,ASC_AP_Expression_7_Value__c,
                                             ASC_AP_Expression_8_Field__c,ASC_AP_Expression_8_Operator__c,ASC_AP_Expression_8_Value__c,
                                             ASC_AP_Expression_9_Field__c,ASC_AP_Expression_9_Operator__c,ASC_AP_Expression_9_Value__c,
                                             ASC_AP_Expression_10_Field__c,ASC_AP_Expression_10_Operator__c,ASC_AP_Expression_10_Value__c                                          
                                             from ASC_ApprovalProduct_Rule__c
                                             LIMIT :UTIL_SLB.retrieveQueryLimitValue()]){            
            
            varapprvlMap.put(var.Name,var);
         }
         
         
         if(!lineItemExtList.isEmpty()){
              for(Line_Item_Extension__c record:lineItemExtList){
                  
                  //System.debug('********ActPilot'+record.Product__r.ASC_Pilot_Activation__c);
                  if(VALUE_YES.equals(record.Product__r.ASC_Pilot_Activation__c)
                    && varapprvlMap.ContainsKey(record.ProductCode__c) && varapprvlMap.get(record.ProductCode__c) !=null){
                    
                    ASC_ApprovalProduct_Rule__c ap = varapprvlMap.get(record.ProductCode__c);
                    
                    Boolean result = approvalProductRuleMatch(record,ap);
                    
                    /*
                    Boolean result = false;
                    if(approvalProductRuleMatch(record,ap)){
                      result = true;//approvalProductRuleMatch(record,ap);
                    }
                    else if(record.Product_Approval__c){
                      result = true;
                    }
                    else if(record.Requires_Short_Lead_Time_Approval__c && record.Short_Lead_Time_Formula__c){
                      result = true;
                    }
                    */
                    
                    System.debug('***********res'+result);
                    varianceUpdtMap.put(record.Quote_Line_Item__c,result);
                  }  
              }        
          }
          
       }
       catch(exception e){
            GA_LogExceptionCls.LogExcp(e, 'ASC_ProductTeamApproval', 'getApprovalNeeded'); 
       }
        return varianceUpdtMap;
     }     
        
   
     public static Boolean approvalProductRuleMatch(SObject record, ASC_ApprovalProduct_Rule__c wpe){
                  
         Boolean result = false;
         ASC_AP_ApprovalProductExpression pe = new ASC_AP_ApprovalProductExpression();
         for(Integer i=1;i<=wpe.ASC_AP_Expression_Count__c;i++)
         {
            Map<String,Object> expressionMap = getExpressionMap(wpe,i);
            if(!expressionMap.isEmpty() && expressionMap.get(FIELD_CONSTANT) != null){
                Boolean b = evaluateExpression(record,expressionMap);
                pe.put(i,b);
                //System.debug('^^^^^^^^^^^^^^^^^pe'+pe);
            }
         }
         if(wpe.ASC_AP_Expression_Count__c > 0){
             String logic = pe.replaceNumWithResult(pe.getExpressionLogic(wpe.ASC_AP_Expression_Logic__c));
             System.debug('^^^^^^^^^^^^^^^^^logic'+logic);
             result = Boolean.valueOf(pe.getResult(logic).trim());
             //System.debug('^^^^^^^^^^^^^^^^^getResult'+pe.getResult(logic));
             //System.debug('^^^^^^^^^^^^^^^^^result'+result);
         }
         return result;
     }   
     
                  
     private static Boolean evaluateExpression(Sobject record, Map<String,Object> expressionMap){
         Boolean result = false;
         String fieldType = string.valueOf(expressionMap.get(FIELDTYPE_CONSTANT));
         result = ASC_AP_ApprovalProductExpressionUtility.evaluateExpression(fieldtype,record,expressionMap);
        
         return result;
     }   

        
     private static Map<String,Object> getExpressionMap(ASC_ApprovalProduct_Rule__c wpe, integer i){
         Boolean typeFlag = false;
         Map<String,Object> result = new Map<String,Object>();
         
         if(wpe.get('ASC_AP_Expression_'+i+'_Field__c')!=null && Schema.getGlobalDescribe().get('Line_Item_Extension__c').getDescribe().fields.getMap().get(string.valueOf(wpe.get('ASC_AP_Expression_'+i+'_Field__c')))!= null){
             String fieldType = Schema.getGlobalDescribe().get('Line_Item_Extension__c').getDescribe().fields.getMap().get(string.valueOf(wpe.get('ASC_AP_Expression_'+i+'_Field__c'))).getDescribe().getType().name().toLowerCase();
             result.put(FIELDTYPE_CONSTANT, fieldType);
             result.put(FIELD_CONSTANT,(String)wpe.get('ASC_AP_Expression_'+i+'_Field__c'));
             result.put(OPERATOR_CONSTANT,(String)wpe.get('ASC_AP_Expression_'+i+'_Operator__c'));
             result.put(VALUE_CONSTANT,(String)wpe.get('ASC_AP_Expression_'+i+'_Value__c'));               
         }
        
         return result;
     }
}