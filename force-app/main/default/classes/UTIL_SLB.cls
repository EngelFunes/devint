/**
* @author          Dinesh
* @date            
* @description     This class contains the generic utility methods used across multiple classes in the application
*/
public with sharing class UTIL_SLB {


     /**
      * @description    This method returns the remaining limit of queries that can be done in the transaction in context
      * @param          NA
      * @return         Integer
      * @throws         NA
      */
    public static Integer retrieveQueryLimitValue() {
        // return the difference between total number of query rows that can be retrieved in a transaction
        // and the number of query rows already exhausted in the transaction
        return Limits.getLimitQueryRows()-Limits.getQueryRows();
    }


    /**
  * @description    This method returns a map of all sObject names (keys) to sObject tokens (values) for the standard and custom objects defined in the organization.
  * @param          NA
  * @return         Map<String,Schema.SObjectType>
  * @throws         NA
  */
   public static Map<String,Schema.SObjectType> createDescribeMap() {
        return Schema.getGlobalDescribe();
    }
}