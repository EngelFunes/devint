/*****************************************************************************************
Class Name   : GA_Plan_PackageTrgrhndlr_Test
Date Created : 10/05/2017
Created By   : IDC Offshore
Description  : 1. This is test class is for GA_Plan_PackageTrgr_Test
******************************************************************************************/
@isTest(seealldata = false)
private class GA_Plan_PackageTrgrhndlr_Test {
    
    private testmethod static void  testMethod1()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestJeoRl','testsalesrepmail@bcbsm.com','System Administrator');
        Database.insert(usr);
        
        system.runAs(usr)
        {
            Account acc1 = GA_OBJ_TD01_TestDataCreation.AccRec();
            database.insert(acc1);
            
            GA_Group_Segment__c gsmt = GA_OBJ_TD01_TestDataCreation.grpSegmntRec(acc1);
            gsmt.Name = '00003_002';
            gsmt.GA_Account__c = acc1.id;
            
            database.insert(gsmt);
            
            GA_Plan_Package__c plnPkg = GA_OBJ_TD01_TestDataCreation.planPkgRec(gsmt);
            plnPkg.GA_Group_Segment__c=gsmt.Id;
            
            test.startTest();
            database.insert(plnPkg);
            plnPkg.GA_Coverage_Begin_Date__c=system.today();
            database.update(plnPkg);
            test.stopTest();
            //task tskQRec=[select id,GA_Call_Category__c from task where id=:tskRec.id limit 1];
            system.assert(plnPkg <> null,true);
        }
        
    }
    
    private static testmethod void HndleExpcpBefUpdte(){
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestJeoRl','testsalesrepmail@bcbsm.com','System Administrator');
        Database.insert(usr);
        system.runAs(usr)
        { 
            test.startTest();
            GA_Plan_PackageTrgrhndlr.afterinsert(null);
            GA_Plan_PackageTrgrhndlr.afterupdate(null,null);
            test.stopTest();
        }
    }
    
}