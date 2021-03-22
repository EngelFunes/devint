/***********************************************************************************************************************************************
@Author : Prasant
@Name: GA_AR_AP_UpdtPltinmStatusBatchCls_Test 
@CreatedDate: 24 - Aug 2018 
@Description: GA_AR_AP_UpdtPltinmStatusBatchCls_Test Test class 
@version : 1.0  
*************************************************************************************************************************************************/

@isTest
private class GA_AR_AP_UpdtPltinmStatusBatchCls_Test {
/***********************************************************************************************************************************************
@Description: executeTest() method 
@Name : executeTest
@Param : None
@Return : void
@throws Exception : N/A;
************************************************************************************************************************************************/   
    private static testmethod void executeTest()
    {  
         string agencyRecType = 'Account - Agency';
        Id agencyRecTpeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(agencyRecType).getRecordTypeId();
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestJeoRl','testsalesrepmail@bcbsm.com','Integration User');
        insert usr;
        system.runAs(usr)
        {
            try{
                
                Account agaccnt = GA_OBJ_TD01_TestDataCreation.AccRec();
                agaccnt.RecordTypeId = agencyRecTpeId;
                agaccnt.GA_Platinum__c = true;
                database.insert(agaccnt);
                Account acc=GA_OBJ_TD01_TestDataCreation.AccRec();
                acc.GA_Platinum__c = false;
                database.insert(acc);
                GA_AgencyRelationship__c ar = GA_OBJ_TD01_TestDataCreation.agencyRelationshipRec(acc.Id);
                ar.GA_Account__c = acc.id;
                ar.GA_Agency__c = agaccnt.Id;
                ar.GA_StartDate__c = system.today();
                ar.GA_EndDate__c = system.today()+5; 
                database.insert(ar);
                string qryUpdtePltnm='Select id,GA_Agency__c,GA_Account__c from GA_AgencyRelationship__c where id in:idLst';
                list<id> agencyIds=new list<id>();
                list<GA_AgencyRelationship__c> arList=new list<GA_AgencyRelationship__c>();
                map<id,GA_AgencyRelationship__c> arOldMap=new map<id,GA_AgencyRelationship__c>();
                agencyIds.add(ar.Id);
                arOldMap.put(ar.Id,ar);
                arList.add(ar);
                Test.startTest();
                GA_AR_AP_UpdatePlatinumStatusBatchCls updtePltnumrBatch=new GA_AR_AP_UpdatePlatinumStatusBatchCls(qryUpdtePltnm,agencyIds, arOldMap,arList);
                Database.executeBatch(updtePltnumrBatch,200);  
                Test.stopTest(); 
                system.assert(acc <> null);
            }
            catch(exception e)
            {
                return;
            }
        }
    }
}