/*****************************************************************************************
Class Name   : GA_Util08_FilterProcessHelper
Date Created : 8/30/2017
Created By   : IDC Offshore
Description  : 1. This is the util data access class for Action Plan Template. Which is used to fetch 
the details from Action Plan Template based on some parameters

Change History : 
******************************************************************************************/
public with sharing class GA_Util08_FilterProcessHelper {
    //Below are the final variables to check the operation on the list of records.
    
    public static final String QUOTE = '\'';
    public static final String QUOTECOMMA = '\',';
    public static final String COMMA =',';
    public static final String OPENBRACKET ='(';
    public static final String CLOSEBRACKET =')';
    public static final string ErrorMsg = 'Unable to Filter';
    /**
@Description: ValidateException() method 
@Name : ValidateException
@Param : None
@Return : void
@throws Exception : N/A;
*/    
    public with sharing class ValidateException extends Exception {}
    
    
    /*convert a Set<String> into a quoted, comma separated String literal for inclusion in a dynamic SOQL Query*/
    public static String idSet(Set<Id> idList)
    {
        try{
            string newSetStr = '';
            for(String str : idList)
                newSetStr += QUOTE + str + QUOTECOMMA;
            
            newSetStr = newSetStr.lastIndexOf(COMMA) > 0 ? OPENBRACKET + newSetStr.substring(0,newSetStr.lastIndexOf(COMMA)) + CLOSEBRACKET : newSetStr ;   
            
            return newSetStr; 
        }
        catch(exception e)
        {
            throw new ValidateException(ErrorMsg, e);
        }
        
    }
    
        /*convert a Set<String> into a quoted, comma separated String literal for inclusion in a dynamic SOQL Query*/
    public static String strSet(Set<String> idList)
    {
        try{
            string newSetStr = '';
            for(String str : idList)
                newSetStr += QUOTE + str + QUOTECOMMA;
            
            newSetStr = newSetStr.lastIndexOf(COMMA) > 0 ? OPENBRACKET + newSetStr.substring(0,newSetStr.lastIndexOf(COMMA)) + CLOSEBRACKET : newSetStr ;   
            
            return newSetStr; 
        }
        catch(exception e)
        {
            throw new ValidateException(ErrorMsg, e);
        }
        
    }
    /*For Quotes in like where filters*/
    public static String FltrString(string Filter)
    {
        try
        {
         String newSetStr1 = '' ;
        
        newSetStr1 += QUOTE + String.escapeSingleQuotes(Filter) + QUOTE;
        
        return newSetStr1;   
        }
        catch(exception e)
        {
            throw new ValidateException(ErrorMsg, e);
        }
        
        
    }
    
        /*For Quotes in like where filters*/
    public static User fetchUsrDtls(string usrId)
    {
        try
        {
         
        User usr = [Select id,username,name,GA_RoleName__c,Department from User where id =: usrId Limit 1 ];
        return usr;   
        }
        catch(exception e)
        {
            throw new ValidateException(ErrorMsg, e);
        }
    }
}