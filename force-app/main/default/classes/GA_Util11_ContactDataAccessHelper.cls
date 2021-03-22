/*****************************************************************************************
Class Name   : GA_Util11_ContactDataAccessHelper
Date Created : 8/30/2017
Created By   : IDC Offshore
Description  : 1. This is the util data access class for Contact. Which is used to fetch 
the details from Contact based on some parameters
2. This is used for DML Operations.
Change History : 
******************************************************************************************/
public with sharing class GA_Util11_ContactDataAccessHelper {
    //Below are the final variables to check the operation on the list of records.
    public static final String BLANK = ' ';
    public static final string contactErrorMsg = 'Contact database operation failed :';
    /**
@Description: ValidateException() method 
@Name : ValidateException
@Param : None
@Return : void
@throws Exception : N/A;
*/    
    public with sharing class ValidateException extends Exception {}
    /****************************************************************************************************
Method Name : fetchContactsMap
Parameters  : String selectQuery,String whereClause,String orderByClause,String limitClause
Return type : Map<Id,Contact>
Description : This method is used to fetch the Contact record based on parameters passed.
It will return the Map<ID,Contact> if user wants the Map, they can perform the logic on 
Map, else they can covert the map to list of contacts.
******************************************************************************************************/
    public static Map<ID,Contact> fetchContactsMap(String selectQuery,String whereClause,String orderByClause,String limitClause){
        String dynaQuery = BLANK;
        Map<ID,Contact> contactMap = NULL;
        try
        {
            dynaQuery = String.isNotBlank(selectQuery) ? selectQuery : BLANK;
            dynaQuery = String.isNotBlank(dynaQuery) && String.isNotBlank(whereClause) ? dynaQuery+=whereClause : dynaQuery;
            dynaQuery = String.isNotBlank(dynaQuery) && String.isNotBlank(orderByClause) ? dynaQuery+=orderByClause : dynaQuery;
            dynaQuery = String.isNotBlank(dynaQuery) && String.isNotBlank(limitClause) ? dynaQuery+=limitClause : dynaQuery;            
            
            if(String.isNotBlank(dynaQuery))
            {
                contactMap = new Map<ID,Contact>((List<Contact>)Database.query(dynaQuery));
            }
        }Catch(Exception ex){            
            throw new ValidateException(contactErrorMsg, ex);   
        }    
        return contactMap;
    }
}