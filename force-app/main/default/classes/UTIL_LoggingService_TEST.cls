/**
  * @author        Urmi Chatterjee
  * @date          10/10/2013
  * @description   Test Class for UTIL_LoggingService class.
  */


@isTest
private class UTIL_LoggingService_TEST{
    
    // Start of Constants for Test Methods
     
    private static final String UN_ALIAS = 'unEr';
    private static final String HN_ALIAS = 'hEr';
    private static final Integer NUM = 1;
    private static final String SYSTEM_ADMIN = 'System Administrator';
    private static final String TEST_EMAIL = 'automation@testapex.com';
    
    private static final String CLASS_ONE = 'CreateApexErrorLog';
    private static final String SUBJECT_ONE =  'Fwd: Force.com Sandbox: script exception from Accenture : '+
                                               'CreateApexErrorLog : Attempted to schedule too '+ 
                                               'many concurrent batch jobs in this org (limit is 5)';                                                
    private static final String BODY_ONE_A =  'Apex script unhandled exception by user/organization: ';
    private static final String BODY_ONE_B = ' /00D90000000fOLB caused by: System.Exception: Attempted to schedule too'+
                                            ' many concurrent batch jobs '+ 
                                            'Class.CreateApexErrorLog.execute: Debug Log: Starts';
    
    private static final String SUBJECT_TWO = 'Developer script exception from Accenture : CreateApexErrorLog : '+
                                              'Attempt to de-reference a null object';
    private static final String BODY_TWO_A = 'Apex script unhandled exception by user/organization: ';
    private static final String BODY_TWO_B = '/00D90000000fOLB Visualforce Page: /apex/flowfinishsecpage '+
                                             'caused by: System.NullPointerException: Attempt to de-reference a null object '+
                                             'Class.CreateApexErrorLog.dataSplit: line 132, column 1';
    
    private static final String CLASS_THREE = 'BeforeUpdate';
    private static final String SUBJECT_THREE = 'RE: Developer script exception from Test Org :BeforeUpdate: execution of AfterInsert';
    private static final String BODY_THREE_A = 'Apex script unhandled trigger exception by user/organization: ';
    private static final String BODY_THREE_B = ' /00D90000000fOLB exception by Test user Org System.QueryException: test: Trigger.BeforeUpdate: line 5, column 1';
    
    private static final String SUBJECT_FOUR_A = 'FW: Developer script exception from Test Org :';
    private static final String SUBJECT_FOUR_B = ' : List index out of bounds ';
    private static final String BODY_FOUR_A = 'Apex script unhandled exception by user/organization: ';
    private static final String BODY_FOUR_B = ' /00D90000000fOLB exception by Test user Org' +
                                              UTIL_ErrorConstants.CAUSED_BY + 'System.ListException: List index out of bounds:' +
                                              UTIL_ErrorConstants.PREFIX_CLASS;
    private static final String BODY_FOUR_C = '.testMethod: line 132, column 1'; 
    
    private static final String SUBJECT_SIX = 'Test:Subject:Exception';
    private static final String BODY_SIX = 'Test Body';
    
    private static final String TEST_ORG_ID = 'TestOrgId';
    private static final String TEST_APP = 'TestApp';
    private static final String TEST_CLASS = 'TestClass';
    private static final String TEST_METHOD = 'TestMethod';
    private static final String TEST_USER_ROLE = 'TestUserRole';
    
    // End of Constants for Test Methods
    
    /**
      * @description       Method to create Messaging.InboundEmail type test data. 
      * @param             subject Subject of the email
      * @param             body Body of the email
      * @return            Messaging.InboundEmail
      * @throws            NA
      */
    private static Messaging.InboundEmail emailData(String subject, String body){
        Messaging.InboundEmail email = new Messaging.InboundEmail();
        email.subject = subject;
        email.plainTextBody = body;
        email.fromAddress = TEST_EMAIL;
        return email;
    }
    
    /**
      * @description       Method to create Custom Setting record to determine severity level. 
      * @param             NA
      * @return            void
      * @throws            NA
      */
    public static void severityLevelValue(){
        LogSeverityLevelValue__c logLevel = LogSeverityLevelValue__c.getInstance(UserInfo.getOrganizationId());
        logLevel.LoggingLevel__c=UTIL_ErrorConstants.SEVERITY_LEVEL_ERROR;
        insert logLevel;  
    }
    
    
  
   
    /**
      * @description       This Test Method is to verify that ExceptionLog__c record is logged 
                           in case of any program throwing a Handled Exception. 
      * @param             NA
      * @return            void
      * @throws            NA
      */
    private static testMethod void handledException(){
        User runUser = UTIL_ErrorHandling_TestMethods.runningUser(HN_ALIAS+NUM , SYSTEM_ADMIN);
        severityLevelValue();
        try{
         Test.startTest();
            Contact testData = new Contact();
           
            insert(testData);  
             Test.stopTest();         
        }
        catch(Exception excp){        
           
           // System.runAs(runUser ){
               UTIL_LoggingService.logHandledException(excp, TEST_ORG_ID, TEST_APP, TEST_CLASS, TEST_METHOD, null, LoggingLevel.ERROR);
          //  }
           
        }
        ExceptionLog__c excpData = [SELECT ClassName__c, Severity__c FROM ExceptionLog__c WHERE Application__c=:TEST_APP]; 
        System.assertEquals(excpData.ClassName__c, TEST_CLASS);
    }
    
    /**
      * @description       This Test Method is to verify that ExceptionLog__c record is merged with an existing ExceptionLog__c record
                           in case of any program throwing a Handled Exception. 
      * @param             NA
      * @return            void
      * @throws            NA
      */
    private static testMethod void handledExceptionMerge(){
        User runUser = UTIL_ErrorHandling_TestMethods.runningUser(HN_ALIAS+NUM+1 , SYSTEM_ADMIN);
        System.runAs(runUser){
        severityLevelValue();
        try{
            //Account testData1 = new Account();
            Contact testData1 = new Contact();
            insert(testData1);           
        }
        catch(DMLException excp){                    
            try{
                Contact testData2 = new Contact();
                insert(testData2);           
            }
            catch(DMLException dmlExcp){
                Test.startTest();
                
                   UTIL_LoggingService.logHandledException(excp, TEST_ORG_ID, TEST_APP, TEST_CLASS, TEST_METHOD, null, LoggingLevel.ERROR);
                   UTIL_LoggingService.logHandledException(dmlExcp, TEST_ORG_ID, TEST_APP, TEST_CLASS, TEST_METHOD, null, LoggingLevel.ERROR);
                
                Test.stopTest();
            }
        }
        ExceptionLog__c excpData = [SELECT NumberOfTimesOccured__c FROM ExceptionLog__c WHERE Application__c=:TEST_APP Limit 1]; 
        System.assertEquals(excpData.NumberOfTimesOccured__c, 1);
        }
    }
    
  
  
    
    /**
      * @description       This Test Method is to verify that ExceptionLog__c record is not logged when 
                           the Logging Level is below 'ERROR'.
      * @param             NA
      * @return            void
      * @throws            NA
      */
    private static testMethod void handledExceptionLoggingLevel(){
        User runUser = UTIL_ErrorHandling_TestMethods.runningUser(HN_ALIAS+NUM+8 , SYSTEM_ADMIN);
        System.runAs(runUser){
        severityLevelValue();
        try{
            Contact testData = new Contact();
            insert(testData);           
        }
        catch(DMLException excp){        
            Test.startTest();
            
               UTIL_LoggingService.logHandledException(excp, TEST_ORG_ID, TEST_APP, TEST_CLASS, TEST_METHOD, null, LoggingLevel.FINE);
           
            Test.stopTest();
        }
        Integer excpDataCount = [SELECT COUNT() FROM ExceptionLog__c WHERE Application__c=:TEST_APP]; 
        System.assertEquals(excpDataCount, 0);
    }
     }
    
    
      
}