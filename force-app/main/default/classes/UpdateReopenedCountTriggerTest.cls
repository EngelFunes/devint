@isTest
public class UpdateReopenedCountTriggerTest {
    
    static testmethod void UpdateReopenedCountTestMethod1(){
        
        Release__c rel = new Release__c();
         rel.Name = 'Test Release ';
         rel.Release__c = 24;
         rel.Plan_Start_Date__c = System.today();
         rel.Release_Planned_End_Date__c= System.today() + 10;
         rel.Status__c = 'Red';
         rel.Description__c = 'Test description ';
         rel.Status_Update__c = 'Test Comments';
         insert rel;
        
        Defect__c newDef = new Defect__c(Status__c = 'Failed Retest', Subject__c = 'efgh', Detailed_Description__c = 'New Test',Times_Reopened__c=0, Release__C = rel.id);
        insert(newDef);
        newDef.Status__c = 'Expected Behaviour';
        update newDef;
    }
    
    static testmethod void UpdateReopenedCountTestMethod2(){
        Release__c rel = new Release__c();
         rel.Name = 'Test Release ';
         rel.Release__c = 24;
         rel.Plan_Start_Date__c = System.today();
         rel.Release_Planned_End_Date__c= System.today() + 10;
         rel.Status__c = 'Red';
         rel.Description__c = 'Test description ';
         rel.Status_Update__c = 'Test Comments';
         insert rel;
        
        Defect__c newDef2 = new Defect__c(Status__c = 'Closed', Subject__c = 'efgh', Detailed_Description__c = 'New Test', Release__C = rel.id);
        insert(newDef2);
        newDef2.Status__c = 'Resolved';
        update newDef2;
    }

    static testmethod void UpdateReopenedCountTestMethod3(){
        Release__c rel = new Release__c();
         rel.Name = 'Test Release ';
         rel.Release__c = 24;
         rel.Plan_Start_Date__c = System.today();
         rel.Release_Planned_End_Date__c= System.today() + 10;
         rel.Status__c = 'Red';
         rel.Description__c = 'Test description ';
         rel.Status_Update__c = 'Test Comments';
         insert rel;
        
        Defect__c newDef2 = new Defect__c(Status__c = 'Fix in Process', Subject__c = 'efgh', Detailed_Description__c = 'New Test', Release__C = rel.id);
        insert(newDef2);
        newDef2.Status__c = 'RE-OPENED';
        //newDef2.Test_Status__c='Pass';
        newDef2.Testing_Comments__c = 'XYZ';
        update newDef2;
    }
}