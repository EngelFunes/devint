@isTest
public class UpdateReopenedCountOnTest {
    
    static testmethod void UpdateReopenedCountTestMethod1(){
        Testing_Defect__c newDef = new Testing_Defect__c(Status__c = 'New', Subject__c = 'efgh', Detailed_Description__c = 'New Test',Times_Reopened__c=0);
        insert(newDef);
        newDef.Status__c = 'Closed - Expected Behavior';
        newDef.Retest_Status__c = 'Pass';
        newDef.Retesting_Comments__c = 'ABD';
        update newDef;
        
        Testing_Defect__c defAfterInsert = [Select Times_Reopened__c from Testing_Defect__c where Id = :newDef.Id];
        System.assertEquals(0, defAfterInsert.Times_Reopened__c);
    }
    
    static testmethod void UpdateReopenedCountTestMethod2(){
        Testing_Defect__c newDef2 = new Testing_Defect__c(Status__c = 'In Progress', Subject__c = 'efgh', Detailed_Description__c = 'New Test');
        insert(newDef2);
        newDef2.Status__c = 'Re-opened';
        newDef2.Retest_Status__c='Fail';
        newDef2.Retesting_Comments__c = 'XYZ';
        update newDef2;
        
        Testing_Defect__c defAfterInsert = [Select Times_Reopened__c from Testing_Defect__c where Id = :newDef2.Id];
        System.assertEquals(1, defAfterInsert.Times_Reopened__c);
    }
        static testmethod void UpdateReopenedCountTestMethod3(){
        Testing_Defect__c newDef3 = new Testing_Defect__c(Status__c = 'New', Subject__c = 'efgh', Detailed_Description__c = 'New Test');
        insert(newDef3);
        newDef3.Status__c = 'Closed - Resolved';
        newDef3.Retest_Status__c = 'Pass';
        newDef3.Retesting_Comments__c = 'ABD';
        update newDef3;
        newDef3.Status__c = 'Re-Opened - Failed Retest';
        newDef3.Retest_Status__c = 'Fail';
        newDef3.Retesting_Comments__c = 'ABCD';  
        update newDef3;
        
        Testing_Defect__c defAfterInsert = [Select Times_Reopened__c from Testing_Defect__c where Id = :newDef3.Id];
        System.assertEquals(1, defAfterInsert.Times_Reopened__c);
    }

}