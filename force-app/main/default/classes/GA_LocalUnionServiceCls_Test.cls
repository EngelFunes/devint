/*******************************************************************************************************************************
@Author : IDC offshore
@Name: GA_LocalUnionServiceCls_Test
@CreatedDate: 24 - Feb 2019 
@Description: GA_LocalUnionServiceCls_Test class is for Local Union.
@version : 1.0  
********************************************************************************************************************************/
@isTest(seealldata = false)
private class GA_LocalUnionServiceCls_Test {
    /*******************************************************************************************************************************
@Description: updtThrdPrtyToAccTest() method 
@Name : updtThrdPrtyToAccTest
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/
    private static testmethod void updtThrdPrtyToAccTest(){
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestSysAdm','testsysadm@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr){
            try{
                Account testAccount = GA_OBJ_TD01_TestDataCreation.AccRec();
                testAccount.Name = 'Test Cust Acc';
                testAccount.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Customer').getRecordTypeId();
                database.insert(testAccount);
                
                Account testAccount1 = GA_OBJ_TD01_TestDataCreation.AccRec();
                testAccount1.Name = 'Test Union Acc';
                testAccount1.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Union').getRecordTypeId();
                database.insert(testAccount1);
                
                Contact testcon = GA_OBJ_TD01_TestDataCreation.cntactRec(testAccount.Id);
                testcon.AccountId=testAccount.Id;
                database.insert(testcon);
                
                list<GA_Union_Representation__c> lclUnList = new list<GA_Union_Representation__c>();
                GA_Union_Representation__c lclUnion = new GA_Union_Representation__c();
                lclUnion.Name = 'Test Union';
                lclUnion.GA_Customer_Account__c = testAccount.Id;
                lclUnion.GA_Local_Union_Contact__c = testcon.Id;
                lclUnion.GA_Local_Union__c = testAccount1.Id;
                lclUnion.GA_UnionAccOwner__c = 'xyz@bcbsm.com';
                database.insert(lclUnion);
                String ownrEmail = 'abc@bcbsm.com';
                ownrEmail = lclUnion.GA_UnionOwner__c;
                lclUnion.GA_UnionAccOwner__c =   lclUnion.GA_UnionOwner__c;
                database.update(lclUnion);
                lclUnList.add(lclUnion);
                
                Test.startTest();
                GA_LocalUnionServiceCls.unionReprsntatn(lclUnList);
                Test.stopTest();
                system.assert(lclUnList <> null);
            }
            catch(exception e)
            {
                system.assert(e <> null);
                return;
            }
        }
    }
    /*******************************************************************************************************************************
@Description: beforeInsert() method 
@Name : beforeInsert
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/    
    private static testmethod void beforeInsert(){
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestSysAdm','testsysadm@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr){
            try{
                Account testAccount = GA_OBJ_TD01_TestDataCreation.AccRec();
                testAccount.Name = 'Test Cust Acc';
                testAccount.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Customer').getRecordTypeId();
                database.insert(testAccount);
                
                Account testAccount1 = GA_OBJ_TD01_TestDataCreation.AccRec();
                testAccount1.Name = 'Test Union Acc';
                testAccount1.RecordTypeId=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Union').getRecordTypeId();
                database.insert(testAccount1);
                
                Contact testcon = GA_OBJ_TD01_TestDataCreation.cntactRec(testAccount.Id);
                testcon.AccountId=testAccount.Id;
                database.insert(testcon);
                
                list<GA_Union_Representation__c> lclUnList = new list<GA_Union_Representation__c>();
                GA_Union_Representation__c lclUnion = new GA_Union_Representation__c();
                lclUnion.Name = 'Test Union';
                lclUnion.GA_Customer_Account__c = testAccount.Id;
                lclUnion.GA_Local_Union_Contact__c = testcon.Id;
                lclUnion.GA_UnionAccOwner__c = 'xyz@bcbsm.com';
                lclUnion.GA_Local_Union__c = testAccount1.Id;
                database.insert(lclUnion);
                String ownrEmail = 'abc@bcbsm.com';
                ownrEmail = lclUnion.GA_UnionOwner__c;
                lclUnion.GA_UnionAccOwner__c =   lclUnion.GA_UnionOwner__c;
                database.update(lclUnion);
                lclUnList.add(lclUnion);
                
                Test.startTest();
                GA_LocalUnionTriggerHandler.beforeInsert(lclUnList);
                Test.stopTest();
                system.assert(lclUnList <> null);
            }
            catch(exception e)
            {
                system.assert(e <> null);
                return;
            }
        }
    }
    /*******************************************************************************************************************************
@Description: lclUnionExp() method 
@Name : lclUnionExp
@Param : None
@Return : void
@throws Exception : N/A;
********************************************************************************************************************************/     
    private static testmethod void lclUnionExp(){
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestSysAdm','testsysadm@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr){
            try{
                GA_LocalUnionTriggerHandler.beforeInsert(null);
                list<GA_Union_Representation__c> lclUnList = new list<GA_Union_Representation__c>();
                 lclUnList[0].adderror('Test');
                list<ExceptionLog__c> ermsgLst= new list<ExceptionLog__c> ();
                Test.startTest();
                GA_LocalUnionServiceCls.unionReprsntatn(null);
                Test.stopTest();
                ermsgLst=[select id from ExceptionLog__c limit 1];
                system.assert(ermsgLst.size()>0);
            }
            catch(exception e)
            {
                system.assert(e <> null);
                return;
            }
        }
    }
}