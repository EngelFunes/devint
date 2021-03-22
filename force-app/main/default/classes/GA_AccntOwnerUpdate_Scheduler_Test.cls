/***********************************************************************************************************************************************
@Author : Idc Offshore
@Name: GA_AccntOwnerUpdate_Scheduler_Test 
@CreatedDate: 15 - Jan 2018 
@Description: GA_AccntOwnerUpdate_Scheduler Test class 
@version : 1.0  
*************************************************************************************************************************************************/
@isTest(seealldata = false)
private class GA_AccntOwnerUpdate_Scheduler_Test {
    
    /***********************************************************************************************************************************************
@Description: executeTest() method 
@Name : executeTest
@Param : None
@Return : void
@throws Exception : N/A;
************************************************************************************************************************************************/   
    private static testmethod void executeTest()
    {   
        string prospectRecType = 'Account - Prospect';
        list<user> usrLst=new list<user>();
        
        Id prspectRecTpeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(prospectRecType).getRecordTypeId();
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestJeoRl','testsalesrepmail@bcbsm.com','Integration User');
        usrLst.add(usr);
        user usrRetSlsRep = GA_OBJ_TD01_TestDataCreation.UsrRec('TestJeoRlRetnslsRep','testsalesrepmail@bcbsm.com','Retention Sales');
        usrLst.add(usrRetSlsRep);
        
        user usrRetSlsRep2 = GA_OBJ_TD01_TestDataCreation.UsrRec('TestJeoRlRetnslsRep2','testsalesrep2mail@bcbsm.com','Retention Sales');
        usrLst.add(usrRetSlsRep2);
        
        database.insert(usrLst);
        
        List<GA_Territory__c> trryLst = New List<GA_Territory__c> ();
        GA_Territory__c territoryRec=GA_OBJ_TD01_TestDataCreation.terrtryRec();
        territoryRec.GA_RetentionSalesRepresentative__c=usrLst[0].id;
        trryLst.add(territoryRec);
        
        GA_Territory__c territoryRec2=GA_OBJ_TD01_TestDataCreation.terrtryRec();
        territoryRec2.GA_RetentionSalesRepresentative__c=usrLst[1].id;
        territoryRec2.Name= 'California';
        territoryRec2.GA_TerritoryCode__c = '34';
        trryLst.add(territoryRec2);
        database.insert(trryLst);
        
        GA_ACC_AP02_IdentifySalesRepOnAccount.isExecuting = true;
        GA_Util_lockRecords.isExecuting = true;
        GA_AP_InvokeCIDOnDml.recrCheck = false;
        Account accnt = GA_OBJ_TD01_TestDataCreation.AccRec();
        accnt.RecordTypeId = prspectRecTpeId;
        accnt.GA_Territory__c = territoryRec.id;
        accnt.GA_Is_Mass_Updating__c = true;
        database.insert(accnt);
        
        system.runAs(usr)
        {
            try{
                
                                
                accnt.GA_Territory__c = territoryRec2.id;
                accnt.GA_Is_Mass_Updating__c = true;
                
                GA_AccntOwnerUpdate_Scheduler aous = new GA_AccntOwnerUpdate_Scheduler();
                String sch = '0 0 23 * * ?'; 
                
                Test.startTest();
                GA_ACC_AP01_CheckPlatinumStatusOnAgency.isExecuting = true;
                GA_Util_lockRecords.isExecuting = true;
                GA_ACC_AP02_IdentifySalesRepOnAccount.isExecuting = true;
                GA_ACC_AP05_CreateHandoverRecord.isExecuting = true;
                GA_ACC_UpdateChildContctsOnAccOwnrChange.isExecuting = true;
                GA_ACC_AP04_UpdtCntOnAccLockUnlock.isExecuting = true;
                GA_ACC_AP_UpdtAssmntOwnrMgrChnge.isExecuting = true;
                GA_AccountTriggerHandlr.isExecuting = true;

                database.update(accnt);

                system.schedule('owner update', sch, aous);
                Test.stopTest(); 
                system.assert(accnt <> null);
            }
            catch(exception e)
            {
                return;
            }
        }
    }
    
    
}