@isTest
public class OpportunityTriggerHandler_Test 
{
	static testMethod void insertNewOpportunity() 
    {
         user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestGrpSgmtrelatLst','testsystemadminstrator@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {
            try
            {
                    Account acc=GA_OBJ_TD01_TestDataCreation.AccRec();
                	database.insert(acc);
                
                	Account_Plan__c assessment = GA_OBJ_TD01_TestDataCreation.createAssessment(acc);
                    database.insert(assessment);
                
                	Opportunity opty = GA_OBJ_TD01_TestDataCreation.optyRec(acc.Id);
                    opty.RecordTypeId =Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Opportunity_ASC').getRecordTypeId();
                	database.insert(opty);
                
                	Opportunity opty1 = GA_OBJ_TD01_TestDataCreation.optyRec(acc.Id);
                	database.insert(opty1);
                
            }
            catch(exception e)
            {
                return;
            }
        }
    }
}