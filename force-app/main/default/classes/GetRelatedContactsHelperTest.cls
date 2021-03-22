/**
@Author : Eswararao Rajana
@Name: GetRelatedSupportRequestHelperTest
@CreatedDate:  -26 June 2020 
@Description: GetRelatedSupportRequestHelper Test class 
*/
@isTest
public class GetRelatedContactsHelperTest {
    public static testMethod void testGetRelatedContactsHelper(){
        
        Account relatedconAcc = GA_OBJ_TD01_TestDataCreation.AccRec();
        database.insert(relatedconAcc);
        
        Test.startTest();
        try {
            getRelatedContactsHelper.getRelatedContacts(relatedconAcc.id);
        } catch (Exception e) {
            System.assert(false, 'Exception ' + e);
        }
        
        Test.stopTest();
        
        
    }
}