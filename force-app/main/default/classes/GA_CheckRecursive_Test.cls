/**
@Author : IDC offshore
@Name: GA_CheckRecursive_Test 
@CreatedDate: 01 - May 2019 
@Description: GA_CheckRecursive_Test Test class 
@version : 1.0  
*/
@isTest(seeAllData=false)
private class GA_CheckRecursive_Test {
 /**
@Description: checkRecursive() method 
@Name : checkRecursive
@Param : None
@Return : void
@throws Exception : N/A;
*/     
private static testMethod void checkRecursive(){
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestCompetitr','testsalesrepmail@bcbsm.com','Retention Sales');
        database.insert(usr);
        system.runAs(usr){      
          GA_CheckRecursive.runOnce(True);   
          GA_CheckRecursive.runOnce(false);   
            System.assert(usr <> null, true);
        }
    }
 /**
@Description: checkfalseRecursive() method 
@Name : checkfalseRecursive
@Param : None
@Return : void
@throws Exception : N/A;
*/     
private static testMethod void checkfalseRecursive(){
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestCompetitr','testsalesrepmail@bcbsm.com','Retention Sales');
        database.insert(usr);
        system.runAs(usr){ 
            GA_CheckRecursive.run = false;
            GA_CheckRecursive.runOnce(true);   
            System.assert(usr <> null, true);
        }
    }   
    
}