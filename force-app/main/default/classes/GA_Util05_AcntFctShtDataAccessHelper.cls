/*****************************************************************************************
Class Name   : GA_Util05_AcntFctShtDataAccessHelper
Date Created : 8/30/2017
Created By   : IDC Offshore
Description  : 1. This is the util data access class for Account Fact Sheet. Which is used to fetch 
the details from Account Fact Sheet based on some parameters

Change History : 
******************************************************************************************/
public with sharing class GA_Util05_AcntFctShtDataAccessHelper {
    //Below are the final variables to check the operation on the list of records.

    public static final String BLANK = ' ';
    public static final string accountFctShtErrorMsg = 'Account factsheet database operation failed :';
    /**
@Description: ValidateException() method 
@Name : ValidateException
@Param : None
@Return : void
@throws Exception : N/A;
*/    
    public with sharing class ValidateException extends Exception {}
     /****************************************************************************************************
    Method Name : fetchAcntFcstShtLst
    Parameters  : String selectQuery,String whereClause,String orderByClause,String limitClause
    Return type : List<GA_Account_Fact_Sheet__c>
    Description : This method is used to fetch the Account Fact sheet record based on parameters passed.
    It will return the List<GA_Account_Fact_Sheet__c>.
    ******************************************************************************************************/
    public static List<GA_Account_Fact_Sheet__c> fetchAcntFcstShtLst(String selectQuery,String whereClause,String orderByClause,String limitClause){
        String dynaQuery = BLANK;
        List<GA_Account_Fact_Sheet__c> acntFctLst = NULL;
        try
        {
            dynaQuery = String.isNotBlank(selectQuery) ? selectQuery : BLANK;
            dynaQuery = String.isNotBlank(dynaQuery) && String.isNotBlank(whereClause) ? dynaQuery+=whereClause : dynaQuery;
            dynaQuery = String.isNotBlank(dynaQuery) && String.isNotBlank(orderByClause) ? dynaQuery+=orderByClause : dynaQuery;
            dynaQuery = String.isNotBlank(dynaQuery) && String.isNotBlank(limitClause) ? dynaQuery+=limitClause : dynaQuery;            
           
            if(String.isNotBlank(dynaQuery))
            {
                acntFctLst = new List<GA_Account_Fact_Sheet__c>((List<GA_Account_Fact_Sheet__c>)Database.query(dynaQuery));
            }
        }Catch(Exception ex){            
          throw new ValidateException(accountFctShtErrorMsg, ex);   
        }    
        return acntFctLst;
    }
}