/**
@Author : IDC Offshore
@Name: GA_ACC_AP_UnionVldtnCls_Test
@CreatedDate: 10 Oct 2018
@Description: GA_ACC_AP_UnionVldtnCls_Test class is for GA_ACC_AP_UnionVldtnCls class.
@version : 1.0  
*/ 
@isTest(seealldata=false)
private class GA_ACC_AP_UnionVldtnCls_Test {
    /**
@Description: createGSRec() method 
@Name : createGSRec
@Param : N/A  
@Return : void
@throws Exception : N/A;
*/ 
    private static testMethod void validateUnionRec()
    {
        Account acc = GA_OBJ_TD01_TestDataCreation.AccRec();
        string accRecTypUnion=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account - Union').getRecordTypeId();
        acc.RecordTypeId = accRecTypUnion;
        acc.Union_Code__c ='003';
        // acc.Account_Status__c = 'Active';
        insert acc;
        GA_AccountTriggerHandlr.isExecuting = true;
        Map<id,Account> oldmap = new Map<id,Account>();
        List<Account> accLst = new  List<Account>();
        
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestNBSales','testsalesrepmail@bcbsm.com','Retention Sales');
        insert usr;
        system.runAs(usr){
            try{
                GA_Trigger_Functionality_By_Pass__c tcs =new GA_Trigger_Functionality_By_Pass__c();
                tcs.GA_Account_Union_Validation__c = true;
                tcs.SetupOwnerId=usr.ProfileId;
                insert tcs;
                
                oldmap.put(acc.id,acc);
                
                GA_AccountTriggerHandlr.isExecuting = false;
                
                Account updtAcc = New Account(id=acc.id);
                updtAcc.RecordTypeId = accRecTypUnion;
                updtAcc.Union_Code__c ='004';
                //update updtAcc;
                accLst.add(updtAcc);
                Test.startTest();
                GA_ACC_AP_UnionVldtnCls.showValiderror(accLst, oldmap); 
                Test.stopTest();  
            }
            catch(exception e)
            {
                system.assert(e <> null);
                return;
            }
        }
    }
    /**
@Description: createGSRec() method 
@Name : createGSRec
@Param : N/A  
@Return : void
@throws Exception : N/A;
*/ 
    private static testMethod void errBlck()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestNBSales','testsalesrepmail@bcbsm.com','System Administrator');
        insert usr;
        system.runAs(usr){
            try{
                GA_AccountTriggerHandlr.isExecuting = true;
                Map<id,Account> oldmap = new Map<id,Account>();
                List<Account> accLst = new  List<Account>();           
                Test.startTest();
                GA_ACC_AP_UnionVldtnCls.showValiderror(null, null);
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