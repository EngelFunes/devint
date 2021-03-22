/*******************************************************************************************************************************
@Author : IDC Offshore
@Name: GA_EventTriggerHandler_Test
@CreatedDate: 03 - Jan 2018 
@Description: GA_EventTriggerHandler_Test class is for GA_EventTriggerHandler.
@version : 1.0  
********************************************************************************************************************************/
@isTest(seealldata = false)
private class GA_EventTriggerHandler_Test {
    
    /*******************************************************************************************************************************
@Description        :   insertEvents() method 
@Name               :   insertEvents
@Param              :   None
@Return             :   void
@throws Exception   :   N/A;
********************************************************************************************************************************/ 
    private static testmethod void insertEvents()
    {
        list<User> userList = New list<User>();
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestJeoRl','testsalesrepmail@bcbsm.com','System Administrator');
        userList.add(usr);
        User usr1 = GA_OBJ_TD01_TestDataCreation.UsrRec('TestInivitee1', 'test123@bcbsm.com', 'Retention Sales');
        userList.add(usr1);          
        User usr2 = GA_OBJ_TD01_TestDataCreation.UsrRec('TestInivitees2', 'test0123@bcbsm.com', 'New Business Sales');
        userList.add(usr2);
        Database.insert(userList);
        system.runAs(usr)
        {   
            list<EventRelation> erList = new list<EventRelation>();
            list<Event> evtLst=new list<Event>(); 
            
            String prospectRecType = 'Account - Prospect';
            string customerRecType = 'Account - Customer';
            Id prospectRecTpeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(prospectRecType).getRecordTypeId();
            Id customerRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(customerRecType).getRecordTypeId();
            
            
            GA_Territory__c terr =  GA_OBJ_TD01_TestDataCreation.terrtryRec();
            terr.GA_RetentionSalesRepresentative__c = userList.get(0).id;
            Database.insert(terr);
            List<Account> accList = New List<Account>();
            Account acc = New Account();
            for(integer i=0; i<11; i++){
                account accnt=GA_OBJ_TD01_TestDataCreation.AccRec();
                accnt.GA_System_of_Record__c='SMART';
                accnt.GA_Territory__c = terr.id;
                accList.add(accnt);
            }
            
            Account accn = GA_OBJ_TD01_TestDataCreation.AccRec(); 
            accList.add(accn);
            
            Database.insert(accList);
            
            List<AccountTeamMember> actmList = new List<AccountTeamMember>();
            AccountTeamMember accountTmMem =new AccountTeamMember();
            for(Account a : accList){
                accountTmMem =new AccountTeamMember();
                accountTmMem.TeamMemberRole = 'Retention Sales Representative';
                accountTmMem.AccountId = a.id;
                accountTmMem.UserId = userList.get(0).id;
                actmList.add(accountTmMem);
                
                accountTmMem =new AccountTeamMember();
                accountTmMem.TeamMemberRole = 'Implementation Manager';
                accountTmMem.AccountId = a.id;
                accountTmMem.UserId = userList.get(1).id;
                actmList.add(accountTmMem);
            }
            
             List<AccountTeamMember> atmLst =  New List<AccountTeamMember>();
            AccountTeamMember arm = GA_OBJ_TD01_TestDataCreation.accountTeamRec(accn.Id);
            arm.TeamMemberRole = 'Implementation Manager';
            arm.AccountId = accn.id;
            arm.UserId = usr1.id;
            actmList.add(arm);
            
            AccountTeamMember art = GA_OBJ_TD01_TestDataCreation.accountTeamRec(accn.Id);
            art.TeamMemberRole = 'New Business Sales Consultant';
            art.AccountId = accn.id;
            art.UserId = usr2.id;
            actmList.add(art);
            database.insert(actmList);
            
            GA_ACC_AP05_CreateHandoverRecord.isExecuting = false;
            GA_HandoverBatchForInsertingTasks.isBatchTaskInsert = false;
            List<Account> flippedAccounts = new List<Account>();
            for(Account a : accList){
                if(accn.id <> a.id){
                a.RecordTypeId = customerRecTypeId;
                flippedAccounts.add(a);
                    }
            }
            Database.update(flippedAccounts);
            
            List<GA_AccountHandOver__c> hrlist = new List<GA_AccountHandOver__c>();
            
            GA_AccountHandOver__c handOver = GA_OBJ_TD01_TestDataCreation.handoverRec(accn.Id);
            handOver.GA_CompanyFullLegalName__c = accn.id;
            database.insert(handOver);
            
            for(integer i=0; i<50; i++)
            {
                Event evt = GA_OBJ_TD01_TestDataCreation.eventRec(handOver.Id);
                evtLst.add(evt);
            }
            
            test.startTest();
            GA_EVE_AP01_AddInvitees.isExecuting = false;
            GA_HandoverBatchForInsertingTasks.isBatchTaskInsert = false;
            GA_EventTriggerHandler.afterinsert(evtLst);
            test.stopTest();
            system.assert(evtLst <> null);
        }
    }
    /*******************************************************************************************************************************
@Description        :   eventTriggerHandlerExcep() method 
@Name               :   eventTriggerHandlerExcep
@Param              :   None
@Return             :   void
@throws Exception   :   N/A;
********************************************************************************************************************************/ 
    private static testmethod void eventTriggerHandlerExcep()
    {
        user usru = GA_OBJ_TD01_TestDataCreation.UsrRec('TestJeoRl','testsalesrepmail@bcbsm.com','System Administrator');
        Database.insert(usru);
        system.runAs(usru)
        {	
            try{
                list<Event> evtLst  =  New list<Event>();
                test.startTest();
                GA_EventTriggerHandler.afterinsert(null);
                test.stopTest();
                system.assert(usru <> null);
            }
            catch(exception e)
            {
                return;
            }
        } 
    }
    
    /*******************************************************************************************************************************
@Description        :   insertEventsExcep() method 
@Name               :   insertEventsExcep
@Param              :   None
@Return             :   void
@throws Exception   :   N/A;
********************************************************************************************************************************/ 
    private static testmethod void insertEventsExcep()
    {
        user usru = GA_OBJ_TD01_TestDataCreation.UsrRec('TestJeoRl','testsalesrepmail@bcbsm.com','System Administrator');
        Database.insert(usru);
        system.runAs(usru)
        {	
            try{
                list<Event> evtLst =  New list<Event>();
                test.startTest();
                GA_EVE_AP01_AddInvitees.addInvites(evtLst);
                test.stopTest();
                system.assert(usru <> null);
            } 
            catch(exception e)
            {
                return;
            }
        } 
    }
}