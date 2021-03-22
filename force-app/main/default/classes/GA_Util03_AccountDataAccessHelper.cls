/*****************************************************************************************
Class Name   : GA_Util03_AccountDataAccessHelper
Date Created : 8/30/2017
Created By   : IDC Offshore
Description  : 1. This is the util data access class for Account. Which is used to fetch 
the details from Account based on some parameters
2. This is used for DML Operations.
Change History : 
******************************************************************************************/
public with sharing class GA_Util03_AccountDataAccessHelper {
    //Below are the final variables to check the operation on the list of records.
    public static final String INSERT_OPERATION = 'Insert';
    public static final String UPDATE_OPERATION = 'Update';
    public static final String DELETE_OPERATION = 'Delete';
    public static final String UPSERT_OPERATION = 'Upsert';
    public static final String BLANK = ' ';
     public static final string accountErrorMsg = 'Account database operation failed :';
    /**
@Description: ValidateException() method 
@Name : ValidateException
@Param : None
@Return : void
@throws Exception : N/A;
*/    
    public with sharing class ValidateException extends Exception {}
     /****************************************************************************************************
    Method Name : fetchAccountsMap
    Parameters  : String selectQuery,String whereClause,String orderByClause,String limitClause
    Return type : Map<Id,Account>
    Description : This method is used to fetch the Account record based on parameters passed.
    It will return the Map<ID,Account> if user wants the Map, they can perform the logic on 
    Map, else they can covert the map to list of accounts.
    ******************************************************************************************************/
    public static Map<ID,Account> fetchAccountsMap(String selectQuery,String whereClause,String orderByClause,String limitClause){
        String dynaQuery = BLANK;
        Map<ID,Account> accountMap = NULL;
        try
        {
            dynaQuery = String.isNotBlank(selectQuery) ? selectQuery : BLANK;
            dynaQuery = String.isNotBlank(dynaQuery) && String.isNotBlank(whereClause) ? dynaQuery+=whereClause : dynaQuery;
            dynaQuery = String.isNotBlank(dynaQuery) && String.isNotBlank(orderByClause) ? dynaQuery+=orderByClause : dynaQuery;
            dynaQuery = String.isNotBlank(dynaQuery) && String.isNotBlank(limitClause) ? dynaQuery+=limitClause : dynaQuery;            
           
            if(String.isNotBlank(dynaQuery))
            {
                accountMap = new Map<ID,Account>((List<Account>)Database.query(dynaQuery));
            }
        }Catch(Exception ex){            
          throw new ValidateException(accountErrorMsg, ex);   
        }    
        return accountMap;
    }
    
    /****************************************************************************************************
    Method Name : dmlOnAccount
    Parameters  : List<Account> accList, String operation
    Return type : List<Account>
    Description : This method is used to perform the DML operations on Acocunt.
    Operation value need to pass to perform the respective dml operation.
    Operation name should be passed from SG01_Constants class.
    ******************************************************************************************************/
    public static List<Account> dmlOnAccount(List<Account> accountList, String operation){
        try
        {
            if( !accountList.isEmpty())
            {
                if(String.isNotBlank(operation) && INSERT_OPERATION.equalsIgnoreCase(operation)){
                    Database.Insert(accountList);
                }else if(String.isNotBlank(operation) && UPDATE_OPERATION.equalsIgnoreCase(operation)){
                    Database.Update(accountList);
                }else if(String.isNotBlank(operation) && DELETE_OPERATION.equalsIgnoreCase(operation)){
                    Database.Delete(accountList);
                }else {
                    Database.Upsert(accountList);
                }
                
            }
        }Catch(Exception ex){
            throw new ValidateException(accountErrorMsg, ex);   
        }    
        return accountList;
    }

}