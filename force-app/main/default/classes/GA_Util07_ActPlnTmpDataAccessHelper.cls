/*****************************************************************************************
Class Name   : GA_Util07_ActPlnTmpDataAccessHelper
Date Created : 8/30/2017
Created By   : IDC Offshore
Description  : 1. This is the util data access class for Action Plan Template. Which is used to fetch 
the details from Action Plan Template based on some parameters

Change History : 
******************************************************************************************/
public with sharing class GA_Util07_ActPlnTmpDataAccessHelper {
    //Below are the final variables to check the operation on the list of records.

    public static final String BLANK = ' ';
    public static final string actionPlnTmpErrorMsg = 'Action Plan Template database operation failed :';
    /**
@Description: ValidateException() method 
@Name : ValidateException
@Param : None
@Return : void
@throws Exception : N/A;
*/    
    public with sharing class ValidateException extends Exception {}
     /****************************************************************************************************
    Method Name : fetchActPlnTmpLst
    Parameters  : String selectQuery,String whereClause,String orderByClause,String limitClause
    Return type : List<ActionPlanTemplate__c>
    Description : This method is used to fetch the Action Plan Template record based on parameters passed.
    It will return the List<ActionPlanTemplate__c>.
    ******************************************************************************************************/
    public static List<ActionPlanTemplate__c> fetchActPlnTmpLst(String selectQuery,String whereClause,String orderByClause,String limitClause){
        String dynaQuery = BLANK;
        List<ActionPlanTemplate__c> actPlnTmpLst = NULL;
        try
        {
            dynaQuery = String.isNotBlank(selectQuery) ? selectQuery : BLANK;
            dynaQuery = String.isNotBlank(dynaQuery) && String.isNotBlank(whereClause) ? dynaQuery+=whereClause : dynaQuery;
            dynaQuery = String.isNotBlank(dynaQuery) && String.isNotBlank(orderByClause) ? dynaQuery+=orderByClause : dynaQuery;
            dynaQuery = String.isNotBlank(dynaQuery) && String.isNotBlank(limitClause) ? dynaQuery+=limitClause : dynaQuery;            
 
            if(String.isNotBlank(dynaQuery))
            {
                actPlnTmpLst = new List<ActionPlanTemplate__c>((List<ActionPlanTemplate__c>)Database.query(dynaQuery));
            }
        }Catch(Exception ex){            
          throw new ValidateException(actionPlnTmpErrorMsg, ex);   
        }    

        return actPlnTmpLst;
    }
}