/**
@Author : Steven Pascaran
@Name: GA_SalesOfficeTriggerHandler_Test 
@CreatedDate: 24 - Jun 2020 
@Description: GA_SalesOfficeTriggerHandler_Test Test class 
@version : 1.0  
*/
@isTest
Private class GA_SalesOfficeTriggerHandler_Test {
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
        database.insert(UsrLst);
        
        RecordType accRecType = [Select Id From RecordType  Where SobjectType = 'Account' and DeveloperName = 'Account_Customer' LIMIT 1];
    	ID recTypeId = accRecType.Id;
        
        system.runAs(usr)
        {
            try{
                Test.startTest();
                
                GA_Region__c regRec = new GA_Region__c();
                regRec.Name = 'Test Region';
                regRec.GA_Region_Code__c = '123';
                database.insert(regRec);
                
                GA_Sales_Office__c salesOffRec= new GA_Sales_Office__c();
                salesOffRec.Name = 'Test Sales Office';
                salesOffRec.GA_Sales_Office_Code__c = '123';
                salesOffRec.GA_Region__c = regRec.id;
                database.insert(salesOffRec);

                GA_Territory__c territoryRec=GA_OBJ_TD01_TestDataCreation.terrtryRec();
                territoryRec.GA_RetentionSalesRepresentative__c=usr.id;
                territoryRec.GA_Sales_Office__c = salesOffRec.id;
                database.insert(territoryRec);
                
                account accnt=GA_OBJ_TD01_TestDataCreation.AccRec();
                accnt.RecordTypeId = recTypeId;
                accnt.GA_Territory__c = territoryRec.id;
                accnt.Account_Status__c = 'Active';
                database.insert(accnt);
                
                salesOffRec.Pharmacy_Team__c = usr.Id;
                database.update(salesOffRec);

                Test.stopTest(); 
            }
            catch(exception e)
            {
                return;
            }
        }  
    }
}