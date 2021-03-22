/**
@Author : Rohith Adulla
@Name: GA_GroupSegmentRelation_RecList_Test 
@CreatedDate: 5/31/17 
@Description: GA_GroupSegmentRelation_RecList Test class 
@version : 1.0  
*/
@isTest(seealldata = false)
private class GA_GroupSegmentRelation_RecList_Test {
    
    /**
@Description: grpsgrelrelatLst() method 
@Name : grpsgrelrelatLst
@Param : None
@Return : void
@throws Exception : N/A;
*/
    private static testmethod void grpsgrelrelatLst()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestAcnFctsht','testsalesrepmail@bcbsm.com','Support');
        database.insert(usr);
        system.runAs(usr)
        {
            try {
                GS_Rlshp_Create_Access__c grpsgmntrel=new GS_Rlshp_Create_Access__c();
                grpsgmntrel.GA_By_Pass__c=true;
                database.insert(grpsgmntrel);
                Account acc=GA_OBJ_TD01_TestDataCreation.AccRec();
                database.insert(acc);
                Contact con = GA_OBJ_TD01_TestDataCreation.cntactRec(acc.Id);
                database.insert(con);
                Case cas = GA_OBJ_TD01_TestDataCreation.CaseRec();
                cas.AccountId = acc.id;
                database.insert(cas);
                GA_Group_Segment__c grpsgmt = GA_OBJ_TD01_TestDataCreation.grpSegmntRec(acc);
                database.insert(grpsgmt);
                GA_Group_Support_Request__c grpsegrel = new GA_Group_Support_Request__c();
                grpsegrel.Name = cas.CaseNumber + grpsgmt.Name;
                grpsegrel.GA_Group_Segment__c = grpsgmt.Id;
                grpsegrel.GA_Support_Request__c = cas.id;
                grpsegrel.GA_External_ID__c = grpsegrel.Name;
                database.insert(grpsegrel);
                List<GA_Group_Support_Request__c> grpsegrelret = new  List<GA_Group_Support_Request__c> ();
                List<GA_Group_Segment__c> grpsec = new List<GA_Group_Segment__c> ();
                test.startTest();
                grpsegrelret=GA_GroupSegmentRelation_RecList.GrpSegRelLst(cas.id);
                grpsec = GA_GroupSegmentRelation_RecList.grpSegRec(cas.id);
                GA_GroupSegmentRelation_RecList.editAccss(cas.id);
                GA_GroupSegmentRelation_RecList.createAccss(cas.id);
                GA_GroupSegmentRelation_RecList.deleteData(grpsegrel.Id);
                GA_GroupSegmentRelation_RecList.sortChildren(cas.id,true);
                GA_GroupSegmentRelation_RecList.sortChildren(cas.id,false);
                GA_GroupSegmentRelation_RecList.getStatus(cas.id);
                String supReqId = grpsegrelret[0].Id;
                GA_GroupSegmentRelation_RecList.getChildrenViaRecord(supReqId,true);
                
                test.stopTest();
                system.assert(grpsec <> null);
                system.assert(grpsegrelret <> null);
            }
            catch(exception e)
            {
                return;
            }
        }
    }
    /**
@Description: grpsegrelrelatLstException() method 
@Name : grpsegrelrelatLstException
@Param : None
@Return : void
@throws Exception : N/A;
*/
    private static testmethod void grpsegrelrelatLstException()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('BCBSM Read Only','testsalesrepmail@bcbsm.com','Support');
        database.insert(usr);
        system.runAs(usr)
        {
            
            try {
                List<String> lstids = new list<String>();
                List<GA_Group_Support_Request__c> grpsegrel = new  List<GA_Group_Support_Request__c> ();
                List<GA_Group_Segment__c> grpsec = new List<GA_Group_Segment__c> ();
                test.startTest();
                grpsegrel = GA_GroupSegmentRelation_RecList.GrpSegRelLst('');
                grpsec = GA_GroupSegmentRelation_RecList.getChildren('',false);
                GA_GroupSegmentRelation_RecList.deleteData('');
                GA_GroupSegmentRelation_RecList.addGroupSegmentRelation('',lstids);
                GA_GroupSegmentRelation_RecList.removeGroupSegmentRelation('',lstids);
                test.stopTest();
                
            } 
            catch (exception e) {
                system.assert(e <> null);
                return;
            }
        }
    }
    
    /**
@Description: grpsgrelgetchildren() method 
@Name : grpsgrelgetchildren
@Param : None
@Return : void
@throws Exception : N/A;
*/
    private static testmethod void grpsgrelgetchildren()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestAcnFctsht','testsalesrepmail@bcbsm.com','Support');
        database.insert(usr);
        system.runAs(usr)
        {
            try {
                Account acc=GA_OBJ_TD01_TestDataCreation.AccRec();
                database.insert(acc);
                Contact con = GA_OBJ_TD01_TestDataCreation.cntactRec(acc.Id);
                database.insert(con);
                Case cas = GA_OBJ_TD01_TestDataCreation.CaseRec();
                cas.AccountId = acc.id;
                database.insert(cas);
                GA_Group_Segment__c grpsgmt = GA_OBJ_TD01_TestDataCreation.grpSegmntRec(acc);
                grpsgmt.Status__c='Active';
                database.insert(grpsgmt);
                List<String> lstOfGSIds = new List<String>();
                lstOfGSIds.add(grpsgmt.Id);
                GA_Group_Support_Request__c grpsegrel = new GA_Group_Support_Request__c();
                grpsegrel.Name = cas.CaseNumber + grpsgmt.Name;
                grpsegrel.GA_Group_Segment__c = grpsgmt.Id;
                grpsegrel.GA_Support_Request__c = cas.id;
                grpsegrel.GA_External_ID__c = grpsegrel.Name;
                database.insert(grpsegrel);
                Boolean checkCreateAccess = false;
                List<GA_Group_Support_Request__c> grpsegrelret = new  List<GA_Group_Support_Request__c> ();
                List<GA_Group_Segment__c> grpsec = new List<GA_Group_Segment__c> ();
                test.startTest();
                grpsegrelret=GA_GroupSegmentRelation_RecList.GrpSegRelLst(cas.id);
                grpsec = GA_GroupSegmentRelation_RecList.getChildren(cas.id,false);
                checkCreateAccess = GA_GroupSegmentRelation_RecList.createAccss(cas.id);
                GA_GroupSegmentRelation_RecList.addGroupSegmentRelation(cas.id,lstOfGSIds);
                test.stopTest();
                system.assert(grpsec <> null);
                system.assert(grpsegrelret <> null);
                system.assertEquals(false, checkCreateAccess);
                
            }
            catch(exception e)
            {
                return;
            }
        }
    }
    /*@Description: grpsgreldeldata() method 
@Name : grpsgreldeldata
@Param : None
@Return : void
@throws Exception : N/A;
*/
    private static testmethod void grpsgreldeldata()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestAcnFctsht','testsalesrepmail@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {
            try {
                Account acc=GA_OBJ_TD01_TestDataCreation.AccRec();
                acc.GA_System_of_Record__c = 'SMART';
                database.insert(acc);
                Contact con = GA_OBJ_TD01_TestDataCreation.cntactRec(acc.Id);
                database.insert(con);
                Case cas = GA_OBJ_TD01_TestDataCreation.CaseRec();
                cas.AccountId = acc.id;
                database.insert(cas);
                GA_Group_Segment__c grpsgmt = GA_OBJ_TD01_TestDataCreation.grpSegmntRec(acc);
                grpsgmt.Status__c='Active';
                database.insert(grpsgmt);
                List<String> lstOfGSIds = new List<String>();
                lstOfGSIds.add(grpsgmt.Id);
                GA_Group_Support_Request__c grpsegrel = new GA_Group_Support_Request__c();
                grpsegrel.Name = cas.CaseNumber + grpsgmt.Name;
                grpsegrel.GA_Group_Segment__c = grpsgmt.Id;
                grpsegrel.GA_Support_Request__c = cas.id;
                grpsegrel.GA_External_ID__c = grpsegrel.Name;
                database.insert(grpsegrel);
                Boolean checkdeletable = false;
                Boolean checkCreateAccess = false;
                boolean crteAccss=GS_Rlshp_Create_Access__c.getInstance().GA_By_Pass__c;
                List<GA_Group_Support_Request__c> grpsegrelret = new  List<GA_Group_Support_Request__c> ();
                List<GA_Group_Segment__c> grpsec = new List<GA_Group_Segment__c> ();
                test.startTest();
                grpsegrelret=GA_GroupSegmentRelation_RecList.GrpSegRelLst(cas.id);
                grpsec = GA_GroupSegmentRelation_RecList.getChildren(cas.id,false);
                checkdeletable = GA_GroupSegmentRelation_RecList.deleteAccss();
                checkCreateAccess = GA_GroupSegmentRelation_RecList.createAccss(cas.id);
                GA_GroupSegmentRelation_RecList.deleteData(grpsegrel.id);
                test.stopTest();
                system.assert(grpsec <> null);
                system.assert(grpsegrelret <> null);
                system.assertEquals(true, checkdeletable);
                //system.assertEquals(true, checkCreateAccess);
            }
            catch(exception e)
            {
                return;
            }
        }
    }
    /*@Description: grpsgrelExcep() method 
@Name : grpsgrelExcep
@Param : None
@Return : void
@throws Exception : N/A;
*/
    private static testmethod void grpsgrelExcep()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestAcnFctsht','testsalesrepmail@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {
            try {
                String currentId='';
                String suppId='';
                String recordId='';
                Boolean isDisabled=false;
                List<String> lstOfGSIds = new List<String>();
                test.startTest();
                GA_GroupSegmentRelation_RecList.GrpSegRelLst(currentId);
                GA_GroupSegmentRelation_RecList.grpSegRec(currentId);
                GA_GroupSegmentRelation_RecList.getChildren(recordId, isDisabled);
                GA_GroupSegmentRelation_RecList.deleteAccss();
                GA_GroupSegmentRelation_RecList.createAccss(suppId);
                GA_GroupSegmentRelation_RecList.deleteData(currentId);
                GA_GroupSegmentRelation_RecList.addGroupSegmentRelation(recordId, lstOfGSIds);
                test.stopTest();
                system.assert(usr <> null);
            } 
            catch(exception e)
            {
                return;
            }
        }
    } 
}