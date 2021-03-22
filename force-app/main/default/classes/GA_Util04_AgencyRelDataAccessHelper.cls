/*****************************************************************************************
Class Name   : GA_Util04_AgencyRelDataAccessHelper
Date Created : 8/30/2017
Created By   : IDC Offshore
    Description  : 1. This is the util data access class for Agency Relations. Which is used to fetch 
the details from Agency Relationsbased on some parameters
2. This is used for DML Operations.
Change History : 
******************************************************************************************/
public with sharing class GA_Util04_AgencyRelDataAccessHelper {
 //Below are the final variables to check the operation on the list of records.
    public static final String INSERT_OPERATION = 'Insert';
    public static final String UPDATE_OPERATION = 'Update';
    public static final String DELETE_OPERATION = 'Delete';
    public static final String UPSERT_OPERATION = 'Upsert';
    public static final String BLANK = ' ';
     public static final string agencyRelErrorMsg = 'Agency Relation  database operation failed :';
    /**
@Description: ValidateException() method 
@Name : ValidateException
@Param : None
@Return : void
@throws Exception : N/A;
*/    
    public with sharing class ValidateException extends Exception {}
     /****************************************************************************************************
    Method Name : fetchAgencyRelationsMap
    Parameters  : String selectQuery,String whereClause,String orderByClause,String limitClause
    Return type : Map<Id,Account>
    Description : This method is used to fetch the Account record based on parameters passed.
    It will return the Map<ID,Account> if user wants the Map, they can perform the logic on 
    Map, else they can covert the map to list of accounts.
    ******************************************************************************************************/
    public static Map<ID,GA_AgencyRelationship__c> fetchAgencyRelationsMap(String selectQuery,String whereClause,String orderByClause,String limitClause){
        String dynaQuery = BLANK;
        Map<ID,GA_AgencyRelationship__c> agencyRelMap = NULL;
        try
        {
            dynaQuery = String.isNotBlank(selectQuery) ? selectQuery : BLANK;
            dynaQuery = String.isNotBlank(dynaQuery) && String.isNotBlank(whereClause) ? dynaQuery+=whereClause : dynaQuery;
            dynaQuery = String.isNotBlank(dynaQuery) && String.isNotBlank(orderByClause) ? dynaQuery+=orderByClause : dynaQuery;
            dynaQuery = String.isNotBlank(dynaQuery) && String.isNotBlank(limitClause) ? dynaQuery+=limitClause : dynaQuery;            
           
            if(String.isNotBlank(dynaQuery))
            {
                agencyRelMap = new Map<ID,GA_AgencyRelationship__c>((List<GA_AgencyRelationship__c>)Database.query(dynaQuery));
            }
        }Catch(Exception ex){            
          throw new ValidateException(agencyRelErrorMsg, ex);   
        }    
        return agencyRelMap;
    }
    
}