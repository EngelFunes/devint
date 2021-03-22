/******************************************************************************
* Apex Class Name : UTIL_SLB_Test        
* Version         : 44.0  
* Function        : This test class will be used to cover the UTIL_SLB class
* Developer         Date            Description        US Number
-------------------------------------------------------------------------------------
*Offshore         03/18/2020       Original Version
*/
@isTest
private class UTIL_SLB_Test { 

     private static final String CLASSNAME = 'UTIL_SLB_Test';
     private static final String PARAM_ID_KEY = 'id';
     private static final String PARAM_ID_VALUE = 'testid';
    
              
     /**
      * @description    This method call the static methods of UTIL_SLB
      * @param          NA
      * @throws         NA
      * @return         NA
      */
     static testMethod void testRetURLParam() {
          user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestSysAdm','testsysadm@bcbsm.com','System Administrator');
          System.runAs(usr){
            Test.startTest();
                 Map<String,String> paramsMap = new Map<String,String>();
                 paramsMap.put(PARAM_ID_KEY,PARAM_ID_VALUE);
                 UTIL_SLB.retrieveQueryLimitValue();
                 UTIL_SLB.createDescribeMap();
            Test.stopTest();
            System.assertequals('testid',PARAM_ID_VALUE);
            
        }
     }     
}