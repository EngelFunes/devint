/*****************************************************************************************
Class Name   : GA_Util18_QueueDataAccesHelper
Date Created : 4/10/2018
Created By   : IDC Offshore
Description  : 1. This is the util data access class for Queue

******************************************************************************************/
public with sharing class GA_Util18_QueueDataAccesHelper {
 public static final String BLANK = ' ';
     public static final string QueueErrorMsg = 'Queue database operation failed :';
    /**
@Description: ValidateException() method 
@Name : ValidateException
@Param : None
@Return : void
@throws Exception : N/A;
*/    
    public with sharing class ValidateException extends Exception {}
     /****************************************************************************************************
    Method Name : fetchwrkflowTmpsMap
    Parameters  : String selectQuery,String whereClause,String orderByClause,String limitClause
    Return type : Map<Id,GA_WFT_workflow__c>
    Description : This method is used to fetch the GA_WFT_workflow__c record based on parameters passed.
    It will return the Map<ID,GA_WFT_workflow__c> if user wants the Map, they can perform the logic on 
    Map, else they can covert the map to list of workflow template.
    ******************************************************************************************************/
    public static Map<ID,QueueSobject> fetchQueuesMap(String selectQuery,String whereClause,String orderByClause,String limitClause){
        String dynaQuery = BLANK;
        Map<ID,QueueSobject> queueTmpMap = NULL;
        try
        {
            dynaQuery = String.isNotBlank(selectQuery) ? selectQuery : BLANK;
            dynaQuery = String.isNotBlank(dynaQuery) && String.isNotBlank(whereClause) ? dynaQuery+=whereClause : dynaQuery;
            dynaQuery = String.isNotBlank(dynaQuery) && String.isNotBlank(orderByClause) ? dynaQuery+=orderByClause : dynaQuery;
            dynaQuery = String.isNotBlank(dynaQuery) && String.isNotBlank(limitClause) ? dynaQuery+=limitClause : dynaQuery;            
          
            if(String.isNotBlank(dynaQuery))
            {
                queueTmpMap = new Map<ID,QueueSobject>((List<QueueSobject>)Database.query(dynaQuery));
            }
        }Catch(Exception ex){            
          throw new ValidateException(QueueErrorMsg, ex);   
        }    
        return queueTmpMap;
    }
 
}