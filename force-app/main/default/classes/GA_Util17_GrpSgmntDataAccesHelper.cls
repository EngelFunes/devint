/*****************************************************************************************
Class Name   : GA_Util17_GrpSgmntDataAccesHelper
Date Created : 4/18/2018
Created By   : IDC Offshore
Description  : 1. This is the util data access class for  group segment. Which is used to fetch 
the details from  group segment based on some parameters

Change History : 
******************************************************************************************/
public with sharing class GA_Util17_GrpSgmntDataAccesHelper {
  //Below are the final variables to check the operation on the list of records.
    public static final String INSERT_OPERATION = 'Insert';
    public static final String UPDATE_OPERATION = 'Update';
    public static final String DELETE_OPERATION = 'Delete';
    public static final String UPSERT_OPERATION = 'Upsert';
    public static final String BLANK = ' ';
    public static final string GSERRORMSG = 'Group segment database operation failed :';
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
    public static Map<ID,GA_Group_Segment__c> fetchGrpSgmMap(String selectQuery,String whereClause,String orderByClause,String limitClause){        
        String dynaQuery = BLANK;
        Map<ID,GA_Group_Segment__c> grpSgmMap = NULL;
        try
        {
            dynaQuery = String.isNotBlank(selectQuery) ? selectQuery : BLANK;
            dynaQuery = String.isNotBlank(dynaQuery) && String.isNotBlank(whereClause) ? dynaQuery+=whereClause : dynaQuery;            
            dynaQuery = String.isNotBlank(dynaQuery) && String.isNotBlank(orderByClause) ? dynaQuery+=orderByClause : dynaQuery;            
            dynaQuery = String.isNotBlank(dynaQuery) && String.isNotBlank(limitClause) ? dynaQuery+=limitClause : dynaQuery;           
                     
            if(String.isNotBlank(dynaQuery))
            {
                grpSgmMap = new Map<ID,GA_Group_Segment__c>((List<GA_Group_Segment__c>)Database.query(dynaQuery));
                
            }
            
        }Catch(Exception ex){            
            throw new ValidateException(GSERRORMSG, ex);   
        }    
        return grpSgmMap;
    }
      /****************************************************************************************************
Method Name : dmlOnGS
Parameters  :List<GA_Group_Segment__c> gsLst, String operation
Return type : List<GA_Group_Segment__c> gsLst
Description : This method is used to perform the DML operations o AOR Group segments.
Operation value need to pass to perform the respective dml operation.
******************************************************************************************************/
    public static List<GA_Group_Segment__c> dmlOnGS(List<GA_Group_Segment__c> gsLst, String operation){
        try
        {
            if( !gsLst.isEmpty())
            {
                if(String.isNotBlank(operation) && INSERT_OPERATION.equalsIgnoreCase(operation)){
                    Database.Insert(gsLst);
                }else if(String.isNotBlank(operation) && UPDATE_OPERATION.equalsIgnoreCase(operation)){
                    Database.Update(gsLst);
                }else if(String.isNotBlank(operation) && DELETE_OPERATION.equalsIgnoreCase(operation)){
                    Database.Delete(gsLst);
                }else {
                    Database.Upsert(gsLst);
                }
                
            }
        }Catch(Exception ex){
            throw new ValidateException(GSERRORMSG, ex);   
        }    
        return gsLst;
    }    
    
}