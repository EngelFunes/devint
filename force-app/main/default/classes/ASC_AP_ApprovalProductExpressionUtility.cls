public with sharing class ASC_AP_ApprovalProductExpressionUtility {
    
    
    public static final Set<String> stringTypes = new Set<String>{'address','id','phone','picklist','string','textarea','url'};
    public static final Set<String> numberTypes = new Set<String>{'currency','double','integer','long','percent'};
    public static final Set<String> booleanTypes = new Set<String>{'boolean'};
    
    public static final Set<String> stringOperators = new Set<String>{'equals','not equal to','greater than','less than'};
    public static final Set<String> numberOperators = new Set<String>{'equals','not equal to','greater than','less than','greater than or equal to','less than or equal to'};    
    public static final Set<String> booleanOperators = new Set<String>{'equals','not equal to'};
    
           
           
             
    public static Boolean evaluateExpression(String fieldType, sobject record, Map<String,Object> expressionMap){
        Boolean result = false;
        if(stringTypes.contains(fieldType)){
            result = ASC_AP_ApprovalProductExpressionUtility.evaluateStringExpression(record,expressionMap);
        }
        else if(numberTypes.contains(fieldType)){
            result = ASC_AP_ApprovalProductExpressionUtility.evaluateNumberExpression(record,expressionMap);
        }
        else if(booleanTypes.contains(fieldType)){
            result = ASC_AP_ApprovalProductExpressionUtility.evaluateBooleanExpression(record,expressionMap);
        }
        return result;
    }
    
    /************************************************************
* Method Name  : evaluateBooleanExpression
* @description : 
* @parameters  : map,Sobject
* @return type : Boolean
*************************************************************/   
   @testvisible
   private static Boolean evaluateBooleanExpression(Sobject record, Map<String,Object> expressionMap){
        Boolean result = false;
        
        String field = string.valueof(expressionMap.get('field'));
        String operator = string.valueOf(expressionMap.get('operator'));
        
        Boolean value;
        
        Boolean recVal;
        String Val;
        if(!string.valueOf(expressionMap.get('value')).equalsIgnoreCase('null') && string.valueOf(expressionMap.get('value')).endsWith('__c') ){            
            value = Boolean.valueof(expressionMap.get('value'));
            System.debug('@@@@@@@@@@@@valueUNDERSCORE'+value);            
                        
            Val = string.valueOf(expressionMap.get('value'));
            System.debug('@@@@@@@@@@@@recVal@@'+Val);            
            
            recVal = (Boolean)record.get(Val);
            System.debug('@@@recVAL'+recVal);            
        }        
        else if(!string.valueOf(expressionMap.get('value')).equalsIgnoreCase('null')){
            value = Boolean.valueof(expressionMap.get('value'));
            System.debug('@@@@@@@@@@@@valueUNDERSCOREELSE'+value);            
        }
        
        Boolean recordValue = (Boolean)record.get(field);
        
        System.debug('@@@@@@@@@@@@recordValue'+recordValue);            
        Switch on operator{
            when 'equals' {
                if(recordValue == value){
                    result = true;
                }
            }
            when 'not equal to' {
                if(recordValue != value){
                    result = true;
                }
            }
        }
        
        return result;
    }        
             
    /************************************************************
    * Method Name  : evaluateNumberExpression
    * @description : 
    * @parameters  : Sobject,Map
    * @return type : Boolean
    *************************************************************/  
   @testvisible
    private static Boolean evaluateNumberExpression(SObject record, Map<String,Object> expressionMap){
        Boolean result = false;
        Double value;
        
        String field = string.valueof(expressionMap.get('field'));
        String operator = string.valueOf(expressionMap.get('operator'));
        
        if(!string.valueOf(expressionMap.get('value')).equalsIgnoreCase('null') && string.valueOf(expressionMap.get('value')).endsWith('__c')){
            String Val = string.valueOf(expressionMap.get('value'));
            value = Double.valueof(record.get(Val));                                               
        }
        else if(!string.valueOf(expressionMap.get('value')).equalsIgnoreCase('null')){
            value = Double.valueof(expressionMap.get('value'));                                               
        }
        
        Double recordValue = Double.valueOf(record.get(field));
         
        switch on operator{
            when 'equals' {
                if(recordValue == value){
                    result = true;
                }
                System.debug('*********INSIDE equals');
            }
            when 'not equal to' {
                if(recordValue != value){
                    result = true;
                    System.debug('*********result'+result);
                }
            }
            when 'greater than' {
                if(recordValue > value){
                    result = true;
                }
            }
            when 'less than' {
                if(recordValue < value){
                    result = true;
                }
            }
            when 'greater than or equal to' {
                if(recordValue >= value){
                    result = true;
                }
            }
            when 'less than or equal to' {
                if(recordValue <= value){
                    result = true;
                }
            }
                        
        }
        return result;
    }
    
     /************************************************************
    * Method Name  : evaluateStringExpression
    * @description : 
    * @parameters  : Sobject,Map
    * @return type : Boolean
    *************************************************************/ 
    @testvisible
    private static Boolean evaluateStringExpression(Sobject record, Map<String,Object> expressionMap){
        Boolean result = false;
        
        String field = string.valueof(expressionMap.get('field'));
        String operator = string.valueOf(expressionMap.get('operator')).toLowerCase();
        
        String value;
        if(!string.valueOf(expressionMap.get('value')).equalsIgnoreCase('null')&& string.valueOf(expressionMap.get('value')).endsWith('__c')){
             String Val = string.valueOf(expressionMap.get('value'));
             value = (String)(record.get(Val));                                                         
             //value = string.valueof(expressionMap.get('value'));            
        }
        if(!string.valueOf(expressionMap.get('value')).equalsIgnoreCase('null')){                        
             value = string.valueof(expressionMap.get('value'));            
        }
        
        String recordValue = (String)record.get(field);
        Switch on operator{
            when 'equals' {
                List<String> listOfVal;
                if(recordValue != null && recordValue.equalsIgnoreCase(value)){
                    result = true;
                }
            }
            when 'not equal to' {
                List<String> listOfVal;
                if(recordValue != null && !recordValue.equalsIgnoreCase(value)){
                    result = true;
                }
            }
            when 'greater than' {
                if(recordValue != null && recordValue > value){
                    result = true;
                }
            }
            when 'less than' {
                if(recordValue != null && recordValue < value){
                    result = true;
                }
               }
                                      
       }
        return result;    
    }
       
    
 }