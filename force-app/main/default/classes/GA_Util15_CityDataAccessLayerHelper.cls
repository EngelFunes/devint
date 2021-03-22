/*****************************************************************************************
Class Name   : GA_Util15_CityDataAccessLayerHelper
Date Created : 8/30/2017
Created By   : IDC Offshore
    Description  : 1. This is the util data access class for City. Which is used to fetch 
the details from City record on some parameters
2. This is used for DML Operations.
Change History : 
******************************************************************************************/
public with sharing class GA_Util15_CityDataAccessLayerHelper {
 //Below are the final variables to check the operation on the list of records.
    public static final String INSERT_OPERATION = 'Insert';
    public static final String BLANK = ' ';
     public static final string ctyErrorMsg = 'City database operation failed :';
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
    public static Map<ID,GA_City_Code__c> fetchCityMap(String selectQuery,String whereClause,String orderByClause,String limitClause){
        String dynaQuery = BLANK;
        Map<ID,GA_City_Code__c> cityMap = NULL;
        try
        {
            dynaQuery = String.isNotBlank(selectQuery) ? selectQuery : BLANK;
            dynaQuery = String.isNotBlank(dynaQuery) && String.isNotBlank(whereClause) ? dynaQuery+=whereClause : dynaQuery;
            dynaQuery = String.isNotBlank(dynaQuery) && String.isNotBlank(orderByClause) ? dynaQuery+=orderByClause : dynaQuery;
            dynaQuery = String.isNotBlank(dynaQuery) && String.isNotBlank(limitClause) ? dynaQuery+=limitClause : dynaQuery;            
           	system.debug('dynaQuery->'+dynaQuery);
            if(String.isNotBlank(dynaQuery))
            {
                cityMap = new Map<ID,GA_City_Code__c>((List<GA_City_Code__c>)Database.query(dynaQuery));
            }
        }Catch(Exception ex){            
          throw new ValidateException(ctyErrorMsg, ex);   
        }    
        return cityMap;
    }
    
        /****************************************************************************************************
Method Name : dmlOnCity
Parameters  : List<GA_City_Code__c> casList, String operation
Return type : List<GA_City_Code__c>
Description : This method is used to perform the DML operations on Case.
Operation value need to pass to perform the respective dml operation.
Operation name should be passed from SG01_Constants class.
******************************************************************************************************/
    public static List<GA_City_Code__c> dmlOnCity(List<GA_City_Code__c> ctyList, String operation){
        try
        {
            if( !ctyList.isEmpty())
            {
                if(String.isNotBlank(operation) && INSERT_OPERATION.equalsIgnoreCase(operation)){
                    Database.Insert(ctyList);
                }
                
            }
        }Catch(Exception ex){
            throw new ValidateException(ctyErrorMsg, ex);   
        }    
        return ctyList;
    }
    
}