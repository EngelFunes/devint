/*
@Author : Sri Lakshmi Addula
@Name: GA_GroupSegment01_RecList_Test 
@CreatedDate: 4 - Oct 2018 
@Description: GA_GroupSegment01_RecList Test class
@version : 1.0  
*/
@isTest
private class GA_GroupSegment01_RecList_Test {
    /*
@Description: GrpSgmtrelatLst() method 
@Name : GrpSgmtrelatLst
@Param :N/A
@Return : None
@throws Exception : AuraHandledException;
*/    
    private static testmethod void GrpSgmtrelatLst()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestGrpSgmtrelatLst','testsalesrepmail@bcbsm.com','Support');
        database.insert(usr);
        system.runAs(usr)
        {
            try {
                Account acc=GA_OBJ_TD01_TestDataCreation.AccRec();
                database.insert(acc);
                
                Contact cntc=GA_OBJ_TD01_TestDataCreation.cntactRec(acc.Id);
                database.insert(cntc);
                
                GA_Group_Segment__c gs = GA_OBJ_TD01_TestDataCreation.grpSegmntRec(acc);
                gs.GA_Administrative_Contact_Id__c=cntc.Id;
                gs.GA_Billing_Contact_Id__c=cntc.Id;
                database.insert(gs);
                
                List<GA_Group_Segment__c> gslst= new List<GA_Group_Segment__c>();
                gsLst.add(gs);
                
                List<GA_Group_Segment__c> gslst1= new List<GA_Group_Segment__c>();
                gsLst1.add(gs);
                
                test.startTest();
                List<GA_Group_Segment__c> grpsgmtLst = GA_GroupSegment01_RecList.gSgmtLst(acc.Id);
                GA_GroupSegment01_RecList.actRec(acc.Id);
                GA_GroupSegment01_RecList.CityRec('Hyd');
                boolean creAccCheck = GA_GroupSegment01_RecList.createAccss(acc.Id);
                boolean edtAccCheck = GA_GroupSegment01_RecList.editAccss(gs.Id);
                boolean delAccCheck = GA_GroupSegment01_RecList.deleteAccss(gs.Id);
                GA_GroupSegment01_RecList.deleteData(gs.Id);
                test.stopTest();
                
            }
            catch(exception e)
            {
                return;
            }
        }
    }
    /*
@Description: GrpSgmtrelatLsttSizeExp() method 
@Name : GrpSgmtrelatLsttSizeExp
@Param :N/A
@Return : None
@throws Exception : AuraHandledException;
*/     
    private static testmethod void GrpSgmtrelatLsttSizeExp()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('Testusr','testuser@bcbsm.com','System Administrator');
        database.insert(usr);     
        system.runAs(usr)
        {
            try {
                Account acc=GA_OBJ_TD01_TestDataCreation.AccRec();
                database.insert(acc);
                
                Contact cntc=GA_OBJ_TD01_TestDataCreation.cntactRec(acc.Id);
                database.insert(cntc);
                
                GA_Group_Segment__c gs = GA_OBJ_TD01_TestDataCreation.grpSegmntRec(acc);
                database.insert(gs);
                
                List<GA_Group_Segment__c> gslst= new List<GA_Group_Segment__c>();
                gsLst.add(gs);
                
                List<GA_Group_Segment__c> gslst1= new List<GA_Group_Segment__c>();
                gsLst1.add(gs);
                
                test.startTest();
                List<GA_Group_Segment__c> grpsgmtLst = GA_GroupSegment01_RecList.gSgmtLst(acc.Id);
                GA_GroupSegment01_RecList.actRec(acc.Id);
                GA_GroupSegment01_RecList.CityRec('Delhi');
                boolean creAccCheck = GA_GroupSegment01_RecList.createAccss(acc.Id);
                boolean edtAccCheck = GA_GroupSegment01_RecList.editAccss(gs.Id);
                boolean delAccCheck = GA_AP_ABRRelatLst.deleteAccss(gs.Id);
                GA_GroupSegment01_RecList.deleteData(gs.Id);
                test.stopTest();
                
            }
            catch(exception e)
            {
                return;
            }
        }
    }
}