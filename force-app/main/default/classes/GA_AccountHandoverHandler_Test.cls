/*******************************************************************************************************************************
@Author : Dilip Junapala
@Name: GA_AccountHandoverHandler_Test
@CreatedDate: 03 - Jan 2018 
@Description: GA_AccountHandoverHandler_Test class is for GA_AccountHandoverHandler.
@version : 1.0  
********************************************************************************************************************************/
@isTest(seealldata = false)
private class GA_AccountHandoverHandler_Test {
    
    /*******************************************************************************************************************************
@Description        :   insertHanoverRecords() method 
@Name               :   insertEvents
@Param              :   None
@Return             :   void
@throws Exception   :   N/A;
********************************************************************************************************************************/ 
    private static testmethod void insertHanoverRecords()
    {
        List<User> usrLst = New List<User>();
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestJeoRl','testsalesrepmail@bcbsm.com','System Administrator');
        usrLst.add(usr) ;
        User usrRtnSls = GA_OBJ_TD01_TestDataCreation.UsrRec('TestInivitee1', 'test123@bcbsm.com', 'Retention Sales');
        usrLst.add(usrRtnSls);
        User usrNB = GA_OBJ_TD01_TestDataCreation.UsrRec('TestInivitees2', 'test0123@bcbsm.com', 'New Business Sales');
        usrLst.add(usrNB);
        User ust = GA_OBJ_TD01_TestDataCreation.UsrRec('TestInivitees2', 'test0123@bcbsm.com', 'New Business Sales');
        usrLst.add(ust);
        
        Database.insert(usrLst);
        system.runAs(usr)
        {
            String prospectRecType = 'Account - Prospect';
            string customerRecType = 'Account - Customer';
            Id prospectRecTpeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(prospectRecType).getRecordTypeId();
            Id customerRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(customerRecType).getRecordTypeId();
            GA_Territory__c terr =  GA_OBJ_TD01_TestDataCreation.terrtryRec();
            terr.GA_RetentionSalesRepresentative__c = usrRtnSls.id;
            Database.insert(terr);
            List<Account> accList = New List<Account>();
            Account acc = New Account();
            for(integer i =0; i<11; i++){
                account accnt=GA_OBJ_TD01_TestDataCreation.AccRec();
                accnt.GA_System_of_Record__c='SMART';
                accnt.GA_Territory__c = terr.id;
                accnt.GA_Is_Mass_Updating__c = true;
                accList.add(accnt);
            }
            GA_AccountTriggerHandlr.isExecuting = true;
            GA_ACC_AP01_CheckPlatinumStatusOnAgency.isExecuting = true;
            GA_Util_lockRecords.isExecuting = true;
            GA_ACC_AP02_IdentifySalesRepOnAccount.isExecuting = true;
            GA_AccountTriggerHandlr.isBfrInstExecuting = true;
            GA_ACC_updtTBPendDateOnGS.isExecuting = true;
            GA_ACC_UpdateChildContctsOnAccOwnrChange.isExecuting = true;
            GA_ACC_AP04_UpdtCntOnAccLockUnlock.isExecuting = true;
            GA_ACC_AP_UpdtAssmntOwnrMgrChnge.isExecuting = true; 
            GA_AccountBatchToUpdateContactOwner.isInvodedFrmBtch = true;
            GA_ACC_AP_UpdtAssmntOwnrMgrChnge.isExecuting = true;
            Database.insert(accList);
            
            List<AccountTeamMember> actmList = new List<AccountTeamMember>();
            AccountTeamMember accTmMem =new AccountTeamMember();
            for(Account a : accList){
                accTmMem =new AccountTeamMember();
                accTmMem.TeamMemberRole = 'Implementation Manager';
                accTmMem.AccountId = a.id;
                accTmMem.UserId = usrRtnSls.id;
                actmList.add(accTmMem);
                
                accTmMem =new AccountTeamMember();
                accTmMem.TeamMemberRole = 'New Business Sales Consultant';
                accTmMem.AccountId = a.id;
                accTmMem.UserId = usrNB.id;
                actmList.add(accTmMem);
            }
            
            Database.insert(actmList);
            
            GA_ACC_AP05_CreateHandoverRecord.isExecuting = false;
            GA_HandoverBatchForInsertingTasks.isBatchTaskInsert = false;
            List<Account> flippedAccounts = new List<Account>();
            for(Account a : accList){
                a.RecordTypeId = customerRecTypeId;
                a.GA_Is_Mass_Updating__c = true;
                flippedAccounts.add(a);
            }
            
            GA_AccountTriggerHandlr.isExecuting = true;
            GA_ACC_AP01_CheckPlatinumStatusOnAgency.isExecuting = true;
            GA_Util_lockRecords.isExecuting = true;
            GA_AccountTriggerHandlr.isBfrInstExecuting = true;
            GA_ACC_AP02_IdentifySalesRepOnAccount.isExecuting = true;
            GA_ACC_updtTBPendDateOnGS.isExecuting = true;
            GA_ACC_UpdateChildContctsOnAccOwnrChange.isExecuting = true;
            GA_ACC_AP04_UpdtCntOnAccLockUnlock.isExecuting = true;
            GA_ACC_AP_UpdtAssmntOwnrMgrChnge.isExecuting = true; 
            GA_AccountBatchToUpdateContactOwner.isInvodedFrmBtch = true;
            GA_ACC_AP_UpdtAssmntOwnrMgrChnge.isExecuting = true;
            
            Database.update(flippedAccounts);
            
            /**    list<GA_AccountHandOver__c> hrsLst=new list<GA_AccountHandOver__c>();
Account accn = GA_OBJ_TD01_TestDataCreation.AccRec(); 
Database.insert(accn);
for(integer i=0; i<11; i++){
GA_AccountHandOver__c hndOver = GA_OBJ_TD01_TestDataCreation.handoverRec(accn.Id); 
hrsLst.add(hndOver);
}
Database.insert(hrsLst);

test.startTest();
GA_ACH_AP01_CreateHandoverTasks.isExecuting = false;
GA_ACH_AP01_CreateHandoverTasks.createtasks(hrsLst);
test.stopTest();
system.assert(hrsLst <> null); **/
            
            
        } 
    }
    /*******************************************************************************************************************************
@Description        :   sendEmailTest() method 
@Name               :   sendEmailTest
@Param              :   None
@Return             :   void
@throws Exception   :   N/A;
********************************************************************************************************************************/ 
    private static testmethod void sendEmailTest()
    {
        UserRole r = new UserRole(DeveloperName = 'West_Michigan_Support_Representative', Name = 'West Michigan Support Representative');
        insert r;
        
        List<User> usrLst = New List<User>();
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestJeoRl','testsalesrepmail@bcbsm.com','System Administrator');
        usrLst.add(usr) ;
        User usrRtnSls = GA_OBJ_TD01_TestDataCreation.UsrRec('TestInivitee1', 'test123@bcbsm.com', 'Retention Sales');
        usrLst.add(usrRtnSls);
        User usrNB = GA_OBJ_TD01_TestDataCreation.UsrRec('TestInivitee2', 'test0123@bcbsm.com', 'West Michigan Support');
        usrNB.UserRoleId = r.Id;
        usrLst.add(usrNB);
        
        Database.insert(usrLst);
        system.runAs(usr)
        {
            GA_Territory__c terr =  GA_OBJ_TD01_TestDataCreation.terrtryRec();
            terr.GA_RetentionSalesRepresentative__c = usrRtnSls.id;
            Database.insert(terr);
            system.debug('USErnB'+usrNB);
            List<Account> accList = New List<Account>();
            Account acc = New Account();
            account accnt=GA_OBJ_TD01_TestDataCreation.AccRec();
            accnt.GA_Territory__c = terr.id;
            accnt.Account_Services_Representative__c = usrNB.Id;
            accList.add(accnt);
            Database.insert(accList);
            
            test.startTest();
            
            list<GA_AccountHandOver__c> hrsLst=new list<GA_AccountHandOver__c>();
            GA_AccountHandOver__c hndOver = GA_OBJ_TD01_TestDataCreation.handoverRec(accnt.Id); 
            hndOver.Status__c = 'Ready';
            hrsLst.add(hndOver);
            Database.insert(hrsLst);
            
            hndOver.Status__c = 'Transition to Retention Account Manager';
            Database.update(hndOver);
            
            test.stopTest();
        } 
    }
    
}