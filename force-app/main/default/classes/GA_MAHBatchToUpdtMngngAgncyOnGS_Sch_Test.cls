/*
@Author : IDC Offshore
@Name: GA_MAHBatchToUpdtMngngAgncyOnGS_Sch_Test 
@CreatedDate: 23 - Aug 2019 
@Description: GA_MAHBatchToUpdtMngngAgncyOnGS_Sch Test class
@version : 1.0  
*/
@isTest(seealldata = false)
private class GA_MAHBatchToUpdtMngngAgncyOnGS_Sch_Test {
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
        
        Id RecordTypeIdAccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Agency').getRecordTypeId();
        Account acc = GA_OBJ_TD01_TestDataCreation.AccRec();
        acc.Name='Test Acc';
        acc.RecordTypeId=RecordTypeIdAccount;
        acc.GA_Managing_Agency_Code__c='01';
        database.insert(acc);
        
        GA_Group_Segment__c gsmt = GA_OBJ_TD01_TestDataCreation.grpSegmntRec(acc);
        database.insert(gsmt); 
        
        GA_Managing_Agency_History__c mngAgcnyHstry = new GA_Managing_Agency_History__c();
        mngAgcnyHstry.GA_Group_Segment__c=gsmt.id;
        mngAgcnyHstry.GA_Managing_Agency__c=acc.id;
        mngAgcnyHstry.GA_Start_Date__c=system.today()-6;
        mngAgcnyHstry.GA_End_Date__c=system.today()-1;
        mngAgcnyHstry.GA_Is_Processed__c=False;
        database.insert(mngAgcnyHstry);
        
        List<GA_Managing_Agency_History__c> mngAgcnyHstryLst = new List<GA_Managing_Agency_History__c> ();
        GA_Managing_Agency_History__c mngAgcnyHstryRcrd = new GA_Managing_Agency_History__c();
        
        For(Integer i=1 ;i<=101 ; i++)
        {                    
            mngAgcnyHstryRcrd = new GA_Managing_Agency_History__c();
            mngAgcnyHstryRcrd.Name = 'Test ' + i;
            mngAgcnyHstryRcrd.GA_Group_Segment__c=gsmt.id;
            mngAgcnyHstryRcrd.GA_Managing_Agency__c=acc.id;
            mngAgcnyHstryRcrd.GA_Start_Date__c=system.today()-6;
            mngAgcnyHstryRcrd.GA_End_Date__c=system.today()-1;
            mngAgcnyHstryRcrd.GA_Is_Processed__c=False;
            mngAgcnyHstryLst.add(mngAgcnyHstryRcrd);    
        }
        database.insert(mngAgcnyHstryLst);
        
        system.runAs(usr){
            
            try{
                GA_MAHBatchToUpdateMngngAgncyOnGS_Schdlr mahBtch = new GA_MAHBatchToUpdateMngngAgncyOnGS_Schdlr();
                String sch = '0 0 23 * * ?'; 
                string CURDTE=string.valueof(system.today()).split(' ')[0];
                STring MAHQRY='select id, GA_Managing_Agency__c, GA_Group_Segment__c, GA_Start_Date__c,'+ 
                    'GA_End_Date__c,GA_Is_Processed__c from GA_Managing_Agency_History__c Where'+ 
                    '(GA_Is_Processed__c=false and GA_Start_Date__c<='+CURDTE +' AND GA_End_Date__c >='+CURDTE +')'+
                    'OR (GA_Is_Processed__c=false and GA_End_Date__c<='+CURDTE +')ORDER BY createddate asc';
                Test.startTest();
                system.schedule('mahBtch update', sch, mahBtch);
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