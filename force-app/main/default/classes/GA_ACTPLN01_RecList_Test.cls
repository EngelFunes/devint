/*
@Author : Prasant Kumar Satpathy
@Name: GA_ACTPLN01_RecList_Test
@CreatedDate: 24- Jul 2017 
@Description: GA_ACTPLN01_RecList Test class
@version : 1.0  
*/
@isTest
private class GA_ACTPLN01_RecList_Test {
    /**
@Description: actionPln() method 
@Name : actionPln
@Param : N/A   
@Return : void
@throws Exception : N/A;
*/     
    private static testmethod void actionPln()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestJeoRl','testsalesrepmail@bcbsm.com','Support');
        insert usr;
        system.runAs(usr)
        {
            Account acc=GA_OBJ_TD01_TestDataCreation.AccRec();
            insert acc;
            ActionPlanTemplate__c acpPlnTmp=GA_OBJ_TD01_TestDataCreation.actionPlanTmpRec('Resell - Test Rec Template','Test Desc Resell template');
            insert acpPlnTmp;
            ActionPlan__c acpPln=GA_OBJ_TD01_TestDataCreation.actionPlanRec('Resell - Test Rec','Test Desc Resell');
            acpPln.Account__c=acc.id;
            acpPln.Action_Plan_Template__c=acpPlnTmp.id;
            insert acpPln;
            test.startTest();
            List<ActionPlan__c> actpnlst=GA_ACTPLN01_RecList.actnplnLst(acc.id,'Resell -%');        
            test.stopTest();
            system.assert(actpnlst.size()>0);
        }
    }
    
    /**
@Description: actionPlnExcep() method 
@Name : actionPlnExcep
@Param : N/A   
@Return : void
@throws Exception : N/A;
*/     
    private static testmethod void actionPlnExcep()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestJeoRl','testsalesrepmail@bcbsm.com','Support');
        insert usr;
        system.runAs(usr)
        {
            Account acc=GA_OBJ_TD01_TestDataCreation.AccRec();
            insert acc;
            ActionPlanTemplate__c acpPlnTmp=GA_OBJ_TD01_TestDataCreation.actionPlanTmpRec('Resell - Test Rec Template','Test Desc Resell template');
            insert acpPlnTmp;
            ActionPlan__c acpPln=GA_OBJ_TD01_TestDataCreation.actionPlanRec('Resell - Test Rec','Test Desc Resell');
            acpPln.Account__c=acc.id;
            acpPln.Action_Plan_Template__c=acpPlnTmp.id;
            insert acpPln;
            test.startTest();
            try{
                List<ActionPlan__c> actpnlst=GA_ACTPLN01_RecList.actnplnLst('','');    
            }
            catch(exception e)
            {
                return;
            }
            
            test.stopTest();
            
        }
    }
    /**
@Description: actionPlnTmplt() method 
@Name : actionPlnTmplt
@Param : N/A   
@Return : void
@throws Exception : N/A;
*/      
    private static testmethod void actionPlnTmplt()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestJeoRl','testsalesrepmail@bcbsm.com','Support');
        insert usr;
        system.runAs(usr)
        {
            Account acc=GA_OBJ_TD01_TestDataCreation.AccRec();
            insert acc;
            ActionPlanTemplate__c acpPlnTmp=GA_OBJ_TD01_TestDataCreation.actionPlanTmpRec('Resell - Test Rec Template','Test Desc Resell template');
            insert acpPlnTmp;
            test.startTest();
            List<GA_ACTPLN01_RecList.ActionPlanTmpWrapCls> actpnTmplst=GA_ACTPLN01_RecList.actnplnTmpLst('Resell -%',acc.id);
            test.stopTest();
            system.assert(actpnTmplst.size()>0);
        }
    }
    
    /**
@Description: actionPlnTmpltExcep() method 
@Name : actionPlnTmpltExcep
@Param : N/A   
@Return : void
@throws Exception : N/A;
*/      
    private static testmethod void actionPlnTmpltExcep()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestJeoRl','testsalesrepmail@bcbsm.com','Support');
        insert usr;
        system.runAs(usr)
        {
            Account acc=GA_OBJ_TD01_TestDataCreation.AccRec();
            insert acc;
            ActionPlanTemplate__c acpPlnTmp=GA_OBJ_TD01_TestDataCreation.actionPlanTmpRec('Resell - Test Rec Template','Test Desc Resell template');
            insert acpPlnTmp;
            test.startTest();
            try{
                List<GA_ACTPLN01_RecList.ActionPlanTmpWrapCls> actpnTmplst=GA_ACTPLN01_RecList.actnplnTmpLst('','');  
            }
            catch(exception e)
            {
                return;
            }
            test.stopTest();
            
        }
    }
}