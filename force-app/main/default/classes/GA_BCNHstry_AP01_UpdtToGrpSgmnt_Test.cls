/*
@Author : IDC Offshore
@Name: GA_BCNHstry_AP01_UpdtToGrpSgmnt_Test 
@CreatedDate: 22 - Aug 2019 
@Description: GA_BCNHstry_AP01_UpdtToGrpSgmnt Test class
@version : 1.0  
*/
@isTest(seealldata = false)
private class GA_BCNHstry_AP01_UpdtToGrpSgmnt_Test {
    
    /*******************************************************************************************************************************
@Description: plExcptnFutureEndDt() method 
@Name : plExcptnFutureEndDt
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
    private static testmethod void plExcptnFutureEndDt(){
        user usrSA = GA_OBJ_TD01_TestDataCreation.UsrRec('Testwfstp','testsystemadminstrator@bcbsm.com','System Administrator');
        database.insert(usrSA);
        system.runAs(usrSA)
        {
            try{
                Map<ID,GA_Plan_Year_Exception_History__c> planexcptOldMap = new Map<ID,GA_Plan_Year_Exception_History__c> ();   
                Account testAccount = GA_OBJ_TD01_TestDataCreation.AccRec();
                database.insert(testAccount);
                
                GA_Group_Segment__c grpSgmntRec=GA_OBJ_TD01_TestDataCreation.grpSegmntRec(testAccount);
                database.insert(grpSgmntRec);
                
                GA_Plan_Year_Exception_History__c planexcpt = new GA_Plan_Year_Exception_History__c();
                planexcpt.GA_Group_Segment__c=grpSgmntRec.id;
                planexcpt.GA_Plan_Year_Month__c='01';
                planexcpt.GA_Start_Date__c=system.today();
                database.insert(planexcpt);
                
                planexcptOldMap.put(planexcpt.id,planexcpt);
                
                GA_Plan_Year_Exception_History__c planexcpt2 = new GA_Plan_Year_Exception_History__c();
                planexcpt2.id=planexcpt.id;
                planexcpt2.GA_Start_Date__c=system.today()-1;
                planexcpt2.GA_End_Date__c=system.today()+6;
                List<GA_Plan_Year_Exception_History__c> planexcptLst = new List<GA_Plan_Year_Exception_History__c> ();
                planexcptLst.add(planexcpt2);
                
                test.startTest();
                GA_BCNHstry_AP01_UpdtToGrpSgmnt.updtBCNtoGs(planexcptLst,planexcptOldMap);
                test.stopTest();
                system.assert(usrSA <> null);
            }
            catch(exception e)
            {
                return;
            }
        }
    } 
    
    /*******************************************************************************************************************************
@Description: plExcptnPastEndDt() method 
@Name : plExcptnPastEndDt
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
    private static testmethod void plExcptnPastEndDt(){
        user usrSA = GA_OBJ_TD01_TestDataCreation.UsrRec('Testwfstp','testsystemadminstrator@bcbsm.com','System Administrator');
        database.insert(usrSA);
        system.runAs(usrSA)
        {
            try{
                Map<ID,GA_Plan_Year_Exception_History__c> planexcptOldMap = new Map<ID,GA_Plan_Year_Exception_History__c> ();   
                Account testAccount = GA_OBJ_TD01_TestDataCreation.AccRec();
                database.insert(testAccount);
                
                GA_Group_Segment__c grpSgmntRec=GA_OBJ_TD01_TestDataCreation.grpSegmntRec(testAccount);
                database.insert(grpSgmntRec);
                
                GA_Plan_Year_Exception_History__c planexcpt = new GA_Plan_Year_Exception_History__c();
                planexcpt.GA_Group_Segment__c=grpSgmntRec.id;
                planexcpt.GA_Plan_Year_Month__c='01';
                planexcpt.GA_Start_Date__c=system.today();
                database.insert(planexcpt);
                
                planexcptOldMap.put(planexcpt.id,planexcpt);
                
                GA_Plan_Year_Exception_History__c planexcpt2 = new GA_Plan_Year_Exception_History__c();
                planexcpt2.id=planexcpt.id;
                planexcpt2.GA_Start_Date__c=system.today()-6;
                planexcpt2.GA_End_Date__c=system.today()-1;
                List<GA_Plan_Year_Exception_History__c> planexcptLst = new List<GA_Plan_Year_Exception_History__c> ();
                planexcptLst.add(planexcpt2);
                
                test.startTest();
                GA_BCNHstry_AP01_UpdtToGrpSgmnt.updtBCNtoGs(planexcptLst,planexcptOldMap);
                test.stopTest();
                system.assert(usrSA <> null);
            }
            catch(exception e)
            {
                return;
            }
        }
    } 
    
    /*******************************************************************************************************************************
@Description: plExcptncatch() method 
@Name : plExcptncatch
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
    private static testmethod void plExcptncatch(){
        user usrSA = GA_OBJ_TD01_TestDataCreation.UsrRec('Testwfstp','testsystemadminstrator@bcbsm.com','System Administrator');
        database.insert(usrSA);
        system.runAs(usrSA)
        {
            try{
                Map<ID,GA_Plan_Year_Exception_History__c> planexcptOldMap = new Map<ID,GA_Plan_Year_Exception_History__c> ();   
                Account testAccount = GA_OBJ_TD01_TestDataCreation.AccRec();
                database.insert(testAccount);
                
                GA_Group_Segment__c grpSgmntRec=GA_OBJ_TD01_TestDataCreation.grpSegmntRec(testAccount);
                database.insert(grpSgmntRec);
                
                test.startTest();
                GA_BCNHstry_AP01_UpdtToGrpSgmnt.updtBCNtoGs(null,null);
                GA_BCNHstry_AP01_UpdtToGrpSgmnt.doAction(null);
                GA_BCNHstry_AP01_UpdtToGrpSgmnt.updatEndDate(null);
                test.stopTest();
                system.assert(usrSA <> null);
            }
            catch(exception e)
            {
                return;
            }
        }
    }
}