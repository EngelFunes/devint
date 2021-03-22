@isTest
public class UnlockRecordBatchJobTest {
    public static testmethod void mymethod()
    {
        string customerRecType = 'Account - Customer';
        Id customerRecTypeid = Schema.SObjectType.Account.getRecordTypeInfosByName().get(customerRecType).getRecordTypeId();
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestJeoRl','testsalesrepmail@bcbsm.com','Integration User');
        insert usr;
        system.runAs(usr)
        {
            try{
                Account custaccnt = GA_OBJ_TD01_TestDataCreation.AccRec();
                custaccnt.RecordTypeId = customerRecTypeid;
                insert custaccnt;
                
                Contact cont = new Contact();
                cont.FirstName='Test';
                cont.LastName='Test';
                cont.Accountid= custaccnt.id;
                insert cont;

                List<Contact> conts = [SELECT Id FROM Contact where Account.RecordType.Name = 'Account - Customer' and id =: cont.id ];
                Approval.LockResult[] lrList = Approval.lock(conts, false);

                UnlockRecordBatchJob obj = new UnlockRecordBatchJob();
                DataBase.executeBatch(obj);

            }
            catch(exception e)
            {
                return;
            }
        }
    }
}