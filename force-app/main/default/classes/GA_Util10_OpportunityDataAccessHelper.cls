/*****************************************************************************************
Class Name   : GA_Util10_OpportunityDataAccessHelper
Date Created : 11/16/2017
Created By   : IDC Offshore
Description  : 1. This is the util data access class for Opportunity. Which is used to fetch 
the details from Opportunity based on some parameters
2. This is used for DML Operations.
Change History : 
******************************************************************************************/
public with sharing class GA_Util10_OpportunityDataAccessHelper {
    //Below are the final variables to check the operation on the list of records.
    public static final String INSERT_OPERATION = 'Insert';
    public static final String UPDATE_OPERATION = 'Update';
    public static final String DELETE_OPERATION = 'Delete';
    public static final String UPSERT_OPERATION = 'Upsert';
    public static final String BLANK = ' ';
    public static final String OpportunityErrorMsg = 'Opportunity database operation failed :';
    /**
@Description: ValidateException() method 
@Name : ValidateException
@Param : None
@Return : void
@throws Exception : N/A;
*/    
    public with sharing class ValidateException extends Exception {}
    /****************************************************************************************************
Method Name : fetchOpportunitysMap
Parameters  : String selectQuery,String whereClause,String orderByClause,String limitClause
Return type : Map<Id,Opportunity>
Description : This method is used to fetch the Opportunity record based on parameters passed.
It will return the Map<ID,Opportunity> if user wants the Map, they can perform the logic on 
Map, else they can covert the map to list of Opportunitys.
******************************************************************************************************/
    public static Map<ID,Opportunity> fetchOpportunitysMap(String selectQuery,String whereClause,String orderByClause,String limitClause){
        String dynaQuery = BLANK;
        Map<ID,Opportunity> opportunityMap = NULL;
        try
        {
            dynaQuery = String.isNotBlank(selectQuery) ? selectQuery : BLANK;
            dynaQuery = String.isNotBlank(dynaQuery) && String.isNotBlank(whereClause) ? dynaQuery+=whereClause : dynaQuery;
            dynaQuery = String.isNotBlank(dynaQuery) && String.isNotBlank(orderByClause) ? dynaQuery+=orderByClause : dynaQuery;
            dynaQuery = String.isNotBlank(dynaQuery) && String.isNotBlank(limitClause) ? dynaQuery+=limitClause : dynaQuery;            
            
            if(String.isNotBlank(dynaQuery))
            {
                opportunityMap = new Map<ID,Opportunity>((List<Opportunity>)Database.query(dynaQuery));
            }
        }Catch(Exception ex){            
            throw new ValidateException(OpportunityErrorMsg, ex);   
        }    
        return opportunityMap ;
    }
    
    /****************************************************************************************************
Method Name : dmlOnOpportunity
Parameters  : List<opportunity> opptyList, String operation
Return type : List<opportunity>
Description : This method is used to perform the DML operations on opportunity.
Operation value need to pass to perform the respective dml operation.
Operation name should be passed from SG01_Constants class.
******************************************************************************************************/
    public static List<opportunity> dmlOnOpportunity(List<opportunity> opptyList, String operation){
        try
        {
            if( !opptyList.isEmpty())
            {
                if(String.isNotBlank(operation) && INSERT_OPERATION.equalsIgnoreCase(operation)){
                    Database.Insert(opptyList);
                }else if(String.isNotBlank(operation) && UPDATE_OPERATION.equalsIgnoreCase(operation)){
                    Database.Update(opptyList);
                }else if(String.isNotBlank(operation) && DELETE_OPERATION.equalsIgnoreCase(operation)){
                    Database.Delete(opptyList);
                }else {
                    Database.Upsert(opptyList);
                }
                
            }
        }Catch(Exception ex){
            throw new ValidateException(OpportunityErrorMsg, ex);   
        }    
        return opptyList;
    }
}