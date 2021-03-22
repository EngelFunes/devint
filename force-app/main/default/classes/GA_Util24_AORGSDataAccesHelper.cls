/*****************************************************************************************
Class Name   : GA_Util24_AORGSDataAccesHelper
Date Created : 7/30/2019
Created By   : IDC Offshore
Description  : This util data access class is for AOR, which is used to fetch 
the details from AOR based on some parameters.
******************************************************************************************/
public with sharing class GA_Util24_AORGSDataAccesHelper {
    //Below are the final variables to check the operation on the list of records.
    public static final String INSERT_OPERATION = 'Insert';
    public static final String UPDATE_OPERATION = 'Update';
    public static final String DELETE_OPERATION = 'Delete';
    public static final String UPSERT_OPERATION = 'Upsert';
    public static final String BLANK = ' ';
    public static final string AORGSERRORMSG = 'AOR database operation failed :';
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
    public static Map<ID,GA_AOR_Group_Segment__c> fetchAORGSMap(String selectQuery,String whereClause,String limitClause){
        String dynaQuery = BLANK;
        Map<ID,GA_AOR_Group_Segment__c> aorgsMap = NULL;
        try
        {
            dynaQuery = String.isNotBlank(selectQuery) ? selectQuery : BLANK;
            dynaQuery = String.isNotBlank(dynaQuery) && String.isNotBlank(whereClause) ? dynaQuery+=whereClause : dynaQuery;
            dynaQuery = String.isNotBlank(dynaQuery) && String.isNotBlank(limitClause) ? dynaQuery+=limitClause : dynaQuery;            
            
            system.debug('dynaQuery->'+dynaQuery);
            if(String.isNotBlank(dynaQuery))
            {
               aorgsMap = new Map<ID,GA_AOR_Group_Segment__c>((List<GA_AOR_Group_Segment__c>)Database.query(dynaQuery));
            }
        }Catch(Exception ex){            
            throw new ValidateException(AORGSERRORMSG, ex);   
        }    
        return aorgsMap;
    }
    /****************************************************************************************************
Method Name : dmlOnAORGs
Parameters  :List<GA_AOR_Group_Segment__c> aorGSLst, String operation
Return type : List<GA_AOR_Group_Segment__c>
Description : This method is used to perform the DML operations on AOR Group segments.
Operation value need to pass to perform the respective dml operation.
******************************************************************************************************/
    public static List<GA_AOR_Group_Segment__c> dmlOnAORGs(List<GA_AOR_Group_Segment__c> aorGSLst, String operation){
        try
        {
            if( !aorGSLst.isEmpty())
            {
                if(String.isNotBlank(operation) && INSERT_OPERATION.equalsIgnoreCase(operation)){
                    Database.Insert(aorGSLst);
                }
                
            }
        }Catch(Exception ex){
            throw new ValidateException(AORGSERRORMSG, ex);   
        }    
        return aorGSLst;
    }    
}