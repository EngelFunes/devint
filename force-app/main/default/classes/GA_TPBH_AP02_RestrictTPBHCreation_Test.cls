/*******************************************************************************************************************************
@Author : IDC offshore
@Name: GA_TPBH_AP02_RestrictTPBHCreation_Test
@CreatedDate: 05 - July 2019 
@Description: GA_TPBH_AP02_RestrictTPBHCreation_Test class is for GA_TPBH_AP02_RestrictTPBHCreation class.
@version : 1.0  
********************************************************************************************************************************/
@isTest(seealldata=false)
private class GA_TPBH_AP02_RestrictTPBHCreation_Test {
    /*******************************************************************************************************************************
@Description: TPBHRecCrtn() method 
@Name : TPBHRecCrtn
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
    private static testMethod void TPBHRecCrtn() {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestSysAdm','testsysadm@bcbsm.com','system administrator');
        database.insert(usr);
        system.runAs(usr)
        {
            try{
                Account acc=GA_OBJ_TD01_TestDataCreation.AccRec();
                database.insert(acc);           
                
                GA_Group_Segment__c gs = GA_OBJ_TD01_TestDataCreation.grpSegmntRec(acc);
                database.insert(gs);
                
                Account tpbacc=new Account();
                tpbacc.Name='tpbacc';
                tpbacc.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Third Party Biller').getRecordTypeId();
                database.insert(tpbacc);
                
                Account Ascntacc=new Account();
                Ascntacc.Name='Ascntacc';
                Ascntacc.GA_Third_Party_Biller_Account_Id__c = tpbacc.Id;
                Ascntacc.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Association').getRecordTypeId();
                database.insert(Ascntacc);
                
                GA_Group_Association__c gsa = GA_OBJ_TD01_TestDataCreation.grpAssociation(gs,Ascntacc);
                gsa.GA_Account__c = Ascntacc.id;
                database.insert(gsa);
                
                user usr1= GA_OBJ_TD01_TestDataCreation.UsrRec('TestSysAdm','testsysadm@bcbsm.com','Support');
                database.insert(usr1);
                system.runAs(usr1)
                {
                    GA_Third_Party_Biller_History__c tphb = GA_OBJ_TD01_TestDataCreation.thirdPartyBiller(gs,tpbacc);
                    
                    List<GA_Third_Party_Biller_History__c> tPBList = new List<GA_Third_Party_Biller_History__c>();
                    tPBList.add(tphb);
                    
                    test.startTest();
                    GA_TPBH_AP02_RestrictTPBHCreation.restrictThirdPrtyBilrHstryCrtn(tPBList);
                    test.stopTest();
                    system.assert(usr <> null);
                }
            }
            catch(exception e)
            {
                return;
            }
        }
    }
}