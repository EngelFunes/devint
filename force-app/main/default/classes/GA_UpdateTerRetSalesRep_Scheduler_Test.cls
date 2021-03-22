/**
@Author : Steven Pascaran
@Name: GA_UpdateTerRetSalesRep_Scheduler_Test 
@CreatedDate: 25 - Mar 2020 
@Description: GA_UpdateTerRetSalesRep_Scheduler_Test Test class 
@version : 1.0  
*/
@isTest
Private class GA_UpdateTerRetSalesRep_Scheduler_Test {
/**
@Description: executeTest() method 
@Name : executeTest
@Param : None
@Return : void
@throws Exception : N/A;
*/   
    private static testmethod void executeTest()
    {
        list<user> UsrLst=new list<user>();
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestJeoRl','testsalesrepmail@bcbsm.com','Support');
        UsrLst.add(usr);
        user usrRetSlsRep = GA_OBJ_TD01_TestDataCreation.UsrRec('TestJeoRlRetnslsRep','testsalesrepmail@bcbsm.com','Retention Sales');
        UsrLst.add(usrRetSlsRep);
        database.insert(UsrLst);
        system.runAs(usr)
        {
            try{
                Test.startTest();

                GA_Territory__c territoryRec=GA_OBJ_TD01_TestDataCreation.terrtryRec();
                territoryRec.GA_RetentionSalesRepresentative__c=usr.id;
                database.insert(territoryRec);
                
                account accnt=GA_OBJ_TD01_TestDataCreation.AccRec();
                accnt.GA_Territory__c = territoryRec.id;
                database.insert(accnt);          

				Retention_Sales_Representative_History__c salesHistoryRec = new Retention_Sales_Representative_History__c();
                salesHistoryRec.Future_Retention_Sales_Representative__c = usrRetSlsRep.id;
                salesHistoryRec.Territory__c = territoryRec.Id;
                salesHistoryRec.Override_Past_Date__c = false;
                salesHistoryRec.Future_Effective_Rep_Date__c = System.today();
                database.insert(salesHistoryRec);
                
                GA_UpdateTerRetSalesRepBatch btch = new GA_UpdateTerRetSalesRepBatch ();
        		database.executeBatch(btch, 2000);
                
                GA_UpdateTerRetSalesRep_Scheduler sh1 = new GA_UpdateTerRetSalesRep_Scheduler();
                String sch = '0 0 23 * * ?'; 
                system.schedule('Test Update Territory Sales Rep', sch, sh1); 
                Test.stopTest(); 
            }
            catch(exception e)
            {
                return;
            }
        }  
    }
}