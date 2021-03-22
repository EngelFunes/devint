/**
@Author : IDC Offshore
@Name: GA_ACC_BypassRollUpFldsUpdate_Test
@CreatedDate: 8 - June 2018 
@Description: GA_ACC_BypassRollUpFldsUpdate_Test class is for GA_ACC_BypassRollUpFldsUpdate class.
@version : 1.0  
*/ 
@isTest
private class GA_ACC_BypassRollUpFldsUpdate_Test {
    /**
@Description: createGSRec() method 
@Name : createGSRec
@Param : N/A  
@Return : void
@throws Exception : N/A;
*/ 
    private static testMethod void createGSRec()
    {
        Map<id,Account> oldmap = new Map<id,Account>();
        List<Account> accLst = new  List<Account>();
        
        user usr = GA_OBJ_TD01_TestDataCreation.UsrRec('TestCompetitr','testsalesrepmail@bcbsm.com','Small Group Underwriter');
        database.insert(usr);
        Account acc = GA_OBJ_TD01_TestDataCreation.AccRec();
        insert  acc;
        
        oldmap.put(acc.id,acc);
        
        GA_AccountTriggerHandlr.isExecuting = true;
            GA_Group_Segment__c GSRec = GA_OBJ_TD01_TestDataCreation.grpSegmntRec(acc);
            GSRec.Status__c='Active';
            GSRec.Network__c = 'Medicare Advantage';
            GSRec.GA_Account__c = acc.id;
            database.insert(GSRec);
            
          
          accLst = [Select Id,GA_IKA_Count__c,GA_ASC_Count__c,GA_TotalNoOfOpenJeopardies__c,
                    GA_Small_Group_Shop_Count__c, GA_Small_Group_Count__c,
                    GA_NoOfOpportunityCancelled__c,GA_NoOfOpportunities__c ,GA_NASCO_Count__c,
                    GA_GroupSegment_Count__c, GA_Experience_Rated_Count__c,
                    GA_ERS_Count__c, GA_BCN_Count__c, GA_ASC_National_ITS_Count__c 
                    from Account where id =: acc.id];
        system.debug('test oldmap'+oldmap);
       system.debug('test accLst'+accLst);
        system.runAs(usr)
        {
           GA_ACC_BypassRollUpFldsUpdate.bypassRollUpFldsUpdate(accLst,oldmap);
         }
    }
    
    
}