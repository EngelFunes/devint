/**
@Author : Eswararao Rajana
@Name: GetRelatedSupportRequestHelperTest
@CreatedDate:  -26 June 2020 
@Description: GetRelatedSupportRequestHelper Test class 
*/
@isTest
public class GetRelatedSupportRequestHelperTest {
    public static testMethod void testGetRelatedSupportRequestHelper(){
        
        Account supportAcc = GA_OBJ_TD01_TestDataCreation.AccRec();
        database.insert(supportAcc);
        
        Test.startTest();
            getRelatedSupportRequestHelper.getRelatedCases(supportAcc.id);
            System.assertEquals('Active',supportAcc.Account_Status__c );
        Test.stopTest();
        
    }
}