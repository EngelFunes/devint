/**
@Author : Raj Jena
@Name: GA_LNTG_FetchAlrtMsg 
@CreatedDate: 4 - Oct 2018 
@Description: GA_LNTG_FetchAlrtMsg Test class.
@version : 1.0  
*/
@isTest
private class GA_LNTG_FetchAlrtMsg_Test {
 /**
@Description: AcntAlrtMsg() method 
@Name : AcntAlrtMsg
@Param : N/A
@Return : void
@throws Exception : N/A;
*/   
 private static testmethod void AcntAlrtMsg()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestRetnsnSlsRep','testRetnsnSlsRep@bcbsm.com','Retention Sales');
        database.insert(usr);
        system.runAs(usr)
        {
            try {
                Account acc=GA_OBJ_TD01_TestDataCreation.AccRec();
                database.insert(acc);
                acc.GA_Account_Type__c='POD';
                acc.GA_Alert_Message__c='Alert Messages Text';
                database.update(acc);
                GA_Alert_Messages__c alrtMsg=new GA_Alert_Messages__c();
                alrtMsg.GA_Account__c=acc.Id;
                alrtMsg.GA_End_Date__c=system.today()+1;
                alrtMsg.GA_Start_Date__c=system.today();
                database.insert(alrtMsg);
                Account acc2=GA_OBJ_TD01_TestDataCreation.AccRec();
                database.insert(acc2);
                Case supportCas =GA_OBJ_TD01_TestDataCreation.CaseRec();
                database.insert(supportCas);
                test.startTest();
                list<GA_LNTG_FetchAlrtMsg.msgPosWrapcls> msgLst=GA_LNTG_FetchAlrtMsg.getMsgLst(acc.id, 'Account', 'GA_Account_Type__c');
                GA_LNTG_FetchAlrtMsg.getMsgLst(supportCas.id, 'Case', 'Id');
                test.stopTest();
            }
            catch(exception e)
            {
                return;
            }
        }
    }
 /**
@Description: AcntNoAlrtMsg() method 
@Name : AcntNoAlrtMsg
@Param : N/A
@Return : void
@throws Exception : N/A;
*/    
    private static testmethod void AcntNoAlrtMsg()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestRetnsnSlsRep','testRetnsnSlsRep@bcbsm.com','Retention Sales');
        database.insert(usr);
        system.runAs(usr)
        {
            try {
                Account acc=GA_OBJ_TD01_TestDataCreation.AccRec();
                database.insert(acc);
                acc.GA_Account_Type__c='POD';
                database.update(acc);
                test.startTest();
                list<GA_LNTG_FetchAlrtMsg.msgPosWrapcls> msgLst=GA_LNTG_FetchAlrtMsg.getMsgLst(acc.id, 'Account', 'GA_Account_Type__c');
                //string AcntAlrtMsg = GA_LNTG_FetchAlrtMsg.getAccntMsg(acc.id, 'Account', 'GA_Alert_Message__c,GA_Account_Type__c');
                test.stopTest();
            }
            catch(exception e)
            {
                return;
            }
        }
    }
  /**
@Description: AcntNotPOD() method 
@Name : AcntNotPOD
@Param : N/A
@Return : void
@throws Exception : N/A;
*/    
    private static testmethod void AcntNotPOD()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestRetnsnSlsRep','testRetnsnSlsRep@bcbsm.com','Retention Sales');
        database.insert(usr);
        system.runAs(usr)
        {
            try {
                Account acc=GA_OBJ_TD01_TestDataCreation.AccRec();
                database.insert(acc);
                acc.GA_Account_Type__c='KLA';
                database.update(acc);
                test.startTest();
                list<GA_LNTG_FetchAlrtMsg.msgPosWrapcls> msgLst=GA_LNTG_FetchAlrtMsg.getMsgLst(acc.id, 'Account', 'GA_Account_Type__c');
                //string AcntAlrtMsg = GA_LNTG_FetchAlrtMsg.getAccntMsg(acc.id, 'Account', 'GA_Alert_Message__c,GA_Account_Type__c');
                test.stopTest();
            }
            catch(exception e)
            {
                return;
            }
        }
    }
 /**
@Description: AcntPassingSingleValue() method 
@Name : AcntPassingSingleValue
@Param : N/A
@Return : void
@throws Exception : N/A;
*/    
     private static testmethod void AcntPassingSingleValue()
    {
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestRetnsnSlsRep','testRetnsnSlsRep@bcbsm.com','Retention Sales');
        database.insert(usr);
        system.runAs(usr)
        {
            try {
                Account acc=GA_OBJ_TD01_TestDataCreation.AccRec();
                database.insert(acc);
                test.startTest();
                list<GA_LNTG_FetchAlrtMsg.msgPosWrapcls> msgLst=GA_LNTG_FetchAlrtMsg.getMsgLst(acc.id, 'Account', 'GA_Account_Type__c');
               // string AcntAlrtMsg = GA_LNTG_FetchAlrtMsg.getAccntMsg(acc.id, 'Account', 'GA_Account_Type__c');
                test.stopTest();
            }
            catch(exception e)
            {
                return;
            }
        }
    }
    
    
}