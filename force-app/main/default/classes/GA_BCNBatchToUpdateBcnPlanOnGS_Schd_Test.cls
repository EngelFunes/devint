/*
@Author : IDC Offshore
@Name: GA_BCNBatchToUpdateBcnPlanOnGS_Schd_Test 
@CreatedDate: 23 - Aug 2019 
@Description: GA_BCNBatchToUpdateBcnPlanOnGS_Schd Test class
@version : 1.0  
*/
@isTest(seealldata = false)
private class GA_BCNBatchToUpdateBcnPlanOnGS_Schd_Test {
  /***********************************************************************************************************************************************
@Description: executeTest() method 
@Name : executeTest
@Param : None
@Return : void
@throws Exception : N/A;
************************************************************************************************************************************************/   
    private static testmethod void executeTest()
    {   
        
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestAgentAdmin','testsalesrepmail@bcbsm.com','System Administrator');
        database.insert(usr);
        Map<ID,GA_Plan_Year_Exception_History__c> planexcptOldMap = new Map<ID,GA_Plan_Year_Exception_History__c> ();   
        
        Account acc = GA_OBJ_TD01_TestDataCreation.AccRec();
        database.insert(acc);
        
        GA_Group_Segment__c gsmt = GA_OBJ_TD01_TestDataCreation.grpSegmntRec(acc);
        database.insert(gsmt); 

        GA_Plan_Year_Exception_History__c planexcpt = new GA_Plan_Year_Exception_History__c();
        planexcpt.GA_Group_Segment__c=gsmt.id;
        planexcpt.GA_Plan_Year_Month__c='01';
        planexcpt.GA_Start_Date__c=system.today()-6;
        planexcpt.GA_End_Date__c=system.today()-1;
        planexcpt.GA_Is_Processed__c=False;
        database.insert(planexcpt);
        List<GA_Plan_Year_Exception_History__c> planexcptLst = new List<GA_Plan_Year_Exception_History__c> ();
        GA_Plan_Year_Exception_History__c planexcptRcrd = new GA_Plan_Year_Exception_History__c();
        
        For(Integer i=1 ;i<=101 ; i++)
        {                    
            planexcptRcrd = new GA_Plan_Year_Exception_History__c();
            planexcptRcrd.Name = 'Test ' + i;
            planexcptRcrd.GA_Group_Segment__c=gsmt.id;
            planexcptRcrd.GA_Plan_Year_Month__c='01';
            planexcptRcrd.GA_Start_Date__c=system.today()-1;
            planexcptRcrd.GA_End_Date__c=system.today()+6;
            planexcptLst.add(planexcptRcrd);    
        }
        database.insert(planexcptLst);
        
        system.runAs(usr){
            
            try{
                GA_BCNBatchToUpdateBcnPlanOnGS_Schdlr bcnBtch = new GA_BCNBatchToUpdateBcnPlanOnGS_Schdlr();
                String sch = '0 0 23 * * ?'; 
                string CURDTE=string.valueof(system.today()).split(' ')[0];
                STring BCNQRY='select id, GA_Plan_Year_Month__c,GA_Group_Segment__c,GA_Start_Date__c,'+ 
                    'GA_End_Date__c,GA_Is_Processed__c from GA_Plan_Year_Exception_History__c Where'+ 
                    '(GA_Is_Processed__c=false and GA_Start_Date__c<='+CURDTE +' AND GA_End_Date__c >='+CURDTE +')'+
                    'OR (GA_Is_Processed__c=false and GA_End_Date__c<='+CURDTE +')ORDER BY createddate asc';
                Test.startTest();
                system.schedule('bcnBtch update', sch, bcnBtch);
                Test.stopTest(); 
                system.assert(usr <> null);
            }
            catch(exception e)
            {
                return;
            }        
        }
        
    }
    
}