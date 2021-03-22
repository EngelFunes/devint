/*****************************************************************************************
Class Name   : GA_Util03_WrkflwStpDataAccessHelper
Date Created : 8/30/2017
Created By   : IDC Offshore
Description  : 1. This is the util data access class for workflow. Which is used to fetch 
the details from workflow based on some parameters
2. This is used for DML Operations.
Change History : 
******************************************************************************************/
public with sharing class GA_Util03_WrkflwDataAccessHelper {
    //Below are the final variables to check the operation on the list of records.
    public static final String INSERT_OPERATION = 'Insert';
    public static final String UPDATE_OPERATION = 'Update';
    public static final String DELETE_OPERATION = 'Delete';
    public static final String UPSERT_OPERATION = 'Upsert';
    public static final String BLANK = ' ';
     public static final string wkflwErrorMsg = 'workflow database operation failed :';
    /**
@Description: ValidateException() method 
@Name : ValidateException
@Param : None
@Return : void
@throws Exception : N/A;
*/    
    public with sharing class ValidateException extends Exception {}

    /*  Method Name : fetchwrkflowMap
    Parameters  : String selectQuery,String whereClause,String orderByClause,String limitClause
    Return type : Map<Id,GA_WF_Workflow__c>
    Description : This method is used to fetch the GA_WF_Workflow__c record based on parameters passed.
    It will return the Map<ID,GA_WF_Workflow__c> if user wants the Map, they can perform the logic on 
    Map, else they can covert the map to list of workflow step template.
    ******************************************************************************************************/
    public static Map<ID,GA_WF_Workflow__c> fetchwrkflowMap(String selectQuery,String whereClause,String orderByClause,String limitClause){
        String dynaQuery = BLANK;
        Map<ID,GA_WF_Workflow__c> wrkflowMap = NULL;
        try
        {
            dynaQuery = String.isNotBlank(selectQuery) ? selectQuery : BLANK;
            dynaQuery = String.isNotBlank(dynaQuery) && String.isNotBlank(whereClause) ? dynaQuery+=whereClause : dynaQuery;
            dynaQuery = String.isNotBlank(dynaQuery) && String.isNotBlank(orderByClause) ? dynaQuery+=orderByClause : dynaQuery;
            dynaQuery = String.isNotBlank(dynaQuery) && String.isNotBlank(limitClause) ? dynaQuery+=limitClause : dynaQuery;            
          
            if(String.isNotBlank(dynaQuery))
            {
                wrkflowMap = new Map<ID,GA_WF_Workflow__c>((List<GA_WF_Workflow__c>)Database.query(dynaQuery));
            }
        }Catch(Exception ex){            
          throw new ValidateException(wkflwErrorMsg, ex);   
        }    
        return wrkflowMap;
    }
    
    /****************************************************************************************************
    Method Name : dmlOnwrkflw
    Parameters  : List<Account> accList, String operation
    Return type : List<Account>
    Description : This method is used to perform the DML operations on Acocunt.
    Operation value need to pass to perform the respective dml operation.
    Operation name should be passed from SG01_Constants class.
    ******************************************************************************************************/
    public static List<GA_WF_Workflow__c> dmlOnwrkflw(List<GA_WF_Workflow__c> wrkflwList, String operation){
        try
        {
            if( !wrkflwList.isEmpty())
            {
                if(String.isNotBlank(operation) && INSERT_OPERATION.equalsIgnoreCase(operation)){
                    Database.Insert(wrkflwList);
                }else if(String.isNotBlank(operation) && UPDATE_OPERATION.equalsIgnoreCase(operation)){
                    Database.Update(wrkflwList);
                }
                /*else if(String.isNotBlank(operation) && DELETE_OPERATION.equalsIgnoreCase(operation)){
                    Database.Delete(wrkflwList);
                }else {
                    Database.Upsert(wrkflwList);
                }
                */
            }
        }Catch(Exception ex){
            throw new ValidateException(wkflwErrorMsg, ex);   
        }    
        return wrkflwList;
    }

}