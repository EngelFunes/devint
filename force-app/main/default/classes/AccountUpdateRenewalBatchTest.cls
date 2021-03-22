@isTest
public class AccountUpdateRenewalBatchTest {
	@isTest private static  void AccountUpdateRenewalTestMethod(){
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestAgentAdmin','testsalesrepmail@bcbsm.com','Agent Administrator');
        database.insert(usr);
        
        Account acc1 = GA_OBJ_TD01_TestDataCreation.AccRec();
        acc1.Renewal_Month_Variation_in_Groups__c =false;
        acc1.GA_Opportunity_Renewal_Date__c =system.today();
        database.insert(acc1);
        
        GA_Group_Segment__c gsmt = GA_OBJ_TD01_TestDataCreation.grpSegmntRec(acc1);
        gsmt.GA_Rate_Renewal_Date__c =system.today();
        gsmt.Status__c = 'Active';
        database.insert(gsmt);         
       
        Database.executeBatch(new AccountUpdateRenewalBatch (), 200); 
        
    }
}