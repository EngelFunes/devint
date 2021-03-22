/*****************************************************************************************
Class Name   : GA_Util_AbrDataAccessHelper
Date Created : 8/30/2017
Created By   : IDC Offshore
Description  : 1. This is the util data access class for ABR. Which is used to fetch 
the details from ABRt based on some parameters

Change History : 
******************************************************************************************/
public with sharing class GA_Util_AbrDataAccessHelper {
    //Below are the final variables to check the operation on the list of records.

    public static final String BLANK = ' ';
    public static final string abrErrorMsg = 'ABR database operation failed :';
    /**
@Description: ValidateException() method 
@Name : ValidateException
@Param : None
@Return : void
@throws Exception : N/A;
*/    
    public with sharing class ValidateException extends Exception {}
     /****************************************************************************************************
    Method Name : fetchAbrLst
    Parameters  : String selectQuery,String whereClause,String orderByClause,String limitClause
    Return type : List<GA_Account_Fact_Sheet__c>
    Description : This method is used to fetch the Account Fact sheet record based on parameters passed.
    It will return the List<GA_Account_Benefit_Review__c>.
    ******************************************************************************************************/
    public static List<GA_Account_Benefit_Review__c> fetchAbrLst(String selectQuery,String whereClause,String orderByClause,String limitClause){
        String dynaQuery = BLANK;
        List<GA_Account_Benefit_Review__c> abrLst = NULL;
        try
        {
            dynaQuery = String.isNotBlank(selectQuery) ? selectQuery : BLANK;
            dynaQuery = String.isNotBlank(dynaQuery) && String.isNotBlank(whereClause) ? dynaQuery+=whereClause : dynaQuery;
            dynaQuery = String.isNotBlank(dynaQuery) && String.isNotBlank(orderByClause) ? dynaQuery+=orderByClause : dynaQuery;
            dynaQuery = String.isNotBlank(dynaQuery) && String.isNotBlank(limitClause) ? dynaQuery+=limitClause : dynaQuery;            
           
            if(String.isNotBlank(dynaQuery))
            {
                abrLst = new List<GA_Account_Benefit_Review__c>((List<GA_Account_Benefit_Review__c>)Database.query(dynaQuery));
            }
        }Catch(Exception ex){            
          throw new ValidateException(abrErrorMsg, ex);   
        }    
        return abrLst;
    }
}