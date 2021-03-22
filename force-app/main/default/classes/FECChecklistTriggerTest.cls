@isTest
public class FECChecklistTriggerTest {
    
    @isTest static void testData(){
        Profile michganProfile = [SELECT Id FROM Profile WHERE Name='West Michigan Support']; 
        user michiganUser = GA_OBJ_TD01_TestDataCreation.UsrRec('','westmichigan@bcbsm.com','West Michigan Support');
        insert michiganUser;
        user supportUser = GA_OBJ_TD01_TestDataCreation.UsrRec('','support@bcbsm.com','Support');
        insert supportUser;
        
        
        System.runAs(michiganUser) {
            FEC_Checklist__c fecChecklist = new FEC_Checklist__c();
            fecChecklist.BAAG__c = true;
            insert fecChecklist;
            
        }
        
        System.runAs(supportUser) {
            FEC_Checklist__c fecChecklist = new FEC_Checklist__c();
            fecChecklist.BAAG__c = true;
            insert fecChecklist;
            
        }
    }
}