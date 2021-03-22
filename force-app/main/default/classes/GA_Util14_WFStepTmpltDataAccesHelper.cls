/*****************************************************************************************
Class Name   : GA_Util14_WFStepTmpltDataAccesHelper
Date Created : 4/10/2018
Created By   : IDC Offshore
Description  : 1. This is the util data access class for workflow step template. Which is used to fetch 
the details from workflow step template based on some parameters

Change History : 
******************************************************************************************/
public with sharing class GA_Util14_WFStepTmpltDataAccesHelper {
    //Below are the final variables to check the operation on the list of records.
    public static final String BLANK = ' ';
     public static final string WFStpTErrorMsg = 'workflow step template database operation failed :';
    /**
@Description: ValidateException() method 
@Name : ValidateException
@Param : None
@Return : void
@throws Exception : N/A;
*/    
    public with sharing class ValidateException extends Exception {}
     /****************************************************************************************************
    Method Name : fetchwrkflowStpTmpsMap
    Parameters  : String selectQuery,String whereClause,String orderByClause,String limitClause
    Return type : Map<Id,GA_WFT_Step__c>
    Description : This method is used to fetch the GA_WFT_Step__c record based on parameters passed.
    It will return the Map<ID,GA_WFT_Step__c> if user wants the Map, they can perform the logic on 
    Map, else they can covert the map to list of workflow step template.
    ******************************************************************************************************/
    public static Map<ID,GA_WFT_Step__c> fetchwrkflowStpTmpsMap(String selectQuery,String whereClause,String orderByClause,String limitClause){
        String dynaQuery = BLANK;
        Map<ID,GA_WFT_Step__c> wrkflowStpTmpMap = NULL;
        try
        {
            dynaQuery = String.isNotBlank(selectQuery) ? selectQuery : BLANK;
            dynaQuery = String.isNotBlank(dynaQuery) && String.isNotBlank(whereClause) ? dynaQuery+=whereClause : dynaQuery;
            dynaQuery = String.isNotBlank(dynaQuery) && String.isNotBlank(orderByClause) ? dynaQuery+=orderByClause : dynaQuery;
            dynaQuery = String.isNotBlank(dynaQuery) && String.isNotBlank(limitClause) ? dynaQuery+=limitClause : dynaQuery;            
          
            if(String.isNotBlank(dynaQuery))
            {
                wrkflowStpTmpMap = new Map<ID,GA_WFT_Step__c>((List<GA_WFT_Step__c>)Database.query(dynaQuery));
            }
        }Catch(Exception ex){            
          throw new ValidateException(WFStpTErrorMsg, ex);   
        }    
        return wrkflowStpTmpMap;
    }
    
}