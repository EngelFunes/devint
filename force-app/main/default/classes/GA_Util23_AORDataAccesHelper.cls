/*****************************************************************************************
Class Name   : GA_Util23_AORDataAccesHelper
Date Created : 7/30/2019
Created By   : IDC Offshore
Description  : This util data access class is for AOR, which is used to fetch 
the details from AOR based on some parameters.
******************************************************************************************/
public with sharing class GA_Util23_AORDataAccesHelper {
    //Below are the final variables to check the operation on the list of records.
    public static final String INSERT_OPERATION = 'Insert';
    public static final String UPDATE_OPERATION = 'Update';
    public static final String DELETE_OPERATION = 'Delete';
    public static final String UPSERT_OPERATION = 'Upsert';
    public static final String BLANK = ' ';
    public static final string AORERRORMSG = 'AOR database operation failed :';
    /**
@Description: ValidateException() method 
@Name : ValidateException
@Param : None
@Return : void
@throws Exception : N/A;
*/    
    public with sharing class ValidateException extends Exception {}
    /****************************************************************************************************
Method Name : fetchwrkflwGrpSgmMap
Parameters  : String selectQuery,String whereClause,String orderByClause,String limitClause
Return type : Map<Id,GA_WF_Group_Segment__c>
Description : This method is used to fetch the GA_WF_Group_Segment__c record based on parameters passed.
It will return the Map<ID,GA_WF_Group_Segment__c> if user wants the Map, they can perform the logic on 
Map, else they can covert the map to list of workflow group segment.
******************************************************************************************************/
    public static Map<ID,GA_AOR__c> fetchAORMap(String selectQuery,String whereClause,String limitClause){
        String dynaQuery = BLANK;
        Map<ID,GA_AOR__c> aorMap = NULL;
        try
        {
            dynaQuery = String.isNotBlank(selectQuery) ? selectQuery : BLANK;
            dynaQuery = String.isNotBlank(dynaQuery) && String.isNotBlank(whereClause) ? dynaQuery+=whereClause : dynaQuery;
            dynaQuery = String.isNotBlank(dynaQuery) && String.isNotBlank(limitClause) ? dynaQuery+=limitClause : dynaQuery;            
            
            if(String.isNotBlank(dynaQuery))
            {
                aorMap = new Map<ID,GA_AOR__c>((List<GA_AOR__c>)Database.query(dynaQuery));
            }
        }Catch(Exception ex){            
            throw new ValidateException(AORERRORMSG, ex);   
        }    
        return aorMap;
    }    
}