global class GA_UpdateUnlockBatch implements Database.Batchable<sObject> {
    global static final string ystrdy=string.valueof(Datetime.now()-1);
    global static Date myDate = date.today()-1;
    global static final string ProspectRecType = 'Account - Prospect';
    global static Id ProspectRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(ProspectRecType).getRecordTypeId();
    global static final string CustomerRecType = 'Account - Customer';
    global static Id CustomerRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(CustomerRecType).getRecordTypeId();
    global static final string queryString = 'select id,LastModifiedBy.Name from account where GA_system_of_Record__c=\'Salesforce\' and (recordtypeId=:CustomerRecordTypeId OR recordtypeId=:ProspectRecordTypeId)';
    //global static final string queryString = 'select id,LastModifiedBy.Name from account where GA_system_of_Record__c=\'Salesforce\' and (recordtypeId=:CustomerRecordTypeId OR recordtypeId=:ProspectRecordTypeId) and LastModifiedDate=:myDate';
    
    /*method to start batch*/
    global Database.QueryLocator start(Database.BatchableContext bc)
    {
        String query= queryString;
        return Database.getQueryLocator(query); 
    }
    /*method to execute batch*/
    global void execute(Database.BatchableContext bc, List<account> scope)
    {
        list<account> accLsttoUnlock=new list<account>();
        for(account acc:scope)
        {
            if(approval.isLocked(acc.Id))
            {
                accLsttoUnlock.add(acc);
            }
        }
        GA_Util_lockRecords.unlockRecords(accLsttoUnlock,'Account');

    }
    /*method to execute post batch finishes*/
    global void finish(Database.BatchableContext bc)
    {
        
    }
}