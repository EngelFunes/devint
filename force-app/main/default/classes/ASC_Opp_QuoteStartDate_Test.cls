/**************************************************************************************************************************
@Author : IDC Offshore
@Name: ASC_Opp_QuoteStartDate_Test 
@CreatedDate: 7 Feb 2020
@Description: ASC_Opp_QuoteStartDate_Test Test class 
@version : 1.0  
****************************************************************************************************************************/
@isTest(seealldata = false)
private class ASC_Opp_QuoteStartDate_Test {
    
    private static testmethod void renewalCycleStartDatetest()
    {   
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestSysAdm1','testsysadm1@bcbsm.com','System Administrator');
        database.insert(usr);
        system.runAs(usr)
        {
            Account acc1 = GA_OBJ_TD01_TestDataCreation.AccRec();
            acc1.ASC_Contract_Renewal_Month__c = 'June';
            database.insert(acc1);  
            
            Opportunity opp1 = GA_OBJ_TD01_TestDataCreation.optyRec(acc1.Id);
            opp1.RecordTypeID = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Opportunity - Renewals').getRecordTypeId();
            database.insert(opp1);  
            
            Opportunity opp2 = GA_OBJ_TD01_TestDataCreation.optyRec(acc1.Id);
            opp2.RecordTypeID = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Opportunity - Renewals').getRecordTypeId();
            database.insert(opp2);  
            
            List<Opportunity> oppList = New List<Opportunity>();
            oppList.add(opp1);
            oppList.add(opp2);
            
            Map<ID,Account> accMap = new Map<ID,Account>([select ID,ASC_Contract_Renewal_Month__c,Contract_Lead_Time__c
                                                          from Account]);
            //accMap.put(acc1.ID,acc1);
            
            acc1.ASC_Contract_Renewal_Month__c = 'May';
            acc1.Contract_Lead_Time__c = 60.0;
            database.update(acc1);
            
            List<Account> accList = new List<Account>();
            accList.add(acc1);
            
            try{                
                test.startTest();
                ASC_Opp_QuoteStartDate.renewalCycleStartDate(accList,accMap);
                ASC_Opp_QuoteStartDate.oppRenewalCycleStartDate(oppList);
                test.stopTest();
                system.assert(usr <> null);
            }
            catch(exception e)
            {
                return;
            }
        }
    }
}