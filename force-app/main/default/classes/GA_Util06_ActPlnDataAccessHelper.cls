/*****************************************************************************************
Class Name   : GA_Util06_ActPlnDataAccessHelper
Date Created : 8/30/2017
Created By   : IDC Offshore
Description  : 1. This is the util data access class for Action Plan. Which is used to fetch 
the details from Action Plan based on some parameters

Change History : 
******************************************************************************************/
public with sharing class GA_Util06_ActPlnDataAccessHelper {
    //Below are the final variables to check the operation on the list of records.

    public static final String BLANK = ' ';
    public static final string actionPlnErrorMsg = 'Action Plan database operation failed :';
    /**
@Description: ValidateException() method 
@Name : ValidateException
@Param : None
@Return : void
@throws Exception : N/A;
*/    
    public with sharing class ValidateException extends Exception {}
     /****************************************************************************************************
    Method Name : fetchActPlnLst
    Parameters  : String selectQuery,String whereClause,String orderByClause,String limitClause
    Return type : Map<Id,Account>
    Description : This method is used to fetch the Action Plan record based on parameters passed.
    It will return the List<ActionPlan__c>.
    ******************************************************************************************************/
    public static List<ActionPlan__c> fetchActPlnLst(String selectQuery,String whereClause,String orderByClause,String limitClause){
        String dynaQuery = BLANK;
        List<ActionPlan__c> actPlnLst = NULL;
        try
        {
            dynaQuery = String.isNotBlank(selectQuery) ? selectQuery : BLANK;
            dynaQuery = String.isNotBlank(dynaQuery) && String.isNotBlank(whereClause) ? dynaQuery+=whereClause : dynaQuery;
            dynaQuery = String.isNotBlank(dynaQuery) && String.isNotBlank(orderByClause) ? dynaQuery+=orderByClause : dynaQuery;
            dynaQuery = String.isNotBlank(dynaQuery) && String.isNotBlank(limitClause) ? dynaQuery+=limitClause : dynaQuery;            
           
            if(String.isNotBlank(dynaQuery))
            {
                actPlnLst = new List<ActionPlan__c>((List<ActionPlan__c>)Database.query(dynaQuery));
            }
        }Catch(Exception ex){            
          throw new ValidateException(actionPlnErrorMsg, ex);   
        }    
       
        return actPlnLst;
    }
}