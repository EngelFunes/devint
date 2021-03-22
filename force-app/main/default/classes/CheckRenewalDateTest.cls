@isTest
public class CheckRenewalDateTest {

    @isTest
    private static void testRenewal(){
        
        
        Account acc=GA_OBJ_TD01_TestDataCreation.AccRec();
        acc.GA_Opportunity_Renewal_Date__c = system.today().addMonths(1);
        database.insert(acc);
        
        GA_Group_Segment__c gs = GA_OBJ_TD01_TestDataCreation.grpSegmntRec(acc);
        gs.Name='AMZ000009_AZ02';
        gs.GA_Account__c = acc.id;
        gs.status__c = 'Active';
        gs.GA_Facets_Group_ID__c = 'AMZ00000';
        gs.GA_Rate_Renewal_Date__c = System.today();
        database.insert(gs);
        
        Map<Id,Account> accNewMap = new Map<Id,Account>([select id,GA_Opportunity_Renewal_Date__c from account]);
        Map<Id,Account> accOldMap = new Map<Id,Account>();
        for(Id key : accNewMap.Keyset()){
            account tempAcc = accNewMap.get(key);
            tempAcc.GA_Opportunity_Renewal_Date__c = system.today().addMonths(1);
            accOldMap.put(tempAcc.id,tempAcc);
        }
        
        update accOldMap.values();
        checkRenewalDate.checkRenewalDateWithGS(accNewMap,accOldMap);
        system.assertEquals(true, [select id,Renewal_Month_Variation_in_Groups__c from account].Renewal_Month_Variation_in_Groups__c);
   }
}