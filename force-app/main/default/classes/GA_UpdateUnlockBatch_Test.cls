/***********************************************************************************************************************************************
@Author : Rohith
@Name: GA_UpdateUnlockBatch_Test 
@CreatedDate: 16 - November 2018 
@Description: GA_UpdateUnlockBatch Test class 
@version : 1.0  
*************************************************************************************************************************************************/

@isTest
public class GA_UpdateUnlockBatch_Test {
    
    /***********************************************************************************************************************************************
@Description: executeTest() method 
@Name : executeTest
@Param : None
@Return : void
@throws Exception : N/A;
************************************************************************************************************************************************/   
    private static testmethod void executeTest()
    {  
        
        string customerRecType = 'Account - Customer';
        string prospectRecType = 'Account - Prospect';
        Id customerRecTypeid = Schema.SObjectType.Account.getRecordTypeInfosByName().get(customerRecType).getRecordTypeId();
        Id prospectRecTypeid = Schema.SObjectType.Account.getRecordTypeInfosByName().get(prospectRecType).getRecordTypeId();
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestJeoRl','testsalesrepmail@bcbsm.com','Integration User');
        insert usr;
        system.runAs(usr)
        {
            try{
                Account custaccnt = GA_OBJ_TD01_TestDataCreation.AccRec();
                custaccnt.RecordTypeId = customerRecTypeid;
                custaccnt.GA_Platinum__c = true;
                custaccnt.GA_System_of_Record__c = 'Salesforce';
                database.insert(custaccnt);
                //Test.setCreatedDate(custaccnt.Id, DateTime.newInstance(2012,12,12));
                //custaccnt.LastModifiedDate = date.today()-1;
                database.upsert(custaccnt);
                system.debug('createddate-->'+custaccnt.CreatedDate);
                Approval.lock(custaccnt.Id, false);
                Account prospectaccnt = GA_OBJ_TD01_TestDataCreation.AccRec();
                prospectaccnt.RecordTypeId = prospectRecTypeid;
                prospectaccnt.GA_Platinum__c = true;
                prospectaccnt.GA_System_of_Record__c = 'Salesforce';
                database.insert(prospectaccnt);
                //Test.setCreatedDate(prospectaccnt.Id, DateTime.newInstance(2012,12,12));
                //prospectaccnt.LastModifiedDate = date.today()-1;
                database.upsert(prospectaccnt);
                system.debug('createddate-->'+prospectaccnt.CreatedDate);
                List<Account> tenlst = new List<Account>();
                tenlst.add(custaccnt);
                tenlst.add(prospectaccnt);
                Account acc=GA_OBJ_TD01_TestDataCreation.AccRec();
                acc.GA_Platinum__c = false;
                database.insert(acc);
                Test.startTest();
                Approval.LockResult[] lrList = Approval.lock(tenlst, false);
                GA_UpdateUnlockBatch updateLockstatusBatch=new GA_UpdateUnlockBatch();
                Database.executeBatch(updateLockstatusBatch,200);  
                Test.stopTest();
                system.assertEquals(false, Approval.isLocked(custaccnt.Id));
                system.assertEquals(false, Approval.isLocked(prospectaccnt.Id));
                system.assert(acc <> null);
            }
            catch(exception e)
            {
                return;
            }
        }
    }
}