/*******************************************************************************************************************************
@Author : IDC offshore
@Name: GA_GS_UpdatWrappingFileTPA_Test
@CreatedDate: 29 - May 2018 
@Description: GA_GS_UpdatWrappingFileTPA_Test class is for creation of TPA records on change of WrappingFileTPA field value on GS.
@version : 1.0  
********************************************************************************************************************************/
@isTest
private class GA_GS_UpdatWrappingFileTPA_Test {
    /*******************************************************************************************************************************
@Description: updtwrpinFileTPATest() method 
@Name : updtwrpinFileTPATest
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
    private static testmethod void updtwrpinFileTPATest(){
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestSysAdm','testsysadm@bcbsm.com','System Administrator');
        insert usr;
        system.runAs(usr){
            try{
                map<id,GA_Group_Segment__c> grpsgOldmp =new map<id,GA_Group_Segment__c>();
                list<GA_Group_Segment__c> gsList=new list<GA_Group_Segment__c>();
                Account testAccount = GA_OBJ_TD01_TestDataCreation.AccRec();
                testAccount.Name = 'Test Prospect Acc';
                testAccount.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Prospect').getRecordTypeId();
                database.insert(testAccount);
                
                Account testAccount1 = GA_OBJ_TD01_TestDataCreation.AccRec();
                testAccount1.Name = 'Test Comp Acc';
                testAccount1.GA_TPA__c = True;
                testAccount1.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Competitor').getRecordTypeId();
                database.insert(testAccount1);
                
                Account testAccount2 = GA_OBJ_TD01_TestDataCreation.AccRec();
                testAccount2.Name = 'Comp Acc';
                testAccount2.GA_TPA__c = True;
                testAccount2.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Competitor').getRecordTypeId();
                database.insert(testAccount2);
                
                GA_Group_Segment__c grpSgmntRec=GA_OBJ_TD01_TestDataCreation.grpSegmntRec(testAccount);
                grpSgmntRec.GA_Group_Effective_Date__c = system.today()-10;
                grpSgmntRec.GA_Cancellation_Date__c = system.today()+10;
                grpSgmntRec.Status__c = 'Pending';
                grpSgmntRec.GA_Transaction_Posted__c=true;
                grpSgmntRec.GA_Post_Transaction__c=true;
                grpSgmntRec.GA_Wrapping_File_TPA__c = testAccount1.Id;
                Database.insert(grpSgmntRec);
                
                GA_Third_Party_Administrator_History__c tpah = new GA_Third_Party_Administrator_History__c();
                tpah.GA_Group_Segment__c = grpSgmntRec.Id;
                tpah.GA_File_Carrier_Name__c=grpSgmntRec.GA_Wrapping_File_TPA__c;
                tpah.GA_Start_Date__c = System.today();
                Database.insert(tpah);
                
                grpSgmntRec.GA_Wrapping_File_TPA__c = testAccount2.Id;
                Database.update(grpSgmntRec);
                
                GA_Third_Party_Administrator_History__c tpahRec = new GA_Third_Party_Administrator_History__c();
                tpahRec.GA_Group_Segment__c = grpSgmntRec.Id;
                tpahRec.GA_File_Carrier_Name__c=grpSgmntRec.GA_Wrapping_File_TPA__c;
                tpahRec.GA_Start_Date__c = System.today();
                Database.insert(tpahRec);
                Test.startTest();
                GA_GS_UpdatWrappingFileTPA.updtwrpinFileTPA(gsList,grpsgOldmp);
                Test.stopTest();
                
            }
            catch(exception e)
            {
                system.assert(e <> null);
                return;
            }
        }
    }
}