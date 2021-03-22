/*****************************************************************************************
Class Name   : GA_Util19_CaseDataAccessHelper
Date Created : 9/19/2017
Created By   : IDC Offshore
Description  : 1. This is the util data access class for case. Which is used to fetch 
the details from workflow based on some parameters
2. This is used for DML Operations.
Change History : 
******************************************************************************************/
public with sharing class GA_Util19_CaseDataAccessHelper {
    //Below are the final variables to check the operation on the list of records.
    public static final String INSERT_OPERATION = 'Insert';
    public static final String UPDATE_OPERATION = 'Update';
    public static final String DELETE_OPERATION = 'Delete';
    public static final String UPSERT_OPERATION = 'Upsert';
    public static final String BLANK = ' ';
    public static final string caseErrorMsg = 'Case database operation failed :';
    /**
@Description: ValidateException() method 
@Name : ValidateException
@Param : None
@Return : void
@throws Exception : N/A;
*/      
    public with sharing class ValidateException extends Exception {}
    
    /*  Method Name : fetchCaseMap
Parameters  : String selectQuery,String whereClause,String orderByClause,String limitClause
Return type : Map<Id,Case>
Description : This method is used to fetch the Case record based on parameters passed.
It will return the Map<ID,Case> if user wants the Map, they can perform the logic on 
Map, else they can covert the map to list.
******************************************************************************************************/
    public static Map<ID,Case> fetchCaseMap(String selectQuery,String whereClause,String orderByClause,String limitClause){
        String dynaQuery = BLANK;
        Map<ID,Case> CaseMap = NULL;
        try
        {
            dynaQuery = String.isNotBlank(selectQuery) ? selectQuery : BLANK;
            dynaQuery = String.isNotBlank(dynaQuery) && String.isNotBlank(whereClause) ? dynaQuery+=whereClause : dynaQuery;
            dynaQuery = String.isNotBlank(dynaQuery) && String.isNotBlank(orderByClause) ? dynaQuery+=orderByClause : dynaQuery;
            dynaQuery = String.isNotBlank(dynaQuery) && String.isNotBlank(limitClause) ? dynaQuery+=limitClause : dynaQuery;            
           
            if(String.isNotBlank(dynaQuery))
            {
                CaseMap = new Map<ID,Case>((List<Case>)Database.query(dynaQuery));
            }
        }Catch(Exception ex){            
            throw new ValidateException(caseErrorMsg, ex);   
        }    
        return CaseMap;
    }
    
    /****************************************************************************************************
Method Name : dmlOnCase
Parameters  : List<Case> casList, String operation
Return type : List<Case>
Description : This method is used to perform the DML operations on Case.
Operation value need to pass to perform the respective dml operation.
Operation name should be passed from SG01_Constants class.
*******************************************************************************************************/
    public static List<Case> dmlOnCase(List<Case> casList, String operation){
        try
        {
            if( !casList.isEmpty())
            {
                if(String.isNotBlank(operation) && INSERT_OPERATION.equalsIgnoreCase(operation)){
                    Database.Insert(casList);
                }if(String.isNotBlank(operation) && UPDATE_OPERATION.equalsIgnoreCase(operation)){
                    Database.Update(casList);
                }
                /*
                else if(String.isNotBlank(operation) && DELETE_OPERATION.equalsIgnoreCase(operation)){
                    Database.Delete(casList);
                }else {
                    Database.Upsert(casList);
                }
*/
            }
        }Catch(Exception ex){
            throw new ValidateException(caseErrorMsg, ex);   
        }    
        return casList;
    }
}