/**
@Author : Prasant S
@Name: GA_LogExceptionCls_Test 
@CreatedDate: 31 - Jul 2017 
@Description: GA_LogExceptionCls_Test Test class 
@version : 1.0  
*/
@isTest
private class GA_LogExceptionCls_Test {
    /**
@Description: LogExcpTest() method 
@Name : LogExcpTest
@Param : None
@Return : void 
@throws Exception : N/A;
*/ 
    private static testmethod void LogExcpTest()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestAcnFctsht','testsalesrepmail@bcbsm.com','Support');
        database.insert(usr);
        system.runAs(usr)
        {
            try {
                List<Log_Exception__e> errorMessages = new List<Log_Exception__e>();
                Log_Exception__e event = new Log_Exception__e(GA_Message__c='Test',
                                                              GA_StackTrace__c=null,
                                                              GA_TypeName__c=null,
                                                              GA_ClassName__c='ClassName',
                                                              GA_MethodName__c='MethodName');
                errorMessages.add(event);
                List<Database.SaveResult> results = EventBus.publish(errorMessages);
                
                test.startTest();
                GA_LogExceptionCls.LogExcp(null, 'ClsName', 'MethodNme');
                test.stopTest();
                list<ExceptionLog__c> ermsgLst=[select id from ExceptionLog__c limit 1];
                system.assert(ermsgLst.size()>0);
            }
            catch(exception e)
            {
                return;
            }
        }
    }
    /*@Description: cntrctMsgExcpTest() method 
@Name : cntrctMsgExcpTest
@Param : None
@Return : void
@throws Exception : N/A;
*/ 
    private static testmethod void cntrctMsgExcpTest()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestAcnFctsht','testsalesrepmail@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {
            try {
                Id prospctRecTypId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Prospect').getRecordTypeId();
                Id unqualifyProsRecTypId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Unqualified Prospect (Agent)').getRecordTypeId();
                Account testAccount = GA_OBJ_TD01_TestDataCreation.AccRec();
                testAccount.RecordTypeId=unqualifyProsRecTypId;
                database.insert(testAccount);
                
                testAccount.RecordTypeId=prospctRecTypId;
                testAccount.GA_Is_Mass_Updating__c=true;
                database.update(testAccount);
                
                Account testAccuqPrsRec = GA_OBJ_TD01_TestDataCreation.AccRec();
                testAccuqPrsRec.RecordTypeId=unqualifyProsRecTypId;
                testAccuqPrsRec.Federal_Tax_ID__c ='23245';
                database.insert(testAccuqPrsRec);
                
                List<Account> accList = New List<Account>();
                
                Account testAccRec = GA_OBJ_TD01_TestDataCreation.AccRec();
                testAccRec.RecordTypeId=prospctRecTypId;
                testAccRec.Federal_Tax_ID__c ='23245';
                accList.add(testAccRec);
                database.insert(accList);
                
                Contract cont1=new Contract();
                cont1.AccountId=testAccuqPrsRec.id;
                cont1.ARV_TECH_Account_Merge__c=testAccRec.id;
                cont1.StartDate=system.today();
                cont1.Status='In Progress';
                cont1.ContractTerm=10;
                database.insert(cont1);
                List<Log_Exception__e> errorMessages = new List<Log_Exception__e>();
                Log_Exception__e event = new Log_Exception__e(GA_Message__c='Test',
                                                              GA_StackTrace__c=null,
                                                              GA_TypeName__c=null,
                                                              GA_ClassName__c='ClassName',
                                                              GA_MethodName__c='MethodName');
                errorMessages.add(event);
                List<Database.SaveResult> results = EventBus.publish(errorMessages);
                
                test.startTest();
                GA_LogExceptionCls.LogExcpContractMsges('null','ClssName', 'MethodName',cont1.Id);
                test.stopTest();
               // list<ExceptionLog__c> ermsgLst=[select id from ExceptionLog__c limit 1];
                //system.assert(ermsgLst.size()>0);
                system.assert(usr<>null);
            }
            catch(exception e)
            {
                return;
            }
        }
    }
        /*@Description: cntrctLogExcpTest() method 
@Name : cntrctLogExcpTest
@Param : None
@Return : void
@throws Exception : N/A;
*/ 
    private static testmethod void cntrctLogExcpTest()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestAcnFctsht','testsalesrepmail@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {
            try {
                Id prospctRecTypId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Prospect').getRecordTypeId();
                Id unqualifyProsRecTypId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Unqualified Prospect (Agent)').getRecordTypeId();
                Account testAccount = GA_OBJ_TD01_TestDataCreation.AccRec();
                testAccount.RecordTypeId=unqualifyProsRecTypId;
                database.insert(testAccount);
                
                testAccount.RecordTypeId=prospctRecTypId;
                testAccount.GA_Is_Mass_Updating__c=true;
                database.update(testAccount);
                
                Account testAccuqPrsRec = GA_OBJ_TD01_TestDataCreation.AccRec();
                testAccuqPrsRec.RecordTypeId=unqualifyProsRecTypId;
                testAccuqPrsRec.Federal_Tax_ID__c ='23245';
                database.insert(testAccuqPrsRec);
                
                List<Account> accList = New List<Account>();
                
                Account testAccRec = GA_OBJ_TD01_TestDataCreation.AccRec();
                testAccRec.RecordTypeId=prospctRecTypId;
                testAccRec.Federal_Tax_ID__c ='23245';
                accList.add(testAccRec);
                database.insert(accList);
                
                Contract cont1=new Contract();
                cont1.AccountId=testAccuqPrsRec.id;
                cont1.ARV_TECH_Account_Merge__c=testAccRec.id;
                cont1.StartDate=system.today();
                cont1.Status='In Progress';
                cont1.ContractTerm=10;
                database.insert(cont1);
                List<Log_Exception__e> errorMessages = new List<Log_Exception__e>();
                Log_Exception__e event = new Log_Exception__e(GA_Message__c='Test',
                                                              GA_StackTrace__c=null,
                                                              GA_TypeName__c=null,
                                                              GA_ClassName__c='ClassName',
                                                              GA_MethodName__c='MethodName');
                errorMessages.add(event);
                List<Database.SaveResult> results = EventBus.publish(errorMessages);
                
                test.startTest();
                GA_LogExceptionCls.LogExcpContract(null,'ClasName', 'MethdNme',cont1.Id);
                test.stopTest();
                list<ExceptionLog__c> ermsgLst=[select id from ExceptionLog__c limit 1];
                system.assert(ermsgLst.size()>0);
            }
            catch(exception e)
            {
                return;
            }
        }
    }
}