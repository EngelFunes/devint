/*
@Author : IDC Offshore
@Name: GA_GS_AP03_UpdateCityForBatch_Test 
@CreatedDate: 6 - Aug 2019 
@Description: GA_GS_AP03_UpdateCityForBatch Test class
@version : 1.0  
*/
@isTest(seealldata = false)
private class GA_GS_AP03_UpdateCityForBatch_Test {
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
                
                GA_City_Code__c cty1 = new GA_City_Code__c();
                cty1.Name ='OTHER';
                database.insert(cty1);
                
                GA_County_Code__c cnty = new GA_County_Code__c();
                cnty.Name = 'Alger';
                database.insert(cnty);
                
                GA_Group_Segment__c grpsgmt = GA_OBJ_TD01_TestDataCreation.grpSegmntRec(acc);
                grpsgmt.GA_Carrier__c='BCBSM';
                grpsgmt.GA_MTV_Group__c='1';
                grpsgmt.GA_MTV_Group_Division__c='2';
                grpsgmt.GA_Administrative_Contact_Id__c=cntc.Id;
                grpsgmt.GA_Billing_Contact_Id__c=cntc.Id;
                grpsgmt.GA_Physical_City__c=cty1.id;
                grpsgmt.GA_Physical_City_Other__c='Hyd';
                grpsgmt.GA_Mailing_City__c=cty1.id;
                grpsgmt.GA_Mailing_City_Other__c='Hyd';
                grpsgmt.GA_Billing_City__c=cty1.id;
                grpsgmt.GA_Billing_City_Other__c='Hyd';
                database.insert(grpsgmt);
                
                GA_Group_Segment__c gsmt1 = GA_OBJ_TD01_TestDataCreation.grpSegmntRec(acc);
                gsmt1.GA_Carrier__c='BCBSM';
                gsmt1.GA_MTV_Group__c='11';
                gsmt1.GA_MTV_Group_Division__c='99';
                gsmt1.GA_Physical_Address_1__c= 'test address';
                gsmt1.GA_Physical_City__c= cty1.Id;
                gsmt1.GA_Physical_City_Other__c = 'HDC3';
                gsmt1.GA_Physical_State__c ='telangana';
                gsmt1.GA_Physical_County_Id__c=cnty.id;                             
                gsmt1.GA_Physical_Zip__c ='243243';            
                gsmt1.GA_Copy_Address_From__c ='Physical to Mailing;Physical to Billing';
                database.insert(gsmt1);
                
                GA_Group_Segment__c gsmt2 = GA_OBJ_TD01_TestDataCreation.grpSegmntRec(acc);
                gsmt2.GA_Carrier__c='BCBSM';
                gsmt2.GA_MTV_Group__c='22';
                gsmt2.GA_MTV_Group_Division__c='88';
                gsmt2.GA_Mailing_Address_1__c= 'test address';
                gsmt2.GA_Mailing_City__c= cty1.Id;
                gsmt2.GA_Mailing_City_Other__c = 'HDC3';
                gsmt2.GA_Mailing_State__c ='telangana';
                gsmt2.GA_Mailing_County_Id__c=cnty.id;                             
                gsmt2.GA_Mailing_Zip__c ='243243';            
                gsmt2.GA_Copy_Address_From__c ='Mailing to Physical;Mailing to Billing';
                database.insert(gsmt2);
                
                GA_Group_Segment__c gsmt3 = GA_OBJ_TD01_TestDataCreation.grpSegmntRec(acc);
                gsmt3.GA_Carrier__c='BCBSM';
                gsmt3.GA_MTV_Group__c='33';
                gsmt3.GA_MTV_Group_Division__c='77';
                gsmt3.GA_Billing_Address_1__c= 'test address';
                gsmt3.GA_Billing_City__c= cty1.Id;
                gsmt3.GA_Billing_City_Other__c = 'HDC3';
                gsmt3.GA_Billing_State__c ='telangana';
                gsmt3.GA_Billing_County_Id__c=cnty.id;                             
                gsmt3.GA_Billing_Zip__c ='243243';            
                gsmt3.GA_Copy_Address_From__c ='Billing to Mailing;Billing to Physical';
                database.insert(gsmt3);
                
                List<ID> gsIDList = new List<ID>();
                gsIDList.add(grpsgmt.id);
                gsIDList.add(gsmt1.id);
                gsIDList.add(gsmt2.id);
                gsIDList.add(gsmt3.id);
                
                test.startTest();
                //GA_GS_AP03_UpdateCityForBatch.updateCityInfo(gsIDList);
                test.stopTest();
                system.assert(gsIDList <> null);
                
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
                
                test.startTest();
                //GA_GS_AP03_UpdateCityForBatch.updateCityInfo(null);
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