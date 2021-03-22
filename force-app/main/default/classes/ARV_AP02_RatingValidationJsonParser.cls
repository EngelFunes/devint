/*************************************************************
Class Name   : ARV_AP02_RatingValidationJsonParser 
Date Created : 30-Mar-2019
Created By   : Anusha and Silpa
Description  : Wrapper class for ARV_AP02_RatingValidationJsonParser class to parse JSON string
*****************************************************************/
public with sharing class ARV_AP02_RatingValidationJsonParser {
    public List<CensusDetails> censusDetails = new List<CensusDetails>();
    // variables declaration to use in Exception handling
    private static final string CLSNAME  = 'ARV_AP02_RatingValidationJsonParser';
    private static final string METHODNAME_COMPARE  ='compareTo';
    private static final string METHODNAME_PARSE  ='parse';
    private static final String EXCEPSEPRATR=': ';
    private static final String ERRORMSG_COMPARE='Unable to Compare age';
    private static final String ERRORMSG_PARSE='Unable to parse the JSON';
    
    /*************************************************************
    Class Name   : CensusDetails  
    Date Created : 30-Mar-2019
    Created By   : Anusha and Silpa
    Description  : Wrapper class for ARV_AP02_RatingValidationJsonParser class to parse JSON string and comparision
    *****************************************************************/        
    public with sharing class CensusDetails implements Comparable{    
        public String RF_SG_CM_Id;
        public String RF_SG_CM_ParentId;
        public String RF_SG_CM_MemberType;
        public Integer Age;
        public String Gender;
        public String Relationship;
        public Boolean isPrimary;
        public Boolean isSpouse;
        public String Id;
        public String ZipCode;
        public String HIOSPlanID;
        public Boolean Smoker;
        public String ProductName;
        public String productKey;
        public String parentProdKey;        
        public String DOB;
        public String empOnlyCount;
        public String empSpouseCount;
        public String empChildCount;
        public String empFamilyCount;
        public String Calculate;
       
        
        /**************  
        Method name : compareTo
        Param      : Object to which compare need to happen
        Return Type : Integer
        Description : This method to run the age in the sorting order.
        *************/        
        public Integer compareTo(Object objToCompare) {            
            try{            
                return Integer.valueOf(age - ((CensusDetails)objToCompare).age);
            }catch(Exception e){
                GA_LogExceptionCls.LogExcp(e, CLSNAME, METHODNAME_COMPARE);
                throw new AuraHandledException(ERRORMSG_COMPARE+EXCEPSEPRATR+e.getMessage());
            } 
        }
    }
 
    /*  
    Method name : parse
    Param 1     : String json
    Return Type : List<ARV_AP01_RatingValidationJsonParser.CensusDetails>
    Description : This method is used parse the JSON string in to sObject List.
    */
    public static List<ARV_AP02_RatingValidationJsonParser.CensusDetails> parse(String json) {
        try{
        return (List<ARV_AP02_RatingValidationJsonParser.CensusDetails>) System.JSON.deserialize(json, List<ARV_AP02_RatingValidationJsonParser.CensusDetails>.class);
        }catch(Exception e){
             GA_LogExceptionCls.LogExcp(e, CLSNAME, METHODNAME_PARSE);        
             throw new AuraHandledException(ERRORMSG_PARSE+EXCEPSEPRATR+e.getMessage());  
        }
    }
    
}