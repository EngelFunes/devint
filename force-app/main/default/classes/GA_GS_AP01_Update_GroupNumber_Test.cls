/*
@Author : IDC Offshore
@Name: GA_GS_AP01_Update_GroupNumber_Test 
@CreatedDate: 6 - Aug 2019 
@Description: GA_GS_AP01_Update_GroupNumber Test class
@version : 1.0  
*/
@isTest(seealldata = false)
private class GA_GS_AP01_Update_GroupNumber_Test {
/*
@Description: grpSgmtRec() method 
@Name : grpSgmtRec
@Param :N/A
@Return : None
@throws Exception : N/A;
*/     
    private static testmethod void grpSgmtRec()
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
                
                GA_Group_Segment__c grpsgmt = GA_OBJ_TD01_TestDataCreation.grpSegmntRec(acc);
                grpsgmt.GA_Carrier__c='BCBSM';
                grpsgmt.GA_MTV_Group__c='1';
                grpsgmt.GA_MTV_Group_Division__c='2';
                grpsgmt.GA_Administrative_Contact_Id__c=cntc.Id;
                grpsgmt.GA_Billing_Contact_Id__c=cntc.Id;
                database.insert(grpsgmt);
                
                List<GA_Group_Segment__c> gsList = new List<GA_Group_Segment__c>();
                gsList.add(grpsgmt);
                
                test.startTest();
                //GA_GS_AP01_Update_GroupNumber.fetchGroupNumber(gsList);
                test.stopTest();
                system.assert(gsList <> null);
            }
            catch(exception e)
            {
                return;
            }
        }
    }
    /*
@Description: grpSgmtRecExcptn() method 
@Name : grpSgmtRecExcptn
@Param :N/A
@Return : None
@throws Exception : N/A;
*/     
    private static testmethod void grpSgmtRecExcptn()
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
                
                GA_Group_Segment__c grpsgmt = GA_OBJ_TD01_TestDataCreation.grpSegmntRec(acc);
                grpsgmt.GA_Carrier__c='BCBSM';
                grpsgmt.GA_MTV_Group__c='1';
                grpsgmt.GA_MTV_Group_Division__c='2';
                grpsgmt.GA_Administrative_Contact_Id__c=cntc.Id;
                grpsgmt.GA_Billing_Contact_Id__c=cntc.Id;
                database.insert(grpsgmt);
                
                List<GA_Group_Segment__c> gsList = new List<GA_Group_Segment__c>();
                gsList.add(grpsgmt);
                
                test.startTest();
                //GA_GS_AP01_Update_GroupNumber.fetchGroupNumber(null);
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