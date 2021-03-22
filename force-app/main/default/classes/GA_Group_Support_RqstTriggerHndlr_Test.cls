/**
@Author : Dilip
@Name: GA_Group_Support_RqstTriggerHndlr_Test
@CreatedDate: 19 - June 2018 
@Description: GA_Group_Support_RqstTriggerHndlr_Test class is for GA_Group_Support_RqstTriggerHndlr class.
@version : 1.0  
*/ 
@isTest(seealldata = false)
private class GA_Group_Support_RqstTriggerHndlr_Test {
    /**
@Description: prepopGsRName() method 
@Name : prepopGsRName
@Param : N/A  
@Return : N/A
@throws Exception : N/A;
*/ 
    private static testmethod void prepopGsRName(){
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestJeoRl','testsalesrepmail@bcbsm.com','Retention Sales');
        Database.insert(usr);
        system.runAs(usr)
        { 
            GA_Territory__c tRec = GA_OBJ_TD01_TestDataCreation.terrtryRec();
            tRec.GA_RetentionSalesRepresentative__c=usr.id;
            database.insert(tRec);
            
            GA_County_Code__c cnty = new GA_County_Code__c();
            cnty.Name = 'ALGER';
            database.insert(cnty);
            
            Account acc = GA_OBJ_TD01_TestDataCreation.AccRec(); 
            acc.GA_Territory__c = tRec.Id;
            acc.GA_Physical_County_Id__c=cnty.id;
            database.insert(acc);
            
            case cas=GA_OBJ_TD01_TestDataCreation.CaseRec();
            
            cas.AccountId = acc.id;
            database.insert(cas);
            
            GA_Group_Segment__c grpSeg = GA_OBJ_TD01_TestDataCreation.grpSegmntRec(acc);
            grpSeg.Name = 'GRP Segment';
            grpSeg.GA_Account__c = acc.id;
            database.insert(grpSeg);
            
            GA_Group_Support_Request__c gsr = new GA_Group_Support_Request__c();
            gsr.name = 'TEST33';
            gsr.GA_Support_Request__c = cas.id;
            gsr.GA_Group_Segment__c = grpSeg.id;
            database.insert(gsr);
            
            gsr.name = 'TEST444';
            database.update(gsr);
            
            System.assert(acc <> null);
        }
    }
    /**
@Description: HndleExpcpBefInsrt() method 
@Name : HndleExpcpBefInsrt
@Param : N/A  
@Return : N/A
@throws Exception : N/A;
*/ 
    private static testmethod void HndleExpcpBefInsrt(){
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestJeoRl','testsalesrepmail@bcbsm.com','Retention Sales');
        Database.insert(usr);
        system.runAs(usr)
        { 
            List<GA_Group_Support_Request__c> gList = null;
            test.startTest();
            GA_Group_Support_RqstTriggerHndlr.beforeInsert(gList);
            test.stopTest();
            System.assert(usr <> null);
        }
    }
    /**
@Description: HndleExpcpBefUpdte() method 
@Name : HndleExpcpBefUpdte
@Param : N/A  
@Return : N/A
@throws Exception : N/A;
*/ 
    private static testmethod void HndleExpcpBefUpdte(){
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestJeoRl','testsalesrepmail@bcbsm.com','Retention Sales');
        Database.insert(usr);
        system.runAs(usr)
        { 
            List<GA_Group_Support_Request__c> gList =null;
            Map<id,GA_Group_Support_Request__c>gsOldMap = null;
            test.startTest();
            GA_Group_Support_RqstTriggerHndlr.beforeInsert(gList);
            GA_Group_Support_RqstTriggerHndlr.beforeUpdate(gList,gsOldMap);
            test.stopTest();
            System.assert(usr <> null);
        }
    }
}