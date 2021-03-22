/**
*Class Name   : ARV_AP07_QueryDataHelper 
*Date Created : 3-MAY-2019
*Created By   : IDC Offshore
*Description  : This is the class for to fetch dynamic QueryData
**/
public without sharing class ARV_AP07_QueryDataHelper {
    public static List<string>  docstrings;
    public static Id paramId1;
    public static List<Quote> quoteid;
    public static string qtId;
    public static Id paramId5;
    public static set<Id> paramId2;
    public static set<string> mystring;
    public static string paramName;
    public static string paramName1;
    public static string paramName2;
    public static string paramName3;
    public static string paramName5;
    public static Boolean paramName4;
    public static Set<Id>  products;
    public static list<Id> idsList;
    public static Date dateVal;
    private static final string CLASSNAME  ='ARV_AP07_QueryDataHelper';
    private static final string METHODNAME  ='getsObjects';
    private static final string QUOTELNITMS_METHOD  = 'getQuoteLineItems';
    private static final string GET_PRODUCTNAME_METHOD  = 'getProductName';
    private static final string INSERT_RATEGRID_METHOD  = 'insertIntoRateGridData';
    private static final string GET_QUOTE_METHOD  = 'getQuoteData';
    
    /**
    *Method Name : getsObjects
    *Parameters  : selectQuery,whereClause,orderByClause and limitClause
    *Return type : List<sObject>
    *Description : This method is used to perform select operations on Salesforce objects.
    **/
    public static List<sObject> getsObjects(String selectQuery,String whereClause,String orderByClause,String limitClause)
    {
        List<sObject> objectList = NULL;
        try{
            String dynaQuery='';
            dynaQuery=selectQuery;
            dynaQuery = String.isNotBlank(dynaQuery) && String.isNotBlank(whereClause) ? dynaQuery+=whereClause : dynaQuery;
            dynaQuery = String.isNotBlank(dynaQuery) && String.isNotBlank(orderByClause) ? dynaQuery+=orderByClause : dynaQuery;
            dynaQuery = String.isNotBlank(dynaQuery) && String.isNotBlank(limitClause) ? dynaQuery+=limitClause : dynaQuery;
            
            system.debug('DynaQuery '+dynaQuery);
            system.debug('WhereClause'+whereClause);
            system.debug('limitClause'+limitClause);
            system.debug('orderByClause'+orderByClause);
            system.debug('QuoteiDStringS'+paramId1);
        if(String.isNotBlank(dynaQuery))
            {
                objectList = ((List<sObject>)Database.query(dynaQuery));
            }

        }
       catch(exception e)
        {
            GA_LogExceptionCls.LogExcp(e, CLASSNAME, METHODNAME);
            throw new AuraHandledException(e.getMessage()); 
        } 
        return objectList;
    } 
}