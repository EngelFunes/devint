public with sharing Class ASC_AP_ApprovalProductExpression {


    private boolean e1;
    private boolean e2;
    private boolean e3;
    private boolean e4;
    private boolean e5;
    private boolean e6;
    private boolean e7;
    private boolean e8;
    private boolean e9;
    private boolean e10;
        
    private static final string AND2 = ' AND 2';
    private static final string AND3 = ' AND 3';
    private static final string AND4 = ' AND 4';
    private static final string AND5 = ' AND 5';
    private static final string AND6 = ' AND 6';
    private static final string AND7 = ' AND 7';
    private static final string AND8 = ' AND 8';
    private static final string AND9 = ' AND 9';
    private static final string AND10 = ' AND 10';
    
    private static final string ANDOptr = 'AND';
    private static final string OROptr = 'OR';
    private static final string FALSEVal = 'FALSE';
    private static final string TRUEVal = 'TRUE';
    
    private static final string OPENBRACES ='(';
    private static final string CLOSEBRACES =')';
    private static final string SPACE =' ';
    
    private static final string ONE = '1';
    private static final string TWO = '2';
    private static final string THREE = '3';
    private static final string FOUR = '4';
    private static final string FIVE = '5';
    private static final string SIX = '6';
    private static final string SEVEN = '7';
    private static final string EIGHT = '8';
    private static final string NINE = '9';
    private static final string TEN = '10';
    
    public void put(Integer i, Boolean b){
        if(i==1){
            e1 = b;
        }else if(i==2){
            e2 = b;
        }else if(i==3){
            e3 = b;
        }else if(i==4){
            e4 = b;
        }else if(i==5){
            e5 = b;
        }else if(i==6){
            e6 = b;
        }else if(i==7){
            e7 = b;
        }else if(i==8){
            e8 = b;
        }else if(i==9){
            e9 = b;
        }else if(i==10){
            e10 = b;
        }
    }
    
    
    public String getExpressionLogic(String expressionLogic){
        String result = expressionLogic;
        
        if(result == null){
            result = '1';
            if(this.e2 != null){
                result = result + AND2;
            }
            if(this.e3 != null){
                result = result + AND3;
            }
            if(this.e4 != null){
                result = result + AND4;
            }
            if(this.e5 != null){
                result = result + AND5;
            }
            if(this.e6 != null){
                result = result + AND6;
            }
            if(this.e7 != null){
                result = result + AND7;
            }
            if(this.e8 != null){
                result = result + AND8;
            }
            if(this.e9 != null){
                result = result + AND9;
            }
            if(this.e10 != null){
                result = result + AND10;
            }
            
         }
         return result;
    }

    public String getResult(String logic){
        String result = FALSEVal;
        String clause = logic;
        String logicVal = logic; 
        
        System.debug('####logicVal'+logicVal);    
        
        Integer iOfClosedParen = logicVal.indexOf(CLOSEBRACES);
        
        System.debug('####iOfClosedParen'+iOfClosedParen);    
        
        if(iOfClosedParen > 0){
            do{
                Integer iOfOpenParen = logicVal.lastIndexOf(OPENBRACES,iOfClosedParen);
                
                System.debug('####iOfOpenParen'+iOfOpenParen);    
                    
                clause = logicVal.substring(iOfOpenParen+1,iOfClosedParen);
                
                System.debug('####clause'+clause);
                    
                logicVal = logicVal.replace(OPENBRACES +clause+CLOSEBRACES, SPACE + this.getResult(clause) + SPACE);
                    
                System.debug('####logicVal'+logicVal);
                
                iOfClosedParen = logicVal.indexOf(CLOSEBRACES);
                
                System.debug('####iOfClosedParen'+iOfClosedParen);
                
            }while(iOfClosedParen>0);
        }
        if(iOfClosedParen <= 0) {
        result = this.evaluateLogic(logicVal);
        }
        return result;
    }
    
    
    private String evaluateLogic(String logic){
        String result = FALSEVal;
        if(logic.containsIgnoreCase(ANDOptr) || logic.containsIgnoreCase(OROptr))
        {
           if (logic.containsIgnoreCase(OROptr)
                         && logic.containsIgnoreCase(TRUEVal)){
                         result = TRUEVal;    
                         }
           else if(logic.containsIgnoreCase(ANDOptr)
               &&  !logic.containsIgnoreCase(FALSEVal)){
                 result = TRUEVal;
          }else{
              if(logic.containsIgnoreCase(FALSEVal)){
                  result = FALSEVal;
              }            
        }
        }
        else
        {
           result=logic; 
        }
       return result;
    }
    
    public String replaceNumWithResult(String logic){
            String result = logic;
            if(e1){
                result = result.replaceAll(ONE,TRUEVal);
            }else{
                result = result.replaceAll(ONE,FALSEVal);
            }
            if(e2 != null){
                if(e2){
                    result = result.replaceAll(TWO,TRUEVal);
                }else{
                    result = result.replaceAll(TWO,FALSEVal);
                }
            }
            if(e3 != null){
                if(e3){
                    result = result.replaceAll(THREE,TRUEVal);
                }else{
                    result = result.replaceAll(THREE,FALSEVal);
                }
            }
            if(e4 != null){
                if(e4){
                    result = result.replaceAll(FOUR,TRUEVal);
                }else{
                    result = result.replaceAll(FOUR,FALSEVal);
                }
            }
            if(e5 != null){
                if(e5){
                    result = result.replaceAll(FIVE,TRUEVal);
                }else{
                    result = result.replaceAll(FIVE,FALSEVal);
                }
            }
            if(e6 != null){
                if(e6){
                    result = result.replaceAll(SIX,TRUEVal);
                }else{
                    result = result.replaceAll(SIX,FALSEVal);
                }
            }
            if(e7 != null){
                if(e7){
                    result = result.replaceAll(SEVEN,TRUEVal);
                }else{
                    result = result.replaceAll(SEVEN,FALSEVal);
                }
            }
            if(e8 != null){
                if(e8){
                    result = result.replaceAll(EIGHT,TRUEVal);
                }else{
                    result = result.replaceAll(EIGHT,FALSEVal);
                }
            }
            if(e9 != null){
                if(e9){
                    result = result.replaceAll(NINE,TRUEVal);
                }else{
                    result = result.replaceAll(NINE,FALSEVal);
                }
            }
            if(e10 != null){
                if(e10){
                    result = result.replaceAll(TEN,TRUEVal);
                }else{
                    result = result.replaceAll(TEN,FALSEVal);
                }
            }
         return result;
     }
      
 }