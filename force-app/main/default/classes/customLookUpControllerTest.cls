@isTest
public class customLookUpControllerTest {
    
    @isTest private static  void customLookUpControllerTestMethod(){
        
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestAgentAdmin','testsalesrepmail@bcbsm.com','Agent Administrator');
        database.insert(usr);
        
        Account acc1 = GA_OBJ_TD01_TestDataCreation.AccRec();
        database.insert(acc1);
        Test.startTest();
        customLookUpController.fetchLookUpValues('Test Acc','Account');    
                Test.stopTest();
    }
}