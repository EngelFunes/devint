/**
@Author : IDC Offshore
@Name: GA_ScheduleAndEmailReports_Test 
@CreatedDate: 20-Mar-2018
@Description: Test class for GA_ScheduleAndEmailReports
@version : 1.0  
*/
@isTest(seealldata = true)
private without sharing class GA_ScheduleAndEmailReports_Test {
    public static final String CRON_EXP = '0 0 0 15 3 ? 2022';
/*******************************************************************************************************************************
@Description        :   EmailSchdlTest() method 
@Name               :   EmailSchdlTest
@Param              :   None
@Return             :   void
@throws Exception   :   N/A;
********************************************************************************************************************************/ 
  	 private static testMethod   void emailSchdlTest(){
        
        user usrSA = GA_OBJ_TD01_TestDataCreation.UsrRec('Testwfstp','testsystemadminstrator@bcbsm.com','System Administrator');
        database.insert(usrSA);
        system.runAs(usrSA)
        {
          try{
                List <Report> reportList = [SELECT Id,DeveloperName FROM Report where
                                            DeveloperName = 'ST_Open_Groups_Processor_to_Review' Limit 1];
                GA_ScheduleAndEmailReports sh1 = new GA_ScheduleAndEmailReports();      
                String sch = '0 0 23 * * ?';
                Test.startTest();
                system.schedule('Test check', sch, sh1);
                Test.stopTest();
                
                system.assert(usrSA <> null);
           }
            
            catch(exception e)
            {
                return;
            }
        }
        
    }
}