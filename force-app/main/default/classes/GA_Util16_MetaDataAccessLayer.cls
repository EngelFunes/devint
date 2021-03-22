/*****************************************************************************************
Class Name   : GA_Util16_MetaDataAccessLayer
Date Created : 4/18/2018
Created By   : IDC Offshore
Description  : 1. This is the util data access class for custom meta data. Which is used to fetch 
the details from workflow group segment based on some parameters

Change History : 
******************************************************************************************/
public with sharing class GA_Util16_MetaDataAccessLayer {
   //Below are the final variables to check the operation on the list of records.
    
    public static final String BLANK = ' ';
    public static final string CustMDErrorMsg = 'custom metadata database operation failed :';
    /**
@Description: ValidateException() method 
@Name : ValidateException
@Param : None
@Return : void
@throws Exception : N/A;
*/    
    public with sharing class ValidateException extends Exception {}
    /****************************************************************************************************
Method Name : fetchWFqueueMap
Parameters  : String selectQuery,String whereClause,String orderByClause,String limitClause
Return type : Map<Id,GA_WF_Queue_Mapping__mdt>
Description : This method is used to fetch the GA_WF_Queue_Mapping__mdt record based on parameters passed.
It will return the Map<ID,GA_WF_Queue_Mapping__mdt> if user wants the Map, they can perform the logic on 
Map, else they can covert the map to list of workflow group segment.
******************************************************************************************************/
    public static Map<ID,GA_WF_Queue_Mapping__mdt> fetchWFqueueMap(String selectQuery,String whereClause,String orderByClause,String limitClause){
        String dynaQuery = BLANK;
        Map<ID,GA_WF_Queue_Mapping__mdt> wfQueueMap = NULL;
        try
        {
            dynaQuery = String.isNotBlank(selectQuery) ? selectQuery : BLANK;
            dynaQuery = String.isNotBlank(dynaQuery) && String.isNotBlank(whereClause) ? dynaQuery+=whereClause : dynaQuery;
            dynaQuery = String.isNotBlank(dynaQuery) && String.isNotBlank(orderByClause) ? dynaQuery+=orderByClause : dynaQuery;
            dynaQuery = String.isNotBlank(dynaQuery) && String.isNotBlank(limitClause) ? dynaQuery+=limitClause : dynaQuery;            
            
            
            if(String.isNotBlank(dynaQuery))
            {
                wfQueueMap = new Map<ID,GA_WF_Queue_Mapping__mdt>((List<GA_WF_Queue_Mapping__mdt>)Database.query(dynaQuery));
            }
        }Catch(Exception ex){            
            throw new ValidateException(CustMDErrorMsg, ex);   
        }    
        return wfQueueMap;
    }
      /****************************************************************************************************
Method Name : fetchWFqueueMap
Parameters  : String selectQuery,String whereClause,String orderByClause,String limitClause
Return type : Map<Id,GA_WF_Queue_Mapping__mdt>
Description : This method is used to fetch the GA_WF_Queue_Mapping__mdt record based on parameters passed.
It will return the Map<ID,GA_WF_Queue_Mapping__mdt> if user wants the Map, they can perform the logic on 
Map, else they can covert the map to list of workflow group segment.
******************************************************************************************************/
    public static Map<ID,User_Step_Role_Mapping__mdt> fetchUserStepRoleMap(String selectQuery,String whereClause,String orderByClause,String limitClause){
        String dynaQuery = BLANK;
        Map<ID,User_Step_Role_Mapping__mdt> wfQueueMap = NULL;
        try
        {
            dynaQuery = String.isNotBlank(selectQuery) ? selectQuery : BLANK;
            dynaQuery = String.isNotBlank(dynaQuery) && String.isNotBlank(whereClause) ? dynaQuery+=whereClause : dynaQuery;
            dynaQuery = String.isNotBlank(dynaQuery) && String.isNotBlank(orderByClause) ? dynaQuery+=orderByClause : dynaQuery;
            dynaQuery = String.isNotBlank(dynaQuery) && String.isNotBlank(limitClause) ? dynaQuery+=limitClause : dynaQuery;            
            
            
            if(String.isNotBlank(dynaQuery))
            {
                wfQueueMap = new Map<ID,User_Step_Role_Mapping__mdt>((List<User_Step_Role_Mapping__mdt>)Database.query(dynaQuery));
            }
        }Catch(Exception ex){            
            throw new ValidateException(CustMDErrorMsg, ex);   
        }    
        return wfQueueMap;
    }
}